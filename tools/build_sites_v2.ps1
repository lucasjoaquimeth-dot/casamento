param()
$ErrorActionPreference = 'Stop'

# Work from the repo root
$ROOT = (Get-Location).Path
if (-not (Test-Path (Join-Path $ROOT "convite_v1_aquarela.html"))) {
    $ROOT = Split-Path $PSScriptRoot -Parent
}
Write-Host "ROOT: $ROOT"

# Read local.jpeg as base64
$localB64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes((Join-Path $ROOT "assets\local.jpeg")))
Write-Host "local.jpeg b64 length: $($localB64.Length)"

# Helper: extract Nth data:image from HTML (0-based)
function Get-ImgB64([string]$html, [int]$index) {
    $rx = [regex]'src="data:(image/[^;]+);base64,([^"]+)"'
    $ms = $rx.Matches($html)
    if ($ms.Count -gt $index) {
        return $ms[$index].Groups[2].Value
    }
    return ''
}

# Helper: extract <style> block content
function Get-StyleBlock([string]$html) {
    $m = [regex]::Match($html, '(?s)<style>(.*?)</style>')
    if ($m.Success) { return $m.Groups[1].Value }
    return ''
}

# Helper: extract inner content of <main class="card">...</main>
function Get-CardInner([string]$html) {
    $m = [regex]::Match($html, '(?s)<main class="card">(.*?)</main>')
    if ($m.Success) { return $m.Groups[1].Value }
    return ''
}

$configs = @(
    'v1_aquarela|convite_v1_aquarela.html|#0a44a8|10,68,168|#e8f1fd|#0e2f60|#f2f7ff|rgba(232,242,255,0.96)|rgba(255,255,255,0.8)|rgba(10,68,168,0.2)|rgba(255,255,255,0.9)|rgba(10,68,168,0.4)|999px|rgba(10,68,168,0.15)|rgba(10,68,168,0.3)|#fff'
    "v2_luxo|convite_v2_luxo.html|#c5a45c|197,164,92|#0f1620|#f6f8fc|#111b28|rgba(10,16,26,0.97)|rgba(255,255,255,0.05)|rgba(197,164,92,0.25)|rgba(255,255,255,0.07)|rgba(197,164,92,0.35)|2px|rgba(197,164,92,0.15)|rgba(197,164,92,0.3)|#0f1620"
    'v3_botanico|convite_v3_botanico.html|#1f5730|31,87,48|#eef2ea|#16301f|#f4f8f2|rgba(238,244,235,0.97)|rgba(255,255,255,0.8)|rgba(31,87,48,0.2)|rgba(255,255,255,0.9)|rgba(31,87,48,0.4)|4px|rgba(31,87,48,0.15)|rgba(31,87,48,0.3)|#fff'
    'v4_noturno|convite_v4_noturno.html|#bfd6ff|191,214,255|#080d1a|#f5f8ff|#0d1628|rgba(8,13,26,0.97)|rgba(255,255,255,0.05)|rgba(191,214,255,0.25)|rgba(255,255,255,0.07)|rgba(191,214,255,0.35)|8px|rgba(191,214,255,0.15)|rgba(191,214,255,0.3)|#080d1a'
)

$fontGoogles = @{
    'v1_aquarela' = 'https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,600;1,400;1,600family=Great+Vibesfamily=Raleway:wght@400;500;600;700display=swap'
    'v2_luxo'     = 'https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,500;1,400family=Italianafamily=Jost:wght@300;400;500;600display=swap'
    'v3_botanico' = 'https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,500;0,600;1,500family=Parisiannefamily=Lato:wght@400;600;700display=swap'
    'v4_noturno'  = 'https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,600;1,400family=Pinyon+Scriptfamily=Montserrat:wght@300;400;500;600;700display=swap'
}

$fontBodies = @{
    'v1_aquarela' = "'Raleway',sans-serif"
    'v2_luxo'     = "'Jost',sans-serif"
    'v3_botanico' = "'Lato',sans-serif"
    'v4_noturno'  = "'Montserrat',sans-serif"
}

$fontScripts = @{
    'v1_aquarela' = "'Great Vibes',cursive"
    'v2_luxo'     = "'Italiana',serif"
    'v3_botanico' = "'Parisienne',cursive"
    'v4_noturno'  = "'Pinyon Script',cursive"
}

$fontSerifs = @{
    'v1_aquarela' = "'Cormorant Garamond',serif"
    'v2_luxo'     = "'Cormorant Garamond',serif"
    'v3_botanico' = "'Playfair Display',serif"
    'v4_noturno'  = "'Cormorant Garamond',serif"
}

$localFilters = @{
    'v1_aquarela' = 'saturate(1.05) brightness(1.02)'
    'v2_luxo'     = 'grayscale(0.12) brightness(0.95)'
    'v3_botanico' = 'saturate(0.9) brightness(1.0)'
    'v4_noturno'  = 'brightness(0.9) saturate(1.1)'
}

$venueCaptions = @{
    'v1_aquarela' = 'Local da Celebracao - Jardim Brasil'
    'v2_luxo'     = 'Local da Celebracao'
    'v3_botanico' = 'O Local da Nossa Celebracao'
    'v4_noturno'  = 'Sob as Estrelas - Jardim Brasil'
}

$greetings = @{
    'v1_aquarela' = 'Com a bencao de Deus e seus pais, convidamos voce'
    'v2_luxo'     = 'Temos a honra de convidar voce para este momento especial'
    'v3_botanico' = 'Com alegria, convidamos voce a celebrar conosco'
    'v4_noturno'  = 'Sob as estrelas, dizemos sim — e queremos voce conosco'
}

