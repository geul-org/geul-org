---
title: "UTF8-LANGUAGE-TEXT (0x078L·0x079L)"
weight: 120
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "UTF8-LANGUAGE-TEXT es un texto con idioma que contiene en un solo Value un registro de Value de idioma y texto UTF-8 (Codec 0x078L/0x079L)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UTF8-LANGUAGE-TEXT es un texto con idioma que contiene en un solo Value un registro de Value de idioma y texto UTF-8 (Codec 0x078L/0x079L).

| Elemento | Valor |
|---|---|
| Nombre | `UTF8-LANGUAGE-TEXT` (grupo par/impar; el nombre de cada código figura en la tabla de miembros de abajo) |
| TAG ID | `0x078L`·`0x079L` |
| Sección | 3 `0011` (Value), desplazamiento C dentro de la sección = 24~25 |
| Kind | Value · familia: TEXT |
| Descripción del índice | Texto con idioma. Registro de Value de idioma (LANGUAGE-SHORT-CODE o LANGUAGE-BCP47-CODE) y bytes UTF-8. Par o impar según los bytes del texto |
| Lado Hugo | `value/text/utf8-language-text.md` |

## Miembros {#구성원}

Esta página trata conjuntamente dos códigos que forman una pareja par/impar. El código par es el de valores con un número par de bytes y el impar, el de valores con un número impar de bytes ([Registro y TAG WORD](../record.md#가변-길이-바이트열)). Hay un documento de Codec por código. Los campos de ambos documentos son los mismos; solo difieren el destino de DECLARE y el nombre (BIND).

| TAG ID | Nombre | Número de bytes | Codec ID | Documento de especificación | TAG WORD |
|---|---|---|---|---|---|
| `0x078L` | `UTF8-LANGUAGE-TEXT-EVEN` | par | `0x00000780` | `0x00000000/codecs/0x00000780/` | `0000 0111 1000 LLLL` |
| `0x079L` | `UTF8-LANGUAGE-TEXT-ODD` | impar | `0x00000790` | `0x00000000/codecs/0x00000790/` | `0000 0111 1001 LLLL` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato que recibe (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `language` | #2 | registro | `07A0` LANGUAGE-SHORT-CODE, `0760` LANGUAGE-BCP47-CODE-EVEN, `0770` LANGUAGE-BCP47-CODE-ODD |  |
| 2 | `bytes` | #3 | resto de valor en bruto (`0xFFFF`) |  |  |

UTF8-LANGUAGE-TEXT es un texto con idioma. Contiene en un solo Value un registro de Value de idioma y una secuencia de bytes UTF-8.

[UTF8-TEXT](0x072L-utf8-text.md) es una cadena sin idioma (identificador, código, nombre de archivo, bytes originales), y este formato es un texto con idioma (nombre, título, lema, oración). Aunque tengan los mismos bytes, son valores distintos. "Paris" (cadena) y "Paris" (en francés) no son iguales. Es lo mismo que RDF separa `xsd:string` de `rdf:langString`.

## Layout {#레이아웃}

- Código: código directo de Value `0x078L` (texto de bytes pares) y `0x079L` (texto de bytes impares). Familia TEXT.

```
TAG WORD          0000 0111 100P LLLL      Codec 0x078L/0x079L (P = el texto tiene bytes impares)
[TAG de extensión de Length] cuando el total es de 15 WORD o más
Language          1 registro de Value LANGUAGE-SHORT-CODE o LANGUAGE-BCP47-CODE (incluido su TAG)
Text WORD 1st ... Nth             UTF-8 bytes / si es impar, el último es 0x00
```

## Interpretación y validez {#해석과-유효성}

- El Payload comienza con el registro de idioma. Se lee el primer WORD del Payload como TAG, y su Length marca el registro de idioma; el resto son los bytes del texto. El registro de idioma es obligatorio. Si no hay idioma, se usa UTF8-TEXT en lugar de este formato.
- El registro de idioma es exactamente un registro completo de [LANGUAGE-SHORT-CODE](0x07AL-language-short-code.md) (`0x07AL`) o de [LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md) (`0x076L`·`0x077L`). Si es de otro Codec o está incompleto, es invalid. La validez del registro de idioma sigue las reglas de su formato.
- Pueden usarse ambos formatos de idioma. La regla para comparar si son el mismo idioma es la misma que en [LABEL](../edge/0x0A4L-label.md). El SHORT-CODE y el tag BCP 47 que el registro asocia a ese número son el mismo idioma.
- No se usa `zxx` (sin contenido lingüístico). Esa cadena es UTF8-TEXT. `und` (idioma indeterminado) y `mul` (varios idiomas) son textos con idioma, por lo que se pueden usar.
- Los bytes del texto siguen las mismas reglas que UTF8-TEXT. Deben ser UTF-8 bien formado, se admite también un U+FEFF inicial como carácter, no se impone normalización y se conserva tal cual el original. Quien compara o indexa lo ajusta a NFC para compararlo.
- El número de bytes del texto es `2 × (número de WORD de Payload − número de WORD del registro de idioma) − P`. P (bit menos significativo del Codec) solo indica la paridad de los bytes del texto. Si es impar, el byte inferior del último WORD debe ser `00`.
- Un texto vacío (0 bytes) se escribe con el código par y solo el registro de idioma.

## Dónde se usa {#쓰는-곳}

- Valor monolingualtext de Wikidata: `{"text":"Bundesrepublik Deutschland","language":"de"}` se convierte en un único valor de este formato. Entra tal cual en el Object de [TRIPLE](../edge/0x0AAL-triple.md) y en el Value de [QUALIFIER](../edge/0x0ABL-qualifier.md). La propiedad, el rank y el qualifier los gestiona TRIPLE.
- Object de [LABEL](../edge/0x0A4L-label.md) y [ALIAS](../edge/0x0A5L-alias.md). Este único valor contiene el nombre y el idioma.
- Textos cuyo idioma está determinado, como los títulos de leyes y artículos.

## Correspondencia de códigos de idioma (Wikidata) {#언어-코드-대응-위키데이터}

- No todos los códigos de idioma de Wikidata y Wikimedia son BCP 47 (por ejemplo, `simple`, `map-bms`). Se trasladan a tags BCP 47 mediante una tabla de correspondencias. Los códigos que no se pueden trasladar se tratan de forma distinta según su uso.
  - Valor (monolingualtext): se conserva el original del datavalue como UTF8-TEXT. El valor es parte de la proposición, así que descartarlo cambiaría la proposición.
  - Etiqueta, descripción y alias: se omiten y se dejan constancia en el informe. Estos Edge solo se sostienen si tienen idioma (un texto sin idioma es invalid), y el original permanece en los datos de origen.
- Si el tag trasladado tiene número en el GEUL Language Registry, se escribe como LANGUAGE-SHORT-CODE; si no, como LANGUAGE-BCP47-CODE.

## Longitud {#길이}

- El total es el número de WORD que suman 1 WORD de TAG, el TAG de extensión de Length (si lo hay), el registro de idioma y los WORD del texto. Hasta 14 WORD se usa longitud directa; desde 15 WORD, longitud extendida ([Length](../record.md)).
- El registro de idioma son 2 WORD si es SHORT-CODE y `ceil(bytes del tag/2) + 1` WORD si es BCP 47 (`de` 2 WORD, `zh-Hant` 5 WORD).

## Ejemplo {#예시}

Todos los idiomas son ejemplos del formato LANGUAGE-BCP47-CODE. `fr`, `ko` y `de` tienen número en el registro, por lo que también pueden escribirse con SHORT-CODE (2 WORD).

| Valor | Bytes del texto | Total de WORD |
|---|---|---|
| "Paris" (fr) | 5 (impar) | `0795 0761 6672 5061 7269 7300` |
| "" (ko) | 0 | `0782 0761 6B6F` |
| "Bundesrepublik Deutschland" (de) | 26 (par) | `078E 0011 0761 6465 4275 6E64 6573 7265 7075 626C 696B 2044 6575 7473 6368 6C61 6E64` |

- "Paris": TAG `0795` (Codec `0x079L`, `LLLL=0101`, 6 WORD en total), idioma `0761 6672` (BCP 47 `fr`), texto `5061 7269 7300` (5 bytes, último `00`).
- El tercero tiene 17 WORD en total, por lo que usa la extensión de Length (`LLLL=1110` de `078E`, TAG de extensión `0011`).

## Fundamento normativo {#표준-근거}

- Language tag: [RFC 5646 (BCP 47)](https://www.rfc-editor.org/rfc/rfc5646). `zxx`, `und` y `mul` son códigos especiales del IANA Language Subtag Registry.
- Texto: [RFC 3629](https://www.rfc-editor.org/rfc/rfc3629).
- Distinción entre cadena y texto con idioma: [RDF 1.1 Concepts — language-tagged string](https://www.w3.org/TR/rdf11-concepts/#dfn-language-tagged-string).

## Problemas abiertos {#열린-문제}

- Comprobación en el schema de la gramática de los tags BCP 47. Por ahora solo se comprueba que sean ASCII y no estén vacíos.

## Páginas relacionadas {#관련-페이지}

- [Value](_index.md), [UTF8-TEXT](0x072L-utf8-text.md), [LANGUAGE-SHORT-CODE](0x07AL-language-short-code.md), [LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md), [LABEL](../edge/0x0A4L-label.md)

## Texto original del documento de especificación {#규격-문서-원문}

Es el aspecto del documento de especificación `0x00000000/codecs/0x00000780/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000078000000000
BODY
#1 DECLARE 0x0780
#2 FIELD #1 record
#3 FIELD #1 rest
#4 BIND #1 "UTF8-LANGUAGE-TEXT-EVEN"
#5 BIND #2 "language"
#6 BIND #3 "bytes"
#7 CODEC #2 0x07A0
#8 CODEC #2 0x0760
#9 CODEC #2 0x0770
```

Lo anterior es el documento de Codec de `UTF8-LANGUAGE-TEXT-EVEN` (`0x078L`). El documento de Codec del otro miembro (`UTF8-LANGUAGE-TEXT-ODD`) solo difiere en el Codec ID del DOC-ID, el destino de DECLARE y el nombre enlazado en `#1` (BIND).
