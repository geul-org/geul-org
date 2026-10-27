---
title: "WIKIDATA-PID"
weight: 6
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "WIKIDATA-PID es un Reference de declaración que apunta a una propiedad (Property) de Wikidata con el número de su ID P."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
WIKIDATA-PID es un Reference de declaración que apunta a una propiedad (Property) de Wikidata. Se escribe como entero sin signo la parte numérica del ID P sin la `P`.

## Layout

```
TAG WORD          0000 0LLL L010 1QQQ      CCCC = 0101
[TAG de extensión de Length]
PID               unsigned big-endian del ancho más corto
```

- El PID se escribe con el ancho más corto. Los números de propiedad actuales caben en 1 WORD y ocupan 2 WORD en total; si superan 65535, pasan de forma natural a 3 WORD.
- Se usa sobre todo en la posición de Predicate de [TRIPLE](/es/grammar/edge/triple/) y de Property de [QUALIFIER](/es/grammar/edge/qualifier/).

## Ejemplo

| Propiedad | Secuencia de WORD |
|---|---|
| `P31` (instance of) | `00A8 001F` |
| `P279` (subclass of) | `00A8 0117` |
| `P569` (date of birth) | `00A8 0239` |

## Páginas relacionadas

- [Reference](/es/grammar/reference/), [WIKIDATA-QID](/es/grammar/reference/wikidata-qid/), [TRIPLE](/es/grammar/edge/triple/), [QUALIFIER](/es/grammar/edge/qualifier/)
