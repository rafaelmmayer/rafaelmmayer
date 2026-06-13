---
title: "Homelab: Cloudflare Tunnel sem abrir o roteador"
description: "Como penso a exposição pública de alguns serviços do homelab usando Cloudflare Tunnel, sem abrir porta direta para o host."
date: 2026-06-16
type: Artigo
order: 3
tags:
  - homelab
  - cloudflare
  - segurança
published: false
---

## Ideia do artigo

Este texto pode separar duas coisas que às vezes aparecem misturadas: conseguir acessar algo de fora e decidir que algo deveria estar acessível de fora.

Cloudflare Tunnel resolve uma parte técnica importante, mas não transforma qualquer painel interno em serviço público seguro. A decisão mais importante continua sendo o que publicar, para quem, e com qual camada de autenticação.

## Pontos para desenvolver

- Por que escolhi rodar `cloudflared` em Docker Compose.
- Diferença entre publicar via tunnel e abrir porta no roteador.
- Por que prefiro `cloudflared -> Traefik -> serviço` para manter um padrão.
- O que pode ficar público e o que deve ficar atrás de Cloudflare Access.
- O que não deveria sair da rede local.

## Possível estrutura

1. O impulso de expor tudo.
2. O tunnel como caminho mais controlado.
3. O compose do `cloudflared`.
4. Regras práticas de exposição.
5. A parte chata que importa: autenticação e superfície de ataque.

## Notas soltas

Usar exemplos genéricos. Evitar listar serviços sensíveis demais. A ideia é mostrar critério, não inventário completo.
