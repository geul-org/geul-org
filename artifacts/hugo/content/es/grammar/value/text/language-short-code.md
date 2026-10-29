---
title: "LANGUAGE-SHORT-CODE"
weight: 73
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T23:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-SHORT-CODE es un Value de código de idioma de GEUL que contiene en 1 WORD una tag BCP 47 numerada por el GEUL Language Registry (Codec 0x48). El registro son los ENUM del documento de especificación de este Codec."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LANGUAGE-SHORT-CODE es un código de idioma comprimido de GEUL que contiene en 1 WORD una tag BCP 47 que tiene número en el GEUL Language Registry. El Payload es exactamente 1 WORD.

## Layout

- Código: código directo de Value `0x48`. Familia TEXT.
- El Payload es exactamente 1 WORD, un código unsigned de 16 bits.

```
TAG WORD          0x08C8 (0000 1000 1100 1000)  2 WORD en total
Payload WORD 1st (16 bits)           número del GEUL Language Registry (uint16)
```

## Interpretación y validez

- El WORD del Payload se lee como entero unsigned de 16 bits.
- Este valor es una tag asignada por el GEUL Language Registry. La forma normativa del registro es el documento de especificación de este Codec, `0x0000/0x0000000000000848`. Cada valor de código tiene un [ENUM](/es/grammar/edge/enum/) en el FIELD `code`, y el nombre ligado con [BIND](/es/grammar/edge/bind/) al Edge Id de ese ENUM es la tag BCP 47 en mayúsculas/minúsculas canónicas.
- El registro es una lista cerrada. Un valor sin ENUM en el documento de especificación es invalid. Esta regla del Codec prevalece sobre la regla general de ENUM ("un valor de código no declarado no es un error").
- Se asignan tres clases de tag.
  - Los registros `Type: language` del IANA Language Subtag Registry, salvo `Scope: private-use` (`qaa..qtz`). No se excluyen collection, macrolanguage ni special (`mul`, `und`, `zxx`, `mis`).
  - Las tags que IANA registra enteras: grandfathered y redundant (`zh-Hans`, `sr-Latn`, `zh-min-nan`, etc.).
  - Las tags combinadas válidas observadas en fuentes públicas CC0 (`pt-BR`, `en-GB`, `be-tarask`, etc.). Solo constan de subtags language, extlang, script, region y variant. No se aceptan tags con extension (`-u-`, `-t-`) ni private-use (`-x-`).
- Una tag sin número no puede escribirse en este formato. Se escribe como [LANGUAGE-BCP47-CODE](/es/grammar/value/text/language-bcp47-code/) (`0x46`, `0x47`). SHORT-CODE no tiene vía de escape.
- `0x0000` y `0xffff` no se asignan nunca. Ambos son invalid en este Value. Ninguno se usa con el sentido de `null`, `unknown` o `und`.
- Los rangos de valores son una convención de asignación. El decodificador no deduce la clase de tag por el rango del valor. El significado de un valor solo viene del documento de especificación.

| Rango | Uso |
|---|---|
| `0x0000` | Nunca asignado (invalid) |
| `0x0001`–`0x3fff` | Tags de un solo language subtag |
| `0x4000`–`0x7fff` | Tags de dos o más subtags (tags enteras de IANA, tags combinadas observadas) |
| `0x8000`–`0xfffe` | Desbordamiento. Cuando un bloque de arriba se llena, la asignación sigue aquí |
| `0xffff` | Nunca asignado (invalid) |

