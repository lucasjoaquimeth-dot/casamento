---
name: convite-casamento
description: >
  Contexto do site de convite de casamento de Mayane & Lucas (18/10/2026):
  HTML/CSS/JS estático, sem build, dois temas, hospedado no GitHub Pages.
  Ative quando o usuário pedir para continuar, editar, revisar ou depurar
  qualquer coisa deste projeto — carta, convite, estilos, temas, assets ou docs.
---

# Convite Digital — Mayane &amp; Lucas

## Identidade

Site estático de convite de casamento. **Sem build, sem framework, sem CDN de
JavaScript.** Única dependência externa: Google Fonts.

- **Noivos**: Mayane &amp; Lucas
- **Data**: 18 de Outubro de 2026, **domingo**, 13h30
- **Local**: Vale Verde — Espaço Acqua · R. Adelino Strasi, 04 — Jardim Brasil, Várzea Paulista · SP
- **Dress code**: Esporte fino · **RSVP até**: 18/09/2026
- **Hospedagem**: GitHub Pages, em subpasta → **só caminhos relativos**

## Estrutura

```
index.html          → <meta refresh> para ./carta/
carta/index.html    → capa (envelope + selo clicável), CSS inline, container queries
convite/
├── index.html      → 9 seções + modal PIX
├── style.css       → estilos e os 2 temas
└── app.js          → 8 IIFEs independentes
assets/{audio,carta,flowers,photos,pix,venue,reference}/
docs/               → PROJETO.md · CHANGELOG.md · DEPLOY.md
serve.js            → dev server (node serve.js → :3000)
```

Antes de editar, leia `docs/PROJETO.md` — é a referência completa.

## Temas

Dois temas, alternados pelo botão do header, persistidos em
`localStorage["convite-theme"]`:

- `serenity` (claro, **padrão**) — vive em `:root`, sem atributo no `<html>`
- `shadow-serenity` (escuro) — `<html data-theme="shadow-serenity">`, ~120 overrides

```
/* Serenity */                    /* Shadow Serenity */
--azul1: #3d6e9e                  --azul1: #1C2333
--azul2: #5a8ab8                  --azul2: #2E3A52
--azul3: #8BADD9                  --azul3: #455673
--azul4: #B6D6F2                  --azul4: #2F3D51
--label:    #4a7aab               --label:    #7DB3E3
--destaque: #3d6e9e               --destaque: #8AC0ED
--creme: #f0f5f8                  --creme: #0F1419
--ink:   #1a2b38                  --ink:   #E8EEF5
```

ℹ️ Os nomes são **semânticos**, não descrevem cor (`--label` = labels uppercase
pequenas, `--destaque` = `<strong>`). A paleta é inteiramente azul: nunca
introduzir verde. Toda alteração de cor precisa ser feita nos **dois** temas.

## Tipografia

| Uso | Fonte |
|---|---|
| Nomes dos noivos | `Great Vibes` `clamp(82px,19vw,136px)` |
| Títulos de seção | `Great Vibes` |
| `&`, versículos, data, countdown | `Cormorant Garamond` |
| Corpo, labels | `Raleway` |

## Módulos de `app.js`

Temas · Monograma (likes) · Countdown · Player · Scroll reveal · Flores
(física de scroll + migração para o header) · Header height (`--header-h`) ·
Modal PIX.

Globais expostas para `onclick`: `playerToggle`, `openPixModal`,
`closePixModal`, `copyPixKey`.

## Regras críticas

### ✅ Sempre
- Fotos como `<img>` com `height:auto`, `loading="lazy"`
- Caminhos relativos `../assets/…`
- `animation: … forwards` nas flores (nunca `both`)
- `transform-origin: center center` nos ripple rings; `top center` no monograma
- `{passive:true}` em `scroll` / `resize`; parar o rAF quando `Math.abs(v) < 0.05`
- Guardas de existência (`if(!el) return;`) em cada IIFE
- JS em ES5 (`var`, `function`) — é o estilo consistente do arquivo

### ❌ Nunca
- Imagens em base64 no HTML (foram removidas de propósito: −406 KB)
- `background-attachment: fixed` em imagem
- `backdrop-filter` no monograma — desfoca o casal
- `overflow:hidden` no `.hero` — corta o `&`
- `object-fit: cover` + altura fixa, ou `max-height` nas fotos no mobile
- Caminho absoluto iniciando com `/` — quebra no GitHub Pages
- CDN de JavaScript ou qualquer etapa de build

## Assets

| Arquivo | Uso |
|---|---|
| `assets/carta/carta.png` | arte do envelope |
| `assets/flowers/flor_serenity.png` | **todas** as flores |
| `assets/photos/monograma.jpg` | monograma oval (setado por `app.js`) |
| `assets/photos/noivos.jpeg` | seção final |
| `assets/venue/local.jpeg` | foto do espaço |
| `assets/pix/qrcode.jpeg` | modal PIX |
| `assets/audio/anjos_cantam.m4a` | player |
| `assets/reference/palheta_serenity.jpeg` | referência de cor, não usada em produção |

## Verificação

```bash
node serve.js   # http://127.0.0.1:3000
```

Checar console sem 404, os dois temas e os breakpoints
(360 / 480 / 768 / 1024 / 1920px). Checklist completo em `docs/DEPLOY.md`.
