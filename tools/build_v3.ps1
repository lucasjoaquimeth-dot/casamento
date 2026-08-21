param()
$ErrorActionPreference = 'Stop'
$ROOT = (Get-Location).Path

# Load assets
$localB64   = [Convert]::ToBase64String([IO.File]::ReadAllBytes((Join-Path $ROOT "assets\local.jpeg")))
$noivosB64  = [Convert]::ToBase64String([IO.File]::ReadAllBytes((Join-Path $ROOT "assets\noivos.jpeg")))
$florTopB64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes((Join-Path $ROOT "assets\flor_sem_fundo.png")))
$florLatB64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes((Join-Path $ROOT "assets\flor_lateral_direita.png")))
Write-Host "Assets loaded."

# Per-version theme config: folder|accent|accentLight|bg|ink|verseBox|namefont
$versions = @(
  "v1_aquarela|#0a44a8|#dde9ff|#ffffff|#1a2c4e|rgba(200,220,255,0.18)|Great Vibes"
  "v2_luxo|#b8963e|#fdf3dc|#faf8f3|#1c1508|rgba(184,150,62,0.15)|Italiana"
  "v3_botanico|#2d6a4f|#e8f5ee|#f9fdf7|#132d1e|rgba(45,106,79,0.12)|Parisienne"
  "v4_noturno|#7ea8d8|#1a2540|#111827|#e8eef8|rgba(126,168,216,0.15)|Pinyon Script"
)

$fontLinks = @{
  "Great Vibes"   = "https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,600;1,400&family=Great+Vibes&family=Raleway:wght@300;400;500;600&display=swap"
  "Italiana"      = "https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,500;1,400&family=Italiana&family=Jost:wght@300;400;500&display=swap"
  "Parisienne"    = "https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,500;1,500&family=Parisienne&family=Lato:wght@300;400;600&display=swap"
  "Pinyon Script" = "https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;1,400&family=Pinyon+Script&family=Montserrat:wght@300;400;500&display=swap"
}

$bodyFonts = @{
  "Great Vibes"   = "'Raleway', sans-serif"
  "Italiana"      = "'Jost', sans-serif"
  "Parisienne"    = "'Lato', sans-serif"
  "Pinyon Script" = "'Montserrat', sans-serif"
}

$displayFonts = @{
  "Great Vibes"   = "'Cormorant Garamond', serif"
  "Italiana"      = "'Cormorant Garamond', serif"
  "Parisienne"    = "'Playfair Display', serif"
  "Pinyon Script" = "'Cormorant Garamond', serif"
}

