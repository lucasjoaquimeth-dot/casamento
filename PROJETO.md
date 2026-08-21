# Convite de Casamento — Mayane & Lucas
## Guia Completo do Projeto · Atualizado

> Use este arquivo para retomar o trabalho em qualquer nova conversa. Documenta todo o estado atual, decisões tomadas, o que funciona e o que não funciona.

---

## 1. Dados do Casamento

| Campo | Valor |
|-------|-------|
| **Noivos** | Mayane & Lucas |
| **Data** | 18 de Outubro de 2026 |
| **Dia** | Sábado |
| **Horário** | 13h30 |
| **Cerimônia** | R. Adelino Strasi, 04 — Jardim Brasil, Várzea Paulista · SP |
| **Recepção** | R. Adelino Strasi, 04 — Jardim Brasil, Várzea Paulista · SP |
| **Dress code** | Esporte fino |
| **RSVP até** | 18/09/2026 |

---

## 2. Estrutura de Pastas

```
Convite/
├── v1_aquarela/index.html   ← PRINCIPAL ✅ — versão mais evoluída (paleta azul, todas as interações)
├── v2_luxo/index.html       ← Variante dourada (dark + gold, mesma estrutura)
├── v3_botanico/index.html   ← Variante verde botânico
├── v4_noturno/index.html    ← Variante azul noturno (dark, estrelas)
│
├── assets/
│   ├── local.jpeg           ← Foto do local (lago/deque/flores) — usada como <img> full-width
│   ├── noivos.jpeg          ← Foto do casal (fundo rosa/pêssego bokeh) — monograma hero
│   ├── flor_sem_fundo.png   ← Flores PNG com alpha — usar para TUDO (cantos, header, laterais)
│   ├── flor_lateral_direita.png  ← ⚠️ TEM FUNDO BRANCO — NÃO usar diretamente
│   ├── flor.png             ← Flores alternativas
│   └── palheta_cores.jpeg   ← Paleta Adobe real: #0644BF #2975D9 #5EADF2 #8DC3F2 #F2F2F2
│
├── .bob/                    ← Cache de base64 (gerado automaticamente — não versionar)
│   ├── local_b64.txt        ← base64 de local.jpeg
│   ├── noivos_b64.txt       ← base64 de noivos.jpeg
│   ├── flor_sem_fundo_b64.txt ← base64 de flor_sem_fundo.png
│   ├── flor_lateral_b64.txt ← base64 de flor_lateral_direita.png
│   ├── fundo_b64.txt        ← base64 de fundo.jpg
│   ├── flor_b64.txt         ← base64 de flor.png
│   ├── tmp_local.txt        ← alias (mesmo que local_b64.txt)
│   ├── tmp_noivos.txt       ← alias (mesmo que noivos_b64.txt)
│   ├── tmp_flortop.txt      ← alias
│   ├── tmp_florlat.txt      ← alias
│   └── template_clean.html  ← Template v1 sem imagens (placeholders __LOCAL__ etc.)
│
├── tools/                   ← Scripts auxiliares de build (build_sites_v2.ps1 é o principal)
├── PROJETO.md               ← Este arquivo
└── .gitignore
```

---

## 3. Paleta Real (extraída de `assets/palheta_cores.jpeg`)

Paleta Adobe com 5 cores base — **apenas azuis, sem verdes**.

| Variável CSS | Hex | Uso |
|---|---|---|
| `--azul1` | `#0644BF` | Azul escuro — nomes no hero, destaques fortes |
| `--azul2` / `--verde` | `#2975D9` | Azul médio — `&`, ícones, separadores, links |
| `--azul3` / `--azul` | `#5EADF2` | Azul claro — bordas, halos, ripples |
| `--azul4` | `#8DC3F2` | Azul pálido — sombras, shimmer suave |
| `--creme` | `#f4f7fc` | Fundo principal — off-white frio |
| `--creme2` | `#eaeff8` | Fundo seções alternadas |
| `--ink` | `#12213d` | Texto principal — azul muito escuro |
| `--ink2` | `#3a5080` | Texto secundário |
| `--muted` | `rgba(41,117,217,0.42)` | Labels, hints |
| `--sep` | `rgba(94,173,242,0.28)` | Linhas divisórias |

