# -*- coding: utf-8 -*-
"""Gera os 4 convites (HTML autocontido, imagens embutidas em base64).

Uso: python tools/build.py
Saida: convite_v1_aquarela.html ... convite_v4_noturno.html na raiz.
"""
import base64
import os

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
BUILD = os.path.join(ROOT, 'assets', 'build')


def data_uri(name, mime):
    with open(os.path.join(BUILD, name), 'rb') as fh:
        return 'data:%s;base64,%s' % (mime, base64.b64encode(fh.read()).decode())


FLOR = data_uri('flor_spray.png', 'image/png')
CANTO = data_uri('flor_canto.png', 'image/png')
FUNDO = data_uri('fundo.jpg', 'image/jpeg')

SVG = {
    'rsvp': '<path d="M9 11l3 3L22 4"/><path d="M21 12v7a2 2 0 01-2 2H5a2 2 0 01-2-2V5a2 2 0 012-2h11"/>',
    'local': '<path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7z"/><circle cx="12" cy="9" r="2.5"/>',
    'gift': '<polyline points="20 12 20 22 4 22 4 12"/><rect x="2" y="7" width="20" height="5"/><line x1="12" y1="22" x2="12" y2="7"/><path d="M12 7H7.5a2.5 2.5 0 010-5C11 2 12 7 12 7z"/><path d="M12 7h4.5a2.5 2.5 0 000-5C13 2 12 7 12 7z"/>',
    'site': '<circle cx="12" cy="12" r="10"/><line x1="2" y1="12" x2="22" y2="12"/><path d="M12 2a15.3 15.3 0 014 10 15.3 15.3 0 01-4 10 15.3 15.3 0 01-4-10 15.3 15.3 0 014-10z"/>',
}

LINKS = [
    ('#confirmar', 'rsvp', 'Confirmar<br>Presen\u00e7a'),
    ('#local', 'local', 'Local'),
    ('#presentes', 'gift', 'Lista de<br>Presentes'),
    ('#site', 'site', 'Site'),
]


def links_html():
    out = []
    for href, icon, label in LINKS:
        out.append(
            '        <a class="link" href="%s">'
            '<span class="link-icon"><svg viewBox="0 0 24 24" fill="none" '
            'stroke="currentColor" stroke-width="1.6" stroke-linecap="round" '
            'stroke-linejoin="round">%s</svg></span>'
            '<span class="link-label">%s</span></a>' % (href, SVG[icon], label)
        )
    return '\n'.join(out)


