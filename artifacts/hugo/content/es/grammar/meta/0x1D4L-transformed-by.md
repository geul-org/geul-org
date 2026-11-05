---
title: "TRANSFORMED-BY (0x1D4L)"
weight: 468
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Indica el método con que se convirtió a este documento desde otra representación (por ejemplo, un conversor de Wikidata o un codificador de lenguaje natural)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `TRANSFORMED-BY` (BIND del documento de especificación `TRANSFORMED-BY`) |
| TAG ID | `0x1D4L` |
| Codec ID | `0x00001D40` |
| Documento de especificación | `0x00000000/codecs/0x00001D40/` (destino de DECLARE `1D40`) |
| Sección | 14 `1110` (Meta), desplazamiento C dentro de la sección = 20 |
| Kind | Meta · clase: linaje |
| TAG WORD | `0001 1101 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Método de conversión. Herramienta, reglas y versión |
| Lado Hugo | `meta/lineage/transformed-by.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato receptor (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `tool` | #2 | registro | cualquier registro (excepto marcador de posición) |  |
| 2 | `version` | #3 | registro | `07C0` SHA-256-DIGEST, `07D0` SHA1-DIGEST |  |

Indica el método con que se convirtió a este documento desde otra representación (por ejemplo, un conversor de Wikidata o un codificador de lenguaje natural). Tool es con qué se convirtió; Version es con qué fuente de esa herramienta. Hacen falta ambos para poder regenerar el mismo documento a partir de la misma entrada.

## Layout {#레이아웃}

```
TAG WORD          0001 1101 0100 LLLL      Codec 0x1D4L
[TAG de extensión de Length]
Tool              1 registro Reference (herramienta o reglas de conversión)
Version           1 registro Value (SHA-256-DIGEST o SHA1-DIGEST)
```

- Codec: Meta `0x1D4L`, clase de linaje
- Payload: Reference incorporado (herramienta) + Value incorporado (resumen de la versión de la fuente)
- Cantidad: varios posibles (uno por herramienta)

## Interpretación y validez {#해석과-유효성}

- Tool es exactamente un registro Reference completo. Sirve cualquier Reference que señale la herramienta.
  - Herramienta de un documento de herramientas de geul.org: [EXTERNAL-ISSUER](../reference/0x02FL-external-issuer-2word.md) (`0x00000000`, ID de documento `0x0001xxxx xxxxxxxx`, su LOCAL). Un documento por herramienta (documento de definición de términos de [Issuer](../issuer.md)).
  - Si el Codec es un documento GEUL, se señala ese documento de Codec con [CODEC-POINTER](../reference/0x042L-codec-pointer.md).
- Version es exactamente un registro Value completo y es el ID de objeto de control de versiones de la fuente de Tool. En git, es el ID completo del objeto commit.
  - Si el formato de objetos del repositorio git es SHA-256, [SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md) (`0x07CL`, 16 WORD); si es SHA-1, [SHA1-DIGEST](../value/0x07DL-sha1-digest.md) (`0x07DL`, 10 WORD). El formato del repositorio se comprueba con `git rev-parse --show-object-format`.
  - No se usan IDs abreviados (como `2bd496f`). El Value de resumen no admite valores truncados.
  - No se escribe como texto hexadecimal (UTF8-TEXT). El mismo valor ocupa 22 WORD en SHA-1 (11 en binario) y 34 WORD en SHA-256 (18 en binario).
- Version es obligatorio. Un registro de herramienta cuya versión de fuente se desconoce no sirve de base para la reproducción. Si la herramienta está fuera del control de versiones, se usa el SHA-256 del entregable (SHA-256-DIGEST).
- Version señala la fuente confirmada (commit). En un documento creado con un árbol de trabajo con cambios sin confirmar no se usa ese ID de commit (se recomienda que la herramienta se niegue a ejecutarse).
- Si la herramienta depende de código fuera del repositorio (por ejemplo, una biblioteca local señalada con `replace` de Go), ese código también se anota aparte con TRANSFORMED-BY. El ID de commit de la herramienta por sí solo no determina ese código.
- Una herramienta que solo traslada la fuente sin pérdida (por ejemplo, una que carga un volcado tal cual en una base de datos) no determina el contenido del documento, así que no se anota. Una carga con pérdida cambia el documento, así que se anota como herramienta.
- El documento de especificación de geul.org (`0x1D40`) se escribe con dos campos de registro: Tool (ancho 0, cualquier Reference, por lo que sin CODEC) y Version (ancho 0, [CODEC](../edge/0x0BEL-codec.md) `07C0` y `07D0`).

## Longitud {#길이}

```
total = 1 + N_len + N_tool + N_version WORD
```

- El cursor tras leer todos los registros debe coincidir exactamente con el final del Meta.
- Si Tool es EXTERNAL-ISSUER-2WORD (8 WORD) y Version es SHA1-DIGEST (11 WORD), el total es 1 + 1 + 8 + 11 = 21 WORD y se usa la longitud extendida. Con SHA-256-DIGEST (18 WORD) son 28 WORD.

## Ejemplo {#예시}

Ejemplo no normativo. La herramienta es el LOCAL 2 del documento de herramientas de geul.org `0x0001000000000001` (`02F7 0000 0000 0001 0000 0000 0001 0002`) y la fuente es el commit `ddc0719974a32aaa7b422ee84221a9721085ce4c` (SHA-1).

```
1D4E 0015
02F7 0000 0000 0001 0000 0000 0001 0002
07DA DDC0 7199 74A3 2AAA 7B42 2EE8 4221 A972 1085 CE4C
```

## Problemas abiertos {#열린-문제}

- Si la versión de [GENERATED-BY](0x1D3L-generated-by.md) también debe cambiarse de la misma manera (resumen obligatorio u otro formato). La versión de un modelo no es un ID de commit.

## Páginas relacionadas {#관련-페이지}

- [Meta](_index.md), [GENERATED-BY](0x1D3L-generated-by.md), [DERIVED-FROM](0x1D2L-derived-from.md)
- [EXTERNAL-ISSUER](../reference/0x02FL-external-issuer-2word.md), [DOC-POINTER](../reference/0x041L-doc-pointer.md), [SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md), [SHA1-DIGEST](../value/0x07DL-sha1-digest.md), [CODEC](../edge/0x0BEL-codec.md)

## Texto original del documento de especificación {#규격-문서-원문}

Es el documento de especificación `0x00000000/codecs/0x00001D40/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D4000000000
BODY
#1 DECLARE 0x1D40
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "TRANSFORMED-BY"
#5 BIND #2 "tool"
#6 BIND #3 "version"
#7 CODEC #3 0x07C0
#8 CODEC #3 0x07D0
```
