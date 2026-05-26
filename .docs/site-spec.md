# Especificação do site pessoal — Rafael Mayer

Documento descreve o que o site é hoje: stack, estrutura, rotas, componentes, conteúdo e padrões visuais. Para direção editorial e tom de voz, ver `portfolio-direction.md`.

## 1. Stack

- **Framework:** Astro 6 (estático, SSG).
- **Estilo:** Tailwind CSS v4 via `@tailwindcss/vite` + estilos globais customizados em `src/styles/global.css`.
- **Conteúdo:** coleções Astro com loaders `glob` em Markdown (`src/content/artigos`, `src/content/projetos`).
- **Tipografia:** Newsreader (serifa, títulos e prose) + Inter (sans, UI) + JetBrains Mono (datas, labels, metadados). Servidas via Google Fonts.
- **Gerenciador:** Bun como package manager e runner.
- **Build:** estático, sem SSR. Site pronto para deploy em qualquer host de páginas estáticas.

## 2. Estrutura de pastas

```
site/
  src/
    content/
      artigos/        # artigos em .md
      projetos/       # projetos em .md
    layouts/
      BaseLayout.astro
    pages/
      index.astro     # home
      artigos/
        index.astro
        [slug].astro
      projetos/
        index.astro
        [slug].astro
    styles/
      global.css
    content.config.ts # schemas das coleções
  public/
    avatar-placeholder.svg
  astro.config.mjs
  package.json
```

## 3. Rotas

| Rota | Conteúdo |
|---|---|
| `/` | Home: hero, sobre, agora, projetos (chamada), artigos (lista recente), contato |
| `/projetos/` | Lista de projetos publicados |
| `/projetos/[slug]/` | Página individual de projeto |
| `/artigos/` | Lista de artigos publicados |
| `/artigos/[slug]/` | Página individual de artigo |

## 4. Coleções de conteúdo

### `artigos`

```ts
{
  title: string;
  description: string;
  date: Date;            // ISO no frontmatter
  type?: string;         // ex: "Artigo", "Nota"
  tags: string[];        // default []
  published: boolean;    // default true
}
```

### `projetos`

```ts
{
  title: string;
  description: string;
  status?: string;       // ex: "em andamento", "público", "privado"
  date?: Date;
  tags: string[];
  published: boolean;
}
```

Itens com `published: false` ficam fora das listagens automaticamente.

## 5. Home — seções

### 5.1 Hero

- Avatar pequeno (~44px) inline com nome + cargo.
- H1 curto: *"Oi, eu sou o Rafael."*
- Dois leads:
  1. Sobre o tipo de trabalho que gosta de fazer (fronteira engenharia/software/infraestrutura).
  2. Estabelece que o site é um canto pessoal.

### 5.2 Sobre

- Papel atual no Optype (head de tecnologia, com link).
- Histórico na RM (líder técnico, AlvMais, Gear).
- Interesse pela fronteira engenharia/software + open source/homelab/self-hosting.
- Frase fechando o caráter pessoal: site não é só sobre tecnologia.

### 5.3 Agora

- Bloco curto sobre o que está fazendo nesse momento.
- Inclui stamp `atualizado em <mês> de <ano>` em mono discreto.
- Atualizar a cada 1–2 meses.

### 5.4 Projetos

- Chamada curta (uma frase) + link "ver projetos →".
- **Não** listar nomes de projetos na home.

### 5.5 Artigos

- Lista densa dos últimos 3–4 artigos (data + título + descrição).
- Link "ver tudo →" pra `/artigos`.

### 5.6 Contato

- Frase única com e-mail, linkedin e github como links inline.
- Sem fileira de pílulas/botões.

## 6. Páginas de índice (`/projetos`, `/artigos`)

- Cabeçalho com kicker em mono (`§ projetos` / `§ artigos`), H1 e parágrafo curto.
- Lista em formato denso (`.index-list`):
  - coluna de data/status em mono à esquerda;
  - título em serifa;
  - descrição curta;
  - tags inline em mono se houver.
- Empty state neutro: *"Nenhum projeto publicado por aqui ainda."* / *"Nenhum artigo publicado ainda."*

## 7. Páginas de detalhe (`/projetos/[slug]`, `/artigos/[slug]`)

- Largura da prose: `--measure` (mesma da home).
- Breadcrumb "← projetos" / "← artigos" em sans pequeno.
- Kicker em mono (`status` do projeto ou `type` do artigo).
- H1 serifado.
- Lead em itálico.
- Linha de metadados em mono (data + tags).
- Conteúdo do Markdown renderizado via `<Content />`.

## 8. Layout e medida

- Coluna única, centralizada.
- `--measure: 1000px` (home, header, footer, listas).
- `.prose` também usa `--measure` para alinhar com o resto.
- Padding lateral: `min(100% - 2.5rem, var(--measure))`.

