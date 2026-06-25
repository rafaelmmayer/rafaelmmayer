---
title: "Homelab: busca e leitura da web"
description: "Como SearXNG e Firecrawl entram no meu homelab como uma camada de busca, leitura e extração para humanos e agentes."
date: 2026-06-17
type: Artigo
order: 4
tags:
  - homelab
  - busca
  - agentes
published: true
---

Depois de arrumar DNS, proxy e tunnel, comecei a olhar para uma camada menos visível do [homelab](/projetos/homelab/): busca e leitura da web.

O uso é bem menor e mais útil: ter um jeito local de procurar, abrir, extrair e transformar páginas em contexto que eu consiga usar melhor. Às vezes esse contexto é para mim. Às vezes é para o Bob.

Essa camada hoje passa principalmente por duas peças: SearXNG e Firecrawl.

## O problema de pesquisar e perder contexto

Pesquisar na web costuma gerar uma sequência meio bagunçada. Abre uma busca, entra em cinco links, fecha dois, deixa três abas abertas, copia um trecho, esquece de onde veio uma informação e tenta transformar aquilo em decisão.

Para uma pesquisa pequena, isso passa. Para comparar ferramentas, ler documentação, juntar referências ou pedir ajuda para um agente, o atrito aparece rápido.

O problema não está só em encontrar links. Está em ler o suficiente, separar o que presta, guardar o contexto e voltar com uma resposta que tenha alguma relação com as fontes.

No homelab, eu gosto de trazer esse tipo de fluxo para perto. Se DNS local tira IP e porta da cabeça, e Traefik organiza a entrada dos serviços, uma camada de busca e leitura ajuda a tirar parte da bagunça da pesquisa.

## SearXNG para descoberta

O SearXNG roda em:

```text
/home/mayer/homelab/search
```

Ele aparece localmente como:

```text
search.home.arpa
```

No compose, o serviço participa da rede `proxy` e recebe uma rota do Traefik por label. Também está configurado para usar o DNS interno como primeiro resolver, com fallback para o roteador da LAN e para `1.1.1.1`.

A parte que mais me interessa nele é simples: ter uma interface de busca local, com resultado em HTML para uso humano e JSON para integração. No `settings.yml`, os formatos habilitados são `html` e `json`. Isso já abre espaço para dois usos diferentes do mesmo serviço.

Quando eu quero pesquisar diretamente, abro `search.home.arpa` no navegador. Quando quero que um agente faça uma primeira passada por resultados, a saída em JSON vira uma superfície melhor do que depender só de uma página visual.

SearXNG aqui não entra como declaração filosófica. Eu ainda uso buscas comerciais quando faz sentido. O valor está em ter uma alternativa local, controlável e fácil de encaixar no resto do ambiente.

## Firecrawl para leitura

Encontrar links resolve metade do caminho. A outra metade é ler as páginas de um jeito útil.

O Firecrawl roda em outra pasta:

```text
/home/mayer/homelab/firecrawl
```

Ele tem uma API local exposta em `127.0.0.1:3002` e também uma rota interna pelo Traefik:

```text
firecrawl.home.arpa
```

Por trás, o stack é maior do que a URL sugere. O compose sobe API, Playwright, Redis, RabbitMQ e Postgres. A API fala com o serviço de Playwright para renderizar páginas quando precisa, usa fila para trabalhos mais pesados e mantém as dependências em uma rede interna separada da `proxy`.

A configuração também conecta Firecrawl ao SearXNG pela variável `SEARXNG_ENDPOINT`. Esse detalhe deixa os dois serviços menos isolados: um ajuda a descobrir, o outro ajuda a extrair.

O uso que me interessa é transformar uma página em Markdown limpo. Uma página da web pode ter menu, banner, modal, script, rodapé, bloco relacionado e um monte de ruído. Para leitura humana isso já incomoda. Para um agente, esse ruído vira contexto ruim.

Quando o Firecrawl consegue devolver o conteúdo principal em um formato mais simples, fica mais fácil pedir resumo, comparação, extração de passos ou leitura crítica.

## O fluxo com o Bob

O desenho prático fica assim:

<div class="flow-map" aria-label="Fluxo entre busca, leitura da web, agente e decisão">
  <span>pergunta</span>
  <span>SearXNG</span>
  <span>links candidatos</span>
  <span>Firecrawl</span>
  <span>resumo ou decisão</span>
</div>

Em vez de pedir uma resposta solta, posso pedir uma sequência mais verificável. Buscar referências. Abrir as páginas mais promissoras. Extrair o conteúdo. Comparar o que elas dizem. Voltar com fontes e limites.

Isso muda o tipo de pedido que faço para o Bob. Perguntas como "qual ferramenta devo usar?" ficam vagas demais. Pedidos melhores ficam mais operacionais:

```text
busque alternativas, leia a documentação principal de cada uma, compare limites e me diga qual encaixa melhor neste setup
```

A diferença está no caminho. A resposta final ainda importa, mas o valor aparece quando dá para reconstruir de onde ela veio.

Isso também combina com a forma como tento operar o homelab. Se um serviço novo depende de documentação, o agente pode ler a documentação, olhar o compose existente, sugerir uma rota no Traefik e depois validar com comando real. Busca e leitura viram parte da operação, não uma etapa separada no navegador.

## Limites que continuam existindo

Essa camada não resolve tudo.

Páginas atrás de login continuam exigindo cuidado. Paywall, bloqueio, CAPTCHA e conteúdo muito dinâmico ainda quebram ou atrapalham. Alguns sites tentam impedir automação. Outros carregam tanta coisa no cliente que a extração fica ruim. E tem um problema mais básico: resultado de busca ruim continua sendo resultado ruim, mesmo quando passa por uma API local.

Também existe o risco de dar aparência de precisão para um processo frágil. Um agente pode resumir uma página errada com muita confiança. Pode comparar versões antigas de documentação. Pode deixar passar um detalhe que um humano perceberia.

Por isso eu tento tratar essa camada como apoio, não como verdade automática. Ela reduz atrito de pesquisa. A decisão ainda precisa de leitura, contexto e verificação.

## Uma peça pequena do ambiente

Gosto dessa parte do homelab porque ela parece discreta. Ela funciona como uma camada de trabalho, mais útil no uso diário do que visível de fora.

Quando funciona, pesquisar fica menos espalhado. O navegador continua existindo, mas deixa de ser o único lugar onde a pesquisa acontece. Um agente consegue participar melhor porque tem uma forma concreta de buscar e ler. Eu consigo pedir trabalhos mais específicos sem colar manualmente cada link.

Ainda quero melhorar esse fluxo. Falta documentar melhor quais endpoints uso, decidir quando vale guardar resultados e separar pesquisa temporária de material que merece virar nota. Também quero deixar mais claro quando o Bob deve usar busca externa, SearXNG, Firecrawl ou uma combinação dos dois.

Mesmo assim, a direção parece boa: se o homelab é o lugar onde rodam minhas ferramentas de trabalho, faz sentido que ele também ajude a ler a web com menos atrito.
