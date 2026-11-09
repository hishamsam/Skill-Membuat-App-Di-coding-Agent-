import subprocess
import json
import os
import sys
import time

class FigcraftClient:
    def __init__(self, port=7979):
        self.port = port
        self.proc = subprocess.Popen(
            ['figcraft-cli', 'mcp', '--attach', str(port)],
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            bufsize=1
        )
        self.req_id = 0
        # Initialize MCP handshake
        self._send({
            'jsonrpc': '2.0',
            'id': self._next_id(),
            'method': 'initialize',
            'params': {
                'protocolVersion': '2024-11-05',
                'capabilities': {},
                'clientInfo': {'name': 'figcraft-fast', 'version': '1.0'}
            }
        })
        self.proc.stdin.write(json.dumps({'jsonrpc': '2.0', 'method': 'notifications/initialized'}) + '\n')
        self.proc.stdin.flush()

    def _next_id(self):
        self.req_id += 1
        return self.req_id

    def _send(self, req):
        line = json.dumps(req)
        self.proc.stdin.write(line + '\n')
        self.proc.stdin.flush()
        res_line = self.proc.stdout.readline()
        if not res_line:
            raise RuntimeError("figcraft-cli process exited or closed connection")
        res = json.loads(res_line)
        if 'error' in res:
            raise RuntimeError(f"RPC error: {res['error']}")
        return res

    def tool(self, name, args=None):
        if args is None:
            args = {}
        res = self._send({
            'jsonrpc': '2.0',
            'id': self._next_id(),
            'method': 'tools/call',
            'params': {
                'name': name,
                'arguments': args
            }
        })
        result = res.get('result', {})
        if result.get('isError'):
            raise RuntimeError(f"Tool error from {name}: {result}")
        content = result.get('content', [])
        if content and content[0].get('type') == 'text':
            try:
                return json.loads(content[0]['text'])
            except Exception:
                return content[0]['text']
        return result

    def cmd(self, command_id, **params):
        return self.tool('run_command', {'command': command_id, 'params': params})

    def close(self):
        try:
            self.proc.terminate()
            self.proc.wait(timeout=2)
        except Exception:
            pass

# Global instance
f = None

def init_client(port=7979):
    global f
    if f is None:
        f = FigcraftClient(port)
    return f

def get_client():
    global f
    if f is None:
        init_client()
    return f

def node(node_type, parent=None, **props):
    client = get_client()
    args = {'type': node_type}
    if parent is not None:
        args['parent'] = parent
    for k in ['x', 'y', 'width', 'height', 'name', 'text', 'path', 'index']:
        if k in props:
            args[k] = props.pop(k)
    if props:
        args['props'] = props
    res = client.tool('create_node', args)
    if isinstance(res, dict) and 'id' in res:
        return res['id']
    return res

def setp(node_id, **props):
    client = get_client()
    ids = node_id if isinstance(node_id, list) else [node_id]
    return client.tool('set_properties', {'ids': ids, 'props': props})

def get(node_id, depth=1):
    client = get_client()
    return client.tool('get_node', {'id': node_id, 'depth': depth})

def box(parent=None, name='Frame', layout='vertical', gap=0, padding=0,
        fill=None, stroke=None, strokeWeight=1, radius=0,
        w=None, h=None, sizingH='hug', sizingV='hug',
        node_type='frame', **props):
    """
    Creates an auto-layout or freely positioned frame/box.
    Handles layout=None gotcha: Figcraft defaults to horizontal layout,
    so we set layout explicitly.
    """
    p = {
        'name': name,
        'gap': gap,
        'padding': padding,
        'sizingH': sizingH if w is None or sizingH != 'hug' else 'fixed',
        'sizingV': sizingV if h is None or sizingV != 'hug' else 'fixed',
    }
    if layout is not None:
        p['layout'] = layout
    if fill is not None:
        if isinstance(fill, list):
            p['fills'] = fill
        else:
            p['fill'] = fill
    if stroke is not None:
        p['stroke'] = stroke
        p['strokeWeight'] = strokeWeight
    if radius:
        p['cornerRadius'] = radius
    p.update(props)

    created_id = node(node_type, parent=parent, width=w or 100, height=h or 100, **p)
    if layout is None:
        setp(created_id, layout=None)
    if w is not None:
        setp(created_id, width=w)
    if h is not None:
        setp(created_id, height=h)
    return created_id

def txt(parent, text, size=14, weight='Regular', color='#000000', family='Inter', **props):
    p = {
        'text': text,
        'fontSize': size,
        'fontStyle': weight,
        'fontFamily': family,
        'fill': color,
    }
    p.update(props)
    return node('text', parent=parent, **p)

def vector(parent, path, fill=None, stroke=None, strokeWeight=1, w=None, h=None, name='Vector', **props):
    p = {
        'name': name,
        'path': path,
    }
    if w is not None:
        p['width'] = w
    if h is not None:
        p['height'] = h
    if fill:
        p['fill'] = fill
    else:
        p['fill'] = None
    if stroke:
        p['stroke'] = stroke
        p['strokeWeight'] = strokeWeight
    p.update(props)
    return node('vector', parent=parent, **p)

def circle(parent, size, fill=None, stroke=None, strokeWeight=1, name='Circle', **props):
    p = {
        'name': name,
        'width': size,
        'height': size,
    }
    if fill:
        p['fill'] = fill
    if stroke:
        p['stroke'] = stroke
        p['strokeWeight'] = strokeWeight
    p.update(props)
    return node('ellipse', parent=parent, **p)

def rect(parent, w, h, fill=None, radius=0, stroke=None, strokeWeight=1, name='Rect', **props):
    p = {
        'name': name,
        'width': w,
        'height': h,
        'cornerRadius': radius,
    }
    if fill:
        p['fill'] = fill
    if stroke:
        p['stroke'] = stroke
        p['strokeWeight'] = strokeWeight
    p.update(props)
    return node('rectangle', parent=parent, **p)

def screenshot(path=None, ids=None):
    client = get_client()
    args = {}
    if ids:
        args['ids'] = ids
    res = client.tool('screenshot', args)
    return res

def export_node(ids, path, scale=2):
    client = get_client()
    abs_path = os.path.abspath(path)
    os.makedirs(os.path.dirname(abs_path), exist_ok=True)
    return client.tool('export', {'ids': ids if isinstance(ids, list) else [ids], 'path': abs_path, 'scale': scale})
