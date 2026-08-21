param()
$ErrorActionPreference = 'Stop'
$ROOT = (Get-Location).Path

$localB64  = [IO.File]::ReadAllText((Join-Path $ROOT ".bob\tmp_local.txt"))
$noivosB64 = [IO.File]::ReadAllText((Join-Path $ROOT ".bob\tmp_noivos.txt"))
$ftB64     = [IO.File]::ReadAllText((Join-Path $ROOT ".bob\tmp_flortop.txt"))
$flB64     = [IO.File]::ReadAllText((Join-Path $ROOT ".bob\tmp_florlat.txt"))
Write-Host "Assets loaded."

# theme array: folder, accent, accentDark, bgBody, bgSect, ink, inkSoft, overlay, gradStop, nfk
$folders  = @('v1_aquarela','v2_luxo','v3_botanico','v4_noturno')
$accents  = @('#1a4fa0','#b8963e','#2a6042','#8ab4e8')
$accentDs = @('#0d3070','#7a6028','#1a4530','#4a7dbf')
$bgBodies = @('#f0f5ff','#faf6ee','#f4faf5','#0d1525')
$bgSects  = @('#e8f0fc','#f5edda','#e8f5eb','#111e30')
$inks     = @('#0d2855','#1c1508','#122518','#dce8f8')
$inkSofts = @('#2a5298','#8c6d28','#2a6042','#8ab4e8')
$overlays = @('rgba(8,22,60,0.55)','rgba(15,10,0,0.52)','rgba(5,25,10,0.50)','rgba(5,10,25,0.42)')
$nfks     = @('Great Vibes','Italiana','Parisienne','Pinyon Script')
$bodyFonts  = @("'Raleway',sans-serif","'Jost',sans-serif","'Lato',sans-serif","'Montserrat',sans-serif")
$serifFonts = @("'Cormorant Garamond',serif","'Cormorant Garamond',serif","'Playfair Display',serif","'Cormorant Garamond',serif")
$scriptFonts= @("'Great Vibes',cursive","'Italiana',serif","'Parisienne',cursive","'Pinyon Script',cursive")
$fontUrls   = @(
    'https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,600;1,400;1,600&family=Great+Vibes&family=Raleway:wght@300;400;500;600;700&display=swap',
    'https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,500;0,600;1,400&family=Italiana&family=Jost:wght@300;400;500;600&display=swap',
    'https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,500;0,700;1,400;1,500&family=Parisienne&family=Lato:wght@300;400;700&display=swap',
    'https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,600;1,400&family=Pinyon+Script&family=Montserrat:wght@300;400;500;600&display=swap'
)

for ($i = 0; $i -lt 4; $i++) {
    $folder     = $folders[$i]
    $accent     = $accents[$i]
    $accentD    = $accentDs[$i]
    $bgBody     = $bgBodies[$i]
    $bgSect     = $bgSects[$i]
    $ink        = $inks[$i]
    $inkSoft    = $inkSofts[$i]
    $overlay    = $overlays[$i]
    $nfk        = $nfks[$i]
    $bodyFont   = $bodyFonts[$i]
    $serifFont  = $serifFonts[$i]
    $scriptFont = $scriptFonts[$i]
    $fontUrl    = $fontUrls[$i]
    $isDark     = ($folder -eq 'v4_noturno')

    if ($isDark) {
        $muted       = 'rgba(220,232,248,0.55)'
        $divClr      = 'rgba(138,180,232,0.22)'
        $cardBg      = 'rgba(255,255,255,0.05)'
        $cardBdr     = 'rgba(138,180,232,0.18)'
        $iconBg      = 'rgba(138,180,232,0.12)'
        $iconBdr     = 'rgba(138,180,232,0.30)'
        $vBoxBg      = 'rgba(138,180,232,0.08)'
        $vBoxBdr     = 'rgba(138,180,232,0.25)'
        $addrClr     = '#8ab4e8'
        $pBtnBg      = '#8ab4e8'
        $pBtnClr     = '#0d1525'
        $gradStop    = "linear-gradient(180deg,rgba(13,21,37,0) 0%,rgba(13,21,37,1) 18%)"
        $noivosGrad  = "linear-gradient(to bottom,rgba(13,21,37,1),transparent)"
    } else {
        $muted       = 'rgba(0,0,0,0.42)'
        $divClr      = 'rgba(0,0,0,0.10)'
        $cardBg      = 'rgba(255,255,255,0.70)'
        $cardBdr     = "${accent}28"
        $iconBg      = "${accent}18"
        $iconBdr     = "${accent}40"
        $vBoxBg      = "${accent}10"
        $vBoxBdr     = "${accent}35"
        $addrClr     = $accent
        $pBtnBg      = $accent
        $pBtnClr     = '#ffffff'
        $rr = [Convert]::ToInt32($bgBody.Substring(1,2),16)
        $rg = [Convert]::ToInt32($bgBody.Substring(3,2),16)
        $rb = [Convert]::ToInt32($bgBody.Substring(5,2),16)
        $gradStop    = "linear-gradient(180deg,rgba($rr,$rg,$rb,0) 0%,rgba($rr,$rg,$rb,1) 18%)"
        $noivosGrad  = "linear-gradient(to bottom,rgba($rr,$rg,$rb,1),transparent)"
    }

    $outDir = Join-Path $ROOT $folder
    if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Force -Path $outDir | Out-Null }

    $css = @"
