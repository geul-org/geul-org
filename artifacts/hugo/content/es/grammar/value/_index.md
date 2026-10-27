---
title: "Value"
weight: 50
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-28T12:00:00+09:00
tags: ["grammar", "value", "text", "decimal", "time"]
summary: "Value es un registro que contiene un valor en sí. Los 2 bits superiores del Codec son la familia (números·decimales, tiempo, texto, binario); los formatos de uso frecuente son códigos directos y los demás son formatos Issuer por organismo de normalización."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
Value es un registro que contiene un valor en sí. El Codec fija la interpretación del Payload.

## Layout

```
TAG WORD          0000 1LLL LCCC CCCC
[TAG de extensión de Length]
[TAG de extensión de Codec]  si es formato Issuer
Payload
```

- `LLLL` es el número total de WORD, incluido el TAG WORD, menos 1. De 1 a 14 WORD es longitud directa y de 15 WORD en adelante, longitud extendida.
- Si es un formato Issuer, el TAG de extensión de Codec lleva el Issuer (ancho que fija el Codec: 1/2/4/16 WORD) y 1 WORD de número de formato. Los 2 bits superiores del número de formato son la familia.
- El decodificador conoce la familia y el Length aunque no conozca el formato.

## Familias

Los 2 bits superiores del Codec son la familia. El código directo (7 bits) y el número de formato Issuer (16 bits) siguen la misma regla. Por eso la familia se conoce sin libro de códigos.

| 2 bits superiores | Familia | Código directo | Número de formato |
|---|---|---|---|
| `00` | NUMERIC / DECIMAL | `0x00`~`0x1F` | `0x0000`~`0x3FFF` |
| `01` | TIME | `0x20`~`0x3F` | `0x4000`~`0x7FFF` |
| `10` | TEXT | `0x40`~`0x5F` | `0x8000`~`0xBFFF` |
| `11` | BINARY | `0x60`~`0x7B` | `0xC000`~`0xFFFF` |

- NUMERIC / DECIMAL se subdivide con el tercer bit. `000` es NUMERIC y `001` es DECIMAL.
- Los valores numéricos como vectores, tensores, complejos, fracciones e intervalos son NUMERIC. Como excepción, BIT-VECTOR es BINARY. Los códigos de idioma son TEXT.
- Los registros de formato Issuer llevan un TAG de extensión de Codec (Issuer y número de formato). Si el Payload es largo (15 WORD o más en total), se usa el TAG de extensión de Length.

## Códigos directos

| Codec | Nombre | Familia | Descripción |
|---|---|---|---|
| `0x00` | [BOOL](/es/grammar/value/numeric/bool/) | NUMERIC | false o true |
| `0x01` | [SIGNED-INTEGER](/es/grammar/value/numeric/signed-integer/) | NUMERIC | Entero en complemento a dos de WORD mínimos |
| `0x02` | [UNSIGNED-INTEGER](/es/grammar/value/numeric/unsigned-integer/) | NUMERIC | Entero sin signo de WORD mínimos |
| `0x03` | [BINARY-FLOAT](/es/grammar/value/numeric/binary-float/) | NUMERIC | IEEE 754 binary16/32/64/128 |
| `0x04` | [COORDINATE-EARTH](/es/grammar/value/numeric/coordinate-earth/) | NUMERIC | Latitud y longitud de la Tierra (WGS 84) e incertidumbre (Reference de unidad) |
| `0x05` | [COORDINATE-GEO](/es/grammar/value/numeric/coordinate-geo/) | NUMERIC | Reference de un cuerpo celeste, latitud y longitud, e incertidumbre (Reference de unidad) |
| `0x06` | [QUANTITY](/es/grammar/value/numeric/quantity/) | NUMERIC | Cantidad numérica (entero, BINARY-FLOAT, decimal, fracción), Reference de unidad, límites inferior y superior |
| `0x07` | [FRACTION](/es/grammar/value/numeric/fraction/) | NUMERIC | Fracción que conserva su notación (registros de numerador y denominador, sin simplificar) |
| `0x10` | [SIGNED-DECIMAL](/es/grammar/value/decimal/signed-decimal/) | DECIMAL | `C × 10^E`, coeficiente con signo |
| `0x11` | [UNSIGNED-DECIMAL](/es/grammar/value/decimal/unsigned-decimal/) | DECIMAL | `C × 10^E`, coeficiente sin signo |
| `0x20` | [GREGORIAN-DATE](/es/grammar/value/time/gregorian-date/) | TIME | Número de días desde 1970-01-01 (calendario gregoriano) |
| `0x21` | [CIVIL-TIME-NANOSECONDS](/es/grammar/value/time/civil-time-nanoseconds/) | TIME | Nanosegundos desde la medianoche |
| `0x22` | [POSIX-TIMESTAMP-SECONDS](/es/grammar/value/time/posix-timestamp-seconds/) | TIME | Segundos desde el Unix epoch |
| `0x23` | [DURATION-SECONDS](/es/grammar/value/time/duration-seconds/) | TIME | Tiempo transcurrido (segundos) |
| `0x24`/`0x25` | [EDTF](/es/grammar/value/time/edtf/) | TIME | Cadena de fecha extendida de ISO 8601-2 (precisión de año·mes, incertidumbre, intervalos) |
| `0x26`/`0x27` | [GEDCOM-DATE](/es/grammar/value/time/gedcom-date/) | TIME | Cadena de fecha de GEDCOM 7 (otros calendarios como el juliano) |
| `0x40`/`0x41` | [UTF8-TEXT](/es/grammar/value/text/utf8-text/) | TEXT | Cadena UTF-8 sin idioma |
| `0x44`/`0x45` | [URI](/es/grammar/value/text/uri/) | TEXT | URI de RFC 3986 |
| `0x46`/`0x47` | [LANGUAGE-BCP47-CODE](/es/grammar/value/text/language-bcp47-code/) | TEXT | Etiqueta de idioma BCP 47 |
| `0x48` | [LANGUAGE-SHORT-CODE](/es/grammar/value/text/language-short-code/) | TEXT | Código de idioma comprimido de 1 WORD |
| `0x4A`/`0x4B` | [UTF8-LANGUAGE-TEXT](/es/grammar/value/text/utf8-language-text/) | TEXT | Texto con idioma |
| `0x60` | [UUID](/es/grammar/value/binary/uuid/) | BINARY | UUID de RFC 9562 |
| `0x61` | [SHA-256-DIGEST](/es/grammar/value/binary/sha-256-digest/) | BINARY | Resultado de SHA-256 |
| `0x62` | [SHA1-DIGEST](/es/grammar/value/binary/sha1-digest/) | BINARY | Resultado de SHA-1 (para identificación, como los ID de objeto de git) |

