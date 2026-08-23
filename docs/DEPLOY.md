# Deploy e QA

## Publicação (GitHub Pages)

O repositório é um site estático sem build — o deploy é o próprio push.

```bash
git add -A
git commit -m "sua mensagem"
git push origin main
```

No GitHub: **Settings → Pages → Source: Deploy from a branch → `main` / `/ (root)`**.

O site fica disponível em
`https://<usuario>.github.io/casamento/` e a raiz redireciona para `/carta/`.

> Por isso **todos** os caminhos de asset são relativos (`../assets/…`).
> Um caminho começando com `/` quebraria em produção, pois o site vive numa
> subpasta.

## Teste local antes de publicar

```bash
node serve.js
```

- <http://127.0.0.1:3000> → deve redirecionar para a carta
- <http://127.0.0.1:3000/carta/> → envelope
- <http://127.0.0.1:3000/convite/> → convite completo

## Checklist de QA

### Carregamento
- [ ] Nenhum 404 no console (Network → filtrar por "img"/"media")
- [ ] Foto do local e foto dos noivos aparecem
- [ ] Monograma exibe a foto do casal
- [ ] QR Code aparece no modal PIX

### Navegação
- [ ] `/` redireciona para `/carta/`
- [ ] Selo da carta abre o convite
- [ ] Os 3 links do iCasei e o link do mapa abrem em nova aba

### Interações
- [ ] Botão de tema alterna Serenity ↔ Shadow Serenity e persiste após F5
- [ ] Countdown atualiza a cada segundo
- [ ] Player toca o áudio e as ondas reagem
- [ ] Monograma cresce ao clicar e volta sozinho após ~4s
- [ ] Modal PIX abre, copia a chave (✓ azul com shimmer) e fecha com ✕, overlay e ESC
- [ ] Flores giram no scroll e migram para o header

### Responsividade (DevTools)
Testar em 360, 390, 480, 600, 768, 1024, 1440 e 1920px:
- [ ] Botão de tema não sobrepõe "M & L" nem a data
- [ ] Header não corta o conteúdo do topo
- [ ] O `&` entre os nomes não é cortado
- [ ] Fotos não cortam pessoas
- [ ] Sem scroll horizontal

### Temas
Repetir os itens acima nos dois temas — o escuro tem ~120 overrides próprios.

### Dispositivos reais
- [ ] iOS Safari (o player exige interação do usuário para tocar)
- [ ] Android Chrome
