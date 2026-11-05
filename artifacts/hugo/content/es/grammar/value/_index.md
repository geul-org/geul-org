---
title: "Value"
weight: 100
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text", "decimal", "time"]
summary: "Value es el registro que contiene el propio valor."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Value es el registro que contiene el propio valor. El Codec determina la interpretación del Payload.

## Layout {#레이아웃}

```
TAG WORD          000K KKKC CCCC LLLL      secciones 3·4 (0x060L~0x09FL)
[TAG de extensión de Length]
[TAG de extensión de Codec]  cuando es un formato de Issuer
Payload
```

- `LLLL` es el número total de WORD, incluido el TAG WORD, menos 1. De 1 a 14 WORD es longitud directa y desde 15 WORD es longitud extendida.
- Si es un formato de Issuer, el TAG de extensión de Codec contiene el Issuer (con el ancho de 2/4/16 WORD que determina el Codec) y un número de Codec de 2 WORD. El número de Codec lo determina el Issuer.
- Un decodificador, aunque no conozca el formato, llega hasta Kind, Length, Issuer y número de Codec.

## Familia {#계열}

El número de un Value no indica la familia. Los códigos directos no expresan la familia mediante bits, y los formatos de Issuer tampoco tienen reglas de familia. La familia es una agrupación temática.

| Familia | Códigos directos |
|---|---|
| NUMERIC | `0x060L~0x067L` |
| DECIMAL | `0x068L~0x069L` |
| TIME | `0x06AL~0x071L`, `0x081L` |
| TEXT | `0x072L~0x07AL` |
| BINARY | `0x07BL~0x080L` |

- Los valores numéricos como vectores, tensores, números complejos, fracciones e intervalos son NUMERIC. Como excepción, BIT-VECTOR es BINARY. Los códigos de idioma son TEXT.
- A los registros de formato de Issuer se les añade un TAG de extensión de Codec (Issuer y número de Codec). Si el Payload es largo (15 WORD o más en total), se usa un TAG de extensión de Length.

## Código directo {#직접-코드}

