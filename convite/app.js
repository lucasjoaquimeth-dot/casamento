/* ── Monograma — foto + likes + crescimento para baixo + contexto recua ── */
(function(){
  var nimg = document.querySelector(".nimg");
  var mbg  = document.getElementById("mBg");
  if(nimg && mbg){ mbg.style.backgroundImage = "url('" + nimg.src + "')"; }

  var COLORS    = ["#0644BF","#2975D9","#5EADF2","#8DC3F2"];
  var clicks    = 0;
  var baseScale = 1;
  var MAX_SCALE = 2.2;
  var MONO_H    = 108;
  var resetTimer = null;

  var wrap = document.querySelector(".monogram-wrap");
  var mono = document.querySelector(".monogram");
  var ctx  = document.getElementById("heroCtx");
  if(!wrap || !mono || !ctx) return;

  wrap.addEventListener("click", function(e){
    clicks++;

    baseScale = Math.min(MAX_SCALE, 1 + (clicks - 1) * 0.06);
    var bounce = baseScale + 0.12;

    mono.style.transition = "transform .35s cubic-bezier(.34,1.56,.64,1)";
    mono.style.transform  = "scale(" + bounce + ")";

    setTimeout(function(){
      mono.style.transform = "scale(" + baseScale + ")";
      var extra = Math.round(MONO_H * (baseScale - 1));
      wrap.style.marginBottom = (24 + extra) + "px";
    }, 360);

    var ctxOp = Math.max(0.25, 1 - (baseScale - 1) * 0.85);
    var ctxTy = Math.round((baseScale - 1) * 14);
    ctx.style.opacity   = ctxOp;
    ctx.style.transform = "translateY(-" + ctxTy + "px)";

    mono.style.animationDuration = Math.max(0.5, 3 - clicks * 0.18) + "s";

    launchHeart();

    clearTimeout(resetTimer);
    resetTimer = setTimeout(function(){
      clicks = 0; baseScale = 1;
      mono.style.transition = "transform 2.0s cubic-bezier(.22,1,.36,1), box-shadow 1.4s ease";
      mono.style.transform  = "scale(1)";
      mono.style.animationDuration = "3s";
      wrap.style.marginBottom = "24px";
      ctx.style.transition = "opacity 1.4s cubic-bezier(.22,1,.36,1) .3s, transform 1.4s cubic-bezier(.22,1,.36,1) .3s";
      ctx.style.opacity    = "1";
      ctx.style.transform  = "translateY(0)";
      setTimeout(function(){
        ctx.style.transition = "opacity 1.0s cubic-bezier(.22,1,.36,1), transform 1.0s cubic-bezier(.22,1,.36,1)";
      }, 1800);
    }, 4000);
  });

  function launchHeart(){
    var rect   = wrap.getBoundingClientRect();
    var cx     = rect.left + rect.width / 2;
    var cy     = rect.top  + MONO_H * baseScale;
    var offsetX = (Math.random() - 0.5) * 80;
    var color  = COLORS[Math.floor(Math.random() * COLORS.length)];
    var h = document.createElement("span");
    h.className = "heart-particle";
    h.innerHTML = '<svg width="18" height="16" viewBox="0 0 24 22" fill="' + color + '">'
      + '<path d="M12 21C12 21 2 13.5 2 7.5A5.5 5.5 0 0 1 12 4.4 5.5 5.5 0 0 1 22 7.5C22 13.5 12 21 12 21Z"/>'
      + '</svg>';
    h.style.cssText = "position:fixed;left:" + (cx + offsetX - 9) + "px;top:" + (cy - 16) + "px;"
      + "pointer-events:none;z-index:9999;";
    document.body.appendChild(h);
    setTimeout(function(){ h.remove(); }, 900);
  }
})();

/* ── Countdown ── */
(function(){
  var t  = new Date("2026-10-18T13:30:00");
  var el = document.getElementById("cd");
  function pad(n){ return String(n).padStart(2, "0"); }
  function tick(){
    var now = new Date(), d = t - now;
    if(d <= 0){ el.innerHTML = "<span style='color:var(--verde);font-size:16px;letter-spacing:.1em'>Chegou o grande dia!</span>"; return; }
    var dy = Math.floor(d / 86400000),
        h  = Math.floor((d % 86400000) / 3600000),
        m  = Math.floor((d % 3600000)  / 60000),
        s  = Math.floor((d % 60000)    / 1000);
    el.innerHTML =
      "<div class='cd-unit'><span class='cd-num'>"  + dy      + "</span><span class='cd-lbl'>dias</span></div>"  +
      "<span class='cd-sep'>:</span>" +
      "<div class='cd-unit'><span class='cd-num'>"  + pad(h)  + "</span><span class='cd-lbl'>horas</span></div>" +
      "<span class='cd-sep'>:</span>" +
      "<div class='cd-unit'><span class='cd-num'>"  + pad(m)  + "</span><span class='cd-lbl'>min</span></div>"   +
      "<span class='cd-sep'>:</span>" +
      "<div class='cd-unit'><span class='cd-num'>"  + pad(s)  + "</span><span class='cd-lbl'>seg</span></div>";
  }
  tick(); setInterval(tick, 1000);
})();

