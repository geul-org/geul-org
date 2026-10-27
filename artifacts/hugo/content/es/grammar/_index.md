---
title: "Gramática de GEUL"
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-28T12:00:00+09:00
tags: ["grammar", "specification"]
summary: "Especificación de la gramática de GEUL v1. Define los registros sobre palabras de 16 bits, los cuatro Kind y todos los Codec, la estructura del documento, el Issuer y las reglas de publicación."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
showContent: true
---

Especificación de la gramática de GEUL v1. Si es tu primera lectura, sigue este orden.

1. [Visión general](/es/grammar/overview/) — qué es GEUL y con qué principios se diseñó
2. [Registro y TAG WORD](/es/grammar/record/) — el TAG WORD de 16 bits, Kind, Length, Codec
3. [Documento](/es/grammar/document/) — HEAD y BODY, hash de contenido, versión y revisión
4. [Reference](/es/grammar/reference/), [Value](/es/grammar/value/), [Edge](/es/grammar/edge/), [Meta](/es/grammar/meta/) — los cuatro Kind
5. [Issuer y publicación](/es/grammar/issuer/) — la entidad que emite documentos y formatos, la tabla de asignación de 1 WORD, el modo de divulgación, la firma y la clave de verificación
6. [Direcciones de publicación y lista de versiones](/es/grammar/publishing/) — notación de ID, dirección de publicación, designación de formato, índice de nombres, lista de versiones, capas de confianza
7. [Documento de especificación de Codec](/es/grammar/codec-spec/) — cómo escribir el layout de un Codec como documento GEUL
8. [Ejemplo: un elemento de Wikidata](/es/grammar/example/) — un documento real completo

Esta página es el índice de todos los Codec. Al pulsar un nombre se abre el documento detallado de ese Codec. Los nombres sin enlace aún no tienen documento detallado. Los códigos directos que no aparecen en las tablas están reservados.

## Kind

El TAG WORD es `000K KLLL LCCC CCCC`. `KK` es el Kind, `LLLL` es Length y `CCC CCCC` son los 7 bits de Codec. En Reference, en cambio, son 4 bits de Codec y 3 bits de Quantifier.

| Valor | Clasificación | Descripción |
|---|---|---|
| `0000 0LLL LCCC CQQQ` | [Reference](/es/grammar/reference/) | Registro que apunta a un objeto. `QQQ` es el Quantifier |
| `0000 1LLL LCCC CCCC` | [Value](/es/grammar/value/) | Registro de valor |
| `0001 0LLL LCCC CCCC` | [Edge](/es/grammar/edge/) | Registro de composición |
| `0001 1LLL LCCC CCCC` | [Meta](/es/grammar/meta/) | Registro sobre el documento y sobre otros registros |

## Reference

`0000 0LLL LCCC CQQQ` — [Reference](/es/grammar/reference/)

### Codec (`CCCC`)

| CCCC | Nombre | Clasificación | ID de destino |
|---|---|---|---|
| `0000` | [Marcador de posición](/es/grammar/reference/slot-marker/) | Reservado | Conjunto de marcadores de 1 WORD que no apuntan a ningún objeto. Los 3 bits inferiores son el número de marcador (véase la tabla siguiente) |
| `0001` | [LOCAL](/es/grammar/reference/local/) | Declara | ID emitido por este documento |
| `0010` | [GEUL](/es/grammar/reference/geul/) | Declara | Entidad emitida por geul.org bajo CC0. Los números pequeños se asignan a entidades de alta frecuencia |
| `0011` | [GEUL-SIDX](/es/grammar/reference/geul-sidx/) | Declara | GEUL SIDX (Semantic-aligned Index). Identificador que lleva significado en sus bits |
| `0100` | [WIKIDATA-QID](/es/grammar/reference/wikidata-qid/) | Declara | Elemento de Wikidata. El entero que sigue a `Q` |
| `0101` | [WIKIDATA-PID](/es/grammar/reference/wikidata-pid/) | Declara | Propiedad de Wikidata. El entero que sigue a `P` |
| `0110` | [ISSUER-POINTER](/es/grammar/reference/issuer-pointer/) | Apunta y declara | El propio Issuer. El Payload es solo el Issuer (1/2/4/16 WORD) y no hay ID de destino |
| `0111` | [DOC-POINTER](/es/grammar/reference/doc-pointer/) | Apunta y declara | Una versión de un documento de un Issuer. Issuer + ID de documento de 4 WORD + ID de versión de 2 WORD; no hay ID de destino |
| `1000` | [EXTERNAL-POINTER-1WORD](/es/grammar/reference/external-pointer/) | Apunta | LOCAL ID de un documento importado con `IMPORT-DOC`. IMPORT ID de 1 WORD |
| `1001` | [EXTERNAL-POINTER-2WORD](/es/grammar/reference/external-pointer/) | Apunta | Igual que el anterior. IMPORT ID de 2 WORD |
| `1010` | [EXTERNAL-POINTER-4WORD](/es/grammar/reference/external-pointer/) | Apunta | Igual que el anterior. IMPORT ID de 4 WORD |
| `1011` | [EXTERNAL-POINTER-8WORD](/es/grammar/reference/external-pointer/) | Apunta | Igual que el anterior. IMPORT ID de 8 WORD |
| `1100` | [EXTERNAL-ISSUER-1WORD](/es/grammar/reference/external-issuer/) | Apunta y declara | LOCAL ID de un documento de Issuer de 1 WORD |
| `1101` | [EXTERNAL-ISSUER-2WORD](/es/grammar/reference/external-issuer/) | Apunta y declara | LOCAL ID de un documento de Issuer de 2 WORD |
| `1110` | [EXTERNAL-ISSUER-4WORD](/es/grammar/reference/external-issuer/) | Apunta y declara | LOCAL ID de un documento de Issuer de 4 WORD |
| `1111` | [EXTERNAL-ISSUER-16WORD](/es/grammar/reference/external-issuer/) | Apunta y declara | LOCAL ID de un documento de Issuer de 16 WORD |

### Marcador de posición (Codec `0000`)

`0000 0000 0000 0MMM` — [Marcador de posición](/es/grammar/reference/slot-marker/). Solo aparece en una posición si la lista CODEC del campo incluye exactamente ese WORD.

| WORD | Nombre | Significado | Wikidata |
|---|---|---|---|
| `0x0000` | [ABSENT](/es/grammar/reference/slot-marker/) | No declarado. Se omitió un campo opcional. No se afirma nada sobre el mundo | sin snak |
| `0x0001` | [UNKNOWN-VALUE](/es/grammar/reference/slot-marker/) | Desconocido. Hay un valor, pero se ignora cuál | `somevalue` |
| `0x0002` | [NO-VALUE](/es/grammar/reference/slot-marker/) | Sin valor. No hay valor | `novalue` |
| `0x0003`~`0x0007` | Reserved | | |

### Quantifier (`QQQ`)