## 9. Paleta

```
--color-ink:        #e8e4dc  (texto principal)
--color-ink-muted:  #9a9389  (texto secundário)
--color-ink-soft:   #6b665e  (metadados, datas)
--color-night:      #0c0c0d  (fundo)
--color-night-2:    #131315  (avatar bg)
--color-night-3:    #1a1a1d  (code inline bg)
--color-line:       #232327  (bordas)
--color-line-soft:  #1c1c1f  (divisores suaves)
--color-orange:     #e26a2c  (acento — usar com parcimônia)
--color-orange-soft:#f08a4b  (hover, links em prose)
```

Laranja é acento raro: links em prose, marcadores `§` de seção, hover, sublinhado dos `a:hover`. **Não** usar como cor de fundo nem em grandes áreas.

## 10. Tipografia

- **Serif (Newsreader)** — H1, H2, H3, `.brand`, prose body, títulos de entries.
- **Sans (Inter)** — body geral, navegação, descrições, parágrafos.
- **Mono (JetBrains Mono)** — datas (`.date`), labels (`.section-label`, `.kicker`), metadados (`.meta`, `.post-meta`), stamp do "agora" (`.now-stamp`).

Tamanhos:
- H1: `clamp(2.25rem, 4.6vw, 3.25rem)`.
- H2: `1.5rem`, weight 500.
- H3: `1.125rem`, weight 500.
- Body: `16px` / line-height `1.7`.
- Prose: `1.0625rem` / line-height `1.75`.

## 11. Componentes / padrões visuais

### Header

- Brand (`Rafael Mayer`) em serif à esquerda.
- Nav em sans minúsculo à direita: `projetos · artigos · contato`.
- Sem fundo, sem sombra. Linha invisível.

### Footer

- Borda superior `--color-line-soft`.
- Esquerda: `© <ano> · Rafael Mayer`.
- Direita: github · linkedin como links inline.

### Section label (kicker)

- Mono, lowercase, com prefixo `§ ` em laranja.
- Margem inferior antes do conteúdo da seção.

### Entry (listas de artigos/projetos)

- Grid `6.5rem 1fr`: data/status à esquerda, corpo à direita.
- Borda inferior tracejada `--color-line-soft`.
- Em mobile (≤560px): vira coluna única, data abaixo do título.

### Note

- Borda esquerda 2px laranja.
- Padding-left + texto em `--color-ink-muted`.
- Para empty states curtos ou avisos.

## 12. Acessibilidade

- HTML semântico (`<main>`, `<article>`, `<nav>`, `<header>`, `<footer>`).
- `aria-label` no nav principal.
- `alt=""` + `aria-hidden="true"` no avatar (decorativo).
- Contraste alto: ink (#e8e4dc) sobre night (#0c0c0d).
- Focus visível pelo padrão do browser.

## 13. Conteúdo: como criar

### Novo artigo

```bash
# criar arquivo
site/src/content/artigos/<slug>.md
```

Frontmatter mínimo:

```yaml
---
title: Título do artigo
description: "Resumo curto em uma linha."
date: 2026-05-26
type: Artigo
tags:
  - tag1
  - tag2
published: true
---
```

### Novo projeto

```bash
site/src/content/projetos/<slug>.md
```

Frontmatter mínimo:

```yaml
---
title: Nome do projeto
description: "Resumo curto."
status: em andamento
date: 2026-05-26
tags:
  - tag1
published: false
---
```

Usar `published: false` até o conteúdo estar pronto.

## 14. Comandos

Da raiz do monorepo:

```bash
bun install          # instala dependências
bun run dev          # dev server
bun run build        # build estático
bun run preview      # preview do build
bun run check        # astro check (typecheck + validação)
bun run sync         # regenera tipos de coleções
```

## 15. Deploy

- Site estático: gera `site/dist/` no build.
- Host: a definir (GitHub Pages, Cloudflare Pages, Vercel, ou self-hosted).
- Sem necessidade de runtime no servidor.
- `astro.config.mjs` define `site: 'https://rafaelmmayer.github.io'` — atualizar quando o domínio definitivo estiver.

## 16. Próximos passos (em aberto)

- Substituir `avatar-placeholder.svg` pelo avatar final.
- Definir domínio definitivo e atualizar `astro.config.mjs`.
- Configurar deploy automático no host escolhido.
- Adicionar projetos conforme cada um fica pronto.
- Continuar publicando artigos.
- Versão em inglês — sem prioridade no momento.

## 17. Manutenção deste documento

Atualizar quando:

- a stack ou arquitetura mudar;
- novas rotas, coleções ou padrões visuais forem adicionados;
- decisões de paleta, tipografia ou layout mudarem.

Não atualizar pra registrar mudanças de texto/tom — isso pertence a `portfolio-direction.md`.