/* ── Player ── */
function togglePlay(b){
  var s = b.querySelector("svg");
  if(b.dataset.p === "1"){ s.innerHTML = "<polygon points='5 3 19 12 5 21'/>"; b.dataset.p = "0"; }
  else{ s.innerHTML = "<rect x='6' y='4' width='4' height='16'/><rect x='14' y='4' width='4' height='16'/>"; b.dataset.p = "1"; }
}

/* ── Scroll reveal ── */
(function(){
  var io = new IntersectionObserver(function(es){
    es.forEach(function(e){
      if(e.isIntersecting){ e.target.classList.add("sv-visible"); io.unobserve(e.target); }
    });
  }, {threshold: 0.07});
  var secs = document.querySelectorAll(".verse-top,.date-sec,.addr-sec,.vbox-sec,.icons-sec,.avisos-sec");
  secs.forEach(function(el){
    el.style.opacity   = "0";
    el.style.transform = "translateY(24px)";
    el.style.transition = "opacity .75s ease, transform .75s ease";
    io.observe(el);
  });
  document.addEventListener("DOMContentLoaded", function(){
    document.querySelectorAll(".sv-visible").forEach(function(el){ el.style.opacity = "1"; el.style.transform = "none"; });
  });
  var style = document.createElement("style");
  style.textContent = ".sv-visible{opacity:1!important;transform:none!important;}";
  document.head.appendChild(style);
})();

/* ── Flores: scroll physics + migração para header + cópia src laterais ── */
(function(){
  var florL  = document.querySelector(".flor-tl");
  var florR  = document.querySelector(".flor-tr");
  var hdr    = document.querySelector(".site-header");
  var hFlorL = document.getElementById("hFlorL");
  var hFlorR = document.getElementById("hFlorR");
  if(!florL || !florR || !hdr || !hFlorL || !hFlorR) return;

  hFlorL.src = florL.src;
  hFlorR.src = florR.src;
  var addrFlorL = document.getElementById("addrFlorL");
  var addrFlorR = document.getElementById("addrFlorR");
  if(addrFlorL) addrFlorL.src = florL.src;
  if(addrFlorR) addrFlorR.src = florL.src;

  var lastY = window.scrollY, velocity = 0, current = 0, raf = null;
  var SENS = 0.018, MAX = 12, DAMP = 0.82, SMOOTH = 0.14;

  var io = new IntersectionObserver(function(entries){
    entries.forEach(function(entry){
      if(entry.target === florL){
        if(!entry.isIntersecting){ hdr.classList.add("has-flores"); }
        else { hdr.classList.remove("has-flores"); }
      }
    });
  }, {threshold: 0, rootMargin: "0px 0px 0px 0px"});
  io.observe(florL);

  function applyRot(deg){
    florL.style.transform  = "rotate(" + deg + "deg)";
    florR.style.transform  = "scaleX(-1) rotate(" + (-deg) + "deg)";
    hFlorL.style.transform = "rotate(" + deg + "deg)";
    hFlorR.style.transform = "scaleX(-1) rotate(" + (-deg) + "deg)";
  }
  function clearRot(){
    florL.style.transform  = "";
    florR.style.transform  = "scaleX(-1)";
    hFlorL.style.transform = "";
    hFlorR.style.transform = "scaleX(-1)";
  }
  function loop(){
    current  += (velocity - current) * SMOOTH;
    velocity *= DAMP;
    applyRot(Math.max(-MAX, Math.min(MAX, current)));
    if(Math.abs(current) > 0.05 || Math.abs(velocity) > 0.05){
      raf = requestAnimationFrame(loop);
    } else {
      clearRot(); raf = null;
    }
  }
  window.addEventListener("scroll", function(){
    var y = window.scrollY;
    velocity += (y - lastY) * SENS;
    lastY = y;
    if(!raf) raf = requestAnimationFrame(loop);
  }, {passive: true});
})();
