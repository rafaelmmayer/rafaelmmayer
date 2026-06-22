---
title: "Homelab: Cloudflare Tunnel sem abrir o roteador"
description: "Como penso a exposição pública de alguns serviços do homelab usando Cloudflare Tunnel, sem abrir porta direta para o host."
date: 2026-06-16
type: Artigo
order: 3
tags:
  - homelab
  - cloudflare
  - segurança
published: false
---

Nos dois primeiros textos da série, falei de duas camadas que deixam o homelab mais confortável de usar: [DNS local](/artigos/homelab/dns-local-e-home-arpa/) para dar nome às coisas e [Traefik](/artigos/homelab/traefik-como-porta-de-entrada/) para centralizar a entrada dos serviços web.

Depois disso aparece a pergunta inevitável: o que pode ser acessado de fora de casa?

Essa pergunta parece técnica, mas só começa técnica. Antes de escolher ferramenta, tem uma decisão mais chata e mais importante: quais serviços merecem sair da rede local, com qual domínio, para qual uso, e protegidos por qual camada de autenticação.

No meu caso, o caminho para expor alguma coisa passa pelo [Cloudflare Tunnel](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/).

## A tentação de publicar tudo

Quando o ambiente começa a ficar organizado, dá vontade de transformar todo serviço interno em URL bonita. Se `homepage.home.arpa`, `search.home.arpa`, `code.home.arpa` e `hermes.home.arpa` funcionam bem na rede local, parece natural querer abrir os mesmos painéis estando fora de casa.

Só que conveniência demais vira risco rápido.

Alguns serviços são feitos para aparecer publicamente. Um site estático, por exemplo, faz sentido estar na internet. Outros carregam coisa sensível: terminal, arquivos, dashboards, tokens, tarefas, configurações, logs, sessões. Esses serviços até podem ser acessados remotamente em alguns cenários, mas exigem mais critério.

Eu tento separar três categorias:

1. coisas públicas, como este site;
2. coisas privadas que posso querer acessar por fora, normalmente com VPN ou autenticação forte;
3. coisas que devem continuar internas.

Essa divisão evita uma armadilha comum em homelab: publicar primeiro e pensar na fronteira depois.

## Por que Cloudflare Tunnel

O jeito clássico de publicar algo em casa seria abrir uma porta no roteador, apontar DNS para o IP público e encaminhar o tráfego para o servidor.

Prefiro evitar esse caminho.

Com Cloudflare Tunnel, o servidor de casa abre uma conexão de saída para a Cloudflare. A internet chega até a Cloudflare, e a Cloudflare entrega o tráfego pelo túnel já estabelecido. Eu não preciso abrir uma porta pública direto para o host.

O desenho fica assim:

<div class="flow-map" aria-label="Fluxo entre internet, Cloudflare Tunnel, Traefik e serviço">
  <span>internet</span>
  <span>Cloudflare</span>
  <span>cloudflared</span>
  <span>Traefik</span>
  <span>serviço publicado</span>
</div>

Isso resolve uma parte importante da exposição. O roteador não precisa encaminhar porta para o servidor. O conector fica rodando de dentro para fora. Se eu quiser remover a exposição, posso cortar a rota no Cloudflare ou parar o container.

Ainda assim, o tunnel não elimina a responsabilidade sobre o que está atrás dele. Ele muda o caminho de entrada. A decisão de publicar continua minha.

## Como ele roda aqui

