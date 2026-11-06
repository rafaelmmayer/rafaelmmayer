---
title: Como preparei o contexto de uma funcionalidade para desenvolver com IA
description: "Um caso de integração financeira no Optype: arquivos, transcrição, APIs e conferência no desenvolvimento com agentes de IA."
date: 2026-11-03
type: Artigo
tags: [ia, desenvolvimento, automação, integrações]
published: true
---

No Optype, a venda começa no Pipedrive. O faturamento e o recebimento ficam no Conta Azul. O financeiro também usava o Asana, e parte da ligação entre essas informações era feita em planilha.

Para saber quanto de uma venda já tinha sido faturado ou recebido, precisávamos juntar essas peças. A informação existia, mas acompanhar a empresa por esse caminho estava ficando difícil.

Trabalho desenvolvendo software e gosto de criar ferramentas que se encaixem no nosso jeito de trabalhar. Em experiências anteriores, mesmo usando sistemas prontos, frequentemente precisávamos construir integrações entre eles. Por isso, fazia sentido levar esses números para o nosso painel interno de gestão, a área do Optype que a equipe usa para acompanhar a operação da empresa.

Usei IA para reunir o material, desenvolver e conferir o resultado. Organizei o relato nessas etapas para explicar o processo, que teve idas e voltas.

## O fluxo que queríamos acompanhar

No nosso acompanhamento financeiro, organizamos os registros assim: uma venda pode ter notas, e cada nota pode ter parcelas. Essa relação permite partir do valor vendido e entender quanto já foi faturado, quanto foi recebido e o que ainda está pendente.

Escolhemos essa organização porque ela faz sentido no nosso negócio. Mas, nos sistemas de origem e na planilha, nem sempre fica claro a qual nota uma parcela pertence. Além de importar os dados, precisávamos descobrir quais registros estavam ligados entre si.

Essa foi uma das razões para construir a tela. Queríamos visualizar o caminho de uma venda até seus recebimentos, de acordo com a forma como acompanhamos a operação. O fluxograma abaixo mostra essa organização:

![Painel interno de gestão com dados fictícios: venda de R$ 12 mil ligada a duas notas de R$ 6 mil, com uma parcela paga e outra vencida.](/artigos/contexto-para-desenvolver-com-ia/venda-fluxo-demonstracao.png)

*Interface real, com nomes, datas e valores substituídos no navegador para demonstração. A hierarquia venda → notas → parcelas representa o modelo adotado neste painel.*

Neste exemplo fictício, a venda de R$ 12 mil já foi totalmente faturada em duas notas de R$ 6 mil. Uma parcela foi paga e a outra está vencida. Por isso, o painel mostra 100% faturado, 50% recebido e R$ 6 mil a receber. O desenho ajuda a localizar de onde vem cada número.

Para chegar a essa visão, precisávamos reunir as fontes e entender como os registros se relacionavam no nosso caso. Foi nesse trabalho que usei IA.

## Reunir o que já existia

Usei IA para buscar os dados das fontes e coloquei os arquivos numa pasta. Também fiz uma reunião para entender o que a equipe precisava enxergar no final. Peguei o vídeo da gravação do Teams e usei o Whisper localmente para transcrever a conversa. Guardei a transcrição junto dos dados.

### Do vídeo da reunião ao texto

