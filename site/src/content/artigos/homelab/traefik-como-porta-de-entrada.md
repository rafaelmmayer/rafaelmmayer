---
title: "Homelab: Traefik como porta de entrada"
description: "Por que centralizei as rotas locais do homelab no Traefik e como isso ajuda a manter os serviços mais fáceis de operar."
date: 2026-06-15
type: Artigo
order: 2
tags:
  - homelab
  - traefik
  - docker
published: true
---

No [artigo sobre DNS local](/artigos/homelab/dns-local-e-home-arpa/), falei da primeira parte do conforto: parar de abrir serviço por IP e porta.

Mas DNS sozinho não resolve tudo. Ele dá nome. Ainda falta decidir o que acontece quando esse nome chega no servidor.

No meu homelab, essa entrada passa pelo Traefik.

## O problema de cada serviço abrir sua própria porta

No começo, é tentador deixar cada serviço aparecer do jeito que veio. Um container expõe `3000`, outro expõe `8080`, outro abre `9443`, um painel roda direto no host, outro tem compose próprio, e por aí vai.

Isso funciona por um tempo. O problema é que cada serviço começa a carregar uma exceção própria. Para abrir um, você precisa lembrar a porta. Para mover outro, precisa trocar o favorito salvo no navegador. Para explicar para o Bob onde fica alguma coisa, precisa passar endereço, porta e contexto.

O atrito aparece na operação do dia a dia.

Homelab pequeno também precisa ser operável. Se toda tarefa começa com uma pequena caça ao endereço certo, o ambiente fica com cara de improviso mesmo quando os serviços estão funcionando.

## O papel do Traefik aqui

O Traefik entra como a porta comum dos serviços web.

O desenho mental é este:

<div class="flow-map" aria-label="Fluxo entre navegador, DNS local, Traefik e serviços do homelab">
  <span>navegador</span>
  <span>DNS local</span>
  <span>Traefik</span>
  <span>serviço</span>
</div>

O navegador pede `homepage.home.arpa`. O DNS local responde para onde esse nome aponta. O Traefik recebe a requisição, olha o hostname e encaminha para o serviço certo.

A parte importante é que o navegador não precisa saber se o serviço está em container, em qual porta ele escuta, se mudou de compose ou se roda no host. O endereço externo continua sendo o nome.

No meu setup, o Traefik roda em Docker, escuta a porta HTTP local e usa dois providers: Docker e arquivo. O provider Docker descobre serviços por labels. O provider de arquivo cobre os casos que não estão no Docker ou que eu prefiro declarar manualmente.

Também deixo `exposedByDefault=false`. Isso é pequeno, mas importante: subir um container na rede não publica nada sozinho. Para virar rota, o serviço precisa dizer explicitamente que quer aparecer no Traefik.

## A rede `proxy`

A fronteira comum entre os containers é uma rede Docker externa chamada `proxy`.

Serviços que devem passar pelo Traefik entram nessa rede e carregam labels parecidas com estas:

```yaml
labels:
  - traefik.enable=true
  - traefik.http.routers.homepage.rule=Host(`homepage.home.arpa`)
  - traefik.http.routers.homepage.entrypoints=web
  - traefik.http.services.homepage.loadbalancer.server.port=3000
networks:
  - proxy
```

Esse padrão aparece em vários serviços: Homepage, SearXNG, Technitium, Firecrawl, este próprio site. Cada um continua com seu compose, seus volumes e suas variáveis, mas a entrada web segue a mesma lógica.

Isso deixa o ambiente mais fácil de ler. Quando abro um compose e vejo a label do Traefik, já sei qual nome aquele serviço atende. Quando vejo a rede `proxy`, sei que ele participa dessa camada de entrada. Se a porta interna muda, a mudança fica no compose do serviço, não na minha cabeça.

## Serviços que rodam no host

Nem tudo no homelab está em container.

Algumas coisas rodam direto no host via systemd ou outro processo local. É o caso de serviços como T3 Code, code-server e o dashboard do Hermes. Mesmo assim, eu não quero acessar cada um por `ip:porta`.

Para esses casos, uso a configuração dinâmica por arquivo do Traefik. Em vez de descobrir o serviço por label Docker, declaro uma rota apontando para o host:

```yaml
http:
  routers:
    code:
      rule: "Host(`code.home.arpa`)"
      entryPoints:
        - web
      service: code-server-host
  services:
    code-server-host:
      loadBalancer:
        servers:
          - url: "http://host.docker.internal:8081"
```

A ideia é a mesma: o serviço pode estar fora do Docker, mas o jeito de chegar nele continua igual para quem usa.

Isso evita criar dois mundos separados. Não fica uma parte do homelab com nomes bonitos e outra parte escondida atrás de portas soltas. Para mim, esse é um dos ganhos reais do proxy: ele cria uma superfície mais consistente para operar o ambiente.

## O limite do proxy

Tem uma armadilha fácil aqui: transformar o proxy em arquitetura demais.

Traefik é útil quando tira atrito. Alguns serviços ficam melhor fora dele. Banco de dados, fila, cache e serviço interno sem interface web não ganham rota só para ficar bonito. Algumas coisas devem continuar conversando só dentro da rede interna. Outras nem precisam ser acessadas pelo navegador.

Também tento separar bem as decisões. Uma rota local continua sendo só local. Um serviço responder em `home.arpa` não autoriza, por si só, acesso de fora de casa. Quando alguma coisa precisa sair da rede local, entram outras perguntas: tunnel, autenticação, exposição, risco. Isso fica para o texto sobre Cloudflare Tunnel.

O Traefik local resolve um problema mais básico: onde as requisições web entram e como elas chegam no serviço certo.

## O que muda no uso diário

A diferença aparece nas pequenas tarefas.

Se quero abrir o painel, vou para `homepage.home.arpa`. Se quero buscar algo, `search.home.arpa`. Se quero mexer no código pelo navegador, `code.home.arpa` ou `t3.home.arpa`. Se quero abrir o dashboard do Bob, `hermes.home.arpa`.

Eu não fico pensando em porta. Não fico procurando compose para descobrir endereço. Não preciso lembrar se aquele serviço está em container ou no host antes de abrir o navegador.

E quando peço algo para o Bob, o nome ajuda. Pedir para ele conferir o serviço por `search.home.arpa` é melhor do que passar um IP com porta e torcer para ele inferir o resto. Nome bom carrega intenção.

## Uma regra simples para novos serviços

Quando um serviço novo entra no homelab, tento seguir uma regra simples.

Se ele tem interface web e faz sentido ser usado pelo navegador, ele ganha:

1. um nome em `home.arpa`;
2. uma rota no Traefik;
3. uma forma clara de chegar no serviço por trás.

Se ele é container, normalmente isso vira label e rede `proxy`. Se ele roda no host, vira arquivo dinâmico. Se ele é só dependência interna, talvez não ganhe rota nenhuma.

Essa regra funciona justamente porque é simples. Ela reduz decisão repetida.

## O detalhe que sustenta o resto

A parte interessante do homelab costuma estar nos serviços. O Traefik deveria ficar quase invisível.

Mas é uma dessas peças que mudam a sensação do ambiente. Quando cada serviço tem um nome, e todos entram por um caminho previsível, o homelab fica menos parecido com um monte de experimentos empilhados e mais parecido com uma oficina que dá para usar todo dia.

Ainda tem coisa para melhorar. Quero limpar melhor algumas rotas, separar com mais cuidado o que é local e o que pode ser público, e documentar o padrão para serviços novos. Mas a decisão principal parece certa: antes de espalhar portas, criar uma entrada comum.