*,*::before,*::after{margin:0;padding:0;box-sizing:border-box;}
html{scroll-behavior:smooth;-webkit-text-size-adjust:100%;}
body{background:$bgBody;color:$ink;font-family:$bodyFont;-webkit-font-smoothing:antialiased;overflow-x:hidden;}
a{color:inherit;text-decoration:none;}
img{display:block;}

/* HERO */
.hero{position:relative;width:100%;height:100svh;min-height:620px;display:flex;flex-direction:column;align-items:center;justify-content:flex-end;overflow:hidden;}
.hero-bg{position:absolute;inset:0;width:100%;height:100%;object-fit:cover;object-position:center 35%;z-index:0;}
.hero-ov{position:absolute;inset:0;z-index:1;background:$overlay;}
.hero-fd{position:absolute;bottom:0;left:0;right:0;height:42%;z-index:2;background:$gradStop;}
.hero-ftl{position:absolute;top:-10px;left:-10px;width:min(280px,42vw);z-index:4;pointer-events:none;opacity:.92;}
.hero-ftr{position:absolute;top:-10px;right:-10px;width:min(280px,42vw);z-index:4;pointer-events:none;opacity:.92;transform:scaleX(-1);}
.hero-body{position:relative;z-index:5;text-align:center;padding:0 24px 64px;width:100%;max-width:720px;}
.hero-mono{display:inline-flex;align-items:center;justify-content:center;width:78px;height:98px;border:1.5px solid rgba(255,255,255,.75);border-radius:50%/55%;margin-bottom:22px;font-family:$serifFont;font-size:20px;font-weight:500;color:#fff;letter-spacing:.1em;text-shadow:0 1px 8px rgba(0,0,0,.5);backdrop-filter:blur(6px);-webkit-backdrop-filter:blur(6px);background:rgba(255,255,255,.12);}
.hero-bless{font-size:11px;letter-spacing:.32em;text-transform:uppercase;color:rgba(255,255,255,.72);margin-bottom:14px;display:block;}
.hero-name{font-family:$scriptFont;font-size:clamp(76px,17vw,124px);line-height:.92;color:#fff;text-shadow:0 4px 36px rgba(0,0,0,.55);display:block;}
.hero-amp{font-family:$scriptFont;font-size:clamp(54px,13vw,90px);line-height:1;color:rgba(255,255,255,.85);text-shadow:0 3px 22px rgba(0,0,0,.45);display:block;margin:-12px 0;}
.hero-tag{font-family:$serifFont;font-style:italic;font-size:clamp(15px,3.5vw,20px);color:rgba(255,255,255,.80);letter-spacing:.07em;margin-top:16px;display:block;}
.hero-scr{position:absolute;bottom:20px;left:50%;transform:translateX(-50%);z-index:5;display:flex;flex-direction:column;align-items:center;gap:5px;color:rgba(255,255,255,.55);}
.hero-scr span{font-size:10px;letter-spacing:.24em;text-transform:uppercase;}
.hero-scr svg{width:20px;height:20px;animation:bob 2.2s ease-in-out infinite;}
@keyframes bob{0%,100%{transform:translateY(0)}50%{transform:translateY(7px)}}

/* VERSE TOP */
.verse-top{background:$bgBody;padding:56px 32px 52px;text-align:center;position:relative;}
.verse-top::before{content:'';position:absolute;top:0;left:50%;transform:translateX(-50%);width:1px;height:42px;background:$divClr;}
.verse-top p{font-family:$serifFont;font-style:italic;font-size:clamp(16px,3.8vw,22px);line-height:1.78;color:$ink;max-width:580px;margin:0 auto 16px;}
.verse-top .vref{font-size:11px;font-weight:700;letter-spacing:.3em;text-transform:uppercase;color:$accent;}

/* PLAYER */
.player-sec{background:$bgSect;padding:30px 20px 34px;text-align:center;border-top:1px solid $divClr;border-bottom:1px solid $divClr;}
.player{display:flex;align-items:center;justify-content:center;gap:20px;margin-bottom:10px;}
.pc{cursor:pointer;color:$muted;transition:.2s;}
.pc:hover{color:$accent;}
.pc svg{width:18px;height:18px;stroke:currentColor;fill:none;stroke-width:1.6;stroke-linecap:round;}
.pb{width:50px;height:50px;border-radius:50%;background:$pBtnBg;border:none;cursor:pointer;display:grid;place-items:center;flex-shrink:0;box-shadow:0 6px 24px ${accent}50;transition:.2s;}
.pb:hover{transform:scale(1.07);}
.pb svg{width:16px;height:16px;fill:$pBtnClr;}
.plbl{font-size:10px;letter-spacing:.3em;text-transform:uppercase;color:$muted;}

/* DATE STRIP */
.date-sec{background:$bgBody;padding:64px 24px 60px;text-align:center;position:relative;}
.date-sec::before,.date-sec::after{content:'';position:absolute;top:50%;transform:translateY(-50%);width:clamp(36px,7vw,110px);height:1px;background:$divClr;}
.date-sec::before{left:clamp(14px,4vw,72px);}
.date-sec::after{right:clamp(14px,4vw,72px);}
.ds-script{font-family:$scriptFont;font-size:clamp(26px,6vw,38px);color:$muted;display:block;margin-bottom:8px;}
.ds-num{font-family:$serifFont;font-size:clamp(96px,20vw,148px);line-height:.88;color:$accent;font-weight:300;display:block;margin-bottom:6px;}
.ds-month{font-size:clamp(14px,3.4vw,18px);font-weight:700;letter-spacing:.4em;text-transform:uppercase;color:$ink;display:block;margin-bottom:10px;}
.ds-sub{font-size:12px;letter-spacing:.22em;text-transform:uppercase;color:$muted;display:block;}

/* ADDRESS */
.addr-sec{background:$bgSect;padding:56px 28px 60px;text-align:center;position:relative;overflow:hidden;}
.addr-fl-l{position:absolute;left:-50px;top:50%;transform:translateY(-50%);width:clamp(130px,20vw,190px);opacity:.07;pointer-events:none;filter:saturate(0);}
.addr-fl-r{position:absolute;right:-50px;top:50%;transform:translateY(-50%) scaleX(-1);width:clamp(130px,20vw,190px);opacity:.07;pointer-events:none;filter:saturate(0);}
.addr-block{margin-bottom:40px;position:relative;z-index:1;}
.addr-ey{font-size:10px;font-weight:700;letter-spacing:.32em;text-transform:uppercase;color:$muted;display:block;margin-bottom:14px;}
.addr-txt{font-size:clamp(13px,3vw,16px);font-weight:600;letter-spacing:.08em;text-transform:uppercase;color:$addrClr;line-height:1.9;display:block;}
.addr-div{display:flex;align-items:center;gap:14px;justify-content:center;margin:0 auto 40px;max-width:260px;position:relative;z-index:1;}
.addr-div::before,.addr-div::after{content:'';flex:1;height:1px;background:$divClr;}
.addr-dot{width:6px;height:6px;border-radius:50%;background:${accent}60;flex-shrink:0;}

/* VERSE BOX */
.vbox-sec{background:$bgBody;padding:52px 28px 56px;text-align:center;}
.vbox{max-width:540px;margin:0 auto;padding:34px 38px;border:1px solid $vBoxBdr;background:$vBoxBg;position:relative;}
.vbox::before{content:'\2736';position:absolute;top:-13px;left:50%;transform:translateX(-50%);background:$bgBody;padding:0 14px;color:$accent;font-size:14px;line-height:1;}
.vbox p{font-family:$serifFont;font-style:italic;font-size:clamp(14px,3.4vw,17px);line-height:1.82;color:$ink;margin-bottom:18px;}
.vbox .vref{font-size:11px;font-weight:700;letter-spacing:.28em;text-transform:uppercase;color:$accent;}

/* ICONS */
.icons-sec{background:$bgSect;padding:60px 24px 64px;text-align:center;position:relative;overflow:hidden;}
.icons-ey{font-size:11px;letter-spacing:.32em;text-transform:uppercase;color:$muted;display:block;margin-bottom:8px;}
.icons-sc{font-family:$scriptFont;font-size:clamp(42px,10vw,60px);color:$ink;display:block;line-height:1.1;margin-bottom:48px;}
.icons-grid{display:grid;grid-template-columns:1fr 1fr;gap:clamp(28px,5vw,52px) clamp(24px,6vw,64px);max-width:440px;margin:0 auto;}
.icon-it{display:flex;flex-direction:column;align-items:center;gap:14px;text-decoration:none;cursor:pointer;}
.icon-ring{width:86px;height:86px;border-radius:50%;background:$iconBg;border:1.5px solid $iconBdr;display:grid;place-items:center;transition:transform .25s,background .25s,box-shadow .25s;position:relative;}
.icon-it:hover .icon-ring{transform:translateY(-5px);background:${accent}22;box-shadow:0 14px 36px ${accent}30;}
.icon-ring svg{width:32px;height:32px;stroke:$accent;fill:none;stroke-width:1.3;stroke-linecap:round;stroke-linejoin:round;}
.icon-lbl{font-size:10.5px;font-weight:700;letter-spacing:.22em;text-transform:uppercase;color:$muted;text-align:center;line-height:1.5;}

/* AVISOS */
.avisos-sec{background:$bgBody;padding:64px 32px 60px;text-align:center;position:relative;}
.avisos-sec::before{content:'';position:absolute;top:0;left:50%;transform:translateX(-50%);width:1px;height:44px;background:$divClr;}
.av-title{font-family:$scriptFont;font-size:clamp(52px,13vw,72px);color:$ink;display:block;line-height:1.05;margin-bottom:36px;}
.av-item{max-width:500px;margin:0 auto 22px;}
.av-item p{font-size:clamp(14px,3.5vw,16px);line-height:1.95;color:$ink;}
.av-item strong{color:$accent;font-weight:700;}
.esp-sc{font-family:$scriptFont;font-size:clamp(46px,12vw,66px);color:$ink;display:block;line-height:1.15;margin-top:44px;}

/* NOIVOS */
.noivos-sec{position:relative;width:100%;overflow:hidden;}
.noivos-sec img.nimg{width:100%;height:clamp(520px,72vh,820px);object-fit:cover;object-position:center top;display:block;}
.noivos-gtop{position:absolute;top:0;left:0;right:0;height:32%;background:$noivosGrad;z-index:2;pointer-events:none;}
.nf-bl{position:absolute;bottom:-14px;left:-14px;width:min(210px,36vw);z-index:4;pointer-events:none;opacity:.90;transform:scaleY(-1);}
.nf-br{position:absolute;bottom:-14px;right:-14px;width:min(210px,36vw);z-index:4;pointer-events:none;opacity:.90;transform:scale(-1);}

/* FOOTER */
.footer{background:$bgSect;padding:38px 20px 30px;text-align:center;border-top:1px solid $divClr;}
.ft-names{font-family:$scriptFont;font-size:clamp(34px,8vw,50px);color:$accent;display:block;margin-bottom:10px;}
.ft-date{font-size:11px;letter-spacing:.34em;text-transform:uppercase;color:$muted;display:block;}

/* ANIMATE */
.fade-up{opacity:0;transform:translateY(32px);transition:opacity .75s ease,transform .75s ease;}
.fade-up.vis{opacity:1;transform:none;}

@media(max-width:480px){
  .date-sec::before,.date-sec::after{display:none;}
  .vbox{padding:24px 20px;}
  .icons-grid{gap:22px 18px;}
  .icon-ring{width:74px;height:74px;}
  .icon-ring svg{width:26px;height:26px;}
}
"@

    $html = @"
<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Mayane &amp; Lucas &mdash; Casamento 2026</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="$fontUrl" rel="stylesheet">
<style>
$css
</style>
</head>
<body>

<!-- HERO -->
<section class="hero">
  <img class="hero-bg" src="data:image/jpeg;base64,$localB64" alt="">
  <div class="hero-ov"></div>
  <div class="hero-fd"></div>
  <img class="hero-ftl" src="data:image/png;base64,$ftB64" alt="">
  <img class="hero-ftr" src="data:image/png;base64,$ftB64" alt="">
  <div class="hero-body">
    <div class="hero-mono">M &amp; L</div>
    <span class="hero-bless">Com a b&ecirc;n&ccedil;&atilde;o de Deus e seus pais</span>
    <span class="hero-name">Mayane</span>
    <span class="hero-amp">&amp;</span>
    <span class="hero-name">Lucas</span>
    <span class="hero-tag">Convidam para a cerim&ocirc;nia de casamento</span>
  </div>
  <div class="hero-scr">
    <span>Rolar</span>
    <svg viewBox="0 0 24 24" fill="none" stroke="rgba(255,255,255,0.55)" stroke-width="2" stroke-linecap="round"><polyline points="6 9 12 15 18 9"/></svg>
  </div>
</section>

<!-- VERSE TOP -->
<section class="verse-top fade-up">
  <p>&ldquo;Melhor &eacute; serem dois do que um, porque t&ecirc;m melhor paga do seu trabalho; porque se um cair, o outro levanta o seu companheiro.&rdquo;</p>
  <span class="vref">Eclesiastes 4:9&ndash;12</span>
</section>

<!-- PLAYER -->
<section class="player-sec fade-up">
  <div class="player">
    <span class="pc"><svg viewBox="0 0 24 24"><polyline points="19 20 9 12 19 4"/><line x1="5" y1="19" x2="5" y2="5"/></svg></span>
    <span class="pc"><svg viewBox="0 0 24 24"><polygon points="19 20 9 12 19 4"/></svg></span>
    <button class="pb" onclick="togglePlay(this)" aria-label="Play"><svg viewBox="0 0 24 24"><polygon points="5 3 19 12 5 21"/></svg></button>
    <span class="pc"><svg viewBox="0 0 24 24"><polygon points="5 4 15 12 5 20"/><line x1="19" y1="5" x2="19" y2="19"/></svg></span>
    <span class="pc"><svg viewBox="0 0 24 24"><polyline points="5 4 15 12 5 20"/><polyline points="19 4 19 20"/></svg></span>
  </div>
  <div class="plbl">Aperte o play</div>
</section>

<!-- DATE -->
<section class="date-sec fade-up">
  <span class="ds-script">a realizar&#8209;se no dia</span>
  <span class="ds-num">18</span>
  <span class="ds-month">Outubro &middot; 2026</span>
  <span class="ds-sub">S&aacute;bado &middot; &agrave;s 13h30</span>
</section>

<!-- ADDRESSES -->
<section class="addr-sec fade-up">
  <img class="addr-fl-l" src="data:image/png;base64,$flB64" alt="">
  <img class="addr-fl-r" src="data:image/png;base64,$flB64" alt="">
  <div class="addr-block">
    <span class="addr-ey">A cerim&ocirc;nia ser&aacute; realizada na</span>
    <span class="addr-txt">R. Adelino Strasi, 04<br>Jardim Brasil &mdash; V&aacute;rzea Paulista &middot; SP</span>
  </div>
  <div class="addr-div"><div class="addr-dot"></div></div>
  <div class="addr-block">
    <span class="addr-ey">A recep&ccedil;&atilde;o dos convidados ser&aacute; no</span>
    <span class="addr-txt">R. Adelino Strasi, 04<br>Jardim Brasil &mdash; V&aacute;rzea Paulista &middot; SP</span>
  </div>
</section>

<!-- VERSE BOX -->
<section class="vbox-sec fade-up">
  <div class="vbox">
    <p>&ldquo;Quem encontra uma esposa encontra algo excelente; recebeu uma b&ecirc;n&ccedil;&atilde;o do Senhor.&rdquo;</p>
    <span class="vref">Prov&eacute;rbios 18:22</span>
  </div>
</section>

<!-- ICONS -->
<section class="icons-sec fade-up">
  <span class="icons-ey">Toque nos &iacute;cones</span>
  <span class="icons-sc">para acessar</span>
  <div class="icons-grid">
    <a class="icon-it" href="#">
      <div class="icon-ring"><svg viewBox="0 0 24 24"><path d="M12 22s-8-4.5-8-11.8A8 8 0 0 1 12 2a8 8 0 0 1 8 8.2c0 7.3-8 11.8-8 11.8z"/><circle cx="12" cy="10" r="2.8"/></svg></div>
      <span class="icon-lbl">Localiza&ccedil;&atilde;o<br>da Cerim&ocirc;nia</span>
    </a>
    <a class="icon-it" href="#">
      <div class="icon-ring"><svg viewBox="0 0 24 24"><path d="M3 22V8l9-6 9 6v14H3z"/><path d="M9 22V12h6v10"/></svg></div>
      <span class="icon-lbl">Localiza&ccedil;&atilde;o<br>da Recep&ccedil;&atilde;o</span>
    </a>
    <a class="icon-it" href="#">
      <div class="icon-ring"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><line x1="2" y1="12" x2="22" y2="12"/><path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"/></svg></div>
      <span class="icon-lbl">Site dos<br>Noivos</span>
    </a>
    <a class="icon-it" href="#avisos">
      <div class="icon-ring"><svg viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/><polyline points="9 16 11 18 15 14"/></svg></div>
      <span class="icon-lbl">Confirmar<br>Presen&ccedil;a</span>
    </a>
  </div>
</section>

<!-- AVISOS -->
<section class="avisos-sec fade-up" id="avisos">
  <span class="av-title">Avisos</span>
  <div class="av-item"><p>A confirma&ccedil;&atilde;o de presen&ccedil;a &eacute; indispens&aacute;vel.<br>Confirme sua presen&ccedil;a at&eacute; o dia <strong>18/09/2026</strong>.</p></div>
  <div class="av-item"><p><strong>Dress code:</strong> Esporte fino.</p></div>
  <div class="av-item"><p>Pedimos a gentileza de chegar com anteced&ecirc;ncia para melhor acomoda&ccedil;&atilde;o de todos e para que possam aproveitar cada momento desse dia especial conosco.</p></div>
  <span class="esp-sc">Esperamos por<br>voc&ecirc;!</span>
</section>

<!-- NOIVOS -->
<section class="noivos-sec">
  <div class="noivos-gtop"></div>
  <img class="nimg" src="data:image/jpeg;base64,$noivosB64" alt="Mayane e Lucas">
  <img class="nf-bl" src="data:image/png;base64,$ftB64" alt="">
  <img class="nf-br" src="data:image/png;base64,$ftB64" alt="">
</section>

<!-- FOOTER -->
<footer class="footer">
  <span class="ft-names">Mayane &amp; Lucas</span>
  <span class="ft-date">18 &middot; Outubro &middot; 2026</span>
</footer>

<script>
function togglePlay(b){var s=b.querySelector("svg");if(b.dataset.p==="1"){s.innerHTML='<polygon points="5 3 19 12 5 21"/>';b.dataset.p="0";}else{s.innerHTML='<rect x="6" y="4" width="4" height="16"/><rect x="14" y="4" width="4" height="16"/>';b.dataset.p="1";}}
(function(){var o=new IntersectionObserver(function(es){es.forEach(function(e){if(e.isIntersecting){e.target.classList.add("vis");o.unobserve(e.target);}});},{threshold:0.07});document.querySelectorAll(".fade-up").forEach(function(el){o.observe(el);});})();
</script>
</body>
</html>
"@

    $outPath = Join-Path $outDir "index.html"
    [IO.File]::WriteAllText($outPath, $html, [Text.Encoding]::UTF8)
    $kb = [math]::Round(([IO.FileInfo]$outPath).Length / 1024, 1)
    Write-Host "OK $folder/index.html - ${kb}KB"
}

Write-Host "Done. 4 elegant sites built."
