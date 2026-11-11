#!/usr/bin/env python3
"""Build GUIDE.html from GUIDE.md.

Usage: python3 scripts/build-guide-html.py
"""

import html
import re
from pathlib import Path

try:
    import markdown
except ModuleNotFoundError:
    raise SystemExit("The 'markdown' module is required: python3 -m pip install markdown")

ROOT = Path(__file__).resolve().parent.parent
SRC = ROOT / "GUIDE.md"
OUT = ROOT / "GUIDE.html"

MD_EXT = ["tables", "fenced_code", "toc", "sane_lists", "attr_list"]


def strip_first_h1(text: str) -> str:
    return re.sub(r"^# .*\n", "", text, count=1, flags=re.M)


def add_anchors(body: str) -> str:
    def repl(m):
        tag, ident, inner = m.group(1), m.group(2), m.group(3)
        return (
            f'<{tag} id="{ident}">{inner}'
            f'<a class="anchor" href="#{ident}" aria-label="Link to this section">#</a>'
            f"</{tag}>"
        )

    return re.sub(r"<(h[23]) id=\"([^\"]+)\">(.*?)</\1>", repl, body, flags=re.S)


def task_lists(body: str) -> str:
    body = body.replace("<li>[ ] ", '<li class="task"><input type="checkbox" disabled> ')
    body = body.replace("<li>[x] ", '<li class="task"><input type="checkbox" checked disabled> ')
    body = body.replace("<li>[X] ", '<li class="task"><input type="checkbox" checked disabled> ')
    return body


def build_toc(body: str) -> str:
    items = []
    for m in re.finditer(r"<(h[23]) id=\"([^\"]+)\">(.*?)</\1>", body, flags=re.S):
        level, ident, inner = m.group(1), m.group(2), m.group(3)
        inner = re.sub(r'<a class="anchor".*?</a>', "", inner, flags=re.S)
        label = html.unescape(re.sub(r"<[^>]+>", "", inner)).strip()
        if level == "h2":
            items.append(
                f'<a class="toc-link toc-h2" href="#{ident}" data-label="{html.escape(label.lower())}">{html.escape(label)}</a>'
            )
        else:
            items.append(
                f'<a class="toc-link toc-h3" href="#{ident}" data-label="{html.escape(label.lower())}">{html.escape(label)}</a>'
            )
    return "\n".join(items)


def section(md_text: str) -> tuple[str, str]:
    body = markdown.markdown(strip_first_h1(md_text), extensions=MD_EXT)
    body = task_lists(body)
    body = add_anchors(body)
    return body, build_toc(body)


