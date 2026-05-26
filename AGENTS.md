# AGENTS.md

## Requisitos antes de concluir

- Antes de considerar uma tarefa concluída, rode a menor validação relevante para os arquivos alterados.
- Antes de cada commit, garanta que o build ainda passa:

```bash
bun run build
```

- Para mudanças amplas, rode também:

```bash
bun run check
```

## Visão geral do projeto

Este repositório é o site pessoal do Rafael Mayer — apresentação, projetos e artigos sobre engenharia, software, infraestrutura e o que mais aparecer pelo caminho. Não é uma landing page comercial nem um portfolio com tom de campanha; é um caderno público.

A direção editorial e de tom está em `.docs/portfolio-direction.md` e `.docs/site-spec.md`. Leia antes de mexer em texto ou estrutura.

## Prioridades

1. Honestidade de tom acima de tudo. Sem marketing, sem buzzwords, sem CTA agressivo.
2. Conteúdo simples, editorial e direto.
3. Manutenibilidade do site (Astro + Markdown) acima de qualquer truque visual.
4. Performance e acessibilidade. Site estático, leve, sem JS desnecessário.

Quando houver tradeoff, prefira a versão mais simples e mais pessoal.

## Tom de voz

- Pessoal, simples, honesto, direto.
- Técnico quando necessário, sem pose de autoridade.
- Evitar "cases de sucesso", "soluções inovadoras", "ajude empresas a", "agende uma conversa", autoridade declarada.
- Evitar o padrão "não é X, não é Y, é Z" (tricolon de negação) — soa gerado por IA.
- Evitar auto-declarações performáticas ("vou ser transparente", "não estou aqui pra agradar").
- Preferir afirmar direto o que é, em vez de listar o que não é.
- Evitar buzzwords e linguagem inflada.

## Estrutura do repositório

- `site/` — projeto Astro com Tailwind. Tudo do site mora aqui.
- `site/src/pages/` — rotas (`index.astro`, `projetos/`, `artigos/`).
- `site/src/content/artigos/` — artigos em Markdown.
- `site/src/content/projetos/` — projetos em Markdown.
- `site/src/layouts/BaseLayout.astro` — header, nav, footer, fontes.
- `site/src/styles/global.css` — estilos globais. Variáveis de cor, tipografia, layout.
- `site/src/content.config.ts` — schemas das coleções (`artigos`, `projetos`).
- `.docs/` — direção editorial, brief e especificação do site. Documentação durável.
- `README.md` (raiz) — README do perfil do GitHub, em pt-BR.
- `Profile.md` — currículo exportado do LinkedIn, referência interna.

## Comandos

- Use `bun` para tudo. `bun install`, `bun run <script>`.
- Scripts da raiz (delegam pro `site/`):
  - `bun run dev` — Astro dev server
  - `bun run build` — build estático
  - `bun run preview` — preview do build
  - `bun run check` — `astro check` (typecheck e validação de conteúdo)
  - `bun run sync` — `astro sync` (regenera tipos de coleções)

## Conteúdo

- Artigos novos: criar `site/src/content/artigos/<slug>.md` com o frontmatter exigido pelo schema (`title`, `description`, `date`, `tags`, `published`, opcional `type`).
- Projetos novos: criar `site/src/content/projetos/<slug>.md` com `title`, `description`, opcional `status`, `date`, `tags`, `published`.
- Use `published: false` enquanto o conteúdo não está pronto.
- Datas em frontmatter: ISO (`YYYY-MM-DD`).
- Não duplicar metadados no corpo do markdown — o frontmatter cuida disso.

## Commits

Use Conventional Commits. Exemplos:

- `feat(home): adiciona seção "agora"`
- `fix(artigos): corrige link quebrado em por-que-este-site-existe`
- `chore(deps): atualiza astro para 6.x`
- `content(artigos): publica primeiro artigo`
- `style(prose): ajusta largura da coluna de leitura`

## O que evitar

- Não adicionar fonte, biblioteca ou dependência sem necessidade clara.
- Não criar componentes Astro novos quando uma seção em `index.astro` resolve.
- Não mexer no tom dos textos sem ler `.docs/portfolio-direction.md`.
- Não introduzir JS no client a menos que seja realmente necessário.
- Não publicar conteúdo no lugar do Rafael — sempre confirmar antes de marcar `published: true` em rascunhos.
