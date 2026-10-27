---
title: "TOULMIN"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "Los Edge TOULMIN (Codec 0x60~0x7B) escriben grafos de juicio y ejecución con el modelo de argumentación de Toulmin. Esta página fija las reglas del documento TOULMIN, los campos comunes, la tabla de códigos, las reglas numéricas y el núcleo fijo de la autorrevisión."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Los Edge de la familia TOULMIN (2 bits superiores del Codec `11`, códigos directos `0x60`~`0x7B`) escriben grafos de juicio y ejecución con el modelo de argumentación de Toulmin. La declaración de afirmaciones, refutaciones y excepciones, las relaciones de ataque y exclusión, las conexiones de ejecución y los resultados del juicio son todos Edge. Un documento TANGEUL (el lenguaje de reglas del motor toulmin) es un documento GEUL. La extensión del archivo es `.geul`, igual que en los demás documentos.

Lo que esta página no fija sigue las reglas comunes de [Edge](/es/grammar/edge/) y [Registro y TAG WORD](/es/grammar/record/).

## Metacognición y autorrevisión

TOULMIN es un Codec de GEUL para que GEUL pueda tener metacognición de sí mismo. Solo si las reglas de juicio y ejecución también se describen en GEUL puede TOULMIN tomarlas como objeto y corregirse a sí mismo. Por eso TOULMIN no es un perfil de aplicación, sino el núcleo de la operación de GEUL, y se ubica en el espacio de códigos directos de Edge (`0x60`~`0x7B`).

