---
title: "WIKIDATA-QID"
weight: 5
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "WIKIDATA-QID es un Reference de declaración que apunta a un elemento (Item) de Wikidata con el número de su ID Q."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
WIKIDATA-QID es un Reference de declaración que apunta a un elemento (Item) de Wikidata. Se escribe como entero sin signo la parte numérica del ID Q sin la `Q`.

## Layout

```
TAG WORD          0000 0LLL L010 0QQQ      CCCC = 0100
[TAG de extensión de Length]
QID               unsigned big-endian del ancho más corto
```

- El QID se escribe con el ancho más corto. De `Q1` a `Q65535` son 2 WORD en total y por encima son 3 WORD.
- Los datos de Wikidata son CC0.
- Si es Variable, es una variable anónima del tipo al que apunta ese elemento (Variable de [Reference](/es/grammar/reference/)).

## Ejemplo

| Elemento | Secuencia de WORD |
|---|---|
| `Q5` (human) | `00A0 0005` |
| `Q76` (Barack Obama) | `00A0 004C` |
| `Q884` (South Korea) | `00A0 0374` |
| `Q317521` (Elon Musk) | `0120 0004 D851` |
| `Q30461` (president), Variable | `00A4 76FD` |

## Páginas relacionadas

- [Reference](/es/grammar/reference/), [WIKIDATA-PID](/es/grammar/reference/wikidata-pid/), [TRIPLE](/es/grammar/edge/triple/)
