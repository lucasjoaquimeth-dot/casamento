"""
build_sites.py
Reads each convite_vN_*.html, extracts embedded base64 blobs (fundo / flor_tl / flor_br),
reads assets/local.jpeg and converts it to base64, then writes a full multi-section
wedding website into each of the 4 version folders.
"""

import os, re, base64, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

def read_b64(path):
    with open(path, "rb") as f:
        return base64.b64encode(f.read()).decode()

def extract_first_b64_from_html(html, prefix):
    """Return the raw base64 string from the first src="data:...<prefix>base64,XXX" """
    pat = r'src="data:' + re.escape(prefix) + r';base64,([^"]+)"'
    m = re.search(pat, html)
    return m.group(1) if m else ""

def extract_all_b64_imgs(html):
    """Return list of (mime, b64) for each <img src="data:..."> in order."""
    pat = r'src="data:(image/[^;]+);base64,([^"]+)"'
    return re.findall(pat, html)

# Load venue photo
local_b64 = read_b64(os.path.join(ROOT, "assets", "local.jpeg"))

VERSIONS = [
    ("v1_aquarela",  "convite_v1_aquarela.html"),
    ("v2_luxo",      "convite_v2_luxo.html"),
    ("v3_botanico",  "convite_v3_botanico.html"),
    ("v4_noturno",   "convite_v4_noturno.html"),
]

