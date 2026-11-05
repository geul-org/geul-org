---
title: "CLOSED-INTERVAL-BINARY64"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "CLOSED-INTERVAL-BINARY64 es un Value que representa un intervalo cerrado mediante dos endpoint IEEE 754 binary64 en el orden (lower, upper)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CLOSED-INTERVAL-BINARY64 es un Value que representa un intervalo cerrado mediante dos endpoint IEEE 754 binary64 en el orden `(lower, upper)`. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, número de Codec `0x00000703`, familia NUMERIC.

## Layout {#레이아웃}

```
TAG WORD          0x09DC (0000 1001 1101 1100)  total 13 WORD
Issuer            2 WORD  0x00000002 (ADHOC)
Número de Codec   2 WORD  0x00000703
Payload           [lower binary64: 4 WORD][upper binary64: 4 WORD]
```

## Interpretación y validez {#해석과-유효성}

- Los dos endpoint son binary64 en orden de WORD big-endian y ambos extremos están incluidos.
- El bit pattern del cero con signo de un endpoint válido se conserva tal cual. No hay ABI padding.
- El Payload es exactamente de 8 WORD y debe cumplirse `lower ≤ upper`.
- NaN no es comparable, así que se rechaza. Un endpoint infinito también se rechaza, porque el intervalo sería unbounded.
- Los intervalos empty, unbounded y open, y NaI, no se pueden representar con este formato y se rechazan.

## Base normativa y estatus del formato {#표준-근거와-형식-지위}

- El formato numérico de los endpoint sigue [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/), y el significado de par de endpoint cerrado toma como referencia el modelo de intervalo de [IEEE 1788, Standard for Interval Arithmetic](https://standards.ieee.org/ieee/1788/4431/) y de su simplified flavor, [IEEE 1788.1-2017](https://ieeexplore.ieee.org/document/8241734).
- Este formato es un profile simple de GEUL que solo admite intervalos cerrados, finitos y no vacíos. No implementa ni serializa tal cual las decorations, NaI, los intervalos empty/unbounded ni el modelo completo de operaciones e interchange de IEEE 1788/1788.1.

## Longitud {#길이}

- El total es exactamente 13 WORD: TAG 1 WORD, Issuer 2 WORD, número de Codec 2 WORD y Payload 8 WORD, con longitud directa `LLLL=1100`. No hay TAG extendida de Length, descriptor ni padding.
- Si el Payload no es exactamente de 8 WORD, se rechaza.

## Ejemplo {#예시}

- El endpoint `(1.0, 2.0)` es `[1.0, 2.0]` y es válido. `(2.0, 1.0)` y `(NaN, 1.0)` son invalid.