| Codec | Nombre | Familia | Descripción |
|---|---|---|---|
| `0x060L` | [BOOL](0x060L-bool.md) | NUMERIC | false o true |
| `0x061L` | [SIGNED-INTEGER](0x061L-signed-integer.md) | NUMERIC | entero en complemento a dos con el mínimo de WORD |
| `0x062L` | [UNSIGNED-INTEGER](0x062L-unsigned-integer.md) | NUMERIC | entero sin signo con el mínimo de WORD |
| `0x063L` | [BINARY-FLOAT](0x063L-binary-float.md) | NUMERIC | IEEE 754 binary16/32/64/128 |
| `0x064L` | [COORDINATE-EARTH](0x064L-coordinate-earth.md) | NUMERIC | latitud y longitud de la Tierra (WGS 84) e incertidumbre (Reference de unidad) |
| `0x065L` | [COORDINATE-GEO](0x065L-coordinate-geo.md) | NUMERIC | Reference de cuerpo celeste, latitud y longitud e incertidumbre (Reference de unidad) |
| `0x066L` | [QUANTITY](0x066L-quantity.md) | NUMERIC | cantidad numérica (entero, BINARY-FLOAT, decimal, fracción), Reference de unidad, límite inferior y superior |
| `0x067L` | [FRACTION](0x067L-fraction.md) | NUMERIC | fracción que conserva la notación (registros de numerador y denominador, sin simplificar) |
| `0x068L` | [SIGNED-DECIMAL](0x068L-signed-decimal.md) | DECIMAL | `C × 10^E`, coeficiente con signo |
| `0x069L` | [UNSIGNED-DECIMAL](0x069L-unsigned-decimal.md) | DECIMAL | `C × 10^E`, coeficiente sin signo |
| `0x06AL` | [GREGORIAN-DATE](0x06AL-gregorian-date.md) | TIME | número de días desde 1970-01-01 (calendario gregoriano) |
| `0x06BL` | [CIVIL-TIME-NANOSECONDS](0x06BL-civil-time-nanoseconds.md) | TIME | nanosegundos desde la medianoche |
| `0x06CL` | [POSIX-TIMESTAMP-SECONDS](0x06CL-posix-timestamp-seconds.md) | TIME | segundos desde el Unix epoch |
| `0x06DL` | [DURATION-SECONDS](0x06DL-duration-seconds.md) | TIME | tiempo transcurrido (segundos) |
| `0x06EL`/`0x06FL` | [EDTF](0x06EL-edtf.md) | TIME | cadena de fecha extendida de ISO 8601-2 (precisión de año y mes, incertidumbre, intervalo) |
| `0x070L`/`0x071L` | [GEDCOM-DATE](0x070L-gedcom-date.md) | TIME | cadena de fecha de GEDCOM 7 (otros calendarios como el juliano) |
| `0x072L`/`0x073L` | [UTF8-TEXT](0x072L-utf8-text.md) | TEXT | cadena UTF-8 sin idioma |
| `0x074L`/`0x075L` | [URI](0x074L-uri.md) | TEXT | URI de RFC 3986 |
| `0x076L`/`0x077L` | [LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md) | TEXT | language tag BCP 47 |
| `0x078L`/`0x079L` | [UTF8-LANGUAGE-TEXT](0x078L-utf8-language-text.md) | TEXT | texto con idioma |
| `0x07AL` | [LANGUAGE-SHORT-CODE](0x07AL-language-short-code.md) | TEXT | código de idioma comprimido de 1 WORD |
| `0x07BL` | [UUID](0x07BL-uuid.md) | BINARY | UUID de RFC 9562 |
| `0x07CL` | [SHA-256-DIGEST](0x07CL-sha-256-digest.md) | BINARY | resultado de SHA-256 |
| `0x07DL` | [SHA1-DIGEST](0x07DL-sha1-digest.md) | BINARY | resultado de SHA-1 (con fines de identificación, como los ID de objeto de git) |
| `0x07EL`/`0x07FL` | [OPAQUE-BYTES](0x07EL-opaque-bytes.md) | BINARY | secuencia de bytes de significado y formato desconocidos. Bytes pares e impares |
| `0x080L` | [BIT-VECTOR](0x080L-bit-vector.md) | BINARY | N bits almacenados MSB-first tras el bit-count |
| `0x081L` | [DURATION-NANOSECONDS](0x081L-duration-nanoseconds.md) | TIME | tiempo transcurrido (nanosegundos) |

- Los códigos emparejados como par/impar son secuencias de bytes de longitud variable. El código par es el de bytes en número par y el impar, el de bytes en número impar ([Registro y TAG WORD](../record.md)).
- Los códigos directos están en `0x060L~0x081L` sin Reserved. `0x082L~0x09CL` es Reserved y `0x09DL~0x09FL` son [VALUE-ISSUER-2WORD](0x09DL-value-issuer-2word.md)·[4WORD](0x09EL-value-issuer-4word.md)·[16WORD](0x09FL-value-issuer-16word.md).

## Formato de Issuer {#issuer-형식}

Los formatos que no están en los códigos directos se colocan como número de Codec bajo el Issuer de la organización que los promulgó. Los formatos de convención sin organización promulgadora se colocan bajo ADHOC (`0x00000002`). Los formatos propios de GEUL (OPAQUE-BYTES, BIT-VECTOR, DURATION-NANOSECONDS) son códigos directos.

| Issuer | Ejemplos de formato |
|---|---|
| ADHOC `0x00000002` | BFLOAT16, vectores de enteros y reales, tensores, números complejos, fracciones, intervalos, cuaterniones, BLAKE3 |
| IETF `0x00000007` | URI relativo, CRC32C, direcciones IPv4·IPv6 |
| IEEE `0x0000000D` | IEEE 754 decimal32/64/128, marca de tiempo POSIX en nanosegundos, dirección MAC |
| KHRONOS `0x0000000E` | píxeles RGBA8·BGRA8 |
| ONNX `0x00000010`, OCP `0x00000011` | FP8, FP4 |
| BIPM `0x00000013` | marca de tiempo TAI |
| NIST `0x00000015` | SHA-512, SHA3-256 |
| GPS `0x00000016` | marca de tiempo GPS |