> ⚠️ A paleta anterior tinha verdes (`#4a7c6f`, `#16301f`, `#eef2ea` etc.) — **foram todos removidos**. Não reintroduzir jamais.

---

## 4. Tipografia

| Uso | Fonte | Tamanho |
|---|---|---|
| Nomes (Mayane, Lucas) | `Great Vibes` | `clamp(82px,19vw,136px)` |
| `&` entre os nomes | `Cormorant Garamond italic 300` | `clamp(52px,11vw,78px)` |
| Títulos de seção | `Great Vibes` | `clamp(52px,13vw,68px)` |
| Versículos, citações | `Cormorant Garamond italic` | `clamp(17px,4vw,22px)` |
| Corpo, labels | `Raleway` | `clamp(10px,3vw,16px)` |
| Número "18" da data | `Cormorant Garamond 300` | `clamp(108px,23vw,160px)` |

> O `&` usa **Cormorant Garamond** (não Great Vibes) — o glifo `&` do Great Vibes tem flourishes muito longos que quebram o layout.

---

## 5. Estrutura do HTML — Ordem das Seções (v1_aquarela)

```
0. HEADER FIXO (.site-header)
   ├── "Mayane & Lucas" em Great Vibes
   ├── separador vertical .site-header-sep
   ├── "18 · OUT · 2026" em Raleway
   ├── .hflor-l (flor miniatura esquerda — desliza ao rolar)
   └── .hflor-r (flor miniatura direita — desliza ao rolar)

1. HERO (.hero)
   ├── .flor-tl / .flor-tr — flores cantos superior (PNG sem fundo, top:36px)
   ├── .hero-ring — anel decorativo pulsante (ringPulse)
   ├── .monogram-wrap — oval com foto dos noivos
   │   ├── .monogram-ripple — anel de onda CSS (expande em todas direções)
   │   └── .monogram > #mBg — <img> da foto (src copiado por JS de .nimg)
   └── #heroCtx (.hero-context) — recua com opacity/translateY ao interagir
       ├── .hero-blessing (versículo acima dos nomes)
       ├── .hero-name "Mayane"
       ├── .hero-amp "&"
       ├── .hero-name "Lucas"
       ├── .hero-tagline
       └── .scroll-hint (seta animada)

2. FOTO DO LOCAL (.local-wrap) — <img> inteira, sem crop, sem overflow:hidden
3. VERSÍCULO TOP — Eclesiastes 4:9–12
4. ORNAMENT ROW ✦ (.ornament-row)
5. PLAYER VISUAL — visual apenas, sem áudio real
6. DATA (.date-section) — "18" gigante + countdown ao vivo
7. ORNAMENT ROW
8. ENDEREÇOS — cerimônia + recepção + flores laterais prata
9. VERSÍCULO BOX — Provérbios 18:22
10. ORNAMENT ROW
11. ÍCONES 2×2 — SVGs inline 48×48
12. ORNAMENT ROW
13. AVISOS + "Esperamos por você!"
14. SEÇÃO NOIVOS (.noivos-section) — foto .nimg full-width + caption + flores cantos inferiores
15. FOOTER
```

---

## 6. Interações JavaScript (v1_aquarela)

### 6.1 Monograma — sistema de likes / crescimento
- **Fonte da foto**: JS copia `src` do `.nimg` para `#mBg` na inicialização — sem duplicar base64
- **Click acumula escala**: `+6%` por clique, máximo `2.2×`
- **`transform-origin: top center`** → monograma cresce só para baixo
- **`marginBottom` dinâmico**: `24px + MONO_H×(escala-1)` — empurra conteúdo abaixo sem sobreposição
- **`.hero-context` recua**: `opacity` e `translateY` proporcionais à escala, mínimo `opacity:0.25`
- **Micro-bounce**: escala sobe `+0.12` antes de assentar no valor final (sensação física)
- **Shimmer acelera**: `animationDuration` decresce proporcionalmente com os cliques
- **Corações**: SVG azul (`--azul2`) flutua da borda inferior do oval, posição X aleatória, animação `heartFloat`
- **Reset automático**: 4s sem clicar → tudo volta com `2.0s cubic-bezier(.22,1,.36,1)`, ctx com delay `0.3s`

