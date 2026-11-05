---
title: "UUID (0x07BL)"
weight: 123
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "UUID es un Value de ancho fijo que contiene el valor de 128 bits de un UUID de RFC 9562."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `UUID` (BIND del documento de especificación `UUID`) |
| TAG ID | `0x07BL` |
| Codec ID | `0x000007B0` |
| Documento de especificación | `0x00000000/codecs/0x000007B0/` (destino de DECLARE `07B0`) |
| Sección | 3 `0011` (Value), desplazamiento C dentro de la sección = 27 |
| Kind | Value · familia: BINARY |
| TAG WORD | `0000 0111 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | UUID de 128 bits de RFC 9562 con un Payload fijo de 8 WORD |
| Lado Hugo | `value/binary/uuid.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato que recibe (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `uuid` | #2 | valor en bruto de 8 WORD |  |  |

UUID es un Value de ancho fijo que contiene el valor de 128 bits de un UUID de RFC 9562. Es el código directo de Value `0x07BL`, de la familia BINARY. El Payload es exactamente 8 WORD (16 octetos, 128 bits).

## Layout {#레이아웃}

```
TAG WORD          0x07B8 (0000 0111 1011 1000)  9 WORD en total
Payload           8 WORD (128 bits)  UUID octeto 0 → octeto 15
```

## Interpretación y validez {#해석과-유효성}

- Se agrupan de dos en dos, en orden, los octetos del UUID canónico de RFC 9562, del octeto 0 al octeto 15. El octeto que viene primero es el byte superior de 8 bits del WORD. No se reordenan ni se vuelven a codificar los field, los bits de version ni los bits de variant del UUID.
- La cadena hexadecimal con guiones `8-4-4-4-12` es solo una representación de entrada y salida. Las mayúsculas o minúsculas y los guiones no entran en el Payload, y solo se almacenan los 16 octetos resultantes del análisis.
- Este Value UUID conserva sin pérdida el patrón de 128 bits. En el variant `10xx` de RFC 9562, las versiones 1, 3, 4, 5, 6 y 7 tienen layout estándar y la versión 8 es un formato de UUID personalizado. La versión 2 está reservada para DCE Security y el RFC no fija su layout; la versión 0 es unused y las versiones 9–15 están reservadas para definiciones futuras. Los demás variant también están reservados para compatibilidad o definiciones futuras.
- El UUID Nil es el valor especial de 128 bits todo a cero y el UUID Max es el de 128 bits todo a uno. Tampoco se excluye estructuralmente un patrón de 128 bits que contenga version o variant reservados o unused; el significado de ese patrón y su interoperabilidad se juzgan según el estándar aplicable y el contexto externo.
- La identidad de un UUID se determina por si los valores de 128 bits del Payload son iguales. Que el valor sea igual no garantiza la autenticación, la propiedad, la existencia actual, la posibilidad de resolución ni los permisos de acceso del objeto.
- Al almacenar un GUID COM de Microsoft, no se copia tal cual la representación mixed-endian de memoria o serialización. Primero se convierte a los 16 octetos en el orden canónico de field/octeto de RFC 9562.
- Si el Payload no es exactamente 8 WORD, se rechaza.

## Fundamento normativo {#표준-근거}

- [RFC 9562 — Universally Unique IDentifiers (UUIDs)](https://www.rfc-editor.org/rfc/rfc9562.html) define el UUID como 16 octetos (128 bits) y codifica los field con el byte más significativo primero, de modo que en el formato binario se encadenan en orden de field big-endian. El variant está en los bits superiores del octeto 8 y la version en los 4 bits superiores del octeto 6, y este formato conserva esas posiciones tal cual.
- Las Secciones 4.1–5.10 de RFC 9562 distinguen el variant, las versiones 1–8, Nil, Max y los rangos reservados. RFC 9562 sustituye a RFC 4122, por lo que la norma vigente de este formato es RFC 9562.
- La ABNF hexadecimal con guiones de RFC 9562 es una representación de texto, y el RFC señala aparte la salvedad del little-endian de los GUID COM. GEUL solo coloca en el Payload los 16 octetos canónicos del UUID del RFC.
- El TAG de GEUL, la Length directa y el framing de WORD de 16 bits no forman parte de RFC 9562, sino que son reglas que añade este formato.

## Longitud {#길이}

- El total son exactamente 9 WORD, la suma de 1 WORD de TAG y 8 WORD de Payload, y usa la longitud directa `LLLL=1000`. No hay TAG de extensión de Length, descriptor ni padding.
- Si el Payload no es exactamente 8 WORD, se rechaza.

## Ejemplo {#예시}

Vector de prueba de UUIDv7 del Apéndice A.6 de RFC 9562, `017f22e2-79b0-7cc3-98c4-dc0c0c07398f`:

```
07B8 017F 22E2 79B0 7CC3 98C4 DC0C 0C07 398F
```

- TAG `07B8`, Payload `017F 22E2 79B0 7CC3 98C4 DC0C 0C07 398F`.

## Texto original del documento de especificación {#규격-문서-원문}

Es el aspecto del documento de especificación `0x00000000/codecs/0x000007B0/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007B000000000
BODY
#1 DECLARE 0x07B0
#2 FIELD #1 0x0008
#3 BIND #1 "UUID"
#4 BIND #2 "uuid"
```
