---
title: "UNKNOWN-VALUE (0x001L)"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "ABSENT", "UNKNOWN-VALUE", "NO-VALUE"]
summary: "UNKNOWN-VALUE es el marcador de posición que significa «desconocido»."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UNKNOWN-VALUE es el [marcador de posición](../slot-marker.md) que significa «desconocido». Es una afirmación sobre el mundo: hay un valor, pero se ignora cuál.

| Elemento | Valor |
|---|---|
| Nombre | `UNKNOWN-VALUE` (BIND `UNKNOWN-VALUE` del documento de especificación) |
| TAG ID | `0x001L` |
| Codec ID | `0x00000010` |
| Documento de especificación | `0x00000000/codecs/0x00000010/` (destino de DECLARE `0010`) |
| Sección | 0 `0000` (entidad Reference), desplazamiento dentro de la sección C = 1 |
| Kind | Reference · clasificación: marcador de posición |
| TAG WORD | `0000 0000 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Desconocido. Hay un valor, pero se ignora cuál (`somevalue` de Wikidata) |
| Lado Hugo | `reference/slot-marker.md` |

## Layout {#레이아웃}

```
TAG WORD          0000 0000 0001 0000      WORD 0x0010, 1 WORD
```

- No hay Payload. Tampoco ID de destino ni Quantifier ([marcador de posición](../slot-marker.md#레이아웃)).
- En `0x001L`, la forma con Payload (L ≥ 1) es Reserved.
- Notación de texto de `geul show` y `geul add`: `UNKNOWN`.

## Significado {#뜻}

| Elemento | Desconocido |
|---|---|
| Sobre qué habla | **Mundo**: hay un valor. Se ignora cuál |
| Lógica | `∃x. P(s, x)`, x no identificado |
| Supuesto de mundo | Existencia cerrada, identidad abierta |
| Wikidata | `somevalue` |

## Aceptación {#수용}

- Solo lo aceptan los campos que tienen el destino CODEC `0010`. Ese campo acepta la afirmación «desconocido». Ejemplos: Object de [TRIPLE](../edge/0x0AAL-triple.md), Value de [QUALIFIER](../edge/0x0ABL-qualifier.md), Origin de [SOURCE](../edge/0x0C0L-source.md).
- No se puede usar en comodines, en campos sin CODEC, en posiciones de registro de HEAD·BODY, en posiciones de Edge Id ni en campos de valor en bruto (regla común de [marcador de posición](../slot-marker.md#수용-규칙)).

## Obligaciones del lector {#읽는-쪽의-의무}

- **UNKNOWN-VALUE no es un valor sino una afirmación de existencia.** No es igual ni distinto de ningún otro valor (el resultado de la comparación es indeterminado). Tampoco se consideran el mismo valor dos UNKNOWN-VALUE entre sí. Cada aparición es una cuantificación existencial independiente (igual que un nodo en blanco de Wikidata).
- Por eso dos TRIPLE con los mismos bytes (`P40 Q… UNKNOWN` ×2) no son un duplicado: puede haber dos hijos o uno solo. Un TRIPLE que contiene UNKNOWN-VALUE no se fusiona como duplicado.
- Cuando más tarde se descubre la identidad, se publica una nueva versión de ese TRIPLE corregido. A UNKNOWN-VALUE no se le puede apuntar. Si se necesita correferencia, se usa una Variable LOCAL (Variable en [Reference](_index.md#quantifier)).
- **El rank se aplica igual.** Al elegir el valor representativo (truthy), el TRIPLE con UNKNOWN-VALUE también es candidato.
- **Cuando se usa como valor de QUALIFIER, cambia el sentido de esa calificación.** Si `P582 = UNKNOWN`, terminó y se ignora el momento. No se lee como una proposición todavía vigente.
- UNKNOWN-VALUE es la afirmación «existe», así que se usa solo cuando la fuente lo dice así. Un valor que no se pudo trasladar no se escribe como UNKNOWN-VALUE.

## Ejemplo {#예시}

`0x0010`, 1 WORD. Ejemplo: se ignora el momento de fin (P582) de la frontera Q30–Q34266: `0AB7 0051 0C58 0191 0246 0051 080C 0010` (QUALIFIER, la posición de Value es `0010`).

## Documento de Codec {#코덱-문서}

El documento de Codec contiene un único DECLARE (destino `0010`). Al no haber Payload, no hay FIELD. El decodificador incorpora el significado del marcador y sus reglas de aceptación ([capa 0](../publishing.md#층)). Para leer el marcador no se consulta ningún documento de Codec.

## Páginas relacionadas {#관련-페이지}

- [Marcador de posición](../slot-marker.md), [ABSENT](0x000L-absent.md), [NO-VALUE](0x002L-no-value.md)
- [CODEC](../edge/0x0BEL-codec.md), [Documento de especificación de Codec](../codec-spec.md), [TRIPLE](../edge/0x0AAL-triple.md), [QUALIFIER](../edge/0x0ABL-qualifier.md)

## Texto original del documento de especificación {#규격-문서-원문}

Así se ve el documento de especificación `0x00000000/codecs/0x00000010/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000001000000000
BODY
#1 DECLARE 0x0010
#2 BIND #1 "UNKNOWN-VALUE"
```
