/* ── Sistema de temas ── */
(function(){
  var THEMES = ["serenity", "shadow-serenity"];
  var LABELS = { "serenity": "Serenity", "shadow-serenity": "Shadow Serenity" };

  /* aplica tema salvo imediatamente (evita flash) */
  var saved = localStorage.getItem("convite-theme") || "serenity";
  applyTheme(saved, false);

  document.addEventListener("DOMContentLoaded", function(){
    var btn   = document.getElementById("themeBtn");
    var label = document.getElementById("themeBtnLabel");
    if(!btn) return;

    updateLabel(label, saved);

    btn.addEventListener("click", function(){
      var current = document.documentElement.getAttribute("data-theme") || "serenity";
      var next    = THEMES[(THEMES.indexOf(current) + 1) % THEMES.length];
      applyTheme(next, true);
      updateLabel(label, next);
      localStorage.setItem("convite-theme", next);
    });
  });

  function applyTheme(theme, animate){
    var html = document.documentElement;
    if(animate){
      /* transição suave em todas as cores */
      html.style.transition = "background .45s ease";
      document.body && (document.body.style.transition = "background .45s ease, color .45s ease");
    }
    if(theme === "serenity"){
      html.removeAttribute("data-theme");
    } else {
      html.setAttribute("data-theme", theme);
    }
    window.dispatchEvent(new CustomEvent("convite:theme-change", {
      detail: { theme: theme, animate: !!animate }
    }));
  }

  function updateLabel(label, theme){
    if(!label) return;
    label.textContent = LABELS[theme] || theme;
  }
})();

