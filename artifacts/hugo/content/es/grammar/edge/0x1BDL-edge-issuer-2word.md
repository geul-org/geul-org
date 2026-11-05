---
title: "EDGE-ISSUER-2WORD (0x1BDL)"
weight: 445
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "EDGE-ISSUER-2WORD es un formato de Edge definido por el Issuer."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EDGE-ISSUER-2WORD es un formato de Edge definido por el Issuer. Es una de las tres últimas posiciones de la zona de Edge y el ancho del Issuer es 2 WORD. El layout de ISSUER es el mismo en los tres Kind ([Registro y TAG WORD](../record.md#issuer-형식-레코드)).

| Elemento | Valor |
|---|---|
| Nombre | `EDGE-ISSUER-2WORD` (BIND del documento de especificación `EDGE-ISSUER-2WORD`) |
| TAG ID | `0x1BDL` |
| Codec ID | `0x00001BD0` |
| Documento de especificación | `0x00000000/codecs/0x00001BD0/` (objetivo de DECLARE `1BD0`) |
| Sección | 13 `1101` (Edge (últimas 3 posiciones ISSUER)), desplazamiento C dentro de la sección = 29 |
| Kind | Edge · clasificación: formato Issuer |
| TAG WORD | `0001 1011 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Issuer de 2 WORD y número de Codec de 2 WORD. El formato lo define el documento de Codec del Issuer |
| Lado Hugo | `edge/_index.md` |

## Layout {#레이아웃}

```
TAG WORD          0001 1011 1101 LLLL      Codec 0x1BDL
[Length TAG extendida]
Issuer            2 WORD
Número de Codec   2 WORD. Lo define el Issuer
Edge Id           registro LOCAL Reference. Primer elemento tras el Issuer y el número de Codec
Resto de Payload  Lo define el documento de Codec publicado por el Issuer
```

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)). El Edge Id de un Edge no se declara como FIELD. En EDGE-ISSUER, el Edge Id va después del número de Codec y antes del campo `payload` ([layout](#레이아웃)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato aceptado (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | valor en bruto 2 WORD |  |  |
| 2 | `codec` | #3 | valor en bruto 2 WORD |  |  |
| 3 | `payload` | #4 | resto del valor en bruto(`0xFFFF`) |  |  |

La composición de `payload` la define el documento de Codec de ese Issuer.

## Interpretación y validez {#해석과-유효성}

- GEUL solo conoce el límite del Payload mediante Length. Un decodificador que no conoce el formato llega hasta Kind, Length, Issuer y número de Codec, y salta el resto con Length.
- El Payload empieza con el Edge Id (Reference LOCAL) ([Edge](_index.md#레이아웃)). Los componentes posteriores al Edge Id los define el documento de Codec del Issuer.
- El Issuer se escribe con el ancho más corto en que cabe el valor ([Issuer y publicación](../issuer.md#issuer-등급)). Un Issuer de 2 WORD puede usar cualquier valor.
- El número de Codec es de 2 WORD. El Issuer lo asigna sin solapamientos dentro de su propio `codecs/`, sin importar el Kind. Si los números no alcanzan, se solicita otro Issuer.
- El documento de Codec se coloca bajo `<Issuer>/codecs/<número de Codec>/` de ese Issuer ([dirección de publicación y lista de versiones](../publishing.md#id-표기)).
- La licencia de un formato Issuer la determina ese Issuer ([Issuer y publicación](../issuer.md#라이선스)).

## Páginas relacionadas {#관련-페이지}

- [Edge — Edge de formato Issuer](_index.md#issuer-형식-edge), [EDGE-ISSUER-4WORD](0x1BEL-edge-issuer-4word.md), [EDGE-ISSUER-16WORD](0x1BFL-edge-issuer-16word.md)
- [Registro y TAG WORD](../record.md#issuer-형식-레코드), [Issuer y publicación](../issuer.md)

## Texto original del documento de especificación {#규격-문서-원문}

Aspecto del documento de especificación `0x00000000/codecs/0x00001BD0/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001BD000000000
BODY
#1 DECLARE 0x1BD0
#2 FIELD #1 0x0002
#3 FIELD #1 0x0002
#4 FIELD #1 rest
#5 BIND #1 "EDGE-ISSUER-2WORD"
#6 BIND #2 "issuer"
#7 BIND #3 "codec"
#8 BIND #4 "payload"
```
