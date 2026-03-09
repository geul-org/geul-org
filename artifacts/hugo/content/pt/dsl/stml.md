---
title: "STML — SSOT Template Markup Language"
weight: 2
date: 2026-03-08T12:00:00+09:00
lastmod: 2026-03-08T12:00:00+09:00
tags: ["STML", "DSL", "SSOT", "frontend", "React", "OpenAPI"]
summary: "Uma linguagem de declaração de UI independente de framework. Define o que as páginas mostram e fazem com atributos HTML5 data-*, valida simbolicamente contra OpenAPI e gera código React."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**SSOT Template Markup Language** — declaração de UI independente de framework.

O código frontend mistura duas coisas: **suas decisões** e **a fiação do framework**. Qual API chamar, quais campos mostrar, em que ordem, sob que condições — essas decisões ficam enterradas em React hooks ou Vue composables. Ao trocar de framework ou refatorar, as decisões são reinterpretadas ou perdidas.

O STML as separa. As decisões ficam em HTML padrão com atributos `data-*`. A fiação do framework é gerada ou delegada.

<a href="https://github.com/geul-org/stml" target="_blank" rel="noopener">Repositório GitHub</a>

## Estrutura

```
┌─────────────────────────────────┐
│  STML (specs/)                  │  Suas decisões. Independente de framework.
│  O que buscar, mostrar, enviar  │  Sobrevive a qualquer reescrita.
├─────────────────────────────────┤
│  Codegen / LLM                  │  Gera a fiação do framework.
│  React, Vue, Svelte, qualquer   │  Substituível.
├─────────────────────────────────┤
│  Runtime (artifacts/)           │  React TSX, Vue SFC, etc.
│  Hooks, estado, renderização    │  Gerado. Não edite.
└─────────────────────────────────┘
```

## O que é preservado

Tudo no HTML do STML é uma decisão do usuário:

- **Quais endpoints de API** chamar (`data-fetch`, `data-action`)
- **Quais campos** exibir ou coletar (`data-bind`, `data-field`)
- **Em que ordem** os elementos aparecem (estrutura DOM)
- **Como aparece** (classes Tailwind, tags HTML)
- **Que texto** os usuários veem (títulos, placeholders, rótulos de botões)
- **Que condições** controlam a visibilidade (`data-state`)
- **Que componentes** lidam com UX especial (`data-component`)
- **Comportamento de listas** — paginação, ordenação, filtragem

Não é React. Não é Vue. É o que sua página faz, declarado em HTML5 padrão.

## Validação

O validador integrado verifica o STML contra OpenAPI antes de gerar código:

- O operationId existe? O método HTTP está correto?
- Os campos de request, response e parâmetros correspondem ao schema?
- As colunas de sort/filter/include estão nas listas permitidas?
- Os componentes referenciados existem?

Detecta incompatibilidades frontend-API no CI, não no runtime.

```bash
stml validate specs/my-project    # 12 verificações simbólicas contra OpenAPI
```

## Atributos data-*

| Atributo | O que declara |
|---|---|
| `data-fetch` | Carrega dados de um endpoint GET |
| `data-action` | Envia dados para um endpoint POST/PUT/DELETE |
| `data-field` | Coleta um campo do corpo da requisição |
| `data-bind` | Exibe um campo da resposta |
| `data-param-*` | A operação precisa de um parâmetro de caminho/query |
| `data-each` | Itera sobre um campo array |
| `data-state` | Exibe condicionalmente |
| `data-component` | Delega a um componente personalizado |
| `data-paginate` | Lista paginada |
| `data-sort` | Lista ordenável (coluna e direção padrão) |
| `data-filter` | Lista filtrável (quais colunas) |
| `data-include` | Inclui recursos relacionados |

## Licença

MIT — <a href="https://github.com/geul-org/stml" target="_blank" rel="noopener">GitHub</a>