$ceremonyLabels = @{
    'v1_aquarela' = 'Cerimonia Simbolica'
    'v2_luxo'     = 'Cerimonia'
    'v3_botanico' = 'Cerimonia'
    'v4_noturno'  = 'Cerimonia'
}

foreach ($cfg in $configs) {
    $parts = $cfg -split '\|'
    $folder     = $parts[0]
    $srcFile    = $parts[1]
    $accent     = $parts[2]
    $accentRgb  = $parts[3]
    $bg         = $parts[4]
    $ink        = $parts[5]
    $sectAlt    = $parts[6]
    $navBg      = $parts[7]
    $cardSect   = $parts[8]
    $cardBrd    = $parts[9]
    $inputBg    = $parts[10]
    $inputBrd   = $parts[11]
    $btnR       = $parts[12]
    $divider2   = $parts[13]
    $divider    = $parts[14]
    $btnColor   = $parts[15]

    $fontGoogle = $fontGoogles[$folder] -replace 'family=','&family=' -replace 'display=','&display='
    $fontGoogle = $fontGoogle -replace '//fonts.googleapis.com/css2\?family=','//fonts.googleapis.com/css2?family='
    $fontBody   = $fontBodies[$folder]
    $fontScript = $fontScripts[$folder]
    $fontSerif  = $fontSerifs[$folder]
    $localFilter = $localFilters[$folder]
    $venueCaption = $venueCaptions[$folder]
    $greeting   = $greetings[$folder]
    $ceremLbl   = $ceremonyLabels[$folder]

    $srcPath = Join-Path $ROOT $srcFile
    $origHtml = [IO.File]::ReadAllText($srcPath, [Text.Encoding]::UTF8)

    $origStyle = Get-StyleBlock $origHtml
    $cardInner = Get-CardInner $origHtml
    $fundoB64  = Get-ImgB64 $origHtml 0

    $outDir = Join-Path $ROOT $folder
    if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Force -Path $outDir | Out-Null }

    # Build HTML using a StringBuilder to avoid PS string interpolation issues
    $sb = [System.Text.StringBuilder]::new()
    $null = $sb.AppendLine('<!DOCTYPE html>')
    $null = $sb.AppendLine('<html lang="pt-BR">')
    $null = $sb.AppendLine('<head>')
    $null = $sb.AppendLine('<meta charset="UTF-8">')
    $null = $sb.AppendLine('<meta name="viewport" content="width=device-width, initial-scale=1.0">')
    $null = $sb.AppendLine("<title>Mayane &amp; Lucas</title>")
    $null = $sb.AppendLine('<link rel="preconnect" href="https://fonts.googleapis.com">')
    $null = $sb.AppendLine('<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>')
    $null = $sb.AppendLine("<link href=`"$fontGoogle`" rel=`"stylesheet`">")
    $null = $sb.AppendLine('<style>')
    $null = $sb.AppendLine("/* === RESET === */")
    $null = $sb.AppendLine("*,*::before,*::after{margin:0;padding:0;box-sizing:border-box;}")
    $null = $sb.AppendLine("html{scroll-behavior:smooth;-webkit-text-size-adjust:100%;}")
    $null = $sb.AppendLine("body{background:$bg;color:$ink;font-family:$fontBody;-webkit-font-smoothing:antialiased;overflow-x:hidden;}")
    $null = $sb.AppendLine("a{color:inherit;text-decoration:none;}")
    $null = $sb.AppendLine("img{display:block;max-width:100%;}")
    $null = $sb.AppendLine("/* === ORIGINAL INVITE STYLES === */")
    $null = $sb.AppendLine($origStyle)
    $null = $sb.AppendLine("/* === NAVBAR === */")
    $null = $sb.AppendLine(".site-nav{position:fixed;top:0;left:0;right:0;z-index:100;background:$navBg;backdrop-filter:blur(12px);-webkit-backdrop-filter:blur(12px);border-bottom:1px solid $divider2;display:flex;align-items:center;justify-content:space-between;padding:0 clamp(16px,4vw,48px);height:60px;}")
    $null = $sb.AppendLine(".nav-brand{font-family:$fontScript;font-size:clamp(22px,4vw,30px);color:$accent;letter-spacing:.02em;white-space:nowrap;}")
    $null = $sb.AppendLine(".nav-links{display:flex;gap:clamp(18px,3vw,36px);list-style:none;}")
    $null = $sb.AppendLine(".nav-links a{font-size:13px;font-weight:600;letter-spacing:.18em;text-transform:uppercase;color:$ink;opacity:.8;transition:.2s;}")
    $null = $sb.AppendLine(".nav-links a:hover{opacity:1;color:$accent;}")
    $null = $sb.AppendLine(".nav-toggle{display:none;background:none;border:none;cursor:pointer;color:$ink;padding:4px;}")
    $null = $sb.AppendLine(".nav-toggle svg{width:22px;height:22px;}")
    $null = $sb.AppendLine(".nav-drawer{display:none;position:fixed;inset:0;z-index:200;background:$navBg;flex-direction:column;align-items:center;justify-content:center;gap:32px;}")
    $null = $sb.AppendLine(".nav-drawer.open{display:flex;}")
    $null = $sb.AppendLine(".nav-drawer a{font-size:clamp(17px,4vw,22px);font-weight:600;letter-spacing:.2em;text-transform:uppercase;color:$ink;}")
    $null = $sb.AppendLine(".nav-drawer a:hover{color:$accent;}")
    $null = $sb.AppendLine(".nav-close{position:absolute;top:18px;right:20px;background:none;border:none;cursor:pointer;color:$ink;}")
    $null = $sb.AppendLine(".nav-close svg{width:28px;height:28px;}")
    $null = $sb.AppendLine("@media(max-width:720px){.nav-links{display:none;}.nav-toggle{display:block;}}")
    $null = $sb.AppendLine("/* === HERO === */")
    $null = $sb.AppendLine("#hero{position:relative;min-height:100vh;display:flex;align-items:center;justify-content:center;padding:80px 16px 40px;}")
    $null = $sb.AppendLine("/* === SECTIONS === */")
    $null = $sb.AppendLine(".site-section{position:relative;z-index:10;padding:clamp(60px,8vw,100px) clamp(20px,5vw,60px);background:$bg;}")
    $null = $sb.AppendLine(".site-section.alt{background:$sectAlt;}")
    $null = $sb.AppendLine(".section-inner{max-width:860px;margin:0 auto;display:flex;flex-direction:column;align-items:center;text-align:center;gap:clamp(24px,4vw,40px);}")
    $null = $sb.AppendLine(".section-eyebrow{font-size:clamp(11px,2.5vw,13px);font-weight:700;letter-spacing:.36em;text-transform:uppercase;color:$accent;}")
    $null = $sb.AppendLine(".section-title{font-family:$fontSerif;font-size:clamp(30px,6vw,52px);font-weight:600;line-height:1.18;color:$ink;}")
    $null = $sb.AppendLine(".section-subtitle{font-family:$fontSerif;font-style:italic;font-size:clamp(20px,4vw,28px);color:$ink;opacity:.85;line-height:1.5;}")
    $null = $sb.AppendLine(".section-text{font-size:clamp(15px,2.4vw,18px);line-height:1.8;color:$ink;opacity:.8;max-width:640px;}")
    $null = $sb.AppendLine(".section-divider{width:min(240px,70%);height:1px;background:linear-gradient(90deg,transparent,$accent,transparent);flex-shrink:0;}")
    $null = $sb.AppendLine("/* === VENUE PHOTO === */")
    $null = $sb.AppendLine(".venue-wrap{position:relative;width:100%;max-width:860px;border-radius:6px;overflow:hidden;box-shadow:0 20px 60px rgba(0,0,0,0.25);}")
    $null = $sb.AppendLine(".venue-wrap img{width:100%;height:clamp(280px,45vw,520px);object-fit:cover;object-position:center 40%;filter:$localFilter;}")
    $null = $sb.AppendLine(".venue-caption{position:absolute;bottom:0;left:0;right:0;padding:16px 24px;background:linear-gradient(to top,rgba(0,0,0,0.65),transparent);font-size:13px;font-weight:600;letter-spacing:.2em;text-transform:uppercase;color:#fff;text-align:center;}")
    $null = $sb.AppendLine("/* === DATE BANNER === */")
    $null = $sb.AppendLine(".date-banner{display:flex;align-items:center;justify-content:center;gap:clamp(16px,4vw,48px);flex-wrap:wrap;padding:clamp(24px,4vw,40px) clamp(20px,5vw,60px);background:$sectAlt;border-top:1px solid $divider2;border-bottom:1px solid $divider2;position:relative;z-index:10;}")
    $null = $sb.AppendLine(".date-banner-num{font-family:$fontSerif;font-size:clamp(64px,14vw,110px);line-height:1;color:$accent;font-weight:600;}")
    $null = $sb.AppendLine(".date-banner-side{display:flex;flex-direction:column;gap:6px;}")
    $null = $sb.AppendLine(".date-banner-month{font-size:clamp(13px,2.6vw,17px);font-weight:700;letter-spacing:.3em;text-transform:uppercase;color:$ink;}")
    $null = $sb.AppendLine(".date-banner-detail{font-size:clamp(13px,2.4vw,16px);letter-spacing:.12em;color:$ink;opacity:.7;}")
    $null = $sb.AppendLine(".date-banner-sep{width:1px;height:70px;background:$divider;}")
    $null = $sb.AppendLine("@media(max-width:480px){.date-banner-sep{display:none;}}")
    $null = $sb.AppendLine("/* === EVENT CARDS === */")
    $null = $sb.AppendLine(".event-cards{display:grid;grid-template-columns:repeat(auto-fit,minmax(280px,1fr));gap:clamp(16px,3vw,28px);width:100%;max-width:760px;}")
    $null = $sb.AppendLine(".event-card{background:$cardSect;border:1px solid $cardBrd;border-radius:8px;padding:clamp(24px,4vw,36px) clamp(20px,4vw,32px);display:flex;flex-direction:column;gap:12px;align-items:center;text-align:center;}")
    $null = $sb.AppendLine(".event-card-icon{width:44px;height:44px;display:grid;place-items:center;border-radius:50%;border:1px solid $divider;color:$accent;flex-shrink:0;}")
    $null = $sb.AppendLine(".event-card-icon svg{width:22px;height:22px;}")
    $null = $sb.AppendLine(".event-card-label{font-size:12px;font-weight:700;letter-spacing:.3em;text-transform:uppercase;color:$accent;}")
    $null = $sb.AppendLine(".event-card-title{font-family:$fontSerif;font-size:clamp(20px,4vw,26px);font-weight:600;color:$ink;}")
    $null = $sb.AppendLine(".event-card-info{font-size:clamp(14px,2.4vw,16px);line-height:1.75;color:$ink;opacity:.8;}")
    $null = $sb.AppendLine(".event-card-time{font-size:clamp(15px,2.6vw,18px);font-weight:700;letter-spacing:.1em;color:$accent;}")
    $null = $sb.AppendLine("/* === RSVP === */")
    $null = $sb.AppendLine(".rsvp-form{width:100%;max-width:560px;display:flex;flex-direction:column;gap:16px;}")
    $null = $sb.AppendLine(".rsvp-form label{display:flex;flex-direction:column;gap:6px;font-size:12px;font-weight:700;letter-spacing:.2em;text-transform:uppercase;color:$ink;opacity:.7;text-align:left;}")
    $null = $sb.AppendLine(".rsvp-form input,.rsvp-form select,.rsvp-form textarea{padding:12px 16px;border-radius:6px;background:$inputBg;border:1px solid $inputBrd;color:$ink;font-family:$fontBody;font-size:15px;outline:none;transition:.2s;-webkit-appearance:none;}")
    $null = $sb.AppendLine(".rsvp-form input:focus,.rsvp-form select:focus,.rsvp-form textarea:focus{border-color:$accent;box-shadow:0 0 0 3px rgba($accentRgb,0.18);}")
    $null = $sb.AppendLine(".rsvp-form textarea{resize:vertical;min-height:90px;}")
    $null = $sb.AppendLine(".rsvp-form select option{background:$bg;color:$ink;}")
    $null = $sb.AppendLine(".rsvp-row{display:grid;grid-template-columns:1fr 1fr;gap:16px;}")
    $null = $sb.AppendLine("@media(max-width:500px){.rsvp-row{grid-template-columns:1fr;}}")
    $null = $sb.AppendLine(".btn-primary{display:inline-flex;align-items:center;justify-content:center;gap:10px;padding:14px 36px;cursor:pointer;background:$accent;color:$btnColor;border:none;font-family:$fontBody;font-weight:700;font-size:14px;letter-spacing:.22em;text-transform:uppercase;border-radius:$btnR;transition:.25s ease;}")
    $null = $sb.AppendLine(".btn-primary:hover{opacity:.88;transform:translateY(-2px);}")
    $null = $sb.AppendLine(".btn-outline{display:inline-flex;align-items:center;justify-content:center;gap:10px;padding:13px 32px;cursor:pointer;background:transparent;color:$accent;border:1.5px solid $accent;font-family:$fontBody;font-weight:700;font-size:14px;letter-spacing:.22em;text-transform:uppercase;border-radius:$btnR;transition:.25s ease;}")
    $null = $sb.AppendLine(".btn-outline:hover{background:rgba($accentRgb,0.12);}")
    $null = $sb.AppendLine(".form-success{display:none;padding:18px 24px;border-radius:8px;background:rgba($accentRgb,0.15);border:1px solid rgba($accentRgb,0.35);font-size:15px;font-weight:600;color:$ink;text-align:center;}")
    $null = $sb.AppendLine("/* === GIFTS === */")
    $null = $sb.AppendLine(".gifts-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(240px,1fr));gap:clamp(14px,2.5vw,24px);width:100%;max-width:760px;}")
    $null = $sb.AppendLine(".gift-card{background:$cardSect;border:1px solid $cardBrd;border-radius:8px;padding:clamp(20px,3.5vw,30px);display:flex;flex-direction:column;gap:10px;align-items:center;text-align:center;}")
    $null = $sb.AppendLine(".gift-card-icon{width:48px;height:48px;display:grid;place-items:center;color:$accent;}")
    $null = $sb.AppendLine(".gift-card-icon svg{width:32px;height:32px;}")
    $null = $sb.AppendLine(".gift-card-name{font-family:$fontSerif;font-size:clamp(18px,3vw,22px);font-weight:600;color:$ink;}")
    $null = $sb.AppendLine(".gift-card-desc{font-size:clamp(13px,2.2vw,15px);line-height:1.6;color:$ink;opacity:.7;}")
    $null = $sb.AppendLine(".gift-note{font-size:clamp(14px,2.5vw,16px);line-height:1.7;color:$ink;opacity:.7;max-width:540px;font-style:italic;}")
    $null = $sb.AppendLine("/* === MAP === */")
    $null = $sb.AppendLine(".map-wrap{width:100%;max-width:860px;border-radius:8px;overflow:hidden;box-shadow:0 12px 40px rgba(0,0,0,0.2);border:1px solid $cardBrd;}")
    $null = $sb.AppendLine(".map-wrap iframe{width:100%;height:clamp(240px,35vw,400px);border:none;display:block;}")
    $null = $sb.AppendLine(".map-addr{background:$cardSect;padding:20px 28px;display:flex;flex-wrap:wrap;gap:16px;align-items:center;justify-content:space-between;}")
    $null = $sb.AppendLine(".map-addr-text{font-size:clamp(14px,2.4vw,16px);line-height:1.7;color:$ink;opacity:.85;}")
    $null = $sb.AppendLine("/* === FOOTER === */")
    $null = $sb.AppendLine(".site-footer{position:relative;z-index:10;background:$sectAlt;border-top:1px solid $divider2;padding:clamp(40px,6vw,70px) clamp(20px,5vw,60px) clamp(28px,4vw,48px);text-align:center;display:flex;flex-direction:column;align-items:center;gap:20px;}")
    $null = $sb.AppendLine(".footer-names{font-family:$fontScript;font-size:clamp(38px,8vw,64px);color:$accent;line-height:1;}")
    $null = $sb.AppendLine(".footer-date{font-size:clamp(13px,2.5vw,16px);font-weight:700;letter-spacing:.32em;text-transform:uppercase;color:$ink;opacity:.7;}")
    $null = $sb.AppendLine(".footer-copy{font-size:12px;letter-spacing:.1em;color:$ink;opacity:.4;}")
    $null = $sb.AppendLine("/* === COUNTDOWN === */")
    $null = $sb.AppendLine(".countdown{display:flex;gap:clamp(12px,3vw,32px);flex-wrap:wrap;justify-content:center;}")
    $null = $sb.AppendLine(".countdown-unit{display:flex;flex-direction:column;align-items:center;gap:4px;}")
    $null = $sb.AppendLine(".countdown-num{font-family:$fontSerif;font-size:clamp(42px,9vw,72px);line-height:1;font-weight:600;color:$ink;}")
    $null = $sb.AppendLine(".countdown-label{font-size:11px;font-weight:700;letter-spacing:.28em;text-transform:uppercase;color:$accent;}")
    $null = $sb.AppendLine(".countdown-sep{font-family:$fontSerif;font-size:clamp(36px,8vw,60px);line-height:1;color:$accent;opacity:.5;align-self:flex-start;padding-top:4px;}")
    $null = $sb.AppendLine("/* === REVEAL === */")
    $null = $sb.AppendLine(".reveal{opacity:0;transform:translateY(28px);transition:opacity .65s ease,transform .65s ease;}")
    $null = $sb.AppendLine(".reveal.visible{opacity:1;transform:none;}")
    $null = $sb.AppendLine('</style>')
    $null = $sb.AppendLine('</head>')
    $null = $sb.AppendLine('<body>')
    $null = $sb.AppendLine('')
    $null = $sb.AppendLine('<!-- NAVBAR -->')
    $null = $sb.AppendLine('<nav class="site-nav">')
    $null = $sb.AppendLine('  <span class="nav-brand">M &amp; L</span>')
    $null = $sb.AppendLine("  <ul class=`"nav-links`">")
    $null = $sb.AppendLine('    <li><a href="#hero">Inicio</a></li>')
    $null = $sb.AppendLine('    <li><a href="#local">Local</a></li>')
    $null = $sb.AppendLine('    <li><a href="#cerimonia">Cerimonia</a></li>')
    $null = $sb.AppendLine('    <li><a href="#confirmar">Confirmar</a></li>')
    $null = $sb.AppendLine('    <li><a href="#presentes">Presentes</a></li>')
    $null = $sb.AppendLine('    <li><a href="#como-chegar">Como Chegar</a></li>')
    $null = $sb.AppendLine('  </ul>')
    $null = $sb.AppendLine("  <button class=`"nav-toggle`" aria-label=`"Menu`" onclick=`"document.getElementById('drawer').classList.add('open')`">")
    $null = $sb.AppendLine('    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><line x1="3" y1="6" x2="21" y2="6"/><line x1="3" y1="12" x2="21" y2="12"/><line x1="3" y1="18" x2="21" y2="18"/></svg>')
    $null = $sb.AppendLine('  </button>')
    $null = $sb.AppendLine('</nav>')
    $null = $sb.AppendLine('<div class="nav-drawer" id="drawer">')
    $null = $sb.AppendLine("  <button class=`"nav-close`" onclick=`"document.getElementById('drawer').classList.remove('open')`">")
    $null = $sb.AppendLine('    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>')
    $null = $sb.AppendLine('  </button>')
    $null = $sb.AppendLine("  <a href=`"#hero`" onclick=`"document.getElementById('drawer').classList.remove('open')`">Inicio</a>")
    $null = $sb.AppendLine("  <a href=`"#local`" onclick=`"document.getElementById('drawer').classList.remove('open')`">Local</a>")
    $null = $sb.AppendLine("  <a href=`"#cerimonia`" onclick=`"document.getElementById('drawer').classList.remove('open')`">Cerimonia</a>")
    $null = $sb.AppendLine("  <a href=`"#confirmar`" onclick=`"document.getElementById('drawer').classList.remove('open')`">Confirmar</a>")
    $null = $sb.AppendLine("  <a href=`"#presentes`" onclick=`"document.getElementById('drawer').classList.remove('open')`">Presentes</a>")
    $null = $sb.AppendLine("  <a href=`"#como-chegar`" onclick=`"document.getElementById('drawer').classList.remove('open')`">Como Chegar</a>")
    $null = $sb.AppendLine('</div>')
    $null = $sb.AppendLine('')
    $null = $sb.AppendLine('<!-- HERO: ORIGINAL INVITE CARD -->')
    $null = $sb.AppendLine('<section id="hero">')
    $null = $sb.AppendLine("  <div class=`"backdrop`"><img src=`"data:image/jpeg;base64,$fundoB64`" alt=`"fundo`"></div>")
    $null = $sb.AppendLine('  <main class="card">')
    $null = $sb.Append($cardInner)
    $null = $sb.AppendLine('')
    $null = $sb.AppendLine('  </main>')
    $null = $sb.AppendLine('</section>')
    $null = $sb.AppendLine('')
    $null = $sb.AppendLine('<!-- VENUE PHOTO -->')
    $null = $sb.AppendLine('<section id="local" class="site-section">')
    $null = $sb.AppendLine('  <div class="section-inner">')
    $null = $sb.AppendLine('    <p class="section-eyebrow reveal">O Local</p>')
    $null = $sb.AppendLine('    <h2 class="section-title reveal">Onde o Amor se Encontra</h2>')
    $null = $sb.AppendLine('    <div class="section-divider reveal"></div>')
    $null = $sb.AppendLine("    <div class=`"venue-wrap reveal`">")
    $null = $sb.AppendLine("      <img src=`"data:image/jpeg;base64,$localB64`" alt=`"$venueCaption`">")
    $null = $sb.AppendLine("      <div class=`"venue-caption`">$venueCaption</div>")
    $null = $sb.AppendLine("    </div>")
    $null = $sb.AppendLine('  </div>')
    $null = $sb.AppendLine('</section>')
    $null = $sb.AppendLine('')
    $null = $sb.AppendLine('<!-- DATE BANNER -->')
    $null = $sb.AppendLine('<div class="date-banner">')
    $null = $sb.AppendLine('  <div class="date-banner-side reveal" style="text-align:right;">')
    $null = $sb.AppendLine('    <span class="date-banner-month">Outubro &middot; 2026</span>')
    $null = $sb.AppendLine('    <span class="date-banner-detail">Domingo &middot; 13h30</span>')
    $null = $sb.AppendLine('  </div>')
    $null = $sb.AppendLine('  <div class="date-banner-sep reveal"></div>')
    $null = $sb.AppendLine('  <div class="date-banner-num reveal">18</div>')
    $null = $sb.AppendLine('  <div class="date-banner-sep reveal"></div>')
    $null = $sb.AppendLine('  <div class="date-banner-side reveal">')
    $null = $sb.AppendLine('    <span class="date-banner-month">Contagem Regressiva</span>')
    $null = $sb.AppendLine('    <div class="countdown" id="cd" style="margin-top:4px;"></div>')
    $null = $sb.AppendLine('  </div>')
    $null = $sb.AppendLine('</div>')
    $null = $sb.AppendLine('')
    $null = $sb.AppendLine('<!-- CERIMONIA & RECEPCAO -->')
    $null = $sb.AppendLine('<section id="cerimonia" class="site-section alt">')
    $null = $sb.AppendLine('  <div class="section-inner">')
    $null = $sb.AppendLine('    <p class="section-eyebrow reveal">Programacao</p>')
    $null = $sb.AppendLine('    <h2 class="section-title reveal">Cerimonia &amp; Recepcao</h2>')
    $null = $sb.AppendLine('    <div class="section-divider reveal"></div>')
    $null = $sb.AppendLine("    <p class=`"section-subtitle reveal`">$greeting</p>")
    $null = $sb.AppendLine('    <div class="event-cards">')
    $null = $sb.AppendLine('      <div class="event-card reveal">')
    $null = $sb.AppendLine('        <div class="event-card-icon">')
    $null = $sb.AppendLine('          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 000-7.78z"/></svg>')
    $null = $sb.AppendLine('        </div>')
    $null = $sb.AppendLine('        <span class="event-card-label">Cerimonia</span>')
    $null = $sb.AppendLine("        <div class=`"event-card-title`">$ceremLbl</div>")
    $null = $sb.AppendLine('        <div class="event-card-time">Domingo &middot; 13h30</div>')
    $null = $sb.AppendLine('        <div class="event-card-info">R. Adelino Strasi, 04 &mdash; Jardim Brasil<br>Varzea Paulista &middot; SP</div>')
    $null = $sb.AppendLine('      </div>')
    $null = $sb.AppendLine('      <div class="event-card reveal">')
    $null = $sb.AppendLine('        <div class="event-card-icon">')
    $null = $sb.AppendLine('          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><path d="M9 18V5l12-2v13"/><circle cx="6" cy="18" r="3"/><circle cx="18" cy="16" r="3"/></svg>')
    $null = $sb.AppendLine('        </div>')
    $null = $sb.AppendLine('        <span class="event-card-label">Recepcao</span>')
    $null = $sb.AppendLine('        <div class="event-card-title">Festa de Recepcao</div>')
    $null = $sb.AppendLine('        <div class="event-card-time">Domingo &middot; 13h30</div>')
    $null = $sb.AppendLine('        <div class="event-card-info">R. Adelino Strasi, 04 &mdash; Jardim Brasil<br>Varzea Paulista &middot; SP</div>')
    $null = $sb.AppendLine('      </div>')
    $null = $sb.AppendLine('    </div>')
    $null = $sb.AppendLine('  </div>')
    $null = $sb.AppendLine('</section>')
    $null = $sb.AppendLine('')
    $null = $sb.AppendLine('<!-- CONFIRMAR PRESENCA -->')
    $null = $sb.AppendLine('<section id="confirmar" class="site-section">')
    $null = $sb.AppendLine('  <div class="section-inner">')
    $null = $sb.AppendLine('    <p class="section-eyebrow reveal">RSVP</p>')
    $null = $sb.AppendLine('    <h2 class="section-title reveal">Confirmar Presenca</h2>')
    $null = $sb.AppendLine('    <div class="section-divider reveal"></div>')
    $null = $sb.AppendLine('    <p class="section-text reveal">Confirme sua presenca ate <strong>18 de Setembro de 2026</strong>.<br>Sua confirmacao e muito importante para nos!</p>')
    $null = $sb.AppendLine('    <form class="rsvp-form reveal" id="rsvpForm" onsubmit="handleRsvp(event)">')
    $null = $sb.AppendLine('      <div class="rsvp-row">')
    $null = $sb.AppendLine('        <label>Nome Completo')
    $null = $sb.AppendLine('          <input type="text" name="nome" placeholder="Seu nome" required>')
    $null = $sb.AppendLine('        </label>')
    $null = $sb.AppendLine('        <label>Telefone / WhatsApp')
    $null = $sb.AppendLine('          <input type="tel" name="tel" placeholder="(00) 00000-0000">')
    $null = $sb.AppendLine('        </label>')
    $null = $sb.AppendLine('      </div>')
    $null = $sb.AppendLine('      <label>E-mail')
    $null = $sb.AppendLine('        <input type="email" name="email" placeholder="seu@email.com">')
    $null = $sb.AppendLine('      </label>')
    $null = $sb.AppendLine('      <div class="rsvp-row">')
    $null = $sb.AppendLine('        <label>Confirmacao')
    $null = $sb.AppendLine('          <select name="confirmacao" required>')
    $null = $sb.AppendLine('            <option value="">Selecione...</option>')
    $null = $sb.AppendLine('            <option value="sim">Sim, estarei presente!</option>')
    $null = $sb.AppendLine('            <option value="nao">Nao poderei comparecer</option>')
    $null = $sb.AppendLine('          </select>')
    $null = $sb.AppendLine('        </label>')
    $null = $sb.AppendLine('        <label>Numero de convidados')
    $null = $sb.AppendLine('          <select name="qtd">')
    $null = $sb.AppendLine('            <option value="1">1 pessoa</option>')
    $null = $sb.AppendLine('            <option value="2">2 pessoas</option>')
    $null = $sb.AppendLine('            <option value="3">3 pessoas</option>')
    $null = $sb.AppendLine('            <option value="4">4 pessoas</option>')
    $null = $sb.AppendLine('          </select>')
    $null = $sb.AppendLine('        </label>')
    $null = $sb.AppendLine('      </div>')
    $null = $sb.AppendLine('      <label>Observacoes (restricao alimentar, etc.)')
    $null = $sb.AppendLine('        <textarea name="obs" placeholder="Alguma observacao? Escreva aqui..."></textarea>')
    $null = $sb.AppendLine('      </label>')
    $null = $sb.AppendLine('      <button type="submit" class="btn-primary" style="align-self:center;">')
    $null = $sb.AppendLine('        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" style="width:18px;height:18px;"><path d="M9 11l3 3L22 4"/><path d="M21 12v7a2 2 0 01-2 2H5a2 2 0 01-2-2V5a2 2 0 012-2h11"/></svg>')
    $null = $sb.AppendLine('        Confirmar Presenca')
    $null = $sb.AppendLine('      </button>')
    $null = $sb.AppendLine('    </form>')
    $null = $sb.AppendLine('    <div class="form-success" id="rsvpSuccess">')
    $null = $sb.AppendLine('      Obrigado! Sua presenca foi confirmada. Mal podemos esperar para te ver!')
    $null = $sb.AppendLine('    </div>')
    $null = $sb.AppendLine('  </div>')
    $null = $sb.AppendLine('</section>')
    $null = $sb.AppendLine('')
    $null = $sb.AppendLine('<!-- LISTA DE PRESENTES -->')
    $null = $sb.AppendLine('<section id="presentes" class="site-section alt">')
    $null = $sb.AppendLine('  <div class="section-inner">')
    $null = $sb.AppendLine('    <p class="section-eyebrow reveal">Presentes</p>')
    $null = $sb.AppendLine('    <h2 class="section-title reveal">Lista de Presentes</h2>')
    $null = $sb.AppendLine('    <div class="section-divider reveal"></div>')
    $null = $sb.AppendLine('    <p class="section-text reveal">Sua presenca ja e o maior presente. Mas se quiser nos presentear, aqui estao nossas opcoes:</p>')
    $null = $sb.AppendLine('    <div class="gifts-grid">')
    $null = $sb.AppendLine('      <div class="gift-card reveal">')
    $null = $sb.AppendLine('        <div class="gift-card-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 12 20 22 4 22 4 12"/><rect x="2" y="7" width="20" height="5"/><line x1="12" y1="22" x2="12" y2="7"/><path d="M12 7H7.5a2.5 2.5 0 010-5C11 2 12 7 12 7z"/><path d="M12 7h4.5a2.5 2.5 0 000-5C13 2 12 7 12 7z"/></svg></div>')
    $null = $sb.AppendLine('        <div class="gift-card-name">Pix</div>')
    $null = $sb.AppendLine('        <div class="gift-card-desc">Chave Pix:<br><strong>mayane@casamento.com</strong></div>')
    $null = $sb.AppendLine("        <button class=`"btn-outline`" onclick=`"navigator.clipboard.writeText('mayane@casamento.com').then(function(){alert('Chave Pix copiada!')})`">Copiar Chave</button>")
    $null = $sb.AppendLine('      </div>')
    $null = $sb.AppendLine('      <div class="gift-card reveal">')
    $null = $sb.AppendLine('        <div class="gift-card-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="2" y1="12" x2="22" y2="12"/><path d="M12 2a15.3 15.3 0 014 10 15.3 15.3 0 01-4 10 15.3 15.3 0 01-4-10 15.3 15.3 0 014-10z"/></svg></div>')
    $null = $sb.AppendLine('        <div class="gift-card-name">Lista Online</div>')
    $null = $sb.AppendLine('        <div class="gift-card-desc">Acesse nossa lista completa com os itens que escolhemos para nosso novo lar.</div>')
    $null = $sb.AppendLine('        <a class="btn-outline" href="#presentes">Ver Lista</a>')
    $null = $sb.AppendLine('      </div>')
    $null = $sb.AppendLine('      <div class="gift-card reveal">')
    $null = $sb.AppendLine('        <div class="gift-card-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 000-7.78z"/></svg></div>')
    $null = $sb.AppendLine('        <div class="gift-card-name">Lua de Mel</div>')
    $null = $sb.AppendLine("        <div class=`"gift-card-desc`">Contribua para nossa viagem dos sonhos e nos ajude a criar memorias inesqueciveis.</div>")
    $null = $sb.AppendLine("        <button class=`"btn-outline`" onclick=`"alert('Em breve!')`">Contribuir</button>")
    $null = $sb.AppendLine('      </div>')
    $null = $sb.AppendLine('    </div>')
    $null = $sb.AppendLine('    <p class="gift-note reveal">O presente mais valioso e a sua presenca e o seu carinho neste dia tao especial.</p>')
    $null = $sb.AppendLine('  </div>')
    $null = $sb.AppendLine('</section>')
    $null = $sb.AppendLine('')
    $null = $sb.AppendLine('<!-- COMO CHEGAR -->')
    $null = $sb.AppendLine('<section id="como-chegar" class="site-section">')
    $null = $sb.AppendLine('  <div class="section-inner">')
    $null = $sb.AppendLine('    <p class="section-eyebrow reveal">Localizacao</p>')
    $null = $sb.AppendLine('    <h2 class="section-title reveal">Como Chegar</h2>')
    $null = $sb.AppendLine('    <div class="section-divider reveal"></div>')
    $null = $sb.AppendLine('    <div class="map-wrap reveal">')
    $null = $sb.AppendLine('      <iframe title="Mapa do Local" src="https://maps.google.com/maps?q=R.+Adelino+Strasi+04,+Jardim+Brasil,+Varzea+Paulista,+SP&output=embed&z=16" allowfullscreen loading="lazy"></iframe>')
    $null = $sb.AppendLine('      <div class="map-addr">')
    $null = $sb.AppendLine("        <div class=`"map-addr-text`"><strong>$ceremLbl</strong><br>R. Adelino Strasi, 04 &mdash; Jardim Brasil<br>Varzea Paulista &middot; SP</div>")
    $null = $sb.AppendLine('        <a class="btn-primary" href="https://www.google.com/maps/search/R.+Adelino+Strasi,+04,+Jardim+Brasil,+Varzea+Paulista,+SP" target="_blank" rel="noopener">')
    $null = $sb.AppendLine('          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" style="width:18px;height:18px;"><path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7z"/><circle cx="12" cy="9" r="2.5"/></svg>')
    $null = $sb.AppendLine('          Abrir no Maps')
    $null = $sb.AppendLine('        </a>')
    $null = $sb.AppendLine('      </div>')
    $null = $sb.AppendLine('    </div>')
    $null = $sb.AppendLine('  </div>')
    $null = $sb.AppendLine('</section>')
    $null = $sb.AppendLine('')
    $null = $sb.AppendLine('<!-- FOOTER -->')
    $null = $sb.AppendLine('<footer class="site-footer">')
    $null = $sb.AppendLine('  <div class="footer-names">Mayane &amp; Lucas</div>')
    $null = $sb.AppendLine('  <div class="footer-date">18 &middot; Outubro &middot; 2026</div>')
    $null = $sb.AppendLine('  <div class="section-divider" style="opacity:.4;"></div>')
    $null = $sb.AppendLine('  <div class="footer-copy">Feito com amor &#9829;</div>')
    $null = $sb.AppendLine('</footer>')
    $null = $sb.AppendLine('')
    $null = $sb.AppendLine('<script>')
    $null = $sb.AppendLine('(function() {')
    $null = $sb.AppendLine("  var target = new Date('2026-10-18T13:30:00');")
    $null = $sb.AppendLine('  var el = document.getElementById("cd");')
    $null = $sb.AppendLine('  function pad(n) { return String(n).padStart(2,"0"); }')
    $null = $sb.AppendLine('  function tick() {')
    $null = $sb.AppendLine('    var now = new Date(); var diff = target - now;')
    $null = $sb.AppendLine('    if (diff <= 0) { el.innerHTML = "<span>E hoje!</span>"; return; }')
    $null = $sb.AppendLine('    var d = Math.floor(diff / 86400000);')
    $null = $sb.AppendLine('    var h = Math.floor((diff % 86400000) / 3600000);')
    $null = $sb.AppendLine('    var m = Math.floor((diff % 3600000) / 60000);')
    $null = $sb.AppendLine('    var s = Math.floor((diff % 60000) / 1000);')
    $null = $sb.AppendLine('    el.innerHTML =')
    $null = $sb.AppendLine('      "<span class=\"countdown-unit\"><span class=\"countdown-num\">" + d + "</span><span class=\"countdown-label\">dias</span></span>" +')
    $null = $sb.AppendLine('      "<span class=\"countdown-sep\">:</span>" +')
    $null = $sb.AppendLine('      "<span class=\"countdown-unit\"><span class=\"countdown-num\">" + pad(h) + "</span><span class=\"countdown-label\">hrs</span></span>" +')
    $null = $sb.AppendLine('      "<span class=\"countdown-sep\">:</span>" +')
    $null = $sb.AppendLine('      "<span class=\"countdown-unit\"><span class=\"countdown-num\">" + pad(m) + "</span><span class=\"countdown-label\">min</span></span>" +')
    $null = $sb.AppendLine('      "<span class=\"countdown-sep\">:</span>" +')
    $null = $sb.AppendLine('      "<span class=\"countdown-unit\"><span class=\"countdown-num\">" + pad(s) + "</span><span class=\"countdown-label\">seg</span></span>";')
    $null = $sb.AppendLine('  }')
    $null = $sb.AppendLine('  tick(); setInterval(tick, 1000);')
    $null = $sb.AppendLine('})();')
    $null = $sb.AppendLine('function handleRsvp(e) {')
    $null = $sb.AppendLine('  e.preventDefault();')
    $null = $sb.AppendLine('  document.getElementById("rsvpForm").style.display = "none";')
    $null = $sb.AppendLine('  document.getElementById("rsvpSuccess").style.display = "block";')
    $null = $sb.AppendLine('}')
    $null = $sb.AppendLine('(function() {')
    $null = $sb.AppendLine('  var obs = new IntersectionObserver(function(entries) {')
    $null = $sb.AppendLine('    entries.forEach(function(en) { if (en.isIntersecting) { en.target.classList.add("visible"); obs.unobserve(en.target); } });')
    $null = $sb.AppendLine('  }, { threshold: 0.08 });')
    $null = $sb.AppendLine('  document.querySelectorAll(".reveal").forEach(function(el) { obs.observe(el); });')
    $null = $sb.AppendLine('})();')
    $null = $sb.AppendLine('</script>')
    $null = $sb.AppendLine('</body>')
    $null = $sb.AppendLine('</html>')

    $outPath = Join-Path $outDir "index.html"
    [IO.File]::WriteAllText($outPath, $sb.ToString(), [Text.Encoding]::UTF8)
    $sizeKB = [int]([IO.FileInfo]$outPath).Length / 1024
    Write-Host "OK $folder/index.html - $sizeKB KB"
}

Write-Host ""
Write-Host "All 4 sites built successfully."
