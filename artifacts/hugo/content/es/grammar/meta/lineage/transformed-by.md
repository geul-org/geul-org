---
title: "TRANSFORMED-BY"
weight: 52
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "TRANSFORMED-BY es un Meta de linaje que anota la herramienta que transformó otra representación en este documento y la versión de su código fuente (digest del commit)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
Anota el método con el que se transformó otra representación en este documento (ejemplo: un conversor de Wikidata, un codificador de lenguaje natural). Tool es con qué se transformó y Version es con qué fuente de esa herramienta. Hacen falta ambos para poder regenerar el mismo documento a partir de la misma entrada.

## Layout

```
TAG WORD          0001 1LLL L011 0011      Codec 0x33
[TAG de extensión de Length]
Tool              1 registro Reference (herramienta o regla de transformación)
Version           1 registro Value (SHA-256-DIGEST o SHA1-DIGEST)
```

- Codec: Meta `0x33`, clase de linaje (`011`)
- Payload: Reference incorporado (herramienta) + Value incorporado (digest de la versión del código fuente)
- Cantidad: puede haber varios (uno por herramienta)

## Interpretación y validez

- Tool es exactamente un registro Reference completo. Sirve cualquier Reference que apunte a la herramienta.
  - Una herramienta del documento de herramientas de geul.org: [EXTERNAL-ISSUER](/es/grammar/reference/external-issuer/) (`0x0000`, ID de documento `0x0001xxxx xxxxxxxx`, su LOCAL). Un documento por herramienta ([Issuer](/es/grammar/issuer/), documento de definición de términos).
  - Si el códec es un documento GEUL, se señala ese documento con [DOC-POINTER](/es/grammar/reference/doc-pointer/).
- Version es exactamente un registro Value completo y es el ID de objeto de control de versiones del código fuente de Tool. En git, es el ID completo del objeto commit.
  - Si el formato de objetos del repositorio git es SHA-256, [SHA-256-DIGEST](/es/grammar/value/binary/sha-256-digest/) (`0x61`, 16 WORD); si es SHA-1, [SHA1-DIGEST](/es/grammar/value/binary/sha1-digest/) (`0x62`, 10 WORD). El formato del repositorio se comprueba con `git rev-parse --show-object-format`.
  - No se usan ID abreviados (`2bd496f`, etc.). El Value de digest no admite valores truncados.
  - No se escribe como texto hex (UTF8-TEXT). El mismo valor ocupa 22 WORD con SHA-1 (11 en binario) y 34 WORD con SHA-256 (18 en binario).
- Version es obligatorio. El registro de una herramienta cuya versión de código fuente se desconoce no sirve de base para la reproducción. Si la herramienta está fuera del control de versiones, se usa el SHA-256 del artefacto distribuido (SHA-256-DIGEST).
- Version señala el código fuente confirmado en un commit. En un documento creado con un árbol de trabajo con cambios sin confirmar no se usa ese ID de commit (se recomienda que la herramienta se niegue a ejecutarse).
- Si la herramienta depende de código fuera del repositorio (ejemplo: una biblioteca local señalada con un `replace` de Go), ese código también se anota aparte con TRANSFORMED-BY. El ID de commit de la herramienta por sí solo no determina ese código.
- Una herramienta que solo traslada el origen sin pérdida (ejemplo: una herramienta que carga un volcado tal cual en una base de datos) no fija el contenido del documento, por lo que no se anota. Una carga con pérdida cambia el documento, así que se anota como herramienta.
- El documento de especificación de geul.org (`0x1833`) lo anota con dos campos de registro: Tool (ancho 0, cualquier Reference, por lo que no lleva CODEC) y Version (ancho 0, [CODEC](/es/grammar/edge/codec/) `0861` y `0862`).

## Longitud

```
total = 1 + N_len + N_tool + N_version WORD
```

- El cursor tras leer todos los registros debe coincidir exactamente con el final del Meta.
- Si Tool es EXTERNAL-ISSUER-1WORD (7 WORD) y Version es SHA1-DIGEST (11 WORD), el total es 1 + 1 + 7 + 11 = 20 WORD y se usa la longitud extendida. Con SHA-256-DIGEST (18 WORD) son 27 WORD.

## Ejemplo

Ejemplo no normativo. La herramienta es el LOCAL 2 (`0360 0000 0001 0000 0000 0001 0002`) del documento de herramientas de geul.org `0x0001000000000001`, y el código fuente es el commit `ddc0719974a32aaa7b422ee84221a9721085ce4c` (SHA-1).

```
1F33 0014
0360 0000 0001 0000 0000 0001 0002
0D62 ddc0 7199 74a3 2aaa 7b42 2ee8 4221 a972 1085 ce4c
```

## Problemas abiertos

- Si la versión de [GENERATED-BY](/es/grammar/meta/lineage/generated-by/) debe pasar al mismo método (digest obligatorio u otro formato). La versión de un modelo no es un ID de commit.

## Páginas relacionadas

- [Meta](/es/grammar/meta/), [GENERATED-BY](/es/grammar/meta/lineage/generated-by/), [DERIVED-FROM](/es/grammar/meta/lineage/derived-from/)
- [EXTERNAL-ISSUER](/es/grammar/reference/external-issuer/), [DOC-POINTER](/es/grammar/reference/doc-pointer/), [SHA-256-DIGEST](/es/grammar/value/binary/sha-256-digest/), [SHA1-DIGEST](/es/grammar/value/binary/sha1-digest/), [CODEC](/es/grammar/edge/codec/)