BASE_CSS = """
  *,*::before,*::after { margin:0; padding:0; box-sizing:border-box; }
  html { -webkit-text-size-adjust:100%; }
  body {
    min-height:100vh; background:var(--bg-page);
    display:flex; align-items:center; justify-content:center;
    padding:28px 16px; font-family:var(--font-body);
    color:var(--ink); -webkit-font-smoothing:antialiased;
  }
  .backdrop { position:fixed; inset:0; z-index:0; overflow:hidden; }
  .backdrop img { width:100%; height:100%; object-fit:cover; filter:var(--bg-filter); }
  .backdrop::after { content:''; position:absolute; inset:0; background:var(--bg-veil); }

  .card {
    position:relative; z-index:1; isolation:isolate;
    width:100%; max-width:var(--card-w);
    background:var(--card-bg);
    border:1px solid var(--card-border);
    box-shadow:var(--card-shadow);
    overflow:hidden;
    padding:var(--pad-top) var(--pad-x) var(--pad-bottom);
    text-align:center;
  }

  /* ---- moldura floral: apenas 2 cantos opostos, sempre ATRAS do conteudo ---- */
  .floral { position:absolute; z-index:0; pointer-events:none; user-select:none; }
  .floral img { display:block; width:100%; height:auto; filter:var(--flor-filter); }
  .floral--tl {
    top:var(--flor-top); left:calc(-1 * var(--flor-bleed)); width:var(--flor-w);
  }
  .floral--br {
    bottom:var(--flor-bottom); right:calc(-1 * var(--flor-bleed));
    width:var(--flor-w-b); transform:scale(-1);
  }
  .floral--tl img { opacity:var(--flor-op); }
  .floral--br img { opacity:var(--flor-op-b); }

  .content {
    position:relative; z-index:3;
    display:flex; flex-direction:column; align-items:center;
  }
  /* veu suave logo atras do texto: mantem os florais visiveis nos cantos,
     mas impede que os desenhos passem "por cima" da leitura */
  .content::before {
    content:''; position:absolute; z-index:-1;
    inset:calc(-1 * var(--pad-top) + var(--veil-y)) calc(-1 * var(--pad-x) + var(--veil-x))
          calc(-1 * var(--pad-bottom) + var(--veil-y));
    background:var(--content-veil); pointer-events:none;
  }

  .eyebrow {
    font-size:clamp(15px,3.8vw,19px); font-weight:700;
    letter-spacing:.38em; text-transform:uppercase;
    color:var(--accent-strong);
  }
  .names { display:flex; flex-direction:column; align-items:center; }
  .name {
    font-family:var(--font-name); color:var(--name-color);
    font-size:var(--name-size); line-height:var(--name-lh);
    font-weight:var(--name-weight); font-style:var(--name-style);
    letter-spacing:var(--name-spacing);
    text-shadow:var(--name-shadow);
  }
  .amp {
    font-family:var(--font-name); color:var(--accent-strong);
    font-size:clamp(40px,9vw,58px); font-style:var(--name-style); line-height:1;
    margin:2px 0 4px;
  }
  .rule { display:flex; align-items:center; justify-content:center; gap:12px; width:min(320px,84%); }
  .rule::before, .rule::after { content:''; flex:1; height:1px; background:var(--rule-grad); }
  .rule span { font-size:16px; color:var(--accent-strong); line-height:1; }

  .kicker {
    font-family:var(--font-accent); font-size:clamp(22px,5.4vw,29px);
    font-style:italic; font-weight:600; color:var(--ink-soft); letter-spacing:.02em;
  }
  .verse {
    font-family:var(--font-accent); font-style:italic; font-weight:600;
    font-size:clamp(22px,5.2vw,27px); line-height:1.62;
    color:var(--ink-soft); max-width:440px;
  }
  .verse-ref {
    display:inline-block; margin-top:8px;
    font-family:var(--font-body); font-style:normal; font-weight:700;
    font-size:clamp(13px,3.4vw,16px); letter-spacing:.24em; text-transform:uppercase;
    color:var(--accent-strong);
  }

  .date-day {
    font-family:var(--font-display); color:var(--name-color);
    font-size:clamp(84px,20vw,124px); line-height:1; font-weight:var(--name-weight);
  }
  .date-text {
    font-size:clamp(19px,4.6vw,24px); font-weight:700;
    letter-spacing:.24em; text-transform:uppercase; color:var(--accent-strong);
  }
  .meta {
    font-size:clamp(17px,4.4vw,21px); font-weight:600; letter-spacing:.05em;
    color:var(--ink); line-height:1.7;
  }
  .meta-label {
    font-size:clamp(13px,3.5vw,17px); font-weight:700; letter-spacing:.3em;
    text-transform:uppercase; color:var(--accent-strong);
  }

  .links { display:grid; grid-template-columns:repeat(2,minmax(0,1fr)); gap:13px; width:100%; align-items:stretch; }
  .link {
    display:flex; align-items:center; gap:12px; padding:15px 16px; min-height:70px;
    text-decoration:none; color:var(--accent-strong);
    background:var(--chip-bg); border:1px solid var(--chip-border);
    border-radius:var(--chip-radius); transition:.25s ease;
  }
  .link:hover { background:var(--chip-bg-hover); border-color:var(--accent-strong); transform:translateY(-2px); }
  .link-icon { display:grid; place-items:center; width:30px; height:30px; flex:0 0 30px; }
  .link-icon svg { width:23px; height:23px; }
  .link-label {
    font-size:clamp(14px,3.7vw,17px); font-weight:700; letter-spacing:.1em;
    text-transform:uppercase; text-align:left; line-height:1.3;
  }

  @media (max-width:560px) {
    body { padding:12px 8px; }
    .card {
      --pad-x:20px;
      --pad-top:104px;
      --pad-bottom:96px;
      --name-size:clamp(52px,15vw,68px);
      --flor-w:154px;
      --flor-w-b:140px;
      --flor-bleed:34px;
      --flor-top:-18px;
      --flor-bottom:-22px;
      --veil-x:6px;
      --veil-y:22px;
    }
    .verse, .kicker { max-width:100%; }
    .meta { letter-spacing:.01em; font-size:clamp(16px,4.1vw,19px); }
    .links { gap:9px; }
    .link { padding:12px 11px; min-height:64px; gap:9px; }
    .link-icon { width:25px; height:25px; flex:0 0 25px; }
    .link-icon svg { width:19px; height:19px; }
    .date-wrap, .date-panel, .date-glow { padding-left:16px; padding-right:16px; }
    .gold-frame { inset:10px; }
  }
"""