# ── per-theme configuration ────────────────────────────────────────────────────
THEMES = {
    "v1_aquarela": dict(
        title       = "Mayane &amp; Lucas — Aquarela Etérea",
        name        = "Mayane &amp; Lucas",
        accent      = "#0a44a8",
        accent_rgb  = "10,68,168",
        bg          = "#e8f1fd",
        ink         = "#0e2f60",
        card_bg     = "rgba(255,255,255,0.92)",
        nav_bg      = "rgba(232,242,255,0.96)",
        section_alt = "#f2f7ff",
        btn_style   = "border-radius:999px;",
        font_google = "https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,600;1,400;1,600&family=Great+Vibes&family=Raleway:wght@400;500;600;700&display=swap",
        font_body   = "'Raleway',sans-serif",
        font_script = "'Great Vibes',cursive",
        font_serif  = "'Cormorant Garamond',serif",
        verse_text  = "&ldquo;Melhor é serem dois do que um, porque têm melhor paga do seu trabalho.&rdquo;",
        verse_ref   = "Eclesiastes 4:9",
        local_filter= "saturate(1.05) brightness(1.02)",
        eyebrow_hero= "Você está convidado",
        greeting    = "Com a bênção de Deus e seus pais",
        ceremony_label = "Cerimônia Simbólica",
        ceremony_addr  = "R. Adelino Strasi, 04 — Jardim Brasil<br>Várzea Paulista · SP",
        reception_label= "Recepção",
        reception_addr = "R. Adelino Strasi, 04 — Jardim Brasil<br>Várzea Paulista · SP",
        date_full   = "18 de Outubro de 2026",
        date_day    = "18",
        date_month  = "Outubro · 2026",
        date_weekday= "Domingo · às 13h30",
        maps_url    = "https://www.google.com/maps/search/R.+Adelino+Strasi,+04,+Jardim+Brasil,+Varzea+Paulista,+SP",
        venue_caption = "Local da Celebração — Jardim Brasil",
    ),
    "v2_luxo": dict(
        title       = "Mayane &amp; Lucas — Luxo Minimalista",
        name        = "Mayane &amp; Lucas",
        accent      = "#c5a45c",
        accent_rgb  = "197,164,92",
        bg          = "#0f1620",
        ink         = "#f6f8fc",
        card_bg     = "linear-gradient(165deg,#16202c 0%,#0d151f 55%,#111b26 100%)",
        nav_bg      = "rgba(10,16,26,0.97)",
        section_alt = "#111b28",
        btn_style   = "border-radius:2px;",
        font_google = "https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,500;1,400&family=Italiana&family=Jost:wght@300;400;500;600&display=swap",
        font_body   = "'Jost',sans-serif",
        font_script = "'Italiana',serif",
        font_serif  = "'Cormorant Garamond',serif",
        verse_text  = "&ldquo;Temo a honra de vos convidar para celebrar este momento único.&rdquo;",
        verse_ref   = "Save the Date",
        local_filter= "grayscale(0.12) brightness(0.95)",
        eyebrow_hero= "Save the Date",
        greeting    = "Temos a honra de convidar você",
        ceremony_label = "Cerimônia",
        ceremony_addr  = "R. Adelino Strasi, 04 — Jardim Brasil<br>Várzea Paulista · SP",
        reception_label= "Recepção",
        reception_addr = "R. Adelino Strasi, 04 — Jardim Brasil<br>Várzea Paulista · SP",
        date_full   = "18 de Outubro de 2026",
        date_day    = "18",
        date_month  = "Outubro · 2026",
        date_weekday= "Domingo · às 13h30",
        maps_url    = "https://www.google.com/maps/search/R.+Adelino+Strasi,+04,+Jardim+Brasil,+Varzea+Paulista,+SP",
        venue_caption = "Local da Celebração",
    ),
    "v3_botanico": dict(
        title       = "Mayane &amp; Lucas — Botânico Clássico",
        name        = "Mayane &amp; Lucas",
        accent      = "#1f5730",
        accent_rgb  = "31,87,48",
        bg          = "#eef2ea",
        ink         = "#16301f",
        card_bg     = "rgba(255,255,255,0.93)",
        nav_bg      = "rgba(238,244,235,0.97)",
        section_alt = "#f4f8f2",
        btn_style   = "border-radius:4px;",
        font_google = "https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,500;0,600;1,500&family=Parisienne&family=Lato:wght@400;600;700&display=swap",
        font_body   = "'Lato',sans-serif",
        font_script = "'Parisienne',cursive",
        font_serif  = "'Playfair Display',serif",
        verse_text  = "&ldquo;Assim, eles já não são dois, mas sim uma só carne.&rdquo;",
        verse_ref   = "Mateus 19:6",
        local_filter= "saturate(0.9) brightness(1.0)",
        eyebrow_hero= "Casamento",
        greeting    = "Com alegria, convidamos você a celebrar conosco",
        ceremony_label = "Cerimônia",
        ceremony_addr  = "R. Adelino Strasi, 04 — Jardim Brasil<br>Várzea Paulista · SP",
        reception_label= "Recepção",
        reception_addr = "R. Adelino Strasi, 04 — Jardim Brasil<br>Várzea Paulista · SP",
        date_full   = "18 de Outubro de 2026",
        date_day    = "18",
        date_month  = "Outubro · 2026",
        date_weekday= "Domingo · às 13h30",
        maps_url    = "https://www.google.com/maps/search/R.+Adelino+Strasi,+04,+Jardim+Brasil,+Varzea+Paulista,+SP",
        venue_caption = "O Local da Nossa Celebração",
    ),
    "v4_noturno": dict(
        title       = "Mayane &amp; Lucas — Noturno Estrelado",
        name        = "Mayane &amp; Lucas",
        accent      = "#bfd6ff",
        accent_rgb  = "191,214,255",
        bg          = "#080d1a",
        ink         = "#f5f8ff",
        card_bg     = "linear-gradient(170deg,#11203a 0%,#0a1428 60%,#0d1a30 100%)",
        nav_bg      = "rgba(8,13,26,0.97)",
        section_alt = "#0d1628",
        btn_style   = "border-radius:8px;",
        font_google = "https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,600;1,400&family=Pinyon+Script&family=Montserrat:wght@300;400;500;600;700&display=swap",
        font_body   = "'Montserrat',sans-serif",
        font_script = "'Pinyon Script',cursive",
        font_serif  = "'Cormorant Garamond',serif",
        verse_text  = "&ldquo;Sob as estrelas, unimos nossas vidas e dizemos sim.&rdquo;",
        verse_ref   = "Nossa Noite",
        local_filter= "brightness(0.9) saturate(1.1)",
        eyebrow_hero= "Nossa Noite",
        greeting    = "Sob as estrelas, dizemos sim",
        ceremony_label = "Cerimônia",
        ceremony_addr  = "R. Adelino Strasi, 04 — Jardim Brasil<br>Várzea Paulista · SP",
        reception_label= "Recepção",
        reception_addr = "R. Adelino Strasi, 04 — Jardim Brasil<br>Várzea Paulista · SP",
        date_full   = "18 de Outubro de 2026",
        date_day    = "18",
        date_month  = "Outubro · 2026",
        date_weekday= "Domingo · às 13h30",
        maps_url    = "https://www.google.com/maps/search/R.+Adelino+Strasi,+04,+Jardim+Brasil,+Varzea+Paulista,+SP",
        venue_caption = "Sob as Estrelas — Jardim Brasil",
    ),
}

# ── SVG icons ─────────────────────────────────────────────────────────────────
ICON_CHECK = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><path d="M9 11l3 3L22 4"/><path d="M21 12v7a2 2 0 01-2 2H5a2 2 0 01-2-2V5a2 2 0 012-2h11"/></svg>'
ICON_PIN   = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7z"/><circle cx="12" cy="9" r="2.5"/></svg>'
ICON_GIFT  = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 12 20 22 4 22 4 12"/><rect x="2" y="7" width="20" height="5"/><line x1="12" y1="22" x2="12" y2="7"/><path d="M12 7H7.5a2.5 2.5 0 010-5C11 2 12 7 12 7z"/><path d="M12 7h4.5a2.5 2.5 0 000-5C13 2 12 7 12 7z"/></svg>'
ICON_HEART = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 000-7.78z"/></svg>'
ICON_MUSIC = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><path d="M9 18V5l12-2v13"/><circle cx="6" cy="18" r="3"/><circle cx="18" cy="16" r="3"/></svg>'
ICON_MENU  = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><line x1="3" y1="6" x2="21" y2="6"/><line x1="3" y1="12" x2="21" y2="12"/><line x1="3" y1="18" x2="21" y2="18"/></svg>'
ICON_CLOSE = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>'

