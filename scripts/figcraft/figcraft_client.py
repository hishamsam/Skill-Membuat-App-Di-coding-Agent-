"""Helpers for scripting the live FigCraft app over ``figcraft-cli mcp --attach``.

The client speaks one JSON-RPC line per request, reads stdout in a background
thread (so stray notifications never desync a request), drains stderr for error
messages, and fails with ``FigcraftError`` instead of a bare traceback.
"""

import atexit
import json
import os
import queue
import shutil
import socket
import subprocess
import threading
from collections import deque


class FigcraftError(RuntimeError):
    pass


def find_cli():
    env = os.environ.get("FIGCRAFT_CLI")
    if env:
        if not os.path.exists(env):
            raise FigcraftError(f"FIGCRAFT_CLI points at a missing file: {env}")
        return env
    for name in ("figcraft-cli", "figcraft-cli.exe"):
        found = shutil.which(name)
        if found:
            return found
    for path in ("~/.local/bin/figcraft-cli",
                 "/usr/local/bin/figcraft-cli",
                 "/opt/homebrew/bin/figcraft-cli",
                 "/usr/bin/figcraft-cli"):
        full = os.path.expanduser(path)
        if os.path.exists(full):
            return full
    raise FigcraftError(
        "figcraft-cli not found. Install FigCraft, or set "
        "FIGCRAFT_CLI=/full/path/to/figcraft-cli."
    )


def check_live(port):
    try:
        with socket.create_connection(("127.0.0.1", int(port)), timeout=2):
            return
    except OSError:
        raise FigcraftError(
            f"FigCraft live mode is not listening on 127.0.0.1:{port}. Open it first: "
            f"figcraft --control {port} & "
            "(macOS: open -n -a /Applications/FigCraft.app --args --control "
            f"{port})"
        ) from None


class FigcraftClient:
    def __init__(self, port=None, timeout=None, attach=True, cli=None):
        self.port = int(port or os.environ.get("FIGCRAFT_PORT", "7979"))
        self.timeout = float(timeout or os.environ.get("FIGCRAFT_TIMEOUT", "120"))
        self.cli = cli or find_cli()
        if attach:
            check_live(self.port)
            args = [self.cli, "mcp", "--attach", str(self.port),
                    "--timeout", str(int(min(max(self.timeout, 1), 600)))]
        else:
            args = [self.cli, "mcp"]
        self._q = queue.Queue()
        self._stderr = deque(maxlen=40)
        self.req_id = 0
        self.proc = subprocess.Popen(
            args,
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            bufsize=1,
        )
        threading.Thread(target=self._read_stdout, daemon=True).start()
        threading.Thread(target=self._read_stderr, daemon=True).start()
        self.protocol = self._request("initialize", {
            "protocolVersion": "2024-11-05",
            "capabilities": {},
            "clientInfo": {"name": "figcraft_client", "version": "2.0"},
        })
        self._write({"jsonrpc": "2.0", "method": "notifications/initialized"})

    # -- transport ---------------------------------------------------------

    def _read_stdout(self):
        for line in self.proc.stdout:
            line = line.strip()
            if not line:
                continue
            try:
                msg = json.loads(line)
            except ValueError:
                self._stderr.append(line)
                continue
            self._q.put(msg)
        self._q.put(None)

    def _read_stderr(self):
        for line in self.proc.stderr:
            line = line.strip()
            if line:
                self._stderr.append(line)

    def _tail(self):
        return " | ".join(list(self._stderr)[-5:]) or "(none)"

    def _write(self, msg):
        try:
            self.proc.stdin.write(json.dumps(msg) + "\n")
            self.proc.stdin.flush()
        except (BrokenPipeError, OSError) as exc:
            raise FigcraftError(
                f"figcraft-cli stopped accepting input ({exc}). stderr: {self._tail()}"
            ) from None

    def _request(self, method, params, timeout=None):
        self.req_id += 1
        req_id = self.req_id
        self._write({"jsonrpc": "2.0", "id": req_id, "method": method,
                     "params": params})
        limit = self.timeout if timeout is None else timeout
        while True:
            try:
                msg = self._q.get(timeout=limit)
            except queue.Empty:
                raise FigcraftError(
                    f"{method} did not answer within {limit:g}s. "
                    f"stderr: {self._tail()}"
                ) from None
            if msg is None:
                raise FigcraftError(
                    f"figcraft-cli exited (code {self.proc.poll()}). "
                    f"stderr: {self._tail()}"
                )
            if "id" not in msg:
                continue
            if msg["id"] != req_id:
                continue
            if "error" in msg:
                raise FigcraftError(f"RPC error: {msg['error']}")
            return msg.get("result") or {}

    # -- tools -------------------------------------------------------------

    def raw(self, name, args=None):
        return self._request("tools/call", {"name": name, "arguments": args or {}})

    def tool(self, name, args=None):
        result = self.raw(name, args)
        content = result.get("content") or []
        text = "".join(c.get("text") or "" for c in content if isinstance(c, dict))
        if result.get("isError"):
            raise FigcraftError(f"{name} failed: {text or result}")
        if not text:
            return result
        try:
            return json.loads(text)
        except ValueError:
            return text

    _RESET_COMMANDS = {
        "file.new", "file.newBoard", "file.open", "page.add", "page.select",
        "page.delete", "page.duplicate",
    }

    def cmd(self, command_id, **params):
        result = self.tool("run_command", {"command": command_id, "params": params})
        if command_id in self._RESET_COMMANDS:
            reset_layout()
        return result

    def close(self):
        try:
            self.proc.stdin.close()
        except Exception:
            pass
        try:
            self.proc.terminate()
            self.proc.wait(timeout=2)
        except subprocess.TimeoutExpired:
            self.proc.kill()
            try:
                self.proc.wait(timeout=2)
            except Exception:
                pass
        except Exception:
            pass


