---
title: "Hermes Web Gateway: quando um protótipo vira serviço"
description: "Uma reflexão sobre construir com agente e sobre o que muda quando uma ferramenta pessoal começa a ocupar lugar estável no homelab."
date: 2026-06-25
type: Artigo
order: 4
tags:
  - homelab
  - agentes
  - desenvolvimento
published: true
---

Construir uma ferramenta para conversar com o Bob usando o próprio Bob é uma experiência curiosa.

No [texto anterior](/artigos/hermes-web-gateway/permissao-e-controle/), falei da fronteira de permissão quando um agente pode agir. Este texto olha para o momento em que uma ferramenta deixa de ser protótipo e começa a ocupar lugar estável no homelab.

Existe uma produtividade real. Eu consigo pedir uma mudança, revisar o caminho e seguir depois da validação. O agente reduz o custo de transformar intenção em código. Isso é poderoso.

Também existe um risco real.

Quando a velocidade aumenta, fica mais fácil aceitar acúmulo. Componentes crescem. Decisões provisórias ficam. Correções rápidas puxam outras. O projeto continua andando, mas passa a depender da conversa do momento.

Eu não quero isso.

## Velocidade precisa de forma

O maior ganho de trabalhar com agente é sair da inércia.

Aquela tarefa que eu adiaria por envolver detalhe demais fica mais fácil de começar. O Bob ajuda a abrir caminho. Mas velocidade sem forma vira bagunça mais rápido do que no trabalho manual.

Quando programo sozinho, meu limite natural me obriga a ir mais devagar. Com agente, esse freio some em parte. Então preciso de outros freios: revisão, escopo e bons nomes.

O objetivo é manter o projeto compreensível.

Para mim, código bom é código que uma próxima sessão consegue entender. Isso vale para humano e para agente. Se eu preciso da conversa anterior para explicar por que algo existe, a estrutura não carregou história suficiente.

## O agente ajuda mais quando o projeto é legível

Existe um ciclo interessante aqui.

Projeto legível ajuda o Bob. Essa ajuda acelera o projeto. Quanto mais rápido o projeto cresce, mais importante fica preservar legibilidade.

O agente não elimina arquitetura. Ele torna arquitetura mais importante.

Com estrutura confusa, o Bob consegue mexer mesmo assim, mas a chance de mudança lateral aumenta. Ele pode alterar demais ou partir de suposição errada. Com estrutura clara, o pedido fica menor e a revisão fica mais fácil.

Trabalhar com agente me deixa mais sensível a isso. Um arquivo gigante atrapalha minha leitura e também vira uma superfície ruim para delegar.

## Protótipo útil ainda é experimento

O Hermes Web Gateway já é útil como protótipo. Ele mostra o tipo de interface que eu quero e já conversa com o Hermes real. Mas uma coisa é um app que roda durante o desenvolvimento. Outra é um serviço que mora no homelab e passa a fazer parte do meu dia.

Essa passagem muda a responsabilidade.

Um protótipo pode ser frágil. Um serviço pessoal também pode ser simples, mas precisa ser compreensível, restaurável e seguro o bastante para o papel que ocupa.

No homelab, gosto que cada coisa tenha lugar.

Um serviço precisa de nome, configuração, logs e uma forma clara de subir de novo. Isso parece burocracia até o dia em que algo quebra. Aí o que parecia excesso vira mapa.

## Serviço tem memória material

Configuração também é memória.

Um arquivo com credencial ou URL parece detalhe técnico. Mas ele define como a ferramenta se comporta. Se eu perder, preciso conseguir recriar. Se vazar, preciso entender o impacto. Se mudar, preciso saber o motivo.

Por isso um serviço do homelab precisa entrar na política de backup de forma proporcional.

Nem tudo merece banco ou ritual pesado. Mas tudo que sustenta uso real merece uma resposta simples: onde está, como restaura e qual o impacto se vazar?

Essa disciplina evita que o homelab vire uma coleção de coisas que funcionam só enquanto ninguém encosta.

## Serviço tem fronteira

A parte mais sensível é acesso.

O gateway é uma interface para falar com um agente que pode operar ferramentas. Isso muda a natureza da tela. Mesmo que ela pareça só um chat, por trás existe capacidade de executar comandos e mudar arquivos ou permissões.

Eu não quero tratar isso como painel qualquer.

A fronteira precisa ser pensada antes de virar hábito. Preciso decidir como entro, quem autentica e qual risco aceito para a interface. Cada decisão muda o tipo de confiança que posso ter no serviço.

O caminho conservador combina mais com o que quero: uma ferramenta interna, próxima, útil e protegida.

## O ponto de virada

Para mim, o protótipo vira serviço quando deixa de depender da minha lembrança imediata.

Eu consigo subir de novo. Sei onde está a configuração, como validar e o que ainda é experimental.

Antes disso, ele pode ser útil, mas continua no território do experimento.

Esse texto fica como critério para o próprio projeto. Quando o Hermes Web Gateway entrar de vez no homelab, quero escrever sobre o que de fato foi decidido, não sobre uma versão idealizada.

A direção, por enquanto, é clara: transformar uma interface que nasceu para melhorar minha conversa com o Bob em um serviço interno com o mesmo cuidado que tento aplicar ao resto da casa.
