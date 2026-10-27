---
title: "LANGUAGE-BCP47-CODE"
weight: 71
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-BCP47-CODE es un Value que contiene como bytes ASCII una etiqueta de idioma BCP 47 completa. Usa el par de códigos de bytes par/impar 0x46/0x47."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
LANGUAGE-BCP47-CODE es un Value que contiene una language tag BCP 47 completa. Se usa para anotar el idioma con exactitud, hasta el script, la region y la variant.

## Layout

- Código: código directo de Value `0x46` (bytes pares) y `0x47` (bytes impares). Familia TEXT.
- El número de bytes se fija con el bit menos significativo del Codec y el número de WORD del Payload. Es `2 × número de WORD del Payload − bit menos significativo` y no hay Byte Count ([Value](/es/grammar/value/)).
- El Payload no es texto UTF-8 sino los bytes ASCII de la tag BCP 47.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x46/0x47
[TAG de extensión de Length] si el total es de 15 WORD o más
Payload WORD 1.º ... N-ésimo          bytes de la tag BCP 47 / relleno de ceros final
```

## Interpretación y validez

- Los bytes deben ser una language tag BCP 47 well-formed de RFC 5646. No se admite la cadena vacía.
- El Payload usa solo caracteres ASCII, dígitos y el hyphen-minus `-`. El separador debe ser siempre ASCII `-`, y no se admiten `_`, espacios ni caracteres no ASCII.
- La comparación de tags BCP 47 no distingue mayúsculas de minúsculas. El canonical profile de GEUL escribe todos los separadores con `-` y serializa en minúsculas los subtags language/extlang/variant/extension/private-use, en Titlecase el script y en mayúsculas la region.
- Que esté well-formed no basta. La validez de los registered subtag y de las grandfathered tag se juzga con respecto a un snapshot concreto del IANA Language Subtag Registry, y hay que conservar junto a ello la fecha de ese snapshot o la versión del registro.
- Los private-use tag y los private-use subtag se admiten si están well-formed según la gramática de RFC 5646. Sin embargo, su significado depende del acuerdo entre las partes y no lo define el registro de IANA, así que no garantizan interoperabilidad pública.
- Si en el mismo snapshot un subtag deprecated o una grandfathered tag tiene Preferred-Value, la forma canónica de GEUL usa ese valor de sustitución con su canonical casing. Una tag con la notación deprecated tal cual se puede interpretar como entrada, pero no es la forma de almacenamiento canónica.
- BCP 47 es un perfil ASCII, por lo que no se aplican requisitos de normalización Unicode como UTF-8 NFC.
- Dentro de un WORD, el byte superior va primero. Si el número de bytes es impar (código impar), el byte inferior no usado del último WORD debe ser `00`.
- El número de WORD del Payload es `ceil(número de bytes/2)`. Si el código es impar y el byte inferior del último WORD no es `00`, se rechaza.

## Base estándar

- La gramática de language tag, la interpretación sin distinción de mayúsculas y los conceptos de deprecated/Preferred-Value siguen [RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646).
- El registro que juzga la validez de las tags es el [IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry).
- El par de códigos par/impar, el relleno de ceros, la política de almacenamiento con canonical casing y el cálculo de Length son reglas de framing de GEUL.

## Longitud

- El total es el número de WORD que suman el TAG de 1 WORD, el TAG de extensión de Length (si lo hay) y el Payload. Hasta 14 WORD se usa longitud directa y desde 15 WORD longitud extendida `1110`·`1111`, y el TAG de extensión también se incluye en el total ([Length](/es/grammar/record/)).

## Relación con LANGUAGE-SHORT-CODE

- Para contener de forma corta solo el primary language subtag, se usa [LANGUAGE-SHORT-CODE](/es/grammar/value/text/language-short-code/).
- Si hacen falta script, region, variant, extension o private-use, se usa LANGUAGE-BCP47-CODE.
- LANGUAGE-BCP47-CODE también se usa para un idioma aún no asignado en el registro de LANGUAGE-SHORT-CODE, cuando haría falta el escape `0xffff` y cuando hay que conservar el original de la full tag.

## Ejemplo

- `ko-KR` son 5 bytes ASCII (impar), por lo que es `LANGUAGE-BCP47-CODE-ODD` (`0x47`) y el Payload es `6b6f 2d4b 5200`.
- Con TAG 1 WORD y Payload 3 WORD, son 4 WORD en total y `LLLL=0011`. El total es `09C7 6b6f 2d4b 5200`.