PAGE = """<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>{title}</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="{fonts}" rel="stylesheet">
<style>
:root {{
{tokens}
}}
{base}
{extra}
</style>
</head>
<body>
  <div class="backdrop"><img src="{fundo}" alt=""></div>

  <main class="card">
    <div class="floral floral--tl"><img src="{canto}" alt=""></div>
    <div class="floral floral--br"><img src="{canto}" alt=""></div>
{frame}
    <div class="content">
{content}
      <div class="links">
{links}
      </div>
    </div>
  </main>
</body>
</html>
"""


def tokens(d):
    return '\n'.join('  --%s: %s;' % (k, v) for k, v in d.items())


COMMON_TOKENS = {
    'card-w': '600px',
    'pad-x': '48px',
    'pad-top': '116px',
    'pad-bottom': '108px',
    'flor-top': '-26px',
    'flor-bottom': '-30px',
    'flor-bleed': '58px',
    'flor-w': '212px',
    'flor-w-b': '196px',
    'flor-op': '.92',
    'flor-op-b': '.86',
    'flor-filter': 'none',
    'bg-filter': 'none',
    'chip-radius': '2px',
    'content-veil': 'none',
    'veil-x': '8px',
    'veil-y': '30px',
    'font-name': "var(--font-display)",
    'name-size': 'clamp(66px,13.5vw,116px)',
    'name-lh': '1.02',
}


def build(name, title, fonts, tok, content, extra='', frame=''):
    merged = dict(COMMON_TOKENS)
    merged.update(tok)
    html = PAGE.format(
        title=title, fonts=fonts, tokens=tokens(merged), base=BASE_CSS,
        extra=extra, fundo=FUNDO, canto=CANTO, frame=frame,
        content=content, links=links_html(),
    )
    path = os.path.join(ROOT, name)
    with open(path, 'w', encoding='utf-8') as fh:
        fh.write(html)
    print('%-28s %9s bytes' % (name, format(os.path.getsize(path), ',')))


# ------------------------------------------------------------------ V1
V1_CONTENT = """      <span class="monogram">M &middot; L</span>
      <p class="eyebrow" style="margin-top:16px">Voc\u00ea est\u00e1 convidado</p>
      <div class="names" style="margin-top:14px">
        <h1 class="name">Mayane</h1>
        <span class="amp">&amp;</span>
        <h1 class="name">Lucas</h1>
      </div>
      <div class="rule" style="margin:22px 0 14px"><span>&#10022;</span></div>
      <p class="kicker">Cerim\u00f4nia Simb\u00f3lica &amp; Celebra\u00e7\u00e3o</p>
      <div class="date-wrap">
        <span class="date-day">18</span>
        <span class="date-text">Outubro &middot; 2026</span>
        <span class="meta" style="margin-top:8px">Domingo &middot; \u00e0s 13h30</span>
      </div>
      <div style="margin:26px 0 24px">
        <span class="meta-label">Local</span>
        <p class="meta" style="margin-top:9px">R. Adelino Strasi, 04 &mdash; Jardim Brasil<br>V\u00e1rzea Paulista &middot; SP</p>
      </div>
"""

V1_EXTRA = """
  .monogram {
    display:grid; place-items:center; width:84px; height:84px; border-radius:50%;
    border:1.5px solid var(--accent-strong); background:rgba(255,255,255,.92);
    font-family:var(--font-display); font-size:24px; font-weight:700; letter-spacing:.14em;
    color:var(--accent-strong);
  }
  .date-wrap {
    margin-top:18px; padding:22px 32px; display:flex; flex-direction:column; align-items:center;
    background:rgba(255,255,255,.8); border-top:1px solid rgba(6,68,191,.3);
    border-bottom:1px solid rgba(6,68,191,.3);
  }
"""

