---
title: "LANGUAGE-SHORT-CODE (0x07AL)"
weight: 122
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-SHORT-CODE es el código de idioma comprimido de GEUL que contiene en 1 WORD un tag BCP 47 al que el GEUL Language Registry ha asignado un número."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `LANGUAGE-SHORT-CODE` (BIND del documento de especificación `LANGUAGE-SHORT-CODE`) |
| TAG ID | `0x07AL` |
| Codec ID | `0x000007A0` |
| Documento de especificación | `0x00000000/codecs/0x000007A0/` (destino de DECLARE `07A0`) |
| Sección | 3 `0011` (Value), desplazamiento C dentro de la sección = 26 |
| Kind | Value · familia: TEXT |
| TAG WORD | `0000 0111 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Tag BCP 47 escrito con un número del GEUL Language Registry (Payload de 1 WORD) |
| Lado Hugo | `value/text/language-short-code.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato que recibe (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `code` | #2 | valor en bruto de 1 WORD |  | 8678 ENUM. Ejemplos: `0x0001` aa, `0x0002` aaa, `0x0003` aab, `0x0004` aac, `0x0005` aad … |

LANGUAGE-SHORT-CODE es el código de idioma comprimido de GEUL que contiene en 1 WORD un tag BCP 47 al que el GEUL Language Registry ha asignado un número. El Payload es exactamente 1 WORD.

## Layout {#레이아웃}

- Código: código directo de Value `0x07AL`. Familia TEXT.
- El Payload es un código unsigned de 16 bits de exactamente 1 WORD.

```
TAG WORD          0x07A1 (0000 0111 1010 0001)  2 WORD en total
Payload WORD 1st (16 bits)           número del GEUL Language Registry (uint16)
```

## Interpretación y validez {#해석과-유효성}

- Se lee el WORD de Payload como un entero unsigned de 16 bits.
- Este valor es un tag asignado por el GEUL Language Registry. La representación oficial del registro es el documento de especificación de este Codec, `0x00000000/codecs/0x000007A0`. Cada valor de código tiene un [ENUM](../edge/0x0BDL-enum.md) en el FIELD `code`, y el nombre unido mediante [BIND](../edge/0x0A3L-bind.md) al Edge Id de ese ENUM es el tag BCP 47 en su capitalización canónica.
- El registro es una lista cerrada. Un valor sin ENUM en el documento de especificación es invalid. Esta regla del Codec prevalece sobre la regla general de ENUM («un valor de código no declarado no es un error»).
- Se asignan los tres siguientes.
  - Los registros `Type: language` del IANA Language Subtag Registry, excepto los de `Scope: private-use` (`qaa..qtz`). No se excluyen collection, macrolanguage ni special (`mul`·`und`·`zxx`·`mis`).
  - Los tags que IANA registró completos: grandfathered y redundant (`zh-Hans`, `sr-Latn`, `zh-min-nan`, etc.).
  - Los tags combinados válidos observados en fuentes públicas CC0 (`pt-BR`, `en-GB`, `be-tarask`, etc.). Son tags formados solo por subtags language, extlang, script, region y variant. No se aceptan los tags que contienen extension (`-u-`·`-t-`) ni private-use (`-x-`).
- Un tag sin número no puede escribirse con este formato. Se escribe con [LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md) (`0x076L`·`0x077L`). Dentro de SHORT-CODE no hay ruta de escape.
- `0x0000` y `0xFFFF` no se asignan nunca. En este Value ambos son invalid. Ninguno de los dos se usa con el sentido de `null`, `unknown` ni `und`.
- Los tramos de valores son una convención de asignación. El decodificador no infiere el tipo de tag a partir del rango del valor. El significado del valor proviene únicamente del documento de especificación.

| Tramo | Uso |
|---|---|
| `0x0000` | sin asignar (invalid) |
| `0x0001`–`0x3FFF` | tags con un solo subtag language |
| `0x4000`–`0x7FFF` | tags con dos o más subtags (tags completos de IANA, tags combinados observados) |
| `0x8000`–`0xFFFE` | desbordamiento. Cuando se llenan los bloques anteriores, la asignación continúa aquí |
| `0xFFFF` | sin asignar (invalid) |

- La edición inicial da los números dentro de cada bloque por orden ASCII del tag en minúsculas. El bloque `0x4000` pone primero los tags completos de IANA (grandfathered y redundant mezclados por orden ASCII) y después los tags combinados observados (por orden ASCII). El orden físico del archivo de IANA y la frecuencia de uso no son reglas de numeración.
- La asignación es solo por adición (append-only). Un tag nuevo se añade al final del bloque y, cuando el bloque se llena, se añade al tramo de desbordamiento. El tag de un número ya dado (sin distinguir mayúsculas) no se cambia, ni se borra ni se reutiliza.
- Un tag nuevo se incorpora añadiendo ENUM y BIND a una versión nueva del documento de especificación. No se modifican los ENUM ni BIND existentes. Por eso cualquier versión es un superconjunto de la anterior.
- Cuando se llenan los 65534, no se asigna más. Los tags nuevos posteriores se escriben con LANGUAGE-BCP47-CODE. No disminuye la capacidad de expresión; solo se pierde la ganancia de compresión.
- Mismo idioma: el SHORT-CODE `n` y el LANGUAGE-BCP47-CODE del tag que el registro asocia a `n` (sin distinguir mayúsculas) son el mismo idioma.
- La edición del registro es la versión del documento de especificación. Cada edición anota el archivo del registry de IANA en que se basa (File-Date, SHA-256) como [SOURCE](../edge/0x0C0L-source.md) del HEAD del documento de especificación. Cuando haya que indicar la edición con que se interpretó un valor, se deja junto con él esa versión ([CODEC-POINTER](../reference/0x042L-codec-pointer.md) (`0x00000000`, `0x000007A0`, ID de versión `n`)).
- Una especificación de Codec puede contener el mismo código de 1 WORD como campo de valor en bruto sin TAG ([CODEC](../codec-spec.md#codec) del campo de valor en bruto). Es una regla de esa especificación de Codec, y la wire form de un Value independiente es siempre 1 WORD de TAG + 1 WORD de Payload.

## Fundamento normativo {#표준-근거}

- El significado del tag y la validez de los subtags siguen el [IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry) y [RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646). IANA e IETF ponen los derechos sobre los registros de protocolo bajo CC0 1.0 ([IANA Licensing Terms](https://www.iana.org/help/licensing-terms)).
- Los números del registro (asignación append-only por orden ASCII, composición de bloques, `0x0000`·`0xFFFF` sin asignar, lista cerrada), que el ENUM del documento de especificación sea la representación oficial y la distinción respecto al embedding como campo de valor en bruto sin TAG son reglas de GEUL.

## Longitud {#길이}

- El total son exactamente 2 WORD, la suma de 1 WORD de TAG y 1 WORD de Payload, y usa la longitud directa `LLLL=0001`. No hay TAG de extensión de Length, descriptor ni padding.
- Si el Payload no es exactamente 1 WORD, se rechaza.

## Ejemplo {#예시}

Son números del registro v2 (versión 2 del documento de especificación `0x00000000/codecs/0x000007A0`, IANA File-Date 2026-09-17). Se asignaron 8678 (language 8275, grandfathered 26, redundant 67, combinaciones observadas 310).

| tag | Código | Total de WORD |
|---|---|---|
| `en` | `0x0784` | `07A1 0784` |
| `ko` | `0x0D06` | `07A1 0D06` |
| `zh-Hans` | `0x404C` | `07A1 404C` |
| `pt-BR` | `0x4130` | `07A1 4130` |

- En el documento de especificación, `en` es `ENUM #2 0x0784` y `BIND "en"` unido a su Edge Id.
- `de-x-formal` (private-use) y `nl-u-sd-bebru` (extension) no tienen número, por lo que se escriben con LANGUAGE-BCP47-CODE.

## Problemas abiertos {#열린-문제}

- Interpretación entre ediciones: cuando se encuentra un número más nuevo que la edición que tiene quien lee, si se descarta como invalid o se trata como «código desconocido» conservando el valor original. Al ser append-only, basta siempre con la última edición, pero hace falta una regla para los decodificadores sin conexión.
- Forma canónica: si un tag que tiene número debe (SHOULD/MUST) escribirse como SHORT-CODE. Con MUST la notación queda determinada de una sola manera, pero cuando sale una edición nueva los documentos escritos antes dejan de estar en forma canónica.
- Cómo representar en el documento de especificación los tags deprecated y el Preferred-Value (no está en la edición actual).
- Procedimiento para añadir tags combinados observados (fuente, umbral mínimo de observación).

## Páginas relacionadas {#관련-페이지}

- [LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md), [UTF8-LANGUAGE-TEXT](0x078L-utf8-language-text.md), [LABEL](../edge/0x0A4L-label.md)
- [documento de especificación de Codec](../codec-spec.md), [ENUM](../edge/0x0BDL-enum.md), [BIND](../edge/0x0A3L-bind.md), [SOURCE](../edge/0x0C0L-source.md)

## Texto original del documento de especificación {#규격-문서-원문}

Es el aspecto del documento de especificación `0x00000000/codecs/0x000007A0/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007A000000000
#17368 SOURCE #0 #17362
#17369 QUALIFIER P577 #17368 GREGORIAN-DATE(2026-09-17)
#17370 QUALIFIER P813 #17368 GREGORIAN-DATE(2026-10-29)
#17371 QUALIFIER P4092 #17368 SHA-256-DIGEST(0x755FAD43283BE7B41EBE3C89AD054B6EAF928F404F9C0EDB74799E0EAB74BEB1)
#17372 SOURCE #0 Q2013
#17373 QUALIFIER P813 #17372 GREGORIAN-DATE(2026-10-29)
BODY
#1 DECLARE 0x07A0
#2 FIELD #1 0x0001
#3 BIND #1 "LANGUAGE-SHORT-CODE"
#4 BIND #2 "code"
#5 ENUM #2 0x0001
#6 BIND #5 "aa"
#7 ENUM #2 0x0002
#8 BIND #7 "aaa"
#9 ENUM #2 0x0003
#10 BIND #9 "aab"
#11 ENUM #2 0x0004
#12 BIND #11 "aac"
#13 ENUM #2 0x0005
#14 BIND #13 "aad"
… (17346 líneas de ENUM·BIND omitidas)
#17361 REFERENCE-NODE #17362 <https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry>
#17363 TRIPLE P275 #17362 Q6938433 normal
#17364 REFERENCE-NODE #17365 <https://www.iana.org/help/licensing-terms>
#17366 SOURCE #17363 #17365
#17367 QUALIFIER P813 #17366 GREGORIAN-DATE(2026-10-29)
```