CSS = r"""
:root{
  --ink:#17211c; --muted:#5b665f; --line:#e2e5dd; --surface:#ffffff;
  --canvas:#f5f6f2; --accent:#0f6b4f; --accent-soft:#e7f1ec;
  --code-bg:#f2f4ef; --topbar:64px; --sidebar:300px;
  --font:ui-sans-serif,system-ui,-apple-system,"Segoe UI",Roboto,"Helvetica Neue",Arial,sans-serif;
  --mono:ui-monospace,SFMono-Regular,Menlo,Consolas,"Liberation Mono",monospace;
}
*{box-sizing:border-box}
html{scroll-behavior:smooth;scroll-padding-top:calc(var(--topbar) + 18px)}
body{margin:0;background:var(--canvas);color:var(--ink);font-family:var(--font);line-height:1.65;-webkit-font-smoothing:antialiased}
a{color:var(--accent);text-decoration:none}
a:hover{text-decoration:underline}
.skip{position:absolute;left:-9999px;top:0;background:var(--ink);color:#fff;padding:10px 14px;z-index:100}
.skip:focus{left:12px;top:12px;border-radius:8px}
.topbar{position:sticky;top:0;z-index:50;height:var(--topbar);background:rgba(255,255,255,.94);backdrop-filter:blur(8px);border-bottom:1px solid var(--line);display:flex;align-items:center;gap:14px;padding:0 20px}
.brand{font-weight:700;font-size:15px;color:var(--ink);white-space:nowrap}
.brand span{font-weight:500;color:var(--muted)}
.icon-btn{display:none;width:40px;height:40px;border:1px solid var(--line);border-radius:10px;background:#fff;color:var(--ink);font-size:18px;cursor:pointer}
.search{margin-left:auto;position:relative}
.search input{width:260px;max-width:38vw;height:40px;border:1px solid var(--line);border-radius:10px;background:#fff;padding:0 12px 0 34px;font:inherit;font-size:14px;color:var(--ink);outline:none}
.search input:focus{border-color:var(--accent);box-shadow:0 0 0 3px rgba(15,107,79,.14)}
.search svg{position:absolute;left:11px;top:11px;width:18px;height:18px;opacity:.55}
.progress{position:absolute;left:0;right:0;bottom:-1px;height:2px;background:transparent}
.progress span{display:block;height:100%;width:0;background:var(--accent)}
.layout{display:flex;align-items:flex-start}
.sidebar{position:sticky;top:var(--topbar);width:var(--sidebar);flex:0 0 var(--sidebar);height:calc(100vh - var(--topbar));overflow-y:auto;padding:22px 16px 60px;border-right:1px solid var(--line);background:#fbfcf9}
.sidebar h2{font-size:11px;letter-spacing:.08em;text-transform:uppercase;color:var(--muted);margin:4px 10px 10px}
.toc-link{display:block;padding:7px 10px;border-radius:8px;color:#36423b;font-size:13.5px;line-height:1.35;border-left:2px solid transparent}
.toc-link:hover{background:var(--accent-soft);text-decoration:none;color:var(--accent)}
.toc-link.active{background:var(--accent-soft);color:var(--accent);font-weight:600;border-left-color:var(--accent)}
.toc-h3{padding-left:22px;font-size:12.8px;color:var(--muted)}
.no-result{display:none;padding:10px;color:var(--muted);font-size:13px}
.main{flex:1;min-width:0;padding:38px 40px 100px}
.doc{max-width:940px;margin:0 auto}
.doc-head{padding-bottom:22px;border-bottom:1px solid var(--line);margin-bottom:26px}
.doc-head h1{font-size:clamp(28px,4vw,42px);line-height:1.15;margin:0 0 10px;letter-spacing:-.02em}
.doc-head p{margin:0;color:var(--muted);font-size:16px;max-width:68ch}
.content h2{font-size:clamp(22px,2.6vw,29px);line-height:1.25;margin:46px 0 14px;padding-top:6px;letter-spacing:-.01em}
.content h3{font-size:18px;margin:30px 0 10px}
.content h4{font-size:15px;margin:22px 0 8px}
.content p{margin:0 0 14px;max-width:78ch}
.content ul,.content ol{margin:0 0 16px;padding-left:24px}
.content li{margin:5px 0}
.content li>p{margin:0}
.content strong{font-weight:650}
.content hr{border:0;border-top:1px solid var(--line);margin:40px 0}
.content blockquote{margin:18px 0;padding:14px 18px;border-left:3px solid var(--accent);background:var(--accent-soft);border-radius:0 10px 10px 0;color:#22372c}
.content blockquote p:last-child{margin:0}
.anchor{margin-left:8px;color:var(--muted);font-weight:400;opacity:0;font-size:.7em;text-decoration:none}
h2:hover .anchor,h3:hover .anchor,.anchor:focus{opacity:1}
.content code{font-family:var(--mono);font-size:.88em;background:var(--code-bg);border:1px solid var(--line);border-radius:5px;padding:1px 5px}
.content pre{position:relative;margin:0 0 18px;background:#1c2620;color:#e8f0ea;border-radius:12px;padding:18px 18px 16px;overflow:auto;font-size:13.5px;line-height:1.6}
.content pre code{background:none;border:0;padding:0;color:inherit;font-size:inherit}
.copy{position:absolute;top:8px;right:8px;border:1px solid rgba(255,255,255,.22);background:rgba(255,255,255,.08);color:#e8f0ea;border-radius:7px;font:inherit;font-size:11px;padding:4px 9px;cursor:pointer;opacity:0;transition:opacity .15s}
pre:hover .copy,.copy:focus{opacity:1}
.copy.done{background:var(--accent);border-color:var(--accent)}
.table-wrap{overflow-x:auto;margin:0 0 20px;border:1px solid var(--line);border-radius:12px;background:#fff}
table{border-collapse:collapse;width:100%;min-width:520px;font-size:14px}
th,td{text-align:left;padding:10px 13px;border-bottom:1px solid var(--line);vertical-align:top}
th{background:#f4f6f0;font-weight:650;white-space:nowrap}
tr:last-child td{border-bottom:0}
tbody tr:hover{background:#fafbf8}
.content input[type=checkbox]{width:16px;height:16px;accent-color:var(--accent);margin-right:6px;vertical-align:-2px}
.footer{max-width:940px;margin:60px auto 0;padding-top:18px;border-top:1px solid var(--line);color:var(--muted);font-size:13px;display:flex;gap:16px;flex-wrap:wrap}
.overlay{display:none;position:fixed;inset:var(--topbar) 0 0;background:rgba(20,30,24,.35);z-index:35}
body.nav-open .overlay{display:block}
@media(max-width:1024px){
  .icon-btn{display:inline-flex;align-items:center;justify-content:center}
  .search input{width:180px}
  .sidebar{position:fixed;left:0;top:var(--topbar);bottom:0;z-index:40;transform:translateX(-105%);transition:transform .18s ease;box-shadow:0 12px 40px rgba(20,30,24,.18)}
  body.nav-open .sidebar{transform:none}
  .main{padding:28px 20px 80px}
}
@media(max-width:640px){
  .brand span{display:none}
  .search{flex:1;margin-left:0}
  .search input{width:100%;max-width:none}
  .topbar{gap:9px;padding:0 12px}
  .content pre{font-size:12.5px}
}
@media(max-width:540px){
  .brand{display:none}
}
@media print{
  .topbar,.sidebar,.overlay,.copy{display:none!important}
  .main{padding:0}
  .doc{max-width:none}
  .content pre{background:#f4f6f0;color:#17211c;border:1px solid #ddd}
  .content a{color:inherit}
  body{background:#fff}
}
"""

