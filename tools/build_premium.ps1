param()
$ErrorActionPreference = 'Stop'
$ROOT = (Get-Location).Path

$localB64  = [IO.File]::ReadAllText((Join-Path $ROOT ".bob\tmp_local.txt"))
$noivosB64 = [IO.File]::ReadAllText((Join-Path $ROOT ".bob\tmp_noivos.txt"))
$ftB64     = [IO.File]::ReadAllText((Join-Path $ROOT ".bob\tmp_flortop.txt"))
$flB64     = [IO.File]::ReadAllText((Join-Path $ROOT ".bob\tmp_florlat.txt"))
Write-Host "Assets loaded."

# 4 versions: each gets accent colors from the real palette extracted from palheta_cores.jpeg
# v1=azul royal, v2=dourado, v3=verde sage, v4=noturno azul profundo
$folders    = @('v1_aquarela','v2_luxo','v3_botanico','v4_noturno')
$accents    = @('#2975D9','#c9a84c','#4a9e6b','#5EADF2')
$accent2s   = @('#0644BF','#a07830','#2d6e4a','#2975D9')
$glassClrs  = @('rgba(6,68,191,0.18)','rgba(201,168,76,0.18)','rgba(74,158,107,0.18)','rgba(41,117,217,0.18)')
$glassBdrs  = @('rgba(141,195,242,0.35)','rgba(201,168,76,0.35)','rgba(74,158,107,0.35)','rgba(94,173,242,0.35)')
$nfks       = @('Great Vibes','Italiana','Parisienne','Pinyon Script')
$scriptFonts= @("'Great Vibes',cursive","'Italiana',serif","'Parisienne',cursive","'Pinyon Script',cursive")
$serifFonts = @("'Cormorant Garamond',serif","'Cormorant Garamond',serif","'Playfair Display',serif","'Cormorant Garamond',serif")
$bodyFonts  = @("'Raleway',sans-serif","'Jost',sans-serif","'Lato',sans-serif","'Montserrat',sans-serif")
$fontUrls   = @(
    'https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,600;1,400;1,600&family=Great+Vibes&family=Raleway:wght@300;400;500;600;700&display=swap',
    'https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,500;0,600;1,400;1,600&family=Italiana&family=Jost:wght@300;400;500;600&display=swap',
    'https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,500;0,700;1,400;1,500&family=Parisienne&family=Lato:wght@300;400;700&display=swap',
    'https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,600;1,400;1,600&family=Pinyon+Script&family=Montserrat:wght@300;400;500;600&display=swap'
)

for ($i = 0; $i -lt 4; $i++) {
    $folder     = $folders[$i]
    $accent     = $accents[$i]
    $accent2    = $accent2s[$i]
    $glassClr   = $glassClrs[$i]
    $glassBdr   = $glassBdrs[$i]
    $nfk        = $nfks[$i]
    $scriptFont = $scriptFonts[$i]
    $serifFont  = $serifFonts[$i]
    $bodyFont   = $bodyFonts[$i]
    $fontUrl    = $fontUrls[$i]

    $outDir = Join-Path $ROOT $folder
    if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Force -Path $outDir | Out-Null }

    $html = @"
<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Mayane &amp; Lucas &mdash; Casamento 18.10.2026</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="$fontUrl" rel="stylesheet">
<style>
/* ═══ RESET ═══ */
*,*::before,*::after{margin:0;padding:0;box-sizing:border-box;}
html{scroll-behavior:smooth;-webkit-text-size-adjust:100%;}
body{
  font-family:$bodyFont;
  -webkit-font-smoothing:antialiased;
  overflow-x:hidden;
  background:#000;
  color:#fff;
}
a{color:inherit;text-decoration:none;}

/* ═══ SITE BG — local.jpeg fixed full screen ═══ */
.site-bg{
  position:fixed;inset:0;z-index:0;
  background-image:url("data:image/jpeg;base64,$localB64");
  background-size:cover;
  background-position:center center;
  background-attachment:fixed;
  filter:brightness(0.55) saturate(1.1);
  will-change:transform;
}
/* subtle parallax via JS */
.site-bg-inner{
  position:absolute;inset:-8%;
  background-image:inherit;
  background-size:cover;
  background-position:center;
  filter:inherit;
}

/* ═══ PARTICLES ═══ */
#particles{position:fixed;inset:0;z-index:1;pointer-events:none;overflow:hidden;}
.particle{
  position:absolute;border-radius:50%;
  background:rgba(255,255,255,0.55);
  animation:drift linear infinite;
  will-change:transform,opacity;
}
@keyframes drift{
  0%  {transform:translateY(100vh) scale(0);   opacity:0;}
  10% {opacity:1;}
  90% {opacity:0.6;}
  100%{transform:translateY(-10vh) scale(1.2); opacity:0;}
}