### 6.2 Ripple (ondas do monograma)
- **3 anéis**: `::before`, `::after`, `.monogram-ripple` — todos com `inset:0`
- **`transform-origin: center center`** nos anéis → expande em todas as direções (pedra no lago)
- **`transform-origin: top center`** no `.monogram` → cresce só para baixo
- Anéis ativam somente no `:hover`, com delays `0s / 0.32s / 0.64s`

### 6.3 Flores — scroll physics
- `requestAnimationFrame` loop contínuo: `velocity`, `DAMP=0.82`, `SMOOTH=0.14`
- Scroll rápido = rotação maior (máx `±12°`), scroll lento = pequena
- Flor esquerda e direita giram em sentidos opostos para naturalidade
- Para quando `Math.abs(velocity) < 0.05` — sem loop eterno
- Scroll listener com `{passive:true}` — performance sem jank

### 6.4 Flores — migração para o header
- `IntersectionObserver` na `.flor-tl` detecta saída da viewport superior
- Ao sair: `hdr.classList.add('has-flores')` → flores miniatura deslizam para dentro via CSS transition
- `src` das miniaturas copiado por JS das originais — zero duplicação de base64
- Mesma rotação de scroll aplicada nas 4 flores (2 hero + 2 header) simultaneamente

### 6.5 Countdown ao vivo
- Target: `new Date("2026-10-18T13:30:00")`
- Atualiza a cada segundo via `setInterval`
- Mostra dias / horas / minutos / segundos em `.cd-val` / `.cd-lbl`

---

## 7. Efeitos CSS Notáveis

### Header glass
```css
background: rgba(244,247,252,.28);
backdrop-filter: blur(18px) saturate(1.6);
box-shadow: 0 1px 0 0 rgba(255,255,255,.55) inset;  /* brilho interno topo */
border-bottom: 1px solid rgba(94,173,242,.22);
```

### Flores laterais — prata azulada (seção endereços)
```css
filter:
  sepia(1)
  hue-rotate(185deg)   /* gira para azul-aço */
  saturate(.55)         /* dessatura → prata, não azul saturado */
  brightness(1.18)
  contrast(.88)
  drop-shadow(0 2px 8px rgba(141,195,242,.35))
  drop-shadow(0 0 18px rgba(255,255,255,.40));
```
> ⚠️ Usar sempre `flor_sem_fundo.png` nas laterais — `flor_lateral_direita.png` tem fundo branco opaco e destrói o efeito.

### Flores cantos — hover brisa
```css
.flor-tl:hover { animation: florBreeze 2.5s ease-in-out infinite; }
/* florBreeze: rotate(±1.5deg) + scale(1.02) */
/* animation: ... forwards (não both) — evita piscar ao sair do hover */
/* opacity:.95 no seletor base — garante que nunca some */
```

### Nomes — hover flutuação
```css
.hero-name:hover {
  color: #2975D9;
  transform: translateY(-4px);
  text-shadow: 0 8px 24px rgba(41,117,217,.22), 0 2px 8px rgba(94,173,242,.18);
}
```

### Monograma — borda shimmer idle
```css
@keyframes shimmer {
  0%,100% { box-shadow: 0 0 0 2px rgba(94,173,242,.40), 0 0 12px 2px rgba(94,173,242,.15); }
  50%     { box-shadow: 0 0 0 2px rgba(41,117,217,.70), 0 0 22px 6px rgba(94,173,242,.30); }
}
```

---

## 8. Keyframes CSS disponíveis

