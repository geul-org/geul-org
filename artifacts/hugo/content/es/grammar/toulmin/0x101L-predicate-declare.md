---
title: "PREDICATE-DECLARE (0x101L)"
weight: 257
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "PREDICATE-DECLARE es el Codec TOULMIN que declara un predicado (expresión de veredicto)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

PREDICATE-DECLARE es el Codec TOULMIN que declara un predicado (expresión de veredicto). Su layout es EXPR. EXPR es el layout que escribe las expresiones condicionales de las Rules de TANGEUL. Despliega el árbol de la expresión en preorden, y las cadenas dentro de la expresión se señalan mediante una tabla de etiquetas dentro del propio registro. Por eso es autosuficiente, sin registros TEXT.

| Elemento | Valor |
|---|---|
| Nombre | `PREDICATE-DECLARE` (BIND `PREDICATE-DECLARE` del documento de especificación) |
| TAG ID | `0x101L` |
| Codec ID | `0x00001010` |
| Documento de especificación | `0x00000000/codecs/0x00001010/` (destino de DECLARE `1010`) |
| Sección | 8 `1000` (Edge TOULMIN), desplazamiento dentro de la sección C = 1 |
| Kind | Edge · familia: TOULMIN, grupo: declaración, layout: EXPR |
| TAG WORD | `0001 0000 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | declaración de predicado. Función y expresión de veredicto, criterio de juicio (Spec), contrato de hechos (Ground) |
| Lado Hugo | `edge/toulmin/expr.md` |

## Layout {#레이아웃}

```
ID                     registro LOCAL Reference (Edge Id)
nº de nodos 1 WORD     número total de registros de expresión
nº etiquetas 1 WORD
etiqueta × nº etiq.    registro Value UTF8-TEXT
reg. expr. × nº nodos  en preorden
```

- Una etiqueta es una cadena: nombre de campo, valor de cadena, paso de ruta o nombre de función. La cadena vacía también es una etiqueta. Un registro de expresión señala una etiqueta con un índice (1 WORD) numerado desde 0.
- Los registros de expresión colocan a los hijos después del padre (preorden). El número de hijos de cada registro y este orden determinan un único árbol.

## Registro de expresión {#식-레코드}

Un registro de expresión empieza con un WORD de encabezado.

```
encabezado 1 WORD   2 bits bajos del tipo (b15–14) | 1 bit alto del tipo (b13) | nº de hijos, 13 bits (b12–0)
```

Tipo = `(b13 << 2) | b15–14`.

| Tipo | Nombre | Nº de hijos | Tras el encabezado |
|---|---|---|---|
| 0 | COMPARE | 0 | operador de comparación 1 WORD, etiqueta de campo 1 WORD, posición de valor |
| 1 | LOGIC | n | operador lógico 1 WORD |
| 2 | NOT | 1 | ninguno |
| 3 | EITHER | n | ninguno |
| 4 | EXISTS | 1 | operador de cuantificación 1 WORD, operando de destino, etiqueta del nombre ligado 1 WORD |
| 5 | CALL | 0 | etiqueta de alias 1 WORD, etiqueta del nombre de función 1 WORD |
| 6 | COMPARE-X | 0 | operador de comparación 1 WORD, etiqueta de campo 1 WORD, marca izquierda 1 WORD [+ operando], posición de valor |
| 7 | Reserved | | |

- Los registros hijos siguen a los campos que van después del encabezado. El hijo de EXISTS es una sola condición.
- COMPARE es una comparación `<campo> <operador> <valor>` sin operandos en ninguno de los lados. Si hay un operando en cualquiera de los lados, se usa COMPARE-X.
- Si la marca izquierda de COMPARE-X es `1`, sigue un operando; si es `0`, no lo hay. Si hay operando izquierdo, la etiqueta de campo es la cadena vacía.
- CALL es una llamada a una función del host en posición de predicado. Si la función es de este documento, la etiqueta de alias es la cadena vacía.

### Posición de valor {#값-자리}

```
tipo de valor 1 WORD   0 número, 1 cadena, 2 operando
valor                  0: registro Value UNSIGNED-INTEGER
                       1: etiqueta 1 WORD
                       2: operando (solo en COMPARE-X)
```

- Si la cadena de valor coincide exactamente con la notación decimal canónica de un entero no negativo, se escribe como Value UNSIGNED-INTEGER. Cualquier otro valor se escribe como etiqueta. Así la cadena de valor se recupera tal cual.

### Operando {#피연산자}

```
tipo de operando 1 WORD   0 ruta, 1 referencia de criterio, 2 llamada a función
ruta, ref. de criterio    número de pasos 1 WORD + etiqueta 1 WORD × número de pasos
llamada a función         etiqueta de alias 1 WORD + etiqueta del nombre de función 1 WORD
```

- Una ruta es la ruta en los datos de entrada; una referencia de criterio es la ruta en el criterio de juicio (SPEC) inyectado con `with`.

### Códigos de operador {#연산자-코드}

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

### Evaluación con entradas desconocidas {#미상-입력의-평가}

Cuando la entrada es un marcador de posición, los operadores de comparación se evalúan con tres valores (verdadero, falso, indeterminado U). Con NO-VALUE, `is empty` es verdadero y las demás comparaciones son falsas. Con UNKNOWN-VALUE, `is not empty` es verdadero y `equals`, `is in` y las comparaciones de tamaño dan U. Con ABSENT y con ausencia de descripción, todos los operadores dan U. Los operadores lógicos siguen la lógica fuerte de tres valores de Kleene, y si el predicado es U, el veredicto del nodo es Review. Esta evaluación es parte del núcleo fijo ([TOULMIN](_index.md#미상-위에서-판정하기)).

## Interpretación y validez {#해석과-유효성}

- El número de nodos debe ser igual al número de registros de expresión desplegados. La posición tras leer el último registro de expresión debe coincidir exactamente con el final del registro.
- Se rechaza un índice de etiqueta mayor o igual que el número de etiquetas.
- El número de hijos de NOT y de EXISTS debe ser 1.
- Se rechazan un tipo desconocido (7) y un tipo de valor o de operando desconocido.
- El número de hijos es de 13 bits (máximo 8191).

## Documento del Codec {#코덱-문서}

El documento del Codec contiene DECLARE (destino `1010`). En el layout EXPR, los valores en bruto iniciales (número de nodos, número de etiquetas) fijan los recuentos de repetición y no se pueden declarar con FIELD, por lo que la declaración de campos es un problema abierto (repetición de [DECLARE](../edge/0x0BBL-declare.md#열린-문제)).

## Páginas relacionadas {#관련-페이지}

- [TOULMIN](_index.md), [NODE](_index.md#node)
- [UTF8-TEXT](../value/0x072L-utf8-text.md), [UNSIGNED-INTEGER](../value/0x062L-unsigned-integer.md)

## Texto original del documento de especificación {#규격-문서-원문}

Así se ve el documento de especificación `0x00000000/codecs/0x00001010/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000101000000000
BODY
#1 DECLARE 0x1010
#2 BIND #1 "PREDICATE-DECLARE"
```
