---
title: "EXPR"
weight: 98
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "EXPR es el layout de expresión condicional que usa PREDICATE-DECLARE (Codec 0x61). Contiene el árbol de la expresión condicional con una tabla de etiquetas propia y registros de expresión desplegados en preorden."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXPR es el layout con el que se escriben las expresiones condicionales de las Rules de TANGEUL. Lo usa el Codec `0x61` PREDICATE-DECLARE (declaración de predicado). Contiene el árbol de la expresión condicional desplegado en preorden, y las cadenas dentro de la expresión se señalan con una tabla de etiquetas dentro del registro. Por eso es autosuficiente, sin registros TEXT.

## Layout

```
ID                     registro Reference LOCAL (Edge Id)
número de nodos 1 WORD  número total de registros de expresión
número de etiquetas 1 WORD
etiquetas × número de etiquetas   registros Value UTF8-TEXT
registros de expresión × número de nodos   en preorden
```

- Las etiquetas son cadenas como nombres de campo, valores de cadena, pasos de ruta o nombres de función. Una cadena vacía también es una etiqueta. Los registros de expresión señalan las etiquetas con un índice numerado desde 0 (1 WORD).
- Los registros de expresión colocan los hijos en orden después del padre (preorden). Con el número de hijos de cada registro y este orden, el árbol queda determinado de forma única.

## Registro de expresión

Un registro de expresión empieza con 1 WORD de cabecera.

```
cabecera 1 WORD      2 bits inferiores del tipo (b15–14) | 1 bit superior del tipo (b13) | número de hijos 13 bits (b12–0)
```

Tipo = `(b13 << 2) | b15–14`.

| Tipo | Nombre | Número de hijos | Tras la cabecera |
|---|---|---|---|
| 0 | COMPARE | 0 | operador de comparación de 1 WORD, etiqueta de campo de 1 WORD, posición del valor |
| 1 | LOGIC | n | operador lógico de 1 WORD |
| 2 | NOT | 1 | nada |
| 3 | EITHER | n | nada |
| 4 | EXISTS | 1 | operador de cuantificación de 1 WORD, operando destino, etiqueta de nombre de enlace de 1 WORD |
| 5 | CALL | 0 | etiqueta de alias de 1 WORD, etiqueta de nombre de función de 1 WORD |
| 6 | COMPARE-X | 0 | operador de comparación de 1 WORD, etiqueta de campo de 1 WORD, marca izquierda de 1 WORD [+ operando], posición del valor |
| 7 | Reservado | | |

- Los registros hijo siguen a los campos tras la cabecera. El hijo de EXISTS es una condición.
- COMPARE es una comparación `<campo> <operador> <valor>` sin operandos a ninguno de los lados. Si hay operando en alguno de los lados, se usa COMPARE-X.
- Si la marca izquierda de COMPARE-X es `1`, sigue un operando, y si es `0`, no hay. Si hay operando izquierdo, la etiqueta de campo es una cadena vacía.
- CALL es una llamada a función del host en posición de predicado. Si es una función de este documento, la etiqueta de alias es una cadena vacía.

### Posición del valor

```
tipo de valor 1 WORD    0 número, 1 cadena, 2 operando
valor                   0: registro Value UNSIGNED-INTEGER
                        1: etiqueta de 1 WORD
                        2: operando (solo en COMPARE-X)
```

- Si la cadena de valor es exactamente la notación decimal canónica de un entero no negativo, se escribe como Value UNSIGNED-INTEGER. Los demás valores se escriben como etiqueta. Así la cadena de valor se recupera tal cual.

### Operando

```
tipo de operando 1 WORD   0 ruta, 1 referencia de criterio, 2 llamada a función
ruta · referencia de criterio   número de pasos de 1 WORD + etiqueta de 1 WORD × número de pasos
llamada a función               etiqueta de alias de 1 WORD + etiqueta de nombre de función de 1 WORD
```

- La ruta es una ruta de los datos de entrada, y la referencia de criterio es una ruta del criterio de juicio (SPEC) inyectado con `with`.

### Códigos de operador

| Código | Operador de comparación |
|---|---|
| `0x0301` | is empty |
| `0x0302` | is not empty |
| `0x0303` | equals |
| `0x0304` | is in |
| `0x0305` | is greater than |
| `0x0306` | is less than |
| `0x0307` | is at most |
| `0x0308` | is at least |

| Código | Operador lógico |
|---|---|
| `0x0311` | and |
| `0x0312` | or |

| Código | Operador de cuantificación |
|---|---|
| `0x0321` | any |

### Evaluación con entradas desconocidas

Cuando la entrada es un marcador de posición, los operadores de comparación se evalúan con 3 valores (verdadero, falso, indeterminado U). Con NO-VALUE, `is empty` es verdadero y las demás comparaciones son falsas. Con UNKNOWN-VALUE, `is not empty` es verdadero y `equals`, `is in` y las comparaciones de magnitud son U. Con ABSENT y con la ausencia de afirmación, todos los operadores son U. Los operadores lógicos siguen la lógica fuerte de Kleene de 3 valores, y si el predicado es U, el juicio del nodo es Review. Esta evaluación es núcleo fijo ([TOULMIN](/es/grammar/edge/toulmin/#juzgar-sobre-lo-desconocido)).

## Interpretación y validez

- El número de nodos debe ser igual al número de registros de expresión desplegados. La posición a la que se llega tras leer el último registro de expresión debe coincidir exactamente con el final del registro.
- Si un índice de etiqueta es igual o mayor que el número de etiquetas, se rechaza.
- El número de hijos de NOT y EXISTS debe ser 1.
- Un tipo desconocido (7), o un tipo de valor o tipo de operando desconocido, se rechaza.
- El número de hijos es de 13 bits (máximo 8191).

## Páginas relacionadas

- [TOULMIN](/es/grammar/edge/toulmin/), [NODE](/es/grammar/edge/toulmin/node/)
- [UTF8-TEXT](/es/grammar/value/text/utf8-text/), [UNSIGNED-INTEGER](/es/grammar/value/numeric/unsigned-integer/)
