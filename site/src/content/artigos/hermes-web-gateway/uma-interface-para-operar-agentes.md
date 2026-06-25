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

Eu já tinha o Hermes rodando, o celular por perto e uma ponte simples para mandar mensagem. Para começar, isso foi ótimo. A barreira era quase zero. Eu podia pedir um resumo, lembrar um caminho, abrir uma investigação pequena ou transformar uma ideia em rascunho sem sentar na frente de um ambiente maior.

Com o tempo, a relação mudou.

O Bob deixou de ser apenas alguém que responde. Ele virou parte do meu jeito de operar o computador e o homelab. Ele lê arquivos, roda comandos, procura sessões antigas, lembra preferências, pede aprovação, edita texto, testa build e volta com evidência. Quando uma conversa chega nesse ponto, a interface passa a carregar mais responsabilidade.

Foi daí que nasceu a vontade de ter um gateway próprio.

## Quando chat começa a virar operação

Toda interface empurra um jeito de pensar.

No Telegram, tudo parece uma conversa contínua. Isso é bom para mensagens rápidas. Também cria atrito quando cada conversa começa a representar uma linha de trabalho: um artigo, uma investigação, um deploy, uma leitura, uma decisão. Eu queria enxergar melhor essas linhas. Queria abrir uma sessão, voltar nela, apagar quando acabou, ver com clareza o que estava pendente e entender o estado do agente sem depender de memória.

A questão principal era simples: se o agente virou uma ferramenta operacional, a interface precisa tratar a conversa como operação.

Uma mensagem pode ser só texto. Mas também pode carregar uma imagem, um pedido de aprovação, um diff, uma tabela, uma decisão de segurança ou uma evidência de execução. Tudo isso fica espremido quando a interface foi pensada principalmente para troca de mensagens.

O Telegram resolveu bem a primeira fase. A segunda fase pedia outro espaço.

## A referência certa, na medida certa

Quando comecei a imaginar esse espaço, o T3 Code apareceu como referência natural.

Eu já usava T3 Code no homelab para programar pelo navegador. Gosto da sensação de bancada: uma área principal de trabalho, uma lateral para navegar e uma entrada clara para agir. É uma interface que comunica continuidade. Você sente que está dentro de uma sessão de trabalho.

Essa sensação combinava com o que eu queria para o Bob.

Mas referência boa também é perigosa. Se eu copio uma ferramenta inteira, acabo importando problemas de outro contexto. O T3 Code resolve um tipo de trabalho. O Hermes Web Gateway resolve outro. O primeiro gira em torno de código. O segundo gira em torno de conversar com um agente que pode operar ferramentas.

A decisão foi copiar menos.

Eu queria uma lateral para sessões, uma área principal limpa, um composer forte e espaço para mensagens com mais estrutura. Queria o mínimo necessário para a conversa parecer uma bancada. O resto deveria nascer do uso, não da referência.

## Mensagem como material de trabalho

Uma conversa com agente raramente é só conversa.

Quando peço algo ao Bob, a resposta pode virar material de trabalho: uma explicação, uma tabela de decisão, um trecho de código, um plano, um diff, uma imagem comentada, uma aprovação pendente ou uma evidência de que algo rodou. Se tudo isso aparece como texto igual, eu perco parte do valor.

A interface precisa respeitar a forma do conteúdo.

Texto longo precisa de ar. Tabelas precisam ser legíveis. Comandos precisam ser copiáveis. Diffs precisam ser revisáveis. Imagens precisam aparecer como imagens. Aprovações precisam ter peso. O conteúdo dita a interface.

Isso importa porque eu não quero apenas receber uma resposta. Quero trabalhar com ela. Copiar um trecho, voltar em uma tabela, comparar opções, conferir um comando, guardar uma ideia para artigo.

Mensagem rica, nesse sentido, é menos sobre visual e mais sobre reaproveitamento.

## Menos cockpit, mais bancada

Uma das decisões que mais gosto é resistir à vontade de transformar o gateway em cockpit.

Cockpit parece bonito em screenshot. No uso cotidiano, pode virar distração. Um agente já traz bastante complexidade própria: modelo, ferramenta, memória, contexto, execução, autorização, arquivo, erro. A interface precisa ajudar a segurar isso, sem competir com isso.

Por isso, a inspiração visual precisa ser filtrada.

A lateral existe para orientar sessão, não para virar painel de métricas. O composer existe para mandar intenção, não para concentrar trinta controles. A timeline existe para ler, revisar e agir. Cada parte precisa defender seu lugar.

Quando uma nova ideia aparece, tento perguntar: isso reduz atrito real ou só preenche a tela?

## Uma ferramenta para uma relação nova

Tenho pensado bastante nessa fronteira entre chat e operação.

Muita ferramenta de agente ainda parece chat porque chat é a forma mais óbvia de entrada. Mas o valor real aparece quando a conversa atravessa ferramentas, arquivos, memória e decisões. A partir daí, a interface precisa mostrar mais do que bolhas de texto.

O Hermes Web Gateway é uma tentativa pessoal de ajustar essa relação. Ele nasce do uso real, não de uma vontade abstrata de criar mais uma UI. Eu quero falar com o Bob em um lugar que combine melhor com o tipo de trabalho que peço a ele.

A decisão geral é essa: quando o agente passa a operar comigo, a interface precisa virar parte da operação também.
