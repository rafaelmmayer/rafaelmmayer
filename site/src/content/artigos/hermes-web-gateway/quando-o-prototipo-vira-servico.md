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

Existe uma produtividade real. Eu consigo pedir uma alteração, revisar um caminho, corrigir um erro, rodar validação e seguir. O agente reduz o custo de transformar intenção em código. Isso é poderoso.

Também existe um risco real.

Quando a velocidade aumenta, fica mais fácil aceitar acúmulo. Um componente cresce demais. Uma decisão provisória fica. Um detalhe visual vira regra. Uma correção rápida puxa outra. O projeto continua andando, mas começa a depender de contexto que só existe na conversa do momento.

Eu não quero isso.

## Velocidade precisa de forma

O maior ganho de trabalhar com agente é sair da inércia.

Aquela tarefa que eu adiaria porque envolve arquivos, boilerplate, ajuste fino e teste fica mais fácil de começar. O Bob ajuda a abrir caminho. Mas velocidade sem forma vira bagunça mais rápido do que no trabalho manual.

Quando estou programando sozinho, meu limite natural me obriga a ir mais devagar. Com agente, esse freio some em parte. Então preciso colocar outros freios: revisão, validação, escopo, nome bom, separação de responsabilidade e coragem para refatorar cedo.

O objetivo é manter o projeto compreensível.

Para mim, código bom é código que uma próxima sessão consegue entender. Isso vale para humano e para agente. Se eu preciso de toda a conversa anterior para explicar por que algo existe, alguma coisa ficou mal documentada no próprio projeto. O código, os nomes e a estrutura precisam carregar parte da história.

## O agente ajuda mais quando o projeto é legível

Existe um ciclo interessante aqui.

Quanto mais legível o projeto, melhor o Bob consegue ajudar. Quanto melhor ele ajuda, mais rápido o projeto cresce. Quanto mais rápido cresce, mais necessário fica preservar legibilidade.

O agente não elimina arquitetura. Ele torna arquitetura mais importante.

Se a estrutura está confusa, o Bob consegue mexer mesmo assim, mas a chance de mudança lateral aumenta. Ele altera mais do que precisa, carrega suposição errada, conserta sintoma. Quando a estrutura está clara, o pedido pode ser menor e a revisão fica mais fácil.

Trabalhar com agente me deixa mais sensível a isso. Um arquivo gigante atrapalha minha leitura e também vira uma superfície ruim para delegar.

## Protótipo útil ainda é experimento

O Hermes Web Gateway já é útil como protótipo. Ele abre, conversa, simula estados, conecta no Hermes real e mostra o tipo de interface que eu quero. Mas uma coisa é um app que roda durante o desenvolvimento. Outra é um serviço que mora no homelab e passa a fazer parte do meu dia.

Essa passagem muda a responsabilidade.

Um protótipo pode ser frágil. Um serviço pessoal também pode ser simples, mas precisa ser compreensível, restaurável e seguro o bastante para o papel que ocupa.

No homelab, gosto que cada coisa tenha lugar.

Um serviço precisa de nome, rota, pasta, configuração, logs e uma forma clara de subir de novo. Isso parece burocracia até o dia em que algo quebra. Aí o que parecia excesso vira mapa.

## Serviço tem memória material

Configuração também é memória.

Um arquivo com URL, modo de conexão, credencial ou preferência parece detalhe técnico. Mas ele define como a ferramenta se comporta. Se eu perder, preciso conseguir recriar. Se vazar, preciso entender o impacto. Se mudar, preciso saber por quê.

Por isso um serviço do homelab precisa entrar na política de backup de forma proporcional.

Nem tudo merece banco, replicação ou ritual pesado. Mas tudo que sustenta uso real merece uma resposta simples para três perguntas: onde está, como restaura, o que acontece se vazar?

Essa disciplina evita que o homelab vire uma coleção de coisas que funcionam só enquanto ninguém encosta.

## Serviço tem fronteira

A parte mais sensível é acesso.

O gateway é uma interface para falar com um agente que pode operar ferramentas. Isso muda a natureza da tela. Mesmo que ela pareça só um chat, por trás existe capacidade de executar comandos, alterar arquivos, responder aprovações e mudar modos de permissão.

Eu não quero tratar isso como painel qualquer.

A fronteira precisa ser pensada antes de virar hábito. Acesso local, VPN, autenticação da própria interface, relação com o dashboard do Hermes, risco de YOLO global, exposição pública. Cada decisão muda o tipo de confiança que posso ter no serviço.

O caminho conservador combina mais com o que quero: uma ferramenta interna, próxima, útil e protegida.

## O ponto de virada

Para mim, o protótipo vira serviço quando deixa de depender da minha lembrança imediata.

Eu consigo subir de novo. Sei onde está a configuração. Sei qual nome abrir. Sei como validar. Sei o que está protegido. Sei o que entra no backup. Sei qual parte ainda é experimental.

Antes disso, ele pode ser útil, mas continua no território do experimento.

Esse texto fica como critério para o próprio projeto. Quando o Hermes Web Gateway entrar de vez no homelab, quero escrever sobre o que de fato foi decidido, não sobre uma versão idealizada.

A direção, por enquanto, é clara: transformar uma interface que nasceu para melhorar minha conversa com o Bob em um serviço interno com o mesmo cuidado que tento aplicar ao resto da casa.
