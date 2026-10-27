---
title: "UNSIGNED-INTEGER"
weight: 3
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "UNSIGNED-INTEGER es un Value que contiene un entero sin signo como magnitude big-endian con el mínimo de WORD."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UNSIGNED-INTEGER es un Value que representa un valor entero sin signo. Es el código directo de Value `0x02`, de la familia NUMERIC. Todo el Payload se lee como una unsigned magnitude de precisión arbitraria, con los WORD en orden big-endian. El Payload tiene al menos 1 WORD y solo se admite la representación canónica con el mínimo de WORD.

## Layout

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x02
[TAG de extensión de Length] si el total es de 15 WORD o más
Payload WORD 1st  (WORD alto)   Unsigned Magnitude 1st
...
Payload WORD Nth  (WORD bajo)   Unsigned Magnitude Nth
```

## Interpretación

- El primer WORD del Payload es la posición más alta y el último WORD, la más baja.
- Si el Payload tiene N WORD, se lee como una única unsigned magnitude de `16N` bits.
- Este ancho no es un ancho de almacenamiento declarado, y no hay descriptor de bit width.

## Representación canónica

- 0 es un Payload de 1 WORD, `0000`.
- Cuando el Payload tiene 2 WORD o más y el primer WORD es `0000`, no es canónico, porque quitarlo deja el mismo valor.
- El decodificador debe rechazar las representaciones con WORD zero iniciales innecesarios.

## Longitud

- El total es la suma de 1 WORD de TAG, el TAG de extensión de Length (si lo hay) y el Payload. Hasta 14 WORD se usa la longitud directa; desde 15 WORD se usa la longitud extendida `1110`·`1111`, y el TAG de extensión también cuenta en el total ([Registros y TAG WORD](/es/grammar/record/)).
- No se conserva un ancho declarado como UINT8, UINT16 o UINT32, solo el valor numérico.

## Ejemplo

| Valor | Payload WORD | Veredicto |
|---:|---|---|
| 0 | `0000` | canónico |
| 1 | `0001` | canónico |
| 65535 | `ffff` | canónico |
| 65536 | `0001 0000` | canónico |
| 1 | `0000 0001` | no canónico: `0000` inicial innecesario |
| Payload de 7 WORD | los 7 WORD que siguen al TAG `0b82` (longitud directa `LLLL=0111`, 8 WORD en total) | canónico |
| Payload de 7 WORD | los 7 WORD que siguen al TAG de longitud extendida y el valor extendido `0009` | no canónico: hasta 14 WORD se escribe con longitud directa |

## Estatus del formato

- Esta representación, que normaliza una unsigned magnitude de precisión arbitraria a una secuencia de WORD de 16 bits mínima y la une al TAG de GEUL, es un scalar profile propio de GEUL.
- Para intercambiar con tipos externos de ancho fijo como UINT8/16/32/64 se necesitan una comprobación de rango y una conversión de ancho explícita.
