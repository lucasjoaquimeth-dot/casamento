# 💎 Como Usar o PIX Presente - Guia Rápido

## 🎯 O que foi feito?

Adicionamos uma modal interativa de PIX ao convite que permite os convidados:
- Ver o QR Code do PIX
- Copiar a chave PIX com um clique
- Ver todos os dados de quem recebe

## 📱 Como acessar?

Ao abrir o convite, clique no ícone **"PIX Presente"** (moeda com símbolo 💎).

## 🎨 O que aparece na modal?

### QR Code
- Tamanho grande para fácil escaneamento
- Arquivo usado: `./assets/photos/QRCode.jpeg`

### Chave PIX
```
c11e4716-c852-40b4-935d-737d80cd83d7
```
- Botão "Copiar" ao lado (ícone de clipboard)
- Após copiar, mostra ✓ em verde por 2 segundos

### Dados do Beneficiário
- **Nome**: Lucas Joaquim da Silva
- **CPF**: 471.477.978-84

### Mensagem
> Seu apoio para nossa lua de mel é muito especial para nós! 💕
> Obrigado por fazer parte deste momento tão importante.

## ⌨️ Controles

| Ação | Efeito |
|------|--------|
| Clicar no ícone PIX | Abre a modal |
| Clicar em "Copiar" | Copia a chave PIX |
| Clicar no X (canto superior direito) | Fecha a modal |
| Clicar fora da modal (no fundo escuro) | Fecha a modal |
| Pressionar ESC | Fecha a modal |

## 🎨 Temas Suportados

A modal funciona com os 2 temas disponíveis:
- ✅ **Serenity** (padrão, claro)
- ✅ **Shadow Serenity** (escuro)

## 📱 Mobile

A modal é totalmente responsiva e funciona perfeitamente em:
- Smartphones
- Tablets
- Desktops

## 🔧 Dados Técnicos

### Arquivos Modificados

#### 1. `convite/index.html`
- 4 links integrados nos ícones
- Modal PIX HTML
- Novo ícone para Cotas da Lua de Mel

#### 2. `convite/style.css`
- 150+ linhas de estilos CSS
- Animações suaves
- Compatibilidade com ambos os temas

#### 3. `convite/app.js`
- Função `openPixModal()`
- Função `closePixModal()`
- Função `copyPixKey()` com feedback visual

## ✅ Testes Realizados

- ✓ Modal abre e fecha corretamente
- ✓ Botão copiar funciona em navegadores modernos e antigos
- ✓ ESC fecha a modal
- ✓ Clique fora fecha a modal
- ✓ Funciona em ambos os temas
- ✓ Responsivo em mobile
- ✓ Sem erros de JavaScript
- ✓ Sem erros de CSS
- ✓ Sem erros de HTML

