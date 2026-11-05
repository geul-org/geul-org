---
title: "Marcador de posición"
weight: 80
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "ABSENT", "UNKNOWN-VALUE", "NO-VALUE"]
summary: "El marcador de posición (slot marker) es un registro de 1 WORD que ocupa la posición de un campo de registro."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

El marcador de posición (slot marker) es un registro de 1 WORD que ocupa la posición de un campo de registro. No señala nada. Son códigos asignados a las tres primeras casillas `0x000L~0x002L` de la sección 0 de Reference. Cada marcador tiene su página: [ABSENT](reference/0x000L-absent.md), [UNKNOWN-VALUE](reference/0x001L-unknown-value.md), [NO-VALUE](reference/0x002L-no-value.md).

En la posición de un valor caben tres afirmaciones: no se ha escrito el valor, hay un valor pero no se sabe cuál, y no hay valor. Son cosas distintas. El marcador de posición las reparte en tres WORD contiguos.

## Layout {#레이아웃}

```
TAG WORD          0000 0000 00CC 0000
                  Prefix 000, sección 0 (Reference), Codec 0~2, LLLL 0000 (1 WORD)
```

| WORD | Nombre | Significado | Notación |
|---|---|---|---|
| `0x0000` | [ABSENT](reference/0x000L-absent.md) | No escrito | `ABSENT` |
| `0x0010` | [UNKNOWN-VALUE](reference/0x001L-unknown-value.md) | Desconocido: hay un valor. No se sabe cuál | `UNKNOWN` |
| `0x0020` | [NO-VALUE](reference/0x002L-no-value.md) | Sin valor: no hay valor | `NONE` |
| Codec 0~2, LLLL ≥ `0001` | Reserved | Esta forma de TAG (marcador con Payload) no se ha asignado | |

- Los marcadores **no tienen Quantifier.** La cuantificación solo se lee en el sistema 5Q (`5 <= C < 30` de la sección 0, `C < 30` de la sección 1). `0x0010` UNKNOWN-VALUE no se lee como `C % 5` para interpretarlo como Generic ([Reference](reference/_index.md) Quantifier).
- No tienen Payload. Tampoco ID de objeto.
- Un decodificador sin codebook sabe, solo con el TAG WORD, que es Kind Reference y de 1 WORD, y lo salta. «Si el valor del WORD es `0x0000`, `0x0010` o `0x0020`, es un marcador de posición» se sabe con `w & 0xF == 0 && w <= 0x0020`.
- Las notaciones `ABSENT`, `UNKNOWN` y `NONE` son la notación de texto de `geul show` y `geul add`.

## Tres distinciones {#세-가지-구분}

| | No escrito (ABSENT) | Desconocido (UNKNOWN-VALUE) | Sin valor (NO-VALUE) |
|---|---|---|---|
| Sobre qué habla | **Documento**: esta posición no se ha rellenado | **Mundo**: hay un valor. No se sabe cuál | **Mundo**: no hay valor |
| Lógica | No afirma nada | `∃x. P(s, x)`, x no está identificado | `¬∃x. P(s, x)` |
| Supuesto de mundo | Mundo abierto (sin información) | La existencia está cerrada, la identidad abierta | Mundo cerrado respecto a (s, P, condición de restricción) |
| Wikidata | No hay ese snak | `somevalue` | `novalue` |
| Dónde se usa | Campo opcional con destino CODEC `0000` (SOURCE Origin, etc.) | Campo con destino CODEC `0010` (TRIPLE Object, QUALIFIER Value, SOURCE Origin) | Campo con destino CODEC `0020` (TRIPLE Object, QUALIFIER Value) |
| «¿Cuántos hijos (P40)?» | No se sabe | Uno o más | 0 |
| «¿Hay instante de finalización (P582)?» | No se sabe → no se sabe si sigue vigente | Terminó. No se sabe cuándo | No ha terminado (aserción) |

La misma distinción rige también en el plano de las proposiciones. **Que un TRIPLE no esté en el documento** es «no escrito». Como un documento GEUL es de mundo abierto, que no haya un enunciado no significa que el hecho no exista. «No hay» solo se puede decir **escribiéndolo** con NO-VALUE.

## Regla de aceptación {#수용-규칙}

