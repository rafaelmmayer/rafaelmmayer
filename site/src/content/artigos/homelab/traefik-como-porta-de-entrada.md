---
title: "Homelab: Traefik como porta de entrada"
description: "Por que centralizei as rotas locais do homelab no Traefik e como isso ajuda a manter os serviços mais fáceis de operar."
date: 2026-06-15
type: Artigo
order: 2
tags:
  - homelab
  - traefik
  - docker
published: false
---

## Ideia do artigo

Este texto pode ser sobre a decisão de ter uma porta de entrada única para os serviços internos.

O ponto principal não é vender Traefik. É explicar o alívio operacional de não deixar cada serviço exposto de um jeito diferente. Quando o roteamento fica em um lugar só, fica mais fácil entender o ambiente, trocar serviço por baixo e manter um padrão.

## Pontos para desenvolver

- Rede Docker `proxy` como fronteira comum dos serviços.
- Serviços Docker versus serviços no host via systemd.
- Quando apontar para container e quando apontar para gateway da rede Docker.
- Rotas por hostname local.
- Middlewares e headers como recurso útil, mas sem deixar o setup mais esperto do que precisa.

## Possível estrutura

1. O problema de cada serviço abrir sua própria porta.
2. Traefik como camada de roteamento, não como centro do universo.
3. Como um serviço entra no padrão.
4. Como serviços do host entram no mesmo padrão.
5. Limites: nem tudo precisa passar por proxy.

## Notas soltas

Seria bom incluir um diagrama textual simples. A série ganha quando mostra o desenho mental antes dos comandos.
