---
title: "WIKIDATA-PID"
weight: 6
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "WIKIDATA-PID é a Reference de declaração que aponta para uma propriedade (Property) do Wikidata pelo número do ID P."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

WIKIDATA-PID é a Reference de declaração que aponta para uma propriedade (Property) do Wikidata. Escreve-se como inteiro sem sinal a parte numérica do ID P, sem o `P`.

## Layout

```
TAG WORD          0000 0LLL L010 1QQQ      CCCC = 0101
[TAG estendida de Length]
PID               unsigned big-endian na menor largura
```

- O PID é escrito na menor largura. Os números de propriedade atuais cabem em 1 WORD, então são 2 WORD no total, e passam naturalmente a 3 WORD acima de 65535.
- Usa-se sobretudo na posição de Predicate de [TRIPLE](/pt/grammar/edge/triple/) e de Property de [QUALIFIER](/pt/grammar/edge/qualifier/).

## Exemplo

| Propriedade | Sequência de WORDs |
|---|---|
| `P31` (instance of) | `00A8 001F` |
| `P279` (subclass of) | `00A8 0117` |
| `P569` (date of birth) | `00A8 0239` |

## Páginas relacionadas

- [Reference](/pt/grammar/reference/), [WIKIDATA-QID](/pt/grammar/reference/wikidata-qid/), [TRIPLE](/pt/grammar/edge/triple/), [QUALIFIER](/pt/grammar/edge/qualifier/)
