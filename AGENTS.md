# AGENTS.md

Para personalidade, voz e posicionamento: ver `SOUL.md`.

---

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
/artigos/[slug]/     página individual
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

- Substituir `public/avatar-placeholder.svg` pelo avatar final.
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
type: Artigo
tags: [tag1, tag2]
published: false
---
```

**Novo projeto:** `site/src/content/projetos/<slug>.md`

```yaml
---
title: Nome
description: "Resumo curto."
status: em andamento
date: 2026-05-26
tags: [tag1]
published: false
---
```

Usar `published: false` até o conteúdo estar pronto. Datas em ISO (`YYYY-MM-DD`).

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