Com o [Whisper](https://github.com/openai/whisper) instalado e o FFmpeg disponível no ambiente, dá para passar o vídeo diretamente para a ferramenta. Ela usa o FFmpeg para ler o áudio. Um exemplo de comando é:

```bash
whisper "reuniao-financeiro.mp4" \
  --model small \
  --language Portuguese \
  --task transcribe \
  --output_format txt \
  --output_dir "/contexto/financeiro/reuniao"
```

O comando gera `reuniao-financeiro.txt` na pasta indicada. `--language` informa o idioma falado, e `--task transcribe` mantém a transcrição no idioma original. O modelo `small` é uma escolha para este exemplo, não o registro do modelo que usei naquela ocasião. O processamento roda localmente; na primeira utilização, os pesos do modelo podem precisar ser baixados.

Eu poderia ter usado a transcrição do próprio Teams. Só lembrei disso depois de já ter feito a do Whisper, haha. Quando ela está disponível e você tem permissão, o Teams permite [baixar a transcrição da reunião](https://support.microsoft.com/en-gb/teams/meetings/start-stop-and-download-live-transcripts-in-microsoft-teams-meetings).

A transcrição permite buscar na conversa sem precisar assistir ao vídeo inteiro. Mas pode conter erros em nomes, números e termos técnicos. Se um trecho importante estiver confuso, vale voltar à gravação ou confirmar com quem participou.

Os arquivos dos sistemas traziam vendas, notas e parcelas. A reunião ajudava a entender o que a equipe precisava ver no painel e quais informações já tinham sido conferidas na planilha. Só baixar os dados não explicaria tudo isso.

### Como os dados chegavam à pasta

O agente pode usar ferramentas diferentes para coletar informação. Uma delas é fazer requisições HTTP a uma API, que devolve dados estruturados, frequentemente em JSON. Outra é operar a interface do sistema, navegando pelas páginas para consultar um registro ou obter um arquivo.

As consultas abaixo usam endpoints reais, conferidos na documentação dos três sistemas. São exemplos de como coletar esse tipo de informação; não são uma reprodução dos comandos originais da entrega. Tokens, identificadores e datas devem ser substituídos no ambiente autorizado.

#### Pipedrive: negócios ganhos

A [API de negócios do Pipedrive](https://developers.pipedrive.com/docs/api/v1/Deals) permite consultar os negócios ganhos com `status=won`:

```http
GET /api/v2/deals?status=won&limit=100 HTTP/1.1
Host: api.pipedrive.com
Accept: application/json
Authorization: Bearer <access_token_oauth>
```

Campos como `id`, `value`, `currency` e `org_id` ajudam a identificar o negócio, seu valor e a organização associada. Quando `additional_data.next_cursor` vier preenchido, ele deve ser enviado no parâmetro `cursor` da próxima consulta. Essa rota lista negócios não arquivados; históricos arquivados exigem uma consulta própria. O filtro de ganhos também é uma escolha do exemplo, não um inventário de todo o comercial.

#### Conta Azul: parcelas de contas a receber

No financeiro, uma consulta real é a [busca de contas a receber do Conta Azul](https://developers.contaazul.com/docs/financial-apis-openapi/v1/searchinstallmentstoreceivebyfilter):

```http
GET /v1/financeiro/eventos-financeiros/contas-a-receber/buscar?pagina=1&tamanho_pagina=100&data_vencimento_de=2026-01-01&data_vencimento_ate=2026-12-31 HTTP/1.1
Host: api-v2.contaazul.com
Accept: application/json
Authorization: Bearer <access_token_oauth>
```

Essa consulta retorna parcelas de receitas filtradas por vencimento. Ela exige paginação e intervalo de datas. As datas acima servem só de exemplo: uma coleta para conciliação deve escolher o período necessário e percorrer as páginas. Também é possível filtrar status como `ATRASADO`, mas começar apenas pelos atrasados deixaria outros recebimentos fora da análise.

Parcelas representam uma parte da operação. Para comparar faturamento e recebimento, ainda é preciso buscar as informações correspondentes de vendas e notas e entender seus vínculos.

#### Asana: o acompanhamento do financeiro

O Asana também fazia parte do processo. A [API de tarefas de um projeto](https://developers.asana.com/reference/gettasksforproject) permite pedir os campos necessários com `opt_fields`:

```http
GET /api/1.0/projects/<project_gid>/tasks?limit=100&opt_fields=name,completed,due_on,custom_fields HTTP/1.1
Host: app.asana.com
Accept: application/json
Authorization: Bearer <access_token>
```

O `project_gid` identifica o projeto autorizado. Os campos personalizados dependem da configuração de cada projeto; é preciso examinar o que representam antes de interpretar seu conteúdo. A próxima página usa o `offset` retornado em `next_page`. O acesso precisa permitir a leitura das tarefas, com o escopo `tasks:read` no caso de OAuth.

Cada resposta pode ser salva na pasta do sistema consultado. Registre também a data da coleta, os filtros usados e as páginas consultadas. Assim, ao abrir o arquivo depois, dá para saber, por exemplo, quais vencimentos foram consultados e se todas as páginas foram baixadas. Não guarde tokens nesses registros.

#### Computer use: conferir o registro na interface

Na navegação, a ferramenta permite ao agente observar a página e executar ações, como pesquisar uma venda, abrir seus detalhes e ler o que aparece. Dependendo da integração, essa observação pode usar capturas de tela ou informações estruturadas dos elementos da página. A [documentação de computer use da OpenAI](https://developers.openai.com/api/docs/guides/tools-computer-use) explica formas de conectar esse ciclo de observação e ação a um agente.

No caso da conferência, eu pedi para o Codex navegar no Pipedrive e no Conta Azul e bater as informações com o painel. Um pedido didático, usando os sistemas reais, seria:

```text
Use as sessões autenticadas do Pipedrive e do Conta Azul.

1. Abra no Pipedrive o negócio identificado no arquivo de conferência.
   Confira o cliente, o valor e as condições registradas.
2. No Conta Azul, localize os registros financeiros correspondentes.
   Confira faturamento, parcelas, vencimentos e recebimentos.
3. Abra a venda no painel interno de gestão e compare os mesmos campos.
4. Registre divergências com a fonte e o horário da consulta.

Não faça associações apenas pela igualdade dos valores.
Quando o vínculo não estiver claro, deixe uma pendência para revisão.
Faça apenas consultas; não altere os registros.
```

Para registrar a conferência, basta indicar o que foi comparado, onde e quando. Este JSON é um exemplo, com valores fictícios:

```json
{
  "fonte": "Conta Azul, detalhe da parcela",
  "consultado_em": "2026-11-03T10:00:00-03:00",
  "referencia_interna": "exemplo-001",
  "campo": "vencimento",
  "valor_na_fonte": "2026-10-15",
  "valor_no_admin": "2026-10-15",
  "resultado": "confere"
}
```

Se a busca falhar ou a página não carregar, marque a consulta como incompleta. Não encontrar uma parcela nessa tentativa não significa que ela não existe.

A API facilita baixar muitos registros de uma vez. Pelo navegador, o agente pode abrir uma venda e conferir seus detalhes na tela. Mas as duas consultas podem usar a mesma base de dados: se a API e a tela mostram o mesmo valor, esse valor ainda pode estar errado na origem.

Os materiais dessa entrega incluem JSONs de consultas e registros de conferência pela interface. Os exemplos mostram como reproduzir a abordagem sem expor os arquivos reais.

### Como organizar o material para consultar depois

Minha pasta real foi acumulando exportações, transcrição e documentos de acompanhamento. Para explicar essa organização, uma versão simplificada poderia ser assim. Os diretórios e nomes abaixo são ilustrativos:

```text
/contexto/financeiro/
├── LEIA-ME.md
├── reuniao/
│   └── transcricao.txt
├── fontes/
│   ├── pipedrive/negocios.json
│   ├── conta-azul/notas-e-parcelas.json
│   ├── asana/tarefas.json
│   └── planilha/conferencia.xlsx
└── conferencia/
    ├── evidencias.md
    └── pendencias.md

/projetos/aplicacao/     # código e instruções do repositório
```

Para quem for repetir o processo, sugiro um `LEIA-ME.md` que explique o que há em cada arquivo, quando os dados foram baixados e se faltou consultar alguma coisa. É uma sugestão para organizar melhor a pasta, não um arquivo que usei na entrega.

Por exemplo:

```markdown
# Fontes desta tarefa

- pipedrive/negocios.json: condições das vendas no sistema comercial.
- conta-azul/notas-e-parcelas.json: faturamento e recebimentos.
- asana/tarefas.json: acompanhamento feito pelo financeiro.
- planilha/conferencia.xlsx: acompanhamento manual, sujeito a revisão.
- reuniao/transcricao.txt: explicação da necessidade e das dúvidas.

Datas de coleta e filtros: registrar junto de cada exportação.
Consulta incompleta: marcar explicitamente; não tratar como ausência de dados.
Divergências: registrar em conferencia/pendencias.md para esclarecer.
```

Por exemplo: se uma parcela aparece como vencida no arquivo baixado do Conta Azul, mas a equipe informa que ela foi paga, vale registrar essa dúvida no arquivo de pendências e consultar o sistema de novo. O arquivo baixado mostra como a parcela estava na hora da coleta; o pagamento pode ter sido registrado depois. Guarde o arquivo original e anote a conclusão da conferência separadamente. Assim, fica claro o que veio do sistema e o que foi esclarecido depois.

## Levar esse contexto para o desenvolvimento

O código estava no repositório e o material de apoio em outra pasta. Indiquei os caminhos ao Codex e pedi ajuda para desenvolver usando os dados e a transcrição como contexto.

Daí em diante, segui desenvolvendo por partes. Fazia um pouco, revisava e continuava. O material ficava disponível para consultar durante esse processo, em vez de depender apenas do que eu lembrava de explicar no chat.

### O que o agente consegue consultar

Contexto é a informação que o modelo tem disponível naquele momento para trabalhar. Isso inclui o pedido, o histórico disponível da conversa e o que as ferramentas retornam, como trechos de arquivos ou resultados de testes.

Quando indico uma pasta, o agente pode buscar e ler os arquivos de que precisa, desde que tenha acesso. O conteúdo lido passa a fazer parte do contexto da tarefa. A pasta inteira não entra automaticamente na conversa só porque está no disco.

Por exemplo: para entender a necessidade, ele pode ler a transcrição. Para investigar uma diferença de valor, pode consultar a exportação financeira. Para implementar a correção, pode procurar o trecho correspondente no repositório. A [documentação de prompting do Codex](https://learn.chatgpt.com/docs/prompting) traz exemplos desse uso de arquivos e caminhos.

![Arquivos são consultados pelo agente e passam a fornecer informação para o desenvolvimento e a conferência.](/artigos/contexto-para-desenvolver-com-ia/diagrama-1.svg)

### Por que manter os arquivos mesmo depois da leitura

O modelo tem um limite para a quantidade de informação que consegue considerar de uma vez, chamado janela de contexto. Quando a conversa cresce, agentes como o Codex podem usar compactação: reduzem o histórico, buscando manter as informações necessárias para continuar a tarefa. Alguns detalhes podem ficar de fora. A [documentação de compactação da OpenAI](https://developers.openai.com/api/docs/guides/compaction) explica esse mecanismo.

Por exemplo: a equipe pode ter explicado no chat por que uma parcela pertence a determinada nota. Depois da compactação, essa explicação pode não estar mais disponível com o detalhe necessário para conferir a associação.

Os arquivos continuam no disco depois da compactação. Se a transcrição e os dados estão guardados, o agente pode voltar à fonte e recuperar a informação. Também vale registrar decisões e pendências em arquivos, em vez de deixá-las somente no chat. Esse é outro motivo para organizar o material e indicar onde encontrá-lo.

Isso depende de uma nova leitura: guardar o arquivo não garante que o agente vá consultá-lo sozinho. Ao retomar uma tarefa ou perceber uma dúvida, posso pedir que releia a decisão ou confira o registro original. O arquivo também precisa estar atualizado ou identificado com a data da coleta.

Reler um arquivo não garante que ele esteja correto. A transcrição pode ter um número errado, e a exportação pode estar desatualizada. O agente ainda precisa seguir as instruções do projeto e apontar essas dúvidas.

### Como explicar a tarefa

Este é um exemplo didático de instrução, reconstruído a partir do processo. Ele não reproduz o prompt original. Os caminhos abaixo são ilustrativos:

```text
Repositório: /projetos/aplicacao
Material de apoio: /contexto/financeiro

Leia a transcrição para entender o resultado desejado.
Use os dados exportados para investigar registros e vínculos.
Consulte as instruções do repositório antes de alterar o código.

Precisamos acompanhar quanto de cada venda foi faturado e recebido.
Se as fontes discordarem, registre a divergência para conferência.
Não deduza um vínculo apenas porque os valores são iguais.

Proponha uma primeira etapa pequena. Depois da implementação,
execute os testes relevantes e mostre o que mudou.
```

O pedido diz o que queremos, onde estão os arquivos e o que fazer quando houver dúvida. Isso importa porque uma parcela ligada à venda errada pode fazer o painel mostrar uma dívida como paga e outra como pendente, mesmo que o total recebido esteja correto.

## Conferir nos sistemas de origem

Para conferir o resultado, abri outra sessão do Codex com contexto limpo. Dei acesso novamente aos arquivos e pedi que navegasse no Pipedrive e no Conta Azul, comparando os dados com o que aparecia no painel.

Queria que a nova sessão comparasse os dados sem partir das explicações e decisões da conversa em que desenvolvi o painel. Isso não garantia encontrar todos os erros: ela ainda usava a mesma ferramenta e parte das mesmas fontes. Depois eu também olhei o resultado, que passou ainda pela revisão de outra pessoa da equipe.

Os registros dessa etapa mostram problemas que só olhar os totais não revelaria. Uma nota podia deixar de ser importada porque o sistema não encontrava a venda correspondente. Mas a nota existia: precisava aparecer no painel, mesmo sem a venda associada, para que a equipe pudesse conferir. Também havia um aviso de diferença de faturamento que não considerava o funcionamento das assinaturas.

### Uma regra de negócio que apareceu na conferência

O histórico do código registra uma correção na identificação de divergências de faturamento. O trecho abaixo foi retirado da alteração, com o corpo do aviso omitido:

```csharp
var invoicedAmount = decimal.Round(invoiced, 2, MidpointRounding.AwayFromZero);
var saleAmount = decimal.Round(sale.Amount, 2, MidpointRounding.AwayFromZero);

if (
    invoicedAmount != saleAmount
    && (sale.SaleType != SaleType.Subscription || invoicedAmount > saleAmount)
)
{
    // Emite o aviso de divergência.
}
```

Para uma assinatura, o valor faturado pode estar abaixo do valor total do contrato porque ainda há faturamento futuro. Nesse caso, a diferença sozinha não deve produzir esse aviso. Faturamento acima do total continua sendo sinalizado. Para as demais vendas, esse trecho mantém a comparação por diferença de valor.

É uma regra específica do nosso fluxo. Ela mostra por que a IA precisava de contexto da operação além do código: comparar dois valores era fácil; decidir quando essa diferença merecia atenção exigia entender o contrato.

### Conferência como outra tarefa

O pedido de exemplo mostrado antes orienta a comparar campos como valor, vencimento e recebimento no painel e nos sistemas de origem. Para cada diferença, pede o registro de onde ela apareceu e do que precisa ser esclarecido. A tela carregar sem erro não mostra se os números estão certos.

O diagrama resume esse caminho, do levantamento dos dados à conferência pela equipe:

![Fluxo de desenvolvimento por etapas, testes e comparação do painel com os sistemas de origem, seguido de revisão humana.](/artigos/contexto-para-desenvolver-com-ia/diagrama-2.svg)

Um teste pode verificar se o código calcula corretamente o percentual recebido de uma venda. A conciliação confere se as parcelas usadas nesse cálculo correspondem aos registros dos sistemas de origem. Nesse trabalho, precisávamos das duas verificações.

## Como os dados continuam atualizados

Os arquivos serviram para desenvolver e conferir a funcionalidade. Na operação, a atualização é feita pelo backend, consultando os sistemas de origem. O agente de IA não precisa ficar navegando nas telas para manter o painel atualizado.

No código, há um serviço agendador em .NET que usa uma expressão cron para solicitar a sincronização às 7h e às 16h, no fuso `America/Sao_Paulo`:

```text
0 7,16 * * *
│ │    │ │ │
│ │    │ │ └─ qualquer dia da semana
│ │    │ └─── qualquer mês
│ │    └───── qualquer dia do mês
│ └────────── às 7h e às 16h
└──────────── no minuto zero
```

Essa expressão é interpretada pela biblioteca [Cronos](https://github.com/HangfireIO/Cronos) dentro da aplicação. Não é uma entrada no cron do Linux. O agendador registra uma execução pendente, e um worker em segundo plano processa essa solicitação e guarda o histórico do resultado. Também há uma verificação para recusar uma nova solicitação quando já existe execução pendente ou em andamento.

### Como os registros se relacionam

A sincronização consulta os negócios ganhos no Pipedrive e os dados financeiros no Conta Azul. O Asana e a planilha fizeram parte do levantamento e da conferência; não são fontes dessa rotina automática no código consultado.

Para reconhecer um registro já importado, usamos o sistema de origem e o ID que ele atribuiu ao registro. Assim, na próxima consulta, atualizamos o registro existente em vez de criar outro. Para ligar uma nota a uma venda ou uma parcela a uma nota, usamos outras regras:

- **Nota com venda:** o código procura uma referência comercial nas observações da venda do Conta Azul e a compara com o código presente no título da venda importada do Pipedrive. Para uma nota nova, um único candidato permite o vínculo automático. Sem candidato ou com mais de um, a nota é importada sem vínculo e o sistema registra uma mensagem para conferência.
- **Parcela com nota:** o código considera a venda de origem no Conta Azul e os números de nota ou de RPS (Recibo Provisório de Serviços) disponíveis. Se encontrar uma única nota correspondente, faz a associação. Caso contrário, usa uma regra alternativa, ou fallback: entre as notas que podem receber a parcela e não estão canceladas, escolhe a de emissão mais antiga e emite um aviso para revisar o vínculo. Se não houver uma nota que atenda a esses critérios, fica uma pendência para tratar.

Se uma parcela já está associada a uma nota, a sincronização preserva essa ligação. A equipe pode ter conferido e corrigido o vínculo manualmente; não queremos que a próxima execução desfaça essa correção usando a regra automática.

Essas regras refletem os dados e as convenções do nosso fluxo. Usar apenas o valor para relacionar registros seria insuficiente: duas vendas podem ter o mesmo valor, e uma venda pode ser faturada em mais de uma nota. O histórico e as mensagens de sincronização ajudam a acompanhar as situações que ainda precisam de atenção.

## O que ficou mais visível

O painel ainda é recente. Um episódio que chamou nossa atenção foi o de duas vendas com valores iguais e recebimentos vencidos também de mesmo valor. A equipe não lembrava daquelas pendências. Ao conferir, entendemos que precisávamos cobrar o cliente.

É um exemplo pequeno do que queríamos conseguir: enxergar melhor informações que já estavam nos sistemas, mas eram difíceis de acompanhar juntas.

Para mim, essa entrega mostrou o valor de preparar o contexto e manter a conferência perto do desenvolvimento. A IA participou de várias etapas, e o trabalho continuou exigindo entender a operação, revisar o código e conferir o resultado com quem conhecia os dados.
