---
title: "DIFFERENT-NODE"
weight: 3
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DIFFERENT-NODE es un Edge de afirmación de no identidad: dos Reference apuntan a objetos distintos (Codec 0x02)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DIFFERENT-NODE es un Edge de afirmación de no identidad: dos Reference apuntan a referents distintos. Codec `0x02`.

No significa que la codificación en byte, el Codec o el ID de dos registros Reference sean distintos. Se distingue del enlace dirigido de [REFERENCE-NODE](/es/grammar/edge/reference-node/) y de la identidad de [SAME-NODE](/es/grammar/edge/same-node/).

## Layout

```
TAG WORD          0001 0LLL L000 0010
[TAG de extensión de Length]
Edge Id           registro Reference LOCAL
Subject           1 registro Reference
Object            1 registro Reference
```

## Interpretación y validez

- Subject y Object deben ser cada uno exactamente un registro [Reference](/es/grammar/reference/) completo. La frontera se halla con la Length de cada registro; si es un Value o un Edge, o está incompleto, es inválido.
- Subject y Object apuntan a referents distintos. No se infiere que los referents sean distintos solo por una diferencia en la secuencia de byte, el Codec o el ID de los registros Reference.
- En particular, dos ID [LOCAL](/es/grammar/reference/local/) distintos son solo dos Reference distintos, y no significa que los referents de la realidad también lo sean. No se deriva DIFFERENT solo de una diferencia de ID LOCAL.
- La no identidad es simétrica, irreflexiva y no transitiva. `DIFFERENT(A, B)` es la misma relación que `DIFFERENT(B, A)`. Pero de `DIFFERENT(A, B)` y `DIFFERENT(B, C)` no se infiere `DIFFERENT(A, C)`.
- El orden Subject/Object en el wire es solo un orden de serialización para el framing y no crea una dirección semántica. Las implementaciones deben poder recorrerlo en ambos sentidos.
- El cursor tras leer los dos componentes debe coincidir exactamente con el final del Edge.

La relación en sí es irreflexiva, pero no se debe borrar como error de gramática del wire una aserción estructuralmente válida como `DIFFERENT(A, A)`, ni una aserción en que choquen SAME y DIFFERENT. Esas aserciones conservan el contexto y el linaje, y la capa de juicio las trata como contradicciones. Al interpretar o derivar DIFFERENT se conservan la procedencia, el momento, el world y el policy scope del documento que contiene ese Edge, y no se amplía a una conclusión global que los ignore.

## Longitud

```
total = 1 + N_len + N_id + N_subject + N_object WORD
```

## Ejemplo (no normativo)

Edge Id `000a`, Subject es LOCAL 1 y Object es LOCAL 2.

- El Edge es TAG 1 + Edge Id 2 + Subject 2 + Object 2 = 7 WORD, `LLLL=0110`. El TAG es `0001 0 0110 0000010` = `1302`.

```
1302 0088 000a 0088 0001 0088 0002
```

La diferencia entre los ID LOCAL de este ejemplo solo sirve para mostrar la codificación. Esta secuencia se convierte en DIFFERENT-NODE únicamente cuando hay una aserción aparte de que el ID 1 y el ID 2 apuntan a referents distintos.

## Páginas relacionadas

- [Edge](/es/grammar/edge/), [REFERENCE-NODE](/es/grammar/edge/reference-node/), [SAME-NODE](/es/grammar/edge/same-node/)
- [Reference](/es/grammar/reference/), [LOCAL](/es/grammar/reference/local/)