- La autodescripción hace posible la automejora, pero corre el riesgo de errores circulares. Si las reglas juzgan por sí mismas su propia revisión, pueden pasar incluso revisiones que aflojan el criterio de juicio (sube la tasa de aprobación y baja la precisión real).
- El riesgo de circularidad se acepta, pero se corta por estructura.
  - **Núcleo fijo**: el significado del juicio (Pass, Review, Fail, ataque, exclusión, prioridad, la evaluación de 3 valores de [Juzgar sobre lo desconocido](#juzgar-sobre-lo-desconocido) y U → Review) queda fijado en esta especificación. No se puede cambiar con un documento TOULMIN. Está en el mismo lugar que las reglas integradas en el decodificador (capa 0 de [Direcciones de publicación y lista de versiones](/es/grammar/publishing/#capas)).
  - **Separación de ediciones**: la revisión del documento de reglas v(n) se juzga con las reglas de v(n−1) y con una comprobación externa. Las reglas no se juzgan a sí mismas. El resultado del juicio se pone en un documento distinto del objeto (el hash de contenido del objeto no cambia).
  - **Historial inmutable**: las revisiones se acumulan como versiones nuevas (`PARENT`, hash de contenido, firma). Como quedan las versiones antiguas, los errores circulares se pueden encontrar a posteriori y revertir. La red de seguridad de la autorrevisión es el modelo de ediciones de GEUL ([revisión de Documento](/es/grammar/document/#revisión)).
  - **Criterio externo**: se mantiene aparte un conjunto de casos de prueba que la vía de revisión no puede tocar. La adopción de una revisión se confirma con el resultado de ese conjunto.
- Prueba de refutación: se introduce a propósito una regla equivocada. Si el sistema la corrige y sube la puntuación del criterio externo, la automejora funciona. Si solo sube la tasa de aprobación y baja la puntuación del criterio externo, es un error circular.

## Códigos

Los registros TOULMIN usan uno de tres layouts. El layout lo fija el Codec (o el número de formato).

| Layout | Uso | Página |
|---|---|---|
| NODE | nodos del grafo como casos, reglas, definiciones y puntos de entrada | [NODE](/es/grammar/edge/toulmin/node/) |
| LINK | relaciones entre nodos (ataque, exclusión, ejecución, definición) | [LINK](/es/grammar/edge/toulmin/link/) |
| EXPR | expresiones de condición (predicados) | [EXPR](/es/grammar/edge/toulmin/expr/) |

El texto original y los registros de sección (SOURCE, TEXT, SECTION, CASE-BEGIN y CASE-END, PROSE) los fija [SOURCE y secciones](/es/grammar/edge/toulmin/source/).

### Códigos directos

| Codec | Nombre | Layout | TANGEUL | Significado |
|---|---|---|---|---|
| `0x60` | [CASE-DECLARE](/es/grammar/edge/toulmin/node/) | NODE | `in case of` | Declaración de caso. Grafo de juicio que contiene nodos y relaciones |
| `0x61` | [PREDICATE-DECLARE](/es/grammar/edge/toulmin/expr/) | EXPR | expresión de condición de Rules | Declaración de predicado. Expresión de juicio |
| `0x62` | [SPEC-DECLARE](/es/grammar/edge/toulmin/node/) | NODE | elemento de Definitions | Declaración de criterio de juicio (Backing). El bit role es el tipo de definición |
| `0x63` | [RULE-DECLARE](/es/grammar/edge/toulmin/node/) | NODE | general rule, nombre de regla de Rules | Declaración de afirmación (Warrant). Puede ser atacada |
| `0x64` | [COUNTER-DECLARE](/es/grammar/edge/toulmin/node/) | NODE | counter rule | Declaración de refutación. Ataca con una conclusión propia. El Level por defecto es Fail |
| `0x65` | [EXCEPT-DECLARE](/es/grammar/edge/toulmin/node/) | NODE | except rule | Declaración de excepción. Ataca sin conclusión propia. El Level por defecto es Review |
| `0x68` | [ATTACKS](/es/grammar/edge/toulmin/link/) | LINK | `don't X when Y` | Relación de ataque. El juicio del atacante reduce gradualmente el juicio del destino |
| `0x69` | [SUPERSEDES](/es/grammar/edge/toulmin/link/) | LINK | `X supersedes Y` | Relación de exclusión. Si el atacante está Active, saca de forma determinista al destino del recuento. Las cadenas (`A > B > C`) se escriben con un registro por cada par |
| `0x6A` | SUPERSEDE-CHAIN | — | | Cadena de prioridad `A > B > C`. Abreviatura de SUPERSEDES por pares. Solo está asignado el código; el layout aún no existe |
| `0x70` | [RUN](/es/grammar/edge/toulmin/link/) | LINK | `run c when n` | Composición de ejecución. Si el nodo está Active, ejecuta el caso subordinado (DAG) |
| `0x71` | [DO](/es/grammar/edge/toulmin/link/) | LINK | `do fn when n` | Acción que se realiza si el nodo está Active |
| `0x72` | [DO-ONCE](/es/grammar/edge/toulmin/link/) | LINK | `do fn once when n` | Acción que se realiza una sola vez aunque se reintente |
| `0x73` | [UNDO](/es/grammar/edge/toulmin/link/) | LINK | `undo fn when n` | Acción de compensación de DO (saga). Si fallan los pasos posteriores, se realiza en orden inverso |
| `0x74` | [CHECKING](/es/grammar/edge/toulmin/link/) | LINK | `checking c` | Conexión que solo juzga, sin efectos secundarios |
| `0x75` | [ENTRY](/es/grammar/edge/toulmin/node/) | NODE | `provides x` | Punto de entrada externo. Ejecuta o juzga un caso |
| `0x76` | [TRIGGER](/es/grammar/edge/toulmin/node/) | NODE | `on`, `every`, `until` | Punto de entrada por evento o periodo, sin llamada externa |
| `0x78` | VERDICT | — | | Resultado del juicio de un nodo o registro. Resultado (Pass, Review, Fail), valor de juicio, Activated, Excluded, Level. Solo está asignado el código; el layout aún no existe |
| `0x79` | EVIDENCE | — | | Evidencia del juicio. Posición, valor esperado, valor real (Fact). Solo está asignado el código; el layout aún no existe |
| `0x7C`~`0x7F` | ISSUER-* | | | Formatos definidos por el Issuer. Véase Formatos ISSUER más abajo |

- Los códigos directos que no están en la tabla (`0x66`, `0x67`, `0x6B`~`0x6F`, `0x77`, `0x7A`, `0x7B`) están reservados.
- Los 2 bits superiores de los 5 bits inferiores del Codec son el grupo: `00` declaración, `01` relación, `10` ejecución, `11` resultado (`0x7C`~`0x7F` son ISSUER).
- El juicio del documento entero lo lleva el Meta [VERDICT](/es/grammar/meta/verification/verdict/) (`0x44`), y el de nodos y registros lo lleva el `VERDICT` de TOULMIN (Edge `0x78`). Son Codec distintos, de Kind diferente.

### Formatos ISSUER

Los registros TOULMIN para los que no alcanzan los códigos directos se ponen como números de formato bajo `ISSUER-1WORD` (`0x7C`), Issuer `0x0000` (GEUL). Los números de formato son de la familia TOULMIN (`0xC000`~`0xFFFF`, 2 bits superiores `11`).

```
TAG WORD          0001 0LLL L111 1100      Edge, Codec 0x7C
[TAG de extensión de Length]
Issuer            0x0000
Número de formato 0xC000~0xC029
Edge Id           registro Reference LOCAL
Componentes      layout fijado por el formato
```

| Número de formato | Nombre | Layout | Significado |
|---|---|---|---|
| `0xC000` | [SOURCE](/es/grammar/edge/toulmin/source/) | ID, WORD de ancho de SPAN, Value UTF8 | texto original de autoría |
| `0xC001` | [TEXT](/es/grammar/edge/toulmin/source/) | ID, Value UTF8 | nombre o cadena |
| `0xC002` | [SECTION](/es/grammar/edge/toulmin/source/) | ID, código de sección 1 WORD | inicio de sección |
| `0xC003` | [CASE-BEGIN](/es/grammar/edge/toulmin/source/) | ID, REF (caso) | inicio del ámbito de un caso |
| `0xC004` | [CASE-END](/es/grammar/edge/toulmin/source/) | ID, REF (caso) | fin del ámbito de un caso |
| `0xC005` | [PROSE](/es/grammar/edge/toulmin/source/) | ID, SPAN | párrafo descriptivo |
| `0xC010` | [NAMESPACE](/es/grammar/edge/toulmin/node/) | NODE | `this document is` |
| `0xC011` | [FUNC](/es/grammar/edge/toulmin/node/) | NODE | referencia a función |
| `0xC012` | [FIELD](/es/grammar/edge/toulmin/node/) | NODE | `is required` |
| `0xC013` | [ALIAS](/es/grammar/edge/toulmin/node/) | NODE | `see … from` |
| `0xC014` | [GROUP](/es/grammar/edge/toulmin/node/) | NODE | grupo de ejecución ordenado |
| `0xC020` | [REQUIRES](/es/grammar/edge/toulmin/link/) | LINK | caso → campo |
| `0xC021` | [MEANS](/es/grammar/edge/toulmin/link/) | LINK | elemento de definición → valor o tipo |
| `0xC022` | [HAS](/es/grammar/edge/toulmin/link/) | LINK | elemento de definición → campo |
| `0xC023` | [RUNS](/es/grammar/edge/toulmin/link/) | LINK | punto de entrada → caso, ejecución |
| `0xC024` | [EVALUATES](/es/grammar/edge/toulmin/link/) | LINK | punto de entrada → caso, juicio |
| `0xC025` | [TRIGGERS](/es/grammar/edge/toulmin/link/) | LINK | disparador → caso |
| `0xC026` | [UNTIL](/es/grammar/edge/toulmin/link/) | LINK | disparador → caso (`every … until`) |
| `0xC027` | [SAME-AS](/es/grammar/edge/toulmin/link/) | LINK | nodo → identificador global |
| `0xC028` | [IMPORTED-FROM](/es/grammar/edge/toulmin/link/) | LINK | alias → ruta (TEXT) |
| `0xC029` | [LABEL](/es/grammar/edge/toulmin/link/) | LINK | nodo → TEXT, notación de nombre |

- El espacio de números de formato es independiente para cada Kind. El formato de GEUL `0xC000` de Value (OPAQUE-BYTES-EVEN) y el `0xC000` de Edge (SOURCE) son formatos distintos.
- Los números de formato solo se añaden. Un número asignado no se reutiliza para otro formato.

## Documento

Un archivo `.geul` es un DOC. Fuera del DOC no se ponen otros bytes.

```
DOC-1WORD/2WORD/4WORD     longitud total
  SPEC-VERSION            0x0001 (v1, entero sin Value integrado)
  PROFILE                 Value UTF8 "tangeul-<major>.<minor>". Actualmente "tangeul-1.0"
  [DEFAULT-LANGUAGE]      Value LANGUAGE-BCP47-CODE. Idioma de autoría ("en", "ko")
BODY
  SOURCE                  texto original de autoría. Primer registro del BODY
  registros de sentencia …  en el orden de declaración del documento
END
```

- HEAD: [SPEC-VERSION](/es/grammar/meta/declaration/spec-version/), [PROFILE](/es/grammar/meta/declaration/profile/), y opcional [DEFAULT-LANGUAGE](/es/grammar/meta/declaration/default-language/).
- El decodificador rechaza el documento si SPEC-VERSION es distinto o si el major de PROFILE es distinto. Si solo cambia el minor, lo lee.
- El primer registro del BODY es SOURCE. Todos los SPAN son rangos dentro de este texto original.
- El orden de los registros de sentencia es el mismo que el orden de declaración del documento. El orden de ejecución (disparo de `do` y `run`, compensación de `undo` en orden inverso) se apoya en este orden. En un documento TOULMIN el orden de los Edge tiene significado (excepción a la regla de orden de [Edge](/es/grammar/edge/)).
- Todos los registros del BODY son Edge. No se ponen registros Value independientes. Los valores se integran en el Payload del Edge.
- La identidad del caso y la importación usan Meta [DOC-ID](/es/grammar/meta/declaration/doc-id/) e [IMPORT-DOC](/es/grammar/meta/import/import-doc/) (el Subject y See de TANGEUL).

## Campos comunes

| Campo | Ancho | Descripción |
|---|---|---|
| ID | registro Reference LOCAL | Edge Id del registro. Primer elemento del Payload de todo registro |
| REF | registro Reference LOCAL | Edge Id que apunta a otro registro de este documento. `0` es ninguno |
| SPAN | ancho fijado por SOURCE × 2 | Rango dentro del texto original de autoría. Byte de inicio, número de bytes |

- ID y REF son registros Reference [LOCAL](/es/grammar/reference/local/) integrados (`0000 0LLL L000 1000` + ID del ancho más corto). El ancho lo fija la Length de ese registro y no se declara por documento.
- REF `0` (LOCAL `0`) es "ninguno". Es una regla de Codec que usa LOCAL `0` como ninguno ([LOCAL](/es/grammar/reference/local/)).
- Los Edge Id se asignan desde 1 y no se repiten dentro del documento. `0` no se usa como Edge Id, porque es el "ninguno" de REF.
- Como otros registros hacen referencias hacia delante a los nodos, estos reciben primero su número en el orden de declaración del documento. Los demás registros (SOURCE, TEXT, LINK, FUNC, registros de sección) reciben del codificador los números siguientes a los de los nodos.
- El decodificador solo comprueba que el Edge Id no sea 0 y no esté repetido. El orden de asignación no se usa en la interpretación.
- Los nodos y las relaciones se señalan por Edge Id.
- Un Value integrado es tal cual el registro Value, con su TAG WORD. La longitud la fija ese TAG.

## Valores numéricos

- El valor de juicio (−1~1) y el Qualifier (0~1) son Values [SIGNED-DECIMAL](/es/grammar/value/decimal/signed-decimal/). No se define aparte un formato de coma fija.
- El codificador elimina los 0 finales del coeficiente. 0.8 es `C=8, E=−1`. El decodificador acepta hasta 4 decimales.
- La compuerta de certeza (por ejemplo, `at least 75%`) se escribe con 1 WORD de operador de comparación y un Value [UNSIGNED-DECIMAL](/es/grammar/value/decimal/unsigned-decimal/) de porcentaje (`E=0`) (F_GATE de [LINK](/es/grammar/edge/toulmin/link/)).

## Ejes de la declaración de nodos

- La declaración de nodos (RULE, COUNTER y EXCEPT-DECLARE) tiene un rol (afirmación, refutación, excepción), un Qualifier (0~1) y un Level (Unset, Fail, Review). El rol lo lleva el Codec y el role de la cabecera de NODE, el Qualifier lo lleva F_QUAL y el Level lo lleva el level de la cabecera ([NODE](/es/grammar/edge/toulmin/node/)).
- La fuerza (Strict, Defeasible, Defeater) es un eje separado del rol. La ubicación de la fuerza aún no está fijada.

## Juzgar sobre lo desconocido

Cuando el grafo de juicio recibe hechos GEUL como entrada, los tres conceptos de los [marcadores de posición](/es/grammar/reference/slot-marker/) (no declarado, desconocido, sin valor) se evalúan de forma distinta. La evaluación de los operadores de comparación de [EXPR](/es/grammar/edge/toulmin/expr/) es la siguiente.

| Entrada | `is empty` | `is not empty` | `equals` / `is in` / comparación de tamaño |
|---|---|---|---|
| valor v | falso | verdadero | se evalúa con v |
| NO-VALUE (sin valor) | **verdadero** | falso | falso |
| UNKNOWN-VALUE (desconocido) | falso | **verdadero** | **indeterminado (U)** |
| ABSENT (no declarado) / sin afirmación | U (mundo abierto) | U | U |

- La lógica es la de 3 valores fuerte de Kleene. `NOT U = U`, `falso AND U = falso`, `verdadero OR U = verdadero`. El resto de combinaciones con U dan U.
- `EXISTS any` es verdadero si alguno de los elementos es verdadero. Si no hay verdadero y hay U, es U; si todos son falsos, es falso.
- **Si el predicado es U, el juicio de ese nodo no es Pass ni Fail, sino Review.** Lo que no se sabe se pasa a una persona (o a la etapa siguiente).
- Para tratar ABSENT como empty y no como U, el lado de la entrada debe **declarar** un mundo cerrado (inyectado como criterio de juicio SPEC, por ejemplo "la entrada de este caso está completa"). Sin esa declaración, es U.
- Esta tabla y la correspondencia U → Review son el significado del juicio, por lo que son **núcleo fijo**. No se pueden cambiar con un documento TOULMIN.
- Ejemplo: la regla "contar solo las fronteras que siguen vigentes" (`P582 is empty`) excluye el caso P582 = UNKNOWN-VALUE por ser falso, incluye el caso P582 = NO-VALUE por ser verdadero, y envía a Review el caso en que no hay P582, por ser U.

## Resultado del juicio

- Los resultados del juicio (`VERDICT`, `EVIDENCE`) se ponen en un documento distinto del objeto juzgado. El documento de resultados importa el documento objeto con [IMPORT-DOC](/es/grammar/meta/import/import-doc/) y lo señala con [EXTERNAL-POINTER-*](/es/grammar/reference/external-pointer/). Por eso, aunque se juzgue, el hash de contenido del documento objeto no cambia.
- El juicio del documento entero es el Meta `VERDICT`, y el de nodos y registros es el `VERDICT` de TOULMIN.
- Las reglas que eligen la edición aplicable de una revisión (disposiciones transitorias, elección entre la ley vigente en el momento del hecho y la ley nueva), así como las interpretaciones y la jurisprudencia, también se escriben como reglas de juicio ([revisión de Documento](/es/grammar/document/#revisión)).

## Problemas abiertos

- Layouts de SUPERSEDE-CHAIN (`0x6A`), VERDICT (`0x78`) y EVIDENCE (`0x79`). Si basta con la forma actual de escribir SUPERSEDES por pares para las cadenas.
- Ubicación de la fuerza de los nodos (Strict, Defeasible, Defeater).
- En EXPR, el número de nodos y el número de etiquetas, y el índice de etiqueta es de 1 WORD y el número de hijos es de 13 bits. Los límites superiores están fijados.
- Layout de PROVENANCE (procedencia y premisas de la regla).
- Si los nombres entre acentos graves se ponen con el [LABEL](/es/grammar/edge/label/) o [BIND](/es/grammar/edge/bind/) de afirmación y no con TEXT + LABEL (`0xC029`).
- Tablas de valores de código de predicate y mode de Claim, y de VerbCode de FuncRef.
- Si la declaración de mundo cerrado (leer ABSENT como empty) se hace como criterio de juicio (SPEC) o por caso.
- El [Documento de especificación de Codec](/es/grammar/codec-spec/) de los Codec TOULMIN. Los campos condicionales de NODE y LINK y el ancho de SPAN fijado por SOURCE son layouts que no se pueden declarar con FIELD.

## Páginas relacionadas

- [NODE](/es/grammar/edge/toulmin/node/), [LINK](/es/grammar/edge/toulmin/link/), [EXPR](/es/grammar/edge/toulmin/expr/), [SOURCE y secciones](/es/grammar/edge/toulmin/source/)
- [Edge](/es/grammar/edge/), [Documento](/es/grammar/document/), [PROFILE](/es/grammar/meta/declaration/profile/)
