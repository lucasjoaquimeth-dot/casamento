---
name: convite-casamento
description: >
  Contexto completo do projeto de convite digital de casamento Mayane & Lucas.
  Ative quando o usuário pedir para continuar, editar ou criar algo no convite.
---

# Convite Digital — Mayane & Lucas

## Identidade do Projeto

Convite de casamento 100% HTML, self-contained (imagens como base64 inline), sem dependências CDN exceto Google Fonts.

- **Noivos**: Mayane & Lucas
- **Data**: 18 de Outubro de 2026, Sábado, 13h30
- **Local**: R. Adelino Strasi, 04 — Jardim Brasil, Várzea Paulista · SP
- **Dress code**: Esporte fino | **RSVP até**: 18/09/2026

## Arquivo Principal

`v1_aquarela/index.html` — versão mais evoluída. Leia `PROJETO.md` para o estado completo.

## Paleta — APENAS AZUIS

```
--azul1: #0644BF   (escuro — nomes, destaques)
--azul2: #2975D9   (médio  — &, ícones, links)
--azul3: #5EADF2   (claro  — bordas, halos, ripples)
--azul4: #8DC3F2   (pálido — sombras, shimmer)
--creme: #f4f7fc   (fundo principal)
--ink:   #12213d   (texto principal)
```

**NUNCA usar verdes** (`#4a7c6f`, `#16301f`, `#eef2ea`, `rgba(74,124,111,...)` etc.).

## Tipografia

| Uso | Fonte |
|---|---|
| Nomes (Mayane, Lucas) | `Great Vibes` `clamp(82px,19vw,136px)` |
| `&` | `Cormorant Garamond italic 300` `clamp(52px,11vw,78px)` |
| Títulos | `Great Vibes` `clamp(52px,13vw,68px)` |
| Corpo | `Raleway` |

## Regras Críticas

### ✅ SEMPRE
- Fotos como `<img height:auto>` — nunca `background-image` fixo
- `animation: ... forwards` nas flores (não `both`)
- `transform-origin: center center` nos ripple rings
- `transform-origin: top center` no monograma
- `flor_sem_fundo.png` para TODAS as flores
- `{passive:true}` no scroll listener
- Parar `requestAnimationFrame` quando `Math.abs(v) < 0.05`

### ❌ NUNCA
- `background-attachment: fixed` com imagem → distorce aquarela
- `backdrop-filter` no monograma → desfoca o casal
- `overflow:hidden` no `.hero` → corta o `&`
- `animation: ... both` nas flores → pisca ao sair do hover
- `transform-origin: top center` nos ripple rings → onda nasce só do topo
- GSAP via CDN externo

## Interações JavaScript Implementadas (v1_aquarela)

1. **Monograma likes**: clique +6% escala (máx 2.2×), micro-bounce, corações flutuantes, reset 4s
2. **Ripple rings**: 3 anéis concêntricos em hover, `transform-origin: center center`
3. **Scroll physics**: `requestAnimationFrame` com `DAMP=0.82`, flores giram em sentidos opostos
4. **Header flores**: `IntersectionObserver` migra flores do hero para o header ao rolar
5. **Countdown**: `setInterval` para `2026-10-18T13:30:00`, dias/horas/min/seg

## Assets

| Arquivo | Uso |
|---|---|
| `assets/local.jpeg` | Foto do local — `<img>` full-width na seção logo abaixo do hero |
| `assets/noivos.jpeg` | Foto do casal — monograma oval no hero |
| `assets/flor_sem_fundo.png` | Flores PNG com alpha — USAR PARA TUDO |
| `assets/flor_lateral_direita.png` | ⚠️ TEM FUNDO BRANCO — não usar diretamente |
| `.bob/*_b64.txt` | Cache base64 das imagens — não versionar |

## Variantes

| Versão | Estilo | Status |
|---|---|---|
| `v1_aquarela/` | Azul aquarela, creme | ✅ Principal |
| `v2_luxo/` | Dark + ouro | Estrutura igual ao v1 |
| `v3_botanico/` | Verde botânico, claro | Estrutura igual ao v1 |
| `v4_noturno/` | Dark azul noturno | Estrutura igual ao v1 |