- Un marcador de posición solo es válido si la lista de [CODEC](edge/0x0BEL-codec.md) del campo tiene **el mismo WORD como destino exacto**. El destino `0000` significa «campo opcional», `0010` «admite desconocido» y `0020` «admite sin valor».
- Los comodines (`000F`, `060F`, etc., `L=1111`) no aceptan marcadores. Tampoco «cualquier Reference» (`000F`·`020F`·`040F`) se solapa con los marcadores.
- Los campos de registro sin CODEC («cualquier registro») tampoco aceptan marcadores.
- Un marcador en las posiciones de registro de HEAD y BODY o en la posición de Edge Id es invalid.
- En un campo de valor en bruto no se puede usar un marcador. Un valor en bruto no tiene TAG, así que no hay lugar para un marcador de 1 WORD.
- Una lista de CODEC que solo tenga destinos de marcador (siempre marcador) es invalid.
- El significado del marcador (qué hay y qué no hay) lo fija la especificación del Edge que lo recibe. Coincide con el principio de que la cuantificación y la negación las fija el Edge, no el Reference.
- El significado y la regla de aceptación de los marcadores pertenecen a la [capa 0](publishing.md#층) (integrada en el decodificador). Los tres carecen de Payload, así que tampoco cuesta integrarlos. Aun así, cada código tiene su documento de Codec. Ese documento de Codec solo contiene DECLARE y ningún FIELD.

## Obligaciones de quien lee {#읽는-쪽의-의무}

Se anotan en la página de cada marcador. En resumen:

- [UNKNOWN-VALUE](reference/0x001L-unknown-value.md#읽는-쪽의-의무) no es un valor, sino una aserción de existencia. No es igual ni distinto a ningún valor, y sus TRIPLE no se fusionan como duplicados.
- [NO-VALUE](reference/0x002L-no-value.md#읽는-쪽의-의무) se cierra dentro de la condición de restricción de esa proposición.
- En ambos marcadores el rank se aplica igual, y si se usan como valor de QUALIFIER, cambian el sentido de esa restricción.
- [ABSENT](reference/0x000L-absent.md#읽는-쪽의-의무) no dice nada sobre el mundo. Un valor que no se pudo trasladar no se escribe como UNKNOWN-VALUE.

## Diferencia con otros «sin valor» {#다른-없음과의-차이}

- La regla de Codec que usa [LOCAL](reference/0x005L-local.md) `0` como «sin valor» ([TOULMIN](toulmin/_index.md) REF, etc.) es un convenio dentro de ese Codec. Es distinta de los marcadores de posición.
- Identified LOCAL no se usa como null ni como sentinel. Para anotar lo desconocido o ausente, se pone un marcador en un campo que acepte marcadores.

## Ejemplo {#예시}

Frontera entre Q30 (Estados Unidos) y Q34266 (Imperio ruso), instante de finalización desconocido. Los Edge Id son ilustrativos.

```
0AA9 0051 080C 0191 002F 0141 001E 0141 85DA 0000      #2060 TRIPLE P47 Q30 Q34266 normal
0AB7 0051 0C58 0191 0246 0051 080C 0010                #3160 QUALIFIER P582 #2060 UNKNOWN
```

Banco central de Q30: no existió entre 1811 y 1816.

```
0AA8 0051 0C59 0191 0518 0141 001E 0020 0000           #3161 TRIPLE P1304 Q30 NONE normal
0AB9 0051 0C5A 0191 0244 0051 0C59 06E2 3138 3131      #3162 QUALIFIER P580 #3161 EDTF("1811")
0AB9 0051 0C5B 0191 0246 0051 0C59 06E2 3138 3136      #3163 QUALIFIER P582 #3161 EDTF("1816")
```

- La posición del marcador es de 1 WORD. El TRIPLE queda en 9 WORD (`0AA8`) y el QUALIFIER en 8 WORD (`0AB7`).
- En su forma más simple, «sin hijos (P40)» es `0AA8 0051 <Edge Id> 0191 0028 <Subject> 0020 0000`.

## Páginas relacionadas {#관련-페이지}

- [ABSENT](reference/0x000L-absent.md), [UNKNOWN-VALUE](reference/0x001L-unknown-value.md), [NO-VALUE](reference/0x002L-no-value.md)
- [Reference](reference/_index.md), [CODEC](edge/0x0BEL-codec.md), [documento de especificación de Codec](codec-spec.md)
- [TRIPLE](edge/0x0AAL-triple.md), [QUALIFIER](edge/0x0ABL-qualifier.md), [TOULMIN](toulmin/_index.md)
