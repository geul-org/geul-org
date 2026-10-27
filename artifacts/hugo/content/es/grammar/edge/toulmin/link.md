---
title: "LINK"
weight: 105
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "LINK es el layout con el que se escriben las relaciones entre nodos TOULMIN (ataque, exclusión, ejecución, enlace de juicio, definición, nombre). Consta de REF src y dst, un WORD de flags, una compuerta de certeza opcional y SPAN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LINK es el layout con el que se escriben las relaciones entre nodos en un grafo TOULMIN. El tipo de relación lo fija el Codec (o el número de formato ISSUER de GEUL).

## Codec

| Codec | Nombre | TANGEUL | src → dst |
|---|---|---|---|
| `0x68` | ATTACKS | `don't X when Y` | regla → regla. Va restando gradualmente al juicio |
| `0x69` | SUPERSEDES | `X supersedes Y` | regla → regla. Si está Active, quita el destino de la agregación |
| `0x70` | RUN | `run c when n` | regla → caso |
| `0x71` | DO | `do fn when n` | regla → FuncRef |
| `0x72` | DO-ONCE | `do fn once when n` | regla → FuncRef |
| `0x73` | UNDO | `undo fn when n` | regla → FuncRef |
| `0x74` | CHECKING | `checking c` | regla → caso. Juicio sin efectos secundarios |
| ISSUER `0x0000`/`0xC020` | REQUIRES | `f is required` | caso → campo |
| ISSUER `0x0000`/`0xC021` | MEANS | Definitions `means` | elemento de definición → valor·tipo |
| ISSUER `0x0000`/`0xC022` | HAS | Definitions `has` | elemento de definición → campo |
| ISSUER `0x0000`/`0xC023` | RUNS | punto de entrada `run c` | punto de entrada → caso (ejecución) |
| ISSUER `0x0000`/`0xC024` | EVALUATES | punto de entrada `check c` | punto de entrada → caso (juicio) |
| ISSUER `0x0000`/`0xC025` | TRIGGERS | disparador `run c` | disparador → caso |
| ISSUER `0x0000`/`0xC026` | UNTIL | `every … until c` | disparador → caso |
| ISSUER `0x0000`/`0xC027` | SAME-AS | | nodo → identificador global |
| ISSUER `0x0000`/`0xC028` | IMPORTED-FROM | `see a from path` | alias → ruta (TEXT) |
| ISSUER `0x0000`/`0xC029` | LABEL | nombre entre comillas invertidas | nodo → TEXT. Notación del nombre |

## Layout

```
ID               registro Reference LOCAL (Edge Id)
src              REF
dst              REF. En DO·DO-ONCE·UNDO, FuncRef
flags 1 WORD     b0 F_ONCE, b1 F_GATE, b2 F_STRIKE, b3 F_ORDERED
[F_GATE]         operador de 1 WORD (2 bits superiores) + Value UNSIGNED-DECIMAL (porcentaje)
SPAN             ancho fijado por SOURCE × 2
```

| flag | Significado |
|---|---|
| b0 F_ONCE | Se ejecuta una sola vez (el `once` de UNDO) |
| b1 F_GATE | Hay un campo de compuerta de certeza |
| b2 F_STRIKE | Es una relación tachada |
| b3 F_ORDERED | Pertenece a una lista ordenada `1.` |

| Operador de compuerta | Significado |
|---|---|
| 0 | at least |
| 1 | above |
| 2 | less than |
| 3 | at most |

## Interpretación y validez

- REF es el Edge Id de un registro de este documento (campos comunes de [TOULMIN](/es/grammar/edge/toulmin/#campos-comunes)).
- La forma de dst la fija el Codec. DO·DO-ONCE·UNDO son FuncRef (REF (ALIAS, o 0 si no hay) + VerbCode de 1 WORD, [NODE](/es/grammar/edge/toulmin/node/#campos)); LABEL·IMPORTED-FROM, el REF de un registro TEXT; los demás, el REF de un nodo.
- `do … once` lo expresa el Codec DO-ONCE. En los flags de DO-ONCE no se usa F_ONCE (si está activado, se rechaza). El `once` de UNDO se escribe con F_ONCE.
- El operador de compuerta son los 2 bits superiores del WORD de operador, y los 14 bits restantes son 0. El porcentaje es un Value UNSIGNED-DECIMAL con `E=0` y va de 0 a 100.
- Los bits b4~b15 de flags están reservados y deben ser 0. Si no, se rechaza.
- En una cadena de SUPERSEDES `A > B > C` se usa un SUPERSEDES por cada par.

## Páginas relacionadas

- [TOULMIN](/es/grammar/edge/toulmin/), [NODE](/es/grammar/edge/toulmin/node/), [SOURCE y secciones](/es/grammar/edge/toulmin/source/)
- [UNSIGNED-DECIMAL](/es/grammar/value/decimal/unsigned-decimal/)
