param()
$ErrorActionPreference = 'Stop'
$ROOT = (Get-Location).Path

$localB64   = [Convert]::ToBase64String([IO.File]::ReadAllBytes((Join-Path $ROOT "assets\local.jpeg")))
$noivosB64  = [Convert]::ToBase64String([IO.File]::ReadAllBytes((Join-Path $ROOT "assets\noivos.jpeg")))
$florTopB64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes((Join-Path $ROOT "assets\flor_sem_fundo.png")))
$florLatB64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes((Join-Path $ROOT "assets\flor_lateral_direita.png")))
$florB64    = [Convert]::ToBase64String([IO.File]::ReadAllBytes((Join-Path $ROOT "assets\flor.png")))
Write-Host "Assets loaded."

$versions = @(
  # folder | accent | accentDark | bgBody | bgSection | ink | inkSoft | heroOverlay | sectionGrad | namefontkey | verseAccent
  "v1_aquarela|#1a4fa0|#0d3070|#f0f5ff|#e8f0fc|#0d2855|#2a5298|rgba(8,22,60,0.55)|linear-gradient(180deg,rgba(240,245,255,0) 0%,rgba(240,245,255,1) 18%)|Great Vibes|#1a4fa0"
  "v2_luxo|#b8963e|#7a6028|#faf6ee|#f5edda|#1c1508|#8c6d28|rgba(15,10,0,0.52)|linear-gradient(180deg,rgba(250,246,238,0) 0%,rgba(250,246,238,1) 18%)|Italiana|#b8963e"
  "v3_botanico|#2a6042|#1a4530|#f4faf5|#e8f5eb|#122518|#2a6042|rgba(5,25,10,0.50)|linear-gradient(180deg,rgba(244,250,245,0) 0%,rgba(244,250,245,1) 18%)|Parisienne|#2a6042"
  "v4_noturno|#8ab4e8|#4a7dbf|#0d1525|#111e30|#dce8f8|#8ab4e8|rgba(5,10,25,0.42)|linear-gradient(180deg,rgba(13,21,37,0) 0%,rgba(13,21,37,1) 18%)|Pinyon Script|#8ab4e8"
)

$fontLinks = @{
  "Great Vibes"   = "https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,600;1,400;1,600&family=Great+Vibes&family=Raleway:wght@300;400;500;600;700&display=swap"
  "Italiana"      = "https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,500;0,600;1,400&family=Italiana&family=Jost:wght@300;400;500;600&display=swap"
  "Parisienne"    = "https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,500;0,700;1,400;1,500&family=Parisienne&family=Lato:wght@300;400;700&display=swap"
  "Pinyon Script" = "https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,600;1,400&family=Pinyon+Script&family=Montserrat:wght@300;400;500;600&display=swap"
}
$bodyFonts   = @{ "Great Vibes"="'Raleway',sans-serif"; "Italiana"="'Jost',sans-serif"; "Parisienne"="'Lato',sans-serif"; "Pinyon Script"="'Montserrat',sans-serif" }
$serifFonts  = @{ "Great Vibes"="'Cormorant Garamond',serif"; "Italiana"="'Cormorant Garamond',serif"; "Parisienne"="'Playfair Display',serif"; "Pinyon Script"="'Cormorant Garamond',serif" }
$scriptFonts = @{ "Great Vibes"="'Great Vibes',cursive"; "Italiana"="'Italiana',serif"; "Parisienne"="'Parisienne',cursive"; "Pinyon Script"="'Pinyon Script',cursive" }

