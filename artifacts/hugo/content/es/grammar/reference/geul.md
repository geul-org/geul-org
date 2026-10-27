---
title: "GEUL"
weight: 3
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "GEUL es un Reference de declaración que apunta a un objeto con un ID de entidad emitido por geul.org bajo CC0."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
GEUL es un Reference de declaración que apunta a una entidad emitida por geul.org bajo CC0. Es un ID secuencial cuyo número no lleva significado. Los identificadores que llevan significado en los bits corresponden a otro Codec, [GEUL-SIDX](/es/grammar/reference/geul-sidx/) (`0011`).

## Layout

```
TAG WORD          0000 0LLL L001 0QQQ      CCCC = 0010
[TAG de extensión de Length]
GEUL ID           unsigned big-endian del ancho más corto
```

- Los números pequeños se asignan a entidades de alta frecuencia. Un ID que cabe en 1 WORD ocupa 2 WORD en total.
- geul.org gestiona la asignación de ID y el registro. En el registro solo se ponen elementos que provengan de fuentes CC0.
- Si es Variable, es una variable anónima de ese tipo (Variable de [Reference](/es/grammar/reference/)).

## Ejemplo

| GEUL ID | Secuencia de WORD |
|---|---|
| 1, Identified | `0090 0001` |
| 1, Variable | `0094 0001` |
| 70000, Generic | `0111 0001 1170` |

## Problemas abiertos

- Reglas de asignación de GEUL ID y formato de divulgación del registro.

## Páginas relacionadas

- [Reference](/es/grammar/reference/), [GEUL-SIDX](/es/grammar/reference/geul-sidx/)