def is_dark(version):
    return version in ("v2_luxo", "v4_noturno")

def build_html(version, fundo_b64, flor_tl_mime, flor_tl_b64, flor_br_mime, flor_br_b64, local_b64, original_html):
    t = THEMES[version]
    dark = is_dark(version)

    # extract the inner card content from the original HTML (between <main class="card"> and </main>)
    card_inner_m = re.search(r'<main class="card">(.*?)</main>', original_html, re.DOTALL)
    card_inner = card_inner_m.group(1) if card_inner_m else ""

    # extract all <style> from original (between <style> and </style>)
    style_m = re.search(r'<style>(.*?)</style>', original_html, re.DOTALL)
    orig_style = style_m.group(1) if style_m else ""

    # colours for sections
    bg          = t["bg"]
    ink         = t["ink"]
    accent      = t["accent"]
    accent_rgb  = t["accent_rgb"]
    section_alt = t["section_alt"]
    nav_bg      = t["nav_bg"]
    btn_style   = t["btn_style"]
    font_body   = t["font_body"]
    font_script = t["font_script"]
    font_serif  = t["font_serif"]

    # border/divider colours
    if dark:
        divider     = f"rgba({accent_rgb},0.3)"
        divider2    = f"rgba({accent_rgb},0.15)"
        input_bg    = "rgba(255,255,255,0.07)"
        input_border= f"rgba({accent_rgb},0.35)"
        card_section= f"rgba(255,255,255,0.05)"
        card_border_section = f"rgba({accent_rgb},0.25)"
        muted       = "rgba(255,255,255,0.55)"
        close_color = ink
    else:
        divider     = f"rgba({accent_rgb},0.35)"
        divider2    = f"rgba({accent_rgb},0.18)"
        input_bg    = "rgba(255,255,255,0.9)"
        input_border= f"rgba({accent_rgb},0.4)"
        card_section= "rgba(255,255,255,0.8)"
        card_border_section = f"rgba({accent_rgb},0.2)"
        muted       = "rgba(0,0,0,0.45)"
        close_color = ink

    html = f"""<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>{t["title"]}</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="{t["font_google"]}" rel="stylesheet">
<style>
/* ═══════════════ RESET & BASE ═══════════════ */
*,*::before,*::after{{margin:0;padding:0;box-sizing:border-box;}}
html{{scroll-behavior:smooth;-webkit-text-size-adjust:100%;}}
body{{
  background:{bg};color:{ink};font-family:{font_body};
  -webkit-font-smoothing:antialiased;overflow-x:hidden;
}}
a{{color:inherit;text-decoration:none;}}
img{{display:block;max-width:100%;}}

/* ═══════════════ ORIGINAL INVITE STYLES ═══════════════ */
{orig_style}

/* ═══════════════ NAVBAR ═══════════════ */
.site-nav{{
  position:fixed;top:0;left:0;right:0;z-index:100;
  background:{nav_bg};backdrop-filter:blur(12px);-webkit-backdrop-filter:blur(12px);
  border-bottom:1px solid {divider2};
  display:flex;align-items:center;justify-content:space-between;
  padding:0 clamp(16px,4vw,48px);height:60px;
}}
.nav-brand{{
  font-family:{font_script};font-size:clamp(22px,4vw,30px);
  color:{accent};letter-spacing:.02em;white-space:nowrap;
}}
.nav-links{{display:flex;gap:clamp(18px,3vw,36px);list-style:none;}}
.nav-links a{{
  font-size:13px;font-weight:600;letter-spacing:.18em;
  text-transform:uppercase;color:{ink};opacity:.8;
  transition:.2s;
}}
.nav-links a:hover{{opacity:1;color:{accent};}}
.nav-toggle{{
  display:none;background:none;border:none;cursor:pointer;
  color:{ink};padding:4px;
}}
.nav-toggle svg{{width:22px;height:22px;}}
.nav-drawer{{
  display:none;position:fixed;inset:0;z-index:200;
  background:{nav_bg};flex-direction:column;
  align-items:center;justify-content:center;gap:32px;
}}
.nav-drawer.open{{display:flex;}}
.nav-drawer a{{
  font-size:clamp(17px,4vw,22px);font-weight:600;
  letter-spacing:.2em;text-transform:uppercase;color:{ink};
}}
.nav-drawer a:hover{{color:{accent};}}
.nav-close{{
  position:absolute;top:18px;right:20px;
  background:none;border:none;cursor:pointer;
  color:{close_color};
}}
.nav-close svg{{width:28px;height:28px;}}
@media(max-width:720px){{
  .nav-links{{display:none;}}
  .nav-toggle{{display:block;}}
}}

/* ═══════════════ HERO WRAPPER ═══════════════ */
#hero{{
  position:relative;min-height:100vh;
  display:flex;align-items:center;justify-content:center;
  padding:80px 16px 40px;
}}
/* the backdrop is already position:fixed inside the card markup */

/* ═══════════════ SECTIONS ═══════════════ */
.site-section{{
  position:relative;z-index:10;
  padding:clamp(60px,8vw,100px) clamp(20px,5vw,60px);
  background:{bg};
}}
.site-section.alt{{background:{section_alt};}}
.section-inner{{
  max-width:860px;margin:0 auto;
  display:flex;flex-direction:column;align-items:center;
  text-align:center;gap:clamp(24px,4vw,40px);
}}
.section-eyebrow{{
  font-size:clamp(11px,2.5vw,13px);font-weight:700;
  letter-spacing:.36em;text-transform:uppercase;
  color:{accent};
}}
.section-title{{
  font-family:{font_serif};font-size:clamp(30px,6vw,52px);
  font-weight:600;line-height:1.18;color:{ink};
}}
.section-subtitle{{
  font-family:{font_serif};font-style:italic;
  font-size:clamp(20px,4vw,28px);color:{ink};opacity:.85;line-height:1.5;
}}
.section-text{{
  font-size:clamp(15px,2.4vw,18px);line-height:1.8;
  color:{ink};opacity:.8;max-width:640px;
}}
.section-divider{{
  width:min(240px,70%);height:1px;
  background:linear-gradient(90deg,transparent,{accent},transparent);
  flex-shrink:0;
}}

/* ═══════════════ VENUE PHOTO ═══════════════ */
.venue-wrap{{
  position:relative;width:100%;max-width:860px;
  border-radius:6px;overflow:hidden;
  box-shadow:0 20px 60px rgba(0,0,0,0.25);
}}
.venue-wrap img{{
  width:100%;height:clamp(280px,45vw,520px);
  object-fit:cover;object-position:center 40%;
  filter:{t["local_filter"]};
}}
.venue-caption{{
  position:absolute;bottom:0;left:0;right:0;
  padding:16px 24px;
  background:linear-gradient(to top, rgba(0,0,0,0.65), transparent);
  font-size:13px;font-weight:600;letter-spacing:.2em;
  text-transform:uppercase;color:#fff;text-align:center;
}}

/* ═══════════════ DATE BANNER ═══════════════ */
.date-banner{{
  display:flex;align-items:center;justify-content:center;gap:clamp(16px,4vw,48px);
  flex-wrap:wrap;padding:clamp(24px,4vw,40px) clamp(20px,5vw,60px);
  background:{section_alt};
  border-top:1px solid {divider2};border-bottom:1px solid {divider2};
  position:relative;z-index:10;
}}
.date-banner-num{{
  font-family:{font_serif};font-size:clamp(64px,14vw,110px);
  line-height:1;color:{accent};font-weight:600;
}}
.date-banner-side{{display:flex;flex-direction:column;gap:6px;}}
.date-banner-month{{
  font-size:clamp(13px,2.6vw,17px);font-weight:700;
  letter-spacing:.3em;text-transform:uppercase;color:{ink};
}}
.date-banner-detail{{
  font-size:clamp(13px,2.4vw,16px);letter-spacing:.12em;
  color:{ink};opacity:.7;
}}
.date-banner-sep{{width:1px;height:70px;background:{divider};}}
@media(max-width:480px){{.date-banner-sep{{display:none;}}}}

/* ═══════════════ CEREMONY / RECEPTION CARDS ═══════════════ */
.event-cards{{
  display:grid;grid-template-columns:repeat(auto-fit,minmax(280px,1fr));
  gap:clamp(16px,3vw,28px);width:100%;max-width:760px;
}}
.event-card{{
  background:{card_section};border:1px solid {card_border_section};
  border-radius:8px;padding:clamp(24px,4vw,36px) clamp(20px,4vw,32px);
  display:flex;flex-direction:column;gap:12px;align-items:center;
  text-align:center;
}}
.event-card-icon{{
  width:44px;height:44px;display:grid;place-items:center;
  border-radius:50%;border:1px solid {divider};
  color:{accent};flex-shrink:0;
}}
.event-card-icon svg{{width:22px;height:22px;}}
.event-card-label{{
  font-size:12px;font-weight:700;letter-spacing:.3em;
  text-transform:uppercase;color:{accent};
}}
.event-card-title{{
  font-family:{font_serif};font-size:clamp(20px,4vw,26px);
  font-weight:600;color:{ink};
}}
.event-card-info{{
  font-size:clamp(14px,2.4vw,16px);line-height:1.75;
  color:{ink};opacity:.8;
}}
.event-card-time{{
  font-size:clamp(15px,2.6vw,18px);font-weight:700;
  letter-spacing:.1em;color:{accent};
}}

/* ═══════════════ RSVP FORM ═══════════════ */
.rsvp-form{{
  width:100%;max-width:560px;
  display:flex;flex-direction:column;gap:16px;
}}
.rsvp-form label{{
  display:flex;flex-direction:column;gap:6px;
  font-size:12px;font-weight:700;letter-spacing:.2em;
  text-transform:uppercase;color:{ink};opacity:.7;
  text-align:left;
}}
.rsvp-form input,
.rsvp-form select,
.rsvp-form textarea{{
  padding:12px 16px;border-radius:6px;
  background:{input_bg};border:1px solid {input_border};
  color:{ink};font-family:{font_body};font-size:15px;
  outline:none;transition:.2s;
  -webkit-appearance:none;
}}
.rsvp-form input:focus,
.rsvp-form select:focus,
.rsvp-form textarea:focus{{
  border-color:{accent};
  box-shadow:0 0 0 3px rgba({accent_rgb},0.18);
}}
.rsvp-form textarea{{resize:vertical;min-height:90px;}}
.rsvp-form select option{{background:{bg};color:{ink};}}
.rsvp-row{{display:grid;grid-template-columns:1fr 1fr;gap:16px;}}
@media(max-width:500px){{.rsvp-row{{grid-template-columns:1fr;}}}}
.btn-primary{{
  display:inline-flex;align-items:center;justify-content:center;gap:10px;
  padding:14px 36px;cursor:pointer;
  background:{accent};color:{"#fff" if not dark else bg};
  border:none;font-family:{font_body};font-weight:700;
  font-size:14px;letter-spacing:.22em;text-transform:uppercase;
  {btn_style}
  transition:.25s ease;
}}
.btn-primary:hover{{opacity:.88;transform:translateY(-2px);}}
.btn-outline{{
  display:inline-flex;align-items:center;justify-content:center;gap:10px;
  padding:13px 32px;cursor:pointer;
  background:transparent;color:{accent};
  border:1.5px solid {accent};font-family:{font_body};font-weight:700;
  font-size:14px;letter-spacing:.22em;text-transform:uppercase;
  {btn_style}
  transition:.25s ease;
}}
.btn-outline:hover{{background:rgba({accent_rgb},0.12);}}
.form-success{{
  display:none;padding:18px 24px;border-radius:8px;
  background:rgba({accent_rgb},0.15);border:1px solid rgba({accent_rgb},0.35);
  font-size:15px;font-weight:600;color:{ink};text-align:center;
}}

/* ═══════════════ GIFTS ═══════════════ */
.gifts-grid{{
  display:grid;grid-template-columns:repeat(auto-fit,minmax(240px,1fr));
  gap:clamp(14px,2.5vw,24px);width:100%;max-width:760px;
}}
.gift-card{{
  background:{card_section};border:1px solid {card_border_section};
  border-radius:8px;padding:clamp(20px,3.5vw,30px);
  display:flex;flex-direction:column;gap:10px;align-items:center;
  text-align:center;
}}
.gift-card-icon{{
  width:48px;height:48px;display:grid;place-items:center;
  color:{accent};
}}
.gift-card-icon svg{{width:32px;height:32px;}}
.gift-card-name{{
  font-family:{font_serif};font-size:clamp(18px,3vw,22px);
  font-weight:600;color:{ink};
}}
.gift-card-desc{{
  font-size:clamp(13px,2.2vw,15px);line-height:1.6;
  color:{ink};opacity:.7;
}}
.gift-note{{
  font-size:clamp(14px,2.5vw,16px);line-height:1.7;
  color:{ink};opacity:.7;max-width:540px;font-style:italic;
}}

/* ═══════════════ MAP ═══════════════ */
.map-wrap{{
  width:100%;max-width:860px;border-radius:8px;overflow:hidden;
  box-shadow:0 12px 40px rgba(0,0,0,0.2);
  border:1px solid {card_border_section};
}}
.map-wrap iframe{{
  width:100%;height:clamp(240px,35vw,400px);border:none;display:block;
}}
.map-addr{{
  background:{card_section};padding:20px 28px;
  display:flex;flex-wrap:wrap;gap:16px;
  align-items:center;justify-content:space-between;
}}
.map-addr-text{{
  font-size:clamp(14px,2.4vw,16px);line-height:1.7;
  color:{ink};opacity:.85;
}}

/* ═══════════════ FOOTER ═══════════════ */
.site-footer{{
  position:relative;z-index:10;
  background:{section_alt};
  border-top:1px solid {divider2};
  padding:clamp(40px,6vw,70px) clamp(20px,5vw,60px) clamp(28px,4vw,48px);
  text-align:center;
  display:flex;flex-direction:column;align-items:center;gap:20px;
}}
.footer-names{{
  font-family:{font_script};font-size:clamp(38px,8vw,64px);
  color:{accent};line-height:1;
}}
.footer-date{{
  font-size:clamp(13px,2.5vw,16px);font-weight:700;
  letter-spacing:.32em;text-transform:uppercase;color:{ink};opacity:.7;
}}
.footer-copy{{
  font-size:12px;letter-spacing:.1em;color:{ink};opacity:.4;
}}

/* ═══════════════ COUNTDOWN ═══════════════ */
.countdown{{
  display:flex;gap:clamp(12px,3vw,32px);flex-wrap:wrap;justify-content:center;
}}
.countdown-unit{{display:flex;flex-direction:column;align-items:center;gap:4px;}}
.countdown-num{{
  font-family:{font_serif};font-size:clamp(42px,9vw,72px);
  line-height:1;font-weight:600;color:{ink};
}}
.countdown-label{{
  font-size:11px;font-weight:700;letter-spacing:.28em;
  text-transform:uppercase;color:{accent};
}}
.countdown-sep{{
  font-family:{font_serif};font-size:clamp(36px,8vw,60px);
  line-height:1;color:{accent};opacity:.5;align-self:flex-start;padding-top:4px;
}}

/* ═══════════════ SCROLL REVEAL ═══════════════ */
.reveal{{opacity:0;transform:translateY(28px);transition:opacity .65s ease,transform .65s ease;}}
.reveal.visible{{opacity:1;transform:none;}}
</style>
</head>
<body>

<!-- ══════════ NAVBAR ══════════ -->
<nav class="site-nav">
  <span class="nav-brand">M &amp; L</span>
  <ul class="nav-links">
    <li><a href="#hero">Início</a></li>
    <li><a href="#local">Local</a></li>
    <li><a href="#cerimonia">Cerimônia</a></li>
    <li><a href="#confirmar">Confirmar</a></li>
    <li><a href="#presentes">Presentes</a></li>
    <li><a href="#como-chegar">Como Chegar</a></li>
  </ul>
  <button class="nav-toggle" aria-label="Menu" onclick="document.getElementById('drawer').classList.add('open')">{ICON_MENU}</button>
</nav>

<!-- mobile drawer -->
<div class="nav-drawer" id="drawer">
  <button class="nav-close" onclick="document.getElementById('drawer').classList.remove('open')">{ICON_CLOSE}</button>
  <a href="#hero"      onclick="document.getElementById('drawer').classList.remove('open')">Início</a>
  <a href="#local"     onclick="document.getElementById('drawer').classList.remove('open')">Local</a>
  <a href="#cerimonia" onclick="document.getElementById('drawer').classList.remove('open')">Cerimônia</a>
  <a href="#confirmar" onclick="document.getElementById('drawer').classList.remove('open')">Confirmar</a>
  <a href="#presentes" onclick="document.getElementById('drawer').classList.remove('open')">Presentes</a>
  <a href="#como-chegar" onclick="document.getElementById('drawer').classList.remove('open')">Como Chegar</a>
</div>

<!-- ══════════ HERO — ORIGINAL INVITE CARD ══════════ -->
<section id="hero">
  <div class="backdrop"><img src="data:image/jpeg;base64,{fundo_b64}" alt="fundo"></div>
  <main class="card">
    {card_inner}
  </main>
</section>

<!-- ══════════ SECTION: VENUE PHOTO ══════════ -->
<section id="local" class="site-section">
  <div class="section-inner">
    <p class="section-eyebrow reveal">O Local</p>
    <h2 class="section-title reveal">Onde o Amor se Encontra</h2>
    <div class="section-divider reveal"></div>
    <div class="venue-wrap reveal">
      <img src="data:image/jpeg;base64,{local_b64}" alt="{t['venue_caption']}">
      <div class="venue-caption">{t["venue_caption"]}</div>
    </div>
    <p class="section-text reveal">{t["verse_text"]}<br><em>{t["verse_ref"]}</em></p>
  </div>
</section>

<!-- ══════════ DATE BANNER ══════════ -->
<div class="date-banner">
  <div class="date-banner-side reveal" style="text-align:right;">
    <span class="date-banner-month">{t["date_month"]}</span>
    <span class="date-banner-detail">{t["date_weekday"]}</span>
  </div>
  <div class="date-banner-sep reveal"></div>
  <div class="date-banner-num reveal">{t["date_day"]}</div>
  <div class="date-banner-sep reveal"></div>
  <div class="date-banner-side reveal">
    <span class="date-banner-month">Contagem</span>
    <div class="countdown" id="cd" style="margin-top:4px;"></div>
  </div>
</div>

<!-- ══════════ SECTION: CERIMÔNIA & RECEPÇÃO ══════════ -->
<section id="cerimonia" class="site-section alt">
  <div class="section-inner">
    <p class="section-eyebrow reveal">Programação</p>
    <h2 class="section-title reveal">Cerimônia &amp; Recepção</h2>
    <div class="section-divider reveal"></div>
    <p class="section-subtitle reveal">{t["greeting"]}</p>
    <div class="event-cards">
      <div class="event-card reveal">
        <div class="event-card-icon">{ICON_HEART}</div>
        <span class="event-card-label">Cerimônia</span>
        <div class="event-card-title">{t["ceremony_label"]}</div>
        <div class="event-card-time">{t["date_weekday"]}</div>
        <div class="event-card-info">{t["ceremony_addr"]}</div>
      </div>
      <div class="event-card reveal">
        <div class="event-card-icon">{ICON_MUSIC}</div>
        <span class="event-card-label">Recepção</span>
        <div class="event-card-title">{t["reception_label"]}</div>
        <div class="event-card-time">{t["date_weekday"]}</div>
        <div class="event-card-info">{t["reception_addr"]}</div>
      </div>
    </div>
  </div>
</section>

<!-- ══════════ SECTION: CONFIRMAR PRESENÇA ══════════ -->
<section id="confirmar" class="site-section">
  <div class="section-inner">
    <p class="section-eyebrow reveal">RSVP</p>
    <h2 class="section-title reveal">Confirmar Presença</h2>
    <div class="section-divider reveal"></div>
    <p class="section-text reveal">Confirme sua presença até <strong>18 de Setembro de 2026</strong>.<br>Sua confirmação é muito importante para nós!</p>
    <form class="rsvp-form reveal" id="rsvpForm" onsubmit="handleRsvp(event)">
      <div class="rsvp-row">
        <label>Nome Completo
          <input type="text" name="nome" placeholder="Seu nome" required>
        </label>
        <label>Telefone / WhatsApp
          <input type="tel" name="tel" placeholder="(00) 00000-0000">
        </label>
      </div>
      <label>E-mail
        <input type="email" name="email" placeholder="seu@email.com">
      </label>
      <div class="rsvp-row">
        <label>Confirmação
          <select name="confirmacao" required>
            <option value="">Selecione...</option>
            <option value="sim">✓ Sim, estarei presente!</option>
            <option value="nao">✗ Não poderei comparecer</option>
          </select>
        </label>
        <label>Número de convidados
          <select name="qtd">
            <option value="1">1 pessoa</option>
            <option value="2">2 pessoas</option>
            <option value="3">3 pessoas</option>
            <option value="4">4 pessoas</option>
          </select>
        </label>
      </div>
      <label>Observações (restrição alimentar, etc.)
        <textarea name="obs" placeholder="Alguma observação? Escreva aqui..."></textarea>
      </label>
      <button type="submit" class="btn-primary" style="align-self:center;">
        {ICON_CHECK}&nbsp; Confirmar Presença
      </button>
    </form>
    <div class="form-success" id="rsvpSuccess">
      🎉 Obrigado! Sua presença foi confirmada com sucesso. Mal podemos esperar para te ver!
    </div>
  </div>
</section>

<!-- ══════════ SECTION: LISTA DE PRESENTES ══════════ -->
<section id="presentes" class="site-section alt">
  <div class="section-inner">
    <p class="section-eyebrow reveal">Presentes</p>
    <h2 class="section-title reveal">Lista de Presentes</h2>
    <div class="section-divider reveal"></div>
    <p class="section-text reveal">Seu carinho e presença já são os melhores presentes. Mas se desejar nos presentear, aqui estão nossas opções:</p>
    <div class="gifts-grid">
      <div class="gift-card reveal">
        <div class="gift-card-icon">{ICON_GIFT}</div>
        <div class="gift-card-name">Pix</div>
        <div class="gift-card-desc">Chave Pix:<br><strong>mayane@casamento.com</strong></div>
        <button class="btn-outline" onclick="navigator.clipboard.writeText('mayane@casamento.com').then(()=>alert('Chave Pix copiada!'))">Copiar Chave</button>
      </div>
      <div class="gift-card reveal">
        <div class="gift-card-icon">{ICON_GIFT}</div>
        <div class="gift-card-name">Lista Online</div>
        <div class="gift-card-desc">Acesse nossa lista completa de presentes com os itens que escolhemos para nosso novo lar.</div>
        <a class="btn-outline" href="#presentes">Ver Lista</a>
      </div>
      <div class="gift-card reveal">
        <div class="gift-card-icon">{ICON_HEART}</div>
        <div class="gift-card-name">Lua de Mel</div>
        <div class="gift-card-desc">Contribua para nossa viagem dos sonhos e nos ajude a criar memórias inesquecíveis.</div>
        <button class="btn-outline" onclick="alert('Em breve!')">Contribuir</button>
      </div>
    </div>
    <p class="gift-note reveal">"O presente mais valioso é a sua presença e o seu carinho neste dia tão especial."</p>
  </div>
</section>

<!-- ══════════ SECTION: COMO CHEGAR ══════════ -->
<section id="como-chegar" class="site-section">
  <div class="section-inner">
    <p class="section-eyebrow reveal">Localização</p>
    <h2 class="section-title reveal">Como Chegar</h2>
    <div class="section-divider reveal"></div>
    <div class="map-wrap reveal">
      <iframe
        title="Mapa do Local"
        src="https://maps.google.com/maps?q=R.+Adelino+Strasi+04,+Jardim+Brasil,+Varzea+Paulista,+SP&output=embed&z=16"
        allowfullscreen
        loading="lazy"
      ></iframe>
      <div class="map-addr">
        <div class="map-addr-text">
          <strong>{t["ceremony_label"]}</strong><br>
          {t["ceremony_addr"]}
        </div>
        <a class="btn-primary" href="{t['maps_url']}" target="_blank" rel="noopener">
          {ICON_PIN}&nbsp; Abrir no Maps
        </a>
      </div>
    </div>
  </div>
</section>

<!-- ══════════ FOOTER ══════════ -->
<footer class="site-footer">
  <div class="footer-names">Mayane &amp; Lucas</div>
  <div class="footer-date">18 · Outubro · 2026</div>
  <div class="section-divider" style="opacity:.4;"></div>
  <div class="footer-copy">Feito com amor ♥ &nbsp;|&nbsp; {t["title"]}</div>
</footer>

<script>
// ── Countdown ──────────────────────────────────────────────
(function() {{
  const target = new Date('2026-10-18T13:30:00');
  const el = document.getElementById('cd');
  function pad(n) {{ return String(n).padStart(2,'0'); }}
  function tick() {{
    const now = new Date();
    const diff = target - now;
    if (diff <= 0) {{ el.innerHTML = '<span style="font-size:14px;opacity:.8">É hoje! 🎉</span>'; return; }}
    const d = Math.floor(diff / 86400000);
    const h = Math.floor((diff % 86400000) / 3600000);
    const m = Math.floor((diff % 3600000) / 60000);
    const s = Math.floor((diff % 60000) / 1000);
    el.innerHTML =
      '<span class="countdown-unit"><span class="countdown-num">' + d + '</span><span class="countdown-label">dias</span></span>' +
      '<span class="countdown-sep">:</span>' +
      '<span class="countdown-unit"><span class="countdown-num">' + pad(h) + '</span><span class="countdown-label">hrs</span></span>' +
      '<span class="countdown-sep">:</span>' +
      '<span class="countdown-unit"><span class="countdown-num">' + pad(m) + '</span><span class="countdown-label">min</span></span>' +
      '<span class="countdown-sep">:</span>' +
      '<span class="countdown-unit"><span class="countdown-num">' + pad(s) + '</span><span class="countdown-label">seg</span></span>';
  }}
  tick();
  setInterval(tick, 1000);
}})();

// ── RSVP form ─────────────────────────────────────────────
function handleRsvp(e) {{
  e.preventDefault();
  const form = document.getElementById('rsvpForm');
  const success = document.getElementById('rsvpSuccess');
  form.style.display = 'none';
  success.style.display = 'block';
}}

// ── Scroll reveal ──────────────────────────────────────────
(function() {{
  const obs = new IntersectionObserver(entries => {{
    entries.forEach(en => {{ if (en.isIntersecting) {{ en.target.classList.add('visible'); obs.unobserve(en.target); }} }});
  }}, {{ threshold: 0.08 }});
  document.querySelectorAll('.reveal').forEach(el => obs.observe(el));
}})();
</script>
</body>
</html>"""
    return html


