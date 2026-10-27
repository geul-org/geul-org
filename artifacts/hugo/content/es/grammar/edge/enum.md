---
title: "ENUM"
weight: 30
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "ENUM es un Edge de afirmación que da significado a un valor de código de un campo de valor crudo (Codec 0x1D). El nombre se liga con BIND."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ENUM es un Edge de afirmación que da significado a un valor de código de un campo de valor crudo. Codec `0x1D`.

Junto con [FIELD](/es/grammar/edge/field/), es el vocabulario con el que se escriben las especificaciones de Codec. El layout viene integrado en el decodificador ([Documento de especificación de Codec](/es/grammar/codec-spec/)).

## Layout

```
TAG WORD          0001 0LLL L001 1101
[TAG de extensión de Length]
Edge Id           registro Reference LOCAL
Campo             registro Reference LOCAL que apunta a un Edge FIELD
Valor de código   valor crudo. Mismo número de WORD que el ancho de ese FIELD
```

## Interpretación y validez

- El campo debe ser un FIELD de valor crudo (ancho `n ≥ 1`). No se pone ENUM a un campo de registro. El significado de un registro lo dice el Codec de ese registro.
- El valor de código ocupa exactamente el ancho de ese FIELD. La frontera se comprueba con la Length del registro ENUM.
- En un campo no se declara dos veces el mismo valor de código.
- El nombre del valor de código se liga al Edge Id de ENUM con [BIND](/es/grammar/edge/bind/). Todo UTF8-TEXT que se pone a DECLARE, FIELD, ENUM y CODEC se hace con BIND, y no se pone con otros Edge como LABEL.
- Un valor de código no declarado no es un error. El visor lo muestra como valor crudo. Cerrar o no los valores permitidos corresponde a la especificación del Codec; el vocabulario actual no tiene una marca para cerrarlos.

## Longitud

```
total = 1 + N_len + N_id + N_field + n WORD
```

## Ejemplo (no normativo)

En el campo de categoría de motivo (FIELD #4, valor crudo de 1 WORD) del documento de especificación de TOMBSTONE se declara el código `0x0001`. Edge Id 10. El nombre se liga aparte con BIND. La tabla de códigos de categorías de motivo aún no está fijada, así que el valor de código es solo un ejemplo.

- TAG 1 + Edge Id 2 + campo 2 + valor de código 1 = 6 WORD, `LLLL = 0101`.

```
129D 0088 000A 0088 0004 0001
```

El documento de especificación de TRIPLE pone tres ENUM (`0`, `1`, `2`) en el campo Rank (FIELD #5) y los liga con BIND a `normal`, `preferred` y `deprecated` respectivamente ([TRIPLE](/es/grammar/edge/triple/)).

## Páginas relacionadas

- [DECLARE](/es/grammar/edge/declare/), [FIELD](/es/grammar/edge/field/), [CODEC](/es/grammar/edge/codec/), [BIND](/es/grammar/edge/bind/)
- [Documento de especificación de Codec](/es/grammar/codec-spec/)
