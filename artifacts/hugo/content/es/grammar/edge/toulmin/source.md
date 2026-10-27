---
title: "SOURCE y secciones"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "Son los formatos ISSUER de GEUL 0xC000~0xC005 con los que se escriben el texto original de autoría (SOURCE), las cadenas (TEXT), las divisiones en secciones y casos (SECTION, CASE-BEGIN, CASE-END) y los párrafos descriptivos (PROSE) de un documento TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Son los registros con los que se escriben el texto original y las divisiones de un documento TOULMIN. Todos son Edge `ISSUER-1WORD` (`0x7C`) que usan números de formato bajo el Issuer `0x0000` (GEUL) ([TOULMIN](/es/grammar/edge/toulmin/#formatos-issuer)).

## Formatos

| Número de formato | Nombre | Layout |
|---|---|---|
| `0xC000` | SOURCE | ID, WORD de ancho de SPAN, Value UTF8 |
| `0xC001` | TEXT | ID, Value UTF8 |
| `0xC002` | SECTION | ID, código de sección de 1 WORD |
| `0xC003` | CASE-BEGIN | ID, REF (caso) |
| `0xC004` | CASE-END | ID, REF (caso) |
| `0xC005` | PROSE | ID, SPAN |

- ID es el Edge Id y REF es el Edge Id de un registro de este documento (campos comunes de [TOULMIN](/es/grammar/edge/toulmin/#campos-comunes)).
- El Value UTF8 es un registro Value [UTF8-TEXT](/es/grammar/value/text/utf8-text/). Contiene los bytes tal cual.

## SOURCE

Es todo el texto original de autoría. Todos los SPAN son rangos de bytes dentro de este texto original.

```
ID
WORD de ancho de SPAN   2 bits superiores = ancho (00=1, 01=2, 10=4, 11=8 WORD), los 14 bits restantes = 0
texto original          registro Value UTF8-TEXT
```

- SOURCE es el primer registro del BODY. Solo hay uno por documento.
- SPAN son dos campos: el byte de inicio y el número de bytes. Cada campo es un entero unsigned del ancho (1/2/4/8 WORD) fijado por el WORD de ancho de SPAN.

## TEXT

Es un nombre o una cadena. Lo señalan con REF las listas F_WITH y F_GROUNDS de NODE y el LABEL e IMPORTED-FROM de LINK.

## SECTION

Es el inicio de una sección. El código de sección es 1 WORD.

| Código | Sección | TANGEUL |
|---|---|---|
| 1 | Subject | `this document is x` |
| 2 | See | `see a from path` |
| 3 | Definitions | `means`, `has` |
| 4 | Rules | reglas de expresión condicional |
| 5 | Cases | `in case of x` |
| 6 | Provides | `provides x` |
| 7 | Internal | `on`, `every` |

- `0` no se usa. Las secciones se declaran en el orden de estos códigos.
- El título de la sección es el PROSE que va justo después de SECTION.

## CASE-BEGIN, CASE-END

- El ámbito de un caso es el que hay entre el CASE-BEGIN y el CASE-END que apuntan al mismo caso (CASE-DECLARE NODE).

## PROSE

Es un párrafo descriptivo que no es una regla. Solo apunta a un rango (SPAN) del texto original.

## Páginas relacionadas

- [TOULMIN](/es/grammar/edge/toulmin/), [NODE](/es/grammar/edge/toulmin/node/), [LINK](/es/grammar/edge/toulmin/link/)
