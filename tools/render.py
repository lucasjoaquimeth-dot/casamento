"""Renderiza os convites em PNG com Chrome headless para inspecao visual.

Uso:
    python tools/render.py                  # todos os convite_v*.html da raiz
    python tools/render.py arquivo.html     # so um arquivo

Saida: tools/shots/<nome>__desktop.png e <nome>__mobile.png

Obs.: o Chrome headless nao aceita viewport menor que ~491px, entao o shot
mobile e feito dentro de um iframe de 390px (viewport real de celular).
"""
import os
import subprocess
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT = os.path.join(ROOT, 'tools', 'shots')
TMP = os.path.join(OUT, '_tmp')
CHROME = r'C:\Program Files\Google\Chrome\Application\chrome.exe'

DESKTOP = (1280, 1500)
MOBILE = (390, 1320)

IFRAME_PAGE = """<!DOCTYPE html>
<html><head><meta charset="utf-8"><style>
  html,body {{ margin:0; padding:0; background:#555; }}
  iframe {{ display:block; width:{w}px; height:{h}px; border:0; }}
</style></head>
<body><iframe src="{src}"></iframe></body></html>
"""


def file_url(path):
    return 'file:///' + os.path.abspath(path).replace('\\', '/')


def run_chrome(url, out, w, h):
    cmd = [CHROME, '--headless=new', '--disable-gpu', '--hide-scrollbars',
           '--force-device-scale-factor=1', '--virtual-time-budget=6000',
           '--window-size=%d,%d' % (w, h), '--screenshot=%s' % out, url]
    subprocess.run(cmd, capture_output=True, timeout=180)


def crop(raw, out, w, h):
    try:
        from PIL import Image
    except ImportError:
        os.replace(raw, out)
        return
    with Image.open(raw) as im:
        im.crop((0, 0, min(w, im.width), min(h, im.height))).save(out)
    os.remove(raw)


def shot(html, tag):
    os.makedirs(TMP, exist_ok=True)
    name = os.path.splitext(os.path.basename(html))[0]
    out = os.path.join(OUT, '%s__%s.png' % (name, tag))
    if os.path.exists(out):
        os.remove(out)

    if tag == 'mobile':
        w, h = MOBILE
        wrapper = os.path.join(TMP, '_frame_%s.html' % name)
        with open(wrapper, 'w', encoding='utf-8') as fh:
            fh.write(IFRAME_PAGE.format(w=w, h=h, src=file_url(html)))
        raw = os.path.join(TMP, '_raw_%s.png' % name)
        run_chrome(file_url(wrapper), raw, 900, h)
        crop(raw, out, w, h)
    else:
        w, h = DESKTOP
        run_chrome(file_url(html), out, w, h)

    print(('OK  ' if os.path.exists(out) else 'FAIL'), out)


if __name__ == '__main__':
    files = sys.argv[1:] or [
        os.path.join(ROOT, f) for f in sorted(os.listdir(ROOT))
        if f.startswith('convite_v') and f.endswith('.html')
    ]
    for f in files:
        for tag in ('desktop', 'mobile'):
            shot(f, tag)