# Global instance
f = None


def init_client(port=None, headless=False, timeout=None, cli=None):
    global f
    _close_client()
    f = FigcraftClient(port=port, timeout=timeout, attach=not headless, cli=cli)
    return f


def get_client():
    global f
    if f is None:
        init_client()
    return f


def _close_client():
    global f
    if f is not None:
        try:
            f.close()
        finally:
            f = None


atexit.register(_close_client)


# -- nodes ----------------------------------------------------------------

# create_node takes these as top-level arguments; everything else goes in `props`.
_TOP_KEYS = ("x", "y", "width", "height", "name", "text", "path", "points",
             "index", "closed", "select", "document")


def create(node_type, parent=None, **props):
    """Create a layer and return the whole create_node result (id + node)."""
    client = get_client()
    args = {"type": node_type}
    if parent is not None:
        args["parent"] = parent
    nested = props.pop("props", None) or {}
    for key in _TOP_KEYS:
        if key in props:
            args[key] = props.pop(key)
    nested.update(props)
    if nested:
        args["props"] = nested
    result = client.tool("create_node", args)
    if not isinstance(result, dict) or "id" not in result:
        raise FigcraftError(f"create_node returned no id: {result}")
    return result


def node(node_type, parent=None, **props):
    return create(node_type, parent=parent, **props)["id"]


def setp(node_id, **props):
    client = get_client()
    ids = node_id if isinstance(node_id, list) else [node_id]
    return client.tool("set_properties", {"ids": ids, "props": props})


def get(node_id, depth=1):
    client = get_client()
    return client.tool("get_node", {"id": node_id, "depth": depth})


# -- top-level placement ---------------------------------------------------

_cursor_x = None


def reset_layout():
    """Forget the left-to-right placement cursor (next top-level frame at x=0)."""
    global _cursor_x
    _cursor_x = None


def _initial_cursor(client):
    doc = client.tool("inspect_document", {})
    page = next((p for p in doc.get("pages", [])
                 if p.get("id") == doc.get("currentPage")), None)
    right = 0
    for child in (page or {}).get("children") or []:
        bounds = child.get("absoluteBounds") or {}
        right = max(right, bounds.get("x", 0) + bounds.get("width", 0))
    return right + 100 if right else 0


