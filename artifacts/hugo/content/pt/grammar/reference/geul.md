---
title: "GEUL"
weight: 3
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "GEUL é a Reference de declaração que aponta para um alvo por um ID de entidade emitido em CC0 pelo geul.org."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL é a Reference de declaração que aponta para uma entidade emitida em CC0 pelo geul.org. É um ID serial, sem significado no número. O identificador que leva significado nos bits fica a cargo do Codec separado [GEUL-SIDX](/pt/grammar/reference/geul-sidx/) (`0011`).

## Layout

```
TAG WORD          0000 0LLL L001 0QQQ      CCCC = 0010
[TAG estendida de Length]
ID GEUL           unsigned big-endian na menor largura
```

- Os números pequenos são atribuídos a entidades de alta frequência. Um ID que cabe em 1 WORD tem 2 WORD no total.
- A atribuição de IDs e o registro são geridos pelo geul.org. No registro só entra o que vem de fontes CC0.
- Se for Variable, é uma variável anônima dessa espécie ([Reference](/pt/grammar/reference/) Variable).

## Exemplo

| ID GEUL | Sequência de WORDs |
|---|---|
| 1, Identified | `0090 0001` |
| 1, Variable | `0094 0001` |
| 70000, Generic | `0111 0001 1170` |

## Questões em aberto

- Regras de atribuição de IDs GEUL e formato de divulgação do registro.

## Páginas relacionadas

- [Reference](/pt/grammar/reference/), [GEUL-SIDX](/pt/grammar/reference/geul-sidx/)
