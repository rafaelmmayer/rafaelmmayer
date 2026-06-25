---
title: "Hermes Web Gateway: simular antes de conectar"
description: "Por que começar pelo mock foi uma decisão sobre clareza, segurança e liberdade antes de ligar no Hermes real."
date: 2026-06-25
type: Artigo
order: 2
tags:
  - agentes
  - arquitetura
  - interface
published: true
---

Começar pelo mock foi uma decisão mais importante do que parecia.

O objetivo do Hermes Web Gateway é falar com o Hermes real. Mesmo assim, ligar direto no agente desde o primeiro dia teria deixado tudo mais confuso. Cada ajuste de interface dependeria de uma sessão real, de autenticação, de estado, de resposta do modelo, de tokens e de uma sequência difícil de repetir.

Eu queria separar duas perguntas.

A primeira: que tipo de interface faz sentido para conversar com o Bob?

A segunda: como essa interface se conecta ao Hermes real?

Se as duas perguntas aparecem juntas cedo demais, uma atrapalha a outra.

## Simular para pensar melhor

Mock costuma soar como etapa provisória, quase descartável. Neste caso, ele virou ferramenta de pensamento.

Ao simular sessões, mensagens, aprovações, diffs e imagens, eu consigo olhar para a interface sem depender do comportamento imprevisível de uma conversa real. Posso perguntar: uma aprovação fica clara desse jeito? Uma resposta longa é confortável de ler? Uma imagem anexada aparece onde deveria? Uma sessão vazia parece quebrada ou pronta?

Essas perguntas são de design, não de integração.

Quando o agente real está no meio, tudo fica mais barulhento. Se algo parece ruim, pode ser a UI, o backend, o modelo, a rede, a autenticação ou o prompt. Com mock, o problema fica mais isolado.

Isso dá liberdade.

## O agente real merece respeito

Também tem uma questão de cuidado.

O Bob está longe de ser uma API de demonstração. Ele tem memória, ferramentas, acesso a arquivos, terminal e histórico real. Usar o agente verdadeiro como massa de teste para cada estado visual parece errado. Eu não quero criar sessão real só para ver se um botão ficou alinhado. Não quero pedir uma aprovação sensível só para testar um card. Não quero gastar execução real para validar uma tabela.

Simular antes é uma forma de respeitar o ambiente.

O Hermes real entra quando a interface já sabe o que quer. Aí o teste passa a ser outro: a ponte está correta? O estado é mapeado com fidelidade? A autorização chega no lugar certo? O histórico real aparece sem bagunça?

Essas são perguntas de integração. Elas merecem outro momento.

## Conectar muda o peso

Enquanto tudo está no mock, a interface é um laboratório. Quando ela fala com o Bob de verdade, passa a encostar no meu ambiente real: sessões, histórico, ferramentas, permissões e ações que podem alterar arquivos ou serviços.

Essa virada exige cuidado.

A tentação em projeto pessoal é fazer o caminho mais curto. Está na minha rede, eu confio na máquina, eu só quero usar logo. Mas esse tipo de atalho costuma envelhecer mal. Uma interface para agente operacional precisa nascer com alguma noção de fronteira, mesmo antes de virar serviço definitivo.

O Hermes real tem memória de trabalho. Existem sessões antigas, títulos, mensagens, decisões, aprovações e contexto. Isso é justamente o que torna o agente útil. Também é o que torna a interface mais sensível.

A partir desse momento, apagar uma sessão deixa de ser gesto visual. Responder uma aprovação deixa de ser teste. Ativar um modo mais permissivo deixa de ser estado de UI. Tudo passa a ter consequência fora da tela.

Essa é a diferença que eu quero que o gateway deixe clara.

## Segurança como parte do desenho

Eu não queria resolver integração desligando proteção.

Em ambiente local, é fácil racionalizar: está atrás da VPN, está no homelab, sou só eu usando. Mas uma interface que conversa com um agente capaz de agir merece uma camada de respeito maior. Autenticação, autorização e escopo viram parte do cuidado quando a ferramenta tem poder de operação.

A decisão de colocar um gateway entre navegador e Hermes vem daí.

Ele funciona como uma fronteira mais controlada. A UI não precisa carregar todos os detalhes sensíveis. O backend pode cuidar da conversa com o dashboard do Hermes, preservar o caminho de autenticação e expor para o navegador uma superfície mais estreita.

O objetivo é evitar que conveniência vire hábito ruim.

## Primeiro entender, depois ligar

Essa decisão diz bastante sobre como eu gosto de construir.

Prefiro entender o formato do problema antes de conectar tudo. Quando uma ferramenta depende de um agente poderoso, a pressa de integrar pode criar uma ilusão de progresso. A tela começa a responder, mas a experiência ainda não está pensada.

O mock me deu espaço para pensar.

Depois, conectar ao Hermes real ficou mais seguro porque a interface já tinha uma opinião. Ela não estava esperando o backend decidir sua forma. Ela já sabia o que precisava mostrar.

Começar pelo mock foi isso: uma forma de ganhar clareza antes de ganhar poder.
