---
title: "DESCRIPTION (0x0A6L)"
weight: 166
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DESCRIPTION es un Edge de enunciado que conecta con Object una descripción en un idioma concreto del objeto Subject."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `DESCRIPTION` (BIND del documento de especificación `DESCRIPTION`) |
| TAG ID | `0x0A6L` |
| Codec ID | `0x00000A60` |
| Documento de especificación | `0x00000000/codecs/0x00000A60/` (destino de DECLARE `0A60`) |
| Sección | 5 `0101` (enunciado de Edge), desplazamiento dentro de la sección C = 6 |
| Kind | Edge · familia: enunciado, grupo: señalamiento y nombre |
| TAG WORD | `0000 1010 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Conexión de la descripción (description) de Subject en un idioma. El layout es igual que el de LABEL |
| Lado Hugo | `edge/description.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)). El Edge Id de un Edge no se declara con FIELD.

| Orden | Campo (BIND) | FIELD | Ancho | Formato que acepta (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | registro | cualquier registro (excepto marcadores de posición) |  |
| 2 | `object` | #3 | registro | `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT, `0050` LOCAL |  |

DESCRIPTION es un Edge de enunciado que conecta con Object una descripción en un idioma concreto del objeto Subject. Codec `0x0A6L`.

La descripción es una frase corta que distingue al objeto (description de Wikidata, por ejemplo «capital y mayor ciudad de Alemania»). No es una definición ni una afirmación sobre el objeto. Las proposiciones sobre el objeto se escriben como [TRIPLE](0x0AAL-triple.md). El layout es igual que el de [LABEL](0x0A4L-label.md). La descripción y su idioma van en un solo Object, [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md). No hay campo de valor en bruto.

## Layout {#레이아웃}

```
TAG WORD          0000 1010 0110 LLLL
[TAG de extensión de Length]
Edge Id           registro Reference LOCAL
Subject           1 registro Reference
Object            1 Value UTF8-LANGUAGE-TEXT o registro Reference LOCAL
```

## Interpretación y validez {#해석과-유효성}

- Las reglas de Subject y Object son iguales que las de [LABEL](0x0A4L-label.md). Subject es exactamente un registro Reference completo. Object es exactamente un registro UTF8-LANGUAGE-TEXT (`0x078L`·`0x079L`) completo, o una Reference LOCAL que se resuelve a UTF8-LANGUAGE-TEXT mediante un vínculo [REFERENCE-NODE](0x0A0L-reference-node.md) del mismo documento.
- Un texto sin idioma (UTF8-TEXT) no puede ser DESCRIPTION. Como la descripción es una por idioma, esa regla solo se sostiene si hay idioma. Una descripción común a varios idiomas se escribe con el idioma `mul`.
- Para el mismo Subject e idioma hay como máximo un DESCRIPTION.
- La descripción sirve para distinguir de otros objetos con el mismo nombre. Conviene que el par LABEL y DESCRIPTION no se repita en dos objetos del mismo idioma, pero la especificación no lo comprueba (Wikidata tampoco lo impone, solo lo recomienda).
- El documento de especificación de geul.org limita Object con [CODEC](0x0BEL-codec.md) (`0780`·`0790`·`0050`, igual que LABEL).

## Longitud {#길이}

```
total = 1 + N_len + N_id + N_subject + N_object WORD
```

- El registro de idioma de Object y el número de bytes del texto los asume el registro Object. El cursor tras leer todos los registros debe coincidir exactamente con el final del Edge.
- La descripción es más larga que el label, por lo que tanto Object como el Edge superan fácilmente los 15 WORD. En ese caso se usa la extensión de Length ([registro](../record.md)).

## Ejemplo (no normativo) {#예시-비규범}

Edge Id `0009`, Subject Q64 (`0141 0040`), Object `capital and largest city of Germany` (en). El idioma es un ejemplo en formato LANGUAGE-BCP47-CODE (`en` tiene el número de registro `0x0784`, así que también puede usarse SHORT-CODE).

- Object es idioma `0761 656E` (BCP47 `en`, 2 WORD) + texto de 35 bytes (impar, 18 WORD), es decir `0x079L`, TAG 1 + TAG de extensión 1 + 20 = 22 WORD, `079E 0016 …`.
- El Edge es TAG 1 + TAG de extensión 1 + Edge Id 2 + Subject 2 + Object 22 = 28 WORD, por lo que `LLLL=1110`, TAG `0A6E`, TAG de extensión `001C`.

```
0A6E 001C 0051 0009 0141 0040
079E 0016 0761 656E 6361 7069 7461 6C20 616E 6420 6C61 7267 6573 7420 6369 7479 206F 6620 4765 726D 616E 7900
```

## Correspondencia con Wikidata {#위키데이터-대응}

- Los `descriptions` del ítem (uno por idioma) → un DESCRIPTION por idioma. El código de idioma se traslada con la misma tabla de correspondencia de códigos de idioma que LABEL.

## Problemas abiertos {#열린-문제}

- Si existen casos que justifiquen admitir una descripción UTF8-TEXT sin idioma (por ahora no se admite).

## Páginas relacionadas {#관련-페이지}

- [Edge](_index.md), [LABEL](0x0A4L-label.md), [ALIAS](0x0A5L-alias.md), [CODEC](0x0BEL-codec.md)
- [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md), [LOCAL](../reference/0x005L-local.md), [REFERENCE-NODE](0x0A0L-reference-node.md)

## Texto original del documento de especificación {#규격-문서-원문}

Así se ve el documento de especificación `0x00000000/codecs/0x00000A60/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A6000000000
BODY
#1 DECLARE 0x0A60
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "DESCRIPTION"
#5 BIND #2 "subject"
#6 BIND #3 "object"
#7 CODEC #3 0x0780
#8 CODEC #3 0x0790
#9 CODEC #3 0x0050
```
