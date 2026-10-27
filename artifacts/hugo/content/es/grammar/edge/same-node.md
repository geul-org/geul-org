---
title: "SAME-NODE"
weight: 2
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "SAME-NODE es un Edge de afirmación de identidad, sin dirección, que declara que dos Reference apuntan al mismo objeto (Codec 0x01)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SAME-NODE es un Edge de afirmación de identidad, sin dirección, que declara que dos Reference apuntan al mismo referent. Codec `0x01`.

No significa que la codificación en byte, el Codec o el ID de dos registros Reference sean iguales. Mientras que [REFERENCE-NODE](/es/grammar/edge/reference-node/) es un enlace dirigido `Reference → registro`, SAME-NODE expresa la identidad (referential identity) entre dos Reference.

## Layout

```
TAG WORD          0001 0LLL L000 0001
[TAG de extensión de Length]
Edge Id           registro Reference LOCAL
Subject           1 registro Reference
Object            1 registro Reference
```

## Interpretación y validez

- Subject y Object se serializan en este orden, y cada uno debe ser exactamente un registro [Reference](/es/grammar/reference/) completo. La frontera se halla con la Length de cada registro.
- Si Subject u Object es un Value, un Edge o un registro incompleto, es inválido.
- La relación SAME-NODE es reflexiva, simétrica y transitiva. El orden Subject/Object en el wire es para el framing y no crea una dirección semántica. Las implementaciones deben poder recorrer esta relación en ambos sentidos.
- Dos ID [LOCAL](/es/grammar/reference/local/) distintos son solo dos Reference distintos, y no son evidencia de que los referents sean iguales o distintos. Que dos Reference apunten al mismo referent se establece con SAME-NODE.
- La interpretación y la inferencia deben conservar la procedencia, el momento, el world y el policy scope del documento que contiene ese Edge y del grafo de juicio. SAME-NODE no se usa como base de una fusión global ajena al contexto.
- Aunque exista SAME-NODE, no se borran ni se sobrescriben el registro Reference original ni el linaje.
- Que un mismo par tenga a la vez SAME-NODE y [DIFFERENT-NODE](/es/grammar/edge/different-node/) no hace inválido el wire. Se conserva el contexto de cada aserción y se evalúa como conflicto.
- Un Reference Variable se resuelve conectándolo con un Reference Identified mediante SAME-NODE (Variable de [Reference](/es/grammar/reference/)).

## Longitud

```
total = 1 + N_len + N_id + N_subject + N_object WORD
```

## Ejemplo (no normativo)

Edge Id `0009`, Subject es LOCAL 1 y Object es LOCAL 2.

- El Edge es TAG 1 + Edge Id 2 + Subject 2 + Object 2 = 7 WORD, `LLLL=0110`. El TAG es `0001 0 0110 0000001` = `1301`.

```
1301 0088 0009 0088 0001 0088 0002
```

## Páginas relacionadas

- [Edge](/es/grammar/edge/), [REFERENCE-NODE](/es/grammar/edge/reference-node/), [DIFFERENT-NODE](/es/grammar/edge/different-node/)
- [Reference](/es/grammar/reference/), [LOCAL](/es/grammar/reference/local/)
