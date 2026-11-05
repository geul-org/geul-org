---
title: "VERDICT (0x1E9L)"
weight: 489
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "Indica el resultado del veredicto de todo el documento."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `VERDICT` (BIND del documento de especificación `VERDICT`) |
| TAG ID | `0x1E9L` |
| Codec ID | `0x00001E90` |
| Documento de especificación | `0x00000000/codecs/0x00001E90/` (destino de DECLARE `1E90`) |
| Sección | 15 `1111` (Meta), desplazamiento C dentro de la sección = 9 |
| Kind | Meta · clase: verificación |
| TAG WORD | `0001 1110 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Resultado del veredicto de todo el documento. Pass, Review, Fail. A nivel de nodo o registro, `VERDICT` de [TOULMIN](../toulmin/_index.md) (Edge `0x118L`) |
| Lado Hugo | `meta/verification/verdict.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato receptor (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `verdict` | #2 | valor en bruto, 1 WORD |  | `0x0000` pass, `0x0001` review, `0x0002` fail |

Indica el resultado del veredicto de todo el documento. El veredicto a nivel de nodo o registro lo asume `VERDICT` de [TOULMIN](../toulmin/_index.md) (Edge `0x118L`).

## Layout {#레이아웃}

```
TAG WORD          0001 1110 1001 LLLL      Codec 0x1E9L
[TAG de extensión de Length]
Veredicto         1 WORD (0 Pass, 1 Review, 2 Fail)
```

- Codec: Meta `0x1E9L`, clase de verificación
- Payload: valor en bruto (veredicto de 1 WORD)
- Cantidad: como máximo uno

## Interpretación y validez {#해석과-유효성}

- Por ser de la clase de verificación, queda fuera del hash de contenido.
- El veredicto sobre otro documento se pone en el BODY de un documento distinto del documento juzgado.

## Problemas abiertos {#열린-문제}

- Si se anotan también el sujeto del veredicto y su fundamento.

## Texto original del documento de especificación {#규격-문서-원문}

Es el documento de especificación `0x00000000/codecs/0x00001E90/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E9000000000
BODY
#1 DECLARE 0x1E90
#2 FIELD #1 0x0001
#3 ENUM #2 0x0000
#4 ENUM #2 0x0001
#5 ENUM #2 0x0002
#6 BIND #1 "VERDICT"
#7 BIND #2 "verdict"
#8 BIND #3 "pass"
#9 BIND #4 "review"
#10 BIND #5 "fail"
```
