---
title: "VALUE-ISSUER-4WORD (0x09EL)"
weight: 158
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text", "decimal", "time"]
summary: "VALUE-ISSUER-4WORD es un formato de Value definido por un Issuer."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

VALUE-ISSUER-4WORD es un formato de Value definido por un Issuer. Es una de las tres últimas casillas de la zona de Value y su ancho de Issuer es de 4 WORD. El layout ISSUER es el mismo en los tres Kind ([Registro y TAG WORD](../record.md#issuer-형식-레코드)).

| Elemento | Valor |
|---|---|
| Nombre | `VALUE-ISSUER-4WORD` (BIND del documento de especificación `VALUE-ISSUER-4WORD`) |
| TAG ID | `0x09EL` |
| Codec ID | `0x000009E0` |
| Documento de especificación | `0x00000000/codecs/0x000009E0/` (destino de DECLARE `09E0`) |
| Sección | 4 `0100` (Value), desplazamiento C dentro de la sección = 30 |
| Kind | Value · clasificación: formato de Issuer |
| TAG WORD | `0000 1001 1110 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Issuer de 4 WORD y número de Codec de 2 WORD. El formato lo determina el documento de Codec del Issuer |
| Lado Hugo | `value/_index.md` |

## Layout {#레이아웃}

```
TAG WORD          0000 1001 1110 LLLL      Codec 0x09EL
[TAG de extensión de Length]
Issuer            4 WORD
Número de Codec   2 WORD. Lo define el Issuer
Payload           Lo determina el documento de Codec que publica el Issuer
```

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato que recibe (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | valor en bruto de 4 WORD |  |  |
| 2 | `codec` | #3 | valor en bruto de 2 WORD |  |  |
| 3 | `payload` | #4 | resto de valor en bruto (`0xFFFF`) |  |  |

La composición de `payload` la determina el documento de Codec de ese Issuer.

## Interpretación y validez {#해석과-유효성}

- GEUL solo conoce el límite del Payload mediante Length. Un decodificador que no conoce el formato llega hasta Kind, Length, Issuer y número de Codec, y salta el resto con Length.
- La interpretación del Payload la determina el documento de Codec del Issuer. Los Value de formato de Issuer registrados actualmente están en el [índice de Codec](../codec-index.md#value-issuer-형식).
- El Issuer se escribe con el ancho más corto en que quepa el valor ([Issuer y publicación](../issuer.md#issuer-등급)). Si los 2 WORD superiores del valor del Issuer son 0, es invalid. Ese valor se escribe con el código de 2 WORD ([VALUE-ISSUER-2WORD](0x09DL-value-issuer-2word.md)).
- El número de Codec es de 2 WORD. El Issuer lo asigna dentro de su propio `codecs/` sin que se solape, con independencia del Kind. Si los números no bastan, se obtiene otro Issuer.
- El documento de Codec se coloca bajo `<Issuer>/codecs/<número de Codec>/` de ese Issuer ([dirección de publicación y lista de versiones](../publishing.md#id-표기)).
- La licencia de un formato de Issuer la determina ese Issuer ([Issuer y publicación](../issuer.md#라이선스)).

## Páginas relacionadas {#관련-페이지}

- [Value — formato de Issuer](_index.md#issuer-형식), [VALUE-ISSUER-2WORD](0x09DL-value-issuer-2word.md), [VALUE-ISSUER-16WORD](0x09FL-value-issuer-16word.md)
- [Registro y TAG WORD](../record.md#issuer-형식-레코드), [Issuer y publicación](../issuer.md)

## Texto original del documento de especificación {#규격-문서-원문}

Es el aspecto del documento de especificación `0x00000000/codecs/0x000009E0/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000009E000000000
BODY
#1 DECLARE 0x09E0
#2 FIELD #1 0x0004
#3 FIELD #1 0x0002
#4 FIELD #1 rest
#5 BIND #1 "VALUE-ISSUER-4WORD"
#6 BIND #2 "issuer"
#7 BIND #3 "codec"
#8 BIND #4 "payload"
```
