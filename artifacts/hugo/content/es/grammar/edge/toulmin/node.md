---
title: "NODE"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "NODE es el layout con el que se escriben los nodos de un grafo TOULMIN (caso, regla, definición, punto de entrada, disparador, función, campo, alias, agrupación). Los flags de un WORD de cabecera fijan los campos condicionales que siguen."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

NODE es el layout con el que se escriben los nodos de un grafo de juicio y ejecución TOULMIN. El tipo de nodo lo fija el Codec (o el número de formato ISSUER de GEUL), y 1 WORD de cabecera fija el rol, el Level, la forma del Claim y los campos condicionales.

## Codec

| Codec | Nombre | TANGEUL | Nodo |
|---|---|---|---|
| `0x60` | CASE-DECLARE | `in case of` | caso |
| `0x62` | SPEC-DECLARE | elemento de Definitions (`means`, `has`) | criterio de juicio (Backing). El role es el tipo de definición |
| `0x63` | RULE-DECLARE | general rule | aserción (Warrant) |
| `0x64` | COUNTER-DECLARE | counter rule | refutación (Rebuttal) |
| `0x65` | EXCEPT-DECLARE | except rule | excepción (Defeater) |
| `0x75` | ENTRY | `provides x` | punto de entrada externo |
| `0x76` | TRIGGER | `on`, `every`, `until` | punto de entrada de evento·periodo |
| ISSUER `0x0000`/`0xC010` | NAMESPACE | `this document is` | espacio de nombres del documento |
| ISSUER `0x0000`/`0xC011` | FUNC | referencia a función | función externa (ejemplo: `bank.withdraw`) |
| ISSUER `0x0000`/`0xC012` | FIELD | `x is required [as Type]` | campo obligatorio |
| ISSUER `0x0000`/`0xC013` | ALIAS | `see a from path` | alias del paquete importado |
| ISSUER `0x0000`/`0xC014` | GROUP | lista ordenada `1.` | agrupación de ejecución ordenada |

Los formatos ISSUER ponen, en el TAG de extensión de Codec que sigue a `ISSUER-1WORD` (`0x7C`), el Issuer `0x0000` y el número de formato ([TOULMIN](/es/grammar/edge/toulmin/)).

## Layout

```
ID               registro Reference LOCAL (Edge Id)
cabecera 1 WORD  role 2b | reservado 2b | F_GROUNDS 1b | level 2b | tipo de object 2b | flags 7b
[F_FUNC]         FuncRef: REF (ALIAS, o 0 si no hay) + VerbCode de 1 WORD
[F_QUAL]         Value SIGNED-DECIMAL. Qualifier
[F_CHECK]        REF (caso)
[F_CLAIM]        Claim: REF (subject) + predicate de 1 WORD + object + mode de 1 WORD
[F_VERDICT]      Value SIGNED-DECIMAL. Valor inicial del juicio
[F_WITH]         cantidad (Value UNSIGNED-INTEGER) + REF (TEXT) × cantidad
[F_GROUNDS]      cantidad (Value UNSIGNED-INTEGER) + REF (TEXT) × cantidad
SPAN             ancho fijado por SOURCE × 2 (byte de inicio, número de bytes)
```

### WORD de cabecera

| Bits | Campo | Valor |
|---|---|---|
| 15–14 | role | 0 general, 1 counter, 2 except |
| 13–12 | reservado | 0 |
| 11 | F_GROUNDS | Hay lista de fundamentos |
| 10–9 | level | 0 Unset, 1 Fail, 2 Review (3 reservado) |
| 8–7 | tipo de object | Forma del object del Claim. 0 REF, 1 Value UNSIGNED-INTEGER, 2 SPAN |
| 6–0 | flags | Tabla siguiente |

| Bit | flag | Significado |
|---|---|---|
| b0 | F_FUNC | Hay campo FuncRef |
| b1 | F_QUAL | Hay campo Qualifier |
| b2 | F_CHECK | Hay campo de caso destino de `checking` |
| b3 | F_CLAIM | Hay campo Claim |
| b4 | F_VERDICT | Hay campo de valor inicial del juicio |
| b5 | F_STRIKE | Es una declaración tachada. No tiene campos |
| b6 | F_WITH | Hay campo de lista de criterios |

- Los campos condicionales se colocan en el orden de los flags (F_FUNC, F_QUAL, F_CHECK, F_CLAIM, F_VERDICT, F_WITH, F_GROUNDS). Un campo cuyo flag está apagado no ocupa lugar.
- Si un flag está activado y falta el campo, se rechaza. La posición a la que se llega leyendo los campos en orden debe coincidir exactamente, tras SPAN, con el final del registro.

## Campos

| Campo | Descripción |
|---|---|
| FuncRef | Posición de función. REF es el registro ALIAS que importó esa función, y `0` si es una función de este documento. VerbCode es un código de 1 WORD que aún no está asignado (se admite `0x0000`). La notación original de la función se escribe aparte con TEXT + [LABEL](/es/grammar/edge/toulmin/link/) |
| Qualifier | Certeza del nodo (0~1) |
| Caso | F_CHECK: caso sobre el que este nodo solo juzga (`checking c`) |
| Claim | Proposición que contiene el nodo. REF de subject, predicate de 1 WORD, object, mode de 1 WORD. La forma del object la fija el tipo de object de la cabecera |
| Valor del juicio | Valor inicial del juicio (−1~1) |
| F_WITH | Criterios de juicio en el momento de la declaración (`기준으로 하는`, "tomando como criterio"). Lista de REF de registros TEXT |
| F_GROUNDS | Nombres de hechos externos que se interpretan en el momento de la evaluación (`근거로 하는`, "tomando como fundamento"). Lista de REF de registros TEXT |
| SPAN | Rango del texto original del que salió esta declaración |

- La notación del valor del juicio y del Qualifier sigue las reglas de [valores numéricos](/es/grammar/edge/toulmin/#valores-numéricos) de TOULMIN.
- La cantidad de las listas es un registro Value [UNSIGNED-INTEGER](/es/grammar/value/numeric/unsigned-integer/) incorporado.
- La forma básica de un Claim descriptivo es subject y predicate `0` y object SPAN (tipo de object 2). Queda fijado a la notación del texto original.

## Interpretación y validez

- El role debe ser igual al Codec en RULE·COUNTER·EXCEPT-DECLARE (0 general, 1 counter, 2 except). En SPEC-DECLARE es el tipo de definición. En los demás Codec es 0.
- Si level es 0 (Unset), se usa el valor por defecto del motor: Fail para COUNTER-DECLARE y Review para EXCEPT-DECLARE.
- La regla de función del host de TANGEUL `tangl:규칙` ("regla") (`쓰는 규칙이다`, "es una regla que usa") se escribe como un NODE RULE-DECLARE fuera de un caso. La función va en F_FUNC, los criterios en F_WITH y los fundamentos en F_GROUNDS. Solo las reglas de expresión condicional llevan delante un [PREDICATE-DECLARE](/es/grammar/edge/toulmin/expr/).
- Los bits reservados (13–12) deben ser 0. Si un bit reservado está activado o el role no corresponde al Codec, se rechaza.

## Páginas relacionadas

- [TOULMIN](/es/grammar/edge/toulmin/), [LINK](/es/grammar/edge/toulmin/link/), [EXPR](/es/grammar/edge/toulmin/expr/), [SOURCE y secciones](/es/grammar/edge/toulmin/source/)
- [LOCAL](/es/grammar/reference/local/), [SIGNED-DECIMAL](/es/grammar/value/decimal/signed-decimal/)
