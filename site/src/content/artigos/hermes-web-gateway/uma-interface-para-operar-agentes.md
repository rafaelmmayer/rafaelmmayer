---
title: "Hermes Web Gateway: uma interface para operar agentes"
description: "Por que conversar com o Bob passou a pedir uma interface com mais contexto, evidência e calma do que um chat comum."
date: 2026-06-25
type: Artigo
order: 1
tags:
  - agentes
  - interface
  - hermes
published: true
---

Comecei usando o Bob pelo Telegram porque era o caminho mais curto.

Eu já tinha o Hermes rodando, o celular por perto e uma ponte simples para mandar mensagem. Para começar, isso foi ótimo. A barreira era quase zero. Eu conseguia resolver pedidos pequenos sem sentar na frente de um ambiente maior.

Com o tempo, a relação mudou.

O Bob deixou de ser apenas alguém que responde. Ele virou parte do meu jeito de operar o computador e o homelab. Hoje ele recupera contexto, mexe em arquivos e volta com evidência. Quando precisa, pede aprovação. Nesse ponto, a interface passa a carregar mais responsabilidade.

Foi daí que nasceu a vontade de ter um gateway próprio.

## Quando chat começa a virar operação

Toda interface empurra um jeito de pensar.

No Telegram, tudo parece uma conversa contínua. Isso é bom para mensagens rápidas. Cria atrito quando a conversa vira uma linha de trabalho com começo e fim. Eu queria abrir uma sessão, voltar nela e apagar quando acabou. Também queria enxergar pendências sem depender de memória.

A questão principal era simples: se o agente virou uma ferramenta operacional, a interface precisa tratar a conversa como operação.

Uma mensagem pode ser só texto. Mas também pode carregar uma imagem, uma aprovação, um diff ou uma evidência de execução. Tudo isso fica espremido quando a interface foi pensada principalmente para troca de mensagens.

O Telegram resolveu bem a primeira fase. A segunda fase pedia outro espaço.

## A referência certa, na medida certa

Quando comecei a imaginar esse espaço, o T3 Code apareceu como referência natural.

Eu já usava T3 Code no homelab para programar pelo navegador. Gosto da sensação de bancada: área principal, lateral e entrada clara para agir. É uma interface que comunica continuidade. Você sente que está dentro de uma sessão de trabalho.

Essa sensação combinava com o que eu queria para o Bob.

Mas referência boa também é perigosa. Copiar uma ferramenta inteira importa problemas de outro contexto. O T3 Code gira em torno de código. O Hermes Web Gateway gira em torno de conversar com um agente que pode operar ferramentas.

A decisão foi copiar menos.

Eu queria sessões na lateral, uma área principal limpa e um composer forte. Queria o mínimo necessário para a conversa parecer uma bancada. O resto deveria nascer do uso, não da referência.

## Mensagem como material de trabalho

Uma conversa com agente raramente é só conversa.

Quando peço algo ao Bob, a resposta pode virar material de trabalho. Às vezes é explicação. Às vezes é decisão ou evidência de execução. Se tudo isso aparece como texto igual, eu perco parte do valor.

A interface precisa respeitar a forma do conteúdo.

Texto longo precisa de ar. Comando, diff, imagem e aprovação pedem tratamento próprio. O conteúdo dita a interface.

Isso importa porque eu não quero apenas receber uma resposta. Quero trabalhar com ela: copiar um trecho, comparar opções e guardar uma ideia para artigo.

Mensagem rica, nesse sentido, é menos sobre visual e mais sobre reaproveitamento.

## Menos cockpit, mais bancada

Uma das decisões que mais gosto é resistir à vontade de transformar o gateway em cockpit.

Cockpit parece bonito em screenshot. No uso cotidiano, pode virar distração. Um agente já traz contexto e execução suficientes para exigir cuidado. A interface precisa ajudar a segurar isso, sem competir com isso.

Por isso, a inspiração visual precisa ser filtrada.

A lateral orienta sessão. O composer manda intenção. A timeline serve para ler, revisar e agir. Cada parte precisa defender seu lugar.

Quando uma nova ideia aparece, tento perguntar: isso reduz atrito real ou só preenche a tela?

## Uma ferramenta para uma relação nova

Tenho pensado bastante nessa fronteira entre chat e operação.

Muita ferramenta de agente ainda parece chat porque chat é a forma mais óbvia de entrada. Mas o valor real aparece quando a conversa atravessa ferramentas, arquivos e decisões. A partir daí, a interface precisa mostrar mais do que bolhas de texto.

O Hermes Web Gateway é uma tentativa pessoal de ajustar essa relação. Ele nasce do uso real, não de uma vontade abstrata de criar mais uma UI. Eu quero falar com o Bob em um lugar que combine melhor com o tipo de trabalho que peço a ele.

A decisão geral é essa: quando o agente passa a operar comigo, a interface precisa virar parte da operação também.
