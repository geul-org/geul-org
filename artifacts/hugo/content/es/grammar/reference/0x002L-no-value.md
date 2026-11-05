---
title: "NO-VALUE (0x002L)"
weight: 2
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "ABSENT", "UNKNOWN-VALUE", "NO-VALUE"]
summary: "NO-VALUE es el marcador de posición que significa «ninguno»."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

NO-VALUE es el [marcador de posición](../slot-marker.md) que significa «ninguno». Es una afirmación sobre el mundo: no hay valor.

| Elemento | Valor |
|---|---|
| Nombre | `NO-VALUE` (BIND `NO-VALUE` del documento de especificación) |
| TAG ID | `0x002L` |
| Codec ID | `0x00000020` |
| Documento de especificación | `0x00000000/codecs/0x00000020/` (destino de DECLARE `0020`) |
| Sección | 0 `0000` (entidad Reference), desplazamiento dentro de la sección C = 2 |
| Kind | Reference · clasificación: marcador de posición |
| TAG WORD | `0000 0000 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Ninguno. No hay valor (`novalue` de Wikidata) |
| Lado Hugo | `reference/slot-marker.md` |

## Layout {#레이아웃}

```
TAG WORD          0000 0000 0010 0000      WORD 0x0020, 1 WORD
```

- No hay Payload. Tampoco ID de destino ni Quantifier ([marcador de posición](../slot-marker.md#레이아웃)).
- En `0x002L`, la forma con Payload (L ≥ 1) es Reserved.
- Notación de texto de `geul show` y `geul add`: `NONE`.

## Significado {#뜻}

| Elemento | Ninguno |
|---|---|
| Sobre qué habla | **Mundo**: no hay valor |
| Lógica | `¬∃x. P(s, x)` |
| Supuesto de mundo | Mundo cerrado para (s, P, condiciones que acotan) |
| Wikidata | `novalue` |

## Aceptación {#수용}

- Solo lo aceptan los campos que tienen el destino CODEC `0020`. Ese campo acepta la afirmación «ninguno». Ejemplos: Object de [TRIPLE](../edge/0x0AAL-triple.md), Value de [QUALIFIER](../edge/0x0ABL-qualifier.md).
- No se puede usar en comodines, en campos sin CODEC, en posiciones de registro de HEAD·BODY, en posiciones de Edge Id ni en campos de valor en bruto (regla común de [marcador de posición](../slot-marker.md#수용-규칙)).

## Obligaciones del lector {#읽는-쪽의-의무}

- **NO-VALUE se cierra dentro de las condiciones que acotan esa proposición.** Si lleva QUALIFIER, se cierra solo en ese ámbito. Q30 P1304 NO-VALUE(P580 1811, P582 1816) significa que solo entre 1811 y 1816 no hubo banco central, y no contradice el TRIPLE de valor de la misma propiedad (Reserva Federal, preferred).
- Si NO-VALUE y un TRIPLE de valor conviven con el mismo Subject·Predicate y el mismo rank, sin que las condiciones que acotan los distingan, hay contradicción. El verificador emite una advertencia. No lo rechaza. Es un estado que también existe en Wikidata, y quien lee elige por rank.
- **El rank se aplica igual.** Al elegir el valor representativo (truthy), el TRIPLE con NO-VALUE también es candidato.
- **Cuando se usa como valor de QUALIFIER, cambia el sentido de esa calificación.** Si `P582 = NONE`, se afirma que no terminó. Si no hay ningún QUALIFIER P582, no se sabe si terminó.
- «No hay» solo se puede decir **escribiéndolo** como NO-VALUE. Que el TRIPLE no esté en el documento es «no escrito» (mundo abierto).

## Ejemplo {#예시}

`0x0020`, 1 WORD. Ejemplo: «sin hijos (P40)» es `0AA8 0051 <Edge Id> 0191 0028 <Subject> 0020 0000` (TRIPLE, la posición de Object es `0020`).

## Documento de Codec {#코덱-문서}

El documento de Codec contiene un único DECLARE (destino `0020`). Al no haber Payload, no hay FIELD. El decodificador incorpora el significado del marcador y sus reglas de aceptación ([capa 0](../publishing.md#층)). Para leer el marcador no se consulta ningún documento de Codec.

## Páginas relacionadas {#관련-페이지}

- [Marcador de posición](../slot-marker.md), [ABSENT](0x000L-absent.md), [UNKNOWN-VALUE](0x001L-unknown-value.md)
- [CODEC](../edge/0x0BEL-codec.md), [Documento de especificación de Codec](../codec-spec.md), [TRIPLE](../edge/0x0AAL-triple.md), [QUALIFIER](../edge/0x0ABL-qualifier.md)

## Texto original del documento de especificación {#규격-문서-원문}

Así se ve el documento de especificación `0x00000000/codecs/0x00000020/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000002000000000
BODY
#1 DECLARE 0x0020
#2 BIND #1 "NO-VALUE"
```
