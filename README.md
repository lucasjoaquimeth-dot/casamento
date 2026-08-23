# Mayane &amp; Lucas — Convite de Casamento

Convite de casamento digital, 100% estático (HTML + CSS + JavaScript puro, sem
build e sem framework). Hospedado no GitHub Pages.

**18 de Outubro de 2026 · Domingo · 13h30 · Vale Verde — Espaço Acqua**

---

## Como rodar localmente

```bash
node serve.js
```

Depois abra <http://127.0.0.1:3000> — o fluxo começa na carta.

> Um servidor é necessário: abrir os arquivos via `file://` quebra o áudio e as
> imagens relativas em alguns navegadores.

## Estrutura

```
.
├── index.html            → redireciona para ./carta/ (entrada do site)
├── serve.js              → servidor estático de dev (Node, sem dependências)
│
├── carta/index.html      → capa: envelope com selo clicável → convite
├── convite/              → convite completo (página única)
│   ├── index.html        →   marcação das 9 seções
│   ├── style.css         →   estilos + 2 temas (Serenity / Shadow Serenity)
│   └── app.js            →   temas, monograma, countdown, player, flores
│
├── assets/
│   ├── audio/            → anjos_cantam.m4a (trilha do player)
│   ├── carta/            → carta.png (arte do envelope)
│   ├── flowers/          → flor_serenity.png (todas as flores decorativas)
│   ├── photos/           → monograma.jpg, noivos.jpeg
│   ├── pix/              → qrcode.jpeg (modal PIX)
│   ├── venue/            → local.jpeg (foto do espaço)
│   └── reference/        → palheta_serenity.jpeg (referência de cor, não usada em produção)
│
├── docs/                 → PROJETO.md, CHANGELOG.md, DEPLOY.md
└── skills/               → contexto para agentes de IA (Cline / Claude)
```

## Documentação

| Arquivo | Conteúdo |
|---|---|
| [`docs/PROJETO.md`](docs/PROJETO.md) | Referência completa: dados, paleta, tipografia, seções, JS, regras críticas |
| [`docs/CHANGELOG.md`](docs/CHANGELOG.md) | Histórico de versões |
| [`docs/DEPLOY.md`](docs/DEPLOY.md) | Publicação no GitHub Pages e checklist de QA |

Antes de editar qualquer coisa, leia `docs/PROJETO.md` — ele documenta as
decisões que não são óbvias no código.