- La edición inicial numera las tags dentro de cada bloque en orden ASCII en minúsculas. En el bloque `0x4000` van primero las tags enteras de IANA (grandfathered y redundant mezcladas, en orden ASCII) y después las tags combinadas observadas (en orden ASCII). Ni el orden físico del archivo de IANA ni la frecuencia de uso son reglas de numeración.
- La asignación solo añade (append-only). Una tag nueva se añade al final de su bloque y, si el bloque está lleno, en el rango de desbordamiento. La tag (sin distinguir mayúsculas) de un número ya dado no se cambia, no se borra ni se reutiliza.
- Una tag nueva entra añadiendo un ENUM y un BIND en una nueva versión del documento de especificación. Los ENUM y BIND existentes no se modifican. Por eso toda versión es un superconjunto de la anterior.
- Cuando se agotan los 65.534 números, no se asignan más. Las tags nuevas posteriores se escriben como LANGUAGE-BCP47-CODE. No se pierde expresividad; solo la ganancia de compresión.
- Mismo idioma: el SHORT-CODE `n` y el LANGUAGE-BCP47-CODE de la tag que el registro liga a `n` (sin distinguir mayúsculas) son el mismo idioma.
- Una edición del registro es una versión del documento de especificación. Cada edición registra el archivo del registro de IANA en que se basa (File-Date, SHA-256) como [SOURCE](/es/grammar/edge/source/) en el HEAD del documento de especificación. Cuando haya que indicar la edición con que se interpretó un valor, se conserva esa versión (`0x0000/0x0000000000000848@n`) junto a él.
- Una especificación de Codec puede contener el mismo código de 1 WORD en un campo de valor crudo sin TAG ([CODEC](/es/grammar/codec-spec/#codec) de un campo de valor crudo). Es una regla de esa especificación de Codec; la wire form de un Value independiente es siempre TAG 1 WORD + Payload 1 WORD.

## Base estándar

- El significado de las tags y la validez de los subtags siguen el [IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry) y [RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646). IANA y el IETF ponen sus derechos sobre los registros de protocolo bajo CC0 1.0 ([IANA Licensing Terms](https://www.iana.org/help/licensing-terms)).
- Los números del registro (asignación append-only en orden ASCII, composición de bloques, `0x0000` y `0xffff` sin asignar, lista cerrada), que los ENUM del documento de especificación sean la forma normativa y la distinción frente al embedding sin TAG en un campo de valor crudo son reglas de GEUL.

## Longitud

- El total es exactamente 2 WORD, TAG 1 WORD más Payload 1 WORD, con longitud directa `LLLL=0001`. No hay TAG de extensión de Length, descriptor ni padding.
- Si el Payload no es exactamente 1 WORD, se rechaza.

## Ejemplo

Números del registro v2 (documento de especificación `0x0000/0x0000000000000848` versión 2, IANA File-Date 2026-09-17). Asigna 8.678 tags (language 8.275, grandfathered 26, redundant 67, combinadas observadas 310).

| tag | Código | WORD completos |
|---|---|---|
| `en` | `0x0784` | `08C8 0784` |
| `ko` | `0x0d06` | `08C8 0D06` |
| `zh-Hans` | `0x404c` | `08C8 404C` |
| `pt-BR` | `0x4130` | `08C8 4130` |

- En el documento de especificación, `en` es `ENUM #2 0x0784` y el `BIND "en"` sobre su Edge Id.
- `de-x-formal` (private-use) y `nl-u-sd-bebru` (extension) no tienen número, así que se escriben como LANGUAGE-BCP47-CODE.

## Problemas abiertos

- Lectura entre ediciones: si un número más nuevo que la edición del lector se descarta como invalid o se conserva con su valor crudo como "código desconocido". Al ser append-only, la última edición siempre basta, pero los decodificadores sin conexión necesitan una regla.
- Forma canónica: si una tag con número debe (SHOULD/MUST) escribirse como SHORT-CODE. Con MUST la grafía queda fijada, pero una edición nueva haría no canónicos los documentos escritos antes.
- Cómo expresar las tags deprecated y Preferred-Value en el documento de especificación (la edición actual no las tiene).
- El procedimiento para añadir tags combinadas observadas (fuentes, umbral de observación).

## Páginas relacionadas

- [LANGUAGE-BCP47-CODE](/es/grammar/value/text/language-bcp47-code/), [UTF8-LANGUAGE-TEXT](/es/grammar/value/text/utf8-language-text/), [LABEL](/es/grammar/edge/label/)
- [Documento de especificación de Codec](/es/grammar/codec-spec/), [ENUM](/es/grammar/edge/enum/), [BIND](/es/grammar/edge/bind/), [SOURCE](/es/grammar/edge/source/)
