---
title: "REFERENCE-NODE"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "REFERENCE-NODE es un Edge de afirmación dirigido que liga un Reference a un registro Object y define qué es ese Reference (Codec 0x00)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

REFERENCE-NODE es un Edge de afirmación dirigido que conecta un Reference con un registro Object para definir o ligar qué es ese Reference. Codec `0x00`.

Subject señala a Object. Este enlace no es un [SAME-NODE](/es/grammar/edge/same-node/), que afirma una identidad semántica, ni significa que los byte de los dos registros sean iguales.

## Layout

```
TAG WORD          0001 0LLL L000 0000
[TAG de extensión de Length]
Edge Id           registro Reference LOCAL
Subject           1 registro Reference
Object            1 registro Reference o Value
```

## Interpretación y validez

- Subject debe ser exactamente un registro [Reference](/es/grammar/reference/) completo. La frontera se halla con la Length del propio Subject; si no es un Reference o está incompleto, es inválido.
- Object debe ser exactamente un registro Reference o Value completo. La frontera se halla con la Length del propio Object; si es un Edge o Meta, o está incompleto, es inválido.
- Si Object es un Reference, la cadena de Reference que se sigue mediante enlaces REFERENCE-NODE no debe ser cíclica, y el LOCAL debe resolverse al final. Un ciclo de resolución y un LOCAL colgante (dangling) son inválidos.
- Si en un mismo documento un ID LOCAL se liga a Object en conflicto, es inválido. El alcance, el ID, el ancho mínimo y las reglas de fusión de LOCAL siguen a [LOCAL](/es/grammar/reference/local/).
- No todos los Reference deben estar ligados con REFERENCE-NODE.
- El uso representativo es `LOCAL → UTF8-LANGUAGE-TEXT`. Cuando se pone un LOCAL en el Object de [LABEL](/es/grammar/edge/label/), el texto se resuelve con este enlace del mismo documento.

No se debe interpretar al revés la dirección en que Subject señala a Object. El significado y las reglas detalladas de SAME y DIFFERENT los fija cada formato por separado.

## Longitud

```
total = 1 + N_len + N_id + N_subject + N_object WORD
```

`N_len` es el número de WORD del TAG de extensión de Length, `N_id` es el número de WORD del registro LOCAL del Edge Id, y `N_subject` y `N_object` son el número total de WORD de cada registro. El cursor tras leer Subject y Object debe coincidir exactamente con el final del Edge.

## Ejemplo (no normativo)

Edge Id `0008`, Subject es LOCAL 1 y Object es un [UTF8-LANGUAGE-TEXT](/es/grammar/value/text/utf8-language-text/) de `Donald Trump` (en).

- El Edge Id es `0088 0008`, 2 WORD.
- Subject es `0088 0001`, 2 WORD.
- Object es idioma `08C6 656e` (BCP47 `en`) + texto de 12 byte (par), por lo que es `UTF8-LANGUAGE-TEXT-EVEN` (`0x4A`), 9 WORD en total. El TAG es `0C4A`.
- El Edge es TAG 1 + Edge Id 2 + Subject 2 + Object 9 = 14 WORD, `LLLL=1101`. El TAG es `1680`.

```
1680 0088 0008 0088 0001 0C4A 08C6 656e 446f 6e61 6c64 2054 7275 6d70
```

## Páginas relacionadas

- [Edge](/es/grammar/edge/), [SAME-NODE](/es/grammar/edge/same-node/), [DIFFERENT-NODE](/es/grammar/edge/different-node/), [LABEL](/es/grammar/edge/label/)
- [Reference](/es/grammar/reference/), [LOCAL](/es/grammar/reference/local/), [UTF8-LANGUAGE-TEXT](/es/grammar/value/text/utf8-language-text/)