/* ═══ GLOBAL PAGE WRAPPER ═══ */
.page{position:relative;z-index:2;}

/* ═══ GLASS helper ═══ */
.glass{
  background:$glassClr;
  backdrop-filter:blur(18px) saturate(1.6);
  -webkit-backdrop-filter:blur(18px) saturate(1.6);
  border:1px solid $glassBdr;
  box-shadow:0 8px 40px rgba(0,0,0,0.35), inset 0 1px 0 rgba(255,255,255,0.15);
}

/* ═══ FLORAL CORNERS ═══ */
.flor-tl{position:absolute;top:-14px;left:-14px;width:min(300px,44vw);z-index:10;pointer-events:none;opacity:0.95;filter:drop-shadow(0 4px 16px rgba(0,0,0,0.3));}
.flor-tr{position:absolute;top:-14px;right:-14px;width:min(300px,44vw);z-index:10;pointer-events:none;opacity:0.95;transform:scaleX(-1);filter:drop-shadow(0 4px 16px rgba(0,0,0,0.3));}
.flor-bl{position:absolute;bottom:-14px;left:-14px;width:min(240px,36vw);z-index:10;pointer-events:none;opacity:0.90;transform:scaleY(-1);}
.flor-br{position:absolute;bottom:-14px;right:-14px;width:min(240px,36vw);z-index:10;pointer-events:none;opacity:0.90;transform:scale(-1);}

/* ═══ SECTION 1: HERO ═══ */
.hero{
  min-height:100svh;
  display:flex;flex-direction:column;
  align-items:center;justify-content:center;
  position:relative;
  padding:80px 20px 100px;
  text-align:center;
}
.hero-monogram{
  display:inline-flex;align-items:center;justify-content:center;
  width:84px;height:104px;
  border:1.5px solid rgba(255,255,255,0.7);
  border-radius:50%/55%;
  font-family:$serifFont;font-size:22px;font-weight:400;
  color:#fff;letter-spacing:.12em;
  background:rgba(255,255,255,0.1);
  backdrop-filter:blur(8px);-webkit-backdrop-filter:blur(8px);
  margin-bottom:28px;
  opacity:0;transform:translateY(-20px);
}
.hero-blessing{
  display:block;font-size:11px;font-weight:500;
  letter-spacing:.38em;text-transform:uppercase;
  color:rgba(255,255,255,0.75);
  margin-bottom:16px;
  opacity:0;
}
.hero-name{
  display:block;
  font-family:$scriptFont;
  font-size:clamp(80px,18vw,140px);
  line-height:0.92;
  color:#fff;
  text-shadow:0 4px 40px rgba(0,0,0,0.6), 0 0 80px rgba(255,255,255,0.15);
  opacity:0;transform:translateY(30px);
}
.hero-amp{
  display:block;
  font-family:$scriptFont;
  font-size:clamp(56px,13vw,96px);
  line-height:1.05;
  color:rgba(255,255,255,0.82);
  text-shadow:0 3px 24px rgba(0,0,0,0.5);
  margin:-14px 0;
  opacity:0;
}
.hero-tagline{
  display:block;
  font-family:$serifFont;font-style:italic;
  font-size:clamp(16px,3.8vw,22px);
  color:rgba(255,255,255,0.80);
  letter-spacing:.08em;margin-top:22px;
  opacity:0;
}
/* animated ring behind monogram */
.hero-ring{
  position:absolute;
  width:200px;height:200px;border-radius:50%;
  border:1px solid rgba(255,255,255,0.12);
  animation:ringPulse 3.5s ease-in-out infinite;
  pointer-events:none;top:50%;left:50%;
  margin-left:-100px;margin-top:-280px;
}
@keyframes ringPulse{0%,100%{transform:scale(1);opacity:.4}50%{transform:scale(1.12);opacity:.12}}
.hero-scroll-hint{
  position:absolute;bottom:28px;left:50%;transform:translateX(-50%);
  display:flex;flex-direction:column;align-items:center;gap:8px;
  color:rgba(255,255,255,0.5);
  animation:fadeInUp 2s 2.5s ease both;
}
.hero-scroll-hint span{font-size:10px;letter-spacing:.3em;text-transform:uppercase;}
.hero-scroll-hint svg{width:22px;height:22px;animation:arrowBounce 1.8s ease-in-out infinite;}
@keyframes arrowBounce{0%,100%{transform:translateY(0)}50%{transform:translateY(8px)}}
@keyframes fadeInUp{from{opacity:0;transform:translateX(-50%) translateY(12px)}to{opacity:1;transform:translateX(-50%) translateY(0)}}

