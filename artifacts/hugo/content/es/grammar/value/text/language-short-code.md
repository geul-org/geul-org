---
title: "LANGUAGE-SHORT-CODE"
weight: 73
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-SHORT-CODE es un Value de código de idioma de GEUL que comprime en 1 WORD solo el primary language subtag (Codec 0x48)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
LANGUAGE-SHORT-CODE es un código de idioma comprimido de GEUL que contiene solo el primary language subtag, no la tag BCP 47 completa. El Payload es exactamente 1 WORD.

## Layout

- Código: código directo de Value `0x48`. Familia TEXT.
- El Payload es exactamente un código unsigned de 16 bits de 1 WORD.

```
TAG WORD          0x08C8 (0000 1000 1100 1000)  2 WORD en total
Payload WORD 1.º (16 bits)           GEUL language code (uint16)
```

## Interpretación y validez

- El Payload de 1 WORD se lee como un entero unsigned de 16 bits.
- Este valor es un código comprimido del primary language subtag. No contiene script, region, variant, extension ni private-use. Si hace falta esa información, se usa [LANGUAGE-BCP47-CODE](/es/grammar/value/text/language-bcp47-code/) (`0x46`·`0x47`).
- `0x0000..0xfffe` es el rango de asignación del GEUL Language Registry. Dentro de este rango, un valor que no esté realmente asignado en la versión de ese registro es invalid.
- El conjunto inicial de asignación son los registros públicos de `Type: language` de un snapshot concreto del IANA Language Subtag Registry, excepto los de `Scope: private-use`. No se excluyen collections, macrolanguage ni special.
- La asignación inicial pone los ID ordenando esos registros públicos por subtag ASCII. El orden físico del archivo de IANA no es una regla de ID.
- Los nuevos subtag `Type: language` posteriores se añaden al final sin cambiar los números existentes (append-only).
- Los ID de los language subtag deprecated no se borran ni se reutilizan. La relación de Preferred-Value y el estado deprecated se conservan como metadatos del registro.
- `0xffff` se reserva como escape de extensión. Hasta que se defina un formato de extensión aparte, es invalid en un Value LANGUAGE-SHORT-CODE independiente. No se usa con sentidos como `null`, `unknown` o `und`.
- Otra especificación de Codec puede definir en el futuro la regla de interpretación posterior a `0xffff`. Pero eso no significa que esa regla alargue el Payload de este formato ni que se admita un Payload que lo siga.
- Una especificación de Codec puede guardar el mismo código de 1 WORD en un campo en bruto sin TAG (un [CODEC](/es/grammar/codec-spec/#codec) en el campo en bruto). Esto es una regla de esa especificación de Codec, y la forma wire de un Value independiente es siempre TAG de 1 WORD + Payload de 1 WORD.
- Para juzgar el significado del valor hay que conservar junto a él la versión del GEUL Language Registry usada y la fecha del snapshot del registro de IANA que fija esa versión.

## Base estándar

- El registro de origen del primary language subtag y los metadatos de deprecated/Preferred-Value siguen el [IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry).
- El significado básico del sistema de language subtag de BCP 47 sigue [RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646).
- La asignación de ID append-only ordenada en ASCII, la reserva de `0xffff` y la distinción respecto de la incrustación sin TAG en un campo en bruto son reglas de GEUL.

## Longitud

- El total es exactamente 2 WORD: TAG 1 WORD y Payload 1 WORD, y se usa la longitud directa `LLLL=0001`. No hay TAG de extensión de Length, descriptor ni relleno.
- Si el Payload no es exactamente de 1 WORD, se rechaza.

## Ejemplo

- Como el snapshot del registro y la tabla de códigos reales aún no están fijados, no se incluyen ejemplos de ID numéricos de idiomas concretos.

## Problemas abiertos

- La fecha del snapshot inicial de IANA, el nombre de la versión del GEUL Language Registry y la tabla de correspondencia completa. Hasta que se fijen, no se confirman ejemplos numéricos concretos ni la tabla de códigos.
