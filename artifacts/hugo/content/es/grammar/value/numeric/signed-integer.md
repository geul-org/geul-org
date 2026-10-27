---
title: "SIGNED-INTEGER"
weight: 2
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "SIGNED-INTEGER es un Value que contiene un entero con signo en complemento a dos con el mínimo de WORD."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SIGNED-INTEGER es un Value que representa un valor entero con signo. Es el código directo de Value `0x01`, de la familia NUMERIC. Todo el Payload se lee como un entero en complemento a dos de precisión arbitraria, con los WORD en orden big-endian. El Payload tiene al menos 1 WORD y solo se admite la representación canónica con el mínimo de WORD.

## Layout

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x01
[TAG de extensión de Length] si el total es de 15 WORD o más
Payload WORD 1st  (WORD alto)   Integer 1st
...
Payload WORD Nth  (WORD bajo)   Integer Nth
```

## Interpretación

- El bit más significativo del primer WORD del Payload es el bit de signo de todo el entero.
- Todos los WORD del Payload se leen como una única cadena continua de bits en complemento a dos. El primer WORD es la posición más alta y el último, la más baja.
- Si el Payload tiene N WORD, el ancho de interpretación es de `16N` bits. Este ancho no es un ancho de almacenamiento declarado, sino el ancho de representación del valor que se fija en la representación canónica.
- No hay Byte Count ni descriptor de bit width.

## Representación canónica

- 0 es un Payload de 1 WORD, `0000`.
- Se prohíben los WORD iniciales de extensión de signo que no cambian el valor.
- Cuando el Payload tiene 2 WORD o más, los siguientes casos no son canónicos.
  - El primer WORD es `0000` y el bit más significativo del siguiente WORD es 0.
  - El primer WORD es `ffff` y el bit más significativo del siguiente WORD es 1.
- Un `0000` inicial que preserva el signo de un número positivo se admite cuando el bit más significativo del siguiente WORD es 1.
- Un `ffff` inicial que preserva el signo de un número negativo se admite cuando el bit más significativo del siguiente WORD es 0.
- El decodificador debe rechazar las representaciones no canónicas.

## Longitud

- El total es la suma de 1 WORD de TAG, el TAG de extensión de Length (si lo hay) y el Payload. Hasta 14 WORD se usa la longitud directa; desde 15 WORD se usa la longitud extendida `1110`·`1111`, y el TAG de extensión también cuenta en el total ([Registros y TAG WORD](/es/grammar/record/)).
- No se conserva un ancho declarado como INT8, INT16 o INT32, solo el valor numérico. De `-32768` a `32767` es 1 WORD, y fuera de ese rango se añaden los WORD necesarios. No existe un formato SIGNED-INT8 aparte.

## Ejemplo

| Valor | Payload WORD | Veredicto |
|---:|---|---|
| 0 | `0000` | canónico |
| 1 | `0001` | canónico |
| 32767 | `7fff` | canónico |
| 32768 | `0000 8000` | canónico: hace falta `0000` para preservar el signo positivo |
| -1 | `ffff` | canónico |
| -32768 | `8000` | canónico |
| -32769 | `ffff 7fff` | canónico: hace falta `ffff` para preservar el signo negativo |
| 1 | `0000 0001` | no canónico: `0000` inicial innecesario |
| -1 | `ffff ffff` | no canónico: `ffff` inicial innecesario |

## Estatus del formato

- El complemento a dos es una convención muy extendida, pero esta representación, que normaliza un valor de precisión arbitraria a una secuencia de WORD de 16 bits mínima y la une al TAG de GEUL, es un scalar profile propio de GEUL.
- Para intercambiar con tipos externos de ancho fijo como INT8/16/32/64 se necesitan una comprobación de rango y una conversión de ancho explícita.