JS = r"""
(function(){
  var body=document.body;
  var input=document.getElementById('search');
  var links=[].slice.call(document.querySelectorAll('.toc-link'));
  var noResult=document.querySelector('.no-result');
  var bar=document.getElementById('bar');
  var menu=document.getElementById('menu');

  menu.addEventListener('click',function(){
    var open=body.classList.toggle('nav-open');
    menu.setAttribute('aria-expanded',String(open));
  });
  document.getElementById('overlay').addEventListener('click',function(){
    body.classList.remove('nav-open');menu.setAttribute('aria-expanded','false');
  });
  document.addEventListener('keydown',function(e){
    if(e.key==='Escape'){body.classList.remove('nav-open');menu.setAttribute('aria-expanded','false');}
  });
  links.forEach(function(a){
    a.addEventListener('click',function(){
      body.classList.remove('nav-open');menu.setAttribute('aria-expanded','false');
    });
  });

  input.addEventListener('input',function(){
    var q=input.value.trim().toLowerCase();
    var shown=0;
    links.forEach(function(a){
      var hit=!q||a.dataset.label.indexOf(q)>-1;
      a.style.display=hit?'':'none';
      if(hit)shown++;
    });
    noResult.style.display=shown?'none':'block';
  });

  document.querySelectorAll('.content pre').forEach(function(pre){
    var btn=document.createElement('button');
    btn.className='copy';btn.type='button';btn.textContent='Copy';
    btn.addEventListener('click',function(){
      var code=pre.querySelector('code');
      var text=code?code.innerText:pre.innerText;
      if(navigator.clipboard&&navigator.clipboard.writeText){
        navigator.clipboard.writeText(text).then(done);
      }else{
        var ta=document.createElement('textarea');
        ta.value=text;document.body.appendChild(ta);ta.select();
        document.execCommand('copy');ta.remove();done();
      }
      function done(){btn.textContent='Copied';btn.classList.add('done');setTimeout(function(){btn.textContent='Copy';btn.classList.remove('done');},1400);}
    });
    pre.appendChild(btn);
  });

  document.querySelectorAll('.content table').forEach(function(t){
    if(t.parentElement.classList.contains('table-wrap'))return;
    var w=document.createElement('div');w.className='table-wrap';
    t.parentNode.insertBefore(w,t);w.appendChild(t);
  });

  document.querySelectorAll('.content h2,.content h3').forEach(function(h){
    if(!h.id||h.querySelector('.anchor'))return;
    var a=document.createElement('a');
    a.className='anchor';a.href='#'+h.id;a.textContent='#';
    a.setAttribute('aria-label','Link to this section');
    h.appendChild(a);
  });

  var current=null;
  function onScroll(){
    var max=document.documentElement.scrollHeight-window.innerHeight;
    bar.style.width=(max>0?Math.min(100,window.scrollY/max*100):0)+'%';
    if(!links.length)return;
    var best=null;
    links.forEach(function(a){
      var id=a.getAttribute('href').slice(1);
      var h=document.getElementById(id);
      if(h&&h.getBoundingClientRect().top<=140)best=a;
    });
    if(best!==current){
      if(current)current.classList.remove('active');
      current=best;
      if(current)current.classList.add('active');
    }
  }
  window.addEventListener('scroll',onScroll,{passive:true});
  window.addEventListener('resize',onScroll);

  var io;
  if('IntersectionObserver'in window){
    io=new IntersectionObserver(function(entries){
      entries.forEach(function(en){
        if(en.isIntersecting){
          var a=document.querySelector('.toc-link[href="#'+en.target.id+'"]');
          if(a){if(current)current.classList.remove('active');current=a;a.classList.add('active');}
        }
      });
    },{rootMargin:'-90px 0px -70% 0px',threshold:0});
    document.querySelectorAll('.content h2').forEach(function(h){io.observe(h);});
  }
  onScroll();
})();
"""