def box(parent=None, name="Frame", layout="vertical", gap=0, padding=0,
        fill=None, stroke=None, strokeWeight=1, radius=0,
        w=None, h=None, sizingH="hug", sizingV="hug",
        node_type="frame", **props):
    """Create an auto-layout or free frame/component.

    Top-level frames (parent=None) are placed left to right automatically so
    mobile and desktop screens never overlap; pass x/y to place one by hand.
    """
    global _cursor_x
    client = get_client()
    p = {
        "name": name,
        "gap": gap,
        "padding": padding,
        "sizingH": sizingH if w is None or sizingH != "hug" else "fixed",
        "sizingV": sizingV if h is None or sizingV != "hug" else "fixed",
    }
    if layout is not None:
        p["layout"] = layout
    if fill is not None:
        if isinstance(fill, list):
            p["fills"] = fill
        else:
            p["fill"] = fill
    if stroke is not None:
        p["stroke"] = stroke
        p["strokeWeight"] = strokeWeight
    if radius:
        p["cornerRadius"] = radius
    p.update(props)

    if parent is None and "x" not in p and "y" not in p:
        if _cursor_x is None:
            _cursor_x = _initial_cursor(client)
        p["x"] = _cursor_x
        p["y"] = 0

    size = {}
    if w is not None:
        size["width"] = w
    if h is not None:
        size["height"] = h

    result = create(node_type, parent=parent, **size, **p)
    node_id = result["id"]
    # create_node ignores layout=None, so free positioning is set afterwards.
    if layout is None:
        setp(node_id, layout=None)
    if parent is None:
        width = (result.get("node") or {}).get("width") or w or 390
        _cursor_x = max(_cursor_x or 0, p.get("x", 0) + width + 100)
    return node_id


def txt(parent, text, size=14, weight="Regular", color="#000000",
        family="Inter", **props):
    p = {
        "text": text,
        "fontSize": size,
        "fontStyle": weight,
        "fontFamily": family,
        "fill": color,
    }
    p.update(props)
    return node("text", parent=parent, **p)


def vector(parent, path, fill=None, stroke=None, strokeWeight=1, w=None,
           h=None, name="Vector", **props):
    p = {
        "name": name,
        "path": path,
    }
    if w is not None:
        p["width"] = w
    if h is not None:
        p["height"] = h
    p["fill"] = fill if fill else None
    if stroke:
        p["stroke"] = stroke
        p["strokeWeight"] = strokeWeight
    p.update(props)
    return node("vector", parent=parent, **p)


def circle(parent, size, fill=None, stroke=None, strokeWeight=1,
           name="Circle", **props):
    p = {
        "name": name,
        "width": size,
        "height": size,
    }
    if fill:
        p["fill"] = fill
    if stroke:
        p["stroke"] = stroke
        p["strokeWeight"] = strokeWeight
    p.update(props)
    return node("ellipse", parent=parent, **p)


def rect(parent, w, h, fill=None, radius=0, stroke=None, strokeWeight=1,
         name="Rect", **props):
    p = {
        "name": name,
        "width": w,
        "height": h,
        "cornerRadius": radius,
    }
    if fill:
        p["fill"] = fill
    if stroke:
        p["stroke"] = stroke
        p["strokeWeight"] = strokeWeight
    p.update(props)
    return node("rectangle", parent=parent, **p)


# -- output ----------------------------------------------------------------

def _ids(value):
    return list(value) if isinstance(value, (list, tuple)) else [value]


def screenshot(ids=None):
    client = get_client()
    args = {}
    if ids is not None:
        args["ids"] = _ids(ids)
    return client.raw("screenshot", args)


def export_node(ids, path, scale=2):
    client = get_client()
    abs_path = os.path.abspath(path)
    os.makedirs(os.path.dirname(abs_path), exist_ok=True)
    return client.tool("export", {"ids": _ids(ids), "path": abs_path,
                                  "scale": scale})


# -- document and pages ----------------------------------------------------

def new_document(name="Untitled"):
    """Start a clean document so a rerun never duplicates layers."""
    client = get_client()
    result = client.cmd("file.new", name=name)
    reset_layout()
    return result


def use_page(name="UI", background=None):
    """Rename the empty starting page (or add one) and make it current."""
    client = get_client()
    pages = client.cmd("page.list") or []
    current = next((p for p in pages if p.get("current")), None)
    if current and current.get("children", 0) == 0:
        client.cmd("page.rename", id=current["id"], name=name)
        page_id = current["id"]
    else:
        empty = next((p for p in pages
                      if p.get("name") == name and p.get("children", 0) == 0), None)
        page_id = empty["id"] if empty else client.cmd("page.add", name=name)["id"]
    client.cmd("page.select", id=page_id)
    if background:
        client.cmd("page.setBackground", id=page_id, color=background)
    reset_layout()
    return page_id