build(
    'convite_v1_aquarela.html',
    'Mayane & Lucas \u2014 Aquarela Et\u00e9rea',
    'https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,600;1,400;1,600&family=Great+Vibes&family=Raleway:wght@400;500;600;700&display=swap',
    {
        'font-body': "'Raleway',sans-serif",
        'font-display': "'Cormorant Garamond',serif",
        'font-accent': "'Cormorant Garamond',serif",
        'font-name': "'Great Vibes',cursive",
        'name-size': 'clamp(66px,14vw,116px)',
        'name-lh': '1.1',
        'bg-page': '#e8f1fd',
        'bg-veil': 'linear-gradient(180deg,rgba(232,242,255,.82),rgba(214,232,252,.88))',
        'bg-filter': 'blur(2px) saturate(.85)',
        'ink': '#0e2f60',
        'ink-soft': '#164178',
        'accent-strong': '#0a44a8',
        'name-color': '#06349b',
        'name-weight': '400',
        'name-style': 'normal',
        'name-spacing': '.005em',
        'name-shadow': '0 2px 18px rgba(255,255,255,.95)',
        'card-bg': 'rgba(255,255,255,.74)',
        'card-border': 'rgba(255,255,255,.9)',
        'card-shadow': '0 30px 70px rgba(13,58,120,.22)',
        'rule-grad': 'linear-gradient(90deg,transparent,rgba(13,75,179,.55),transparent)',
        'chip-bg': 'rgba(255,255,255,.86)',
        'chip-bg-hover': '#ffffff',
        'chip-border': 'rgba(13,75,179,.38)',
        'chip-radius': '999px',
        'content-veil': 'radial-gradient(118% 76% at 50% 50%,rgba(255,255,255,.94) 0%,rgba(255,255,255,.78) 58%,rgba(255,255,255,0) 86%)',
        'pad-top': '112px',
        'pad-bottom': '104px',
        'flor-op': '.9',
        'flor-op-b': '.84',
    },
    V1_CONTENT, V1_EXTRA,
)


# ------------------------------------------------------------------ V2
V2_FRAME = """    <div class="gold-frame"></div>"""

V2_CONTENT = """      <span class="crest">ML</span>
      <p class="eyebrow" style="margin-top:18px">Save the Date</p>
      <div class="names" style="margin-top:14px">
        <h1 class="name">Mayane</h1>
        <span class="amp">&amp;</span>
        <h1 class="name">Lucas</h1>
      </div>
      <div class="rule" style="margin:24px 0 16px"><span>&#9670;</span></div>
      <p class="kicker">Temos a honra de convidar voc\u00ea</p>
      <div class="date-row">
        <span class="date-side">Dom</span>
        <span class="date-day">18</span>
        <span class="date-side">13<small>h</small>30</span>
      </div>
      <span class="date-text">Outubro &middot; 2026</span>
      <div style="margin:26px 0 24px">
        <span class="meta-label">Recep\u00e7\u00e3o</span>
        <p class="meta" style="margin-top:9px">R. Adelino Strasi, 04 &mdash; Jardim Brasil<br>V\u00e1rzea Paulista &middot; SP</p>
      </div>
"""

V2_EXTRA = """
  .gold-frame {
    position:absolute; z-index:1; inset:16px; pointer-events:none;
    border:1px solid rgba(197,164,92,.55);
    box-shadow:inset 0 0 0 4px rgba(197,164,92,.14);
  }
  .crest {
    display:grid; place-items:center; width:88px; height:88px;
    border:1.5px solid rgba(217,184,112,.85); border-radius:50%;
    background:rgba(255,255,255,.06);
    font-family:var(--font-display); font-size:32px; letter-spacing:.1em;
    color:#f0d79b;
  }
  .date-row {
    margin-top:20px; display:flex; align-items:center; justify-content:center; gap:20px;
  }
  .date-side {
    font-size:clamp(15px,3.9vw,19px); font-weight:600; letter-spacing:.22em;
    text-transform:uppercase; color:#f0d79b; padding:0 20px; position:relative;
  }
  .date-side::before, .date-side::after {
    content:''; position:absolute; top:50%; width:13px; height:1px;
    background:rgba(217,184,112,.75);
  }
  .date-side::before { left:0; } .date-side::after { right:0; }
  .date-side small { font-size:.68em; }
"""