| QQQ | Nombre | Significado | Ejemplo |
|---|---|---|---|
| `000` | Identified | Entidad identificada | Elon Musk, Corea del Sur |
| `001` | Generic | Afirmación general o definitoria sobre una clase entera. Admite excepciones. | Los soldados obedecen las órdenes |
| `010` | Free-choice | Cualquier objeto que cumpla la condición | Cualquier soldado |
| `011` | Universal | Todos los objetos del ámbito dado | Todos los soldados |
| `100` | Variable | Variable del discurso | esa persona, esta mujer |
| `101`~`111` | Reserved |  |  |

- En el Codec `0000` (marcador de posición), los 3 bits inferiores no son un Quantifier sino el número de marcador.

## Issuer

El Issuer es la entidad que define documentos y formatos — [Issuer y publicación](/es/grammar/issuer/)

| Posición | Significado |
|---|---|
| Códigos ISSUER de Value y Edge (`0x7C`~`0x7F`) | Formato definido por ese Issuer |
| Meta `DOC-ID` | El Issuer que emitió este documento |
| Meta `IMPORT-DOC` | El Issuer que emitió el documento importado |
| Reference `EXTERNAL-ISSUER-*`, `DOC-POINTER` | El Issuer que emitió el documento al que se apunta (1/2/4/16 WORD) |
| Reference `ISSUER-POINTER` | El propio Issuer al que se apunta (1/2/4/16 WORD) |

