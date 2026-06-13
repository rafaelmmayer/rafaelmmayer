---
title: "Homelab: DNS local e home.arpa"
description: "Como uso DNS local no homelab para parar de decorar IP, porta e caminho de serviço."
date: 2026-06-13
type: Artigo
order: 1
tags:
  - homelab
  - dns
  - infraestrutura
published: true
---

Tem uma parte do [meu homelab](/projetos/homelab/) que parece pequena até você tirar. Depois que acostuma, voltar para IP e porta parece trabalhar com etiqueta provisória em tudo.

No começo eu ainda abria serviço com endereço assim:

```text
http://192.168.x.y:8080
http://192.168.x.y:3000
http://192.168.x.y:9443
```

Funciona. Só que funciona do jeito chato. Você precisa lembrar qual porta é de qual serviço, onde salvou aquele link, se mudou alguma coisa no compose, se aquele painel está no host ou em container. Não é difícil. É só uma pequena interrupção repetida muitas vezes.

DNS local entrou no meu homelab para resolver isso.

## O que eu queria resolver

Eu queria que os serviços tivessem nomes.

Não nomes públicos, nem domínios bonitos para mostrar para alguém. Nomes locais mesmo. Coisas que fazem sentido dentro da minha rede:

```text
homepage.home.arpa
search.home.arpa
t3.home.arpa
hermes.home.arpa
```

Isso muda o jeito de usar o ambiente. Em vez de pensar em IP e porta, eu penso no serviço. Se quero abrir o painel, vou para `homepage.home.arpa`. Se quero buscar alguma coisa, `search.home.arpa`. Se quero mexer no Hermes, `hermes.home.arpa`.

Parece pouco, mas o ganho real é tirar coisa da cabeça. Homelab já tem detalhe demais. Serviço sobe em Docker, serviço roda no host, serviço tem volume, token, rede, porta, proxy, arquivo de configuração. Se eu ainda preciso lembrar endereço manualmente, alguma coisa ficou para trás.

## Por que home.arpa

Eu poderia ter inventado qualquer domínio local. Muita gente usa `.local`, `.lan`, `.home` ou algum domínio próprio apontado para IP interno.

Preferi `home.arpa` porque ele existe justamente para esse tipo de rede doméstica. O [RFC 8375](https://www.rfc-editor.org/rfc/rfc8375.html) reserva `home.arpa` para uso em redes residenciais. Isso evita algumas gambiarrazinhas que parecem inocentes no começo e depois viram ruído: conflito com mDNS, domínio inventado que pode existir no futuro, certificado estranho, resolver externo recebendo consulta que não deveria.

Não quer dizer que todo homelab precisa usar `home.arpa`. Quer dizer só que, se a ideia é ter nomes locais, vale usar o nome que já foi reservado para isso.

No meu caso ficou simples:

```text
serviço.home.arpa
```

O nome diz duas coisas ao mesmo tempo. Primeiro: isso é interno. Segundo: se eu estou fora da rede, talvez esse endereço nem devesse funcionar. Spoiler: eu consigo acessar parte disso por fora usando VPN, mas isso fica para outro artigo.

## Onde entra o Technitium

O DNS local hoje fica no [Technitium DNS](https://technitium.com/dns/). Ele mantém a zona `home.arpa` e responde os nomes da rede interna. Também uso o DNS como bloqueador de anúncios na rede, filtrando parte do lixo antes dele chegar nos dispositivos.

Poderia ser outro servidor DNS. O ponto importante não é a ferramenta. O ponto é ter uma zona local que eu controlo.

Quando crio um serviço novo, a sequência mental fica mais ou menos assim:

1. escolho um nome local;
2. aponto esse nome no DNS;
3. crio ou ajusto a rota no Traefik;
4. acesso pelo navegador usando o nome.

O DNS não precisa saber todos os detalhes do serviço. Ele só precisa levar o nome até a entrada certa. A partir dali, o Traefik resolve para onde mandar a requisição.

## Como isso conversa com o Traefik

O desenho que mais aparece por aqui é este:

<div class="flow-map" aria-label="Fluxo entre navegador, DNS local, Traefik e serviço">
  <span>navegador</span>
  <span>DNS local</span>
  <span>Traefik</span>
  <span>serviço</span>
</div>

O DNS responde que `homepage.home.arpa` aponta para o lugar onde o Traefik está ouvindo. O Traefik olha o hostname e encaminha para o container ou para o serviço no host.

Essa separação deixa o setup mais fácil de mexer. Se eu troco a porta interna de um serviço, o endereço no navegador continua igual. Se eu movo um serviço de container para systemd, ou o contrário, consigo preservar o nome. Se eu recrio um compose, não preciso ensinar meu cérebro de novo onde aquilo mora.

Também ajuda o Bob. Quando eu peço para ele mexer em alguma coisa, o nome local carrega contexto. `search.home.arpa` é melhor do que `172.20.0.1:alguma-porta`. Um nome bom reduz explicação.

## Local não é público

Uma coisa que tento manter clara: resolver um nome na LAN não é o mesmo que publicar um serviço na internet.

`home.arpa` é para dentro. Se algo precisa ser acessado de fora, eu trato como outra decisão. Aí entra Cloudflare Tunnel, autenticação, regra de exposição e um pouco mais de paranoia.

Essa separação é saudável. Tem serviço que eu quero abrir no celular estando fora de casa. Tem painel que eu prefiro que nunca saia da rede local. O fato de ambos terem nomes bonitos não torna os dois igualmente publicáveis.

O DNS local me ajuda justamente porque deixa essa fronteira mais explícita. Se termina em `home.arpa`, eu sei que estou falando da casa, não da internet.

## O detalhe que vira infraestrutura

DNS é uma dessas coisas que só aparece quando falha. Quando está funcionando, ele some. E talvez seja por isso que vale arrumar cedo.

No homelab, esse tipo de detalhe define a sensação de uso. Um serviço pode estar tecnicamente funcionando, mas ainda parecer improvisado se você precisa lembrar IP, porta e exceção toda vez que abre. Com nomes locais, o ambiente fica mais operável.

Ainda tem coisas para melhorar. Quero documentar melhor quais nomes existem, separar com mais cuidado o que é só LAN e o que pode passar por tunnel, e talvez automatizar parte do cadastro quando um serviço novo entra no Traefik.

Mas a decisão base já parece certa: primeiro dar nome às coisas. Depois o resto fica mais fácil de organizar.
