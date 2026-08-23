# Convite de Casamento — Mayane &amp; Lucas

Referência técnica do projeto. **Leia este arquivo antes de qualquer edição.**

---

## 1. Dados do casamento

| Campo | Valor |
|---|---|
| **Noivos** | Mayane &amp; Lucas |
| **Data** | 18 de Outubro de 2026 — **Domingo** |
| **Horário** | 13h30 |
| **Cerimônia e recepção** | Vale Verde — Espaço Acqua |
| **Endereço** | R. Adelino Strasi, 04 — Jardim Brasil, Várzea Paulista · SP |
| **Dress code** | Esporte fino |
| **RSVP até** | 18/09/2026 |
| **Contagem regressiva** | alvo `2026-10-18T13:30:00` (`convite/app.js`) |

## 2. Links externos usados

| Destino | URL |
|---|---|
| Mapa | `https://maps.app.goo.gl/egAJYvL6jMXkU9BH8` |
| Lista de presentes | `https://sites.icasei.com.br/lucasmayane/pages/38500020` |
| Cotas da lua de mel | `https://sites.icasei.com.br/lucasmayane/pages/38500022` |
| Confirmar presença | `https://sites.icasei.com.br/lucasmayane/pages/38500021` |
| PIX | modal interno — chave aleatória `c11e4716-c852-40b4-935d-737d80cd83d7` |

## 3. Arquitetura

Site estático, **sem build e sem framework**. Só três arquivos de código:

```
index.html          → <meta refresh> para ./carta/
carta/index.html    → capa autocontida (CSS inline, container queries)
convite/
├── index.html      → marcação
├── style.css       → estilos + temas
└── app.js          → comportamento (8 IIFEs independentes)
```

Únicas dependências externas: **Google Fonts**. Nada de CDN de JavaScript —
o convite precisa funcionar em conexões ruins.

### Fluxo de navegação

```
/  →  /carta/  →  (clique no selo)  →  /convite/
```

### Assets referenciados (todos com caminho relativo `../assets/...`)

| Arquivo | Onde é usado |
|---|---|
| `assets/carta/carta.png` | `carta/index.html` — arte do envelope |
| `assets/flowers/flor_serenity.png` | flores do hero, header, endereço e noivos |
| `assets/photos/monograma.jpg` | fundo do monograma oval (setado em `app.js`) |
| `assets/photos/noivos.jpeg` | seção final `.noivos-sec` |
| `assets/venue/local.jpeg` | foto do espaço, dentro do hero |
| `assets/pix/qrcode.jpeg` | modal PIX |
| `assets/audio/anjos_cantam.m4a` | player de música |
| `assets/reference/palheta_serenity.jpeg` | apenas referência de cor — **não** carregado pelo site |

> Imagens são arquivos externos, **não base64 inline**. As duas fotos grandes
> ficaram embutidas em base64 no passado (417 KB de HTML); hoje são `<img>` com
> `loading="lazy"` (11 KB de HTML). Não reintroduzir base64.

## 4. Temas

Dois temas, alternados pelo botão do header e persistidos em
`localStorage["convite-theme"]`. `serenity` é o padrão e vive em `:root`
(sem atributo no `<html>`); `shadow-serenity` é aplicado via
`<html data-theme="shadow-serenity">`.

Ao trocar, `app.js` dispara o evento `convite:theme-change`, que o módulo das
flores escuta para animar a substituição.

### Serenity (claro — padrão)

| Variável | Hex | Uso |
|---|---|---|
| `--azul1` | `#3d6e9e` | escuro — títulos, destaques |
| `--azul2` | `#5a8ab8` | médio |
| `--azul3` | `#8BADD9` | claro — bordas, halos, separadores |
| `--azul4` | `#B6D6F2` | pálido — sombras, shimmer |
| `--verde` | `#4a7aab` | labels uppercase pequenas (alias legado, **é azul**) |
| `--verde2` | `#3d6e9e` | `<strong>`, destaques |
| `--creme` / `--creme2` | `#f0f5f8` / `#e4eff4` | fundos |
| `--ink` / `--ink2` | `#1a2b38` / `#2e4a5e` | textos |

### Shadow Serenity (escuro)

| Variável | Hex |
|---|---|
| `--azul1` … `--azul4` | `#1C2333` · `#2E3A52` · `#455673` · `#2F3D51` |
| `--verde` / `--verde2` / `--azul` | `#7DB3E3` · `#8AC0ED` · `#7DB3E3` |
| `--creme` / `--creme2` | `#0F1419` / `#1A2230` |
| `--ink` / `--ink2` | `#E8EEF5` / `#B8C8DC` |

Contraste dos textos principais validado em WCAG 2.1 AA/AAA.

> ⚠️ `--verde` e `--verde2` são **nomes legados** de uma paleta abandonada.
> Hoje contêm azuis. Renomear exigiria tocar em ~120 seletores; a decisão foi
> mantê-los. **Não** colocar verde real neles.

## 5. Tipografia (Google Fonts)

