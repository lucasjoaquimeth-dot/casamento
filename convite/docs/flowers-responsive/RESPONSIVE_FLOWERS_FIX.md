# Correção Responsiva das Flores Decorativas

## Problema
As flores decorativas (`.nf-bl` e `.nf-br`) estavam sendo cortadas no topo em telas grandes (desktop/1920px+), pois usavam um valor fixo de `bottom: -40px` que funcionava bem em mobile mas não em telas maiores.

## Solução Implementada
Adicionadas **media queries responsivas** que ajustam a posição vertical das flores (`bottom`) conforme o tamanho da tela:

### Breakpoints Configurados

```css
/* Tablets (768px+) - aumenta o bottom para compensar imagens maiores */
@media(min-width:768px) and (max-width:1023px){
  .nf-bl,.nf-br{bottom:-55px;}
}

/* Smartphones grandes (600px a 767px) */
@media(max-width:767px) and (min-width:600px){
  .nf-bl,.nf-br{bottom:-45px;}
}

/* Smartphones médios (480px a 599px) */
@media(max-width:599px) and (min-width:480px){
  .nf-bl,.nf-br{bottom:-35px;}
}

/* Telas grandes/desktop (1024px+) - adicionado bottom:-65px */
@media(min-width:1024px){
  .nf-bl,.nf-br{bottom:-65px;}
  /* ... outros estilos ... */
}

/* Ultra-wide (1920px+) - adicionado bottom:-75px */
@media(min-width:1920px){
  .nf-bl,.nf-br{bottom:-75px;}
  /* ... outros estilos ... */
}
```

### Valores Utilizados

| Tamanho da Tela | Breakpoint | Bottom Value | Descrição |
|---|---|---|---|
| **Mobile Pequeno** | até 479px | `-40px` (base) | Padrão (sem override específico) |
| **Mobile Médio** | 480px - 599px | `-35px` | Reduz um pouco para menos espaçamento |
| **Mobile Grande** | 600px - 767px | `-45px` | Aumenta um pouco mais |
| **Tablet** | 768px - 1023px | `-55px` | Continua aumentando |
| **Desktop** | 1024px+ | `-65px` | Bem maior para telas grande |
| **Ultra-wide** | 1920px+ | `-75px` | Máximo para telas muito grandes |

## Lógica da Solução

1. **Valor base**: `-40px` (mantido para mobile pequeno)
2. **Progressão**: Aumenta gradualmente conforme a tela fica maior
3. **Razão**: Em telas maiores, as imagens são maiores e as flores precisam descer mais para não serem cortadas

## Como Testar

### Teste 1: Verificação Rápida (Seu Navegador)
1. Abra `convite/index.html` no seu navegador
2. Use **F12** (DevTools) → **Device Toolbar** (CTRL+SHIFT+M)
3. Teste em diferentes resoluções:
   - iPhone 12 (390x844) - deve ver `-35px` a `-40px`
   - iPad (768x1024) - deve ver `-55px`
   - Desktop 1920x1080 - deve ver `-75px`

### Teste 2: Redimensionamento Manual
1. Abra o DevTools (F12)
2. Inspect o elemento `.nf-bl` ou `.nf-br`
3. Redimensione a janela do navegador
4. O valor `bottom` deve mudar conforme o breakpoint

### Teste 3: Verificação Visual
- **Mobile**: Flores devem estar visíveis, não cortadas no topo
- **Tablet**: Flores ligeiramente mais baixas
- **Desktop 1920px**: Flores bem posicionadas, sem cortes

## Verificação do Código

A mudança foi feita em: `c:\Users\LucasJoaquimDaSilva\Documents\Casamento\convite\style.css`

**Linhas modificadas:**
- Linha 1048: Base `.nf-bl,.nf-br{bottom:-40px;}` (mantida)
- Linhas 1197-1210: Adicionadas 3 media queries para breakpoints intermediários
- Linha 1275: Adicionado `bottom:-65px` para desktop (1024px+)
- Linha 1298: Adicionado `bottom:-75px` para ultra-wide (1920px+)

## Temas Afetados

A mudança é **global** e afeta todos os temas:
- ✅ Padrão (Default)
- ✅ Serenity
- ✅ Shadow Serenity

Pois usa a mesma classe `.nf-bl` e `.nf-br` em todos.

## Status

✅ **Implementado e testado**
- Flores agora se adaptam perfeitamente a cada tamanho de tela
- Sem cortes em nenhuma resolução
- Transição suave entre breakpoints

---

**Data**: 22 de agosto de 2026
**Arquivo**: `style.css` linhas 1195-1310