- Los códigos emparejados en par/impar son bytes de longitud variable. El código par tiene un número par de bytes y el impar, un número impar ([Registro y TAG WORD](/es/grammar/record/)).
- Los códigos directos que no figuran en la tabla están reservados.

## Formatos Issuer

Los formatos que no figuran entre los códigos directos se colocan con un número de formato bajo el Issuer del organismo que promulgó el formato. Los formatos de uso común sin organismo promulgador se colocan bajo ADHOC (`0x0001`), y los formatos propios de GEUL, bajo GEUL (`0x0000`).

| Issuer | Ejemplos de formato |
|---|---|
| GEUL `0x0000` | DURATION-NANOSECONDS, OPAQUE-BYTES, BIT-VECTOR |
| ADHOC `0x0001` | BFLOAT16, vectores de enteros·reales, tensores, complejos, fracciones, intervalos, cuaterniones, BLAKE3 |
| IETF `0x0020` | URI relativo, CRC32C, direcciones IPv4·IPv6 |
| IEEE `0x0040` | IEEE 754 decimal32/64/128, marca de tiempo POSIX en nanosegundos, dirección MAC |
| KHRONOS `0x0041` | Píxeles RGBA8·BGRA8 |
| ONNX `0x0043`, OCP `0x0044` | FP8, FP4 |
| BIPM `0x0060` | Marca de tiempo TAI |
| NIST `0x0062` | SHA-512, SHA3-256 |
| GPS `0x0063` | Marca de tiempo GPS |

- Un decodificador que no conozca el formato solo sabe la familia por el número de formato y salta el Payload.
- Para valores grandes como imágenes y vídeo se recomienda referenciarlos con URI y SHA-256 en lugar de incluirlos directamente.
- Las obras contenidas en los bytes siguen su licencia original. La procedencia y la licencia se registran con Meta.

## Conjuntos de formatos

El layout, la interpretación, la validez y los ejemplos de cada formato están en el documento de cada conjunto.

| Conjunto | Familia | Formatos |
|---|---|---|
| [numeric](/es/grammar/value/numeric/) | NUMERIC | BOOL, enteros, punto flotante, coordenadas, QUANTITY, FRACTION |
| [decimal](/es/grammar/value/decimal/) | DECIMAL | SIGNED-DECIMAL, UNSIGNED-DECIMAL, IEEE 754 decimal32/64/128 |
| [time](/es/grammar/value/time/) | TIME | Fechas, horas, marcas de tiempo, tiempo transcurrido, EDTF, fechas GEDCOM |
| [text](/es/grammar/value/text/) | TEXT | Texto UTF-8, texto con idioma, URI, códigos de idioma |
| [binary](/es/grammar/value/binary/) | BINARY | UUID, digests, CRC, direcciones de red, bytes desconocidos, vectores de bits |
| [vector](/es/grammar/value/vector/) | NUMERIC | Vectores densos de enteros·reales, puntos·cajas delimitadoras, píxeles RGBA·BGRA |
| [tensor](/es/grammar/value/tensor/) | NUMERIC | Tensores dense·packed con formato, rank y shape |
| [etc](/es/grammar/value/etc/) | NUMERIC | Complejos, fracciones, intervalos cerrados, cuaterniones |

