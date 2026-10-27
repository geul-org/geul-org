---
title: "UUID"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "UUID es un Value de 9 WORD fijos que contiene tal cual, en sus 16 octetos canónicos, el valor de 128 bits de un UUID de RFC 9562."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
UUID es un Value de ancho fijo que contiene el valor de 128 bits de un UUID de RFC 9562. Es el código directo de Value `0x60`, familia BINARY. El Payload es exactamente 8 WORD (16 octetos, 128 bits).

## Layout

```
TAG WORD          0x0C60 (0000 1100 0110 0000)  9 WORD en total
Payload           8 WORD (128 bits)  UUID octet 0 → octet 15
```

## Interpretación y validez

- Los octetos canónicos del UUID de RFC 9562, del octet 0 al octet 15, se agrupan en orden de dos en dos octetos. El octeto que va primero son los 8 bits superiores del WORD. No se reordenan ni se vuelven a codificar los field, los version bit ni los variant bit del UUID.
- La cadena hex-and-dash `8-4-4-4-12` es solo una representación de entrada y salida. Las mayúsculas/minúsculas y los guiones no entran en el Payload, y solo se almacenan los 16 octetos resultantes del análisis.
- Este Value UUID conserva sin pérdida el patrón de 128 bits. En el variant `10xx` de RFC 9562, las versiones 1, 3, 4, 5, 6 y 7 son layouts estándar y la versión 8 es un formato de UUID personalizado. La versión 2 está reservada para DCE Security y el RFC no fija su layout; la versión 0 es unused y las versiones 9–15 están reservadas para definiciones futuras. Los demás variants también están reservados para compatibilidad o definiciones futuras.
- El Nil UUID es el valor especial con los 128 bits a cero, y el Max UUID, con los 128 bits a uno. Tampoco se excluye estructuralmente ningún patrón de 128 bits, incluidos los de versión/variant reservados o unused; el significado y la interoperabilidad de esos patrones se juzgan según el estándar aplicable y el contexto externo.
- La identidad de un UUID se juzga por si el valor de 128 bits del Payload es el mismo. Que el valor sea el mismo no garantiza la autenticación, la propiedad, la existencia actual, la resolubilidad ni los permisos de acceso del objeto.
- Al almacenar un GUID COM de Microsoft, no se copia tal cual su representación mixed-endian en memoria o serializada. Primero se convierte a 16 octetos en el orden canónico de campos/octetos de RFC 9562.
- Si el Payload no es exactamente de 8 WORD, se rechaza.

## Base estándar

- [RFC 9562 — Universally Unique IDentifiers (UUIDs)](https://www.rfc-editor.org/rfc/rfc9562.html) define el UUID como 16 octetos (128 bits), codifica los campos most-significant-byte-first y los encadena en orden de campos big-endian en el formato binario. El variant está en los bits superiores del octet 8 y la versión en los 4 bits superiores del octet 6; este formato conserva esas posiciones tal cual.
- Las secciones 4.1–5.10 de RFC 9562 distinguen el variant, las versiones 1–8, Nil, Max y los rangos reservados. Como RFC 9562 sustituye a RFC 4122, la norma vigente de este formato es RFC 9562.
- La ABNF hex-and-dash de RFC 9562 es una representación de texto, y el RFC también señala aparte la salvedad little-endian del GUID COM. GEUL pone en el Payload solo los 16 octetos canónicos del UUID del RFC.
- El TAG de GEUL, el Length directo y el framing en WORD de 16 bits son reglas que añade este formato, no parte de RFC 9562.

## Longitud

- El total es exactamente 9 WORD: TAG 1 WORD y Payload 8 WORD, y se usa la longitud directa `LLLL=1000`. No hay TAG de extensión de Length, descriptor ni relleno.
- Si el Payload no es exactamente de 8 WORD, se rechaza.

## Ejemplo

El test vector de UUIDv7 del Appendix A.6 de RFC 9562, `017f22e2-79b0-7cc3-98c4-dc0c0c07398f`:

```
0c60 017f 22e2 79b0 7cc3 98c4 dc0c 0c07 398f
```

- TAG `0c60`, Payload `017f 22e2 79b0 7cc3 98c4 dc0c 0c07 398f`.