| Ancho del Issuer | Emisión |
|---|---|
| 1 WORD | geul.org lo asigna a organismos de normalización y a instituciones principales ([tabla de asignación de 1 WORD](/es/grammar/issuer/#tabla-de-asignación-de-1-word)). |
| 2 WORD | Registro en geul.org. Issuer que ha pasado la prueba de propiedad de dominio (p. ej., company.com) |
| 4 WORD | Registro en geul.org. Issuer registrado sin prueba de propiedad |
| 16 WORD | Autoemisión. Se calcula a partir de la clave pública, sin registro. Sigue la regla de generación que se indica más abajo. |

### Algoritmo de firma del Issuer de 16 WORD

| ID de algoritmo de firma | Algoritmo |
|---|---|
| `0x0001` | Ed25519 |
| Otros | Reservado |

## Edge

`0001 0LLL LCCC CCCC` — [Edge](/es/grammar/edge/)

Los 2 bits superiores del Codec son la familia. Tanto el código directo (7 bits) como el número de formato ISSUER (16 bits) siguen la misma regla.

| 2 bits superiores | Familia | Código directo | Número de formato |
|---|---|---|---|
| `00` | Afirmación | `0x00`~`0x1F` | `0x0000`~`0x3FFF` |
| `01` | Fundamento | `0x20`~`0x3F` | `0x4000`~`0x7FFF` |
| `10` | Ejecución | `0x40`~`0x5F` | `0x8000`~`0xBFFF` |
| `11` | [TOULMIN](/es/grammar/edge/toulmin/) | `0x60`~`0x7B` | `0xC000`~`0xFFFF` |

### Afirmación (`00`)

| CCCCC | Codec | Nombre | Subformato | Descripción |
|---|---|---|---|---|
| `00000` | `0x00` | [REFERENCE-NODE](/es/grammar/edge/reference-node/) |  | Vínculo dirigido en el que un Subject que es un Reference designa un Object |
| `00001` | `0x01` | [SAME-NODE](/es/grammar/edge/same-node/) |  | Identidad: dos Reference designan el mismo objeto |
| `00010` | `0x02` | [DIFFERENT-NODE](/es/grammar/edge/different-node/) |  | No identidad: dos Reference designan objetos distintos |
| `00011` | `0x03` | [BIND](/es/grammar/edge/bind/) |  | Vincula al Subject un nombre con el que la máquina hace coincidir (`UTF8-TEXT-*`). Es único dentro del ámbito, debe coincidir exactamente y no tiene idioma |
| `00100` | `0x04` | [LABEL](/es/grammar/edge/label/) |  | Asocia al Subject un nombre en un idioma (label). El Object es UTF8-LANGUAGE-TEXT |
| `00101` | `0x05` | [ALIAS](/es/grammar/edge/alias/) |  | Asocia al Subject otro nombre (alias). El layout es el mismo que el de LABEL |
| `00110` | `0x06` | [DESCRIPTION](/es/grammar/edge/description/) |  | Asocia al Subject una descripción en un idioma (description). El layout es el mismo que el de LABEL |
| `00111` | `0x07` | Reserved |  |  |
| `01000` | `0x08` | VERB-SHORT |  | Forma abreviada de la afirmación verbal |
| `01001` | `0x09` | VERB |  | Afirmación verbal |
| `01010` | `0x0A` | [TRIPLE](/es/grammar/edge/triple/) |  | Proposición en el orden Predicate, Subject, Object, más rank. El Object es un valor o un marcador UNKNOWN-VALUE·NO-VALUE. Su significado es la suma de todos los QUALIFIER que apuntan al Edge Id de ese Edge |
| `01011` | `0x0B` | [QUALIFIER](/es/grammar/edge/qualifier/) |  | Una condición que acota la proposición de otro Edge. Property, Target (Edge Id), Value (un valor o un marcador UNKNOWN-VALUE·NO-VALUE). Forma parte de la proposición |
| `01100`~`01111` | `0x0C`~`0x0F` | Reserved |  |  |
| `10000` | `0x10` | WORLD | Sí | Estructura para expresar una cosmovisión |
| `10001` | `0x11` | TIMELINE | Sí | Estructura que expresa el orden de mundos y sucesos |
| `10010` | `0x12` | SCENE | Sí | Estructura de escena para describir rasgos propios de un guion |
| `10011`~`10111` | `0x13`~`0x17` | Reserved |  |  |
| `11000` | `0x18` | [PUBLICATION](/es/grammar/edge/publication/) |  | Publicación de un documento. DOC-POINTER, hash de contenido |
| `11001` | `0x19` | DEPRECATION |  | Deprecación de una versión publicada. DOC-POINTER |
| `11010` | `0x1A` | TOMBSTONE |  | Eliminación (lápida) de una versión publicada. DOC-POINTER, categoría de motivo |
| `11011` | `0x1B` | [DECLARE](/es/grammar/edge/declare/) |  | Declaración de la composición del Payload de un Codec. Kind y Codec de destino |
| `11100` | `0x1C` | [FIELD](/es/grammar/edge/field/) |  | Un campo del Payload. El DECLARE al que pertenece; ancho: registro (Length del TAG) o valor en bruto de n WORD |
| `11101` | `0x1D` | [ENUM](/es/grammar/edge/enum/) |  | Un valor de código de un campo en bruto. Campo, valor de código |
| `11110` | `0x1E` | [CODEC](/es/grammar/edge/codec/) |  | Un Kind y Codec que acepta un campo. Campo, WORD de destino (`000K KLLL LCCC CCCC`, LLLL `0000` exacto, `1111` comodín; los marcadores de posición solo como destino exacto `0000`~`0002`). Un campo de registro tiene varios (lista cerrada); un campo en bruto tiene uno (ese Value sin TAG) |
| `11111` | `0x1F` | Reserved |  |  |

| 2 bits superiores de CCCCC | Grupo |
|---|---|
| `00` | Referencia y nombre |
| `01` | Proposición |
| `10` | Estructura |
| `11` | Otros |

### Fundamento (`01`)

| Codec | Nombre | Subformato | Descripción |
|---|---|---|---|
| `0x20` | [SOURCE](/es/grammar/edge/source/) |  | Conecta un registro, o el documento entero, con su origen. Target (Edge Id del BODY; en el HEAD, `0` = documento entero), Origin (Reference, ABSENT o UNKNOWN-VALUE). La naturaleza del origen se escribe con un TRIPLE que tiene el origen como Subject; la naturaleza de la cita (fecha de consulta, ubicación, hash del texto original) con un QUALIFIER que se adjunta al SOURCE. El SOURCE del documento entero y sus QUALIFIER van en el HEAD |
| `0x21`~`0x3F` | Reserved |  |  |

- El alcance en el texto original, el agente productor, la confiabilidad, el periodo de vigencia por artículo y los registros antiguos se escriben con QUALIFIER; la primera versión en que entró se calcula a partir del historial de versiones ([SOURCE](/es/grammar/edge/source/#expresión-de-otros-fundamentos)).

### Ejecución (`10`)

| CCCCC | Codec | Nombre | Descripción |
|---|---|---|---|
| `00000` | `0x40` | Reserved |  |
| `00001` | `0x41` | FUNCTION-DECLARE | Declaración de función. Símbolo, lista de símbolos de parámetros, tipo de retorno, cuerpo (BLOCK) |
| `00010` | `0x42` | TYPE-DECLARE | Declaración de tipo. Símbolo y composición (lista de símbolos de campos, valores de enumeración, destino del alias) |
| `00011`~`00111` | `0x43`~`0x47` | Reserved |  |
| `01000` | `0x48` | CONST | Expresión constante. Un Value incorporado |
| `01001` | `0x49` | UNARY | Expresión unaria. Operador de 1 WORD, operando |
| `01010` | `0x4A` | BINARY | Expresión binaria. Operador de 1 WORD, izquierda, derecha |
| `01011` | `0x4B` | CALL | Llamada. Función de destino, número de argumentos, argumentos × número de argumentos |
| `01100` | `0x4C` | MEMBER | Acceso a miembro. Destino, símbolo del campo |
| `01101` | `0x4D` | INDEX | Acceso por índice. Destino, índice |
| `01110` | `0x4E` | CONSTRUCT | Construcción de valor compuesto (lista, registro). Tipo, número de elementos, elementos × número de elementos |
| `01111` | `0x4F` | CONDITIONAL | Expresión condicional. Condición, valor si es verdadera, valor si es falsa |
| `10000` | `0x50` | BLOCK | Secuencia ordenada de sentencias. Número de sentencias, sentencias × número de sentencias |
| `10001` | `0x51` | ASSIGN | Asignación. Destino (símbolo, MEMBER, INDEX), valor |
| `10010` | `0x52` | IF | Bifurcación condicional. Condición, BLOCK verdadero, falso (BLOCK·IF; `0` si no hay) |
| `10011` | `0x53` | SWITCH | Bifurcación múltiple. Destino, número de ramas, (valor, BLOCK) × número de ramas, BLOCK por defecto (`0` si no hay) |
| `10100` | `0x54` | WHILE | Repetición condicional. Condición, BLOCK del cuerpo |
| `10101` | `0x55` | FOREACH | Repetición por recorrido. Símbolo del elemento, destino, BLOCK del cuerpo |
| `10110` | `0x56` | JUMP | Control de repetición. Tipo de 1 WORD (break, continue), repetición de destino |
| `10111` | `0x57` | RETURN | Retorno. Valor (`0` si no hay) |
| `11000` | `0x58` | RAISE | Lanzamiento de error. Valor del error |
| `11001` | `0x59` | TRY | Manejo de errores. BLOCK del cuerpo, símbolo del error, BLOCK de manejo, BLOCK de cierre (`0` si no hay) |
| `11010`~`11111` | `0x5A`~`0x5F` | Reserved |  |

| 2 bits superiores de CCCCC | Grupo |
|---|---|
| `00` | Declaración |
| `01` | Expresión |
| `10` | Sentencia |
| `11` | Error |

### TOULMIN (`11`)

Detalles: [TOULMIN](/es/grammar/edge/toulmin/)

| CCCCC | Codec | Nombre | Descripción |
|---|---|---|---|
| `00000` | `0x60` | [CASE-DECLARE](/es/grammar/edge/toulmin/node/) | Declaración de caso. Grafo de juicio que contiene nodos y relaciones |
| `00001` | `0x61` | [PREDICATE-DECLARE](/es/grammar/edge/toulmin/expr/) | Declaración de predicado. Función o expresión de juicio, criterio de juicio (Spec), contrato de hechos (Ground) |
| `00010` | `0x62` | [SPEC-DECLARE](/es/grammar/edge/toulmin/node/) | Declaración de criterio de juicio. Constantes y listas (Backing) |
| `00011` | `0x63` | [RULE-DECLARE](/es/grammar/edge/toulmin/node/) | Declaración de aserción. Coloca un predicado como regla general (Warrant) dentro de un caso. Puede ser atacada. |
| `00100` | `0x64` | [COUNTER-DECLARE](/es/grammar/edge/toulmin/node/) | Declaración de refutación. Ataca con su propia conclusión. El Level por defecto es Fail |
| `00101` | `0x65` | [EXCEPT-DECLARE](/es/grammar/edge/toulmin/node/) | Declaración de excepción. Ataca sin conclusión propia. El Level por defecto es Review |
| `00110`~`00111` | `0x66`~`0x67` | Reserved |  |
| `01000` | `0x68` | [ATTACKS](/es/grammar/edge/toulmin/link/) | Relación de ataque. El juicio del atacante reduce gradualmente el juicio del destino. |
| `01001` | `0x69` | [SUPERSEDES](/es/grammar/edge/toulmin/link/) | Relación de exclusión. Si el atacante está Active, el destino queda excluido de forma determinista del cómputo. |
| `01010` | `0x6A` | SUPERSEDE-CHAIN | Cadena de prioridad `A > B > C`. Abreviatura de SUPERSEDES por pares. Layout sin decidir |
| `01011`~`01111` | `0x6B`~`0x6F` | Reserved |  |
| `10000` | `0x70` | [RUN](/es/grammar/edge/toulmin/link/) | Composición de ejecución. Si el nodo está Active, ejecuta un caso subordinado (DAG). |
| `10001` | `0x71` | [DO](/es/grammar/edge/toulmin/link/) | Acción que se realiza si el nodo está Active |
| `10010` | `0x72` | [DO-ONCE](/es/grammar/edge/toulmin/link/) | Acción que se realiza una sola vez aunque se reintente |
| `10011` | `0x73` | [UNDO](/es/grammar/edge/toulmin/link/) | Acción compensatoria de DO (saga). Si falla un paso posterior, se ejecuta en orden inverso. |
| `10100` | `0x74` | [CHECKING](/es/grammar/edge/toulmin/link/) | Conexión que solo juzga, sin efectos secundarios |
| `10101` | `0x75` | [ENTRY](/es/grammar/edge/toulmin/node/) | Punto de entrada externo. Ejecuta o juzga un caso |
| `10110` | `0x76` | [TRIGGER](/es/grammar/edge/toulmin/node/) | Punto de entrada por evento o periodicidad, sin llamada externa |
| `10111` | `0x77` | Reserved |  |
| `11000` | `0x78` | VERDICT | Resultado del juicio de un nodo o registro. Resultado (Pass, Review, Fail), valor del juicio, Activated, Excluded, Level. Layout sin decidir. El juicio del documento entero es el Meta [VERDICT](/es/grammar/meta/verification/verdict/) (`0x44`) |
| `11001` | `0x79` | EVIDENCE | Evidencia del juicio. Ubicación, valor esperado, valor real (Fact). Layout sin decidir |
| `11010`~`11011` | `0x7A`~`0x7B` | Reserved |  |
| `111xx` | `0x7C`~`0x7F` | ISSUER-* | Formato definido por un Issuer |

| 2 bits superiores de CCCCC | Grupo |
|---|---|
| `00` | Declaración |
| `01` | Relación |
| `10` | Ejecución |
| `11` | Resultado (`0x7C`~`0x7F` es ISSUER) |

### Formatos ISSUER de Edge

Tras `0x7C`~`0x7F` (ISSUER-1/2/4/16WORD), el TAG de extensión de Codec lleva el Issuer y el número de formato. Los 2 bits superiores del número de formato son la familia. El espacio de números de formato es independiente del de Value.

| Issuer | Número de formato | Nombre | Familia | Descripción |
|---|---|---|---|---|
| `0x0000` GEUL | `0xC000` | [SOURCE](/es/grammar/edge/toulmin/source/) | TOULMIN | Texto original de autoría. Ancho de SPAN y Value UTF8 |
| `0x0000` GEUL | `0xC001` | [TEXT](/es/grammar/edge/toulmin/source/) | TOULMIN | Nombres y cadenas |
| `0x0000` GEUL | `0xC002` | [SECTION](/es/grammar/edge/toulmin/source/) | TOULMIN | Inicio de sección. Código de sección |
| `0x0000` GEUL | `0xC003` | [CASE-BEGIN](/es/grammar/edge/toulmin/source/) | TOULMIN | Inicio del ámbito de un caso |
| `0x0000` GEUL | `0xC004` | [CASE-END](/es/grammar/edge/toulmin/source/) | TOULMIN | Fin del ámbito de un caso |
| `0x0000` GEUL | `0xC005` | [PROSE](/es/grammar/edge/toulmin/source/) | TOULMIN | Párrafo descriptivo (SPAN) |
| `0x0000` GEUL | `0xC010` | [NAMESPACE](/es/grammar/edge/toulmin/node/) | TOULMIN | NODE. `this document is` |
| `0x0000` GEUL | `0xC011` | [FUNC](/es/grammar/edge/toulmin/node/) | TOULMIN | NODE. Referencia a función |
| `0x0000` GEUL | `0xC012` | [FIELD](/es/grammar/edge/toulmin/node/) | TOULMIN | NODE. `is required` |
| `0x0000` GEUL | `0xC013` | [ALIAS](/es/grammar/edge/toulmin/node/) | TOULMIN | NODE. `see … from` |
| `0x0000` GEUL | `0xC014` | [GROUP](/es/grammar/edge/toulmin/node/) | TOULMIN | NODE. Grupo de ejecución ordenado |
| `0x0000` GEUL | `0xC020` | [REQUIRES](/es/grammar/edge/toulmin/link/) | TOULMIN | LINK. Caso → campo |
| `0x0000` GEUL | `0xC021` | [MEANS](/es/grammar/edge/toulmin/link/) | TOULMIN | LINK. Elemento de definición → valor o tipo |
| `0x0000` GEUL | `0xC022` | [HAS](/es/grammar/edge/toulmin/link/) | TOULMIN | LINK. Elemento de definición → campo |
| `0x0000` GEUL | `0xC023` | [RUNS](/es/grammar/edge/toulmin/link/) | TOULMIN | LINK. Punto de entrada → caso, ejecución |
| `0x0000` GEUL | `0xC024` | [EVALUATES](/es/grammar/edge/toulmin/link/) | TOULMIN | LINK. Punto de entrada → caso, juicio |
| `0x0000` GEUL | `0xC025` | [TRIGGERS](/es/grammar/edge/toulmin/link/) | TOULMIN | LINK. Trigger → caso |
| `0x0000` GEUL | `0xC026` | [UNTIL](/es/grammar/edge/toulmin/link/) | TOULMIN | LINK. Trigger → caso (`every … until`) |
| `0x0000` GEUL | `0xC027` | [SAME-AS](/es/grammar/edge/toulmin/link/) | TOULMIN | LINK. Nodo → identificador global |
| `0x0000` GEUL | `0xC028` | [IMPORTED-FROM](/es/grammar/edge/toulmin/link/) | TOULMIN | LINK. Alias → ruta (TEXT) |
| `0x0000` GEUL | `0xC029` | [LABEL](/es/grammar/edge/toulmin/link/) | TOULMIN | LINK. Nodo → TEXT, notación del nombre |

## Value

`0000 1LLL LCCC CCCC` — [Value](/es/grammar/value/)

Los 2 bits superiores del Codec son la familia. NUMERIC/DECIMAL se subdividen con el tercer bit superior (`000` NUMERIC, `001` DECIMAL).

| 2 bits superiores | Familia | Código directo | Número de formato |
|---|---|---|---|
| `00` | [NUMERIC](/es/grammar/value/numeric/)/[DECIMAL](/es/grammar/value/decimal/) | `0x00`~`0x1F` | `0x0000`~`0x3FFF` |
| `01` | [TIME](/es/grammar/value/time/) | `0x20`~`0x3F` | `0x4000`~`0x7FFF` |
| `10` | [TEXT](/es/grammar/value/text/) | `0x40`~`0x5F` | `0x8000`~`0xBFFF` |
| `11` | [BINARY](/es/grammar/value/binary/) | `0x60`~`0x7B` | `0xC000`~`0xFFFF` |

### Códigos directos

| Codec | Nombre | Familia | Descripción |
|---|---|---|---|
| `0x00` | [BOOL](/es/grammar/value/numeric/bool/) | NUMERIC | false o true en 1 WORD fijo |
| `0x01` | [SIGNED-INTEGER](/es/grammar/value/numeric/signed-integer/) | NUMERIC | Entero con signo en complemento a dos, con el mínimo de WORD |
| `0x02` | [UNSIGNED-INTEGER](/es/grammar/value/numeric/unsigned-integer/) | NUMERIC | Entero de magnitud unsigned big-endian, con el mínimo de WORD |
| `0x03` | [BINARY-FLOAT](/es/grammar/value/numeric/binary-float/) | NUMERIC | Escalar IEEE 754 binary16/32/64/128 con Payload de 1/2/4/8 WORD |
| `0x04` | [COORDINATE-EARTH](/es/grammar/value/numeric/coordinate-earth/) | NUMERIC | Latitud y longitud binary64 de la Tierra (WGS 84), incertidumbre binary32 y el Reference de su unidad (ABSENT = desconocida) |
| `0x05` | [COORDINATE-GEO](/es/grammar/value/numeric/coordinate-geo/) | NUMERIC | Reference de un cuerpo celeste, latitud y longitud binary64, incertidumbre binary32 y el Reference de su unidad |
| `0x06` | [QUANTITY](/es/grammar/value/numeric/quantity/) | NUMERIC | amount Value numérico (entero, BINARY-FLOAT, decimal, fracción), Reference de la unidad, límites inferior y superior. La unidad y los límites pueden omitirse (ABSENT `0x0000`) |
| `0x07` | [FRACTION](/es/grammar/value/numeric/fraction/) | NUMERIC | Fracción que conserva la notación original: numerador entero o decimal, denominador entero o decimal sin signo. No se simplifica |
| `0x08`~`0x0F` | Reserved | NUMERIC |  |
| `0x10` | [SIGNED-DECIMAL](/es/grammar/value/decimal/signed-decimal/) | DECIMAL | `C×10^E` con exponente `E` signed y coefficient `C` en complemento a dos con el mínimo de WORD |
| `0x11` | [UNSIGNED-DECIMAL](/es/grammar/value/decimal/unsigned-decimal/) | DECIMAL | `C×10^E` con exponente `E` signed y coefficient `C` unsigned con el mínimo de WORD |
| `0x12`~`0x1F` | Reserved | DECIMAL |  |
| `0x20` | [GREGORIAN-DATE](/es/grammar/value/time/gregorian-date/) | TIME | Número de días signed respecto a `1970-01-01` del calendario gregoriano proléptico |
| `0x21` | [CIVIL-TIME-NANOSECONDS](/es/grammar/value/time/civil-time-nanoseconds/) | TIME | Cuenta unsigned de nanosegundos desde la medianoche del día civil |
| `0x22` | [POSIX-TIMESTAMP-SECONDS](/es/grammar/value/time/posix-timestamp-seconds/) | TIME | Cuenta signed de segundos desde la época Unix/POSIX |
| `0x23` | [DURATION-SECONDS](/es/grammar/value/time/duration-seconds/) | TIME | Tiempo transcurrido signed en segundos SI, sin época |
| `0x24`/`0x25` | [EDTF](/es/grammar/value/time/edtf/) | TIME | Cadena de fecha EDTF (ISO 8601-2). Bytes pares/impares. No se usa para fechas expresables con GREGORIAN-DATE |
| `0x26`/`0x27` | [GEDCOM-DATE](/es/grammar/value/time/gedcom-date/) | TIME | Cadena de valor de fecha GEDCOM 7. Conserva la notación original de otros calendarios (juliano, etc.). Bytes pares/impares |
| `0x28`~`0x3F` | Reserved | TIME |  |
| `0x40` | [UTF8-TEXT-EVEN](/es/grammar/value/text/utf8-text/) | TEXT | Secuencia de bytes UTF-8 válida que no implica normalización. Bytes pares |
| `0x41` | [UTF8-TEXT-ODD](/es/grammar/value/text/utf8-text/) | TEXT | Igual que el anterior. Bytes impares |
| `0x42`/`0x43` | Reserved | TEXT |  |
| `0x44` | [URI-EVEN](/es/grammar/value/text/uri/) | TEXT | Secuencia de bytes ASCII de la producción `URI` de RFC 3986. Bytes pares |
| `0x45` | [URI-ODD](/es/grammar/value/text/uri/) | TEXT | Igual que el anterior. Bytes impares |
| `0x46` | [LANGUAGE-BCP47-CODE-EVEN](/es/grammar/value/text/language-bcp47-code/) | TEXT | Secuencia de bytes ASCII de una etiqueta de idioma BCP 47 completa con mayúsculas canónicas. Bytes pares |
| `0x47` | [LANGUAGE-BCP47-CODE-ODD](/es/grammar/value/text/language-bcp47-code/) | TEXT | Igual que el anterior. Bytes impares |
| `0x48` | [LANGUAGE-SHORT-CODE](/es/grammar/value/text/language-short-code/) | TEXT | Código comprimido de idioma primario de GEUL, con Payload fijo de 1 WORD |
| `0x49` | Reserved | TEXT |  |
| `0x4A`/`0x4B` | [UTF8-LANGUAGE-TEXT](/es/grammar/value/text/utf8-language-text/) | TEXT | Texto con idioma. Un registro Value de idioma (LANGUAGE-SHORT-CODE o LANGUAGE-BCP47-CODE) y bytes UTF-8. Paridad pares/impares de los bytes del texto |
| `0x4C`~`0x5F` | Reserved | TEXT |  |
| `0x60` | [UUID](/es/grammar/value/binary/uuid/) | BINARY | UUID de 128 bits de RFC 9562, con Payload fijo de 8 WORD |
| `0x61` | [SHA-256-DIGEST](/es/grammar/value/binary/sha-256-digest/) | BINARY | Resultado de SHA-256, con Payload fijo de 16 WORD |
| `0x62` | [SHA1-DIGEST](/es/grammar/value/binary/sha1-digest/) | BINARY | Resultado de SHA-1, con Payload fijo de 10 WORD. Solo para identificación, como los ID de objeto de git |
| `0x63`~`0x7B` | Reserved | BINARY |  |
| `0x7C`~`0x7F` | ISSUER-* |  | Formato definido por un Issuer. Véase más abajo Formatos ISSUER de Value |

### Formatos ISSUER de Value

Tras `0x7C`~`0x7F` (ISSUER-1/2/4/16WORD), el TAG de extensión de Codec lleva el Issuer y el número de formato. Los 2 bits superiores del número de formato son la familia.

| Issuer | Número de formato | Nombre | Familia | Descripción |
|---|---|---|---|---|
| `0x0000` GEUL | `0x4000` | [DURATION-NANOSECONDS](/es/grammar/value/time/duration-nanoseconds/) | TIME | Tiempo transcurrido signed en nanosegundos, sin época |
| `0x0000` GEUL | `0xC000` | [OPAQUE-BYTES-EVEN](/es/grammar/value/binary/opaque-bytes/) | BINARY | Secuencia de bytes de significado y formato desconocidos. Bytes pares |
| `0x0000` GEUL | `0xC001` | [OPAQUE-BYTES-ODD](/es/grammar/value/binary/opaque-bytes/) | BINARY | Igual que el anterior. Bytes impares |
| `0x0000` GEUL | `0xC002` | [BIT-VECTOR](/es/grammar/value/binary/bit-vector/) | BINARY | N bits almacenados MSB-first tras el bit-count |
| `0x0001` ADHOC | `0x0000` | BFLOAT16 | NUMERIC | Bits de intercambio BF16 con Payload fijo de 1 WORD |
| `0x0001` ADHOC | `0x0500` | [DENSE-I16-VECTOR](/es/grammar/value/vector/dense-i16-vector/) | NUMERIC | Vector contiguo de int16 big-endian |
| `0x0001` ADHOC | `0x0501` | [DENSE-U16-VECTOR](/es/grammar/value/vector/dense-u16-vector/) | NUMERIC | Vector contiguo de uint16 big-endian |
| `0x0001` ADHOC | `0x0502` | [DENSE-I32-VECTOR](/es/grammar/value/vector/dense-i32-vector/) | NUMERIC | Vector contiguo de int32 big-endian |
| `0x0001` ADHOC | `0x0503` | [DENSE-U32-VECTOR](/es/grammar/value/vector/dense-u32-vector/) | NUMERIC | Vector contiguo de uint32 big-endian |
| `0x0001` ADHOC | `0x0504` | [DENSE-I64-VECTOR](/es/grammar/value/vector/dense-i64-vector/) | NUMERIC | Vector contiguo de int64 big-endian |
| `0x0001` ADHOC | `0x0505` | [DENSE-U64-VECTOR](/es/grammar/value/vector/dense-u64-vector/) | NUMERIC | Vector contiguo de uint64 big-endian |
| `0x0001` ADHOC | `0x0506` | [DENSE-BINARY16-VECTOR](/es/grammar/value/vector/dense-binary16-vector/) | NUMERIC | Vector contiguo IEEE 754 binary16 |
| `0x0001` ADHOC | `0x0507` | [DENSE-BFLOAT16-VECTOR](/es/grammar/value/vector/dense-bfloat16-vector/) | NUMERIC | Vector contiguo BF16 |
| `0x0001` ADHOC | `0x0508` | [DENSE-BINARY32-VECTOR](/es/grammar/value/vector/dense-binary32-vector/) | NUMERIC | Vector contiguo IEEE 754 binary32 |
| `0x0001` ADHOC | `0x0509` | [DENSE-BINARY64-VECTOR](/es/grammar/value/vector/dense-binary64-vector/) | NUMERIC | Vector contiguo IEEE 754 binary64 |
| `0x0001` ADHOC | `0x050A` | [POINT2-BINARY64](/es/grammar/value/vector/point2-binary64/) | NUMERIC | Vector bidimensional IEEE binary64 en el orden `(x,y)` |
| `0x0001` ADHOC | `0x050B` | [POINT3-BINARY64](/es/grammar/value/vector/point3-binary64/) | NUMERIC | Vector tridimensional IEEE binary64 en el orden `(x,y,z)` |
| `0x0001` ADHOC | `0x050C` | [BBOX2-BINARY64](/es/grammar/value/vector/bbox2-binary64/) | NUMERIC | Vector IEEE binary64 en el orden `(minX,minY,maxX,maxY)` |
| `0x0001` ADHOC | `0x0600` | [DESCRIBED-DENSE-TENSOR](/es/grammar/value/tensor/described-dense-tensor/) | NUMERIC | element-format, rank, shape y payload denso C-contiguous |
| `0x0001` ADHOC | `0x0601` | [DESCRIBED-PACKED-TENSOR](/es/grammar/value/tensor/described-packed-tensor/) | NUMERIC | packed-format, rank, shape y payload empaquetado low-bit-first dentro del octeto |
| `0x0001` ADHOC | `0x0700` | [COMPLEX64](/es/grammar/value/etc/complex64/) | NUMERIC | Dos binary32 en el orden `(real, imag)` |
| `0x0001` ADHOC | `0x0701` | [COMPLEX128](/es/grammar/value/etc/complex128/) | NUMERIC | Dos binary64 en el orden `(real, imag)` |
| `0x0001` ADHOC | `0x0702` | [RATIONAL-I64](/es/grammar/value/etc/rational-i64/) | NUMERIC | numerator int64 normalizado y denominator int64 positivo |
| `0x0001` ADHOC | `0x0703` | [CLOSED-INTERVAL-BINARY64](/es/grammar/value/etc/closed-interval-binary64/) | NUMERIC | Intervalo cerrado binary64 con `lower ≤ upper` |
| `0x0001` ADHOC | `0x0704` | [QUATERNION-BINARY32](/es/grammar/value/etc/quaternion-binary32/) | NUMERIC | Cuatro binary32 en el orden `(x,y,z,w)` |
| `0x0001` ADHOC | `0xC000` | [BLAKE3-256-DIGEST](/es/grammar/value/binary/blake3-256-digest/) | BINARY | Resultado por defecto de BLAKE3, con Payload fijo de 16 WORD |
| `0x0020` IETF | `0x8000` | [URI-RELATIVE-REF-EVEN](/es/grammar/value/text/uri-relative-ref/) | TEXT | Secuencia de bytes ASCII de relative-ref de RFC 3986. Bytes pares |
| `0x0020` IETF | `0x8001` | [URI-RELATIVE-REF-ODD](/es/grammar/value/text/uri-relative-ref/) | TEXT | Igual que el anterior. Bytes impares |
| `0x0020` IETF | `0xC000` | [CRC32C](/es/grammar/value/binary/crc32c/) | BINARY | Resultado de CRC-32C de Castagnoli, con Payload fijo de 2 WORD |
| `0x0020` IETF | `0xC001` | [IPV4-ADDRESS](/es/grammar/value/binary/ipv4-address/) | BINARY | Dirección IPv4 de 32 bits, con Payload fijo de 2 WORD |
| `0x0020` IETF | `0xC002` | [IPV6-ADDRESS](/es/grammar/value/binary/ipv6-address/) | BINARY | Dirección IPv6 de 128 bits, con Payload fijo de 8 WORD |
| `0x0040` IEEE | `0x2000` | [IEEE-DECIMAL32-DPD](/es/grammar/value/decimal/ieee-decimal32-dpd/) | DECIMAL | IEEE 754 decimal32 DPD, con Payload fijo de 2 WORD |
| `0x0040` IEEE | `0x2001` | [IEEE-DECIMAL64-DPD](/es/grammar/value/decimal/ieee-decimal64-dpd/) | DECIMAL | IEEE 754 decimal64 DPD, con Payload fijo de 4 WORD |
| `0x0040` IEEE | `0x2002` | [IEEE-DECIMAL128-DPD](/es/grammar/value/decimal/ieee-decimal128-dpd/) | DECIMAL | IEEE 754 decimal128 DPD, con Payload fijo de 8 WORD |
| `0x0040` IEEE | `0x2003` | [IEEE-DECIMAL32-BID](/es/grammar/value/decimal/ieee-decimal32-bid/) | DECIMAL | IEEE 754 decimal32 BID, con Payload fijo de 2 WORD |
| `0x0040` IEEE | `0x2004` | [IEEE-DECIMAL64-BID](/es/grammar/value/decimal/ieee-decimal64-bid/) | DECIMAL | IEEE 754 decimal64 BID, con Payload fijo de 4 WORD |
| `0x0040` IEEE | `0x2005` | [IEEE-DECIMAL128-BID](/es/grammar/value/decimal/ieee-decimal128-bid/) | DECIMAL | IEEE 754 decimal128 BID, con Payload fijo de 8 WORD |
| `0x0040` IEEE | `0x4000` | [POSIX-TIMESTAMP-NANOSECONDS](/es/grammar/value/time/posix-timestamp-nanoseconds/) | TIME | Cuenta signed de nanosegundos desde la época Unix/POSIX |
| `0x0040` IEEE | `0xC000` | [MAC-48-ADDRESS](/es/grammar/value/binary/mac-48-address/) | BINARY | Dirección MAC IEEE 802 de 48 bits, con Payload fijo de 3 WORD |
| `0x0041` KHRONOS | `0x0000` | [RGBA8-UNORM](/es/grammar/value/vector/rgba8-unorm/) | NUMERIC | Vector empaquetado fijo de 4×UNORM8 en el orden R, G, B, A |
| `0x0041` KHRONOS | `0x0001` | [BGRA8-UNORM](/es/grammar/value/vector/bgra8-unorm/) | NUMERIC | Vector empaquetado fijo de 4×UNORM8 en el orden B, G, R, A |
| `0x0043` ONNX | `0x0000` | FP8-E4M3FN | NUMERIC | Escalar ONNX E4M3FN en el octeto superior del Payload |
| `0x0043` ONNX | `0x0001` | FP8-E4M3FNUZ | NUMERIC | Escalar ONNX E4M3FNUZ en el octeto superior del Payload |
| `0x0043` ONNX | `0x0002` | FP8-E5M2 | NUMERIC | Escalar ONNX E5M2 en el octeto superior del Payload |
| `0x0043` ONNX | `0x0003` | FP8-E5M2FNUZ | NUMERIC | Escalar ONNX E5M2FNUZ en el octeto superior del Payload |
| `0x0044` OCP | `0x0000` | FP8-E8M0FNU | NUMERIC | Escalar unsigned solo de exponente E8M0FNU en el octeto superior del Payload |
| `0x0044` OCP | `0x0001` | FP4-E2M1FN | NUMERIC | Escalar ONNX/DLPack E2M1FN en el nibble superior del Payload |
| `0x0060` BIPM | `0x4000` | [TAI-TIMESTAMP-SECONDS](/es/grammar/value/time/tai-timestamp-seconds/) | TIME | Cuenta signed de segundos SI desde `1970-01-01T00:00:00 TAI` |
| `0x0060` BIPM | `0x4001` | [TAI-TIMESTAMP-NANOSECONDS](/es/grammar/value/time/tai-timestamp-nanoseconds/) | TIME | Cuenta signed de nanosegundos desde la misma época TAI |
| `0x0062` NIST | `0xC000` | [SHA-512-DIGEST](/es/grammar/value/binary/sha-512-digest/) | BINARY | Resultado de SHA-512, con Payload fijo de 32 WORD |
| `0x0062` NIST | `0xC001` | [SHA3-256-DIGEST](/es/grammar/value/binary/sha3-256-digest/) | BINARY | Resultado de SHA3-256, con Payload fijo de 16 WORD |
| `0x0063` GPS | `0x4000` | [GPS-TIMESTAMP-SECONDS](/es/grammar/value/time/gps-timestamp-seconds/) | TIME | Cuenta signed de segundos desde la época GPS |
| `0x0063` GPS | `0x4001` | [GPS-TIMESTAMP-NANOSECONDS](/es/grammar/value/time/gps-timestamp-nanoseconds/) | TIME | Cuenta signed de nanosegundos desde la época GPS |

## Meta

`0001 1LLL LCCC CCCC` — [Meta](/es/grammar/meta/)

Los 3 bits superiores del Codec son la clase. Meta no tiene códigos ISSUER.

| 3 bits superiores | Clase | Código directo | Qué trata |
|---|---|---|---|
| `000` | [Estructura](/es/grammar/meta/structure/) | `0x00`~`0x0F` | Límites y longitud del documento |
| `001` | [Definición](/es/grammar/meta/declaration/) | `0x10`~`0x1F` | Declaraciones de interpretación |
| `010` | [Procedencia](/es/grammar/meta/provenance/) | `0x20`~`0x2F` | Quién, cuándo, dónde |
| `011` | [Linaje](/es/grammar/meta/lineage/) | `0x30`~`0x3F` | De qué y cómo surgió |
| `100` | [Verificación](/es/grammar/meta/verification/) | `0x40`~`0x4F` | Si es fiable |
| `101` | [Política](/es/grammar/meta/policy/) | `0x50`~`0x5F` | Cómo se trata |
| `110` | [IMPORT](/es/grammar/meta/import/) | `0x60`~`0x6F` | Importa un documento externo con un IMPORT ID (`IMPORT-DOC`) |
| `111` | Reserved | `0x70`~`0x7F` |  |

### Estructura (`000`)

| Codec | Nombre | Descripción |
|---|---|---|
| `0x00` | [DOC-1WORD](/es/grammar/meta/structure/doc/) | Inicio de documento con la longitud total indicada en un Payload de 1 WORD |
| `0x01` | [DOC-2WORD](/es/grammar/meta/structure/doc/) | Inicio de documento con la longitud total indicada en un Payload de 2 WORD |
| `0x02` | [DOC-4WORD](/es/grammar/meta/structure/doc/) | Inicio de documento con la longitud total indicada en un Payload de 4 WORD |
| `0x03`~`0x0D` | Reserved |  |
| `0x0E` | [BODY](/es/grammar/meta/structure/body/) | 1 WORD. Termina el HEAD del documento y comienza el BODY. |
| `0x0F` | [END](/es/grammar/meta/structure/end/) | 1 WORD. Cierra el documento. |

### Definición (`001`)

| Codec | Nombre | Descripción |
|---|---|---|
| `0x10` | [SPEC-VERSION](/es/grammar/meta/declaration/spec-version/) | Versión de la especificación GEUL que sigue. El Payload es directamente un entero unsigned del ancho más corto. v1 es `0x0001` (registro `0x1890 0x0001`) |
| `0x11` | [PROFILE](/es/grammar/meta/declaration/profile/) | Perfil aplicado |
| `0x12` | [DOC-ID](/es/grammar/meta/declaration/doc-id/) | Identificador de este documento. Reference `DOC-POINTER` incorporado (Issuer, ID de documento, versión 0) |
| `0x13` | [EFFECTIVE-FROM](/es/grammar/meta/declaration/effective-from/) | Fecha de entrada en vigor de esta versión. Value GREGORIAN-DATE o POSIX-TIMESTAMP. Si falta, el momento de publicación |
| `0x14` | [EFFECTIVE-UNTIL](/es/grammar/meta/declaration/effective-until/) | Fin de la vigencia de esta versión (norma temporal). Si falta, hasta que entre en vigor la versión siguiente |
| `0x15` | Reserved |  |
| `0x16` | [DEFAULT-LANGUAGE](/es/grammar/meta/declaration/default-language/) | Idioma por defecto |
| `0x17`~`0x1F` | Reserved |  |

### Procedencia (`010`)

| Codec | Nombre | Descripción |
|---|---|---|
| `0x20` | [AUTHOR](/es/grammar/meta/provenance/author/) | Autor. Reference (git author) |
| `0x21` | [CO-AUTHOR](/es/grammar/meta/provenance/co-author/) | Coautor. Reference (git `Co-authored-by`) |
| `0x22` | [CREATED-AT](/es/grammar/meta/provenance/created-at/) | Momento de creación. Value TIME (git author date) |
| `0x23` | [MODIFIED-AT](/es/grammar/meta/provenance/modified-at/) | Momento de modificación. Value TIME |
| `0x24` | [RECORDED-BY](/es/grammar/meta/provenance/recorded-by/) | Entidad que lo registró. Reference (git committer) |
| `0x25` | [RECORDED-AT](/es/grammar/meta/provenance/recorded-at/) | Momento del registro. Value TIME (git commit date) |
| `0x26`~`0x2F` | Reserved |  |

- El material de origen y su rango, momento de obtención y hash no se escriben como Meta, sino con el Edge de fundamento [SOURCE](/es/grammar/edge/source/#procedencia-del-documento-entero) del HEAD (Target `0`) y sus QUALIFIER.

### Linaje (`011`)

| Codec | Nombre | Descripción |
|---|---|---|
| `0x30` | [PARENT](/es/grammar/meta/lineage/parent/) | Hash de contenido de la versión inmediatamente anterior (git parent). Si falta, es la primera versión; si hay varios, es una fusión (git merge commit). |
| `0x31` | [DERIVED-FROM](/es/grammar/meta/lineage/derived-from/) | Derivado de registros o materiales de otro linaje. Para fijar una versión concreta de un material externo, se añade al [SOURCE](/es/grammar/edge/source/#procedencia-del-documento-entero) del HEAD un QUALIFIER de hash del texto original (P4092) (git submodule). |
| `0x32` | [GENERATED-BY](/es/grammar/meta/lineage/generated-by/) | Entidad generadora. Persona, modelo, motor de reglas |
| `0x33` | [TRANSFORMED-BY](/es/grammar/meta/lineage/transformed-by/) | Método de transformación. Herramienta, regla, versión |
| `0x34` | [CHERRY-PICKED-FROM](/es/grammar/meta/lineage/cherry-picked-from/) | Hash de contenido de la versión original de la que se tomó un cambio de otro linaje (git cherry-pick `-x`) |
| `0x35` | [REVERTS](/es/grammar/meta/lineage/reverts/) | Hash de contenido de la versión cuyo cambio se deshizo (git revert) |
| `0x36` | [REPLACES](/es/grammar/meta/lineage/replaces/) | Hash de contenido de la versión que se reescribió (git amend·rebase). La versión original no se borra. |
| `0x37` | [SQUASHED-FROM](/es/grammar/meta/lineage/squashed-from/) | Hashes de contenido de las versiones originales que se fusionaron en una (git squash) |
| `0x38` | [MESSAGE](/es/grammar/meta/lineage/message/) | Motivo del cambio. Value UTF8-LANGUAGE-TEXT, uno por idioma (git commit message) |
| `0x39` | [TAG](/es/grammar/meta/lineage/tag/) | Nombre inmutable que se pone a una versión. Value TEXT y hash de contenido (git annotated tag) |
| `0x3A` | [DELTA-BASE](/es/grammar/meta/lineage/delta-base/) | El archivo de esta versión es un diff respecto a una versión base del mismo documento (ID de versión de 2 WORD) (git packfile delta) |
| `0x3B` | [DELTA-REMOVE](/es/grammar/meta/lineage/delta-remove/) | Lista de LOCAL ID (Edge Id) que se quitan del BODY base en el diff |
| `0x3C` | [NEXT-LOCAL-ID](/es/grammar/meta/lineage/next-local-id/) | Siguiente LOCAL ID que se asignará (auto increment). Se coloca en el HEAD de la lista de versiones `versions.geul` |
| `0x3D`~`0x3F` | Reserved |  |

### Verificación (`100`)

| Codec | Nombre | Descripción |
|---|---|---|
| `0x40` | [ISSUER-KEY](/es/grammar/meta/verification/issuer-key/) | Declaración del ID de algoritmo de firma y de la clave pública de un Issuer autoemitido |
| `0x41` | [SIGNATURE](/es/grammar/meta/verification/signature/) | Firma sobre un objeto. La firma de un documento firma su hash de contenido (git signed commit·tag) |
| `0x42` | [SIGNED-OFF](/es/grammar/meta/verification/signed-off/) | Confirmación del derecho a contribuir. Reference (git `Signed-off-by`, DCO) |
| `0x43` | [CONFIDENCE](/es/grammar/meta/verification/confidence/) | Confiabilidad |
| `0x44` | [VERDICT](/es/grammar/meta/verification/verdict/) | Resultado del juicio del documento entero. Pass, Review, Fail. A nivel de nodo o registro, [TOULMIN](/es/grammar/edge/toulmin/) `VERDICT` (Edge `0x78`) |
| `0x45`~`0x4F` | Reserved |  |

### Política (`101`)

| Codec | Nombre | Descripción |
|---|---|---|
| `0x50` | [LICENSE](/es/grammar/meta/policy/license/) | Licencia. Reference |
| `0x51` | [ACCESS](/es/grammar/meta/policy/access/) | Alcance de divulgación |
| `0x52` | [PRIVACY](/es/grammar/meta/policy/privacy/) | Nivel de datos personales |
| `0x53` | [RETENTION](/es/grammar/meta/policy/retention/) | Plazo de conservación |
| `0x54` | [CONSENT](/es/grammar/meta/policy/consent/) | Alcance y fundamento del consentimiento |
| `0x55` | [USAGE](/es/grammar/meta/policy/usage/) | Restricciones de uso |
| `0x56`~`0x5F` | Reserved |  |

### IMPORT (`110`)

| Codec | Nombre | Descripción |
|---|---|---|
| `0x60` | [IMPORT-DOC](/es/grammar/meta/import/import-doc/) | Importa un documento externo con un IMPORT ID. Reference `DOC-POINTER` incorporado + IMPORT ID |
| `0x61`~`0x6F` | Reserved |  |