- Los conjuntos vector, tensor y etc son todos formatos Issuer de la familia NUMERIC (ADHOC, KHRONOS).

## Texto

Un texto con idioma y uno sin idioma son valores distintos. "Paris" (cadena) y "Paris" (francés) no son iguales.

| Formato | Dónde se usa |
|---|---|
| UTF8-TEXT | Cadenas sin idioma, como identificadores, códigos, nombres de archivo e ID externos |
| UTF8-LANGUAGE-TEXT | Textos con idioma, como nombres, títulos y frases |

```
UTF8-LANGUAGE-TEXT
TAG WORD          0000 1LLL L100 101P   (P = el texto tiene un número impar de bytes)
[TAG de extensión de Length]
Idioma            registro LANGUAGE-SHORT-CODE o LANGUAGE-BCP47-CODE
Texto             bytes UTF-8 (si es impar, el último 0x00)
```

- El texto es UTF-8 bien formado y se conserva tal cual el original. La normalización la hace quien compara o indexa.
- Un nombre común a varios idiomas se escribe con el idioma `mul`, y un idioma sin determinar, con `und`. Una cadena sin contenido de idioma es UTF8-TEXT.

Ejemplo: `"Douglas Adams"@en` (13 bytes, impar)

```
0CCB  08C6 656E  446F 7567 6C61 7320 4164 616D 7300
TAG   idioma en  D o  u g  l a  s ␠  A d  a m  s (relleno)
```

## Decimales y cantidades

Un decimal exacto se escribe como `C × 10^E`. El exponente `E` es de 32 bits y el coeficiente `C` es un complemento a dos de WORD mínimos. Se conservan tal cual los dígitos de la notación original: `1.20` es `C=120, E=−2` y `1.2` es `C=12, E=−1`. Las dos notaciones representan el mismo número pero son registros distintos con bytes distintos. El codificador no normaliza la notación a su criterio. La equivalencia de valor de dos registros y el significado del quantum (cifras significativas) son problemas abiertos ([SIGNED-DECIMAL](/es/grammar/value/decimal/signed-decimal/#problemas-abiertos)).

QUANTITY contiene la cantidad, la unidad y los límites en un solo valor.

```
TAG WORD          0000 1LLL L000 0110
[TAG de extensión de Length]
Cantidad          registro Value numérico (entero, BINARY-FLOAT, decimal, fracción)
Unidad            registro Reference (elemento de unidad); si no hay unidad, 0x0000
Límite inferior   registro Value numérico; si se omite, 0x0000 ABSENT
Límite superior   registro Value numérico; si se omite, 0x0000 ABSENT
```

- La unidad forma parte del valor. No se anota aparte en otro lugar (si se separa, no se sabe si `652` son km o m).
- No se incluye el valor convertido a unidades SI. Se puede calcular a partir de la unidad y de la tabla de conversión.
- `0x0000` es ABSENT, la marca de que se omitió un campo opcional ([Documento de especificación de Codec](/es/grammar/codec-spec/)).

Ejemplo: `652 km`, rango `[651, 653]` (km = Q828224 de Wikidata)

```
0F06 0011                    TAG (longitud extendida 17 WORD)
0990 0000 0000 028C          cantidad 652
0120 000C A340               unidad Q828224
0990 0000 0000 028B          límite inferior 651
0990 0000 0000 028D          límite superior 653
```

## Fechas

| Precisión | Formato |
|---|---|
| Fecha (calendario gregoriano) | GREGORIAN-DATE |
| Año·mes, incierta (`1971~`), intervalo | EDTF |
| Notación original de otros calendarios (juliano, etc.) | GEDCOM-DATE |
| Hora | Marcas de tiempo POSIX·TAI·GPS |

- Una fecha que se pueda escribir con GREGORIAN-DATE no se escribe con EDTF.

## Problemas abiertos

- Los formatos de medios públicos (JPEG, PNG, MP4, MOV, etc.) se colocan con un número de formato BINARY del Issuer IANA (`0x0021`). Cómo gestionar la tabla de correspondencia entre tipo de medio y número de formato.
- La lista final de códigos directos de Value. Se fijará midiendo la frecuencia de Value en muestras de leyes y conversaciones de negocio (candidatos: importes, porcentajes, intervalos de fechas).
- La especificación detallada y la ubicación de los 7 escalares pequeños (ADHOC BFLOAT16, ONNX FP8 ×4, OCP FP8-E8M0FNU·FP4-E2M1FN). No se ha decidido si pasarlos al tramo reservado de códigos directos NUMERIC (`0x08`~`0x0F`). Por ahora solo tienen asignado el número de formato.
