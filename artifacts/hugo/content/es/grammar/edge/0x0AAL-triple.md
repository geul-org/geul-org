---
title: "TRIPLE (0x0AAL)"
weight: 170
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "TRIPLE es un Edge de enunciado que contiene una proposición (Predicate, Subject, Object) y su grado (rank)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `TRIPLE` (BIND del documento de especificación `TRIPLE`) |
| TAG ID | `0x0AAL` |
| Codec ID | `0x00000AA0` |
| Documento de especificación | `0x00000000/codecs/0x00000AA0/` (destino de DECLARE `0AA0`) |
| Sección | 5 `0101` (enunciado de Edge), desplazamiento dentro de la sección C = 10 |
| Kind | Edge · familia: enunciado, grupo: proposición |
| TAG WORD | `0000 1010 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Proposición en el orden Predicate, Subject, Object y rank. Object es un valor o un marcador UNKNOWN-VALUE·NO-VALUE. Su significado es todo lo reunido por los QUALIFIER que señalan su Edge Id |
| Lado Hugo | `edge/triple.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)). El Edge Id de un Edge no se declara con FIELD.

| Orden | Campo (BIND) | FIELD | Ancho | Formato que acepta (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `predicate` | #2 | registro | `000F` toda la sección 0 (comodín, Reference), `020F` toda la sección 1 (comodín, Reference), `040F` toda la sección 2 (comodín, Reference) |  |
| 2 | `subject` | #3 | registro | `000F` toda la sección 0 (comodín, Reference), `020F` toda la sección 1 (comodín, Reference), `040F` toda la sección 2 (comodín, Reference) |  |
| 3 | `object` | #4 | registro | `000F` toda la sección 0 (comodín, Reference), `020F` toda la sección 1 (comodín, Reference), `040F` toda la sección 2 (comodín, Reference), `060F` toda la sección 3 (comodín, Value), `080F` toda la sección 4 (comodín, Value), `0010` UNKNOWN-VALUE, `0020` NO-VALUE |  |
| 4 | `rank` | #5 | valor en bruto 1 WORD | `0620` UNSIGNED-INTEGER | `0x0000` normal, `0x0001` preferred, `0x0002` deprecated |

TRIPLE es un Edge de enunciado que contiene una proposición (Predicate, Subject, Object) y su grado (rank). Codec `0x0AAL`.

Las condiciones que califican la proposición (momento de inicio y fin, ámbito de aplicación, etc.) se añaden con un [QUALIFIER](0x0ABL-qualifier.md) que señala el Edge Id del TRIPLE. La procedencia (las references de Wikidata) se añade con el Edge de fundamento [SOURCE](0x0C0L-source.md) que señala el Edge Id del TRIPLE.

## Layout {#레이아웃}

```
TAG WORD          0000 1010 1010 LLLL
[TAG de extensión de Length]
Edge Id           registro Reference LOCAL
Predicate         registro Reference (WIKIDATA-PID, etc.)
Subject           registro Reference
Object            registro Reference o Value, o marcador de posición 0x0010 UNKNOWN-VALUE·0x0020 NO-VALUE
Rank              1 WORD (ENUM)
```

## Rank {#rank}

| Código | Nombre | Significado |
|---|---|---|
| `0` | normal | Por defecto |
| `1` | preferred | Valor actual, el más autorizado |
| `2` | deprecated | Valor juzgado erróneo u obsoleto pero conservado como registro |

- Es igual al statement rank de Wikidata. El valor representativo (truthy de Wikidata) es, entre los del mismo Subject y Predicate, el preferred si lo hay y, si no, el normal.
- Las fuentes que no asignan rank usan `0` (normal).
- Cualquier otro código es invalid.

## Interpretación y validez {#해석과-유효성}

- Predicate y Subject son exactamente un registro Reference completo.
- Object es exactamente un registro Reference o Value completo, o 1 WORD del [marcador de posición](../slot-marker.md) `0x0010` (UNKNOWN-VALUE) o `0x0020` (NO-VALUE). ABSENT (`0x0000`) no se acepta. Object no es un campo opcional.
- Tras leer Object debe quedar exactamente 1 WORD (Rank).
- El documento de especificación de geul.org pone en el campo de valor en bruto Rank el [CODEC](0x0BEL-codec.md) UNSIGNED-INTEGER (`0620`) y el [ENUM](0x0BDL-enum.md) 0·1·2. En el campo Object pone los CODEC `000F`·`020F`·`040F` (cualquier Reference), `060F`·`080F` (cualquier Value), `0010` (UNKNOWN-VALUE) y `0020` (NO-VALUE). En los campos Predicate y Subject pone los CODEC `000F`·`020F`·`040F` (cualquier Reference). Por ser comodines, no aceptan marcadores de posición.
- **El significado de un TRIPLE es todo lo reunido por los QUALIFIER que señalan su Edge Id en el mismo documento.** Quien lee reúne los QUALIFIER antes de interpretar el TRIPLE. Un TRIPLE leído sin QUALIFIER puede ser una proposición sin su calificación (por ejemplo, «jefe de gobierno» sin la calificación temporal).

## Desconocido y ausente {#알-수-없음과-없음}

El marcador de posición en el lugar de Object no es un valor sino una aserción sobre la proposición.

| Object | Significado | Lógica |
|---|---|---|
| valor v | Uno de los valores de Predicate de Subject es v | `P(s, v)` |
| UNKNOWN-VALUE (`0x0010`) | Hay un valor. No se sabe cuál (`somevalue` de Wikidata) | `∃x. P(s, x)` |
| NO-VALUE (`0x0020`) | No hay valor (`novalue` de Wikidata) | `¬∃x. P(s, x)` |
| sin TRIPLE | No se asevera nada (mundo abierto) | |

- **Se lee dentro de las condiciones de calificación.** El ámbito de `∃` y `¬∃` lo fijan los QUALIFIER que señalan ese TRIPLE. Si se añade un QUALIFIER, solo se cierra en ese ámbito. «Entre 1811 y 1816 no hubo banco central» se escribe añadiendo QUALIFIER P580·P582 a un TRIPLE NO-VALUE. No contradice los TRIPLE de valor de otros períodos del mismo Predicate.
- **El rank se aplica igual.** Al elegir el valor representativo (truthy), los TRIPLE UNKNOWN-VALUE·NO-VALUE también son candidatos. Si hay preferred, solo queda el preferred.
- **Dos UNKNOWN-VALUE no son iguales entre sí.** UNKNOWN-VALUE no es igual ni distinto a ningún valor (resultado de la comparación indeterminado), y dos UNKNOWN-VALUE tampoco se consideran el mismo valor. Cada aparición es una cuantificación existencial independiente. Por eso dos TRIPLE UNKNOWN-VALUE con los mismos bytes no son un duplicado y no se fusionan (puede haber dos hijos o uno).
- Si para el mismo Subject, Predicate y rank coexisten un TRIPLE NO-VALUE y un TRIPLE de valor (o UNKNOWN-VALUE) sin que las condiciones de calificación se distingan, hay contradicción. El verificador emite una advertencia. No lo rechaza (es un estado que también existe en Wikidata).
- Un valor que no se pudo trasladar (la fuente original sí tiene valor) no se escribe como UNKNOWN-VALUE.

## Ejemplo (no normativo) {#예시-비규범}

Q42 (Douglas Adams) P31 (instance of) Q5 (human), normal. Edge Id `0005`.

- TAG 1 + Edge Id 2 + Predicate 2 + Subject 2 + Object 2 + Rank 1 = 10 WORD, `LLLL=1001`. El TAG es `0000 1010 1010 1001` = `0AA9`.

```
0AA9 0051 0005 0191 001F 0141 002A 0141 0005 0000
```

Q30 (Estados Unidos) P1304 (banco central) NO-VALUE, normal. Entre 1811 y 1816 no hubo banco central (los QUALIFIER P580·P582 están en el ejemplo de [QUALIFIER](0x0ABL-qualifier.md)). Edge Id `3161`.

- TAG 1 + Edge Id 2 + Predicate 2 + Subject 2 + Object 1 + Rank 1 = 9 WORD, `LLLL=1000`. El TAG es `0000 1010 1010 1000` = `0AA8`.

```
0AA8 0051 0C59 0191 0518 0141 001E 0020 0000      #3161 TRIPLE P1304 Q30 NONE normal
```

- «Sin hijos (P40)» es `0AA8 0051 <Edge Id> 0191 0028 <Subject> 0020 0000`.

## Problemas abiertos {#열린-문제}

- scope (contexto de la afirmación: mundo, perspectiva): se fijará cuando surja un uso.
- Forma abreviada que pliega TRIPLE y QUALIFIER en un registro: después de que exista la declaración de campos repetidos (problemas abiertos de [DECLARE](0x0BBL-declare.md)).

## Páginas relacionadas {#관련-페이지}

- [Edge](_index.md), [QUALIFIER](0x0ABL-qualifier.md), [SOURCE](0x0C0L-source.md), [LABEL](0x0A4L-label.md), [ALIAS](0x0A5L-alias.md), [marcador de posición](../slot-marker.md)
- [WIKIDATA-PID](../reference/0x019L-wikidata-pid.md), [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md)

## Texto original del documento de especificación {#규격-문서-원문}

Así se ve el documento de especificación `0x00000000/codecs/0x00000AA0/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000AA000000000
BODY
#1 DECLARE 0x0AA0
#2 FIELD #1 record
#3 FIELD #1 record
#4 FIELD #1 record
#5 FIELD #1 0x0001
#6 ENUM #5 0x0000
#7 ENUM #5 0x0001
#8 ENUM #5 0x0002
#9 BIND #1 "TRIPLE"
#10 BIND #2 "predicate"
#11 BIND #3 "subject"
#12 BIND #4 "object"
#13 BIND #5 "rank"
#14 BIND #6 "normal"
#15 BIND #7 "preferred"
#16 BIND #8 "deprecated"
#17 CODEC #5 0x0620
#18 CODEC #4 0x000F
#22 CODEC #4 0x020F
#23 CODEC #4 0x040F
#19 CODEC #4 0x060F
#24 CODEC #4 0x080F
#20 CODEC #4 0x0010
#21 CODEC #4 0x0020
#25 CODEC #2 0x000F
#26 CODEC #2 0x020F
#27 CODEC #2 0x040F
#28 CODEC #3 0x000F
#29 CODEC #3 0x020F
#30 CODEC #3 0x040F
```
