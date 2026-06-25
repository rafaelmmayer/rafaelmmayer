---
title: "Homelab: operando infraestrutura com agentes"
description: "O que muda quando um agente com terminal, memória e acesso ao repositório passa a fazer parte do jeito de operar um homelab."
date: 2026-06-18
type: Artigo
order: 5
tags:
  - homelab
  - agentes
  - automação
published: true
---

Nos primeiros textos da série, falei das peças que deixam o [homelab](/projetos/homelab/) mais fácil de usar: DNS local, Traefik, Cloudflare Tunnel, busca e leitura da web.

Só que tem uma parte do meu uso diário que mudou bastante nos últimos meses: eu passei a operar parte desse ambiente conversando com um agente.

No meu caso, esse agente é o Hermes. Eu chamo ele de Bob.

## O agente perto da infra

O Bob funciona melhor quando está perto do lugar onde as coisas acontecem.

Isso quer dizer acesso a terminal, arquivos, repositórios, navegador, histórico de sessões, skills e memória persistente. Em um homelab, essa proximidade muda bastante a utilidade do agente. Ele pode olhar um compose, conferir uma rota do Traefik, ler um serviço systemd, ajustar um arquivo, rodar build, ver erro, corrigir e validar de novo.

A conversa vira uma interface para operação, mas com uma diferença importante: a resposta precisa carregar evidência. Se ele diz que buildou, tem que ter saída de build. Se diz que mudou um arquivo, tem que apontar o arquivo. Se diz que um serviço respondeu, tem que mostrar o status ou o teste que rodou.

Essa exigência é o que separa um fluxo útil de uma conversa bonita.

## Como ele roda aqui

No meu setup, o Hermes aparece de algumas formas.

O gateway roda como serviço de usuário e conecta o agente ao Telegram. É por ali que eu mando mensagens como esta. O dashboard também roda como serviço e fica atrás do Traefik em:

```text
hermes.home.arpa
```

A rota local aponta para a porta `9119` no host. Isso mantém o dashboard dentro do mesmo desenho dos outros serviços: nome local, Traefik na frente, serviço por trás.

Os arquivos do Hermes ficam em `~/.hermes`. Ali entram configuração, sessões, skills, memória, logs e scripts auxiliares. Essa pasta precisa de critério, porque ela existe como parte do ambiente. O agente não fica só em uma aba. Ele tem estado, ferramentas e histórico.

Também uso cron jobs do Hermes para rotinas pequenas. Um exemplo é o relatório diário de memória, que coleta candidatos de consolidação e pede aprovação manual antes de qualquer mudança. Esse ponto importa para mim: automação local precisa ser auditável.

## Memória e skills

Memória persistente é uma das partes mais úteis, e também uma das que mais precisam de limite.

Quando o Bob lembra que o Traefik usa a rede `proxy`, que o Firecrawl responde em `127.0.0.1:3002`, que o site pessoal fica em `/home/mayer/dev/rafaelmmayer/site`, ou que rascunhos devem continuar com `published: false`, eu preciso explicar menos.

Esse tipo de memória reduz atrito. Ela não deveria virar um depósito de tudo. Fato temporário, tarefa concluída, número de PR, commit antigo e detalhe que vai envelhecer rápido só poluem o contexto. Preferência estável, caminho importante e convenção de trabalho fazem mais sentido.

Skills cumprem outro papel. Elas guardam procedimentos. Se publicar o site exige build, commit, deploy e verificação via Traefik, isso pertence a uma skill. Se operar um serviço de produção tem runbook, também. A memória diz o que é verdade sobre o ambiente. A skill diz como repetir um caminho com menos improviso.

Essa separação deixa o agente menos dependente de lembrança vaga.

## Ferramentas com consequência

Um agente com terminal é útil porque consegue agir. Pelo mesmo motivo, precisa de freio.

Editar artigo é uma coisa. Alterar compose, reiniciar serviço, mexer em DNS, publicar rota ou apagar arquivo é outra. O fato de o Bob conseguir rodar comandos não transforma todo comando em boa ideia.

Tento manter uma regra simples: tarefas com consequência precisam de verificação e escopo claro. Antes de mexer em serviço, olhar o arquivo certo. Depois de mexer, rodar o teste possível. Se for publicar algo, confirmar a intenção. Se uma ação for destrutiva, parar e pedir confirmação.

Isso vale ainda mais no homelab porque tudo fica perto demais. O mesmo agente que escreve um rascunho consegue editar um compose. A conveniência é real. O risco também.

## Exemplos do uso diário

Alguns usos são pequenos.

Peço para o Bob localizar onde está um serviço, abrir o compose e me dizer qual hostname ele usa. Peço para conferir logs de um container. Peço para transformar uma ideia em rascunho de artigo. Peço para procurar uma sessão antiga em que decidimos alguma coisa.

Outros usos atravessam mais peças.

Quando mexi no site, o Bob leu as regras de voz, editou Markdown, rodou `bun run build` e reportou o resultado. Quando olhamos exposição pública, ele comparou Traefik, Cloudflare Tunnel e DNS local. Quando quero pesquisar ferramenta, ele pode usar busca, extração de páginas e terminal na mesma conversa.

O ponto prático é que o agente consegue costurar contexto. Ele não precisa abrir uma aba mental nova para cada ferramenta. Arquivo, comando, artigo, memória e serviço ficam na mesma linha de trabalho.

## Onde eu seguro a mão

A parte mais importante desse modelo é saber onde parar.

Eu não quero um agente tomando decisões de arquitetura sozinho. Também não quero memória sendo consolidada automaticamente sem revisão, nem serviço publicado porque pareceu conveniente, nem configuração sensível sendo tratada como texto comum.

O lugar bom do agente é a execução acompanhada: investigar, propor, editar, testar, explicar o que aconteceu e deixar a decisão importante visível.

Isso combina bem com homelab. Grande parte do trabalho é operacional e repetitivo: lembrar comando, achar arquivo, comparar configuração, rodar validação, escrever documentação do que acabou de mudar. Um agente ajuda bastante nisso.

Julgamento ainda fica comigo.

## Operar conversando

A melhor descrição que tenho hoje é esta: o Bob virou parte da interface do homelab.

DNS local deixa os serviços nomeados. Traefik organiza a entrada. Cloudflare Tunnel controla o que sai para a internet. SearXNG e Firecrawl ajudam a buscar e ler. O Bob fica por cima dessas camadas, não como dono delas, mas como uma forma de operar com menos troca de contexto.

Quando funciona, eu consigo dizer o que quero fazer e acompanhar a execução. O agente consulta o ambiente, usa o que já sabe, chama as ferramentas certas e volta com uma resposta verificável.

Ainda tem muita coisa para melhorar. Quero runbooks mais claros, mais testes para operações comuns, melhor separação entre ações seguras e ações sensíveis, e menos dependência de conhecimento espalhado em conversa.

Mas a direção já mudou meu jeito de usar o homelab. A infra deixou de ser só um conjunto de serviços. Ela virou um ambiente que responde melhor quando eu converso com ele, desde que a conversa termine em evidência.
