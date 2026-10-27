---
title: "BINARY-FLOAT"
weight: 4
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "BINARY-FLOAT es un Value que contiene tal cual la cadena de bits de interchange IEEE 754 binary16/32/64/128."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
BINARY-FLOAT es un Value que representa un escalar binary interchange de IEEE 754. Es el código directo de Value `0x03`, familia NUMERIC. Si el Payload es de 1/2/4/8 WORD, es binary16/32/64/128 respectivamente. Conserva tal cual la cadena de bits de interchange y no admite otros tamaños de Payload.

## Layout

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x03
[TAG de extensión de Length] si el total es de 15 WORD o más
Payload WORD 1.º  (WORD superior)   IEEE Binary Interchange 1.º
...
Payload WORD N-ésimo  (WORD inferior)   IEEE Binary Interchange N-ésimo
```

## Interpretación

- Los WORD del Payload se concatenan en orden big-endian y se leen como la cadena de bits de interchange binary de IEEE 754 de ese ancho.
- Se conserva el patrón de bits de interchange, incluidos el NaN payload y el signed zero.
- El decodificador no debe sustituir un NaN por un único NaN canónico cualquiera ni borrar el signo de un signed zero.
- El modo de redondeo y el comportamiento aritmético no los fija este formato de serialización.

## Longitud

El total es el número de WORD que suman el TAG de 1 WORD, el TAG de extensión de Length (si lo hay) y el Payload ([Registro y TAG WORD](/es/grammar/record/)).

| Formato | Payload | Código de Length | TAG de extensión de Length | Length total |
|---|---:|---|---|---:|
| binary16 | 1 WORD | `0001` | No hay | 2 WORD |
| binary32 | 2 WORD | `0010` | No hay | 3 WORD |
| binary64 | 4 WORD | `0100` | No hay | 5 WORD |
| binary128 | 8 WORD | `1000` | No hay | 9 WORD |

binary128 también está dentro del rango directo de 1 a 14 WORD, por lo que no usa TAG de extensión de Length.

## Validez

- El Payload es exactamente de 1, 2, 4 u 8 WORD.
- Cada tamaño de Payload debe coincidir exactamente con la expresión de Length de la tabla anterior.
- No se admiten la recodificación que cambia el ancho ni WORD de relleno antes o después del Payload.

## Ejemplo

| Formato | TAG | TAG de extensión de Length | Ejemplo de Payload | Veredicto |
|---|---|---|---|---|
| binary16 | `0883` | No hay | `0000` | canónico |
| binary32 | `0903` | No hay | `0000 0000` | canónico |
| binary64 | `0A03` | No hay | `0000 0000 0000 0000` | canónico |
| binary128 | `0C03` | No hay | cadena de bits de 8 WORD | canónico |
| cualquiera | No coincide con el tamaño que indica Length | cualquiera | cualquiera | invalid |

## Base estándar

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): se aplica la codificación de interchange de binary16, binary32, binary64 y binary128. GEUL solo añade a esa cadena de bits el TAG y el framing big-endian en WORD de 16 bits.
