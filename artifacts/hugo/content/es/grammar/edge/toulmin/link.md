---
title: "LINK"
weight: 105
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-31T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "LINK es el layout con el que se escriben las relaciones entre nodos TOULMIN (ataque, exclusión, ejecución, enlace de juicio, definición, nombre). Consta de REF src y dst, un WORD de flags, una compuerta de certeza opcional, una intensidad de ataque opcional y SPAN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LINK es el layout con el que se escriben las relaciones entre nodos en un grafo TOULMIN. El tipo de relación lo fija el Codec (o el número de formato ISSUER de GEUL).

## Codec

| Codec | Nombre | TANGEUL | src → dst |
|---|---|---|---|
| `0x68` | ATTACKS | `don't X when Y` | regla → regla. Va restando gradualmente al juicio según la intensidad de ataque |
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
flags 1 WORD     b0 F_ONCE, b1 F_GATE, b2 F_STRIKE, b3 F_ORDERED, b4 F_FORCE
[F_GATE]         operador de 1 WORD (2 bits superiores) + Value UNSIGNED-DECIMAL (porcentaje)
[F_FORCE]        SIGNED-DECIMAL Value. Intensidad de ataque (0~1). Solo ATTACKS
SPAN             ancho fijado por SOURCE × 2
```

| flag | Significado |
|---|---|
| b0 F_ONCE | Se ejecuta una sola vez (el `once` de UNDO) |
| b1 F_GATE | Hay un campo de compuerta de certeza |
| b2 F_STRIKE | Es una relación tachada |
| b3 F_ORDERED | Pertenece a una lista ordenada `1.` |
| b4 F_FORCE | Hay un campo de intensidad de ataque. Solo ATTACKS |

| Operador de compuerta | Significado |
|---|---|
| 0 | at least |
| 1 | above |
| 2 | less than |
| 3 | at most |

- Los campos condicionales van en el orden de los flags (F_GATE, F_FORCE). Un campo cuyo flag está apagado no ocupa espacio.

## Intensidad de ataque

La intensidad de ataque (Force) indica con cuánta intensidad una arista ATTACKS ataca a su destino. Su rango es 0~1 y vale 1 si no hay F_FORCE.

- En el juicio, la contribución `(v+1)/2` del valor de juicio v del atacante se multiplica por la intensidad F. Un ataque de refutación (COUNTER) entra en el término del denominador como `F·(v+1)/2`, y un ataque de excepción (EXCEPT) entra en la compuerta `Π(1 − F·(v+1)/2)`. Con F = 0 el ataque no afecta al juicio.
- El valor sigue las reglas numéricas de [TOULMIN](/es/grammar/edge/toulmin/#valores-numéricos). El codificador elimina los ceros finales del coeficiente (0.5 es `C=5, E=−1`; 1.0 es `C=1, E=0`). El decodificador acepta hasta 4 decimales.
- Una superficie que no escribe intensidad (`don't X when Y`, en coreano `` `Y` 면 `X` 는 무효다``) apaga F_FORCE.
- Una superficie que escribe intensidad (en coreano `` `Y` 면 `X` 를 0.5의 세기로 공격한다``) enciende F_FORCE y guarda el valor. Aunque se escriba 1, como en `1.0의 세기로`, se enciende F_FORCE y se guarda 1. Así la superficie original vuelve tal cual.
- La intensidad de ataque es un eje distinto de la fuerza del nodo (Strict, Defeasible, Defeater). La fuerza pertenece al nodo; la intensidad de ataque, a la arista ATTACKS.

### Ejemplo

`` `Y` 면 `X` 를 0.5의 세기로 공격한다``. Edge Id 5, el atacante Y es Edge Id 3, el destino X es Edge Id 2, ancho de SPAN 1 WORD.

```
16E8                  TAG WORD: Edge, 14 WORD en total, Codec 0x68 (ATTACKS)
0088 0005             ID      LOCAL 5
0088 0003             src     LOCAL 3 (Y, atacante)
0088 0002             dst     LOCAL 2 (X, destino)
0010                  flags   F_FORCE
0990 FFFF FFFF 0005   F_FORCE SIGNED-DECIMAL, E=−1, C=5 (0.5)
0040 001A             SPAN    byte inicial 0x40, número de bytes 0x1A
```

La misma arista sin intensidad tiene flags `0000` y no tiene campo F_FORCE. Su TAG WORD es `14E8` (10 WORD en total).

## Interpretación y validez

- REF es el Edge Id de un registro de este documento (campos comunes de [TOULMIN](/es/grammar/edge/toulmin/#campos-comunes)).
- La forma de dst la fija el Codec. DO·DO-ONCE·UNDO son FuncRef (REF (ALIAS, o 0 si no hay) + VerbCode de 1 WORD, [NODE](/es/grammar/edge/toulmin/node/#campos)); LABEL·IMPORTED-FROM, el REF de un registro TEXT; los demás, el REF de un nodo.
- `do … once` lo expresa el Codec DO-ONCE. En los flags de DO-ONCE no se usa F_ONCE (si está activado, se rechaza). El `once` de UNDO se escribe con F_ONCE.
- El operador de compuerta son los 2 bits superiores del WORD de operador, y los 14 bits restantes son 0. El porcentaje es un Value UNSIGNED-DECIMAL con `E=0` y va de 0 a 100.
- Los bits b5~b15 de flags están reservados y deben ser 0. Si no, se rechaza.
- F_FORCE solo se usa en ATTACKS. Si está encendido en otro Codec (SUPERSEDES, enlaces de ejecución y de juicio, relaciones de formato ISSUER), se rechaza.
- Si la intensidad de ataque no es un Value SIGNED-DECIMAL, está fuera de 0~1 o no puede escribirse exactamente con 4 decimales, se rechaza.
- En una cadena de SUPERSEDES `A > B > C` se usa un SUPERSEDES por cada par.

## Páginas relacionadas

- [TOULMIN](/es/grammar/edge/toulmin/), [NODE](/es/grammar/edge/toulmin/node/), [SOURCE y secciones](/es/grammar/edge/toulmin/source/)
- [UNSIGNED-DECIMAL](/es/grammar/value/decimal/unsigned-decimal/), [SIGNED-DECIMAL](/es/grammar/value/decimal/signed-decimal/)
