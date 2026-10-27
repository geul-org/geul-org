---
title: "BOOL"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "BOOL es un Value de 2 WORD fijos que contiene los valores lógicos false y true."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
BOOL es un Value que representa los valores lógicos false y true. Es el código directo de Value `0x00`, familia NUMERIC. Es un tipo distinto de SIGNED-INTEGER y UNSIGNED-INTEGER, que contienen los números 0 y 1.

## Layout

```
TAG WORD          0x0880 (0000 1000 1000 0000)  2 WORD en total
Payload           1 WORD  Boolean Code
```

## Interpretación y validez

- El Payload `0000` es false y `0001` es true.
- No hay relleno ni descriptor.
- El Payload es exactamente `0000` o `0001`. Cualquier otro valor de 16 bits se rechaza como invalid.
- Cualquier otra expresión de Length se rechaza como invalid.

## Longitud

- El total es exactamente 2 WORD: TAG 1 WORD y Payload 1 WORD, y se usa la longitud directa `LLLL=0001`. No hay TAG de extensión de Length, descriptor ni relleno.
- Si el Payload no es exactamente de 1 WORD, se rechaza.

## Ejemplo

| Registro completo (TAG + Payload) | Payload | Veredicto |
|---|---|---|
| `0880 0000` | `0000` | false, canónico |
| `0880 0001` | `0001` | true, canónico |
| `0880 0002` | `0002` | invalid |
| `0880 ffff` | `ffff` | invalid |
| TAG cuyo Length no sea `0001` + `0000` o `0001` | `0000` o `0001` | invalid |

## Estatus del formato

- Esta representación, que une la palabra de código de 16 bits `0000`/`0001` con el TAG de GEUL, es un scalar profile propio de GEUL.
- El valor lógico en sí es universal, pero no se afirma que exista un único estándar industrial que corresponda a esta representación de 1 WORD.