Aqui o `cloudflared` roda como mais um serviço em [Docker Compose](https://docs.docker.com/compose/), em uma pasta própria do homelab:

```text
/home/mayer/homelab/cloudflare-tunnel
```

O compose é pequeno:

```yaml
services:
  cloudflared:
    image: cloudflare/cloudflared:${CLOUDFLARED_TAG:-latest}
    container_name: cloudflared
    restart: unless-stopped
    command:
      - tunnel
      - --no-autoupdate
      - run
      - --token
      - ${CLOUDFLARED_TOKEN}
    networks:
      - proxy

networks:
  proxy:
    external: true
```

O token fica no `.env`, fora do Git. O container entra na mesma rede Docker externa que o Traefik usa, a `proxy`.

Essa parte é proposital. O tunnel não precisa conhecer cada serviço do homelab. Ele só precisa conseguir chegar no Traefik quando uma rota pública deve entrar pelo mesmo caminho das rotas locais.

Nos logs, o conector registra conexões usando QUIC e recebe a configuração remota de ingress. Hoje a parte pública aponta `mayerafa.com` e `www.mayerafa.com` para `http://traefik:80`, com fallback 404 para o resto. É um bom padrão: publicar explicitamente alguns hostnames e recusar o que sobra.

## O caminho até o Traefik

A escolha de mandar o tunnel para o Traefik deixa a arquitetura mais previsível.

O site `mayerafa.com`, por exemplo, roda como container separado e participa da rede `proxy`. No compose dele, a rota pública fica declarada por label:

```yaml
labels:
  - traefik.enable=true
  - traefik.http.routers.rafaelmmayer.rule=Host(`mayerafa.com`) || Host(`www.mayerafa.com`)
  - traefik.http.routers.rafaelmmayer.entrypoints=web
  - traefik.http.services.rafaelmmayer.loadbalancer.server.port=80
```

A Cloudflare entrega a requisição pelo tunnel. O `cloudflared` passa para `http://traefik:80`. O Traefik olha o hostname público e encaminha para o container certo.

Isso preserva o mesmo modelo mental do ambiente local: nome, entrada comum, serviço por trás. A diferença é que o nome público vem da internet e passa pela Cloudflare antes de chegar na rede Docker.

Para mim, esse padrão é mais fácil de operar do que criar exceção por serviço. Se amanhã outro serviço precisar sair, a pergunta fica mais concreta: ele deve ter um hostname público? A rota no Traefik está clara? A autenticação é suficiente? O serviço deveria estar atrás de [Cloudflare Access](https://developers.cloudflare.com/cloudflare-one/applications/)?

Se a resposta não estiver boa, ele continua local.

## O que eu não quero publicar

A parte mais importante dessa camada talvez seja o que fica de fora.

Painel de administração, ambiente de código, dashboard do Bob, banco, fila, cache, serviço interno e qualquer coisa com poder de mexer no host precisam de mais cuidado. Alguns podem ser úteis remotamente, mas isso não significa que devam virar URL pública simples.

Para uso pessoal fora de casa, VPN continua sendo uma fronteira melhor em vários casos. Ela combina mais com serviço interno: eu entro na rede e uso como se estivesse perto. Para algo que outras pessoas precisam acessar, ou para um site que deve estar publicamente disponível, o tunnel faz mais sentido.

Essa separação deixa o homelab menos confuso. `home.arpa` continua sendo o território local. Domínio público é outra decisão.

## Autenticação antes de conforto

Cloudflare Tunnel reduz uma parte da superfície, mas não substitui autenticação.

Para site estático público, tudo bem: a intenção é aparecer. Para dashboards, terminais e ferramentas de operação, eu quero pelo menos uma camada forte antes do serviço. Pode ser Cloudflare Access, autenticação própria do app, ou as duas coisas dependendo do caso.

Também tento evitar uma falsa sensação de segurança por estar "atrás da Cloudflare". Se um hostname público aponta para um painel sem proteção suficiente, o problema continua existindo. O caminho ficou mais organizado, mas o serviço ainda está publicado.

## O resultado prático

Hoje o tunnel tem uma função bem definida: publicar o que eu escolho publicar sem abrir porta direta no roteador e sem criar um caminho paralelo ao Traefik.

Isso combina com o resto do homelab. DNS local cuida dos nomes internos. Traefik organiza a entrada web. Cloudflare Tunnel cria uma ponte controlada para os poucos casos em que algo precisa aparecer fora da casa.

O valor está em acessar de fora sem perder a pergunta explícita toda vez que um serviço quer sair: por que isso precisa ser público, quem deve acessar, e qual proteção existe na frente?

Se essa pergunta fica clara, a ferramenta ajuda. Se ela some, o tunnel vira só mais um jeito elegante de publicar coisa demais.
