---
title: "Hermes Web Gateway: permissão e controle"
description: "Uma opinião sobre por que interfaces para agentes precisam tratar permissão, YOLO e evidência como parte central da experiência."
date: 2026-06-25
type: Artigo
order: 3
tags:
  - agentes
  - seguranca
  - interface
published: true
---

Um agente operacional precisa pedir licença em alguns momentos.

Depois de [falar sobre simular antes de conectar](/artigos/hermes-web-gateway/simular-antes-de-conectar/), vale entrar na fronteira que aparece quando o agente pode agir: permissão e controle.

Isso parece óbvio quando falamos em comandos destrutivos, mas a fronteira real é mais sutil. Editar arquivo ou reiniciar serviço pode parecer pequeno dentro do fluxo. Fora dele, cada ação pesa mais.

Se a interface trata tudo como mensagem comum, a consequência fica escondida.

Por isso aprovações e YOLO são parte central para mim. Eles dizem que tipo de relação eu quero ter com o Bob.

## Permissão precisa aparecer

Quando o agente pede aprovação, a interface deve mudar de tom.

O desenho precisa deixar claro que a conversa chegou em um ponto de decisão. A interface deve mostrar o risco, o escopo do pedido e uma opção normal de negar.

Eu quero que essa decisão apareça como decisão.

O pior desenho seria aquele em que aprovar parece apenas continuar o fluxo. Um botão bonito demais, pequeno demais ou automático demais cria o hábito errado. A aprovação vira reflexo. Para um agente que mexe em ambiente real, reflexo é perigoso.

## Escopo muda tudo

Permitir uma vez, permitir durante a sessão e permitir sempre são escolhas muito diferentes.

Permitir uma vez combina com cautela. Eu olho o comando e autorizo aquele passo.

Permitir durante a sessão faz sentido quando o escopo está claro. Estou trabalhando em um artigo ou ajustando arquivos conhecidos. Quero reduzir interrupção, mas dentro daquele contexto.

Permitir sempre é uma decisão mais pesada. Ela troca cuidado por velocidade de forma duradoura. Pode ser correta em alguns casos, mas deve exigir mais intenção.

A interface precisa mostrar essa diferença. Se tudo parece o mesmo botão, o usuário perde a noção do que está entregando.

## YOLO como escolha consciente

YOLO é útil justamente porque tira atrito.

Às vezes estou em uma tarefa clara e quero que o Bob siga sem parar a cada passo seguro. O problema aparece quando esse conforto escapa do contexto. Modo permissivo é bom quando sei onde estou pisando. Fica ruim quando esqueço que ele está ligado.

Por isso eu gosto da separação entre sessão e global.

YOLO de sessão pertence ao trabalho atual. Ele precisa estar visível enquanto escrevo o próximo prompt. YOLO global tem outro peso. Ele afeta muito mais coisa e deve morar em um lugar que obrigue uma pausa antes de ativar.

Essa fricção é saudável. Nem todo atrito é problema. Alguns atritos existem para impedir que a gente faça uma besteira com facilidade demais.

## Evidência também é controle

Permissão é uma parte do controle. Evidência é outra.

Se o Bob alterou algo, quero ver o que mudou. Se rodou um comando, quero saber o resultado. Se pediu aprovação, quero enxergar a ação. Esse material precisa aparecer melhor do que em texto corrido.

Um diff pede tratamento diferente de uma resposta de build. Cada evidência precisa aparecer de um jeito que favoreça revisão.

O ponto é revisão.

Eu uso o Bob para pensar junto, mas também para fazer coisas. Quando uma resposta vira ação, preciso conseguir conferir. A interface precisa favorecer esse gesto de revisão.

## O humano continua na decisão

Eu gosto de automação local justamente porque ela pode ficar perto do meu julgamento.

Não quero transformar o Bob em operador autônomo sem critério. Quero que ele investigue, proponha e execute passos seguros. Quando precisa, ele deve pedir licença e voltar com evidência. A decisão importante deve ficar visível.

Esse é o ponto das aprovações no Hermes Web Gateway. Elas não existem para enfeitar um protocolo. Elas existem para manter a relação correta entre pessoa, agente e ambiente.

A interface para agentes precisa ter opinião sobre isso. A minha é simples: quanto mais poder o agente tem, mais clara deve ser a fronteira de permissão.