foreach ($v in $versions) {
  $p = $v -split '\|'
  $folder=$p[0]; $accent=$p[1]; $accentDark=$p[2]; $bgBody=$p[3]; $bgSection=$p[4]
  $ink=$p[5]; $inkSoft=$p[6]; $heroOverlay=$p[7]; $sectionGrad=$p[8]; $nfk=$p[9]; $verseAccent=$p[10]

  $isDark = ($folder -eq "v4_noturno")
  $fontLink  = $fontLinks[$nfk]
  $bodyFont  = $bodyFonts[$nfk]
  $serifFont = $serifFonts[$nfk]
  $scriptFont= $scriptFonts[$nfk]

  if ($isDark) {
    $mutedTxt   = "rgba(220,232,248,0.55)"
    $divClr     = "rgba(138,180,232,0.22)"
    $cardBg     = "rgba(255,255,255,0.05)"
    $cardBdr    = "rgba(138,180,232,0.18)"
    $iconBg     = "rgba(138,180,232,0.12)"
    $iconBdr    = "rgba(138,180,232,0.3)"
    $inputBg    = "rgba(255,255,255,0.07)"
    $inputBdr   = "rgba(138,180,232,0.3)"
    $verseBoxBg = "rgba(138,180,232,0.08)"
    $verseBoxBdr= "rgba(138,180,232,0.25)"
    $warnBg     = "rgba(138,180,232,0.08)"
    $warnBdr    = "rgba(138,180,232,0.2)"
    $addrClr    = "#8ab4e8"
    $playerBtnBg= "#8ab4e8"
    $playerBtnClr = "#0d1525"
  } else {
    $mutedTxt   = "rgba(0,0,0,0.42)"
    $divClr     = "rgba(0,0,0,0.1)"
    $cardBg     = "rgba(255,255,255,0.7)"
    $cardBdr    = "${accent}28"
    $iconBg     = "${accent}18"
    $iconBdr    = "${accent}40"
    $inputBg    = "rgba(255,255,255,0.85)"
    $inputBdr   = "${accent}35"
    $verseBoxBg = "${accent}10"
    $verseBoxBdr= "${accent}35"
    $warnBg     = "${accent}0c"
    $warnBdr    = "${accent}28"
    $addrClr    = $accent
    $playerBtnBg= $accent
    $playerBtnClr = "#fff"
  }

  $outDir = Join-Path $ROOT $folder
  if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Force -Path $outDir | Out-Null }

  $sb = [System.Text.StringBuilder]::new(3000000)
  function W([string]$s) { $null = $sb.AppendLine($s) }

  W '<!DOCTYPE html>'
  W '<html lang="pt-BR">'
  W '<head>'
  W '<meta charset="UTF-8">'
  W '<meta name="viewport" content="width=device-width, initial-scale=1.0">'
  W "<title>Mayane &amp; Lucas &mdash; Casamento 2026</title>"
  W '<link rel="preconnect" href="https://fonts.googleapis.com">'
  W '<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>'
  W "<link href=`"$fontLink`" rel=`"stylesheet`">"
  W '<style>'

  # ── Base Reset ──
  W "*, *::before, *::after { margin:0; padding:0; box-sizing:border-box; }"
  W "html { scroll-behavior:smooth; -webkit-text-size-adjust:100%; }"
  W "body { background:$bgBody; color:$ink; font-family:$bodyFont; -webkit-font-smoothing:antialiased; overflow-x:hidden; }"
  W "a { color:inherit; text-decoration:none; }"
  W "img { display:block; }"

  # ── HERO — full viewport ──
  W ".hero {"
  W "  position:relative; width:100%; height:100svh; min-height:600px;"
  W "  display:flex; flex-direction:column; align-items:center; justify-content:flex-end;"
  W "  overflow:hidden;"
  W "}"
  W ".hero-bg {"
  W "  position:absolute; inset:0; width:100%; height:100%;"
  W "  object-fit:cover; object-position:center 30%;"
  W "  z-index:0;"
  W "}"
  W ".hero-overlay {"
  W "  position:absolute; inset:0; z-index:1;"
  W "  background:$heroOverlay;"
  W "}"
  # gradient fading into page bg at bottom
  W ".hero-fade {"
  W "  position:absolute; bottom:0; left:0; right:0; height:40%; z-index:2;"
  W "  background:$sectionGrad;"
  W "}"
  # floral decorations on hero — corners absolutely positioned
  W ".hero-flor-tl {"
  W "  position:absolute; top:-8px; left:-8px; width:min(260px,40vw);"
  W "  z-index:4; pointer-events:none; opacity:0.92;"
  W "}"
  W ".hero-flor-tr {"
  W "  position:absolute; top:-8px; right:-8px; width:min(260px,40vw);"
  W "  z-index:4; pointer-events:none; opacity:0.92; transform:scaleX(-1);"
  W "}"
  # hero text over the image
  W ".hero-content {"
  W "  position:relative; z-index:5; text-align:center;"
  W "  padding:0 20px 60px; width:100%; max-width:700px;"
  W "}"
  W ".hero-monogram {"
  W "  display:inline-flex; align-items:center; justify-content:center;"
  W "  width:76px; height:96px; border:1.5px solid rgba(255,255,255,0.8);"
  W "  border-radius:50% / 55%; margin-bottom:20px;"
  W "  font-family:$serifFont; font-size:20px; font-weight:500;"
  W "  color:#fff; letter-spacing:.1em;"
  W "  text-shadow:0 1px 8px rgba(0,0,0,0.5);"
  W "  backdrop-filter:blur(4px); -webkit-backdrop-filter:blur(4px);"
  W "  background:rgba(255,255,255,0.12);"
  W "}"
  W ".hero-blessing {"
  W "  font-size:11px; letter-spacing:.3em; text-transform:uppercase;"
  W "  color:rgba(255,255,255,0.75); margin-bottom:12px;"
  W "}"
  W ".hero-names {"
  W "  font-family:$scriptFont;"
  W "  font-size:clamp(72px,16vw,120px); line-height:0.95;"
  W "  color:#fff;"
  W "  text-shadow:0 4px 32px rgba(0,0,0,0.5);"
  W "  margin-bottom:14px;"
  W "}"
  W ".hero-amp {"
  W "  font-family:$scriptFont;"
  W "  font-size:clamp(52px,12vw,88px); line-height:1;"
  W "  color:rgba(255,255,255,0.88);"
  W "  text-shadow:0 3px 20px rgba(0,0,0,0.45);"
  W "  display:block; margin:-10px 0;"
  W "}"
  W ".hero-tagline {"
  W "  font-family:$serifFont; font-style:italic;"
  W "  font-size:clamp(15px,3.5vw,20px); color:rgba(255,255,255,0.82);"
  W "  letter-spacing:.06em; margin-top:14px;"
  W "}"
  W ".hero-scroll {"
  W "  position:absolute; bottom:18px; left:50%; transform:translateX(-50%);"
  W "  z-index:5; display:flex; flex-direction:column; align-items:center; gap:6px;"
  W "  color:rgba(255,255,255,0.6);"
  W "}"
  W ".hero-scroll span { font-size:10px; letter-spacing:.22em; text-transform:uppercase; }"
  W ".hero-scroll svg { width:20px; height:20px; animation:scrollBounce 2s infinite; }"
  W "@keyframes scrollBounce { 0%,100%{transform:translateY(0)} 50%{transform:translateY(6px)} }"

  # ── VERSE BAND ──
  W ".verse-band {"
  W "  background:$bgBody; padding:52px 28px 48px;"
  W "  text-align:center; position:relative;"
  W "}"
  W ".verse-band::before {"
  W "  content:''; position:absolute; top:0; left:50%; transform:translateX(-50%);"
  W "  width:1px; height:40px; background:$divClr;"
  W "}"
  W ".verse-band p {"
  W "  font-family:$serifFont; font-style:italic;"
  W "  font-size:clamp(16px,3.8vw,22px); line-height:1.75;"
  W "  color:$ink; max-width:600px; margin:0 auto 14px;"
  W "}"
  W ".verse-band .ref {"
  W "  font-size:11px; font-weight:700; letter-spacing:.28em;"
  W "  text-transform:uppercase; color:$accent;"
  W "}"

  # ── PLAYER section ──
  W ".player-section {"
  W "  background:$bgSection; padding:32px 20px 36px;"
  W "  text-align:center; border-top:1px solid $divClr; border-bottom:1px solid $divClr;"
  W "}"
  W ".player { display:flex; align-items:center; justify-content:center; gap:18px; margin-bottom:8px; }"
  W ".player-ctrl { cursor:pointer; color:$mutedTxt; transition:.2s; }"
  W ".player-ctrl:hover { color:$accent; }"
  W ".player-ctrl svg { width:18px; height:18px; stroke:currentColor; fill:none; stroke-width:1.6; stroke-linecap:round; }"
  W ".player-btn {"
  W "  width:48px; height:48px; border-radius:50%;"
  W "  background:$playerBtnBg; border:none; cursor:pointer;"
  W "  display:grid; place-items:center; flex-shrink:0;"
  W "  box-shadow:0 4px 20px ${accent}55; transition:.2s;"
  W "}"
  W ".player-btn:hover { transform:scale(1.06); }"
  W ".player-btn svg { width:16px; height:16px; fill:$playerBtnClr; }"
  W ".player-label { font-size:10px; letter-spacing:.28em; text-transform:uppercase; color:$mutedTxt; }"

  # ── DATE HERO-STRIP ──
  W ".date-strip {"
  W "  background:$bgBody; padding:56px 20px 52px;"
  W "  text-align:center; position:relative;"
  W "}"
  # subtle SVG ornament lines on the sides
  W ".date-strip::before, .date-strip::after {"
  W "  content:''; position:absolute; top:50%; transform:translateY(-50%);"
  W "  width:clamp(40px,8vw,120px); height:1px; background:$divClr;"
  W "}"
  W ".date-strip::before { left:clamp(16px,5vw,80px); }"
  W ".date-strip::after { right:clamp(16px,5vw,80px); }"
  W ".date-script {"
  W "  font-family:$scriptFont; font-size:clamp(28px,6vw,40px);"
  W "  color:$mutedTxt; display:block; margin-bottom:6px;"
  W "}"
  W ".date-num {"
  W "  font-family:$serifFont; font-size:clamp(80px,18vw,130px);"
  W "  line-height:0.9; color:$accent; font-weight:300;"
  W "  display:block; margin-bottom:4px;"
  W "}"
  W ".date-month {"
  W "  font-size:clamp(14px,3.5vw,18px); font-weight:700;"
  W "  letter-spacing:.38em; text-transform:uppercase; color:$ink;"
  W "  display:block; margin-bottom:8px;"
  W "}"
  W ".date-sub {"
  W "  font-size:12px; letter-spacing:.2em; text-transform:uppercase; color:$mutedTxt; display:block;"
  W "}"

  # ── ADDRESS section ──
  W ".address-section {"
  W "  background:$bgSection; padding:52px 24px 56px;"
  W "  text-align:center; position:relative; overflow:hidden;"
  W "}"
  # faint lateral floral watermark
  W ".address-flor-l {"
  W "  position:absolute; left:-60px; top:50%; transform:translateY(-50%);"
  W "  width:clamp(140px,22vw,200px); opacity:0.08; pointer-events:none;"
  W "  filter:saturate(0);"
  W "}"
  W ".address-flor-r {"
  W "  position:absolute; right:-60px; top:50%; transform:translateY(-50%) scaleX(-1);"
  W "  width:clamp(140px,22vw,200px); opacity:0.08; pointer-events:none;"
  W "  filter:saturate(0);"
  W "}"
  W ".addr-block { margin-bottom:36px; position:relative; z-index:1; }"
  W ".addr-eyebrow {"
  W "  font-size:10px; font-weight:700; letter-spacing:.32em;"
  W "  text-transform:uppercase; color:$mutedTxt; display:block; margin-bottom:14px;"
  W "}"
  W ".addr-text {"
  W "  font-size:clamp(13px,3vw,16px); font-weight:600;"
  W "  letter-spacing:.08em; text-transform:uppercase;"
  W "  color:$addrClr; line-height:1.85;"
  W "  display:block;"
  W "}"
  W ".addr-sep {"
  W "  display:flex; align-items:center; gap:16px;"
  W "  justify-content:center; margin:0 auto 36px; position:relative; z-index:1;"
  W "  max-width:280px;"
  W "}"
  W ".addr-sep::before, .addr-sep::after {"
  W "  content:''; flex:1; height:1px; background:$divClr;"
  W "}"
  W ".addr-sep-dot {"
  W "  width:6px; height:6px; border-radius:50%;"
  W "  background:${accent}66; flex-shrink:0;"
  W "}"

  # ── VERSE BOX ──
  W ".verse-box-section {"
  W "  background:$bgBody; padding:48px 28px 52px; text-align:center;"
  W "}"
  W ".verse-box {"
  W "  max-width:560px; margin:0 auto;"
  W "  padding:32px 36px; border:1px solid $verseBoxBdr;"
  W "  background:$verseBoxBg;"
  W "  position:relative;"
  W "}"
  # corner ornaments
  W ".verse-box::before {"
  W "  content:'✦'; position:absolute; top:-12px; left:50%; transform:translateX(-50%);"
  W "  background:$bgBody; padding:0 12px;"
  W "  color:$accent; font-size:14px; line-height:1;"
  W "}"
  W ".verse-box p {"
  W "  font-family:$serifFont; font-style:italic;"
  W "  font-size:clamp(14px,3.5vw,17px); line-height:1.8;"
  W "  color:$ink; margin-bottom:16px;"
  W "}"
  W ".verse-box .ref {"
  W "  font-size:11px; font-weight:700; letter-spacing:.28em;"
  W "  text-transform:uppercase; color:$accent;"
  W "}"

  # ── ICONS ──
  W ".icons-section {"
  W "  background:$bgSection; padding:56px 20px 60px; text-align:center;"
  W "  position:relative; overflow:hidden;"
  W "}"
  W ".icons-eyebrow {"
  W "  font-size:11px; letter-spacing:.3em; text-transform:uppercase;"
  W "  color:$mutedTxt; display:block; margin-bottom:8px;"
  W "}"
  W ".icons-script {"
  W "  font-family:$scriptFont; font-size:clamp(40px,10vw,58px);"
  W "  color:$ink; display:block; line-height:1.1; margin-bottom:44px;"
  W "}"
  W ".icons-grid {"
  W "  display:grid; grid-template-columns:1fr 1fr;"
  W "  gap:clamp(24px,5vw,48px) clamp(20px,6vw,60px);"
  W "  max-width:480px; margin:0 auto;"
  W "}"
  W ".icon-item {"
  W "  display:flex; flex-direction:column; align-items:center; gap:12px;"
  W "  text-decoration:none; cursor:pointer;"
  W "}"
  W ".icon-ring {"
  W "  width:84px; height:84px; border-radius:50%;"
  W "  background:$iconBg; border:1.5px solid $iconBdr;"
  W "  display:grid; place-items:center;"
  W "  transition:transform .25s ease, background .25s ease, box-shadow .25s ease;"
  W "  position:relative;"
  W "}"
  W ".icon-item:hover .icon-ring {"
  W "  transform:translateY(-4px);"
  W "  background:${accent}22;"
  W "  box-shadow:0 12px 32px ${accent}30;"
  W "}"
  W ".icon-ring svg {"
  W "  width:32px; height:32px; stroke:$accent; fill:none;"
  W "  stroke-width:1.35; stroke-linecap:round; stroke-linejoin:round;"
  W "}"
  W ".icon-label {"
  W "  font-size:10.5px; font-weight:700; letter-spacing:.22em;"
  W "  text-transform:uppercase; color:$mutedTxt;"
  W "  text-align:center; line-height:1.5;"
  W "}"

  # ── AVISOS ──
  W ".avisos-section {"
  W "  background:$bgBody; padding:60px 28px 56px; text-align:center; position:relative;"
  W "}"
  W ".avisos-section::before {"
  W "  content:''; position:absolute; top:0; left:50%; transform:translateX(-50%);"
  W "  width:1px; height:40px; background:$divClr;"
  W "}"
  W ".avisos-script {"
  W "  font-family:$scriptFont; font-size:clamp(48px,12vw,68px);"
  W "  color:$ink; display:block; line-height:1.1; margin-bottom:32px;"
  W "}"
  W ".aviso-item { max-width:520px; margin:0 auto 20px; }"
  W ".aviso-item p {"
  W "  font-size:clamp(14px,3.5vw,16px); line-height:1.9;"
  W "  color:$ink;"
  W "}"
  W ".aviso-item strong { color:$accent; font-weight:700; }"
  W ".esperamos-script {"
  W "  font-family:$scriptFont; font-size:clamp(44px,11vw,62px);"
  W "  color:$ink; display:block; line-height:1.15; margin-top:40px;"
  W "}"

  # ── NOIVOS PHOTO ──
  W ".noivos-section {"
  W "  position:relative; width:100%; overflow:hidden;"
  W "}"
  W ".noivos-section img.noivos-img {"
  W "  width:100%; height:clamp(500px,70vh,800px);"
  W "  object-fit:cover; object-position:center top; display:block;"
  W "}"
  # overlay gradient top
  W ".noivos-grad {"
  W "  position:absolute; top:0; left:0; right:0; height:35%;"
  W "  background:linear-gradient(to bottom,$bgBody,transparent);"
  W "  z-index:2; pointer-events:none;"
  W "}"
  # floral corners on the photo
  W ".noivos-flor-bl {"
  W "  position:absolute; bottom:-12px; left:-12px;"
  W "  width:min(200px,35vw); z-index:4; pointer-events:none; opacity:0.88;"
  W "  transform:scaleY(-1);"
  W "}"
  W ".noivos-flor-br {"
  W "  position:absolute; bottom:-12px; right:-12px;"
  W "  width:min(200px,35vw); z-index:4; pointer-events:none; opacity:0.88;"
  W "  transform:scale(-1);"
  W "}"

  # ── SEP line shorthand ──
  W ".sep-line {"
  W "  width:1px; height:44px; background:$divClr; margin:0 auto;"
  W "}"
  W ".sep-diamond {"
  W "  display:flex; align-items:center; justify-content:center; gap:12px;"
  W "  margin:0 auto; max-width:200px;"
  W "}"
  W ".sep-diamond::before, .sep-diamond::after {"
  W "  content:''; flex:1; height:1px; background:$divClr;"
  W "}"
  W ".sep-diamond span { color:$accent; font-size:10px; }"

  # ── FOOTER ──
  W ".footer {"
  W "  background:$bgSection; padding:36px 20px 28px;"
  W "  text-align:center; border-top:1px solid $divClr;"
  W "}"
  W ".footer-names {"
  W "  font-family:$scriptFont; font-size:clamp(32px,8vw,48px);"
  W "  color:$accent; display:block; margin-bottom:8px;"
  W "}"
  W ".footer-date {"
  W "  font-size:11px; letter-spacing:.32em; text-transform:uppercase;"
  W "  color:$mutedTxt; display:block;"
  W "}"

  # ── Animations ──
  W ".fade-up {"
  W "  opacity:0; transform:translateY(30px);"
  W "  transition:opacity .7s ease, transform .7s ease;"
  W "}"
  W ".fade-up.visible { opacity:1; transform:none; }"

  W "@media(max-width:480px){"
  W "  .hero-content { padding-bottom:40px; }"
  W "  .date-strip::before,.date-strip::after { display:none; }"
  W "  .verse-box { padding:24px 20px; }"
  W "  .icons-grid { gap:20px 16px; }"
  W "  .icon-ring { width:72px; height:72px; }"
  W "  .icon-ring svg { width:26px; height:26px; }"
  W "}"
  W '</style>'
  W '</head>'
  W '<body>'

  # ══════════════ HERO ══════════════
  W '<section class="hero">'
  W "  <img class=`"hero-bg`" src=`"data:image/jpeg;base64,$localB64`" alt=`"Local do casamento`">"
  W '  <div class="hero-overlay"></div>'
  W '  <div class="hero-fade"></div>'
  W "  <img class=`"hero-flor-tl`" src=`"data:image/png;base64,$florTopB64`" alt=`"`">"
  W "  <img class=`"hero-flor-tr`" src=`"data:image/png;base64,$florTopB64`" alt=`"`">"
  W '  <div class="hero-content">'
  W '    <div class="hero-monogram">M &amp; L</div>'
  W '    <p class="hero-blessing">Com a b&ecirc;n&ccedil;&atilde;o de Deus e seus pais</p>'
  W '    <div class="hero-names">Mayane</div>'
  W '    <div class="hero-amp">&amp;</div>'
  W '    <div class="hero-names">Lucas</div>'
  W '    <p class="hero-tagline">Convidam para a cerim&ocirc;nia de casamento</p>'
  W '  </div>'
  W '  <div class="hero-scroll">'
  W '    <span>Rolar</span>'
  W '    <svg viewBox="0 0 24 24" fill="none" stroke="rgba(255,255,255,0.6)" stroke-width="2" stroke-linecap="round"><polyline points="6 9 12 15 18 9"/></svg>'
  W '  </div>'
  W '</section>'

  # ══════════════ VERSE BAND ══════════════
  W '<section class="verse-band fade-up">'
  W '  <p>&ldquo;Melhor &eacute; serem dois do que um, porque t&ecirc;m melhor paga do seu trabalho;<br>porque se um cair, o outro levanta o seu companheiro.&rdquo;</p>'
  W '  <span class="ref">Eclesiastes 4:9&#8209;12</span>'
  W '</section>'

  # ══════════════ PLAYER ══════════════
  W '<section class="player-section fade-up">'
  W '  <div class="player">'
  W '    <span class="player-ctrl"><svg viewBox="0 0 24 24"><polyline points="19 20 9 12 19 4"/><line x1="5" y1="19" x2="5" y2="5"/></svg></span>'
  W '    <span class="player-ctrl"><svg viewBox="0 0 24 24"><polygon points="19 20 9 12 19 4"/></svg></span>'
  W "    <button class=`"player-btn`" onclick=`"togglePlay(this)`" aria-label=`"Play`">"
  W '      <svg viewBox="0 0 24 24"><polygon points="5 3 19 12 5 21"/></svg>'
  W '    </button>'
  W '    <span class="player-ctrl"><svg viewBox="0 0 24 24"><polygon points="5 4 15 12 5 20"/><line x1="19" y1="5" x2="19" y2="19"/></svg></span>'
  W '    <span class="player-ctrl"><svg viewBox="0 0 24 24"><polyline points="5 4 15 12 5 20"/><polyline points="19 4 19 20"/></svg></span>'
  W '  </div>'
  W '  <div class="player-label">Aperte o play</div>'
  W '</section>'

  # ══════════════ DATE STRIP ══════════════
  W '<section class="date-strip fade-up">'
  W '  <span class="date-script">a realizar&#8209;se no dia</span>'
  W '  <span class="date-num">18</span>'
  W '  <span class="date-month">Outubro &middot; 2026</span>'
  W '  <span class="date-sub">S&aacute;bado &middot; &agrave;s 13h30</span>'
  W '</section>'

  # ══════════════ ADDRESS ══════════════
  W '<section class="address-section fade-up">'
  W "  <img class=`"address-flor-l`" src=`"data:image/png;base64,$florLatB64`" alt=`"`">"
  W "  <img class=`"address-flor-r`" src=`"data:image/png;base64,$florLatB64`" alt=`"`">"
  W '  <div class="addr-block">'
  W '    <span class="addr-eyebrow">A cerim&ocirc;nia ser&aacute; realizada na</span>'
  W '    <span class="addr-text">R. Adelino Strasi, 04<br>Jardim Brasil &mdash; V&aacute;rzea Paulista &middot; SP</span>'
  W '  </div>'
  W '  <div class="addr-sep"><div class="addr-sep-dot"></div></div>'
  W '  <div class="addr-block">'
  W '    <span class="addr-eyebrow">A recep&ccedil;&atilde;o dos convidados ser&aacute; no</span>'
  W '    <span class="addr-text">R. Adelino Strasi, 04<br>Jardim Brasil &mdash; V&aacute;rzea Paulista &middot; SP</span>'
  W '  </div>'
  W '</section>'

  # ══════════════ VERSE BOX ══════════════
  W '<section class="verse-box-section fade-up">'
  W '  <div class="verse-box">'
  W '    <p>&ldquo;Quem encontra uma esposa encontra algo excelente; recebeu uma b&ecirc;n&ccedil;&atilde;o do Senhor.&rdquo;</p>'
  W '    <span class="ref">Prov&eacute;rbios 18:22</span>'
  W '  </div>'
  W '</section>'

  # ══════════════ ICONS ══════════════
  W '<section class="icons-section fade-up">'
  W '  <span class="icons-eyebrow">Toque nos &iacute;cones</span>'
  W '  <span class="icons-script">para acessar</span>'
  W '  <div class="icons-grid">'
  # icon 1: ceremony location
  W '    <a class="icon-item" href="#" title="Localiza&ccedil;&atilde;o da Cerim&ocirc;nia">'
  W '      <div class="icon-ring">'
  W '        <svg viewBox="0 0 24 24"><path d="M12 22s-8-4.5-8-11.8A8 8 0 0 1 12 2a8 8 0 0 1 8 8.2c0 7.3-8 11.8-8 11.8z"/><circle cx="12" cy="10" r="2.8"/></svg>'
  W '      </div>'
  W '      <span class="icon-label">Localiza&ccedil;&atilde;o<br>da Cerim&ocirc;nia</span>'
  W '    </a>'
  # icon 2: reception location
  W '    <a class="icon-item" href="#" title="Localiza&ccedil;&atilde;o da Recep&ccedil;&atilde;o">'
  W '      <div class="icon-ring">'
  W '        <svg viewBox="0 0 24 24"><path d="M3 22V8l9-6 9 6v14H3z"/><path d="M9 22V12h6v10"/></svg>'
  W '      </div>'
  W '      <span class="icon-label">Localiza&ccedil;&atilde;o<br>da Recep&ccedil;&atilde;o</span>'
  W '    </a>'
  # icon 3: site dos noivos
  W '    <a class="icon-item" href="#" title="Site dos Noivos">'
  W '      <div class="icon-ring">'
  W '        <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><line x1="2" y1="12" x2="22" y2="12"/><path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"/></svg>'
  W '      </div>'
  W '      <span class="icon-label">Site dos<br>Noivos</span>'
  W '    </a>'
  # icon 4: confirmar
  W '    <a class="icon-item" href="#avisos" title="Confirmar Presen&ccedil;a">'
  W '      <div class="icon-ring">'
  W '        <svg viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/><polyline points="9 16 11 18 15 14"/></svg>'
  W '      </div>'
  W '      <span class="icon-label">Confirmar<br>Presen&ccedil;a</span>'
  W '    </a>'
  W '  </div>'
  W '</section>'

  # ══════════════ AVISOS ══════════════
  W '<section class="avisos-section fade-up" id="avisos">'
  W '  <div class="sep-diamond"><span>&#10022;</span></div>'
  W '  <span class="avisos-script" style="margin-top:32px;">Avisos</span>'
  W '  <div class="aviso-item">'
  W '    <p>A confirma&ccedil;&atilde;o de presen&ccedil;a &eacute; indispens&aacute;vel.<br>Confirme sua presen&ccedil;a at&eacute; o dia <strong>18/09/2026</strong>.</p>'
  W '  </div>'
  W '  <div class="aviso-item">'
  W '    <p><strong>Dress code:</strong> Esporte fino.</p>'
  W '  </div>'
  W '  <div class="aviso-item">'
  W '    <p>Pedimos a gentileza de chegar com anteced&ecirc;ncia para melhor acomoda&ccedil;&atilde;o de todos e para que possam aproveitar cada momento desse dia especial conosco.</p>'
  W '  </div>'
  W '  <span class="esperamos-script">Esperamos por<br>voc&ecirc;!</span>'
  W '</section>'

  # ══════════════ NOIVOS PHOTO ══════════════
  W '<section class="noivos-section">'
  W '  <div class="noivos-grad"></div>'
  W "  <img class=`"noivos-img`" src=`"data:image/jpeg;base64,$noivosB64`" alt=`"Mayane e Lucas`">"
  W "  <img class=`"noivos-flor-bl`" src=`"data:image/png;base64,$florTopB64`" alt=`"`">"
  W "  <img class=`"noivos-flor-br`" src=`"data:image/png;base64,$florTopB64`" alt=`"`">"
  W '</section>'

  # ══════════════ FOOTER ══════════════
  W '<footer class="footer">'
  W '  <span class="footer-names">Mayane &amp; Lucas</span>'
  W '  <span class="footer-date">18 &middot; Outubro &middot; 2026</span>'
  W '</footer>'

  # ══════════════ SCRIPTS ══════════════
  W '<script>'
  W 'function togglePlay(btn){'
  W '  var s=btn.querySelector("svg");'
  W '  if(btn.dataset.p==="1"){s.innerHTML="<polygon points=\"5 3 19 12 5 21\"/>";btn.dataset.p="0";}'
  W '  else{s.innerHTML="<rect x=\"6\" y=\"4\" width=\"4\" height=\"16\"/><rect x=\"14\" y=\"4\" width=\"4\" height=\"16\"/>";btn.dataset.p="1";}'
  W '}'
  W '(function(){'
  W '  var io=new IntersectionObserver(function(es){'
  W '    es.forEach(function(e){if(e.isIntersecting){e.target.classList.add("visible");io.unobserve(e.target);}});'
  W '  },{threshold:0.08});'
  W '  document.querySelectorAll(".fade-up").forEach(function(el){io.observe(el);});'
  W '})();'
  W '</script>'
  W '</body>'
  W '</html>'

  $outPath = Join-Path $outDir "index.html"
  [IO.File]::WriteAllText($outPath, $sb.ToString(), [Text.Encoding]::UTF8)
  $kb = [math]::Round(([IO.FileInfo]$outPath).Length / 1024, 1)
  Write-Host "OK $folder/index.html — ${kb}KB"
}

Write-Host "Done. 4 elegant sites built."