- Un decodificador que no conoce el formato llega hasta el Issuer y el número de Codec, y salta el resto con Length.
- El documento de Codec se coloca bajo el `codecs/` de ese Issuer con el número de Codec del registro. Ejemplo: el CRC32C de IETF está en `0x00000007/codecs/0x0000C000/` ([dirección de publicación y lista de versiones](../publishing.md)).
- Para valores grandes como imágenes y vídeos, se recomienda referenciarlos mediante URI y SHA-256 en lugar de incluirlos directamente.
- Las obras contenidas en una secuencia de bytes siguen su licencia original. La procedencia y la licencia se registran con Meta.

## Grupos de formatos {#형식-묶음}

La descripción de cada grupo está más abajo. El layout, la interpretación, la validez y los ejemplos de cada formato están en el documento de cada formato.

| Grupo | Familia | Formatos |
|---|---|---|
| [numeric](#numeric) | NUMERIC | BOOL, enteros, coma flotante, coordenadas, QUANTITY, FRACTION |
| [decimal](#decimal) | DECIMAL | SIGNED-DECIMAL, UNSIGNED-DECIMAL, IEEE 754 decimal32/64/128 |
| [time](#time) | TIME | fechas, horas, marcas de tiempo, tiempo transcurrido, EDTF, fechas GEDCOM |
| [text](#text) | TEXT | texto UTF-8, texto con idioma, URI, códigos de idioma |
| [binary](#binary) | BINARY | UUID, digests, CRC, direcciones de red, secuencias de bytes desconocidas, vectores de bits |
| [vector](#vector) | NUMERIC | vectores densos de enteros y reales, puntos y cajas delimitadoras, píxeles RGBA·BGRA |
| [tensor](#tensor) | NUMERIC | tensores dense·packed con formato, rank y shape |
| [etc](#etc) | NUMERIC | números complejos, fracciones, intervalos cerrados, cuaterniones |

- Los grupos vector, tensor y etc son todos formatos de Issuer (ADHOC, KHRONOS) de la familia NUMERIC.

### numeric {#numeric}

Son los formatos numéricos básicos de la familia NUMERIC. Se colocan en los códigos directos `0x060L~0x067L`.

- Hay BOOL, enteros con y sin signo, coma flotante binary de IEEE 754, coordenadas de la Tierra (WGS 84) y de cuerpos celestes, QUANTITY, que agrupa cantidad, unidad y límites, y FRACTION, una fracción con su notación original.
- Los enteros se escriben con el mínimo de WORD en que quepa el valor.
- Los formatos de Issuer escalares pequeños (BFLOAT16, FP8, FP4) solo tienen asignado el número de Codec y no tienen especificación detallada (problema abierto de [Value](#열린-문제)).
- Los vectores, tensores, números complejos, fracciones irreducibles (RATIONAL-I64) e intervalos también son de la familia NUMERIC, pero como son formatos de Issuer se colocan en los grupos [vector](#vector), [tensor](#tensor) y [etc](#etc).

### decimal {#decimal}

La familia DECIMAL son los formatos de decimales exactos. Se colocan en los códigos directos `0x068L~0x069L`.

- Los códigos directos SIGNED-DECIMAL y UNSIGNED-DECIMAL se escriben como `C × 10^E` y contienen tal cual el número de dígitos de la notación original. `1.20` (`C=120, E=−2`) y `1.2` (`C=12, E=−1`) son registros distintos. La equivalencia de valor y la conservación del quantum son un problema abierto de [SIGNED-DECIMAL](0x068L-signed-decimal.md#열린-문제).
- Las codificaciones DPD·BID de IEEE 754 decimal32/64/128 son formatos del Issuer IEEE (`0x0000000D`).

### time {#time}

La familia TIME son los formatos de fecha y hora. Se colocan en los códigos directos `0x06AL~0x071L` y `0x081L` (DURATION-NANOSECONDS).

| Precisión | Formato |
|---|---|
| Fecha (calendario gregoriano) | GREGORIAN-DATE |
| Año y mes, incertidumbre, intervalo | EDTF |
| Notación original de otro calendario (juliano, etc.) | GEDCOM-DATE |
| Hora | marcas de tiempo POSIX·TAI·GPS |
| Tiempo transcurrido | DURATION-SECONDS, DURATION-NANOSECONDS |

- Una fecha que se pueda escribir con GREGORIAN-DATE no se escribe con EDTF.
- Las marcas de tiempo en nanosegundos y los formatos TAI·GPS son formatos bajo el Issuer de cada organización de normalización (IEEE, BIPM, GPS).

### text {#text}

La familia TEXT son los formatos de texto e identificadores de cadena. Se colocan en los códigos directos `0x072L~0x07AL`.

- La cadena sin idioma es UTF8-TEXT, y el texto con idioma, como nombres, títulos y oraciones, es UTF8-LANGUAGE-TEXT.
- Los códigos de idioma (LANGUAGE-SHORT-CODE, LANGUAGE-BCP47-CODE) también son de la familia TEXT.
- Las secuencias de bytes de longitud variable se colocan en parejas de Codec par/impar. Si el bit menos significativo es `1`, el número de bytes es impar y el byte inferior del último WORD es relleno `0x00` ([Registro y TAG WORD](../record.md)).

### binary {#binary}

La familia BINARY son los formatos de secuencias de bytes. Se colocan en los códigos directos `0x07BL~0x080L`.

- UUID, SHA-256, SHA-1, la secuencia de bytes desconocida (OPAQUE-BYTES) y el vector de bits (BIT-VECTOR) son códigos directos. El resto de digests, CRC32C y las direcciones IPv4·IPv6·MAC son formatos de Issuer.
- Los valores de tamaño fijo (UUID, digests, direcciones) tienen el tamaño determinado, por lo que no tienen pareja par/impar.
- Los medios públicos como imágenes y vídeos se colocan como formatos del Issuer IANA (`0x00000008`). Los números de Codec se asignan en parejas par/impar y el Payload es una secuencia de bytes. El límite superior de Length es 2^32−1 WORD. Para valores grandes se recomienda referenciarlos mediante URI y SHA-256 en lugar de incluirlos directamente.
- Las obras contenidas en una secuencia de bytes siguen su licencia original. La procedencia y la licencia se registran con Meta.

### vector {#vector}

Los formatos de vector son formatos de Issuer de la familia NUMERIC. Los vectores densos de enteros y reales y los puntos y cajas delimitadoras se colocan en ADHOC (`0x00000002`) con los números de Codec `0x00000500`~`0x0000050C`, y los formatos de píxel bajo KHRONOS (`0x0000000E`).

- Los elementos de un vector denso se almacenan de forma contigua en big-endian.
- Al ser formatos de Issuer, el TAG de extensión de Codec lleva el Issuer de 2 WORD y el número de Codec de 2 WORD.

### tensor {#tensor}

Los formatos de tensor son formatos de Issuer de la familia NUMERIC. Se colocan en ADHOC (`0x00000002`) con los números de Codec `0x00000600`~`0x00000601`.

- DESCRIBED-DENSE-TENSOR contiene el formato de los elementos, el rank, el shape y un payload dense C-contiguous.
- DESCRIBED-PACKED-TENSOR contiene el formato packed, el rank, el shape y un payload packed low-bit-first dentro de un octeto.

### etc {#etc}

Los demás formatos numéricos son formatos de Issuer de la familia NUMERIC. Se colocan en ADHOC (`0x00000002`) con los números de Codec `0x00000700`~`0x00000704`.

- Hay números complejos (COMPLEX64, COMPLEX128), fracciones normalizadas (RATIONAL-I64), intervalos cerrados binary64 y cuaterniones binary32.

## Texto {#텍스트}

Un texto con idioma y uno sin idioma son valores distintos. "Paris" (cadena) y "Paris" (en francés) no son iguales.

| Formato | Dónde se usa |
|---|---|
| UTF8-TEXT | cadenas sin idioma, como identificadores, códigos, nombres de archivo e ID externos |
| UTF8-LANGUAGE-TEXT | textos con idioma, como nombres, títulos y oraciones |

```
UTF8-LANGUAGE-TEXT
TAG WORD          0000 0111 100P LLLL   (P = el texto tiene bytes impares)
[TAG de extensión de Length]
Idioma            registro LANGUAGE-SHORT-CODE o LANGUAGE-BCP47-CODE
Texto             bytes UTF-8 (si es impar, el último es 0x00)
```

- El texto es UTF-8 bien formado y se conserva tal cual el original. La normalización la hace quien compara o indexa.
- Para un nombre común a varios idiomas se usa el idioma `mul`, y para el idioma indeterminado, `und`. Una cadena sin contenido lingüístico es UTF8-TEXT.

Ejemplo: `"Douglas Adams"@en` (13 bytes, impar)

```
0799  0761 656E  446F 7567 6C61 7320 4164 616D 7300
TAG   idioma en  D o  u g  l a  s ␠  A d  a m  s (relleno)
```

## Decimales y cantidades {#10진수와-수량}

Un decimal exacto se escribe como `C × 10^E`. El exponente `E` es de 32 bits y el coeficiente `C` es un complemento a dos con el mínimo de WORD. Contiene tal cual el número de dígitos de la notación original: `1.20` es `C=120, E=−2` y `1.2` es `C=12, E=−1`. Ambas notaciones representan el mismo número, pero son registros distintos con bytes distintos. El codificador no normaliza la notación a su arbitrio. La equivalencia de valor de los dos registros y el significado del quantum (cifras significativas) son un problema abierto ([SIGNED-DECIMAL](0x068L-signed-decimal.md#열린-문제)).

QUANTITY contiene en un solo valor la cantidad, la unidad y los límites.

```
TAG WORD          0000 0110 0110 LLLL
[TAG de extensión de Length]
Cantidad          registro de Value numérico (entero, BINARY-FLOAT, decimal, fracción)
Unidad            registro Reference (elemento de unidad); si no hay unidad, 0x0000
Límite inferior   registro de Value numérico; si se omite, 0x0000 ABSENT
Límite superior   registro de Value numérico; si se omite, 0x0000 ABSENT
```

- La unidad es parte del valor. No se separa la unidad para anotarla en otro lugar (si se separa, no se sabe si `652` son km o m).
- No se incluye el valor convertido a unidades del SI. Se puede calcular a partir de la unidad y la tabla de conversión.
- `0x0000` es la marca ABSENT que indica que se ha omitido un campo opcional ([documento de especificación de Codec](../codec-spec.md)).

Ejemplo: `652 km`, rango `[651, 653]` (km = Q828224 de Wikidata)

```
066E 0011                    TAG (longitud extendida de 17 WORD)
0683 0000 0000 028C          cantidad 652
0142 000C A340               unidad Q828224
0683 0000 0000 028B          límite inferior 651
0683 0000 0000 028D          límite superior 653
```

## Fecha {#날짜}

| Precisión | Formato |
|---|---|
| Fecha (calendario gregoriano) | GREGORIAN-DATE |
| Año y mes, incertidumbre (`1971~`), intervalo | EDTF |
| Notación original de otro calendario (juliano, etc.) | GEDCOM-DATE |
| Hora | marcas de tiempo POSIX·TAI·GPS |

- Una fecha que se pueda escribir con GREGORIAN-DATE no se escribe con EDTF.

## Problemas abiertos {#열린-문제}

- Los formatos de medios públicos (JPEG, PNG, MP4, MOV, etc.) se colocan con números de Codec del Issuer IANA (`0x00000008`). Cómo gestionar la tabla de correspondencias entre tipos de medios y números de Codec.
- La lista final de códigos directos de Value. Se determinará midiendo la frecuencia de Value en muestras de leyes y de conversaciones de trabajo (candidatos: importes, porcentajes, intervalos de fechas).
- La especificación detallada y la ubicación de los 7 escalares pequeños (BFLOAT16 de ADHOC, 4 FP8 de ONNX, FP8-E8M0FNU y FP4-E2M1FN de OCP). No se ha decidido si trasladarlos a códigos directos. Por ahora solo tienen asignado el número de Codec.
