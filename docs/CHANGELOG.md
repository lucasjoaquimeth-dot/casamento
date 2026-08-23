# Changelog

Formato baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/).

---

## [1.4.0] — 2026-08-23

### Adicionado
- `README.md` na raiz com estrutura, instruções de execução e índice da documentação.
- `docs/DEPLOY.md` — publicação no GitHub Pages e checklist de QA.
- `loading="lazy"` e `decoding="async"` nas fotos do local e dos noivos.
- `serve.js` agora resolve `index.html` para qualquer diretório e bloqueia
  path traversal; lista as URLs de `carta` e `convite` ao subir.

### Alterado
- **Imagens externalizadas**: as fotos do local e dos noivos estavam embutidas
  em base64 dentro de `convite/index.html` (417 KB). Agora apontam para
  `assets/venue/local.jpeg` e `assets/photos/noivos.jpeg` — arquivos
  byte-idênticos aos blobs anteriores. HTML caiu para **11 KB (−97%)**.
- `serve.js` passou a servir a raiz do repositório em vez de apenas `convite/`
  — antes `/carta/` respondia 404.
- `assets/` reorganizado por função: novas pastas `carta/`, `pix/` e
  `reference/`; `QRCode.jpeg` → `pix/qrcode.jpeg`,
  `venue/carta_versao_final.png` → `carta/carta.png`,
  `photos/M_L-137.jpg` → `photos/monograma.jpg`,
  `venue/palheta_de_cores_azul_serenity.jpeg` → `reference/palheta_serenity.jpeg`.
- `docs/PROJETO.md` reescrito a partir do código real. A versão anterior
  descrevia uma estrutura que não existe mais (`v1_aquarela/` … `v4_noturno/`),
  uma paleta abandonada (`#0644BF`) e informava o dia da semana errado
  (18/10/2026 é **domingo**, não sábado).
- `skills/convite-casamento/SKILL.md` atualizado para a arquitetura atual.

### Removido
- `tools/` (24 MB) — scripts de build/render que geravam `convite_v1_aquarela.html`
  e liam `assets/flor.png`, `assets/flor_sem_fundo.png`, `assets/local.jpeg`:
  arquivos e fluxo de trabalho que não existem mais. Recuperável no histórico Git.
- `.bob/` (7,1 MB) — cache de base64 e `template_clean.html`, obsoletos com as
  imagens externalizadas.
- 48 MB de assets órfãos: `IMG_*.JPEG` (8 fotos não referenciadas),
  `carta_horizontal.png`, `carta_veritical.png`, `vale_verde_fundo.png`,
  `palheta_cores_azul.jpeg` (paleta antiga) e `assets/build/`.
- 9 documentos redundantes em `docs/`: `CHANGES_SUMMARY.md`,
  `CONTRAST_FIX_AUGUST_2026.md`, `FILE_MANIFEST.md`,
  `HEADER_RESPONSIVITY_FIX.md`, `HEADER_RESPONSIVITY_TEST_GUIDE.md`,
  `IMPLEMENTATION_VALIDATION.md`, `QUICK_SUMMARY.md`,
  `SHADOW_SERENITY_IMPLEMENTATION.md` e `VALIDATION_REPORT.txt` — todos
  descreviam a mesma tarefa concluída, com números de linha já defasados.
- 6 skills sem relação com o stack (HTML/CSS/JS puro): `angular-best-practices`,
  `angular-best-practices-material`, `typst` (7,6 MB), `gsap-core`,
  `mermaid-to-image`, `grill-with-docs`.

---

## [1.3.0] — 2026-08-22

### Corrigido
- Contraste crítico no tema Shadow Serenity: `.hero-name` e `.addr-venue`
  usavam `--azul1` (`#1C2333`) sobre fundo `#0F1419` — contraste 1.05:1,
  praticamente invisível. Passaram a usar `--ink` (`#E8EEF5`), ~17:1 (AAA).
- `.hero-amp` (75% → 85%) e `.hero-bless` (65% → 80%) de opacidade.

### Alterado
- Flores passaram a usar `flor_serenity.png` (azul) em vez do PNG rosa.
- `drop-shadow` azul nas flores em todos os pontos (`.flor-*`, `.hflor-*`, `.nf-*`).

---

## [1.2.0] — 2026-08-22

### Adicionado
- Tema **Shadow Serenity** (escuro) com ~120 seletores de override.
- Botão de troca de tema no header, com persistência em `localStorage`.
- Breakpoints responsivos do header (6 faixas, de ≤360px a 1920px+).
- `--header-h` medido em runtime → `body{padding-top}`, evitando que o header
  fixo corte o conteúdo.

### Alterado
- Header exibe as iniciais "M & L" em vez dos nomes completos.

---

## [1.1.0] — 2026-08-21

### Adicionado
- Modal PIX com QR Code, cópia da chave e feedback visual.
- Player de áudio com visualizador de ondas.
- Página `carta/` (envelope com selo clicável) como entrada do site.
- Flores decorativas responsivas.

### Alterado
- Convite dividido em `convite/index.html`, `style.css` e `app.js`
  (antes era um HTML monolítico).

---

## [1.0.0] — 2026-08-20

### Adicionado
- Convite inicial de Mayane &amp; Lucas em página única.