/* ═══ GLASS SECTIONS ═══ */
.glass-section{
  padding:clamp(52px,8vw,88px) clamp(20px,6vw,80px);
  position:relative;
}
.glass-section .inner{
  max-width:720px;margin:0 auto;
  text-align:center;
}

/* ═══ SECTION: VERSE ═══ */
.verse-section .glass{
  padding:clamp(36px,5vw,60px) clamp(28px,5vw,64px);
  position:relative;overflow:hidden;
}
.verse-section .glass::before{
  content:'';position:absolute;
  top:-60px;right:-60px;
  width:200px;height:200px;border-radius:50%;
  background:radial-gradient(circle,$accent 0%,transparent 70%);
  opacity:0.12;
}
.verse-quote{
  font-family:$serifFont;font-style:italic;
  font-size:clamp(17px,3.8vw,23px);line-height:1.8;
  color:rgba(255,255,255,0.92);
  margin-bottom:20px;
}
.verse-ref{
  font-size:11px;font-weight:700;letter-spacing:.32em;
  text-transform:uppercase;color:$accent;
}

/* ═══ PLAYER ═══ */
.player-section{padding:0 clamp(20px,6vw,80px) clamp(40px,6vw,72px);}
.player-glass{
  max-width:480px;margin:0 auto;
  padding:28px 32px;
  display:flex;flex-direction:column;align-items:center;gap:16px;
}
.player-row{display:flex;align-items:center;gap:22px;}
.pc{
  cursor:pointer;color:rgba(255,255,255,0.55);
  transition:color .2s,transform .2s;
  background:none;border:none;padding:4px;
}
.pc:hover{color:$accent;transform:scale(1.15);}
.pc svg{width:20px;height:20px;stroke:currentColor;fill:none;stroke-width:1.6;stroke-linecap:round;}
.pb{
  width:56px;height:56px;border-radius:50%;
  background:linear-gradient(135deg,$accent,$accent2);
  border:none;cursor:pointer;
  display:grid;place-items:center;
  box-shadow:0 6px 28px rgba(0,0,0,0.45), 0 0 0 0 ${accent}60;
  transition:transform .2s,box-shadow .2s;
  animation:pbPulse 2.5s ease-in-out infinite;
}
@keyframes pbPulse{0%,100%{box-shadow:0 6px 28px rgba(0,0,0,0.45),0 0 0 0 ${accent}60}50%{box-shadow:0 6px 28px rgba(0,0,0,0.45),0 0 0 12px ${accent}00}}
.pb:hover{transform:scale(1.08);}
.pb svg{width:18px;height:18px;fill:#fff;}
.plbl{font-size:10px;letter-spacing:.32em;text-transform:uppercase;color:rgba(255,255,255,0.45);}

/* ═══ DATE SECTION ═══ */
.date-section{padding:clamp(52px,8vw,96px) 20px;}
.date-glass{
  max-width:620px;margin:0 auto;
  padding:clamp(40px,6vw,72px) clamp(28px,5vw,60px);
  position:relative;overflow:hidden;
}
.date-glass::after{
  content:'';position:absolute;inset:0;pointer-events:none;
  background:radial-gradient(ellipse 60% 50% at 50% 50%,rgba(255,255,255,0.04) 0%,transparent 70%);
}
.date-script{
  font-family:$scriptFont;font-size:clamp(28px,6vw,40px);
  color:rgba(255,255,255,0.6);display:block;margin-bottom:10px;
}
.date-number{
  font-family:$serifFont;font-size:clamp(110px,22vw,170px);
  font-weight:300;line-height:0.85;
  color:#fff;display:block;
  text-shadow:0 4px 48px rgba(0,0,0,0.5);
  position:relative;
}
.date-number::after{
  content:attr(data-month);
  display:block;font-family:$bodyFont;font-size:clamp(13px,3vw,17px);
  font-weight:700;letter-spacing:.42em;text-transform:uppercase;
  color:$accent;margin-top:16px;
  text-shadow:none;
}
.date-sub{
  font-size:12px;letter-spacing:.26em;text-transform:uppercase;
  color:rgba(255,255,255,0.55);display:block;margin-top:10px;
}
/* Countdown */
.countdown{
  display:flex;gap:clamp(16px,4vw,36px);
  justify-content:center;margin-top:28px;
  flex-wrap:wrap;
}
.cd-unit{display:flex;flex-direction:column;align-items:center;gap:4px;}
.cd-num{
  font-family:$serifFont;font-size:clamp(40px,9vw,68px);
  line-height:1;color:#fff;font-weight:300;
}
.cd-lbl{font-size:10px;letter-spacing:.28em;text-transform:uppercase;color:$accent;}
.cd-sep{
  font-family:$serifFont;font-size:clamp(32px,7vw,56px);
  color:rgba(255,255,255,0.3);align-self:flex-start;padding-top:2px;
}

/* ═══ ADDRESS SECTION ═══ */
.addr-section{padding:0 clamp(20px,6vw,80px) clamp(52px,8vw,88px);}
.addr-glass{max-width:620px;margin:0 auto;padding:clamp(36px,5vw,60px) clamp(28px,5vw,56px);}
.addr-ornament{
  display:flex;align-items:center;gap:16px;
  margin-bottom:clamp(28px,4vw,44px);
}
.addr-ornament::before,.addr-ornament::after{
  content:'';flex:1;height:1px;
  background:linear-gradient(90deg,transparent,$glassBdr,transparent);
}
.addr-ornament span{color:$accent;font-size:16px;}
.addr-eyebrow{
  font-size:10px;font-weight:700;letter-spacing:.34em;
  text-transform:uppercase;color:rgba(255,255,255,0.5);
  display:block;margin-bottom:14px;
}
.addr-text{
  font-size:clamp(14px,3.2vw,17px);font-weight:600;
  letter-spacing:.08em;text-transform:uppercase;
  color:$accent;line-height:1.9;display:block;
  margin-bottom:36px;
}

/* ═══ VERSE BOX ═══ */
.vbox-section{padding:0 clamp(20px,6vw,80px) clamp(52px,8vw,88px);}
.vbox-glass{
  max-width:580px;margin:0 auto;
  padding:clamp(32px,5vw,52px) clamp(28px,5vw,52px);
  position:relative;
}
.vbox-star{
  position:absolute;top:-16px;left:50%;transform:translateX(-50%);
  width:32px;height:32px;border-radius:50%;
  background:$glassClr;
  border:1px solid $glassBdr;
  display:grid;place-items:center;
  font-size:12px;color:$accent;
  backdrop-filter:blur(8px);-webkit-backdrop-filter:blur(8px);
}
.vbox-quote{
  font-family:$serifFont;font-style:italic;
  font-size:clamp(15px,3.5vw,19px);line-height:1.85;
  color:rgba(255,255,255,0.88);margin-bottom:18px;
}
.vbox-ref{font-size:11px;font-weight:700;letter-spacing:.3em;text-transform:uppercase;color:$accent;}

/* ═══ ICONS ═══ */
.icons-section{padding:0 clamp(20px,6vw,80px) clamp(52px,8vw,88px);}
.icons-glass{max-width:640px;margin:0 auto;padding:clamp(40px,6vw,68px) clamp(20px,4vw,52px);}
.icons-eyebrow{font-size:11px;letter-spacing:.32em;text-transform:uppercase;color:rgba(255,255,255,0.5);display:block;margin-bottom:8px;}
.icons-script{font-family:$scriptFont;font-size:clamp(44px,10vw,64px);color:#fff;display:block;line-height:1.1;margin-bottom:44px;}
.icons-grid{display:grid;grid-template-columns:1fr 1fr;gap:clamp(24px,5vw,48px) clamp(20px,5vw,52px);max-width:420px;margin:0 auto;}
.icon-item{display:flex;flex-direction:column;align-items:center;gap:14px;text-decoration:none;cursor:pointer;}
.icon-ring{
  width:90px;height:90px;border-radius:50%;
  background:$glassClr;
  border:1.5px solid $glassBdr;
  backdrop-filter:blur(10px);-webkit-backdrop-filter:blur(10px);
  display:grid;place-items:center;
  transition:transform .3s cubic-bezier(.34,1.56,.64,1),background .3s,box-shadow .3s;
  position:relative;
}
.icon-ring::after{
  content:'';position:absolute;inset:-1px;border-radius:50%;
  background:linear-gradient(135deg,rgba(255,255,255,0.15) 0%,transparent 50%);
  pointer-events:none;
}
.icon-item:hover .icon-ring{
  transform:translateY(-6px) scale(1.06);
  background:rgba(255,255,255,0.18);
  box-shadow:0 16px 48px rgba(0,0,0,0.4), 0 0 0 1px ${accent}80;
}
.icon-ring svg{width:34px;height:34px;stroke:$accent;fill:none;stroke-width:1.3;stroke-linecap:round;stroke-linejoin:round;}
.icon-label{font-size:10.5px;font-weight:600;letter-spacing:.22em;text-transform:uppercase;color:rgba(255,255,255,0.65);text-align:center;line-height:1.5;}

/* ═══ AVISOS ═══ */
.avisos-section{padding:0 clamp(20px,6vw,80px) clamp(52px,8vw,88px);}
.avisos-glass{max-width:600px;margin:0 auto;padding:clamp(40px,6vw,68px) clamp(28px,5vw,56px);text-align:center;}
.av-ornament{margin-bottom:32px;}
.av-ornament svg{width:40px;height:40px;stroke:$accent;fill:none;stroke-width:1.2;}
.av-script{font-family:$scriptFont;font-size:clamp(56px,14vw,78px);color:#fff;display:block;line-height:1;margin-bottom:36px;}
.av-item{margin-bottom:20px;}
.av-item p{font-size:clamp(14px,3.3vw,16px);line-height:1.95;color:rgba(255,255,255,0.82);}
.av-item strong{color:$accent;font-weight:700;}
.esp-script{font-family:$scriptFont;font-size:clamp(48px,12vw,70px);color:#fff;display:block;line-height:1.1;margin-top:44px;}

/* ═══ NOIVOS SECTION — foto full screen ═══ */
.noivos-section{
  position:relative;width:100%;
  min-height:100svh;
  overflow:hidden;
}
.noivos-bg{
  position:absolute;inset:0;z-index:0;
  background-image:url("data:image/jpeg;base64,$noivosB64");
  background-size:cover;
  background-position:center top;
}
.noivos-overlay{
  position:absolute;inset:0;z-index:1;
  background:linear-gradient(
    to bottom,
    rgba(0,0,0,0.45) 0%,
    rgba(0,0,0,0.1) 40%,
    rgba(0,0,0,0.1) 65%,
    rgba(0,0,0,0.5) 100%
  );
}
.noivos-flor-bl{position:absolute;bottom:-16px;left:-16px;width:min(220px,38vw);z-index:5;pointer-events:none;opacity:.92;transform:scaleY(-1);filter:drop-shadow(0 4px 12px rgba(0,0,0,0.4));}
.noivos-flor-br{position:absolute;bottom:-16px;right:-16px;width:min(220px,38vw);z-index:5;pointer-events:none;opacity:.92;transform:scale(-1);filter:drop-shadow(0 4px 12px rgba(0,0,0,0.4));}
.noivos-content{
  position:relative;z-index:3;
  min-height:100svh;
  display:flex;flex-direction:column;
  align-items:center;justify-content:flex-end;
  padding:40px 24px 80px;
  text-align:center;
}
.noivos-script{font-family:$scriptFont;font-size:clamp(52px,14vw,88px);color:#fff;display:block;line-height:1.05;text-shadow:0 4px 32px rgba(0,0,0,0.6);margin-bottom:16px;}
.noivos-date{font-size:13px;font-weight:600;letter-spacing:.4em;text-transform:uppercase;color:rgba(255,255,255,0.75);}

/* ═══ FOOTER ═══ */
.footer{
  position:relative;z-index:2;
  text-align:center;padding:40px 20px 36px;
  background:rgba(0,0,0,0.7);
  backdrop-filter:blur(20px);-webkit-backdrop-filter:blur(20px);
  border-top:1px solid rgba(255,255,255,0.08);
}
.footer-names{font-family:$scriptFont;font-size:clamp(38px,9vw,56px);color:$accent;display:block;margin-bottom:10px;}
.footer-date{font-size:11px;letter-spacing:.36em;text-transform:uppercase;color:rgba(255,255,255,0.4);display:block;}

/* ═══ GSAP initial states ═══ */
.gsap-hidden{opacity:0;}
.gsap-up{opacity:0;transform:translateY(40px);}
.gsap-left{opacity:0;transform:translateX(-30px);}
.gsap-right{opacity:0;transform:translateX(30px);}
.gsap-scale{opacity:0;transform:scale(0.88);}

@media(max-width:520px){
  .icons-grid{gap:20px 16px;}
  .icon-ring{width:76px;height:76px;}
  .icon-ring svg{width:28px;height:28px;}
  .date-number{font-size:clamp(88px,18vw,130px);}
}
</style>
</head>
<body>

<!-- Fixed background -->
<div class="site-bg"></div>

<!-- Particles canvas -->
<div id="particles"></div>

<div class="page">

<!-- ═══ HERO ═══ -->
<section class="hero" id="hero">
  <img class="flor-tl" src="data:image/png;base64,$ftB64" alt="">
  <img class="flor-tr" src="data:image/png;base64,$ftB64" alt="">
  <div class="hero-ring"></div>
  <div class="hero-monogram" id="hm">M &amp; L</div>
  <span class="hero-blessing" id="hb">Com a b&ecirc;n&ccedil;&atilde;o de Deus e seus pais</span>
  <span class="hero-name" id="hn1">Mayane</span>
  <span class="hero-amp" id="ha">&amp;</span>
  <span class="hero-name" id="hn2">Lucas</span>
  <span class="hero-tagline" id="ht">Convidam para a cerim&ocirc;nia de casamento</span>
  <div class="hero-scroll-hint">
    <span>Descubra mais</span>
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><polyline points="6 9 12 15 18 9"/></svg>
  </div>
</section>

<!-- ═══ VERSE ═══ -->
<section class="glass-section verse-section">
  <div class="inner">
    <div class="glass gsap-up">
      <p class="verse-quote">&ldquo;Melhor &eacute; serem dois do que um, porque t&ecirc;m melhor paga do seu trabalho; porque se um cair, o outro levanta o seu companheiro.&rdquo;</p>
      <span class="verse-ref">Eclesiastes 4:9&ndash;12</span>
    </div>
  </div>
</section>

<!-- ═══ PLAYER ═══ -->
<section class="player-section">
  <div class="player-glass glass gsap-up">
    <div class="player-row">
      <button class="pc" title="Anterior"><svg viewBox="0 0 24 24"><polyline points="19 20 9 12 19 4"/><line x1="5" y1="19" x2="5" y2="5"/></svg></button>
      <button class="pc" title="Voltar"><svg viewBox="0 0 24 24"><polygon points="19 20 9 12 19 4"/></svg></button>
      <button class="pb" id="playBtn" onclick="togglePlay(this)" aria-label="Play">
        <svg viewBox="0 0 24 24"><polygon points="5 3 19 12 5 21"/></svg>
      </button>
      <button class="pc" title="Avan&ccedil;ar"><svg viewBox="0 0 24 24"><polygon points="5 4 15 12 5 20"/><line x1="19" y1="5" x2="19" y2="19"/></svg></button>
      <button class="pc" title="Pr&oacute;xima"><svg viewBox="0 0 24 24"><polyline points="5 4 15 12 5 20"/><polyline points="19 4 19 20"/></svg></button>
    </div>
    <div class="plbl">Aperte o play</div>
  </div>
</section>

<!-- ═══ DATE + COUNTDOWN ═══ -->
<section class="date-section">
  <div class="date-glass glass gsap-scale">
    <span class="date-script">a realizar&#8209;se no dia</span>
    <span class="date-number" data-month="Outubro &middot; 2026">18</span>
    <span class="date-sub">S&aacute;bado &middot; &agrave;s 13h30</span>
    <div class="countdown" id="countdown"></div>
  </div>
</section>

<!-- ═══ ADDRESSES ═══ -->
<section class="addr-section">
  <div class="addr-glass glass gsap-up">
    <div class="addr-ornament"><span>&#10022;</span></div>
    <span class="addr-eyebrow">A cerim&ocirc;nia ser&aacute; realizada na</span>
    <span class="addr-text">R. Adelino Strasi, 04<br>Jardim Brasil &mdash; V&aacute;rzea Paulista &middot; SP</span>
    <div class="addr-ornament"><span>&#10022;</span></div>
    <span class="addr-eyebrow">A recep&ccedil;&atilde;o dos convidados ser&aacute; no</span>
    <span class="addr-text" style="margin-bottom:0">R. Adelino Strasi, 04<br>Jardim Brasil &mdash; V&aacute;rzea Paulista &middot; SP</span>
  </div>
</section>

<!-- ═══ VERSE BOX ═══ -->
<section class="vbox-section">
  <div class="vbox-glass glass gsap-up">
    <div class="vbox-star">&#10022;</div>
    <p class="vbox-quote">&ldquo;Quem encontra uma esposa encontra algo excelente; recebeu uma b&ecirc;n&ccedil;&atilde;o do Senhor.&rdquo;</p>
    <span class="vbox-ref">Prov&eacute;rbios 18:22</span>
  </div>
</section>

<!-- ═══ ICONS ═══ -->
<section class="icons-section">
  <div class="icons-glass glass gsap-up">
    <span class="icons-eyebrow">Toque nos &iacute;cones</span>
    <span class="icons-script">para acessar</span>
    <div class="icons-grid">

      <!-- Localização cerimônia — church SVG -->
      <a class="icon-item" href="#" title="Cerim&ocirc;nia">
        <div class="icon-ring">
          <svg viewBox="0 0 48 48">
            <line x1="24" y1="2" x2="24" y2="10" stroke-width="1.5"/>
            <line x1="20" y1="6" x2="28" y2="6" stroke-width="1.5"/>
            <rect x="8" y="18" width="32" height="28" rx="1" stroke-width="1.5"/>
            <path d="M8 18 L24 10 L40 18" stroke-width="1.5" fill="none"/>
            <rect x="18" y="30" width="12" height="16" rx="1" stroke-width="1.4"/>
            <path d="M18 30 Q24 24 30 30" stroke-width="1.3" fill="none"/>
            <rect x="11" y="22" width="8" height="10" rx="1" stroke-width="1.2"/>
            <rect x="29" y="22" width="8" height="10" rx="1" stroke-width="1.2"/>
          </svg>
        </div>
        <span class="icon-label">Localiza&ccedil;&atilde;o<br>da Cerim&ocirc;nia</span>
      </a>

      <!-- Localização recepção — champagne SVG -->
      <a class="icon-item" href="#" title="Recep&ccedil;&atilde;o">
        <div class="icon-ring">
          <svg viewBox="0 0 48 48">
            <path d="M16 6 L16 28 Q16 40 24 40 Q32 40 32 28 L32 6" stroke-width="1.5"/>
            <path d="M14 14 Q24 20 34 14" stroke-width="1.4" fill="none"/>
            <line x1="24" y1="40" x2="24" y2="45" stroke-width="1.5"/>
            <line x1="18" y1="45" x2="30" y2="45" stroke-width="1.5"/>
            <path d="M20 8 C20 8 22 11 24 8" stroke-width="1.2" fill="none"/>
            <path d="M26 10 C26 10 28 7 30 10" stroke-width="1.2" fill="none"/>
          </svg>
        </div>
        <span class="icon-label">Localiza&ccedil;&atilde;o<br>da Recep&ccedil;&atilde;o</span>
      </a>

      <!-- Site dos noivos — rings SVG -->
      <a class="icon-item" href="#" title="Site dos Noivos">
        <div class="icon-ring">
          <svg viewBox="0 0 48 48">
            <circle cx="16" cy="24" r="10" stroke-width="1.5"/>
            <circle cx="32" cy="24" r="10" stroke-width="1.5"/>
            <path d="M22 18 Q24 22 22 30" stroke-width="1.2" fill="none"/>
            <path d="M26 18 Q24 22 26 30" stroke-width="1.2" fill="none"/>
            <circle cx="16" cy="24" r="2.5" fill="currentColor" stroke="none" opacity="0.4"/>
            <circle cx="32" cy="24" r="2.5" fill="currentColor" stroke="none" opacity="0.4"/>
          </svg>
        </div>
        <span class="icon-label">Site dos<br>Noivos</span>
      </a>

      <!-- Confirmar presença — heart calendar SVG -->
      <a class="icon-item" href="#avisos" title="Confirmar">
        <div class="icon-ring">
          <svg viewBox="0 0 48 48">
            <rect x="6" y="12" width="36" height="32" rx="3" stroke-width="1.5"/>
            <line x1="6" y1="22" x2="42" y2="22" stroke-width="1.4"/>
            <line x1="16" y1="6" x2="16" y2="18" stroke-width="1.5"/>
            <line x1="32" y1="6" x2="32" y2="18" stroke-width="1.5"/>
            <path d="M20 30 Q24 26 28 30 Q32 34 24 40 Q16 34 20 30Z" stroke-width="1.3" fill="none"/>
          </svg>
        </div>
        <span class="icon-label">Confirmar<br>Presen&ccedil;a</span>
      </a>

    </div>
  </div>
</section>

<!-- ═══ AVISOS ═══ -->
<section class="avisos-section" id="avisos">
  <div class="avisos-glass glass gsap-up">
    <div class="av-ornament">
      <svg viewBox="0 0 40 40">
        <path d="M20 4 L22 16 L34 16 L24 24 L28 36 L20 28 L12 36 L16 24 L6 16 L18 16 Z"/>
      </svg>
    </div>
    <span class="av-script">Avisos</span>
    <div class="av-item"><p>A confirma&ccedil;&atilde;o de presen&ccedil;a &eacute; indispens&aacute;vel.<br>Confirme sua presen&ccedil;a at&eacute; o dia <strong>18/09/2026</strong>.</p></div>
    <div class="av-item"><p><strong>Dress code:</strong> Esporte fino.</p></div>
    <div class="av-item"><p>Pedimos a gentileza de chegar com anteced&ecirc;ncia para melhor acomoda&ccedil;&atilde;o de todos e para que possam aproveitar cada momento desse dia especial conosco.</p></div>
    <span class="esp-script">Esperamos por<br>voc&ecirc;!</span>
  </div>
</section>

<!-- ═══ NOIVOS — full screen ═══ -->
<section class="noivos-section" id="noivos">
  <div class="noivos-bg"></div>
  <div class="noivos-overlay"></div>
  <img class="noivos-flor-bl" src="data:image/png;base64,$ftB64" alt="">
  <img class="noivos-flor-br" src="data:image/png;base64,$ftB64" alt="">
  <div class="noivos-content">
    <span class="noivos-script gsap-up">Mayane &amp; Lucas</span>
    <span class="noivos-date">18 &middot; Outubro &middot; 2026</span>
  </div>
</section>

<!-- ═══ FOOTER ═══ -->
<footer class="footer">
  <span class="footer-names">Mayane &amp; Lucas</span>
  <span class="footer-date">18 &middot; Outubro &middot; 2026</span>
</footer>

</div><!-- .page -->

<!-- GSAP + ScrollTrigger CDN -->
<script src="https://cdn.jsdelivr.net/npm/gsap@3.12.5/dist/gsap.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/gsap@3.12.5/dist/ScrollTrigger.min.js"></script>
<script>
gsap.registerPlugin(ScrollTrigger);

/* ── Hero entrance ── */
var tl = gsap.timeline({defaults:{ease:"power3.out"}});
tl.to("#hm",  {opacity:1,y:0,duration:1,   delay:0.3})
  .to("#hb",  {opacity:1,   duration:0.7},  "-=0.4")
  .to("#hn1", {opacity:1,y:0,duration:0.9}, "-=0.3")
  .to("#ha",  {opacity:1,   duration:0.6},  "-=0.4")
  .to("#hn2", {opacity:1,y:0,duration:0.9}, "-=0.5")
  .to("#ht",  {opacity:1,   duration:0.8},  "-=0.3");

/* ── ScrollTrigger: reveal each glass block ── */
document.querySelectorAll(".gsap-up").forEach(function(el){
  gsap.to(el,{
    scrollTrigger:{trigger:el,start:"top 88%",toggleActions:"play none none none"},
    opacity:1,y:0,duration:0.85,ease:"power3.out"
  });
});
document.querySelectorAll(".gsap-scale").forEach(function(el){
  gsap.to(el,{
    scrollTrigger:{trigger:el,start:"top 85%",toggleActions:"play none none none"},
    opacity:1,scale:1,duration:1,ease:"back.out(1.4)"
  });
});

/* ── Subtle parallax on fixed bg via scroll ── */
window.addEventListener("scroll",function(){
  var y = window.pageYOffset;
  document.querySelector(".site-bg").style.transform = "translateY("+y*0.18+"px)";
},{passive:true});

/* ── Countdown ── */
(function(){
  var target = new Date("2026-10-18T13:30:00");
  var el = document.getElementById("countdown");
  function pad(n){return String(n).padStart(2,"0");}
  function tick(){
    var now = new Date(), diff = target - now;
    if(diff<=0){el.innerHTML="<span style='color:#fff;font-size:18px;letter-spacing:.1em'>Chegou o grande dia! \uD83C\uDF89</span>";return;}
    var d=Math.floor(diff/86400000),
        h=Math.floor((diff%86400000)/3600000),
        m=Math.floor((diff%3600000)/60000),
        s=Math.floor((diff%60000)/1000);
    el.innerHTML=
      '<div class="cd-unit"><span class="cd-num">'+d+'</span><span class="cd-lbl">dias</span></div>'+
      '<span class="cd-sep">:</span>'+
      '<div class="cd-unit"><span class="cd-num">'+pad(h)+'</span><span class="cd-lbl">horas</span></div>'+
      '<span class="cd-sep">:</span>'+
      '<div class="cd-unit"><span class="cd-num">'+pad(m)+'</span><span class="cd-lbl">min</span></div>'+
      '<span class="cd-sep">:</span>'+
      '<div class="cd-unit"><span class="cd-num">'+pad(s)+'</span><span class="cd-lbl">seg</span></div>';
  }
  tick(); setInterval(tick,1000);
})();

/* ── Player toggle ── */
function togglePlay(b){
  var s=b.querySelector("svg");
  if(b.dataset.p==="1"){
    s.innerHTML='<polygon points="5 3 19 12 5 21"/>';
    b.dataset.p="0";
  } else {
    s.innerHTML='<rect x="6" y="4" width="4" height="16"/><rect x="14" y="4" width="4" height="16"/>';
    b.dataset.p="1";
  }
}

/* ── Particle system ── */
(function(){
  var container = document.getElementById("particles");
  var count = 28;
  for(var i=0;i<count;i++){
    var p = document.createElement("div");
    p.className = "particle";
    var sz = Math.random()*3+1.5;
    p.style.cssText = [
      "width:"+sz+"px","height:"+sz+"px",
      "left:"+(Math.random()*100)+"%",
      "bottom:"+(Math.random()*-20)+"px",
      "animation-duration:"+(Math.random()*18+10)+"s",
      "animation-delay:"+(-Math.random()*20)+"s",
      "opacity:"+(Math.random()*0.5+0.2)
    ].join(";");
    container.appendChild(p);
  }
})();
</script>
</body>
</html>
"@

    $outPath = Join-Path $outDir "index.html"
    [IO.File]::WriteAllText($outPath, $html, [Text.Encoding]::UTF8)
    $kb = [math]::Round(([IO.FileInfo]$outPath).Length / 1024, 1)
    Write-Host "OK $folder/index.html - ${kb}KB"
}
Write-Host "Done. 4 premium sites built."
