---
title: "ALIAS (0x0A5L)"
weight: 165
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "ALIAS es un Edge de enunciado que conecta con Object otro nombre (alias) del objeto Subject."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `ALIAS` (BIND del documento de especificación `ALIAS`) |
| TAG ID | `0x0A5L` |
| Codec ID | `0x00000A50` |
| Documento de especificación | `0x00000000/codecs/0x00000A50/` (destino de DECLARE `0A50`) |
| Sección | 5 `0101` (enunciado de Edge), desplazamiento dentro de la sección C = 5 |
| Kind | Edge · familia: enunciado, grupo: señalamiento y nombre |
| TAG WORD | `0000 1010 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Conexión de otro nombre (alias) de Subject. El layout es igual que el de LABEL |
| Lado Hugo | `edge/alias.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)). El Edge Id de un Edge no se declara con FIELD.

| Orden | Campo (BIND) | FIELD | Ancho | Formato que acepta (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | registro | cualquier registro (excepto marcadores de posición) |  |
| 2 | `object` | #3 | registro | `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT, `0050` LOCAL |  |

ALIAS es un Edge de enunciado que conecta con Object otro nombre (alias) del objeto Subject. Codec `0x0A5L`.

[LABEL](0x0A4L-label.md) es el nombre representativo en ese idioma (como máximo uno por idioma), y ALIAS es otro nombre del mismo objeto (varios por idioma, el «also known as» de Wikidata). Se usa sobre todo en la búsqueda. El layout y la validez son iguales que los de LABEL.

## Layout {#레이아웃}

```
TAG WORD          0000 1010 0101 LLLL
[TAG de extensión de Length]
Edge Id           registro Reference LOCAL
Subject           1 registro Reference
Object            1 Value UTF8-LANGUAGE-TEXT o registro Reference LOCAL
```

## Interpretación y validez {#해석과-유효성}

- Las reglas de Subject y Object son iguales que las de [LABEL](0x0A4L-label.md) (Object es [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md) o un LOCAL que se resuelve a él).
- Para el mismo Subject e idioma se pueden poner varios ALIAS. El orden es el orden dentro del documento.
- No se pone como ALIAS el mismo texto que el LABEL del mismo Subject e idioma (el nombre representativo basta con un LABEL). Esta regla es una recomendación.
- El documento de especificación de geul.org limita Object con [CODEC](0x0BEL-codec.md) (`0780`·`0790`·`0050`, igual que LABEL).

## Ejemplo (no normativo) {#예시-비규범}

Edge Id `0003`, Subject Q42 (`0141 002A`), Object `DNA` (en): idioma `0761 656E` (BCP47 `en`) + texto de 3 bytes (impar) → `UTF8-LANGUAGE-TEXT-ODD` (`0x079L`), `0794 0761 656E 444E 4100`.

- TAG 1 + Edge Id 2 + Subject 2 + Object 5 = 10 WORD, `LLLL=1001`. El TAG es `0A59`.

```
0A59 0051 0003 0141 002A 0794 0761 656E 444E 4100
```

## Páginas relacionadas {#관련-페이지}

- [Edge](_index.md), [LABEL](0x0A4L-label.md), [DESCRIPTION](0x0A6L-description.md), [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md)

## Texto original del documento de especificación {#규격-문서-원문}

Así se ve el documento de especificación `0x00000000/codecs/0x00000A50/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A5000000000
BODY
#1 DECLARE 0x0A50
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "ALIAS"
#5 BIND #2 "subject"
#6 BIND #3 "object"
#7 CODEC #3 0x0780
#8 CODEC #3 0x0790
#9 CODEC #3 0x0050
```