build(
    'convite_v2_luxo.html',
    'Mayane & Lucas \u2014 Luxo Minimalista',
    'https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,500;1,400&family=Italiana&family=Jost:wght@300;400;500;600&display=swap',
    {
        'font-body': "'Jost',sans-serif",
        'font-display': "'Cormorant Garamond',serif",
        'font-accent': "'Cormorant Garamond',serif",
        'font-name': "'Italiana',serif",
        'name-size': 'clamp(64px,13.5vw,110px)',
        'name-lh': '1.06',
        'bg-page': '#0f1620',
        'bg-veil': 'linear-gradient(180deg,rgba(10,16,24,.9),rgba(6,10,16,.95))',
        'bg-filter': 'blur(3px) grayscale(.5) brightness(.5)',
        'ink': '#f6f8fc',
        'ink-soft': '#eaf0f8',
        'accent-strong': '#f0d79b',
        'name-color': '#ffffff',
        'name-weight': '400',
        'name-style': 'normal',
        'name-spacing': '.05em',
        'name-shadow': '0 4px 30px rgba(0,0,0,.6)',
        'card-bg': 'linear-gradient(165deg,#16202c 0%,#0d151f 55%,#111b26 100%)',
        'card-border': 'rgba(197,164,92,.28)',
        'card-shadow': '0 34px 80px rgba(0,0,0,.6)',
        'rule-grad': 'linear-gradient(90deg,transparent,rgba(217,184,112,.8),transparent)',
        'chip-bg': 'rgba(255,255,255,.08)',
        'chip-bg-hover': 'rgba(217,184,112,.22)',
        'chip-border': 'rgba(217,184,112,.5)',
        'content-veil': 'radial-gradient(116% 74% at 50% 50%,rgba(9,15,23,.9) 0%,rgba(9,15,23,.72) 58%,rgba(9,15,23,0) 86%)',
        'pad-x': '50px',
        'pad-top': '116px',
        'pad-bottom': '110px',
        'flor-w': '204px',
        'flor-w-b': '188px',
        'flor-op': '.85',
        'flor-op-b': '.78',
        'flor-filter': 'saturate(.55) brightness(1.02)',
    },
    V2_CONTENT, V2_EXTRA, V2_FRAME,
)


# ------------------------------------------------------------------ V3
V3_CONTENT = """      <p class="eyebrow">Casamento</p>
      <div class="names" style="margin-top:16px">
        <h1 class="name">Mayane</h1>
        <span class="amp">&amp;</span>
        <h1 class="name">Lucas</h1>
      </div>
      <div class="rule" style="margin:22px 0 18px"><span>&#10047;</span></div>
      <p class="verse">&ldquo;Assim, eles j\u00e1 n\u00e3o s\u00e3o dois, mas sim uma s\u00f3 carne.&rdquo;<br><span class="verse-ref">Mateus 19:6</span></p>
      <div class="date-panel">
        <span class="date-day">18</span>
        <span class="date-text">Outubro &middot; 2026</span>
        <span class="meta" style="margin-top:10px">Domingo &middot; 13h30</span>
      </div>
      <div style="margin:24px 0 24px">
        <span class="meta-label">Onde</span>
        <p class="meta" style="margin-top:9px">R. Adelino Strasi, 04 &mdash; Jardim Brasil<br>V\u00e1rzea Paulista &middot; SP</p>
      </div>
"""

V3_EXTRA = """
  .card { border-radius:6px; }
  .date-panel {
    margin-top:22px; padding:22px 34px; border-radius:4px;
    display:flex; flex-direction:column; align-items:center;
    background:rgba(244,248,242,.92); border:1px solid rgba(31,87,48,.28);
  }
"""

build(
    'convite_v3_botanico.html',
    'Mayane & Lucas \u2014 Bot\u00e2nico Cl\u00e1ssico',
    'https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,500;0,600;1,500&family=Parisienne&family=Lato:wght@400;600;700&display=swap',
    {
        'font-body': "'Lato',sans-serif",
        'font-display': "'Playfair Display',serif",
        'font-accent': "'Playfair Display',serif",
        'font-name': "'Parisienne',cursive",
        'name-size': 'clamp(62px,13vw,108px)',
        'name-lh': '1.14',
        'bg-page': '#eef2ea',
        'bg-veil': 'linear-gradient(180deg,rgba(238,244,235,.86),rgba(222,233,220,.9))',
        'bg-filter': 'blur(2px) saturate(.9)',
        'ink': '#16301f',
        'ink-soft': '#1b3a25',
        'accent-strong': '#1f5730',
        'name-color': '#122a19',
        'name-weight': '400',
        'name-style': 'normal',
        'name-spacing': '.005em',
        'name-shadow': '0 2px 16px rgba(255,255,255,.9)',
        'card-bg': 'rgba(255,255,255,.9)',
        'card-border': 'rgba(47,107,63,.24)',
        'card-shadow': '0 28px 64px rgba(31,63,38,.2)',
        'rule-grad': 'linear-gradient(90deg,transparent,rgba(31,87,48,.6),transparent)',
        'chip-bg': 'rgba(246,251,244,.95)',
        'chip-bg-hover': '#ffffff',
        'chip-border': 'rgba(31,87,48,.4)',
        'chip-radius': '4px',
        'content-veil': 'radial-gradient(118% 76% at 50% 50%,rgba(255,255,255,.95) 0%,rgba(255,255,255,.8) 58%,rgba(255,255,255,0) 86%)',
        'pad-top': '116px',
        'pad-bottom': '104px',
        'flor-filter': 'hue-rotate(-108deg) saturate(.66) brightness(.98)',
        'flor-w': '208px',
        'flor-w-b': '192px',
        'flor-op': '.88',
        'flor-op-b': '.82',
    },
    V3_CONTENT, V3_EXTRA,
)


