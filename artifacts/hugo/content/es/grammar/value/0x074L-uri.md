---
title: "URI (0x074L·0x075L)"
weight: 116
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "URI es un Value que contiene una secuencia de bytes ASCII con la gramática de URI de RFC 3986 (URI absoluto con scheme)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

URI es un Value que contiene una secuencia de bytes ASCII con la gramática de URI de RFC 3986 (URI absoluto con scheme). Usa la pareja de códigos de bytes pares e impares 0x074L/0x075L.

| Elemento | Valor |
|---|---|
| Nombre | `URI` (grupo par/impar; el nombre de cada código figura en la tabla de miembros de abajo) |
| TAG ID | `0x074L`·`0x075L` |
| Sección | 3 `0011` (Value), desplazamiento C dentro de la sección = 20~21 |
| Kind | Value · familia: TEXT |
| Descripción del índice | Secuencia de bytes ASCII de la production `URI` de RFC 3986. Bytes pares e impares |
| Lado Hugo | `value/text/uri.md` |

## Miembros {#구성원}

Esta página trata conjuntamente dos códigos que forman una pareja par/impar. El código par es el de valores con un número par de bytes y el impar, el de valores con un número impar de bytes ([Registro y TAG WORD](../record.md#가변-길이-바이트열)). Hay un documento de Codec por código. Los campos de ambos documentos son los mismos; solo difieren el destino de DECLARE y el nombre (BIND).

| TAG ID | Nombre | Número de bytes | Codec ID | Documento de especificación | TAG WORD |
|---|---|---|---|---|---|
| `0x074L` | `URI-EVEN` | par | `0x00000740` | `0x00000000/codecs/0x00000740/` | `0000 0111 0100 LLLL` |
| `0x075L` | `URI-ODD` | impar | `0x00000750` | `0x00000000/codecs/0x00000750/` | `0000 0111 0101 LLLL` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato que recibe (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | resto de valor en bruto (`0xFFFF`) |  |  |

URI es un Value que contiene una secuencia de bytes ASCII con la gramática `URI = scheme ":" hier-part [ "?" query ] [ "#" fragment ]` de RFC 3986. Como incluye el scheme, su interpretación no necesita un base URI.

## Layout {#레이아웃}

- Código: código directo de Value `0x074L` (bytes pares) y `0x075L` (bytes impares). Familia TEXT.
- El número de bytes se determina por el bit menos significativo del Codec y el número de WORD de Payload. Es `2 × número de WORD de Payload − bit menos significativo`, y no hay Byte Count ([Value](_index.md)).

```
TAG WORD          0000 0111 010P LLLL      Codec 0x074L/0x075L
[TAG de extensión de Length] cuando el total es de 15 WORD o más
Payload WORD 1st ... Nth          URI bytes / final zero padding
```

## Interpretación y validez {#해석과-유효성}

- La secuencia de bytes debe ajustarse a la gramática `URI = scheme ":" hier-part [ "?" query ] [ "#" fragment ]` de RFC 3986. Puede incluir query y fragment.
- Los terminales de la gramática de URI son caracteres US-ASCII. Los caracteres ASCII permitidos se almacenan tal cual, y al aplicar percent-encoding a un octeto se usa el formato `pct-encoded = "%" HEXDIG HEXDIG`. No se deben introducir directamente caracteres no ASCII como bytes literales.
- Debe incluir siempre el `scheme` y `:`. Para las referencias relativas se usa [URI-RELATIVE-REF](ietf.geul.org/uri-relative-ref.md) (números de Codec de IETF `0x00008000`·`0x00008001`).
- La production URI de RFC 3986 no admite la cadena vacía. Un registro de 0 bytes no es válido.
- Dentro de un WORD, el byte superior va primero. Si el número de bytes es impar (código impar), el byte inferior no usado del último WORD debe ser `00`.
- El número de WORD de Payload es `ceil(número de bytes/2)`. Si el código es impar y el byte inferior del último WORD no es `00`, se rechaza.

## Fundamento normativo {#표준-근거}

- La gramática de `URI`, los caracteres de URI y el percent-encoding siguen [RFC 3986, Uniform Resource Identifier (URI): Generic Syntax](https://www.rfc-editor.org/rfc/rfc3986).
- La pareja de códigos par/impar, el zero padding y la disposición de TAG/Length de GEUL y WORD de 16 bits son reglas de framing de este formato.

## Longitud {#길이}

- El total es el número de WORD que suman 1 WORD de TAG, el TAG de extensión de Length (si lo hay) y el Payload. Hasta 14 WORD se usa longitud directa; desde 15 WORD se usa la longitud extendida `1110`·`1111`, y el TAG de extensión también se incluye en el total ([Length](../record.md)).

## Ejemplo {#예시}

- `https://example.com/` son 20 bytes ASCII (par), por lo que es `URI-EVEN` (`0x074L`).
- El Payload son 10 WORD: `6874 7470 733A 2F2F 6578 616D 706C 652E 636F 6D2F`.
- Con 1 WORD de TAG y 10 WORD de Payload, el total es de 11 WORD y `LLLL=1010`. El total es `074A 6874 7470 733A 2F2F 6578 616D 706C 652E 636F 6D2F`.

## GEUL Archive URI {#geul-archive-uri}

`archive.geul.org` se concibió como un almacén de contenido inmutable para que GEUL haga referencia a contenidos de gran tamaño, como binarios y documentos externos, y todavía no está en funcionamiento. El formato de dirección recomendado es `https://archive.geul.org/sha256/{digest}`. La misma secuencia de bytes debe tener el mismo URI y, una vez publicado, no se deben cambiar los bytes de ese URI.

Un Value URI solo representa la ubicación o la cadena de dirección de un contenido externo; no garantiza la identidad ni la inmutabilidad del destino en sí. Los binarios y textos que superen el rango máximo de un Value en línea pueden referenciarse mediante un archive URI. Los metadatos del objeto almacenado deben registrar los siguientes elementos.

- URI original y momento de la recopilación
- SHA-256 y Byte Length
- MIME type
- license identifier y version
- autoría, procedencia y avisos
- URI de la base de la licencia y, si es necesario, una copia de esa base en el momento de la recopilación

Para decidir si un contenido puede recopilarse no se atiende a si el acceso es gratuito, sino a si el permiso de redistribución está confirmado de forma explícita. Deben respetarse las condiciones de la licencia aplicable, como atribución, no comercial, sin obra derivada o compartir igual. En documentos y contenidos se registra una licencia explícita como Creative Commons y, en el software, se usa si es posible el SPDX License ID.

Aunque se suspenda la provisión por problemas de derechos o por correcciones, no se deben colocar bytes distintos en el URI existente. Ese URI debe devolver un tombstone con el motivo y el momento de la suspensión, y conservar el digest original y el registro de auditoría. No obstante, si una obligación legal prohíbe conservar el registro de auditoría, prevalece esa obligación.

El archive URI proporciona conjuntamente la ubicación de acceso y el digest del contenido. Estas reglas de content-address e inmutabilidad son política del perfil GEUL Archive, y la gramática general del Value URI no depende de `archive.geul.org`.

## Texto original del documento de especificación {#규격-문서-원문}

Es el aspecto del documento de especificación `0x00000000/codecs/0x00000740/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000074000000000
BODY
#1 DECLARE 0x0740
#2 FIELD #1 rest
#3 BIND #1 "URI-EVEN"
#4 BIND #2 "bytes"
```

Lo anterior es el documento de Codec de `URI-EVEN` (`0x074L`). El documento de Codec del otro miembro (`URI-ODD`) solo difiere en el Codec ID del DOC-ID, el destino de DECLARE y el nombre enlazado en `#1` (BIND).
