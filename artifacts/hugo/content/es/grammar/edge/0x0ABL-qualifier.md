---
title: "QUALIFIER (0x0ABL)"
weight: 171
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "QUALIFIER es un Edge de enunciado que añade una condición que califica la proposición contenida en otro Edge (principalmente un TRIPLE)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `QUALIFIER` (BIND del documento de especificación `QUALIFIER`) |
| TAG ID | `0x0ABL` |
| Codec ID | `0x00000AB0` |
| Documento de especificación | `0x00000000/codecs/0x00000AB0/` (destino de DECLARE `0AB0`) |
| Sección | 5 `0101` (enunciado de Edge), desplazamiento dentro de la sección C = 11 |
| Kind | Edge · familia: enunciado, grupo: proposición |
| TAG WORD | `0000 1010 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Una condición que califica la proposición de otro Edge. Property, Target (Edge Id), Value (valor o marcador UNKNOWN-VALUE·NO-VALUE). Es parte de la proposición |
| Lado Hugo | `edge/qualifier.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)). El Edge Id de un Edge no se declara con FIELD.

| Orden | Campo (BIND) | FIELD | Ancho | Formato que acepta (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `property` | #2 | registro | cualquier registro (excepto marcadores de posición) |  |
| 2 | `target` | #3 | registro | `0050` LOCAL |  |
| 3 | `value` | #4 | registro | `000F` toda la sección 0 (comodín, Reference), `020F` toda la sección 1 (comodín, Reference), `040F` toda la sección 2 (comodín, Reference), `060F` toda la sección 3 (comodín, Value), `080F` toda la sección 4 (comodín, Value), `0010` UNKNOWN-VALUE, `0020` NO-VALUE |  |

QUALIFIER es un Edge de enunciado que añade una condición que califica la proposición contenida en otro Edge (principalmente un [TRIPLE](0x0AAL-triple.md)). Codec `0x0ABL`.

Es igual a un qualifier (snak) de Wikidata: una propiedad y un valor.

## Layout {#레이아웃}

```
TAG WORD          0000 1010 1011 LLLL
[TAG de extensión de Length]
Edge Id           registro Reference LOCAL
Property          registro Reference (WIKIDATA-PID, etc.)
Target            registro Reference LOCAL (Edge Id del Edge que se califica)
Value             registro Reference o Value, o marcador de posición 0x0010 UNKNOWN-VALUE·0x0020 NO-VALUE
```

- El orden de los componentes es igual que el de TRIPLE (Property ↔ Predicate, Target ↔ Subject, Value ↔ Object). El decodificador lee por el mismo camino. Los papeles los fija el Codec.

## Interpretación y validez {#해석과-유효성}

- Property y Target son exactamente un registro Reference completo, y Target es una Reference LOCAL. El documento de especificación de geul.org pone en Target el [CODEC](0x0BEL-codec.md) LOCAL (`0050`). Value es exactamente un registro Reference o Value completo, o 1 WORD del [marcador de posición](../slot-marker.md) `0x0010` (UNKNOWN-VALUE) o `0x0020` (NO-VALUE). El documento de especificación pone en Value los CODEC `000F`, `020F`, `040F` (cualquier Reference), `060F`, `080F` (cualquier Value), `0010` y `0020`. ABSENT (`0x0000`) no se acepta. Property y Target no aceptan marcadores de posición. El cursor tras leer Value debe coincidir con el final del Edge.
- Target es un Edge Id dentro del mismo documento. El QUALIFIER se pone en el mismo documento que el Edge que califica.
- Si Target es el [SOURCE](0x0C0L-source.md#문서-전체의-출처) de HEAD (el origen de todo el documento), el QUALIFIER también va en HEAD, después de ese SOURCE. Los demás QUALIFIER van en BODY. Si hay en BODY un QUALIFIER que tiene como Target el SOURCE de HEAD, es invalid.
- Target puede ser otro Edge además de un TRIPLE. Un QUALIFIER añadido a [SOURCE](0x0C0L-source.md) califica el acto de cita (fecha de consulta, ubicación dentro del origen, etc.). El significado de SOURCE también es todo lo reunido por los QUALIFIER que lo señalan.
- **QUALIFIER es parte de la proposición.** No es una afirmación aparte sobre la proposición, sino que califica las condiciones en que la proposición es verdadera. El significado del TRIPLE destino es todo lo reunido por los QUALIFIER que lo señalan.
  - La procedencia de la proposición se escribe como [SOURCE](0x0C0L-source.md). Las propiedades del nodo de origen (título, autor, etc.) se escriben como TRIPLE con el origen como Subject.
- Para el mismo Target puede haber varios QUALIFIER con la misma Property. El orden de los QUALIFIER con el mismo Target es el orden dentro del documento (una excepción en que el orden de los Edge tiene significado).

## Desconocido y ausente {#알-수-없음과-없음}

Si el Value de un QUALIFIER es un marcador de posición, cambia el sentido de esa calificación. Tomemos como ejemplo el momento de fin (P582).

| Lo añadido al TRIPLE destino | Significado | ¿La proposición sigue vigente? |
|---|---|---|
| `QUALIFIER P582 #n EDTF("1974")` | Terminó en 1974 | No |
| `QUALIFIER P582 #n UNKNOWN` | Terminó. No se sabe cuándo (`somevalue` de Wikidata) | No |
| `QUALIFIER P582 #n NONE` | Se asevera que no ha terminado (`novalue` de Wikidata) | Sí |
| sin QUALIFIER P582 | No se sabe si terminó (mundo abierto) | No se sabe |

- Si se descartan los `somevalue`·`novalue` de los qualifier de Wikidata, la proposición se ensancha. Un TRIPLE de frontera del que se descartó el somevalue del momento de fin se lee como «frontera aún vigente». Por eso, al trasladar, se trasladan como marcadores.
- Dos UNKNOWN-VALUE no se consideran el mismo valor. El resultado de la comparación es indeterminado.

## Ejemplo (no normativo) {#예시-비규범}

Q42 P69 (educated at) Q691283 (St John's College), 1971~1974.

```
TRIPLE     #9   P69   Q42  Q691283  rank 0
QUALIFIER  #10  P580  #9   EDTF "1971"
QUALIFIER  #11  P582  #9   EDTF "1974"
```

- `#10`: TAG 1 + Edge Id 2 + Property 2 + Target 2 + Value 3 = 10 WORD. Value es el [EDTF](../value/0x06EL-edtf.md) `"1971"`.

```
0AB9 0051 000A 0191 0244 0051 0009 06E2 3139 3731
```

Frontera (P47) entre Q30 (Estados Unidos) y Q34266 (Imperio ruso), con momento de fin desconocido. Edge Id `2060`·`3160`.

```
0AA9 0051 080C 0191 002F 0141 001E 0141 85DA 0000      #2060 TRIPLE P47 Q30 Q34266 normal
0AB7 0051 0C58 0191 0246 0051 080C 0010                #3160 QUALIFIER P582 #2060 UNKNOWN
```

- `0AB7` = `000 0101 01011 0111` (sección 5): Edge, Codec `0x0ABL`, 8 WORD. TAG 1 + Edge Id 2 + Property P582 (`0191 0246`) 2 + Target #2060 (`0051 080C`) 2 + marcador 1.

Se añade el período al TRIPLE NO-VALUE de banco central (P1304) de Q30, `#3161`. Solo faltó entre 1811 y 1816.

```
0AA8 0051 0C59 0191 0518 0141 001E 0020 0000           #3161 TRIPLE P1304 Q30 NONE normal
0AB9 0051 0C5A 0191 0244 0051 0C59 06E2 3138 3131      #3162 QUALIFIER P580 #3161 EDTF("1811")
0AB9 0051 0C5B 0191 0246 0051 0C59 06E2 3138 3136      #3163 QUALIFIER P582 #3161 EDTF("1816")
```

## Páginas relacionadas {#관련-페이지}

- [Edge](_index.md), [TRIPLE](0x0AAL-triple.md), [SOURCE](0x0C0L-source.md), [WIKIDATA-PID](../reference/0x019L-wikidata-pid.md), [EDTF](../value/0x06EL-edtf.md), [marcador de posición](../slot-marker.md)

## Texto original del documento de especificación {#규격-문서-원문}

Así se ve el documento de especificación `0x00000000/codecs/0x00000AB0/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000AB000000000
BODY
#1 DECLARE 0x0AB0
#2 FIELD #1 record
#3 FIELD #1 record
#4 FIELD #1 record
#5 BIND #1 "QUALIFIER"
#6 BIND #2 "property"
#7 BIND #3 "target"
#8 BIND #4 "value"
#9 CODEC #3 0x0050
#10 CODEC #4 0x000F
#14 CODEC #4 0x020F
#15 CODEC #4 0x040F
#11 CODEC #4 0x060F
#16 CODEC #4 0x080F
#12 CODEC #4 0x0010
#13 CODEC #4 0x0020
```
