# AGENTS.md

Para personalidade, voz e posicionamento: ver `SOUL.md`.

---

## Estilo de comunicação

- Mantenha respostas curtas e concisas.
- Não use emojis em commits, issues, comentários de PR ou código.
- Evite fluff e preenchimento excessivamente entusiasmado. Exemplo: prefira `Thanks @user` a `Thanks so much @user!`.
- Use prosa técnica e direta.
- Quando o usuário fizer uma pergunta, responda primeiro antes de editar arquivos ou rodar comandos de implementação.
- Ao responder a feedback do usuário ou a uma análise, diga explicitamente se concorda ou discorda antes de explicar o que foi alterado.

## Visão geral

Site pessoal do Rafael Mayer — apresentação, projetos e artigos sobre engenharia, software, infraestrutura e o que mais aparecer pelo caminho.

## Prioridades

1. Honestidade de tom. Ler `SOUL.md` antes de mexer em qualquer texto.
2. Conteúdo simples, editorial e direto.
3. Manutenibilidade (Astro + Markdown) acima de qualquer truque visual.
4. Site estático, leve, sem JS desnecessário.

## Estrutura do repositório

```
site/src/pages/          rotas (index.astro, projetos/, artigos/)
site/src/content/artigos/    artigos em Markdown
site/src/content/projetos/   projetos em Markdown
site/src/layouts/BaseLayout.astro
site/src/styles/global.css
site/src/content.config.ts   schemas das coleções
README.md                    perfil GitHub, pt-BR
SOUL.md                      personalidade e voz
AGENTS.md                    este arquivo
```

## Rotas

```
/                    home
/projetos/           lista de projetos
/projetos/[slug]/    página individual
/artigos/            lista de artigos
/artigos/[...slug]/  página individual, incluindo artigos em subpastas
```

## Seções da home

| Seção | Conteúdo |
|---|---|
| **Hero** | Avatar + nome + cargo + linha sobre o que constrói + caráter pessoal do site |
| **Sobre** | Optype (papel + link), RM (AlvMais/Gear), eng/software/infra, open source/homelab, não é só tecnologia |
| **Agora** | O que está fazendo agora. Stamp `atualizado em <mês> <ano>`. Atualizar a cada 1–2 meses. |
| **Projetos** | Chamada curta + link. Sem listar nomes na home. |
| **Artigos** | Lista densa dos últimos 3–4. Sem grid de cards. |
| **Contato** | Frase única com links inline. Sem pílulas de CTA. |

## Decisões visuais firmadas

- **"Artigos"** é o termo (não "escritos", "notas", "blog").
- BIM não aparece no posicionamento.
- Sem mural de badges, sem lista de tecnologias na home.
- Sem grid de cards estilo "features".
- Coluna única, ~1000px, laranja como acento raro.
- Tipografia: Newsreader (títulos/prose) · Inter (UI) · JetBrains Mono (meta/datas).

## Contatos e referências

- E-mail: mayer.rafa@outlook.com
- LinkedIn: https://www.linkedin.com/in/rafaelmmayer/
- GitHub: https://github.com/rafaelmmayer/rafaelmmayer
- Idioma: português. Inglês no futuro, sem prioridade.

**Projetos candidatos** (entram quando ficarem prontos):
Optype · Sourcea/Reeva · Solidus · AlvMais · Gear · EngTools

## Próximo passo em aberto

- Definir domínio e atualizar `site/astro.config.mjs`.
- Configurar deploy automático.

## Comandos

```bash
bun run dev       # dev server
bun run build     # build estático
bun run preview   # preview do build
bun run check     # typecheck + validação
bun run sync      # regenera tipos de coleções
```

## Conteúdo

**Novo artigo:** `site/src/content/artigos/<slug>.md`

```yaml
---
title: Título
description: "Resumo curto."
date: 2026-05-26
# opcional, só quando um texto publicado for revisado
updated: 2026-06-15
type: Artigo
tags: [tag1, tag2]
published: false
---
```

**Séries de artigos:** usar subpasta em `site/src/content/artigos/<serie>/<slug>.md`.

Todo `.md` dentro de uma subpasta é tratado como parte da série com o nome da pasta. Exemplo:

```text
site/src/content/artigos/homelab/dns-local-e-home-arpa.md
site/src/content/artigos/homelab/traefik-como-porta-de-entrada.md
```

Usar `order` no frontmatter para indicar a parte da série:

```yaml
order: 1
```

Artigos soltos em `site/src/content/artigos/*.md` continuam sendo tratados como artigos normais.

**Novo projeto:** `site/src/content/projetos/<slug>.md`

```yaml
---
title: Nome
description: "Resumo curto."
status: em andamento
date: 2026-05-26
# opcional, só quando um projeto publicado for revisado
updated: 2026-06-15
tags: [tag1]
published: false
---
```

Usar `published: false` até o conteúdo estar pronto. Datas em ISO (`YYYY-MM-DD`). Campo `updated` é opcional e só deve aparecer quando um texto ou projeto publicado for revisado. O site formata datas com `timeZone: 'UTC'` para evitar deslocamento de dia em datas sem horário.

## Commits

Conventional Commits:

- `feat(home): adiciona seção "agora"`
- `fix(artigos): corrige link quebrado`
- `content(artigos): publica artigo sobre linkedin`
- `style(prose): ajusta largura da coluna`
- `chore(deps): atualiza astro para 6.x`

## Antes de concluir

```bash
bun run build   # sempre
bun run check   # para mudanças amplas
```

## O que evitar

- Não adicionar dependência sem necessidade clara.
- Não criar componentes Astro novos quando uma seção em `index.astro` resolve.
- Não mexer em texto ou tom sem ler `SOUL.md`.
- Não introduzir JS no client sem necessidade real.
- Não marcar `published: true` em rascunhos sem confirmar com o Rafael.