# ------------------------------------------------------------------ V4
V4_CONTENT = """      <p class="eyebrow">Nossa Noite</p>
      <div class="names" style="margin-top:16px">
        <h1 class="name">Mayane</h1>
        <span class="amp">&amp;</span>
        <h1 class="name">Lucas</h1>
      </div>
      <div class="rule" style="margin:24px 0 16px"><span>&#10038;</span></div>
      <p class="kicker">Sob as estrelas, dizemos sim</p>
      <div class="date-glow">
        <span class="date-day">18</span>
        <span class="date-text">Outubro &middot; 2026</span>
        <span class="meta" style="margin-top:10px">Domingo &middot; 13h30</span>
      </div>
      <div style="margin:26px 0 24px">
        <span class="meta-label">Endere\u00e7o</span>
        <p class="meta" style="margin-top:9px">R. Adelino Strasi, 04 &mdash; Jardim Brasil<br>V\u00e1rzea Paulista &middot; SP</p>
      </div>
"""

V4_EXTRA = """
  .card { border-radius:10px; }
  .card::before {
    content:''; position:absolute; z-index:1; inset:0; pointer-events:none;
    background:radial-gradient(120% 60% at 50% 0%,rgba(120,170,255,.16),transparent 60%);
  }
  .date-glow {
    margin-top:20px; padding:22px 34px; border-radius:8px;
    display:flex; flex-direction:column; align-items:center;
    background:rgba(255,255,255,.05); border:1px solid rgba(146,183,255,.28);
    box-shadow:inset 0 1px 0 rgba(255,255,255,.08);
  }
  .date-glow .date-day { text-shadow:0 0 34px rgba(140,180,255,.6); }
"""

build(
    'convite_v4_noturno.html',
    'Mayane & Lucas \u2014 Noturno Estrelado',
    'https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,600;1,400&family=Pinyon+Script&family=Montserrat:wght@300;400;500;600;700&display=swap',
    {
        'font-body': "'Montserrat',sans-serif",
        'font-display': "'Cormorant Garamond',serif",
        'font-accent': "'Cormorant Garamond',serif",
        'font-name': "'Pinyon Script',cursive",
        'name-size': 'clamp(64px,13.5vw,112px)',
        'name-lh': '1.16',
        'bg-page': '#080d1a',
        'bg-veil': 'linear-gradient(180deg,rgba(8,14,30,.88),rgba(4,8,18,.95))',
        'bg-filter': 'blur(4px) brightness(.42) saturate(1.1)',
        'ink': '#f5f8ff',
        'ink-soft': '#e6edfd',
        'accent-strong': '#bfd6ff',
        'name-color': '#ffffff',
        'name-weight': '400',
        'name-style': 'normal',
        'name-spacing': '.01em',
        'name-shadow': '0 0 42px rgba(120,165,255,.45)',
        'card-bg': 'linear-gradient(170deg,#11203a 0%,#0a1428 60%,#0d1a30 100%)',
        'card-border': 'rgba(146,183,255,.26)',
        'card-shadow': '0 34px 82px rgba(0,0,0,.62)',
        'rule-grad': 'linear-gradient(90deg,transparent,rgba(180,206,255,.75),transparent)',
        'chip-bg': 'rgba(255,255,255,.09)',
        'chip-bg-hover': 'rgba(180,206,255,.24)',
        'chip-border': 'rgba(160,195,255,.48)',
        'chip-radius': '8px',
        'content-veil': 'radial-gradient(116% 74% at 50% 50%,rgba(8,16,32,.9) 0%,rgba(8,16,32,.7) 58%,rgba(8,16,32,0) 86%)',
        'pad-top': '116px',
        'pad-bottom': '110px',
        'flor-w': '204px',
        'flor-w-b': '188px',
        'flor-op': '.82',
        'flor-op-b': '.74',
        'flor-filter': 'brightness(1.05) saturate(1.05)',
    },
    V4_CONTENT, V4_EXTRA,
)
