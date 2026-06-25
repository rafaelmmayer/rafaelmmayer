---
title: "Homelab: código no navegador"
description: "Como uso T3 Code e code-server para ter um ambiente de desenvolvimento acessível pelo navegador dentro do homelab."
date: 2026-06-19
type: Artigo
order: 6
tags:
  - homelab
  - desenvolvimento
  - ferramentas
published: true
---

Uma parte importante do [meu homelab](/projetos/homelab/) é poder mexer em código e configuração pelo navegador.

O objetivo é ter uma bancada perto do servidor, dos arquivos e das ferramentas que rodam em casa. Continuo gostando de trabalhar na minha máquina quando estou nela, mas algumas tarefas pedem proximidade com o ambiente do homelab.

Hoje uso duas peças principais para isso: T3 Code e code-server.

## O incômodo da máquina certa

Existe um tipo de tarefa que sempre parece pequena demais para abrir o fluxo completo de desenvolvimento, mas grande demais para fazer de qualquer jeito.

Olhar um compose. Corrigir uma configuração. Conferir um arquivo de serviço. Abrir um projeto que está no servidor. Ajustar um script. Ver um log e alterar alguma coisa logo em seguida.

Quando tudo depende da máquina certa, essas tarefas ganham atrito. Se estou no computador principal, ótimo. Se estou em outro lugar, preciso ter chave, editor, clone atualizado, ambiente e acesso ao caminho certo. Para trabalho sério isso faz parte. Para pequenas operações do homelab, vira fricção repetida.

Ter código no navegador resolve uma parte desse uso. Eu abro uma URL interna e já estou perto do ambiente onde as coisas rodam.

## T3 Code para abrir um projeto

O T3 Code roda como serviço systemd no host:

```text
t3-web.service
```

O serviço chama um script em:

```text
/home/mayer/.local/bin/start-t3-web
```

Hoje esse script inicia o T3 em modo web, sem abrir navegador, escutando no endereço Docker do host e na porta `3773`:

```text
npx -y t3@latest start --no-browser --mode web --host 172.17.0.1 --port 3773
```

Pelo lado do Traefik, a rota local fica em:

```text
t3.home.arpa
```

A configuração dinâmica aponta esse nome para `host.docker.internal:3773`. Para quem usa, o detalhe some. Eu entro em `t3.home.arpa` e trabalho com o serviço pelo nome.

O T3 Code faz mais sentido quando quero abrir um projeto como ambiente de trabalho. É o lugar para mexer em código com mais intenção: navegar no repositório, editar múltiplos arquivos, rodar comandos e seguir uma tarefa com mais continuidade.

Ele combina bem com agentes porque já parte de um ambiente web voltado a desenvolvimento. A experiência fica mais próxima de uma estação remota do que de um painel administrativo.

## code-server para olhar e editar arquivo

O code-server também roda direto no host via systemd. A anotação que deixei no homelab é bem objetiva:

```text
Serviço: code-server@mayer
Config: /home/mayer/.config/code-server/config.yaml
Porta local: 8081
URL: http://code.home.arpa
```

No Traefik, a rota `code.home.arpa` aponta para `host.docker.internal:8081`.

Uso o code-server de um jeito um pouco diferente. Ele é muito útil quando quero entrar no filesystem, olhar estrutura, abrir configuração, conferir um arquivo de volume, editar um YAML pequeno ou entender o estado de alguma pasta.

Às vezes o que eu preciso é só uma visão boa dos arquivos. Para isso, code-server é uma ferramenta confortável. Não precisa transformar toda operação em sessão de desenvolvimento completa.

## Dois caminhos, uma superfície

Na prática, eu separo assim:

<div class="flow-map" aria-label="Fluxo entre navegador, Traefik, T3 Code, code-server e arquivos do homelab">
  <span>navegador</span>
  <span>Traefik</span>
  <span>T3 Code ou code-server</span>
  <span>projetos e configs</span>
</div>

Se vou programar em um projeto, tendo a abrir o T3 Code. Se quero inspecionar e editar arquivo do homelab, code-server costuma ser suficiente.

Os dois passam pelo mesmo modelo do resto da infraestrutura. DNS local dá nome. Traefik recebe a requisição. O serviço pode rodar no host, mas a entrada continua organizada.

Isso evita uma divisão chata entre serviços em container e serviços no host. Para mim, `t3.home.arpa` e `code.home.arpa` são parte da mesma superfície de uso que `search.home.arpa`, `hermes.home.arpa` e `homepage.home.arpa`.

## Perto das ferramentas certas

A vantagem real aparece quando o editor está perto do resto.

O servidor já tem Bun, uv, GitHub CLI, repositórios locais, scripts do homelab, serviços systemd e pastas de configuração. Quando abro um editor ali, muita coisa já está no lugar certo.

Isso ajuda especialmente em tarefas de infraestrutura pessoal. Se preciso ajustar uma rota do Traefik, o arquivo está no servidor. Se quero olhar um compose, ele está na pasta do serviço. Se quero editar um artigo, o repo do site está perto do ambiente de build. Se quero usar o Bob junto, ele também está na mesma máquina, com acesso aos mesmos caminhos.

O resultado é menos cópia de contexto. Eu não fico mandando arquivo para lá e para cá. Abro o ambiente certo e trabalho onde o problema mora.

## A fronteira de segurança

Editor no navegador é uma ferramenta sensível.

Um serviço desses pode mexer em código, arquivo, token, configuração e comando. Por isso trato acesso remoto com cuidado. A regra conservadora é manter local, usar VPN quando fizer sentido e evitar URL pública simples para qualquer coisa com poder de operação.

Isso conversa com o texto sobre [Cloudflare Tunnel](/artigos/homelab/cloudflare-tunnel/). Nem todo serviço que tem uma rota bonita merece sair para a internet. Ambiente de código entra na categoria que exige mais critério.

Mesmo dentro da LAN, vale manter a pergunta viva: quem acessa, por onde, com qual autenticação e com qual capacidade de estrago?

## A bancada

A imagem que mais gosto para essa parte é bancada.

T3 Code e code-server não precisam ser o melhor editor possível em todos os cenários. Eles precisam estar disponíveis quando quero mexer no ambiente sem montar uma operação maior do que a tarefa pede.

Para mim, isso é bem homelab. Um conjunto de ferramentas pequenas, conectadas do jeito certo, que deixam o trabalho cotidiano menos travado.

Ainda quero organizar melhor essa camada. Falta documentar quando usar cada ambiente, revisar autenticação, limpar extensões antigas e talvez separar melhor workspace de código e workspace de operação. Também quero deixar mais explícito quais caminhos o Bob pode editar sem pedir contexto adicional.

Mas a decisão principal está funcionando: ter código no navegador, perto da infra, torna o homelab mais operável. Minha máquina principal continua sendo meu ambiente mais confortável. A bancada no navegador fica sempre dentro da casa.