| Uso | Fonte | Tamanho |
|---|---|---|
| Nomes dos noivos | `Great Vibes` | `clamp(82px,19vw,136px)` |
| Títulos de seção | `Great Vibes` | `clamp(40px,13vw,68px)` |
| `&`, versículos, data, countdown | `Cormorant Garamond` | variável |
| Corpo, labels, botões | `Raleway` | variável |

## 6. Seções de `convite/index.html`

Na ordem, separadas pelo ornamento `<div class="orn">`:

1. `.site-header` — fixo: "M & L", data, flores migratórias, botão de tema
2. `.hero` — flores nos cantos, monograma, nomes, `.player-sec`, foto do local
3. `.verse-top` — Eclesiastes 4:9–10
4. `.date-sec` — data grande + countdown ao vivo
5. `.addr-sec` — endereço, nome do espaço e link do mapa
6. `.verse-mid` — Provérbios 18:22
7. `.icons-sec` — 4 ícones SVG: presentes, PIX, lua de mel, RSVP
8. `.avisos-sec` — RSVP, dress code, pontualidade
9. `.noivos-sec` — foto do casal com gradientes e flores nos cantos
10. `.pix-modal` — modal do PIX (fora do fluxo, no fim do `<body>`)

A altura real do header é medida em runtime e exposta como `--header-h`,
consumida por `body{padding-top}` — por isso o conteúdo nunca fica cortado.

## 7. Módulos de `convite/app.js`

Cada bloco é uma IIFE independente que verifica a existência dos elementos
antes de agir (falha silenciosa se o HTML mudar).

| Módulo | Responsabilidade |
|---|---|
| **Temas** | aplica o tema salvo antes do paint (sem flash), rotaciona no clique, dispara `convite:theme-change` |
| **Monograma** | clique → +6% de escala (máx `2.2×`), micro-bounce, corações flutuantes, contexto recua; reset após 4s |
| **Countdown** | `setInterval` de 1s até `2026-10-18T13:30:00`; ao chegar exibe "Chegou o grande dia!" |
| **Player** | play/pause do `<audio>`, ondas concêntricas dirigidas por `beatPattern` (tempos mapeados na mão) |
| **Scroll reveal** | `IntersectionObserver` (`threshold 0.07`) → adiciona `.sv-visible` |
| **Flores** | física de scroll com `requestAnimationFrame` (`SENS .018`, `MAX 12°`, `DAMP .82`, `SMOOTH .14`), migração hero → header via observer, animação na troca de tema |
| **Header height** | mede o header e escreve `--header-h`; re-mede em `fonts.ready`, `resize` e `orientationchange` |
| **Modal PIX** | abre/fecha (clique, ✕, ESC), copia a chave com `navigator.clipboard` + fallback `execCommand` |

Funções expostas no `window` (chamadas por `onclick` no HTML):
`playerToggle`, `openPixModal`, `closePixModal`, `copyPixKey`.

## 8. Responsividade

Breakpoints em `convite/style.css`:

`≤360px` · `≤479px` · `480–599px` · `600–767px` · `≤767px` · `768px+` ·
`768–1023px` · `1024px+` · `1920px+`

O header reserva `padding-right` para o botão de tema, que tem `flex-shrink:0`
— assim ele nunca sobrepõe o texto. Abaixo de 600px o rótulo "Tema" é ocultado
e fica só o ícone.

`carta/index.html` usa **container queries** (`cqw`) em vez de media queries:
o selo e o texto escalam com o tamanho do card, não da viewport.

## 9. Regras críticas

### ✅ Sempre

- Fotos como `<img>` com `height:auto` — nunca `background-image` com `cover`
- `animation: … forwards` nas flores (nunca `both`)
- `transform-origin: center center` nos ripple rings
- `transform-origin: top center` no monograma (cresce para baixo)
- `{passive:true}` nos listeners de `scroll` / `resize`
- Parar o `requestAnimationFrame` quando `Math.abs(v) < 0.05`
- Caminhos relativos (`../assets/…`) — o site roda em subpasta no GitHub Pages
- `loading="lazy"` nas fotos grandes

### ❌ Nunca

- Reintroduzir imagens em base64 no HTML
- `background-attachment: fixed` em imagem — distorce e trava no iOS
- `backdrop-filter` no monograma — desfoca o casal
- `overflow:hidden` no `.hero` — corta o `&` entre os nomes
- `object-fit: cover` + altura fixa nas fotos — corta as pessoas
- `max-height` nas fotos do mobile — removido de propósito (commit `03232e2`)
- Caminho absoluto começando com `/` — quebra no GitHub Pages
- Verde real em `--verde` / `--verde2`
- Qualquer CDN de JavaScript

## 10. Pendências

- [ ] Testar em iOS Safari e Android Chrome reais
- [ ] Otimizar `assets/photos/monograma.jpg` (5,1 MB → alvo < 500 KB)
- [ ] Otimizar `assets/carta/carta.png` (2,2 MB — avaliar WebP)
- [ ] Mapear `beatPattern` do player para a música inteira (hoje cobre ~2,2s)
- [ ] Avaliar `prefers-reduced-motion` nas animações

