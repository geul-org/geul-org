---
title: "URI"
weight: 69
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "URI es un Value que contiene los bytes ASCII de la gramática de URI de RFC 3986 (URI absoluto con scheme). Usa el par de códigos de bytes par/impar 0x44/0x45."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
URI es un Value que contiene los bytes ASCII de la gramática `URI = scheme ":" hier-part [ "?" query ] [ "#" fragment ]` de RFC 3986. Como incluye el scheme, la interpretación no necesita un base URI.

## Layout

- Código: código directo de Value `0x44` (bytes pares) y `0x45` (bytes impares). Familia TEXT.
- El número de bytes se fija con el bit menos significativo del Codec y el número de WORD del Payload. Es `2 × número de WORD del Payload − bit menos significativo` y no hay Byte Count ([Value](/es/grammar/value/)).

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x44/0x45
[TAG de extensión de Length] si el total es de 15 WORD o más
Payload WORD 1.º ... N-ésimo          bytes del URI / relleno de ceros final
```

## Interpretación y validez

- Los bytes deben ajustarse a la gramática `URI = scheme ":" hier-part [ "?" query ] [ "#" fragment ]` de RFC 3986. Puede incluir query y fragment.
- Los terminales de la gramática URI son caracteres US-ASCII. Los caracteres ASCII permitidos se almacenan tal cual, y al aplicar percent-encoding a un octeto se usa la forma `pct-encoded = "%" HEXDIG HEXDIG`. No se deben meter directamente como bytes literales caracteres no ASCII.
- Debe incluir obligatoriamente `scheme` y `:`. Las referencias relativas usan [URI-RELATIVE-REF](/es/grammar/value/text/uri-relative-ref/) (números de formato IETF `0x8000` y `0x8001`).
- La producción URI de RFC 3986 no admite la cadena vacía. Un registro de 0 bytes no es válido.
- Dentro de un WORD, el byte superior va primero. Si el número de bytes es impar (código impar), el byte inferior no usado del último WORD debe ser `00`.
- El número de WORD del Payload es `ceil(número de bytes/2)`. Si el código es impar y el byte inferior del último WORD no es `00`, se rechaza.

## Base estándar

- La gramática de `URI`, de los caracteres URI y del percent-encoding sigue [RFC 3986, Uniform Resource Identifier (URI): Generic Syntax](https://www.rfc-editor.org/rfc/rfc3986).
- El par de códigos par/impar, el relleno de ceros, el TAG/Length de GEUL y la disposición en WORD de 16 bits son reglas de framing de este formato.

## Longitud

- El total es el número de WORD que suman el TAG de 1 WORD, el TAG de extensión de Length (si lo hay) y el Payload. Hasta 14 WORD se usa longitud directa y desde 15 WORD longitud extendida `1110`·`1111`, y el TAG de extensión también se incluye en el total ([Length](/es/grammar/record/)).

## Ejemplo

- `https://example.com/` son 20 bytes ASCII (par), por lo que es `URI-EVEN` (`0x44`).
- El Payload son los 10 WORD `6874 7470 733a 2f2f 6578 616d 706c 652e 636f 6d2f`.
- Con TAG 1 WORD y Payload 10 WORD son 11 WORD en total, así que `LLLL=1010`. El total es `0D44 6874 7470 733a 2f2f 6578 616d 706c 652e 636f 6d2f`.

## GEUL Archive URI

`archive.geul.org` es un almacén de contenido inmutable previsto para referenciar desde GEUL contenidos grandes, como binarios y documentos externos. Todavía no está en funcionamiento. El formato de dirección recomendado es `https://archive.geul.org/sha256/{digest}`. Los mismos bytes deben tener el mismo URI, y una vez publicado no se deben cambiar los bytes de ese URI.

El Value URI solo representa la ubicación o la cadena de dirección del contenido externo, y no garantiza la identidad ni la inmutabilidad del objeto en sí. Los binarios y textos que superen el rango máximo de un Value inline pueden referenciarse con un URI de archive. En los metadatos del objeto almacenado se deben registrar los siguientes elementos.

- URI original y momento de recopilación
- SHA-256 y Byte Length
- MIME type
- license identifier y versión
- Autor, procedencia y avisos
- URI del fundamento de la licencia y, si hace falta, una copia del fundamento en el momento de la recopilación

Si se puede recopilar o no se juzga no por si el acceso es gratuito, sino por si el permiso de redistribución está confirmado explícitamente. Hay que respetar las condiciones de licencia aplicables, como atribución, no comercial, sin obras derivadas o compartir igual. En los documentos y contenidos se registra una licencia explícita como Creative Commons y, en el software, si es posible, un SPDX License ID.

Aunque se deje de proporcionar por problemas de derechos o por correcciones, no se deben poner otros bytes en el URI existente. Ese URI debe devolver una tombstone con el motivo y el momento de la interrupción, y conservar el digest original y el registro de auditoría. Sin embargo, si una obligación legal prohíbe conservar el registro de auditoría, prevalece esa obligación.

El URI de archive proporciona juntos la ubicación de acceso y el digest del contenido. Estas reglas de content-address e inmutabilidad son una política del GEUL Archive profile, y la gramática general del Value URI no depende de `archive.geul.org`.
