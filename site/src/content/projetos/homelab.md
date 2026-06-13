---
title: Homelab
slug: homelab
description: "Um ambiente pessoal para código, automação, tarefas, serviços internos e experimentos de infraestrutura rodando em casa."
status: em construção
date: 2026-06-13
tags:
  - homelab
  - self-hosting
  - infraestrutura
  - automação
published: true
---

## Por que isso existe

Meu homelab começou como quase todo homelab começa: curiosidade, alguns containers, uma vontade meio teimosa de rodar as coisas em casa e entender melhor o caminho entre um serviço e o navegador.

Com o tempo ele foi virando outra coisa. Hoje é parte do meu ambiente de trabalho. É onde ficam ferramentas que uso para programar, consultar arquivos, automatizar tarefas, testar ideias e manter um pouco mais de controle sobre o meu próprio fluxo.

Eu gosto dessa ideia por um motivo simples: ela diminui atrito. Em vez de cada coisa morar em um serviço solto, com um login solto, uma aba solta e um contexto perdido, tento trazer tudo para perto. Código, tarefas, notas, agentes, busca, deploy, DNS, proxy. Nada disso é glamuroso. Mas quando funciona, o dia fica mais leve.

## Como está organizado

A base é um servidor em casa rodando [Docker](https://www.docker.com/), alguns serviços em [systemd](https://systemd.io/) e um [Traefik](https://traefik.io/traefik/) na frente. A rede local usa nomes em `home.arpa`, resolvidos pelo meu DNS interno. Quando algum serviço precisa sair da rede de casa, o caminho passa por [Cloudflare Tunnel](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/), sem abrir porta pública direto no roteador.

O desenho mental é mais ou menos este:

<div class="flow-map" aria-label="Fluxo de acesso aos serviços do homelab">
  <span>navegador, terminal ou agente</span>
  <span>DNS local ou Cloudflare Tunnel</span>
  <span>Traefik</span>
  <span>serviços internos</span>
  <span>código, arquivos, tarefas, busca e memória</span>
</div>

Traefik é a porta de entrada local. [Technitium DNS](https://technitium.com/dns/) cuida do DNS. [Docker Compose](https://docs.docker.com/compose/) deixa cada serviço em uma pasta própria, com estado, configuração e rede bem definidos. Alguns serviços rodam como containers; outros rodam direto no host via systemd quando isso faz mais sentido.

Não é uma arquitetura definitiva. É uma arquitetura que foi crescendo conforme eu fui usando.

## O que roda hoje

O Traefik fica na rede `proxy` e resolve as rotas internas. É ele que recebe nomes como `homepage.home.arpa`, `search.home.arpa`, `code.home.arpa`, `t3.home.arpa`, `hermes.home.arpa` e encaminha para o serviço certo.

O Technitium DNS mantém a zona local. Isso parece detalhe até o momento em que você para de decorar IP e porta. Depois disso fica difícil voltar.

O [Homepage](https://gethomepage.dev/) é o painel de entrada. Ele não faz nada muito sofisticado, e talvez por isso seja útil: mostra atalhos, organiza serviços e serve como ponto de partida quando eu não quero lembrar o endereço exato de alguma coisa.

O [SearXNG](https://docs.searxng.org/) roda como busca local. Em alguns fluxos ele entra como alternativa para pesquisar sem depender diretamente de uma busca comercial. Também é usado como peça de apoio para outros serviços.

O [Firecrawl](https://www.firecrawl.dev/) roda com API, [Playwright](https://playwright.dev/), [Redis](https://redis.io/), [RabbitMQ](https://www.rabbitmq.com/) e [Postgres](https://www.postgresql.org/). Ele serve para extração e leitura de páginas, principalmente quando quero transformar conteúdo da web em algo que um agente consiga consultar e resumir melhor.

O Cloudflare Tunnel fica em um container separado. A função dele é simples: publicar apenas o que eu decidir publicar, sem expor o host inteiro. Isso é importante porque nem todo serviço do homelab deve sair para a internet. Algumas coisas são de uso local mesmo.

Também tem este site. O próprio `rafaelmmayer` roda em Docker, servido por [Nginx](https://nginx.org/) e roteado pelo Traefik. O deploy ainda é simples: builda a imagem, recria o container e pronto. Por enquanto isso já resolve.

## Código no navegador

Uma parte importante do homelab é o ambiente de desenvolvimento.

Uso o [T3 Code](https://github.com/pingdotgg/t3code) quando quero abrir um projeto e programar direto pelo navegador. Ele vira uma espécie de estação de trabalho remota, mas rodando aqui. Para algumas tarefas isso é mais prático do que depender da máquina em que estou no momento.

Também uso [code-server](https://github.com/coder/code-server) para navegar e editar arquivos. A diferença é sutil, mas no uso aparece: às vezes quero um ambiente mais voltado a código; às vezes quero só entrar no filesystem, olhar uma configuração, abrir um Compose, conferir um arquivo de serviço.

O [GitHub CLI](https://cli.github.com/) entra nesse mesmo fluxo. Issues, pull requests, branches e histórico ficam acessíveis pelo terminal. Isso importa porque muitos passos deixam de ser uma troca de contexto entre navegador, editor e chat. O agente pode consultar uma issue, olhar o código, editar arquivo, rodar teste e voltar com o resultado.

## Tarefas, contexto e próximos passos

Ainda estou desenvolvendo um [MCP](https://modelcontextprotocol.io/) para [Asana](https://asana.com/). A ideia é conectar minhas tarefas ao resto do ambiente, sem transformar isso em mais uma caixa fechada.

Quero conseguir perguntar o que está pendente, puxar contexto de uma tarefa, transformar uma conversa em próximos passos e manter esse material perto do código. Não quero que o Asana vire centro de tudo. Quero que ele seja uma fonte de tarefas que conversa com o resto.

Isso ainda está em construção. E provavelmente vai mudar bastante quando eu começar a usar de verdade.

## O papel do Hermes

Aqui entra uma parte que tem ficado cada vez mais importante: eu uso um agente [Hermes](https://hermes-agent.nousresearch.com/docs/), ao qual dei o nome de Bob.

O Bob fica perto do lugar onde as coisas acontecem: terminal, arquivos, navegador, ferramentas, skills e memória persistente. Ele consegue lembrar preferências, consultar sessões antigas, editar um Compose, subir um serviço, escrever um rascunho, rodar build, investigar logs e me devolver o que aconteceu.

Tenho pensado nele como uma espécie de segundo cérebro operacional. Não para pensar por mim. Isso seria ruim. O valor está em reduzir o custo de recuperar contexto e transformar intenção em ação.

Eu posso dizer que quero expor um serviço, e ele lembra que aqui o Traefik usa a rede `proxy`, que o DNS local é `home.arpa`, que alguns serviços rodam no host e precisam ser acessados por `host.docker.internal` ou pelo gateway da rede Docker. Posso pedir para criar um deploy simples para este site, e ele escreve o script, roda, vê o erro, corrige e valida.

Isso muda a relação com o homelab. A infra deixa de ser só um conjunto de arquivos que eu preciso lembrar de cabeça. Ela vira um ambiente que consigo operar conversando, desde que eu continue verificando as decisões importantes.

## Fluxo real de uso

Um fluxo típico fica mais ou menos assim.

Abro o painel local e entro no serviço que preciso. Se vou programar, abro o T3 Code. Se quero olhar arquivo e configuração, vou de code-server. Se preciso mexer em issue ou pull request, uso GitHub CLI pelo terminal. Se quero investigar algo da web, Firecrawl e SearXNG entram como apoio. Se a tarefa nasceu no Asana, a ideia é que o MCP traga esse contexto para perto.

No meio disso, o Bob costura as partes. Ele não substitui o trabalho, mas tira boa parte do atrito. Em vez de eu ficar alternando entre lembrar comando, procurar arquivo, abrir dashboard e copiar contexto de um lugar para outro, eu consigo pedir uma sequência de ações e acompanhar o resultado.

Quando dá certo, parece pouca coisa. E talvez seja mesmo. Só que pouca coisa repetida todo dia vira uma diferença grande.

## A série

Esta página fica como visão geral do projeto. Em paralelo, estou organizando uma série de artigos para abrir cada parte com mais calma. Não precisa ter um artigo introdutório separado, porque a introdução já é esta página.

O primeiro texto da série é sobre [DNS local e `home.arpa`](/artigos/homelab/dns-local-e-home-arpa/). Depois quero escrever sobre Traefik, Cloudflare Tunnel, busca e leitura da web, código no navegador e o uso do Bob como parte da operação.

Prefiro assim porque o homelab muda o tempo todo. O projeto registra o estado geral. A série deixa espaço para entrar nos detalhes e continuar quando alguma peça nova aparecer.

## O que ainda falta

Ainda tem bastante coisa para arrumar.

Quero separar melhor o que é local, o que pode ser público e o que deve ficar atrás de autenticação forte. Também quero melhorar backup, observabilidade e documentação. Alguns serviços ainda estão em modo experimento. Outros funcionam bem, mas foram montados do jeito pragmático: primeiro fazer funcionar, depois limpar.

Também quero escrever mais sobre partes específicas. Traefik, Cloudflare Tunnel, agentes locais, MCP, DNS interno, deploy de serviço estático. Cada pedaço dá um artigo próprio.

Por enquanto, o Homelab é isso: um ambiente pessoal onde infraestrutura, oficina e memória externa acabam se misturando. Um lugar onde eu posso construir ferramentas para trabalhar melhor e entender melhor o que estou construindo.