foreach ($v in $versions) {
  $p          = $v -split '\|'
  $folder     = $p[0]
  $accent     = $p[1]
  $accentLight= $p[2]
  $bg         = $p[3]
  $ink        = $p[4]
  $verseBox   = $p[5]
  $nameFontKey= $p[6]

  $fontLink   = $fontLinks[$nameFontKey]
  $bodyFont   = $bodyFonts[$nameFontKey]
  $displayFont= $displayFonts[$nameFontKey]
  $scriptFont = "'$nameFontKey', cursive"
  if ($nameFontKey -eq "Italiana") { $scriptFont = "'Italiana', serif" }

  # Dark mode adjustments
  $isDark = ($folder -eq "v4_noturno")
  if ($isDark) {
    $mutedColor   = "rgba(232,238,248,0.55)"
    $separatorClr = "rgba(126,168,216,0.3)"
    $iconBg       = "rgba(126,168,216,0.15)"
    $iconBorder   = "rgba(126,168,216,0.4)"
    $verseBoxBg   = "rgba(126,168,216,0.1)"
    $verseBoxBdr  = "rgba(126,168,216,0.3)"
    $warningBg    = "rgba(126,168,216,0.12)"
    $warningBdr   = "rgba(126,168,216,0.3)"
  } else {
    $mutedColor   = "rgba(0,0,0,0.45)"
    $separatorClr = "rgba(0,0,0,0.12)"
    $iconBg       = $accentLight
    $iconBorder   = "${accent}44"
    $verseBoxBg   = $accentLight
    $verseBoxBdr  = "${accent}44"
    $warningBg    = $accentLight
    $warningBdr   = "${accent}44"
  }

  $outDir = Join-Path $ROOT $folder
  if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Force -Path $outDir | Out-Null }

  $sb = [System.Text.StringBuilder]::new(2000000)

  $nl = $sb.AppendLine.GetType()

  function W([string]$line) { $null = $sb.AppendLine($line) }

  W '<!DOCTYPE html>'
  W '<html lang="pt-BR">'
  W '<head>'
  W '<meta charset="UTF-8">'
  W '<meta name="viewport" content="width=device-width, initial-scale=1.0">'
  W "<title>Mayane &amp; Lucas &mdash; Casamento</title>"
  W '<link rel="preconnect" href="https://fonts.googleapis.com">'
  W '<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>'
  W "<link href=`"$fontLink`" rel=`"stylesheet`">"
  W '<style>'

  W "*, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }"
  W "html { -webkit-text-size-adjust: 100%; }"
  W "body { background: $bg; color: $ink; font-family: $bodyFont; -webkit-font-smoothing: antialiased; }"
  W "a { color: inherit; text-decoration: none; }"
  W "img { display: block; max-width: 100%; }"

  # Page wrapper — narrow centered column like the reference
  W ".page {"
  W "  max-width: 480px;"
  W "  margin: 0 auto;"
  W "  background: $bg;"
  W "  position: relative;"
  W "  overflow: hidden;"
  W "}"

  # ── Floral corners ──
  W ".flor-tl {"
  W "  position: absolute; top: -10px; left: -10px;"
  W "  width: 200px; pointer-events: none; z-index: 2;"
  W "  opacity: 0.9;"
  W "}"
  W ".flor-tr {"
  W "  position: absolute; top: -10px; right: -10px;"
  W "  width: 200px; pointer-events: none; z-index: 2;"
  W "  opacity: 0.9; transform: scaleX(-1);"
  W "}"
  W ".flor-bl {"
  W "  position: absolute; bottom: -10px; left: -10px;"
  W "  width: 180px; pointer-events: none; z-index: 2;"
  W "  opacity: 0.85; transform: scaleY(-1);"
  W "}"
  W ".flor-br {"
  W "  position: absolute; bottom: -10px; right: -10px;"
  W "  width: 180px; pointer-events: none; z-index: 2;"
  W "  opacity: 0.85; transform: scale(-1);"
  W "}"

  # ── Top section (monogram + verse + player) ──
  W ".section-top {"
  W "  padding: 100px 40px 32px;"
  W "  text-align: center;"
  W "  position: relative;"
  W "  z-index: 1;"
  W "}"

  # Monogram oval
  W ".monogram {"
  W "  display: inline-flex; align-items: center; justify-content: center;"
  W "  width: 72px; height: 88px;"
  W "  border: 1.5px solid $accent;"
  W "  border-radius: 50% / 60%;"
  W "  font-family: $displayFont;"
  W "  font-size: 22px; font-weight: 500;"
  W "  color: $accent;"
  W "  letter-spacing: .05em;"
  W "  margin-bottom: 28px;"
  W "}"

  # Verse text at top
  W ".verse-top {"
  W "  font-family: $bodyFont;"
  W "  font-size: 10.5px; font-weight: 500;"
  W "  letter-spacing: .16em; text-transform: uppercase;"
  W "  color: $accent;"
  W "  line-height: 1.8;"
  W "  max-width: 320px; margin: 0 auto 28px;"
  W "}"

  # Music player bar
  W ".player {"
  W "  display: flex; align-items: center; justify-content: center; gap: 14px;"
  W "  margin: 0 auto 6px;"
  W "  max-width: 220px;"
  W "}"
  W ".player-btn {"
  W "  width: 36px; height: 36px; border-radius: 50%;"
  W "  background: $accent;"
  W "  border: none; cursor: pointer;"
  W "  display: grid; place-items: center; flex-shrink: 0;"
  W "  transition: opacity .2s;"
  W "}"
  W ".player-btn:hover { opacity: .8; }"
  W ".player-btn svg { width: 14px; height: 14px; fill: #fff; }"
  W ".player-ctrl svg { width: 16px; height: 16px; stroke: $mutedColor; fill: none; stroke-width: 1.5; cursor: pointer; }"
  W ".player-ctrl svg:hover { stroke: $accent; }"
  W ".player-label {"
  W "  font-size: 10px; letter-spacing: .22em; text-transform: uppercase;"
  W "  color: $mutedColor; margin-top: 6px; margin-bottom: 20px;"
  W "}"

  # Divider line
  W ".sep {"
  W "  width: 1px; height: 40px; background: $separatorClr;"
  W "  margin: 0 auto 28px;"
  W "}"
  W ".sep-h {"
  W "  width: 80px; height: 1px; background: $separatorClr;"
  W "  margin: 0 auto;"
  W "}"

  # Blessing
  W ".blessing {"
  W "  font-size: 11px; font-weight: 500; letter-spacing: .18em;"
  W "  text-transform: uppercase; color: $mutedColor;"
  W "  margin-bottom: 10px;"
  W "}"

  # Names
  W ".names {"
  W "  font-family: $scriptFont;"
  W "  font-size: clamp(64px, 18vw, 88px);"
  W "  line-height: 1.05;"
  W "  color: $ink;"
  W "  margin-bottom: 16px;"
  W "}"

  # Subtitle under names
  W ".subtitle {"
  W "  font-family: $displayFont;"
  W "  font-size: clamp(13px, 3vw, 16px);"
  W "  font-style: italic; letter-spacing: .08em;"
  W "  color: $mutedColor; margin-bottom: 32px;"
  W "}"

  # ── Local photo ──
  W ".local-photo {"
  W "  width: 88%; margin: 0 auto 28px;"
  W "  position: relative;"
  W "}"
  W ".local-photo img {"
  W "  width: 100%; height: auto;"
  W "  display: block;"
  W "}"

  # Date big
  W ".date-block {"
  W "  padding: 8px 40px 0;"
  W "  text-align: center;"
  W "  position: relative; z-index: 1;"
  W "}"
  W ".date-script {"
  W "  font-family: $scriptFont;"
  W "  font-size: clamp(30px, 8vw, 44px);"
  W "  color: $mutedColor;"
  W "  display: block; margin-bottom: 2px;"
  W "}"
  W ".date-main {"
  W "  font-family: $bodyFont;"
  W "  font-size: clamp(17px, 5vw, 22px);"
  W "  font-weight: 700; letter-spacing: .28em;"
  W "  text-transform: uppercase; color: $ink;"
  W "  display: block; margin-bottom: 6px;"
  W "}"
  W ".date-sub {"
  W "  font-size: 12px; letter-spacing: .22em; text-transform: uppercase;"
  W "  color: $mutedColor; display: block; margin-bottom: 28px;"
  W "}"

  # Address lines
  W ".address {"
  W "  padding: 0 40px;"
  W "  text-align: center;"
  W "  position: relative; z-index: 1;"
  W "  margin-bottom: 8px;"
  W "}"
  W ".addr-label {"
  W "  font-size: 10px; font-weight: 700; letter-spacing: .28em;"
  W "  text-transform: uppercase; color: $mutedColor;"
  W "  margin-bottom: 8px; display: block;"
  W "}"
  W ".addr-text {"
  W "  font-size: clamp(12px, 3vw, 14px); font-weight: 600;"
  W "  letter-spacing: .08em; text-transform: uppercase;"
  W "  color: $accent; line-height: 1.7;"
  W "  display: block;"
  W "}"

  # Verse box (highlighted)
  W ".verse-box {"
  W "  margin: 28px 30px;"
  W "  padding: 20px 24px;"
  W "  background: $verseBoxBg;"
  W "  border: 1px solid $verseBoxBdr;"
  W "  text-align: center;"
  W "  position: relative; z-index: 1;"
  W "}"
  W ".verse-box p {"
  W "  font-family: $displayFont;"
  W "  font-size: clamp(13px, 3.5vw, 15px);"
  W "  font-style: italic; font-weight: 600;"
  W "  color: $ink; line-height: 1.7;"
  W "}"
  W ".verse-box .ref {"
  W "  font-family: $bodyFont;"
  W "  font-size: 11px; font-weight: 700;"
  W "  letter-spacing: .2em; text-transform: uppercase;"
  W "  color: $accent; margin-top: 10px; display: block;"
  W "}"

  # ── Icon buttons ──
  W ".icons-label {"
  W "  text-align: center; padding: 0 40px 0;"
  W "  position: relative; z-index: 1;"
  W "}"
  W ".icons-label .tap {"
  W "  font-size: 11px; letter-spacing: .2em; text-transform: uppercase;"
  W "  color: $mutedColor; display: block; margin-bottom: 4px;"
  W "}"
  W ".icons-label .tap-script {"
  W "  font-family: $scriptFont;"
  W "  font-size: clamp(32px, 9vw, 46px);"
  W "  color: $ink; display: block; line-height: 1.1; margin-bottom: 28px;"
  W "}"
  W ".icons-grid {"
  W "  display: grid; grid-template-columns: 1fr 1fr;"
  W "  gap: 24px 20px; padding: 0 32px 32px;"
  W "  position: relative; z-index: 1;"
  W "}"
  W ".icon-btn {"
  W "  display: flex; flex-direction: column; align-items: center; gap: 10px;"
  W "  cursor: pointer; text-decoration: none;"
  W "}"
  W ".icon-circle {"
  W "  width: 76px; height: 76px; border-radius: 50%;"
  W "  background: $iconBg;"
  W "  border: 1.5px solid $iconBorder;"
  W "  display: grid; place-items: center;"
  W "  transition: transform .2s, background .2s;"
  W "}"
  W ".icon-btn:hover .icon-circle { transform: translateY(-3px); background: ${accent}22; }"
  W ".icon-circle svg { width: 30px; height: 30px; stroke: $accent; fill: none; stroke-width: 1.4; stroke-linecap: round; stroke-linejoin: round; }"
  W ".icon-caption {"
  W "  font-size: 10px; font-weight: 700; letter-spacing: .2em;"
  W "  text-transform: uppercase; color: $mutedColor;"
  W "  text-align: center; line-height: 1.4;"
  W "}"

  # ── Avisos section ──
  W ".avisos {"
  W "  padding: 8px 40px 32px;"
  W "  text-align: center;"
  W "  position: relative; z-index: 1;"
  W "}"
  W ".avisos-title {"
  W "  font-family: $scriptFont;"
  W "  font-size: clamp(40px, 11vw, 56px);"
  W "  color: $ink; display: block;"
  W "  margin-bottom: 20px; line-height: 1.1;"
  W "}"
  W ".aviso-text {"
  W "  font-size: clamp(13px, 3.5vw, 15px);"
  W "  line-height: 1.85; color: $ink;"
  W "  margin-bottom: 18px;"
  W "}"
  W ".aviso-text strong {"
  W "  color: $accent;"
  W "}"
  W ".esperamos {"
  W "  font-family: $scriptFont;"
  W "  font-size: clamp(40px, 11vw, 56px);"
  W "  color: $ink; display: block;"
  W "  line-height: 1.1; margin-top: 12px; margin-bottom: 0;"
  W "}"

  # ── Noivos photo ──
  W ".noivos-photo {"
  W "  position: relative; margin-top: 0;"
  W "}"
  W ".noivos-photo img {"
  W "  width: 100%; display: block;"
  W "  min-height: 400px; object-fit: cover; object-position: center top;"
  W "}"
  W ".noivos-flor-bl {"
  W "  position: absolute; bottom: -8px; left: -8px;"
  W "  width: 160px; pointer-events: none; z-index: 3;"
  W "  opacity: 0.9; transform: scaleY(-1);"
  W "}"
  W ".noivos-flor-br {"
  W "  position: absolute; bottom: -8px; right: -8px;"
  W "  width: 160px; pointer-events: none; z-index: 3;"
  W "  opacity: 0.9; transform: scale(-1);"
  W "}"

  # Responsive
  W "@media (max-width: 480px) {"
  W "  .page { max-width: 100%; }"
  W "  .icons-grid { padding: 0 20px 28px; }"
  W "  .section-top { padding: 90px 28px 28px; }"
  W "  .address, .date-block { padding-left: 28px; padding-right: 28px; }"
  W "  .verse-box { margin: 24px 18px; }"
  W "  .avisos { padding: 8px 28px 28px; }"
  W "}"

  W '</style>'
  W '</head>'
  W '<body>'
  W '<div class="page">'

  # ── Floral top corners ──
  W "  <img class=`"flor-tl`" src=`"data:image/png;base64,$florTopB64`" alt=`"`">"
  W "  <img class=`"flor-tr`" src=`"data:image/png;base64,$florTopB64`" alt=`"`">"

  # ── TOP SECTION ──
  W '  <div class="section-top">'
  W '    <div class="monogram">M &amp; L</div>'
  W '    <p class="verse-top">&ldquo;Melhor &eacute; serem dois do que um&hellip; porque se<br>um cair, o outro levanta o seu<br>companheiro.&rdquo; &mdash; Eclesiastes 4:9&#8209;12</p>'

  # Music player
  W '    <div class="player">'
  W '      <span class="player-ctrl"><svg viewBox="0 0 24 24"><polyline points="19 20 9 12 19 4"/><line x1="5" y1="19" x2="5" y2="5"/></svg></span>'
  W '      <span class="player-ctrl"><svg viewBox="0 0 24 24"><polygon points="19 20 9 12 19 4"/></svg></span>'
  W '      <button class="player-btn" onclick="togglePlay(this)" aria-label="Play">'
  W '        <svg viewBox="0 0 24 24"><polygon points="5 3 19 12 5 21"/></svg>'
  W '      </button>'
  W '      <span class="player-ctrl"><svg viewBox="0 0 24 24"><polygon points="5 4 15 12 5 20"/><line x1="19" y1="5" x2="19" y2="19"/></svg></span>'
  W '      <span class="player-ctrl"><svg viewBox="0 0 24 24"><polyline points="5 4 15 12 5 20"/><polyline points="19 4 19 20"/></svg></span>'
  W '    </div>'
  W '    <div class="player-label">Aperte o play</div>'

  W '    <div class="sep"></div>'
  W '    <p class="blessing">Com a b&ecirc;n&ccedil;&atilde;o de Deus e seus pais</p>'
  W '  </div>'

  # ── NAMES ──
  W '  <div style="text-align:center; padding: 0 20px; position:relative; z-index:1;">'
  W '    <div class="names">Mayane</div>'
  W '    <div class="names" style="margin-top:-18px">&amp;</div>'
  W '    <div class="names" style="margin-top:-18px">Lucas</div>'
  W '  </div>'
  W '  <p class="subtitle" style="text-align:center; padding:0 20px;">Convidam para a cerim&ocirc;nia de casamento</p>'

  # ── LOCAL PHOTO ──
  W "  <div class=`"local-photo`">"
  W "    <img src=`"data:image/jpeg;base64,$localB64`" alt=`"Local do casamento`">"
  W "  </div>"

  # ── DATE ──
  W '  <div class="date-block">'
  W '    <span class="date-script">a realizar-se no dia</span>'
  W '    <span class="date-main">18 de Outubro de 2026</span>'
  W '    <span class="date-sub">S&aacute;bado, &agrave;s 13h30</span>'
  W '  </div>'

  W '  <div class="sep" style="margin-bottom:24px;"></div>'

  # ── CEREMONY ADDRESS ──
  W '  <div class="address">'
  W '    <span class="addr-label">A cerim&ocirc;nia ser&aacute; realizada na</span>'
  W '    <span class="addr-text">R. Adelino Strasi, 04<br>Jardim Brasil, V&aacute;rzea Paulista &middot; SP</span>'
  W '  </div>'

  W '  <div class="sep" style="margin: 20px auto;"></div>'

  # ── RECEPTION ADDRESS ──
  W '  <div class="address">'
  W '    <span class="addr-label">A recep&ccedil;&atilde;o dos convidados ser&aacute; no</span>'
  W '    <span class="addr-text">R. Adelino Strasi, 04<br>Jardim Brasil, V&aacute;rzea Paulista &middot; SP</span>'
  W '  </div>'

  # ── VERSE BOX ──
  W '  <div class="verse-box">'
  W '    <p>&ldquo;Quem encontra uma esposa encontra algo excelente;&nbsp; recebeu uma b&ecirc;n&ccedil;&atilde;o do Senhor.&rdquo;</p>'
  W '    <span class="ref">Prov&eacute;rbios 18:22</span>'
  W '  </div>'

  W '  <div class="sep" style="margin-bottom:28px;"></div>'

  # ── ICONS LABEL ──
  W '  <div class="icons-label">'
  W '    <span class="tap">Toque nos &iacute;cones</span>'
  W '    <span class="tap-script">para acessar</span>'
  W '  </div>'

  # ── ICONS GRID ──
  W '  <div class="icons-grid">'

  # Icon 1: Location ceremony
  W '    <a class="icon-btn" href="#ceremony" title="Localiza&ccedil;&atilde;o da Cerim&ocirc;nia">'
  W '      <div class="icon-circle">'
  W '        <svg viewBox="0 0 24 24"><path d="M12 22s-8-4.5-8-11.8A8 8 0 0 1 12 2a8 8 0 0 1 8 8.2c0 7.3-8 11.8-8 11.8z"/><circle cx="12" cy="10" r="3"/></svg>'
  W '      </div>'
  W '      <span class="icon-caption">Localiza&ccedil;&atilde;o<br>da Cerim&ocirc;nia</span>'
  W '    </a>'

  # Icon 2: Location reception
  W '    <a class="icon-btn" href="#reception" title="Localiza&ccedil;&atilde;o da Recep&ccedil;&atilde;o">'
  W '      <div class="icon-circle">'
  W '        <svg viewBox="0 0 24 24"><path d="M8 22V12H16V22"/><path d="M2 22V8L12 2L22 8V22H2Z"/><path d="M12 7V12"/><circle cx="16" cy="9" r="1.5" fill="currentColor" stroke="none"/></svg>'
  W '      </div>'
  W '      <span class="icon-caption">Localiza&ccedil;&atilde;o<br>da Recep&ccedil;&atilde;o</span>'
  W '    </a>'

  # Icon 3: Site dos noivos
  W '    <a class="icon-btn" href="#" title="Site dos Noivos">'
  W '      <div class="icon-circle">'
  W '        <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><line x1="2" y1="12" x2="22" y2="12"/><path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"/></svg>'
  W '      </div>'
  W '      <span class="icon-caption">Site dos<br>Noivos</span>'
  W '    </a>'

  # Icon 4: Confirmar presença
  W '    <a class="icon-btn" href="#confirmar" title="Confirmar Presen&ccedil;a">'
  W '      <div class="icon-circle">'
  W '        <svg viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/><polyline points="9 16 11 18 15 14"/></svg>'
  W '      </div>'
  W '      <span class="icon-caption">Confirmar<br>Presen&ccedil;a</span>'
  W '    </a>'

  W '  </div>'

  W '  <div class="sep" style="margin-bottom:32px;"></div>'

  # ── AVISOS ──
  W '  <div class="avisos" id="confirmar">'
  W '    <span class="avisos-title">Avisos</span>'
  W '    <p class="aviso-text">A confirma&ccedil;&atilde;o de presen&ccedil;a &eacute; indispens&aacute;vel.<br>Confirme sua presen&ccedil;a at&eacute; o dia <strong>18/09/2026</strong>.</p>'
  W '    <p class="aviso-text"><strong>Dress code:</strong> Esporte fino.</p>'
  W '    <p class="aviso-text">Pedimos a gentileza de chegar com anteced&ecirc;ncia<br>para melhor acomoda&ccedil;&atilde;o de todos e para que possam<br>aproveitar cada momento desse dia especial conosco.</p>'
  W '  </div>'

  W '  <div style="text-align:center; position:relative; z-index:1; padding-bottom: 16px;">'
  W '    <span class="esperamos">Esperamos por<br>voc&ecirc;!</span>'
  W '  </div>'

  # ── NOIVOS PHOTO ──
  W '  <div class="noivos-photo">'
  W "    <img src=`"data:image/jpeg;base64,$noivosB64`" alt=`"Mayane e Lucas`">"
  W "    <img class=`"noivos-flor-bl`" src=`"data:image/png;base64,$florTopB64`" alt=`"`">"
  W "    <img class=`"noivos-flor-br`" src=`"data:image/png;base64,$florTopB64`" alt=`"`">"
  W '  </div>'

  W '</div>'

  # ── JS: simple audio toggle ──
  W '<script>'
  W 'function togglePlay(btn) {'
  W '  var svg = btn.querySelector("svg");'
  W '  if (btn.dataset.playing === "1") {'
  W '    svg.innerHTML = "<polygon points=\"5 3 19 12 5 21\"/>";'
  W '    btn.dataset.playing = "0";'
  W '  } else {'
  W '    svg.innerHTML = "<rect x=\"6\" y=\"4\" width=\"4\" height=\"16\"/><rect x=\"14\" y=\"4\" width=\"4\" height=\"16\"/>";'
  W '    btn.dataset.playing = "1";'
  W '  }'
  W '}'
  W '</script>'
  W '</body>'
  W '</html>'

  $outPath = Join-Path $outDir "index.html"
  [IO.File]::WriteAllText($outPath, $sb.ToString(), [Text.Encoding]::UTF8)
  $kb = [int]([IO.FileInfo]$outPath).Length / 1024
  Write-Host "OK $folder/index.html - ${kb}KB"
}

Write-Host ""
Write-Host "Done. 4 sites rebuilt."
