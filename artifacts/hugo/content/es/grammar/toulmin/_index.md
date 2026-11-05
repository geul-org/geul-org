---
title: "TOULMIN"
weight: 130
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "Escribe grafos de veredicto y de ejecución con el modelo de argumentación de Toulmin."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Escribe grafos de veredicto y de ejecución con el modelo de argumentación de Toulmin. Es la familia central con la que GEUL describe sus propias reglas en GEUL y se corrige a sí mismo.

| Grupo | Codec |
|---|---|
| Declaración | [CASE-DECLARE](0x100L-case-declare.md) (caso), [PREDICATE-DECLARE](0x101L-predicate-declare.md) (predicado), [SPEC-DECLARE](0x102L-spec-declare.md) (criterio de juicio), [RULE-DECLARE](0x103L-rule-declare.md) (afirmación), [COUNTER-DECLARE](0x104L-counter-declare.md) (refutación), [EXCEPT-DECLARE](0x105L-except-declare.md) (excepción) — [NODE](#node) |
| Relación | [ATTACKS](0x108L-attacks.md) (ataque), [SUPERSEDES](0x109L-supersedes.md) (exclusión) — [LINK](#link), [SUPERSEDE-CHAIN](0x10AL-supersede-chain.md) (cadena de prioridad, layout sin definir) |
| Ejecución | [RUN](0x110L-run.md), [DO](0x111L-do.md), [DO-ONCE](0x112L-do-once.md), [UNDO](0x113L-undo.md), [CHECKING](0x114L-checking.md) — [LINK](#link), [ENTRY](0x115L-entry.md), [TRIGGER](0x116L-trigger.md) — [NODE](#node) |
| Resultado | [VERDICT](0x118L-verdict.md) (resultado del veredicto: Pass, Review, Fail), [EVIDENCE](0x119L-evidence.md) (evidencia del veredicto) — layout sin definir |

- El texto original, la delimitación y los nodos y relaciones auxiliares son los códigos directos `0x120L~0x134L` de la familia de formato TOULMIN ([SOURCE y delimitación](#source와-구획), [TOULMIN](#toulmin-형식)).
- El resultado del veredicto se coloca en un documento distinto del que contiene el objeto juzgado. El documento de resultado importa el documento de destino y lo señala. Por eso, emitir un veredicto no cambia el hash de contenido del documento de destino.

Los Edge de la familia TOULMIN (códigos directos `0x100L~0x11BL`; los registros auxiliares pertenecen a la familia de formato TOULMIN `0x120L~0x134L`) escriben grafos de veredicto y de ejecución con el modelo de argumentación de Toulmin. La declaración de afirmaciones, refutaciones y excepciones, las relaciones de ataque y exclusión, las conexiones de ejecución y los resultados de veredicto son todos Edge. Un documento TANGEUL (el lenguaje de reglas del motor toulmin) se convierte en un documento GEUL. La extensión de archivo es `.geul`, igual que la de los demás documentos.

Lo que este documento no fija sigue las reglas comunes de [Edge](../edge/_index.md) y [Registro y TAG WORD](../record.md).

## Metacognición y autorrevisión {#메타-인지와-자기-개정}

TOULMIN es un Codec de GEUL para que GEUL pueda tener metacognición de sí mismo. Solo si las reglas de veredicto y de ejecución también se describen en GEUL, TOULMIN puede tomar esas reglas como objeto y corregirse a sí mismo. Por eso TOULMIN no es un perfil de aplicación, sino el núcleo del funcionamiento de GEUL, y se sitúa en el espacio de códigos directos de Edge (`0x100L~0x11BL`).

- La autodescripción hace posible la automejora, pero asume el riesgo de errores circulares. Si una regla juzga su propia revisión, también puede aprobarse una revisión que relaje el criterio de juicio (sube la tasa de aprobación y baja la precisión real).
- La circularidad se acepta como riesgo, pero se corta mediante la estructura.
  - **Núcleo fijo**: el significado del veredicto (Pass, Review, Fail; ataque, exclusión, prioridad; la evaluación de tres valores y U → Review de [Juzgar sobre lo desconocido](#미상-위에서-판정하기), más abajo) queda fijado en esta especificación. No se puede cambiar con un documento TOULMIN. Está en el mismo lugar que las reglas integradas en el decodificador (capa 0 de [Direcciones de publicación y lista de versiones](../publishing.md#층)).
  - **Separación de ediciones**: la revisión del documento de reglas v(n) se juzga con las reglas de v(n−1) y con una verificación externa. Una regla no se juzga a sí misma. El resultado del veredicto se coloca en un documento distinto del destino (el hash de contenido del destino no cambia).
  - **Historial inmutable**: las revisiones se acumulan como versiones nuevas (`PARENT`, hash de contenido, firma). Como las versiones antiguas se conservan, los errores circulares se pueden encontrar a posteriori y revertir. La red de seguridad de la autorrevisión es el modelo de ediciones de GEUL ([Documento](../document.md#개정)).
  - **Criterio externo**: se mantiene aparte un conjunto de casos de prueba que la vía de revisión no puede tocar. La adopción de una revisión se confirma con el resultado de este conjunto.
- Prueba de refutación: se introduce deliberadamente una regla errónea. Si el sistema la corrige y la puntuación del criterio externo sube, la automejora funciona. Si solo sube la tasa de aprobación y baja la puntuación del criterio externo, hay un error circular.

## Código {#코드}

Un registro TOULMIN usa uno de tres layouts. El layout lo fija el Codec.

| Layout | Uso | Página |
|---|---|---|
| NODE | nodos del grafo, como caso, regla, definición y punto de entrada | [NODE](#node) |
| LINK | relaciones entre nodos (ataque, exclusión, ejecución, definición) | [LINK](#link) |
| EXPR | expresión condicional (predicado) | [EXPR](0x101L-predicate-declare.md) |

El texto original y los registros de delimitación (SOURCE, TEXT, SECTION, CASE-BEGIN y CASE-END, PROSE) los fija [SOURCE y delimitación](#source와-구획).

### Códigos directos {#직접-코드}

| Codec | Nombre | Layout | TANGEUL | Significado |
|---|---|---|---|---|
| `0x100L` | [CASE-DECLARE](0x100L-case-declare.md) | NODE | `in case of` | declaración de caso. Grafo de veredicto que contiene nodos y relaciones |
| `0x101L` | [PREDICATE-DECLARE](0x101L-predicate-declare.md) | EXPR | expresión condicional de Rules | declaración de predicado. Expresión de veredicto |
| `0x102L` | [SPEC-DECLARE](0x102L-spec-declare.md) | NODE | elemento de Definitions | declaración de criterio de juicio (Backing). Los bits de role indican el tipo de definición |
| `0x103L` | [RULE-DECLARE](0x103L-rule-declare.md) | NODE | general rule, nombre de regla de Rules | declaración de afirmación (Warrant). Puede ser atacada |
| `0x104L` | [COUNTER-DECLARE](0x104L-counter-declare.md) | NODE | counter rule | declaración de refutación. Ataca con una conclusión propia. El Level por defecto es Fail |
| `0x105L` | [EXCEPT-DECLARE](0x105L-except-declare.md) | NODE | except rule | declaración de excepción. Ataca sin conclusión propia. El Level por defecto es Review |
| `0x108L` | [ATTACKS](0x108L-attacks.md) | LINK | `don't X when Y` | relación de ataque. El veredicto del atacante reduce gradualmente el del destino según la fuerza de ataque (0 a 1, por defecto 1) |
| `0x109L` | [SUPERSEDES](0x109L-supersedes.md) | LINK | `X supersedes Y` | relación de exclusión. Si el atacante está Active, el destino se quita de forma determinista de la agregación. Una cadena (`A > B > C`) se escribe con una por cada par |
| `0x10AL` | [SUPERSEDE-CHAIN](0x10AL-supersede-chain.md) | — | | cadena de prioridad `A > B > C`. Abreviatura de los SUPERSEDES por pares. Solo se ha asignado el código; el layout aún no existe |
| `0x110L` | [RUN](0x110L-run.md) | LINK | `run c when n` | composición de ejecución. Si el nodo está Active, ejecuta el caso subordinado (DAG) |
| `0x111L` | [DO](0x111L-do.md) | LINK | `do fn when n` | acción que se realiza si el nodo está Active |
| `0x112L` | [DO-ONCE](0x112L-do-once.md) | LINK | `do fn once when n` | acción que se realiza una sola vez aunque se reintente |
| `0x113L` | [UNDO](0x113L-undo.md) | LINK | `undo fn when n` | acción compensatoria de DO (saga). Si falla un paso posterior, se realiza en orden inverso |
| `0x114L` | [CHECKING](0x114L-checking.md) | LINK | `checking c` | conexión que solo emite el veredicto, sin efectos secundarios |
| `0x115L` | [ENTRY](0x115L-entry.md) | NODE | `provides x` | punto de entrada externo. Ejecuta o juzga un caso |
| `0x116L` | [TRIGGER](0x116L-trigger.md) | NODE | `on`, `every`, `until` | punto de entrada de evento o periódico, sin llamada externa |
| `0x118L` | [VERDICT](0x118L-verdict.md) | — | | resultado del veredicto de un nodo o registro. Resultado (Pass, Review, Fail), valor del veredicto, Activated, Excluded, Level. Solo se ha asignado el código; el layout aún no existe |
| `0x119L` | [EVIDENCE](0x119L-evidence.md) | — | | evidencia del veredicto. Posición, valor esperado, valor real (Fact). Solo se ha asignado el código; el layout aún no existe |
| `0x11CL~0x11FL` | Reserved | | | |

- Los códigos directos que no figuran en la tabla (`0x106L` y `0x107L`, `0x10BL`~`0x10FL`, `0x117L`, `0x11AL` y `0x11BL`) son Reserved.
- Los grupos son: `0x100L~0x107L` declaración, `0x108L~0x10FL` relación, `0x110L~0x117L` ejecución, `0x118L~0x11FL` resultado (`0x11CL~0x11FL` es Reserved).
- El veredicto del documento completo corresponde al Meta [VERDICT](../meta/0x1E9L-verdict.md) (`0x1E9L`), y el de un nodo o registro, al `VERDICT` de TOULMIN (Edge `0x118L`). Son dos Codecs distintos, de Kind diferente.

### Formato TOULMIN {#toulmin-형식}

El texto original, la delimitación y los nodos y relaciones auxiliares se sitúan en los códigos directos `0x120L~0x134L` de la familia de formato Edge TOULMIN. No tienen campos de Issuer ni de número de Codec, y el Payload sigue directamente a la TAG.

```
TAG WORD          0001 0010 0000 LLLL      Edge, Codec 0x120L (SOURCE). Los demás códigos ocupan el mismo lugar
[TAG de extensión de Length]
Edge Id           registro LOCAL Reference
componentes       layout fijado por el formato
```

| Codec | Nombre | Layout | Significado |
|---|---|---|---|
| `0x120L` | [SOURCE](0x120L-source.md) | ID, WORD de ancho de SPAN, Value UTF8 | texto original de la redacción |
| `0x121L` | [TEXT](0x121L-text.md) | ID, Value UTF8 | nombre o cadena |
| `0x122L` | [SECTION](0x122L-section.md) | ID, código de sección de 1 WORD | inicio de sección |
| `0x123L` | [CASE-BEGIN](0x123L-case-begin.md) | ID, REF (caso) | inicio del ámbito de un caso |
| `0x124L` | [CASE-END](0x124L-case-end.md) | ID, REF (caso) | fin del ámbito de un caso |
| `0x125L` | [PROSE](0x125L-prose.md) | ID, SPAN | párrafo descriptivo |
| `0x126L` | [NAMESPACE](0x126L-namespace.md) | NODE | `this document is` |
| `0x127L` | [FUNC](0x127L-func.md) | NODE | referencia a función |
| `0x128L` | [FIELD](0x128L-field.md) | NODE | `is required` |
| `0x129L` | [ALIAS](0x129L-alias.md) | NODE | `see … from` |
| `0x12AL` | [GROUP](0x12AL-group.md) | NODE | grupo de ejecución ordenado |
| `0x12BL` | [REQUIRES](0x12BL-requires.md) | LINK | caso → campo |
| `0x12CL` | [MEANS](0x12CL-means.md) | LINK | elemento de definición → valor o tipo |
| `0x12DL` | [HAS](0x12DL-has.md) | LINK | elemento de definición → campo |
| `0x12EL` | [RUNS](0x12EL-runs.md) | LINK | punto de entrada → caso, ejecución |
| `0x12FL` | [EVALUATES](0x12FL-evaluates.md) | LINK | punto de entrada → caso, veredicto |
| `0x130L` | [TRIGGERS](0x130L-triggers.md) | LINK | disparador → caso |
| `0x131L` | [UNTIL](0x131L-until.md) | LINK | disparador → caso (`every … until`) |
| `0x132L` | [SAME-AS](0x132L-same-as.md) | LINK | nodo → identificador global |
| `0x133L` | [IMPORTED-FROM](0x133L-imported-from.md) | LINK | alias → ruta (TEXT) |
| `0x134L` | [LABEL](0x134L-label.md) | LINK | nodo → TEXT, notación del nombre |

## Documento {#문서}

Un archivo `.geul` es un DOC. No se coloca ningún otro byte fuera del DOC.

```
DOC-1WORD/2WORD/4WORD     longitud total
  SPEC-VERSION            0x0001 (v1, entero sin Value integrado)
  PROFILE                 Value UTF8 "tangeul-<major>.<minor>". Actualmente "tangeul-1.0"
  [DEFAULT-LANGUAGE]      Value LANGUAGE-BCP47-CODE. Configuración regional de redacción ("en", "ko")
BODY
  SOURCE                  texto original de la redacción. Primer registro de BODY
  registros de enunciado …  en el orden de declaración del documento
END
```

- HEAD: [SPEC-VERSION](../meta/0x1C5L-spec-version.md), [PROFILE](../meta/0x1C6L-profile.md), y opcionalmente [DEFAULT-LANGUAGE](../meta/0x1CAL-default-language.md).
- El decodificador rechaza el documento si SPEC-VERSION es distinta o si el major de PROFILE es distinto. Si solo difiere el minor, lo lee.
- El primer registro de BODY es SOURCE. Todo SPAN es un rango dentro de este texto original.
- El orden de los registros de enunciado es igual al orden de declaración del documento. El orden de ejecución (disparo de `do` y `run`, compensación inversa de `undo`) depende de este orden. En un documento TOULMIN el orden de los Edge tiene significado (excepción a la regla de orden del [layout de Edge](../edge/_index.md#레이아웃)).
- Todos los registros de BODY son Edge. No se colocan registros Value independientes. Los valores se integran en el Payload del Edge.
- La identidad del caso y la importación usan los Meta [DOC-ID](../meta/0x1C7L-doc-id.md) e [IMPORT-DOC](../meta/0x1E4L-import-doc.md) (Subject y See de TANGEUL).

## Campos comunes {#공통-필드}

| Campo | Ancho | Descripción |
|---|---|---|
| ID | registro LOCAL Reference | Edge Id del registro. Primer elemento del Payload de todos los registros |
| REF | registro LOCAL Reference | Edge Id que señala otro registro de este documento. `0` significa ninguno |
| SPAN | ancho fijado por SOURCE × 2 | rango dentro del texto original de la redacción. Byte de inicio, número de bytes |

- ID y REF son registros Reference [LOCAL](../reference/0x005L-local.md) integrados (`0000 0000 0101 LLLL` + ID del ancho más corto). El ancho lo fija el Length de ese registro y no se declara por documento.
- REF `0` (LOCAL `0`) significa «ninguno». Es una regla del Codec que usa LOCAL `0` como ninguno ([LOCAL](../reference/0x005L-local.md)).
- Los Edge Id se asignan desde 1 y no se repiten dentro del documento. `0` es el «ninguno» de REF, así que no se usa como Edge Id.
- Como otros registros referencian nodos hacia adelante, los nodos reciben primero su número en el orden de declaración del documento. Los demás registros (SOURCE, TEXT, LINK, FUNC, registros de delimitación) reciben del codificador los números siguientes a los de los nodos.
- El decodificador solo comprueba que el Edge Id no sea 0 y que no haya duplicados. El orden de asignación no se usa en la interpretación.
- Los nodos y las relaciones se señalan por Edge Id.
- Un Value integrado es el propio registro Value, incluida su TAG WORD. Su longitud la fija esa TAG.

## Valores numéricos {#수치}

- El valor de veredicto (−1 a 1), el Qualifier (0 a 1) y la fuerza de ataque (0 a 1) son Value [SIGNED-DECIMAL](../value/0x068L-signed-decimal.md). No se define aparte un formato de coma fija.
- El codificador elimina los ceros finales del coeficiente. 0.8 es `C=8, E=−1`. El decodificador acepta hasta 4 decimales.
- La compuerta de certeza (p. ej., `at least 75%`) se escribe con un operador de comparación de 1 WORD y un Value [UNSIGNED-DECIMAL](../value/0x069L-unsigned-decimal.md) de porcentaje (`E=0`) (F_GATE de [LINK](#link)).
- La fuerza de ataque es el campo F_FORCE de ATTACKS ([LINK](#공격-세기)). Se rechaza si está fuera de rango.

## Ejes de la declaración de nodo {#노드-선언의-축}

- Una declaración de nodo (RULE, COUNTER, EXCEPT-DECLARE) tiene un rol (afirmación, refutación, excepción), un Qualifier (0 a 1) y un Level (Unset, Fail, Review). El rol lo contiene el Codec y el role del encabezado NODE; el Qualifier, F_QUAL; el Level, el level del encabezado ([NODE](#node)).
- La fortaleza (Strict, Defeasible, Defeater) es un eje independiente del rol. Aún no se ha fijado su ubicación.
- La fuerza de ataque (Force) no es de un nodo, sino un valor de la arista ATTACKS ([LINK](#공격-세기) F_FORCE). Es un eje distinto de la fortaleza.

## Juzgar sobre lo desconocido {#미상-위에서-판정하기}

Cuando el grafo de veredicto recibe hechos de GEUL como entrada, los tres conceptos del [marcador de posición](../slot-marker.md) (no escrito, desconocido, inexistente) se evalúan de forma distinta. La evaluación de los operadores de comparación de [EXPR](0x101L-predicate-declare.md) es la siguiente.

| Entrada | `is empty` | `is not empty` | `equals` / `is in` / comparación de tamaño |
|---|---|---|---|
| valor v | falso | verdadero | se evalúa con v |
| NO-VALUE (inexistente) | **verdadero** | falso | falso |
| UNKNOWN-VALUE (desconocido) | falso | **verdadero** | **indeterminado (U)** |
| ABSENT (no escrito) / sin descripción | U (mundo abierto) | U | U |

- La lógica usa los tres valores fuertes de Kleene. `NOT U = U`, `falso AND U = falso`, `verdadero OR U = verdadero`. En las demás combinaciones, el U es U.
- `EXISTS any` es verdadero si al menos uno de los elementos es verdadero. Si no hay verdaderos pero hay U, es U; si todos son falsos, es falso.
- **Si el predicado es U, el veredicto de ese nodo no es Pass ni Fail, sino Review.** Si no se sabe, se pasa a una persona (o a la etapa siguiente).
- Para leer ABSENT como empty y no como U, el lado de la entrada debe **declarar** un mundo cerrado (se inyecta con el criterio de juicio SPEC, p. ej., «la entrada de este caso está completa»). Sin declaración, es U.
- Esta tabla y la correspondencia U → Review son el significado del veredicto, por lo que son el **núcleo fijo**. No se pueden cambiar con un documento TOULMIN.
- Ejemplo: la regla «contar solo las fronteras que siguen vigentes» (`P582 is empty`) excluye el caso P582 = UNKNOWN-VALUE por ser falso, incluye el caso P582 = NO-VALUE por ser verdadero, y envía a Review el caso en que no hay P582, porque es U.

## Resultado del veredicto {#판정-결과}

- Los resultados de veredicto (`VERDICT`, `EVIDENCE`) se colocan en un documento distinto del que contiene el objeto juzgado. El documento de resultado importa el documento de destino con [IMPORT-DOC](../meta/0x1E4L-import-doc.md) y lo señala con [EXTERNAL-POINTER-*](../reference/0x020L-external-pointer-1word.md). Por eso, emitir un veredicto no cambia el hash de contenido del documento de destino.
- El veredicto del documento completo es el `VERDICT` de Meta; el de un nodo o registro, el `VERDICT` de TOULMIN.
- Las reglas para elegir la edición aplicable de una revisión (disposiciones transitorias, elección entre la ley vigente al momento del hecho y la ley nueva), así como las interpretaciones y la jurisprudencia, también se usan como reglas de veredicto ([Documento](../document.md#개정)).

## Problemas abiertos {#열린-문제}

- El layout de SUPERSEDE-CHAIN (`0x10AL`), VERDICT (`0x118L`) y EVIDENCE (`0x119L`). Si el método actual, que escribe SUPERSEDES por cada par, basta para las cadenas.
- La ubicación de la fortaleza de los nodos (Strict, Defeasible, Defeater).
- Un ATTACKS que escribe la fuerza 1 y uno que no la escribe dan el mismo veredicto, pero sus bytes son distintos. Que el veredicto sea el mismo debe compararse por el valor interpretado, no por los bytes.
- En EXPR, el número de nodos, el número de etiquetas y el índice de etiqueta son de 1 WORD, y el número de hijos es de 13 bits. Los límites superiores están fijados.
- El layout de PROVENANCE (procedencia y premisas de las reglas).
- Si el nombre entre acentos graves se coloca como [LABEL](../edge/0x0A4L-label.md) o [BIND](../edge/0x0A3L-bind.md) de enunciado en lugar de TEXT + LABEL (`0x134L`).
- La tabla de valores de código de predicate y mode de Claim, y de VerbCode de FuncRef.
- Si la declaración de mundo cerrado (leer ABSENT como empty) se hace mediante el criterio de juicio (SPEC) o por caso.
- El [documento de especificación de Codec](../codec-spec.md) de los Codecs TOULMIN. Los campos condicionales de NODE y LINK y el ancho de SPAN que fija SOURCE son layouts que no se pueden declarar con FIELD.

## Páginas relacionadas {#관련-페이지}

- [NODE](#node), [LINK](#link), [EXPR](0x101L-predicate-declare.md), [SOURCE y delimitación](#source와-구획)
- [Documento](../document.md), [PROFILE](../meta/0x1C6L-profile.md)

## NODE {#node}

NODE es el layout que escribe un nodo del grafo de veredicto y de ejecución de TOULMIN. El Codec fija el tipo de nodo, y un WORD de encabezado fija el rol, el Level, la forma del Claim y los campos condicionales.

### Codec {#codec}

| Codec | Nombre | TANGEUL | Nodo |
|---|---|---|---|
| `0x100L` | [CASE-DECLARE](0x100L-case-declare.md) | `in case of` | caso |
| `0x102L` | [SPEC-DECLARE](0x102L-spec-declare.md) | elemento de Definitions (`means`, `has`) | criterio de juicio (Backing). El role indica el tipo de definición |
| `0x103L` | [RULE-DECLARE](0x103L-rule-declare.md) | general rule | afirmación (Warrant) |
| `0x104L` | [COUNTER-DECLARE](0x104L-counter-declare.md) | counter rule | refutación (Rebuttal) |
| `0x105L` | [EXCEPT-DECLARE](0x105L-except-declare.md) | except rule | excepción (Defeater) |
| `0x115L` | [ENTRY](0x115L-entry.md) | `provides x` | punto de entrada externo |
| `0x116L` | [TRIGGER](0x116L-trigger.md) | `on`, `every`, `until` | punto de entrada de evento o periódico |
| `0x126L` | [NAMESPACE](0x126L-namespace.md) | `this document is` | espacio de nombres del documento |
| `0x127L` | [FUNC](0x127L-func.md) | referencia a función | función externa (p. ej., `bank.withdraw`) |
| `0x128L` | [FIELD](0x128L-field.md) | `x is required [as Type]` | campo obligatorio |
| `0x129L` | [ALIAS](0x129L-alias.md) | `see a from path` | alias de un paquete importado |
| `0x12AL` | [GROUP](0x12AL-group.md) | `1.` lista ordenada | grupo de ejecución ordenado |

`0x126L~0x12AL` son códigos directos de la familia de formato Edge TOULMIN ([TOULMIN](#toulmin-형식)).

### Layout {#레이아웃}

```
ID               registro LOCAL Reference (Edge Id)
encab. 1 WORD    role 2b | Reserved 2b | F_GROUNDS 1b | level 2b | tipo de object 2b | flags 7b
[F_FUNC]         FuncRef: REF (ALIAS, o 0 si no hay) + VerbCode 1 WORD
[F_QUAL]         Value SIGNED-DECIMAL. Qualifier
[F_CHECK]        REF (caso)
[F_CLAIM]        Claim: REF (subject) + predicate 1 WORD + object + mode 1 WORD
[F_VERDICT]      Value SIGNED-DECIMAL. Valor inicial del veredicto
[F_WITH]         recuento (Value UNSIGNED-INTEGER) + REF (TEXT) × recuento
[F_GROUNDS]      recuento (Value UNSIGNED-INTEGER) + REF (TEXT) × recuento
SPAN             ancho fijado por SOURCE × 2 (byte de inicio, número de bytes)
```

#### WORD de encabezado {#헤더-word}

| Bits | Campo | Valor |
|---|---|---|
| 15–14 | role | 0 general, 1 counter, 2 except |
| 13–12 | Reserved | 0 |
| 11 | F_GROUNDS | hay lista de fundamentos |
| 10–9 | level | 0 Unset, 1 Fail, 2 Review (3 Reserved) |
| 8–7 | tipo de object | forma del object del Claim. 0 REF, 1 Value UNSIGNED-INTEGER, 2 SPAN |
| 6–0 | flags | tabla siguiente |

| Bit | flag | Significado |
|---|---|---|
| b0 | F_FUNC | hay campo FuncRef |
| b1 | F_QUAL | hay campo Qualifier |
| b2 | F_CHECK | hay campo de caso de destino de `checking` |
| b3 | F_CLAIM | hay campo Claim |
| b4 | F_VERDICT | hay campo de valor inicial del veredicto |
| b5 | F_STRIKE | declaración tachada. No tiene campos |
| b6 | F_WITH | hay campo de lista de criterios |

- Los campos condicionales se colocan en el orden de los flags (F_FUNC, F_QUAL, F_CHECK, F_CLAIM, F_VERDICT, F_WITH, F_GROUNDS). Un campo cuyo flag está apagado no ocupa lugar.
- Se rechaza si un flag está activado y falta el campo. La posición tras leer los campos en orden, después de SPAN, debe coincidir exactamente con el final del registro.

### Campos {#필드}

| Campo | Descripción |
|---|---|
| FuncRef | posición de la función. REF es el registro ALIAS que importó esa función, y es `0` si la función es de este documento. VerbCode es un código de 1 WORD que aún no se ha asignado (se admite `0x0000`). La notación original de la función se escribe aparte con TEXT + [LABEL](#link) |
| Qualifier | certeza del nodo (0 a 1) |
| caso | F_CHECK: caso que este nodo solo juzga (`checking c`) |
| Claim | la proposición que contiene el nodo. REF de subject, predicate 1 WORD, object, mode 1 WORD. La forma del object la fija el tipo de object del encabezado |
| valor del veredicto | valor inicial del veredicto (−1 a 1) |
| F_WITH | criterios en el momento de la declaración (`기준으로 하는`, «que toma como criterio»). Lista de REF de registros TEXT |
| F_GROUNDS | nombres de hechos externos que se resuelven en el momento de la evaluación (`근거로 하는`, «que toma como fundamento»). Lista de REF de registros TEXT |
| SPAN | rango del texto original del que salió esta declaración |

- La notación del valor de veredicto y del Qualifier sigue las reglas numéricas de [TOULMIN](#수치).
- El recuento de una lista es un registro Value [UNSIGNED-INTEGER](../value/0x062L-unsigned-integer.md) integrado.
- La forma por defecto de un Claim descriptivo tiene subject y predicate en `0` y el object es SPAN (tipo de object 2). Queda fijado a la notación del texto original.

### Interpretación y validez {#해석과-유효성}

- El role debe ser igual al del Codec en RULE, COUNTER y EXCEPT-DECLARE (0 general, 1 counter, 2 except). En SPEC-DECLARE es el tipo de definición. En los demás Codecs es 0.
- Si el level es 0 (Unset), se usa el valor por defecto del motor: Fail para COUNTER-DECLARE y Review para EXCEPT-DECLARE.
- La regla de función del host de TANGEUL `tangl:규칙` (`쓰는 규칙이다`, «es una regla que usa») se escribe como un NODE RULE-DECLARE fuera del caso. La función es F_FUNC, el criterio es F_WITH y el fundamento es F_GROUNDS. Solo las reglas de expresión condicional llevan delante un [PREDICATE-DECLARE](0x101L-predicate-declare.md).
- Los bits Reserved (13–12) deben ser 0. Se rechaza si un bit Reserved está activado o si el role no concuerda con el Codec.

### Páginas relacionadas {#관련-페이지-1}

- [TOULMIN](_index.md), [LINK](#link), [EXPR](0x101L-predicate-declare.md), [SOURCE y delimitación](#source와-구획)
- [LOCAL](../reference/0x005L-local.md), [SIGNED-DECIMAL](../value/0x068L-signed-decimal.md)

## LINK {#link}

LINK es el layout que escribe las relaciones entre nodos en el grafo TOULMIN. El Codec fija el tipo de relación.

### Codec {#codec-1}

| Codec | Nombre | TANGEUL | src → dst |
|---|---|---|---|
| `0x108L` | [ATTACKS](0x108L-attacks.md) | `don't X when Y` | regla → regla. Reduce gradualmente el veredicto según la fuerza de ataque |
| `0x109L` | [SUPERSEDES](0x109L-supersedes.md) | `X supersedes Y` | regla → regla. Si está Active, el destino se quita de la agregación |
| `0x110L` | [RUN](0x110L-run.md) | `run c when n` | regla → caso |
| `0x111L` | [DO](0x111L-do.md) | `do fn when n` | regla → FuncRef |
| `0x112L` | [DO-ONCE](0x112L-do-once.md) | `do fn once when n` | regla → FuncRef |
| `0x113L` | [UNDO](0x113L-undo.md) | `undo fn when n` | regla → FuncRef |
| `0x114L` | [CHECKING](0x114L-checking.md) | `checking c` | regla → caso. Veredicto sin efectos secundarios |
| `0x12BL` | [REQUIRES](0x12BL-requires.md) | `f is required` | caso → campo |
| `0x12CL` | [MEANS](0x12CL-means.md) | Definitions `means` | elemento de definición → valor o tipo |
| `0x12DL` | [HAS](0x12DL-has.md) | Definitions `has` | elemento de definición → campo |
| `0x12EL` | [RUNS](0x12EL-runs.md) | punto de entrada `run c` | punto de entrada → caso (ejecución) |
| `0x12FL` | [EVALUATES](0x12FL-evaluates.md) | punto de entrada `check c` | punto de entrada → caso (veredicto) |
| `0x130L` | [TRIGGERS](0x130L-triggers.md) | disparador `run c` | disparador → caso |
| `0x131L` | [UNTIL](0x131L-until.md) | `every … until c` | disparador → caso |
| `0x132L` | [SAME-AS](0x132L-same-as.md) | | nodo → identificador global |
| `0x133L` | [IMPORTED-FROM](0x133L-imported-from.md) | `see a from path` | alias → ruta (TEXT) |
| `0x134L` | [LABEL](0x134L-label.md) | nombre entre acentos graves | nodo → TEXT. Notación del nombre |

### Layout {#레이아웃-1}

```
ID               registro LOCAL Reference (Edge Id)
src              REF
dst              REF. En DO, DO-ONCE y UNDO es un FuncRef
flags 1 WORD     b0 F_ONCE, b1 F_GATE, b2 F_STRIKE, b3 F_ORDERED, b4 F_FORCE
[F_GATE]         operador 1 WORD (2 bits altos) + Value UNSIGNED-DECIMAL (porcentaje)
[F_FORCE]        Value SIGNED-DECIMAL. Fuerza de ataque (0 a 1). Solo ATTACKS
SPAN             ancho fijado por SOURCE × 2
```

| flag | Significado |
|---|---|
| b0 F_ONCE | se realiza una sola vez (el `once` de UNDO) |
| b1 F_GATE | hay campo de compuerta de certeza |
| b2 F_STRIKE | relación tachada |
| b3 F_ORDERED | pertenece a una lista ordenada `1.` |
| b4 F_FORCE | hay campo de fuerza de ataque. Solo ATTACKS |

| Operador de compuerta | Significado |
|---|---|
| 0 | at least |
| 1 | above |
| 2 | less than |
| 3 | at most |

- Los campos condicionales se colocan en el orden de los flags (F_GATE, F_FORCE). Un campo cuyo flag está apagado no ocupa lugar.

### Fuerza de ataque {#공격-세기}

Solo [ATTACKS](0x108L-attacks.md#공격-세기) usa la fuerza de ataque (F_FORCE). La fórmula del veredicto, la notación y los ejemplos están en esa página.

### Interpretación y validez {#해석과-유효성-1}

- REF es el Edge Id de un registro de este documento (campos comunes de [TOULMIN](#공통-필드)).
- La forma de dst la fija el Codec. En DO, DO-ONCE y UNDO es un FuncRef (REF (ALIAS, o 0 si no hay) + VerbCode de 1 WORD, [NODE](#필드)); en LABEL e IMPORTED-FROM es el REF de un registro TEXT; en los demás es el REF de un nodo.
- `do … once` lo representa el Codec DO-ONCE. En los flags de DO-ONCE no se usa F_ONCE (si está activado, se rechaza). El `once` de UNDO se escribe con F_ONCE.
- El operador de compuerta son los 2 bits altos del WORD de operador, y los 14 bits restantes son 0. El porcentaje es un Value UNSIGNED-DECIMAL con `E=0` y va de 0 a 100.
- Los bits b5 a b15 de flags son Reserved y deben ser 0. Si no, se rechaza.
- F_FORCE solo se usa en ATTACKS. Se rechaza si está activado en otro Codec (SUPERSEDES, conexiones de ejecución y de veredicto, relaciones de formato TOULMIN).
- Se rechaza si la fuerza de ataque no es un Value SIGNED-DECIMAL, si está fuera de 0 a 1 o si no se puede representar exactamente con 4 decimales.
- Una cadena `A > B > C` de SUPERSEDES se escribe con un SUPERSEDES por cada par.

### Páginas relacionadas {#관련-페이지-2}

- [TOULMIN](_index.md), [NODE](#node), [SOURCE y delimitación](#source와-구획)
- [UNSIGNED-DECIMAL](../value/0x069L-unsigned-decimal.md), [SIGNED-DECIMAL](../value/0x068L-signed-decimal.md)

## SOURCE y delimitación {#source와-구획}

Son los registros que escriben el texto original y la delimitación de un documento TOULMIN. Todos son códigos directos `0x120L~0x125L` de la familia de formato Edge TOULMIN ([TOULMIN](#toulmin-형식)). El Payload sigue a la TAG, sin campos de Issuer ni de número de Codec.

### Formato {#형식}

| Codec | Nombre | Layout |
|---|---|---|
| `0x120L` | [SOURCE](0x120L-source.md) | ID, WORD de ancho de SPAN, Value UTF8 |
| `0x121L` | [TEXT](0x121L-text.md) | ID, Value UTF8 |
| `0x122L` | [SECTION](0x122L-section.md) | ID, código de sección de 1 WORD |
| `0x123L` | [CASE-BEGIN](0x123L-case-begin.md) | ID, REF (caso) |
| `0x124L` | [CASE-END](0x124L-case-end.md) | ID, REF (caso) |
| `0x125L` | [PROSE](0x125L-prose.md) | ID, SPAN |

- ID es el Edge Id y REF es el Edge Id de un registro de este documento (campos comunes de [TOULMIN](#공통-필드)).
- Un Value UTF8 es un registro Value [UTF8-TEXT](../value/0x072L-utf8-text.md). Contiene los bytes tal cual.

### Páginas por formato {#형식별-쪽}

El layout, la tabla de códigos de sección y la interpretación tienen una página aparte por cada formato.

- [SOURCE](0x120L-source.md): texto original de la redacción. Es el primer registro de BODY y fija el ancho de SPAN
- [TEXT](0x121L-text.md): nombre o cadena
- [SECTION](0x122L-section.md): inicio de sección y código de sección
- [CASE-BEGIN](0x123L-case-begin.md), [CASE-END](0x124L-case-end.md): ámbito de un caso
- [PROSE](0x125L-prose.md): párrafo descriptivo

### Páginas relacionadas {#관련-페이지-3}

- [TOULMIN](_index.md), [NODE](#node), [LINK](#link)