# ── Main build loop ────────────────────────────────────────────────────────────
for folder, src_file in VERSIONS:
    src_path = os.path.join(ROOT, src_file)
    with open(src_path, "r", encoding="utf-8") as f:
        original_html = f.read()

    imgs = extract_all_b64_imgs(original_html)
    # imgs[0] = backdrop jpeg, imgs[1] = flor_tl png, imgs[2] = flor_br png
    fundo_mime,   fundo_b64   = imgs[0] if len(imgs) > 0 else ("image/jpeg", "")
    flor_tl_mime, flor_tl_b64 = imgs[1] if len(imgs) > 1 else ("image/png", "")
    flor_br_mime, flor_br_b64 = imgs[2] if len(imgs) > 2 else ("image/png", "")

    out_dir  = os.path.join(ROOT, folder)
    os.makedirs(out_dir, exist_ok=True)
    out_path = os.path.join(out_dir, "index.html")

    html = build_html(folder, fundo_b64, flor_tl_mime, flor_tl_b64,
                      flor_br_mime, flor_br_b64, local_b64, original_html)

    with open(out_path, "w", encoding="utf-8") as f:
        f.write(html)

    size_kb = os.path.getsize(out_path) // 1024
    print(f"✓ {folder}/index.html — {size_kb} KB")

print("\nAll 4 sites built successfully.")
