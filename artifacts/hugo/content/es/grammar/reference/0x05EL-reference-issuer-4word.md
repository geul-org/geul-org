---
title: "REFERENCE-ISSUER-4WORD (0x05EL)"
weight: 94
date: 2026-11-03T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "issuer"]
summary: "REFERENCE-ISSUER-4WORD es un formato de Reference definido por un Issuer."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

REFERENCE-ISSUER-4WORD es un formato de Reference definido por un Issuer. Es una de las tres últimas casillas de la zona Reference y el ancho del Issuer es de 4 WORD. El layout ISSUER de los tres Kind es el mismo ([Registros y TAG WORD](../record.md#issuer-형식-레코드)).

| Elemento | Valor |
|---|---|
| Nombre | `REFERENCE-ISSUER-4WORD` (BIND `REFERENCE-ISSUER-4WORD` del documento de especificación) |
| TAG ID | `0x05EL` |
| Codec ID | `0x000005E0` |
| Documento de especificación | `0x00000000/codecs/0x000005E0/` (destino de DECLARE `05E0`) |
| Sección | 2 `0010` (Reference otros), desplazamiento dentro de la sección C = 30 |
| Kind | Reference · clasificación: formato de Issuer |
| TAG WORD | `0000 0101 1110 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Issuer de 4 WORD y número de Codec de 2 WORD. El formato lo fija el documento de Codec del Issuer |
| Lado Hugo | `reference/reference-issuer.md` |

## Layout {#레이아웃}

```
TAG WORD          0000 0101 1110 LLLL      Codec 0x05EL
[TAG de extensión de Length]
Issuer            4 WORD
Número de Codec   2 WORD. Lo define el Issuer
Payload           Lo fija el documento de Codec publicado por el Issuer
```

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([Documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato aceptado (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | valor en bruto de 4 WORD |  |  |
| 2 | `codec` | #3 | valor en bruto de 2 WORD |  |  |
| 3 | `payload` | #4 | resto en valor en bruto (`0xFFFF`) |  |  |

La composición de `payload` la fija el documento de Codec de ese Issuer.

## Interpretación y validez {#해석과-유효성}

- GEUL solo conoce por Length el límite del Payload. Un decodificador que no conoce el formato llega a conocer el Kind, el Length, el Issuer y el número de Codec, y salta con Length.
- El significado del número de Codec, la cuantificación y lo que se señala los fija el documento de Codec publicado por el Issuer. No se aplican las reglas comunes de Reference, como el ancho mínimo del ID de destino o la lectura de la cuantificación ([REFERENCE-ISSUER](_index.md#해석과-유효성)).
- El Issuer se escribe con el ancho más corto en que quepa el valor ([Issuer y publicación](../issuer.md#issuer-등급)). Si los 2 WORD superiores del valor del Issuer son 0, es invalid. Ese valor se escribe con el código de 2 WORD ([REFERENCE-ISSUER-2WORD](0x05DL-reference-issuer-2word.md)).
- El número de Codec es de 2 WORD. El Issuer lo asigna sin solaparse dentro de su `codecs/`, con independencia del Kind. Si los números no alcanzan, se obtiene otro Issuer.
- El documento de Codec se coloca bajo `<Issuer>/codecs/<número de Codec>/` de ese Issuer ([Direcciones de publicación y lista de versiones](../publishing.md#id-표기)).
- La licencia de un formato de Issuer la fija ese Issuer ([Issuer y publicación](../issuer.md#라이선스)).

## Páginas relacionadas {#관련-페이지}

- [REFERENCE-ISSUER](_index.md#reference-issuer), [REFERENCE-ISSUER-2WORD](0x05DL-reference-issuer-2word.md), [REFERENCE-ISSUER-16WORD](0x05FL-reference-issuer-16word.md)
- [Registros y TAG WORD](../record.md#issuer-형식-레코드), [Issuer y publicación](../issuer.md)

## Texto original del documento de especificación {#규격-문서-원문}

Así se ve el documento de especificación `0x00000000/codecs/0x000005E0/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000005E000000000
BODY
#1 DECLARE 0x05E0
#2 FIELD #1 0x0004
#3 FIELD #1 0x0002
#4 FIELD #1 rest
#5 BIND #1 "REFERENCE-ISSUER-4WORD"
#6 BIND #2 "issuer"
#7 BIND #3 "codec"
#8 BIND #4 "payload"
```
