---
title: "CLOSED-INTERVAL-BINARY64"
weight: 1004
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "CLOSED-INTERVAL-BINARY64 es un formato Issuer ADHOC de 11 WORD fijos que contiene un intervalo cerrado finito y no vacío con un límite inferior y uno superior binary64."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
CLOSED-INTERVAL-BINARY64 es un Value que representa un intervalo cerrado con dos endpoints IEEE 754 binary64 en el orden `(lower, upper)`. Es un Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, número de formato `0x0703`, familia NUMERIC.

## Layout

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  11 WORD en total
Issuer            1 WORD  0x0001 (ADHOC)
Número de formato 1 WORD  0x0703
Payload           [lower binary64: 4 WORD][upper binary64: 4 WORD]
```

## Interpretación y validez

- Los dos endpoints son binary64 en orden de WORD big-endian e incluyen ambos extremos.
- El patrón de bits del signed zero de un endpoint válido se conserva tal cual. No hay ABI padding.
- El Payload es exactamente de 8 WORD y debe cumplirse `lower ≤ upper`.
- NaN no se puede comparar, por lo que se rechaza. Un endpoint infinity también se rechaza, porque sería un intervalo unbounded.
- Los intervalos empty, unbounded, open y NaI no se pueden representar con este formato y se rechazan.

## Base estándar y estatus del formato

- El formato numérico de los endpoints sigue [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/), y para el sentido de un par de endpoints cerrado se toma como referencia el modelo de intervalos de [IEEE 1788, Standard for Interval Arithmetic](https://standards.ieee.org/ieee/1788/4431/) y de su flavor simplificado [IEEE 1788.1-2017](https://ieeexplore.ieee.org/document/8241734).
- Este formato es un profile sencillo de GEUL que solo admite intervalos cerrados finitos y no vacíos. No implementa ni serializa tal cual las decorations, NaI, los intervalos empty/unbounded ni el modelo completo de operaciones e interchange de IEEE 1788/1788.1.

## Longitud

- El total es exactamente 11 WORD: TAG 1 WORD, Issuer 1 WORD, número de formato 1 WORD y Payload 8 WORD, y se usa la longitud directa `LLLL=1010`. No hay TAG de extensión de Length, descriptor ni relleno.
- Si el Payload no es exactamente de 8 WORD, se rechaza.

## Ejemplo

- Los endpoints `(1.0, 2.0)` son `[1.0, 2.0]` y es válido. `(2.0, 1.0)` y `(NaN, 1.0)` son invalid.