def main() -> None:
    src = SRC.read_text(encoding="utf-8")
    body, toc = section(src)

    doc = f"""<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="Complete WebApp Builder usage guide: PRD, UI Design (Lampiran Images), responsive code, local testing, handoff.">
<title>Usage Guide — WebApp Builder</title>
<style>{CSS}</style>
</head>
<body>
<a class="skip" href="#main">Skip to content</a>
<header class="topbar">
  <button class="icon-btn" id="menu" aria-label="Open menu" aria-expanded="false" aria-controls="sidebar">☰</button>
  <a class="brand" href="#main">WebApp Builder <span>· Guide</span></a>
  <div class="search">
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><circle cx="11" cy="11" r="7"></circle><path d="m20 20-3.5-3.5"></path></svg>
    <input id="search" type="search" placeholder="Search sections…" aria-label="Search sections">
  </div>
  <div class="progress" aria-hidden="true"><span id="bar"></span></div>
</header>
<div class="overlay" id="overlay"></div>
<div class="layout">
  <aside class="sidebar" id="sidebar">
    <h2>Contents</h2>
    <nav aria-label="Contents">{toc}</nav>
    <p class="no-result">No matching sections.</p>
  </aside>
  <main class="main" id="main">
    <div class="doc">
      <header class="doc-head">
        <h1>Complete Usage Guide</h1>
        <p>From a rough idea to a tested, deployed application. Includes PRD, UI Design from attached images, responsive code, local testing, and handoff.</p>
      </header>
      <div class="content">{body}</div>
      <footer class="footer">
        <span>WebApp Builder · 2026</span>
        <a href="GUIDE.md">Source: GUIDE.md</a>
      </footer>
    </div>
  </main>
</div>
<script>{JS}</script>
</body>
</html>
"""
    OUT.write_text(doc, encoding="utf-8")
    print(f"wrote: {OUT.relative_to(ROOT)} ({len(doc):,} characters)")


if __name__ == "__main__":
    main()
