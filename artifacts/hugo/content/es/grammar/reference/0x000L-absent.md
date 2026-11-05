---
title: "ABSENT (0x000L)"
weight: 0
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "ABSENT", "UNKNOWN-VALUE", "NO-VALUE"]
summary: "ABSENT es el marcador de posición que significa «no escrito»."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ABSENT es el [marcador de posición](../slot-marker.md) que significa «no escrito». Habla del documento: esta posición no se rellenó. No afirma nada sobre el mundo.

| Elemento | Valor |
|---|---|
| Nombre | `ABSENT` (BIND `ABSENT` del documento de especificación) |
| TAG ID | `0x000L` |
| Codec ID | `0x00000000` |
| Documento de especificación | `0x00000000/codecs/0x00000000/` (destino de DECLARE `0000`) |
| Sección | 0 `0000` (entidad Reference), desplazamiento dentro de la sección C = 0 |
| Kind | Reference · clasificación: marcador de posición |
| TAG WORD | `0000 0000 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | No escrito. Se omitió un campo opcional. No afirma nada sobre el mundo |
| Lado Hugo | `reference/slot-marker.md` |

## Layout {#레이아웃}

```
TAG WORD          0000 0000 0000 0000      WORD 0x0000, 1 WORD
```

- No hay Payload. Tampoco ID de destino ni Quantifier ([marcador de posición](../slot-marker.md#레이아웃)).
- En `0x000L`, la forma con Payload (L ≥ 1) es Reserved.
- Notación de texto de `geul show` y `geul add`: `ABSENT`.

## Significado {#뜻}

| Elemento | No escrito |
|---|---|
| Sobre qué habla | **Documento**: esta posición no se rellenó |
| Lógica | No afirma nada |
| Supuesto de mundo | Mundo abierto (sin información) |
| Wikidata | No existe el snak correspondiente |

## Aceptación {#수용}

- Solo lo aceptan los campos que tienen el destino CODEC `0000`. Ese campo es un **campo opcional**. Al omitir un campo opcional se escribe en su posición un único WORD `0x0000`. Un campo opcional también ocupa siempre su posición ([Documento de especificación de Codec](../codec-spec.md#선택-필드와-자리-표지)). Ejemplos: Origin de [SOURCE](../edge/0x0C0L-source.md); unidad, límite inferior y límite superior de [QUANTITY](../value/0x066L-quantity.md).
- No se puede usar en comodines, en campos sin CODEC, en posiciones de registro de HEAD·BODY, en posiciones de Edge Id ni en campos de valor en bruto (regla común de [marcador de posición](../slot-marker.md#수용-규칙)).

## Obligaciones del lector {#읽는-쪽의-의무}

- **ABSENT no dice nada sobre el mundo.** No se lee como UNKNOWN-VALUE ni como NO-VALUE.
- Está prohibido que un conversor escriba como UNKNOWN-VALUE un valor que no pudo trasladar (un valor que sí existe en la fuente), porque la fuente conoce el valor. Una posición sobre la que la fuente no dice nada (por ejemplo, el Origin de un [SOURCE](../edge/0x0C0L-source.md) cuya fuente no está descrita) también la escribe el conversor como ABSENT.
- En el grafo de veredictos, para ABSENT y para la ausencia de enunciado todos los operadores de comparación dan indeterminado (U). Para leer ABSENT como empty, la entrada debe declarar un mundo cerrado ([TOULMIN](../toulmin/_index.md#미상-위에서-판정하기)).

## Ejemplo {#예시}

`0x0000`, 1 WORD. Ejemplo: la posición de la unidad en un QUANTITY cuya unidad no se escribe.

## Documento de Codec {#코덱-문서}

El documento de Codec contiene un único DECLARE (destino `0000`). Al no haber Payload, no hay FIELD. El decodificador incorpora el significado del marcador y sus reglas de aceptación ([capa 0](../publishing.md#층)). Para leer el marcador no se consulta ningún documento de Codec.

## Páginas relacionadas {#관련-페이지}

- [Marcador de posición](../slot-marker.md), [UNKNOWN-VALUE](0x001L-unknown-value.md), [NO-VALUE](0x002L-no-value.md)
- [CODEC](../edge/0x0BEL-codec.md), [Documento de especificación de Codec](../codec-spec.md), [TRIPLE](../edge/0x0AAL-triple.md), [QUALIFIER](../edge/0x0ABL-qualifier.md)

## Texto original del documento de especificación {#규격-문서-원문}

Así se ve el documento de especificación `0x00000000/codecs/0x00000000/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000000000000000
BODY
#1 DECLARE 0x0000
#2 BIND #1 "ABSENT"
```
