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

Isso parece óbvio quando falamos em comandos destrutivos, mas a fronteira real é mais sutil. Editar arquivo, rodar script, reiniciar serviço, publicar uma rota, apagar sessão, mudar configuração, enviar algo para fora. Cada uma dessas ações pode ser pequena dentro do fluxo e grande fora dele.

Se a interface trata tudo como mensagem comum, a consequência fica escondida.

Por isso aprovações e YOLO são parte central para mim. Eles dizem que tipo de relação eu quero ter com o Bob.

## Permissão precisa aparecer

Quando o agente pede aprovação, a interface deve mudar de tom.

Não precisa virar teatro. Precisa deixar claro que a conversa chegou em um ponto de decisão. O que será feito? Qual é o risco? O pedido vale só agora, vale para a sessão ou quer virar permissão permanente? Existe uma opção normal de negar?

Eu quero que essa decisão apareça como decisão.

O pior desenho seria aquele em que aprovar parece apenas continuar o fluxo. Um botão bonito demais, pequeno demais ou automático demais cria o hábito errado. A aprovação vira reflexo. Para um agente que mexe em ambiente real, reflexo é perigoso.

## Escopo muda tudo

Permitir uma vez, permitir durante a sessão e permitir sempre são escolhas muito diferentes.

Permitir uma vez combina com cautela. Eu olho aquele comando, aquele arquivo, aquela ação, e autorizo aquele passo.

Permitir durante a sessão faz sentido quando o escopo está claro. Estou trabalhando em um artigo, rodando build, ajustando arquivos conhecidos. Quero reduzir interrupção, mas dentro daquele contexto.

Permitir sempre é uma decisão mais pesada. Ela troca cuidado por velocidade de forma duradoura. Pode ser correta em alguns casos, mas deve exigir mais intenção.

A interface precisa mostrar essa diferença. Se tudo parece o mesmo botão, o usuário perde a noção do que está entregando.

## YOLO como escolha consciente

YOLO é útil justamente porque tira atrito.

Às vezes estou acompanhando uma tarefa clara e quero que o Bob siga sem parar a cada passo seguro. O problema aparece quando esse conforto escapa do contexto. Um modo permissivo é bom quando eu sei onde estou pisando. Fica ruim quando esqueço que ele está ligado.

Por isso eu gosto da separação entre sessão e global.

YOLO de sessão pertence ao trabalho atual. Ele precisa estar visível enquanto escrevo o próximo prompt. YOLO global tem outro peso. Ele afeta muito mais coisa e deve morar em um lugar que obrigue uma pausa antes de ativar.

Essa fricção é saudável. Nem todo atrito é problema. Alguns atritos existem para impedir que a gente faça uma besteira com facilidade demais.

## Evidência também é controle

Permissão é uma parte do controle. Evidência é outra.

Se o Bob diz que alterou algo, quero ver o que mudou. Se rodou um comando, quero saber o resultado. Se sugere uma decisão, quero ver a razão. Se pede aprovação, quero enxergar a ação. Essas coisas não deveriam ficar enterradas em texto corrido.

Diff, tabela, bloco de comando e resposta de build são formas diferentes de evidência. Cada uma pede apresentação própria.

O ponto é revisão.

Eu uso o Bob para pensar junto, mas também para fazer coisas. Quando uma resposta vira ação, preciso conseguir conferir. A interface precisa favorecer esse gesto: ler, conferir, copiar, aprovar, negar, comparar, voltar.

## O humano continua na decisão

Eu gosto de automação local justamente porque ela pode ficar perto do meu julgamento.

Não quero transformar o Bob em operador autônomo sem critério. Quero que ele investigue, proponha, execute passos seguros, peça licença quando precisa e volte com evidência. A decisão importante deve ficar visível.

Esse é o ponto das aprovações no Hermes Web Gateway. Elas não existem para enfeitar um protocolo. Elas existem para manter a relação correta entre pessoa, agente e ambiente.

A interface para agentes precisa ter opinião sobre isso. A minha é simples: quanto mais poder o agente tem, mais clara deve ser a fronteira de permissão.