/* ── Monograma — foto + likes + crescimento para baixo + contexto recua ── */
(function(){
  var mbg = document.getElementById("mBg");
  if(mbg){ mbg.style.backgroundImage = "url('../assets/photos/monograma.jpg')"; }

  var COLORS    = ["#5A7B9F","#7DB3E3","#8AC0ED","#95C8F5"];  /* Serenity Blues */
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
(function(){
  var audio    = document.getElementById("audioPlayer");
  var btn      = document.getElementById("playBtn");
  var playIcon = document.getElementById("playIcon");
  if(!audio || !btn) return;

  var PLAY_PATH  = "<polygon points='5 3 19 12 5 21'/>";
  var PAUSE_PATH = "<rect x='6' y='4' width='4' height='16'/><rect x='14' y='4' width='4' height='16'/>";

  /* anéis idle fixos (antes do play) */
  var rings = [
    document.getElementById("pRing1"),
    document.getElementById("pRing2"),
    document.getElementById("pRing3")
  ];

  var rafId, analyser, dataArr, playing = false;

  /* ── Batidas mapeadas manualmente do áudio (sincronizadas exatamente com a música) ── */
  /* Adicione os tempos e intensidades reais conforme a música toca */
  var beatPattern = [
    { time: 0.0, energy: 0.4 },
    { time: 0.2, energy: 0.6 },
    { time: 0.4, energy: 0.3 },
    { time: 0.6, energy: 0.5 },
    { time: 0.8, energy: 0.2 },
    { time: 1.0, energy: 0.7 },
    { time: 1.2, energy: 0.4 },
    { time: 1.4, energy: 0.5 },
    { time: 1.6, energy: 0.3 },
    { time: 1.8, energy: 0.6 },
    { time: 2.0, energy: 0.2 },
    { time: 2.2, energy: 0.8 }
  ];
  var lastDetectedTime = -1;
  var detectionThreshold = 0.15; // segundos

  function getEnergyFromAudioTime(){
    if(!audio || audio.paused) return 0;
    
    var currentTime = audio.currentTime;
    var closestEnergy = 0.3;
    var minDist = detectionThreshold;
    
    // Procura o tempo mais próximo no padrão
    for(var i = 0; i < beatPattern.length; i++){
      var beat = beatPattern[i];
      var dist = Math.abs(currentTime - beat.time);
      
      if(dist < minDist && currentTime >= beat.time){
        closestEnergy = beat.energy;
        minDist = dist;
        lastDetectedTime = beat.time;
      }
    }
    
    return closestEnergy;
  }

  function tryAnalyser(){
    if(analyser) return;
    analyser = { fake: true };
    dataArr = new Uint8Array(256);
  }

  function getEnergy(){
    if(!analyser) return 0;
    return getEnergyFromAudioTime();
  }

  function tryAnalyser(){
    if(analyser) return;
    analyser = { fake: true };
    dataArr = new Uint8Array(256);
  }

  function getEnergy(){
    if(!analyser) return 0;
    return getEnergyFromAudioTime();
  }

  /* ── Idle CSS (antes do play) ── */
  function setIdleCSS(){
    rings.forEach(function(r, i){
      if(!r) return;
      r.style.transform = "";
      r.style.opacity   = "";
      var names  = ["ringIdle1","ringIdle2","ringIdle3"];
      var delays = ["0s","0.95s","1.9s"];
      r.style.animation = names[i] + " 6s ease-in-out " + delays[i] + " infinite";
    });
  }

  function hideIdleRings(){
    rings.forEach(function(r){
      if(!r) return;
      r.style.animation = "none";
      r.style.opacity   = "0";
      r.style.transform = "";
    });
  }

  /* ── Ondas dinâmicas: cada onda é um <span> criado e destruído ── */
  var lastEnergy = 0, lastSpawn = 0, MIN_INTERVAL = 90; /* ms entre ondas */

  function spawnWave(energy){
    var wave = document.createElement("span");
    wave.style.cssText = [
      "position:absolute",
      "inset:-1px",
      "border-radius:50%",
      "border:1px solid var(--verde)",
      "pointer-events:none",
      "transform:scale(1)",
      "opacity:" + (0.18 + energy * 0.45),
      "transition:transform " + (0.9 + energy * 0.7) + "s cubic-bezier(.2,.6,.3,1),opacity " + (0.9 + energy * 0.7) + "s ease-out"
    ].join(";");
    btn.appendChild(wave);
    /* força reflow para a transition funcionar */
    void wave.offsetWidth;
    wave.style.transform = "scale(" + (1.5 + energy * 1.4) + ")";
    wave.style.opacity   = "0";
    /* remove do DOM após terminar */
    setTimeout(function(){ wave.remove(); }, (0.9 + energy * 0.7) * 1000 + 50);
  }

  function beatLoop(){
    rafId = requestAnimationFrame(beatLoop);
    var energy = getEnergy();
    var now    = performance.now();

    /* dispara onda quando a energia sobe acima do último valor + threshold */
    if(energy > lastEnergy + 0.03 && now - lastSpawn > MIN_INTERVAL){
      spawnWave(energy);
      lastSpawn = now;
    }
    lastEnergy = energy * 0.7 + lastEnergy * 0.3; /* suaviza para detectar subidas */
  }

  function startBeat(){
    hideIdleRings();
    lastEnergy = 0; lastSpawn = 0;
    if(!rafId) beatLoop();
  }

  function stopBeat(){
    if(rafId){ cancelAnimationFrame(rafId); rafId = null; }
    /* remove qualquer onda voando */
    btn.querySelectorAll("span:not(.player-ring)").forEach(function(el){ el.remove(); });
    setIdleCSS();
  }

  /* inicia com CSS idle */
  setIdleCSS();

  window.playerToggle = function(){
    if(audio.paused){
      tryAnalyser();
      audio.play().then(function(){
        playing = true;
        playIcon.innerHTML = PAUSE_PATH;
        startBeat();
      }).catch(function(err){
        console.warn("Playback bloqueado:", err);
      });
    } else {
      audio.pause();
      playing = false;
      playIcon.innerHTML = PLAY_PATH;
      stopBeat();
    }
  };
})();

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

/* ── Flores: scroll physics + migração para header + troca por tema ── */
(function(){
  var florL  = document.querySelector(".flor-tl");
  var florR  = document.querySelector(".flor-tr");
  var hdr    = document.querySelector(".site-header");
  var hFlorL = document.getElementById("hFlorL");
  var hFlorR = document.getElementById("hFlorR");
  if(!florL || !florR || !hdr || !hFlorL || !hFlorR) return;

  var SERENITY_SRC = "../assets/flowers/flor_serenity.png";
  var addrFlorL = document.getElementById("addrFlorL");
  var addrFlorR = document.getElementById("addrFlorR");
  var noivosFlorL = document.querySelector(".nf-bl");
  var noivosFlorR = document.querySelector(".nf-br");
  var lastY = window.scrollY, velocity = 0, current = 0, raf = null;
  var SENS = 0.018, MAX = 12, DAMP = 0.82, SMOOTH = 0.14;

  syncFlowers(false);

  var io = new IntersectionObserver(function(entries){
    entries.forEach(function(entry){
      if(entry.target === florL){
        if(!entry.isIntersecting){ hdr.classList.add("has-flores"); }
        else { hdr.classList.remove("has-flores"); }
      }
    });
  }, {threshold: 0, rootMargin: "0px 0px 0px 0px"});
  io.observe(florL);

  window.addEventListener("convite:theme-change", function(event){
    var detail = event.detail || {};
    syncFlowers(!!detail.animate);
  });

  function getThemeSrc(){
    return SERENITY_SRC;
  }

  function syncFlowers(animate){
    var src = getThemeSrc();
    if(florL.getAttribute("src") === src && hFlorL.getAttribute("src") === src){
      syncSecondaryFlowers(src);
      return;
    }
    if(!animate){
      setFlowerSource(src);
      return;
    }
    animateFlowerSwap(src);
  }

  function setFlowerSource(src){
    florL.src = src;
    florR.src = src;
    hFlorL.src = src;
    hFlorR.src = src;
    syncSecondaryFlowers(src);
  }

  function syncSecondaryFlowers(src){
    if(addrFlorL) addrFlorL.src = src;
    if(addrFlorR) addrFlorR.src = src;
    if(noivosFlorL) noivosFlorL.src = src;
    if(noivosFlorR) noivosFlorR.src = src;
  }

  function animateFlowerSwap(src){
    var heroFlowers = [florL, florR, hFlorL, hFlorR].filter(Boolean);
    var accentFlowers = [addrFlorL, addrFlorR, noivosFlorL, noivosFlorR].filter(Boolean);
    heroFlowers.forEach(function(el){
      el.classList.remove("flor-arriving", "flor-leaving");
      void el.offsetWidth;
      el.classList.add("flor-leaving");
    });
    setTimeout(function(){
      accentFlowers.forEach(function(el){
        el.classList.remove("flor-arriving", "flor-leaving");
        void el.offsetWidth;
        el.classList.add("flor-leaving");
      });
    }, 90);
    hdr.classList.add("theme-flip");
    document.body.classList.add("theme-flip-active");
    setTimeout(function(){
      setFlowerSource(src);
      heroFlowers.forEach(function(el){
        el.classList.remove("flor-leaving");
        void el.offsetWidth;
        el.classList.add("flor-arriving");
      });
      setTimeout(function(){
        accentFlowers.forEach(function(el){
          el.classList.remove("flor-leaving");
          void el.offsetWidth;
          el.classList.add("flor-arriving");
        });
      }, 110);
      setTimeout(function(){
        heroFlowers.concat(accentFlowers).forEach(function(el){ el.classList.remove("flor-arriving"); });
      }, 1180);
    }, 360);
    setTimeout(function(){
      hdr.classList.remove("theme-flip");
      document.body.classList.remove("theme-flip-active");
    }, 1120);
  }

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

/* ── Header height → CSS variable (responsivo) ── */
(function(){
  function setHeaderH(){
    var hdr = document.querySelector(".site-header");
    if(!hdr) return;
    document.documentElement.style.setProperty("--header-h", hdr.getBoundingClientRect().height + "px");
  }
  /* roda imediatamente (script está no fim do body, DOM existe) */
  setHeaderH();
  /* re-mede após fontes carregarem (Great Vibes pode alterar altura) */
  document.addEventListener("DOMContentLoaded", setHeaderH);
  if(document.fonts && document.fonts.ready){
    document.fonts.ready.then(setHeaderH);
  }
  /* re-mede em resize e orientação (mobile, zoom) */
  window.addEventListener("resize", setHeaderH, {passive: true});
  window.addEventListener("orientationchange", setHeaderH, {passive: true});
})();

/* ── Modal PIX — abertura, fechamento e cópia de chave ── */
(function(){
  function openPixModal(){
    var overlay = document.getElementById("pixModalOverlay");
    var modal = document.getElementById("pixModal");
    if(!overlay || !modal) return;
    
    overlay.classList.add("active");
    modal.classList.add("active");
    document.body.style.overflow = "hidden";
  }
  
  function closePixModal(){
    var overlay = document.getElementById("pixModalOverlay");
    var modal = document.getElementById("pixModal");
    if(!overlay || !modal) return;
    
    overlay.classList.remove("active");
    modal.classList.remove("active");
    document.body.style.overflow = "";
  }
  
  function copyPixKey(){
    var keyText = document.getElementById("pixKeyText");
    if(!keyText) return;

    var text = keyText.textContent || keyText.innerText;
    if(!text) return;

    var btn = document.getElementById("pixCopyBtn");

    function showCopied(){
      if(!btn) return;
      var iconSvg  = btn.querySelector(".copy-icon");
      var checkSvg = btn.querySelector(".copy-check");
      if(iconSvg)  iconSvg.style.display  = "none";
      if(checkSvg) checkSvg.style.display = "";
      btn.classList.add("copied");
      setTimeout(function(){
        btn.classList.remove("copied");
        if(iconSvg)  iconSvg.style.display  = "";
        if(checkSvg) checkSvg.style.display = "none";
      }, 2000);
    }

    /* copia para clipboard */
    navigator.clipboard.writeText(text).then(showCopied).catch(function(){
      /* fallback para navegadores antigos */
      var textarea = document.createElement("textarea");
      textarea.value = text;
      document.body.appendChild(textarea);
      textarea.select();
      document.execCommand("copy");
      document.body.removeChild(textarea);
      showCopied();
    });
  }
  
  /* expõe globalmente */
  window.openPixModal = openPixModal;
  window.closePixModal = closePixModal;
  window.copyPixKey = copyPixKey;
  
  /* fecha modal com ESC */
  document.addEventListener("keydown", function(e){
    if(e.key === "Escape"){
      closePixModal();
    }
  });
})();