```
fadeDown      — de cima → posição (header entry, .3s delay)
fadeUp        — de baixo → posição (seções, nomes)
fadeIn        — aparecer (flores, textos)
scaleIn       — 0.88→1.0 (monograma entry)
arrowBob      — bounce vertical (scroll hint)
ringPulse     — pulso radial (anel hero)
shimmer       — box-shadow pulsante (borda monograma idle)
florBreeze    — brisa hover flores esquerda
florBreezeR   — brisa hover flores direita (scaleX(-1))
ripple1/2/3   — ondas concêntricas (monograma hover)
heartFloat    — corações subindo (clique monograma)
```

---

## 9. Regras Críticas — O que FUNCIONA e o que NÃO FUNCIONA

### ✅ SEMPRE FAZER
1. Fotos como `<img height:auto>` — nunca `background-image` fixo com `cover`
2. `animation: ... forwards` nas flores (não `both`) — evita piscar no hover
3. `transform-origin: center center` nos ripple rings — onda em todas as direções
4. `transform-origin: top center` no monograma — cresce para baixo
5. Copiar `src` de imagem por JS para reaproveitar base64 sem duplicar
6. `{passive:true}` no scroll listener — performance
7. Parar `requestAnimationFrame` quando `Math.abs(v) < 0.05` — sem loop eterno
8. Usar `flor_sem_fundo.png` para TODAS as flores (cantos, header, laterais)
9. Paleta: apenas `#0644BF #2975D9 #5EADF2 #8DC3F2` — nunca verdes

### ❌ NUNCA FAZER
1. `background-attachment: fixed` + imagem base64 → distorce a aquarela
2. `filter: saturate(0)` nas flores laterais → manchas cinzas sem detalhe
3. `animation: ... both` nas flores → pisca ao sair do hover
4. `transform-origin: top center` nos ripple rings → onda nasce só do topo
5. `backdrop-filter` no monograma → desfoca a foto, casal fica irreconhecível
6. `overflow:hidden` no `.hero` → corta o `&` entre os nomes
7. GSAP via CDN externo → quebra offline
8. `object-fit: cover` com altura fixa nas fotos → corta pessoas
9. Qualquer cor `rgba(74,124,111,...)` ou `rgba(22,48,31,...)` — são verdes da paleta antiga

---

## 10. Variantes — Diferenças por versão

| | v1_aquarela | v2_luxo | v3_botanico | v4_noturno |
|---|---|---|---|---|
| **Fundo** | `#f4f7fc` creme | `#0f1620` dark | `#eef2ea` verde claro | `#080d1a` dark azul |
| **Acento** | Azuis `#0644BF` | Ouro `#f0d79b` | Verdes `#1f5730` | Azul noite `#bfd6ff` |
| **Fonte nome** | Great Vibes | Italiana | Parisienne | Pinyon Script |
| **Fonte corpo** | Raleway | Jost | Lato | Montserrat |
| **Status** | ✅ Principal, todas interações | Estrutura igual ao v1 | Estrutura igual ao v1 | Estrutura igual ao v1 |

---

## 11. Pendências / Próximos Passos

- [ ] Adicionar música real ao player (ou remover completamente)
- [ ] Substituir `href="#"` dos ícones pelos URLs reais (Google Maps, form RSVP, WhatsApp)
- [ ] Hospedar online (GitHub Pages, Netlify ou Vercel — arquivo estático)
- [ ] Testar no mobile (iOS Safari + Android Chrome)
- [ ] Corrigir flores laterais v2/v3/v4 se necessário (usar `flor_sem_fundo.png`)
- [ ] Propagar refinamentos do v1 para v2/v3/v4 se aprovado

---

## 12. Contexto para Nova Conversa

> "Convite digital HTML para **Mayane & Lucas** — 18/10/2026, 13h30, R. Adelino Strasi 04, Várzea Paulista SP.
> Versão principal: `v1_aquarela/index.html`. Paleta: `#0644BF #2975D9 #5EADF2 #8DC3F2` (azuis puros, sem verdes).
> Fundo `#f4f7fc`. Interações: monograma com likes/crescimento, ripple rings, flores com scroll physics, header glass com flores migratórias, countdown ao vivo.
> **Leia `PROJETO.md` completo antes de qualquer edição.**"

---

*Última atualização: paleta corrigida para azuis, estrutura v1–v4 documentada, todas as interações JS descritas*
