---
title: "Índice de códigos"
weight: 60
date: 2026-11-05T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar"]
summary: "Esta página es el índice de todos los Codec."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Esta página es el índice de todos los Codec. Al pulsar un nombre se va al documento detallado de ese Codec. Los códigos directos que no están en la tabla son Reservados.

## Kind {#kind}

El TAG WORD es `000K KKKC CCCC LLLL`. Los 4 bits superiores `KKKK` son la sección, `C` es el desplazamiento de 5 bits dentro de la sección y `LLLL` es el Length. Los 9 bits formados por la sección y `C` son el lugar del Codec. El TAG ID se escribe como `0x000L`. Los tres primeros dígitos son esos 9 bits (`w >> 4`) y `L` es el lugar del Length ([Registro y TAG WORD](record.md)).

| Sección | TAG ID | Clasificación | Descripción |
|---|---|---|---|
| 0~2 | `0x000L~0x05FL` | [Reference](reference/_index.md) | Registros que apuntan a un objeto |
| 3·4 | `0x060L~0x09FL` | [Value](value/_index.md) | Registros de valor |
| 5~13 | `0x0A0L~0x1BFL` | [Edge](edge/_index.md) | Registros de composición |
| 14·15 | `0x1C0L~0x1FFL` | [Meta](meta/_index.md) | Registros sobre el documento y los registros |

- La sección es `S = w >> 9` (4 bits) y cada sección tiene 32 casillas.
- El Kind se determina por un único rango de secciones: `w < 0x0600` Reference, `w < 0x0A00` Value, `w < 0x1C00` Edge, el resto Meta. No hay excepciones.
- Las tres últimas casillas de las zonas Reference, Value y Edge son ISSUER (`..DL` 2 WORD, `..EL` 4 WORD, `..FL` 16 WORD). Meta no tiene ISSUER.

## Reference {#reference}

`0x000L~0x05FL` — [Reference](reference/_index.md)

### Codec {#codec}

| TAG ID | Nombre | Clasificación | ID del objeto |
|---|---|---|---|
| `0x000L~0x002L` | [Marcador de posición](slot-marker.md) | marcador de posición | Grupo de marcadores de 1 WORD que no apuntan a ningún objeto (tabla siguiente) |
| `0x005L~0x009L` | [LOCAL](reference/0x005L-local.md) | declaración | ID emitido por este documento |
| `0x00AL~0x00EL` | [GEUL](reference/0x00AL-geul.md) | declaración | Entidad que geul.org emite bajo CC0. Los números pequeños se asignan a entidades de alta frecuencia |
| `0x00FL~0x013L` | [GEUL-SIDX](reference/0x00FL-geul-sidx.md) | declaración | GEUL SIDX (Semantic-aligned Index). Identificador que lleva significado en los bits |
| `0x014L~0x018L` | [WIKIDATA-QID](reference/0x014L-wikidata-qid.md) | declaración | Elemento de Wikidata. El entero que sigue a `Q` |
| `0x019L~0x01DL` | [WIKIDATA-PID](reference/0x019L-wikidata-pid.md) | declaración | Propiedad de Wikidata. El entero que sigue a `P` |
| `0x020L~0x024L` | [EXTERNAL-POINTER-1WORD](reference/0x020L-external-pointer-1word.md) | indicación | ID LOCAL de un documento importado con `IMPORT-DOC`. IMPORT ID de 1 WORD |
| `0x025L~0x029L` | [EXTERNAL-POINTER-2WORD](reference/0x025L-external-pointer-2word.md) | indicación | Igual que el anterior. IMPORT ID de 2 WORD |
| `0x02AL~0x02EL` | [EXTERNAL-POINTER-4WORD](reference/0x02AL-external-pointer-4word.md) | indicación | Igual que el anterior. IMPORT ID de 4 WORD |
| `0x02FL~0x033L` | [EXTERNAL-ISSUER-2WORD](reference/0x02FL-external-issuer-2word.md) | indicación y declaración | ID LOCAL de un documento de Issuer de 2 WORD |
| `0x034L~0x038L` | [EXTERNAL-ISSUER-4WORD](reference/0x034L-external-issuer-4word.md) | indicación y declaración | ID LOCAL de un documento de Issuer de 4 WORD |
| `0x039L~0x03DL` | [EXTERNAL-ISSUER-16WORD](reference/0x039L-external-issuer-16word.md) | indicación y declaración | ID LOCAL de un documento de Issuer de 16 WORD |
| `0x040L` | [ISSUER-POINTER](reference/0x040L-issuer-pointer.md) | indicación y declaración | El propio Issuer. El Payload es solo el Issuer (2/4/16 WORD) y no hay ID de objeto |
| `0x041L` | [DOC-POINTER](reference/0x041L-doc-pointer.md) | indicación y declaración | Una versión de un documento del Issuer. Issuer + ID de documento de 4 WORD + ID de versión de 2 WORD, sin ID de objeto |
| `0x042L` | [CODEC-POINTER](reference/0x042L-codec-pointer.md) | indicación y declaración | Una versión de un Codec del Issuer. Issuer + ID de Codec de 2 WORD + ID de versión de 2 WORD, sin ID de objeto |
| `0x043L` | [TOKEN-0](reference/0x043L-token.md) | declaración | Una entrada del vocabulario de tokens de GEUL (ID de token 0~65.535). Payload de 1 WORD, 2 WORD en total |
| `0x044L` | [TOKEN-1](reference/0x043L-token.md) | declaración | Igual que el anterior. ID de token 65.536~131.071 (65.536 + Payload) |
| `0x05DL` | [REFERENCE-ISSUER-2WORD](reference/0x05DL-reference-issuer-2word.md) | formato Issuer | Issuer de 2 WORD y número de Codec de 2 WORD. La clasificación y el objeto los define el documento del Issuer |
| `0x05EL` | [REFERENCE-ISSUER-4WORD](reference/0x05EL-reference-issuer-4word.md) | formato Issuer | Issuer de 4 WORD y número de Codec de 2 WORD. Igual que el anterior |
| `0x05FL` | [REFERENCE-ISSUER-16WORD](reference/0x05FL-reference-issuer-16word.md) | formato Issuer | Issuer de 16 WORD y número de Codec de 2 WORD. Igual que el anterior |

- Reference tiene tres secciones. Sección 0 entidades `0x000L~0x01FL` (marcadores de posición, sistema 5Q), sección 1 EXTERNAL `0x020L~0x03FL`, sección 2 otros `0x040L~0x05FL` (punteros, REFERENCE-ISSUER). Los Reservados son `0x003L~0x004L`, `0x01EL~0x01FL`, `0x03EL~0x03FL`, `0x045L~0x05CL`.
- Los grupos de 5 casillas (de LOCAL a EXTERNAL-ISSUER-16WORD) siguen el orden de Quantifier de más abajo, una casilla cada uno. Ejemplo: WIKIDATA-QID Identified `0x014L`, Generic `0x015L`.

### Marcador de posición (`0x000L~0x002L`) {#자리-표지-0x000l0x002l}

`0x0000`, `0x0010`, `0x0020` — [Marcador de posición](slot-marker.md). Solo aparece en un lugar cuando la lista de CODEC del campo lo indica exactamente como ese WORD.

| WORD | Nombre | Significado | Wikidata |
|---|---|---|---|
| `0x0000` | [ABSENT](reference/0x000L-absent.md) | No anotado. Se omitió un campo opcional. No se afirma nada sobre el mundo | sin snak |
| `0x0010` | [UNKNOWN-VALUE](reference/0x001L-unknown-value.md) | Desconocido. Hay un valor, pero no se sabe cuál | `somevalue` |
| `0x0020` | [NO-VALUE](reference/0x002L-no-value.md) | Inexistente. No hay valor | `novalue` |

### Quantifier {#quantifier}

| `C % 5` | Nombre | Significado | Ejemplo |
|---|---|---|---|
| `0` | Identified | Entidad identificada | Elon Musk, Corea del Sur |
| `1` | Generic | Enunciado general o definitorio sobre toda una clase. Admite excepciones. | Los soldados obedecen las órdenes |
| `2` | Free-choice | Cualquier objeto que cumpla la condición | cualquier soldado |
| `3` | Universal | Todos los objetos del ámbito dado | todos los soldados |
| `4` | Variable | Variable del discurso | esa persona, esta mujer |

- La cuantificación se lee por el desplazamiento `C` dentro de la sección. En la sección 0, si `5 <= C < 30`, la cuantificación es `C % 5` y el sistema es `C / 5` (1~5). En la sección 1, si `C < 30`, la cuantificación es `C % 5` y el sistema es `6 + C / 5` (6~11). No se usa en los marcadores (sección 0, `C < 3`) ni en la sección 2 (punteros, REFERENCE-ISSUER).
- ISSUER-POINTER, DOC-POINTER y CODEC-POINTER son una sola casilla sin cuantificación. La cuantificación de REFERENCE-ISSUER la define el documento de Codec publicado por el Issuer.

## Issuer {#issuer}

El Issuer es la entidad que define documentos y formatos — [Issuer y publicación](issuer.md)

| Lugar | Significado |
|---|---|
| Códigos ISSUER de Reference, Value y Edge (las tres últimas casillas de cada zona) | Formato definido por ese Issuer |
| Meta `DOC-ID` | Issuer que emitió este documento |
| Meta `IMPORT-DOC` | Issuer que emitió el documento importado |
| Reference `EXTERNAL-ISSUER-*`, `DOC-POINTER`, `CODEC-POINTER` | Issuer que emitió el documento o Codec apuntado (2/4/16 WORD) |
| Reference `ISSUER-POINTER` | El propio Issuer apuntado (2/4/16 WORD) |

| Ancho del Issuer | Emisión |
|---|---|
| 2 WORD | Registrado en geul.org. Issuer que ha pasado la prueba de propiedad del dominio (por ejemplo company.com). Los números que geul.org asigna a organismos de normalización y a instituciones principales también tienen este ancho ([tabla de asignación de 2 WORD](issuer.md#2-word-배정표)). |
| 4 WORD | Registrado en geul.org. Issuer registrado sin prueba de propiedad |
| 16 WORD | Autoemitido. Se calcula a partir de la clave pública, sin registro. Sigue las reglas de generación de más abajo. |

### Algoritmo de firma del Issuer de 16 WORD {#16-word-issuer-서명-알고리즘}

| ID del algoritmo de firma | Algoritmo |
|---|---|
| `0x0001` | Ed25519 |
| Otros | Reservado |

## Edge {#edge}

`0x0A0L~0x1BFL` — [Edge](edge/_index.md)

La familia de un código directo es `(código − 0xA0) >> 5` (el código son los tres primeros dígitos del TAG ID). Cada familia tiene 32 casillas y es igual a la sección `w >> 9` menos 5. Los códigos directos asignados pertenecen a las cinco familias siguientes. `0x135L~0x1BCL` es Reservado (las secciones 10~12 son Reservadas por completo). El formato Issuer no tiene regla de familia.

| Sección | Familia | Códigos directos |
|---|---|---|
| 5 | enunciado | `0x0A0L~0x0BFL` |
| 6 | fundamento | `0x0C0L~0x0DFL` |
| 7 | ejecución | `0x0E0L~0x0FFL` |
| 8 | [TOULMIN](toulmin/_index.md) | `0x100L~0x11BL` |
| 9 | formato [TOULMIN](toulmin/_index.md) | `0x120L~0x134L` |

- `0x11CL~0x11FL` es Reservado.
- `0x1BDL~0x1BFL` (las tres últimas casillas de la sección 13) es EDGE-ISSUER (formato Edge ISSUER, más abajo).

### Enunciado (`0x0A0L~0x0BFL`) {#서술-0x0a0l0x0bfl}

| Codec | Nombre | Subformato | Descripción |
|---|---|---|---|
| `0x0A0L` | [REFERENCE-NODE](edge/0x0A0L-reference-node.md) |  | Vínculo dirigido en el que un Subject que es Reference señala un Object |
| `0x0A1L` | [SAME-NODE](edge/0x0A1L-same-node.md) |  | Identidad: dos Reference señalan el mismo objeto |
| `0x0A2L` | [DIFFERENT-NODE](edge/0x0A2L-different-node.md) |  | No identidad: dos Reference señalan objetos distintos |
| `0x0A3L` | [BIND](edge/0x0A3L-bind.md) |  | Une al Subject un nombre que la máquina hace coincidir (`UTF8-TEXT-*`). Debe ser único dentro del ámbito, coincidir exactamente y no tiene idioma |
| `0x0A4L` | [LABEL](edge/0x0A4L-label.md) |  | Asocia al Subject un nombre en un idioma (label). El Object es UTF8-LANGUAGE-TEXT |
| `0x0A5L` | [ALIAS](edge/0x0A5L-alias.md) |  | Asocia al Subject otro nombre (alias). La disposición es igual que la de LABEL |
| `0x0A6L` | [DESCRIPTION](edge/0x0A6L-description.md) |  | Asocia al Subject una descripción en un idioma (description). La disposición es igual que la de LABEL |
| `0x0A7L` | Reservado |  |  |
| `0x0A8L` | [VERB-SHORT](edge/0x0A8L-verb-short.md) |  | Enunciado verbal abreviado |
| `0x0A9L` | [VERB](edge/0x0A9L-verb.md) |  | Enunciado verbal |
| `0x0AAL` | [TRIPLE](edge/0x0AAL-triple.md) |  | Proposición en el orden Predicate, Subject, Object, y rank. El Object es un valor o un marcador UNKNOWN-VALUE o NO-VALUE. Su significado es la suma de todos los QUALIFIER que apuntan a su Edge Id |
| `0x0ABL` | [QUALIFIER](edge/0x0ABL-qualifier.md) |  | Una condición que delimita la proposición de otro Edge. Property, Target (Edge Id), Value (valor o marcador UNKNOWN-VALUE o NO-VALUE). Forma parte de la proposición |
| `0x0ACL~0x0AFL` | Reservado |  |  |
| `0x0B0L` | [WORLD](edge/0x0B0L-world.md) | sí | Estructura para expresar cosmovisiones |
| `0x0B1L` | [TIMELINE](edge/0x0B1L-timeline.md) | sí | Estructura que expresa el orden de mundos y sucesos |
| `0x0B2L` | [SCENE](edge/0x0B2L-scene.md) | sí | Estructura de escena para enunciar rasgos de un escenario |
| `0x0B3L~0x0B7L` | Reservado |  |  |
| `0x0B8L` | [PUBLICATION](edge/0x0B8L-publication.md) |  | Publicación de un documento. DOC-POINTER, hash de contenido |
| `0x0B9L` | [DEPRECATION](edge/0x0B9L-deprecation.md) |  | Deprecación de una versión publicada. DOC-POINTER |
| `0x0BAL` | [TOMBSTONE](edge/0x0BAL-tombstone.md) |  | Eliminación (lápida) de una versión publicada. DOC-POINTER, categoría del motivo |
| `0x0BBL` | [DECLARE](edge/0x0BBL-declare.md) |  | Declaración de la composición del Payload de un Codec. Kind y Codec de destino |
| `0x0BCL` | [FIELD](edge/0x0BCL-field.md) |  | Un campo del Payload. DECLARE al que pertenece, ancho: registro (Length del TAG) o n WORD de valor en bruto |
| `0x0BDL` | [ENUM](edge/0x0BDL-enum.md) |  | Un valor de código de un campo de valor en bruto. Campo, valor de código |
| `0x0BEL` | [CODEC](edge/0x0BEL-codec.md) |  | Un Kind y Codec que acepta un campo. Campo, WORD de destino (`000K KKKC CCCC LLLL`, LLLL 0000 exacto, 1111 comodín (las 32 casillas de esa sección); los marcadores de posición solo como destino exacto `0000`, `0010`, `0020`). Un campo de registro tiene varios (lista cerrada) y un campo de valor en bruto tiene uno (ese Value sin TAG) |
| `0x0BFL` | Reservado |  |  |

| TAG ID | Grupo |
|---|---|
| `0x0A0L~0x0A7L` | Indicación y nombres |
| `0x0A8L~0x0AFL` | Proposiciones |
| `0x0B0L~0x0B7L` | Estructuras |
| `0x0B8L~0x0BFL` | Otros |

### Fundamento (`0x0C0L~0x0DFL`) {#근거-0x0c0l0x0dfl}

| Codec | Nombre | Subformato | Descripción |
|---|---|---|---|
| `0x0C0L` | [SOURCE](edge/0x0C0L-source.md) |  | Une un registro o todo el documento con su origen. Target (Edge Id de BODY; en HEAD, `0` = todo el documento), Origin (Reference, ABSENT o UNKNOWN-VALUE). La naturaleza del origen se expresa con un TRIPLE que tiene al origen como Subject, y la naturaleza de la cita (fecha de consulta, ubicación, hash del original) con QUALIFIER unidos al SOURCE. El SOURCE de todo el documento y sus QUALIFIER van en HEAD |
| `0x0C1L~0x0DFL` | Reservado |  |  |

- El alcance del texto original, el autor, la fiabilidad, el periodo de vigencia por artículo y los registros antiguos se escriben con QUALIFIER, y la primera versión en que entró se calcula a partir del historial de versiones ([SOURCE](edge/0x0C0L-source.md#다른-근거의-표현)).

### Ejecución (`0x0E0L~0x0FFL`) {#실행-0x0e0l0x0ffl}

| Codec | Nombre | Descripción |
|---|---|---|
| `0x0E0L` | Reservado |  |
| `0x0E1L` | [FUNCTION-DECLARE](edge/0x0E1L-function-declare.md) | Declaración de función. Símbolo, lista de símbolos de parámetros, tipo de retorno, cuerpo (BLOCK) |
| `0x0E2L` | [TYPE-DECLARE](edge/0x0E2L-type-declare.md) | Declaración de tipo. Símbolo y composición (lista de símbolos de campos, valores de enumeración, destino del alias) |
| `0x0E3L~0x0E7L` | Reservado |  |
| `0x0E8L` | [CONST](edge/0x0E8L-const.md) | Expresión constante. Un Value incorporado |
| `0x0E9L` | [UNARY](edge/0x0E9L-unary.md) | Expresión unaria. Operador de 1 WORD, operando |
| `0x0EAL` | [BINARY](edge/0x0EAL-binary.md) | Expresión binaria. Operador de 1 WORD, izquierda, derecha |
| `0x0EBL` | [CALL](edge/0x0EBL-call.md) | Llamada. Función de destino, número de argumentos, argumentos × número de argumentos |
| `0x0ECL` | [MEMBER](edge/0x0ECL-member.md) | Acceso a miembro. Destino, símbolo del campo |
| `0x0EDL` | [INDEX](edge/0x0EDL-index.md) | Acceso por índice. Destino, índice |
| `0x0EEL` | [CONSTRUCT](edge/0x0EEL-construct.md) | Creación de un valor compuesto (lista, registro). Tipo, número de elementos, elementos × número de elementos |
| `0x0EFL` | [CONDITIONAL](edge/0x0EFL-conditional.md) | Expresión condicional. Condición, valor si es verdadera, valor si es falsa |
| `0x0F0L` | [BLOCK](edge/0x0F0L-block.md) | Grupo ordenado de sentencias. Número de sentencias, sentencias × número de sentencias |
| `0x0F1L` | [ASSIGN](edge/0x0F1L-assign.md) | Asignación. Destino (símbolo, MEMBER, INDEX), valor |
| `0x0F2L` | [IF](edge/0x0F2L-if.md) | Bifurcación condicional. Condición, BLOCK verdadero, falso (BLOCK o IF, 0 si no hay) |
| `0x0F3L` | [SWITCH](edge/0x0F3L-switch.md) | Bifurcación múltiple. Destino, número de ramas, (valor, BLOCK) × número de ramas, BLOCK por defecto (0 si no hay) |
| `0x0F4L` | [WHILE](edge/0x0F4L-while.md) | Repetición condicional. Condición, BLOCK del cuerpo |
| `0x0F5L` | [FOREACH](edge/0x0F5L-foreach.md) | Repetición por recorrido. Símbolo del elemento, destino, BLOCK del cuerpo |
| `0x0F6L` | [JUMP](edge/0x0F6L-jump.md) | Control de repetición. Tipo de 1 WORD (break, continue), repetición de destino |
| `0x0F7L` | [RETURN](edge/0x0F7L-return.md) | Retorno. Valor (0 si no hay) |
| `0x0F8L` | [RAISE](edge/0x0F8L-raise.md) | Generación de error. Valor de error |
| `0x0F9L` | [TRY](edge/0x0F9L-try.md) | Tratamiento de errores. BLOCK del cuerpo, símbolo del error, BLOCK de tratamiento, BLOCK final (0 si no hay) |
| `0x0FAL~0x0FFL` | Reservado |  |

| TAG ID | Grupo |
|---|---|
| `0x0E0L~0x0E7L` | Declaraciones |
| `0x0E8L~0x0EFL` | Expresiones |
| `0x0F0L~0x0F7L` | Sentencias |
| `0x0F8L~0x0FFL` | Errores |

### TOULMIN (`0x100L~0x11BL`) {#toulmin-0x100l0x11bl}

En detalle: [TOULMIN](toulmin/_index.md)

| Codec | Nombre | Descripción |
|---|---|---|
| `0x100L` | [CASE-DECLARE](toulmin/0x100L-case-declare.md) | Declaración de caso. Grafo de veredicto que contiene nodos y relaciones |
| `0x101L` | [PREDICATE-DECLARE](toulmin/0x101L-predicate-declare.md) | Declaración de predicado. Función o expresión de veredicto, criterio de juicio (Spec), contrato de hechos (Ground) |
| `0x102L` | [SPEC-DECLARE](toulmin/0x102L-spec-declare.md) | Declaración de criterio de juicio. Constantes y listas (Backing) |
| `0x103L` | [RULE-DECLARE](toulmin/0x103L-rule-declare.md) | Declaración de afirmación. Dentro de un caso, pone un predicado como regla general (Warrant). Puede ser atacada. |
| `0x104L` | [COUNTER-DECLARE](toulmin/0x104L-counter-declare.md) | Declaración de refutación. Ataca con una conclusión propia. El Level por defecto es Fail |
| `0x105L` | [EXCEPT-DECLARE](toulmin/0x105L-except-declare.md) | Declaración de excepción. Ataca sin conclusión propia. El Level por defecto es Review |
| `0x106L~0x107L` | Reservado |  |
| `0x108L` | [ATTACKS](toulmin/0x108L-attacks.md) | Relación de ataque. El veredicto del atacante va reduciendo gradualmente el veredicto del objetivo. |
| `0x109L` | [SUPERSEDES](toulmin/0x109L-supersedes.md) | Relación de exclusión. Si el atacante está Active, saca al objetivo del cómputo de forma determinista. |
| `0x10AL` | [SUPERSEDE-CHAIN](toulmin/0x10AL-supersede-chain.md) | Cadena de prioridad `A > B > C`. Abreviatura de SUPERSEDES por pares. Disposición sin definir |
| `0x10BL~0x10FL` | Reservado |  |
| `0x110L` | [RUN](toulmin/0x110L-run.md) | Composición de ejecución. Si el nodo está Active, ejecuta el caso subordinado (DAG). |
| `0x111L` | [DO](toulmin/0x111L-do.md) | Acción que se realiza si el nodo está Active |
| `0x112L` | [DO-ONCE](toulmin/0x112L-do-once.md) | Acción que se realiza una sola vez aunque se reintente |
| `0x113L` | [UNDO](toulmin/0x113L-undo.md) | Acción de compensación de DO (saga). Si falla un paso posterior, se realiza en orden inverso. |
| `0x114L` | [CHECKING](toulmin/0x114L-checking.md) | Conexión que solo emite veredicto, sin efectos secundarios |
| `0x115L` | [ENTRY](toulmin/0x115L-entry.md) | Punto de entrada externo. Ejecuta o juzga un caso |
| `0x116L` | [TRIGGER](toulmin/0x116L-trigger.md) | Punto de entrada por evento o periodo, sin llamada externa |
| `0x117L` | Reservado |  |
| `0x118L` | [VERDICT](toulmin/0x118L-verdict.md) | Resultado del veredicto de un nodo o registro. Resultado (Pass, Review, Fail), valor del veredicto, Activated, Excluded, Level. Disposición sin definir. El veredicto de todo el documento es Meta [VERDICT](meta/0x1E9L-verdict.md) (`0x1E9L`) |
| `0x119L` | [EVIDENCE](toulmin/0x119L-evidence.md) | Prueba del veredicto. Ubicación, valor esperado, valor real (Fact). Disposición sin definir |
| `0x11AL~0x11BL` | Reservado |  |
| `0x11CL~0x11FL` | Reservado |  |

| TAG ID | Grupo |
|---|---|
| `0x100L~0x107L` | Declaraciones |
| `0x108L~0x10FL` | Relaciones |
| `0x110L~0x117L` | Ejecución |
| `0x118L~0x11FL` | Resultados (`0x11CL~0x11FL` es Reservado) |

### Formato TOULMIN (`0x120L~0x134L`) {#toulmin-형식-0x120l0x134l}

Nodos y relaciones de texto original, particiones y auxiliares de los documentos [TOULMIN](toulmin/_index.md).

| Codec | Nombre | Descripción |
|---|---|---|
| `0x120L` | [SOURCE](toulmin/0x120L-source.md) | Texto original de autoría. Ancho de SPAN y Value UTF8 |
| `0x121L` | [TEXT](toulmin/0x121L-text.md) | Nombres y cadenas |
| `0x122L` | [SECTION](toulmin/0x122L-section.md) | Inicio de sección. Código de sección |
| `0x123L` | [CASE-BEGIN](toulmin/0x123L-case-begin.md) | Inicio del ámbito de un caso |
| `0x124L` | [CASE-END](toulmin/0x124L-case-end.md) | Fin del ámbito de un caso |
| `0x125L` | [PROSE](toulmin/0x125L-prose.md) | Párrafo descriptivo (SPAN) |
| `0x126L` | [NAMESPACE](toulmin/0x126L-namespace.md) | NODE. `this document is` |
| `0x127L` | [FUNC](toulmin/0x127L-func.md) | NODE. Referencia a una función |
| `0x128L` | [FIELD](toulmin/0x128L-field.md) | NODE. `is required` |
| `0x129L` | [ALIAS](toulmin/0x129L-alias.md) | NODE. `see … from` |
| `0x12AL` | [GROUP](toulmin/0x12AL-group.md) | NODE. Grupo de ejecución ordenado |
| `0x12BL` | [REQUIRES](toulmin/0x12BL-requires.md) | LINK. caso → campo |
| `0x12CL` | [MEANS](toulmin/0x12CL-means.md) | LINK. elemento de definición → valor o tipo |
| `0x12DL` | [HAS](toulmin/0x12DL-has.md) | LINK. elemento de definición → campo |
| `0x12EL` | [RUNS](toulmin/0x12EL-runs.md) | LINK. punto de entrada → caso, ejecución |
| `0x12FL` | [EVALUATES](toulmin/0x12FL-evaluates.md) | LINK. punto de entrada → caso, veredicto |
| `0x130L` | [TRIGGERS](toulmin/0x130L-triggers.md) | LINK. trigger → caso |
| `0x131L` | [UNTIL](toulmin/0x131L-until.md) | LINK. trigger → caso (`every … until`) |
| `0x132L` | [SAME-AS](toulmin/0x132L-same-as.md) | LINK. nodo → identificador global |
| `0x133L` | [IMPORTED-FROM](toulmin/0x133L-imported-from.md) | LINK. alias → ruta (TEXT) |
| `0x134L` | [LABEL](toulmin/0x134L-label.md) | LINK. nodo → TEXT, notación del nombre |

- `0x135L~0x1BCL` es Reservado.

### Formato Edge ISSUER {#edge-issuer-형식}

Tras `0x1BDL`~`0x1BFL` ([EDGE-ISSUER-2WORD](edge/0x1BDL-edge-issuer-2word.md), [-4WORD](edge/0x1BEL-edge-issuer-4word.md), [-16WORD](edge/0x1BFL-edge-issuer-16word.md)), la TAG extendida de Codec lleva el Issuer y un número de Codec de 2 WORD. Por ahora no hay ningún formato Edge ISSUER registrado.

## Value {#value}

`0x060L~0x09FL` — [Value](value/_index.md)

El número de Value no indica familia. Los códigos directos van de `0x060L~0x081L` sin Reservados. `0x082L~0x09CL` es Reservado, y `0x09DL~0x09FL` es VALUE-ISSUER. Los nombres de familia (NUMERIC, DECIMAL, TIME, TEXT, BINARY) son grupos temáticos. Los pares par·impar empiezan en un código par.

| Familia | Códigos directos |
|---|---|
| [NUMERIC](value/_index.md#numeric) | `0x060L~0x067L` |
| [DECIMAL](value/_index.md#decimal) | `0x068L~0x069L` |
| [TIME](value/_index.md#time) | `0x06AL~0x071L`, `0x081L` |
| [TEXT](value/_index.md#text) | `0x072L~0x07AL` |
| [BINARY](value/_index.md#binary) | `0x07BL~0x080L` |

### Códigos directos {#직접-코드}

| Codec | Nombre | Familia | Descripción |
|---|---|---|---|
| `0x060L` | [BOOL](value/0x060L-bool.md) | NUMERIC | false o true de 1 WORD fijo |
| `0x061L` | [SIGNED-INTEGER](value/0x061L-signed-integer.md) | NUMERIC | Entero con signo en complemento a dos, con el mínimo de WORD |
| `0x062L` | [UNSIGNED-INTEGER](value/0x062L-unsigned-integer.md) | NUMERIC | Entero de magnitud big-endian sin signo, con el mínimo de WORD |
| `0x063L` | [BINARY-FLOAT](value/0x063L-binary-float.md) | NUMERIC | Escalar IEEE 754 binary16/32/64/128 con Payload de 1/2/4/8 WORD |
| `0x064L` | [COORDINATE-EARTH](value/0x064L-coordinate-earth.md) | NUMERIC | Latitud y longitud terrestres (WGS 84) en binary64, incertidumbre en binary32 y su Reference de unidad (ABSENT = desconocida) |
| `0x065L` | [COORDINATE-GEO](value/0x065L-coordinate-geo.md) | NUMERIC | Reference del cuerpo celeste, latitud y longitud en binary64, incertidumbre en binary32 y su Reference de unidad |
| `0x066L` | [QUANTITY](value/0x066L-quantity.md) | NUMERIC | Value numérico amount (entero, BINARY-FLOAT, decimal, fracción), Reference de unidad, límite inferior y superior. La unidad y los límites se pueden omitir (ABSENT `0x0000`) |
| `0x067L` | [FRACTION](value/0x067L-fraction.md) | NUMERIC | Fracción que conserva la notación original: numerador entero o decimal, denominador entero sin signo o decimal. No se simplifica |
| `0x068L` | [SIGNED-DECIMAL](value/0x068L-signed-decimal.md) | DECIMAL | `C×10^E` con exponente con signo `E` y coeficiente `C` en complemento a dos con el mínimo de WORD |
| `0x069L` | [UNSIGNED-DECIMAL](value/0x069L-unsigned-decimal.md) | DECIMAL | `C×10^E` con exponente con signo `E` y coeficiente `C` sin signo con el mínimo de WORD |
| `0x06AL` | [GREGORIAN-DATE](value/0x06AL-gregorian-date.md) | TIME | Número de días con signo respecto de `1970-01-01` del calendario gregoriano proléptico |
| `0x06BL` | [CIVIL-TIME-NANOSECONDS](value/0x06BL-civil-time-nanoseconds.md) | TIME | Cuenta de nanosegundos sin signo desde la medianoche del día civil |
| `0x06CL` | [POSIX-TIMESTAMP-SECONDS](value/0x06CL-posix-timestamp-seconds.md) | TIME | Cuenta de segundos con signo desde la época Unix/POSIX |
| `0x06DL` | [DURATION-SECONDS](value/0x06DL-duration-seconds.md) | TIME | Tiempo transcurrido con signo en segundos SI, sin época |
| `0x06EL`/`0x06FL` | [EDTF](value/0x06EL-edtf.md) | TIME | Cadena de fecha EDTF (ISO 8601-2). Número par o impar de bytes. No se usa para fechas que se puedan expresar con GREGORIAN-DATE |
| `0x070L`/`0x071L` | [GEDCOM-DATE](value/0x070L-gedcom-date.md) | TIME | Cadena de valor de fecha de GEDCOM 7. Conserva la notación original de otros calendarios (juliano, etc.). Número par o impar de bytes |
| `0x072L` | [UTF8-TEXT-EVEN](value/0x072L-utf8-text.md) | TEXT | Secuencia de bytes UTF-8 válida que no implica normalización. Número par de bytes |
| `0x073L` | [UTF8-TEXT-ODD](value/0x072L-utf8-text.md) | TEXT | Igual que el anterior. Número impar de bytes |
| `0x074L` | [URI-EVEN](value/0x074L-uri.md) | TEXT | Secuencia de bytes ASCII de la producción `URI` de RFC 3986. Número par de bytes |
| `0x075L` | [URI-ODD](value/0x074L-uri.md) | TEXT | Igual que el anterior. Número impar de bytes |
| `0x076L` | [LANGUAGE-BCP47-CODE-EVEN](value/0x076L-language-bcp47-code.md) | TEXT | Secuencia de bytes ASCII de una etiqueta de idioma BCP 47 completa con mayúsculas canónicas. Número par de bytes |
| `0x077L` | [LANGUAGE-BCP47-CODE-ODD](value/0x076L-language-bcp47-code.md) | TEXT | Igual que el anterior. Número impar de bytes |
| `0x078L`/`0x079L` | [UTF8-LANGUAGE-TEXT](value/0x078L-utf8-language-text.md) | TEXT | Texto con idioma. Un registro Value de idioma (LANGUAGE-SHORT-CODE o LANGUAGE-BCP47-CODE) y bytes UTF-8. Par o impar según los bytes del texto |
| `0x07AL` | [LANGUAGE-SHORT-CODE](value/0x07AL-language-short-code.md) | TEXT | Etiqueta BCP 47 escrita con el número del GEUL Language Registry (Payload de 1 WORD) |
| `0x07BL` | [UUID](value/0x07BL-uuid.md) | BINARY | UUID RFC 9562 de 128 bits, con Payload fijo de 8 WORD |
| `0x07CL` | [SHA-256-DIGEST](value/0x07CL-sha-256-digest.md) | BINARY | Resultado SHA-256, con Payload fijo de 16 WORD |
| `0x07DL` | [SHA1-DIGEST](value/0x07DL-sha1-digest.md) | BINARY | Resultado SHA-1, con Payload fijo de 10 WORD. Solo para identificación, como los ID de objetos de git |
| `0x07EL` | [OPAQUE-BYTES-EVEN](value/0x07EL-opaque-bytes.md) | BINARY | Secuencia de bytes de significado y formato desconocidos. Número par de bytes |
| `0x07FL` | [OPAQUE-BYTES-ODD](value/0x07EL-opaque-bytes.md) | BINARY | Igual que el anterior. Número impar de bytes |
| `0x080L` | [BIT-VECTOR](value/0x080L-bit-vector.md) | BINARY | N bits almacenados con MSB primero tras el bit-count |
| `0x081L` | [DURATION-NANOSECONDS](value/0x081L-duration-nanoseconds.md) | TIME | Tiempo transcurrido con signo en nanosegundos, sin época |
| `0x09DL`~`0x09FL` | [VALUE-ISSUER-2WORD](value/0x09DL-value-issuer-2word.md), [-4WORD](value/0x09EL-value-issuer-4word.md), [-16WORD](value/0x09FL-value-issuer-16word.md) |  | Formato definido por el Issuer. Véase el formato Value ISSUER más abajo |

### Formato Value ISSUER {#value-issuer-형식}

Tras `0x09DL`~`0x09FL` ([VALUE-ISSUER-2WORD](value/0x09DL-value-issuer-2word.md), [-4WORD](value/0x09EL-value-issuer-4word.md), [-16WORD](value/0x09FL-value-issuer-16word.md)), la TAG extendida de Codec lleva el Issuer y un número de Codec de 2 WORD. El documento de Codec se coloca bajo `codecs/` de ese Issuer, con el número de Codec del registro. Ejemplo: IETF CRC32C es `0x00000007/codecs/0x0000C000/` ([Direcciones de publicación y lista de versiones](publishing.md)).
| Issuer | Número de Codec | Nombre | Descripción |
|---|---|---|---|
| `0x00000002` ADHOC | `0x00000000` | BFLOAT16 | Bits de intercambio BF16 con Payload fijo de 1 WORD |
| `0x00000002` ADHOC | `0x00000500` | [DENSE-I16-VECTOR](value/adhoc.geul.org/dense-i16-vector.md) | Vector int16 big-endian contiguo |
| `0x00000002` ADHOC | `0x00000501` | [DENSE-U16-VECTOR](value/adhoc.geul.org/dense-u16-vector.md) | Vector uint16 big-endian contiguo |
| `0x00000002` ADHOC | `0x00000502` | [DENSE-I32-VECTOR](value/adhoc.geul.org/dense-i32-vector.md) | Vector int32 big-endian contiguo |
| `0x00000002` ADHOC | `0x00000503` | [DENSE-U32-VECTOR](value/adhoc.geul.org/dense-u32-vector.md) | Vector uint32 big-endian contiguo |
| `0x00000002` ADHOC | `0x00000504` | [DENSE-I64-VECTOR](value/adhoc.geul.org/dense-i64-vector.md) | Vector int64 big-endian contiguo |
| `0x00000002` ADHOC | `0x00000505` | [DENSE-U64-VECTOR](value/adhoc.geul.org/dense-u64-vector.md) | Vector uint64 big-endian contiguo |
| `0x00000002` ADHOC | `0x00000506` | [DENSE-BINARY16-VECTOR](value/adhoc.geul.org/dense-binary16-vector.md) | Vector IEEE 754 binary16 contiguo |
| `0x00000002` ADHOC | `0x00000507` | [DENSE-BFLOAT16-VECTOR](value/adhoc.geul.org/dense-bfloat16-vector.md) | Vector BF16 contiguo |
| `0x00000002` ADHOC | `0x00000508` | [DENSE-BINARY32-VECTOR](value/adhoc.geul.org/dense-binary32-vector.md) | Vector IEEE 754 binary32 contiguo |
| `0x00000002` ADHOC | `0x00000509` | [DENSE-BINARY64-VECTOR](value/adhoc.geul.org/dense-binary64-vector.md) | Vector IEEE 754 binary64 contiguo |
| `0x00000002` ADHOC | `0x0000050A` | [POINT2-BINARY64](value/adhoc.geul.org/point2-binary64.md) | Vector bidimensional IEEE binary64 en el orden `(x,y)` |
| `0x00000002` ADHOC | `0x0000050B` | [POINT3-BINARY64](value/adhoc.geul.org/point3-binary64.md) | Vector tridimensional IEEE binary64 en el orden `(x,y,z)` |
| `0x00000002` ADHOC | `0x0000050C` | [BBOX2-BINARY64](value/adhoc.geul.org/bbox2-binary64.md) | Vector IEEE binary64 en el orden `(minX,minY,maxX,maxY)` |
| `0x00000002` ADHOC | `0x00000600` | [DESCRIBED-DENSE-TENSOR](value/adhoc.geul.org/described-dense-tensor.md) | element-format, rank, shape y Payload denso C-contiguous |
| `0x00000002` ADHOC | `0x00000601` | [DESCRIBED-PACKED-TENSOR](value/adhoc.geul.org/described-packed-tensor.md) | packed-format, rank, shape y Payload empaquetado con low-bit-first dentro del octeto |
| `0x00000002` ADHOC | `0x00000700` | [COMPLEX64](value/adhoc.geul.org/complex64.md) | Dos binary32 en el orden `(real, imag)` |
| `0x00000002` ADHOC | `0x00000701` | [COMPLEX128](value/adhoc.geul.org/complex128.md) | Dos binary64 en el orden `(real, imag)` |
| `0x00000002` ADHOC | `0x00000702` | [RATIONAL-I64](value/adhoc.geul.org/rational-i64.md) | Numerador int64 normalizado y denominador int64 positivo |
| `0x00000002` ADHOC | `0x00000703` | [CLOSED-INTERVAL-BINARY64](value/adhoc.geul.org/closed-interval-binary64.md) | Intervalo cerrado binary64 con `lower ≤ upper` |
| `0x00000002` ADHOC | `0x00000704` | [QUATERNION-BINARY32](value/adhoc.geul.org/quaternion-binary32.md) | Cuatro binary32 en el orden `(x,y,z,w)` |
| `0x00000002` ADHOC | `0x0000C000` | [BLAKE3-256-DIGEST](value/adhoc.geul.org/blake3-256-digest.md) | Resultado BLAKE3 por defecto con Payload fijo de 16 WORD |
| `0x00000007` IETF | `0x00008000` | [URI-RELATIVE-REF-EVEN](value/ietf.geul.org/uri-relative-ref.md) | Secuencia de bytes ASCII relative-ref de RFC 3986. Número par de bytes |
| `0x00000007` IETF | `0x00008001` | [URI-RELATIVE-REF-ODD](value/ietf.geul.org/uri-relative-ref.md) | Igual que el anterior. Número impar de bytes |
| `0x00000007` IETF | `0x0000C000` | [CRC32C](value/ietf.geul.org/crc32c.md) | Resultado CRC-32C de Castagnoli con Payload fijo de 2 WORD |
| `0x00000007` IETF | `0x0000C001` | [IPV4-ADDRESS](value/ietf.geul.org/ipv4-address.md) | Dirección IPv4 de 32 bits con Payload fijo de 2 WORD |
| `0x00000007` IETF | `0x0000C002` | [IPV6-ADDRESS](value/ietf.geul.org/ipv6-address.md) | Dirección IPv6 de 128 bits con Payload fijo de 8 WORD |
| `0x0000000D` IEEE | `0x00002000` | [IEEE-DECIMAL32-DPD](value/ieee.geul.org/ieee-decimal32-dpd.md) | IEEE 754 decimal32 DPD con Payload fijo de 2 WORD |
| `0x0000000D` IEEE | `0x00002001` | [IEEE-DECIMAL64-DPD](value/ieee.geul.org/ieee-decimal64-dpd.md) | IEEE 754 decimal64 DPD con Payload fijo de 4 WORD |
| `0x0000000D` IEEE | `0x00002002` | [IEEE-DECIMAL128-DPD](value/ieee.geul.org/ieee-decimal128-dpd.md) | IEEE 754 decimal128 DPD con Payload fijo de 8 WORD |
| `0x0000000D` IEEE | `0x00002003` | [IEEE-DECIMAL32-BID](value/ieee.geul.org/ieee-decimal32-bid.md) | IEEE 754 decimal32 BID con Payload fijo de 2 WORD |
| `0x0000000D` IEEE | `0x00002004` | [IEEE-DECIMAL64-BID](value/ieee.geul.org/ieee-decimal64-bid.md) | IEEE 754 decimal64 BID con Payload fijo de 4 WORD |
| `0x0000000D` IEEE | `0x00002005` | [IEEE-DECIMAL128-BID](value/ieee.geul.org/ieee-decimal128-bid.md) | IEEE 754 decimal128 BID con Payload fijo de 8 WORD |
| `0x0000000D` IEEE | `0x00004000` | [POSIX-TIMESTAMP-NANOSECONDS](value/ieee.geul.org/posix-timestamp-nanoseconds.md) | Cuenta de nanosegundos con signo desde la época Unix/POSIX |
| `0x0000000D` IEEE | `0x0000C000` | [MAC-48-ADDRESS](value/ieee.geul.org/mac-48-address.md) | Dirección MAC IEEE 802 de 48 bits con Payload fijo de 3 WORD |
| `0x0000000E` KHRONOS | `0x00000000` | [RGBA8-UNORM](value/khronos.geul.org/rgba8-unorm.md) | Vector empaquetado fijo de 4×UNORM8 en el orden R, G, B, A |
| `0x0000000E` KHRONOS | `0x00000001` | [BGRA8-UNORM](value/khronos.geul.org/bgra8-unorm.md) | Vector empaquetado fijo de 4×UNORM8 en el orden B, G, R, A |
| `0x00000010` ONNX | `0x00000000` | FP8-E4M3FN | Escalar ONNX E4M3FN en el octeto superior del Payload |
| `0x00000010` ONNX | `0x00000001` | FP8-E4M3FNUZ | Escalar ONNX E4M3FNUZ en el octeto superior del Payload |
| `0x00000010` ONNX | `0x00000002` | FP8-E5M2 | Escalar ONNX E5M2 en el octeto superior del Payload |
| `0x00000010` ONNX | `0x00000003` | FP8-E5M2FNUZ | Escalar ONNX E5M2FNUZ en el octeto superior del Payload |
| `0x00000011` OCP | `0x00000000` | FP8-E8M0FNU | Escalar E8M0FNU sin signo, solo exponente, en el octeto superior del Payload |
| `0x00000011` OCP | `0x00000001` | FP4-E2M1FN | Escalar ONNX/DLPack E2M1FN en el nibble superior del Payload |
| `0x00000013` BIPM | `0x00004000` | [TAI-TIMESTAMP-SECONDS](value/bipm.geul.org/tai-timestamp-seconds.md) | Cuenta de segundos SI con signo desde `1970-01-01T00:00:00 TAI` |
| `0x00000013` BIPM | `0x00004001` | [TAI-TIMESTAMP-NANOSECONDS](value/bipm.geul.org/tai-timestamp-nanoseconds.md) | Cuenta de nanosegundos con signo desde la misma época TAI |
| `0x00000015` NIST | `0x0000C000` | [SHA-512-DIGEST](value/nist.geul.org/sha-512-digest.md) | Resultado SHA-512 con Payload fijo de 32 WORD |
| `0x00000015` NIST | `0x0000C001` | [SHA3-256-DIGEST](value/nist.geul.org/sha3-256-digest.md) | Resultado SHA3-256 con Payload fijo de 16 WORD |
| `0x00000016` GPS | `0x00004000` | [GPS-TIMESTAMP-SECONDS](value/gps.geul.org/gps-timestamp-seconds.md) | Cuenta de segundos con signo desde la época GPS |
| `0x00000016` GPS | `0x00004001` | [GPS-TIMESTAMP-NANOSECONDS](value/gps.geul.org/gps-timestamp-nanoseconds.md) | Cuenta de nanosegundos con signo desde la época GPS |

## Meta {#meta}

`0x1C0L~0x1FFL` — [Meta](meta/_index.md)

El número de Meta no indica la clase mediante bits. La clase se conoce por la tabla de rangos siguiente. La clase de verificación son los registros con `C >= 5` en la sección 15, es decir, `w >= 0x1E50`, y se conoce sin codebook. Meta no tiene códigos ISSUER.

| Clase | Códigos directos | Qué trata |
|---|---|---|
| [estructura](meta/_index.md#구조) | `0x1C0L~0x1C4L` | Límites y longitud del documento |
| [definición](meta/_index.md#정의) | `0x1C5L~0x1CAL` | Declaraciones de interpretación |
| [procedencia](meta/_index.md#출처) | `0x1CBL~0x1D0L` | Quién, cuándo, dónde |
| [linaje](meta/_index.md#계보) | `0x1D1L~0x1DDL` | De qué y cómo surgió |
| [política](meta/_index.md#정책) | `0x1DEL~0x1E3L` | Cómo se trata |
| [IMPORT](meta/_index.md#import) | `0x1E4L` | Trae un documento externo mediante un IMPORT ID (`IMPORT-DOC`) |
| [verificación](meta/_index.md#검증) | `0x1E5L~0x1E9L` | Si es fiable |
| Reservado (solo verificación) | `0x1EAL~0x1FFL` |  |

- Los números continúan desde `0x1C0L` sin Reservados. Un Meta nuevo ajeno a la verificación no se puede insertar antes de la verificación. El Reservado final `0x1EAL~0x1FFL` es exclusivo de la verificación. Si se coloca aquí un Meta ajeno a la verificación, queda fuera del hash de contenido.

### Estructura (`0x1C0L~0x1C4L`) {#구조-0x1c0l0x1c4l}

| Codec | Nombre | Descripción |
|---|---|---|
| `0x1C0L` | [DOC-1WORD](meta/0x1C0L-doc-1word.md) | Inicio de documento con la longitud total indicada en un Payload de 1 WORD |
| `0x1C1L` | [DOC-2WORD](meta/0x1C1L-doc-2word.md) | Inicio de documento con la longitud total indicada en un Payload de 2 WORD |
| `0x1C2L` | [DOC-4WORD](meta/0x1C2L-doc-4word.md) | Inicio de documento con la longitud total indicada en un Payload de 4 WORD |
| `0x1C3L` | [BODY](meta/0x1C3L-body.md) | 1 WORD. Termina el HEAD del documento y empieza el BODY. |
| `0x1C4L` | [END](meta/0x1C4L-end.md) | 1 WORD. Cierra el documento. |

### Definición (`0x1C5L~0x1CAL`) {#정의-0x1c5l0x1cal}

| Codec | Nombre | Descripción |
|---|---|---|
| `0x1C5L` | [SPEC-VERSION](meta/0x1C5L-spec-version.md) | Edición de la especificación GEUL que se sigue. El Payload es directamente un entero sin signo del ancho más corto. v1 es `0x0001` (registro `0x1C51 0x0001`) |
| `0x1C6L` | [PROFILE](meta/0x1C6L-profile.md) | Perfil aplicado |
| `0x1C7L` | [DOC-ID](meta/0x1C7L-doc-id.md) | Identificador de este documento. Reference incorporada `DOC-POINTER` (Issuer, ID de documento, versión 0). Un documento de Codec usa `CODEC-POINTER` (Issuer, ID de Codec, versión 0) |
| `0x1C8L` | [EFFECTIVE-FROM](meta/0x1C8L-effective-from.md) | Fecha de entrada en vigor de esta versión. Value GREGORIAN-DATE o POSIX-TIMESTAMP. Si no hay, la hora de publicación |
| `0x1C9L` | [EFFECTIVE-UNTIL](meta/0x1C9L-effective-until.md) | Fin del periodo de validez de esta versión (ley temporal). Si no hay, hasta que entre en vigor la versión siguiente |
| `0x1CAL` | [DEFAULT-LANGUAGE](meta/0x1CAL-default-language.md) | Idioma por defecto |

### Procedencia (`0x1CBL~0x1D0L`) {#출처-0x1cbl0x1d0l}

| Codec | Nombre | Descripción |
|---|---|---|
| `0x1CBL` | [AUTHOR](meta/0x1CBL-author.md) | Autor. Reference (git author) |
| `0x1CCL` | [CO-AUTHOR](meta/0x1CCL-co-author.md) | Coautor. Reference (git `Co-authored-by`) |
| `0x1CDL` | [CREATED-AT](meta/0x1CDL-created-at.md) | Hora de creación. Value TIME (git author date) |
| `0x1CEL` | [MODIFIED-AT](meta/0x1CEL-modified-at.md) | Hora de modificación. Value TIME |
| `0x1CFL` | [RECORDED-BY](meta/0x1CFL-recorded-by.md) | Entidad que registró. Reference (git committer) |
| `0x1D0L` | [RECORDED-AT](meta/0x1D0L-recorded-at.md) | Hora del registro. Value TIME (git commit date) |

- El material original, su alcance, la hora de obtención y el hash no se escriben en Meta, sino con el Edge de fundamento [SOURCE](edge/0x0C0L-source.md#문서-전체의-출처) del HEAD (Target `0`) y sus QUALIFIER.

### Linaje (`0x1D1L~0x1DDL`) {#계보-0x1d1l0x1ddl}

| Codec | Nombre | Descripción |
|---|---|---|
| `0x1D1L` | [PARENT](meta/0x1D1L-parent.md) | Hash de contenido de la versión inmediatamente anterior (git parent). Si no hay, es la primera versión; si hay varios, es una fusión (git merge commit). |
| `0x1D2L` | [DERIVED-FROM](meta/0x1D2L-derived-from.md) | Derivado de registros o material de otro linaje. Para fijarlo a una versión concreta de un material externo, se añade al [SOURCE](edge/0x0C0L-source.md#문서-전체의-출처) del HEAD un QUALIFIER de hash del original (P4092) (git submodule). |
| `0x1D3L` | [GENERATED-BY](meta/0x1D3L-generated-by.md) | Entidad generadora. Persona, modelo, motor de reglas |
| `0x1D4L` | [TRANSFORMED-BY](meta/0x1D4L-transformed-by.md) | Método de transformación. Herramienta, regla, versión |
| `0x1D5L` | [CHERRY-PICKED-FROM](meta/0x1D5L-cherry-picked-from.md) | Hash de contenido de la versión original de la que se tomó un cambio de otro linaje (git cherry-pick `-x`) |
| `0x1D6L` | [REVERTS](meta/0x1D6L-reverts.md) | Hash de contenido de la versión cuyo cambio se revirtió (git revert) |
| `0x1D7L` | [REPLACES](meta/0x1D7L-replaces.md) | Hash de contenido de la versión que se reescribió (git amend·rebase). La versión original no se borra. |
| `0x1D8L` | [SQUASHED-FROM](meta/0x1D8L-squashed-from.md) | Hashes de contenido de las versiones originales que se fusionaron en una (git squash) |
| `0x1D9L` | [MESSAGE](meta/0x1D9L-message.md) | Motivo del cambio. Value UTF8-LANGUAGE-TEXT, uno por idioma (git commit message) |
| `0x1DAL` | [TAG](meta/0x1DAL-tag.md) | Nombre inmutable puesto a una versión. Value TEXT y hash de contenido (git annotated tag) |
| `0x1DBL` | [DELTA-BASE](meta/0x1DBL-delta-base.md) | El archivo de esta versión es un diff respecto de una versión base del mismo documento (ID de versión de 2 WORD) (git packfile delta) |
| `0x1DCL` | [DELTA-REMOVE](meta/0x1DCL-delta-remove.md) | Lista de ID LOCAL (Edge Id) que el diff quita del BODY base |
| `0x1DDL` | [NEXT-LOCAL-ID](meta/0x1DDL-next-local-id.md) | Siguiente ID LOCAL que se asignará (auto increment). Se coloca en el HEAD de `versions.geul`, la lista de versiones |

### Política (`0x1DEL~0x1E3L`) {#정책-0x1del0x1e3l}

| Codec | Nombre | Descripción |
|---|---|---|
| `0x1DEL` | [LICENSE](meta/0x1DEL-license.md) | Licencia. Reference |
| `0x1DFL` | [ACCESS](meta/0x1DFL-access.md) | Ámbito de divulgación |
| `0x1E0L` | [PRIVACY](meta/0x1E0L-privacy.md) | Nivel de datos personales |
| `0x1E1L` | [RETENTION](meta/0x1E1L-retention.md) | Plazo de conservación |
| `0x1E2L` | [CONSENT](meta/0x1E2L-consent.md) | Alcance y fundamento del consentimiento |
| `0x1E3L` | [USAGE](meta/0x1E3L-usage.md) | Restricciones de uso |

### IMPORT (`0x1E4L`) {#import-0x1e4l}

| Codec | Nombre | Descripción |
|---|---|---|
| `0x1E4L` | [IMPORT-DOC](meta/0x1E4L-import-doc.md) | Trae un documento externo mediante un IMPORT ID. Reference incorporada `DOC-POINTER` (`CODEC-POINTER` para un documento de Codec) + IMPORT ID |

### Verificación (`0x1E5L~0x1E9L`) {#검증-0x1e5l0x1e9l}

| Codec | Nombre | Descripción |
|---|---|---|
| `0x1E5L` | [ISSUER-KEY](meta/0x1E5L-issuer-key.md) | Declaración del ID del algoritmo de firma y de la clave pública de un Issuer autoemitido |
| `0x1E6L` | [SIGNATURE](meta/0x1E6L-signature.md) | Firma sobre un objetivo. La firma de un documento firma el hash de contenido (git signed commit·tag) |
| `0x1E7L` | [SIGNED-OFF](meta/0x1E7L-signed-off.md) | Confirmación del derecho de contribución. Reference (git `Signed-off-by`, DCO) |
| `0x1E8L` | [CONFIDENCE](meta/0x1E8L-confidence.md) | Grado de confianza |
| `0x1E9L` | [VERDICT](meta/0x1E9L-verdict.md) | Resultado del veredicto de todo el documento. Pass, Review, Fail. Por nodo o registro es [TOULMIN](toulmin/_index.md) `VERDICT` (Edge `0x118L`) |

## Tabla completa de asignación {#전체-배정표}

227 casillas asignadas, 176 md. Los sistemas 5Q y los pares par·impar ocupan una fila por miembro, y el md es el md de cabecera del grupo.

| TAG ID | ID de Codec | Nombre | Kind | Sección | md | Grupo |
|---|---|---|---|---|---|---|
| `0x000L` | `0x00000000` | ABSENT | Reference | 0 | [0x000L-absent.md](reference/0x000L-absent.md) |  |
| `0x001L` | `0x00000010` | UNKNOWN-VALUE | Reference | 0 | [0x001L-unknown-value.md](reference/0x001L-unknown-value.md) |  |
| `0x002L` | `0x00000020` | NO-VALUE | Reference | 0 | [0x002L-no-value.md](reference/0x002L-no-value.md) |  |
| `0x005L` | `0x00000050` | LOCAL-IDENTIFIED | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x006L` | `0x00000060` | LOCAL-GENERIC | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x007L` | `0x00000070` | LOCAL-FREE-CHOICE | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x008L` | `0x00000080` | LOCAL-UNIVERSAL | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x009L` | `0x00000090` | LOCAL-VARIABLE | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x00AL` | `0x000000A0` | GEUL-IDENTIFIED | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00BL` | `0x000000B0` | GEUL-GENERIC | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00CL` | `0x000000C0` | GEUL-FREE-CHOICE | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00DL` | `0x000000D0` | GEUL-UNIVERSAL | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00EL` | `0x000000E0` | GEUL-VARIABLE | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00FL` | `0x000000F0` | GEUL-SIDX-IDENTIFIED | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x010L` | `0x00000100` | GEUL-SIDX-GENERIC | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x011L` | `0x00000110` | GEUL-SIDX-FREE-CHOICE | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x012L` | `0x00000120` | GEUL-SIDX-UNIVERSAL | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x013L` | `0x00000130` | GEUL-SIDX-VARIABLE | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x014L` | `0x00000140` | WIKIDATA-QID-IDENTIFIED | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x015L` | `0x00000150` | WIKIDATA-QID-GENERIC | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x016L` | `0x00000160` | WIKIDATA-QID-FREE-CHOICE | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x017L` | `0x00000170` | WIKIDATA-QID-UNIVERSAL | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x018L` | `0x00000180` | WIKIDATA-QID-VARIABLE | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x019L` | `0x00000190` | WIKIDATA-PID-IDENTIFIED | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x01AL` | `0x000001A0` | WIKIDATA-PID-GENERIC | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x01BL` | `0x000001B0` | WIKIDATA-PID-FREE-CHOICE | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x01CL` | `0x000001C0` | WIKIDATA-PID-UNIVERSAL | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x01DL` | `0x000001D0` | WIKIDATA-PID-VARIABLE | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x020L` | `0x00000200` | EXTERNAL-POINTER-1WORD-IDENTIFIED | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x021L` | `0x00000210` | EXTERNAL-POINTER-1WORD-GENERIC | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x022L` | `0x00000220` | EXTERNAL-POINTER-1WORD-FREE-CHOICE | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x023L` | `0x00000230` | EXTERNAL-POINTER-1WORD-UNIVERSAL | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x024L` | `0x00000240` | EXTERNAL-POINTER-1WORD-VARIABLE | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x025L` | `0x00000250` | EXTERNAL-POINTER-2WORD-IDENTIFIED | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x026L` | `0x00000260` | EXTERNAL-POINTER-2WORD-GENERIC | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x027L` | `0x00000270` | EXTERNAL-POINTER-2WORD-FREE-CHOICE | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x028L` | `0x00000280` | EXTERNAL-POINTER-2WORD-UNIVERSAL | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x029L` | `0x00000290` | EXTERNAL-POINTER-2WORD-VARIABLE | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x02AL` | `0x000002A0` | EXTERNAL-POINTER-4WORD-IDENTIFIED | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02BL` | `0x000002B0` | EXTERNAL-POINTER-4WORD-GENERIC | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02CL` | `0x000002C0` | EXTERNAL-POINTER-4WORD-FREE-CHOICE | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02DL` | `0x000002D0` | EXTERNAL-POINTER-4WORD-UNIVERSAL | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02EL` | `0x000002E0` | EXTERNAL-POINTER-4WORD-VARIABLE | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02FL` | `0x000002F0` | EXTERNAL-ISSUER-2WORD-IDENTIFIED | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x030L` | `0x00000300` | EXTERNAL-ISSUER-2WORD-GENERIC | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x031L` | `0x00000310` | EXTERNAL-ISSUER-2WORD-FREE-CHOICE | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x032L` | `0x00000320` | EXTERNAL-ISSUER-2WORD-UNIVERSAL | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x033L` | `0x00000330` | EXTERNAL-ISSUER-2WORD-VARIABLE | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x034L` | `0x00000340` | EXTERNAL-ISSUER-4WORD-IDENTIFIED | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x035L` | `0x00000350` | EXTERNAL-ISSUER-4WORD-GENERIC | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x036L` | `0x00000360` | EXTERNAL-ISSUER-4WORD-FREE-CHOICE | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x037L` | `0x00000370` | EXTERNAL-ISSUER-4WORD-UNIVERSAL | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x038L` | `0x00000380` | EXTERNAL-ISSUER-4WORD-VARIABLE | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x039L` | `0x00000390` | EXTERNAL-ISSUER-16WORD-IDENTIFIED | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x03AL` | `0x000003A0` | EXTERNAL-ISSUER-16WORD-GENERIC | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x03BL` | `0x000003B0` | EXTERNAL-ISSUER-16WORD-FREE-CHOICE | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x03CL` | `0x000003C0` | EXTERNAL-ISSUER-16WORD-UNIVERSAL | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x03DL` | `0x000003D0` | EXTERNAL-ISSUER-16WORD-VARIABLE | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x040L` | `0x00000400` | ISSUER-POINTER | Reference | 2 | [0x040L-issuer-pointer.md](reference/0x040L-issuer-pointer.md) |  |
| `0x041L` | `0x00000410` | DOC-POINTER | Reference | 2 | [0x041L-doc-pointer.md](reference/0x041L-doc-pointer.md) |  |
| `0x042L` | `0x00000420` | CODEC-POINTER | Reference | 2 | [0x042L-codec-pointer.md](reference/0x042L-codec-pointer.md) |  |
| `0x043L` | `0x00000430` | TOKEN-0 | Reference | 2 | [0x043L-token.md](reference/0x043L-token.md) | Par `TOKEN-0`·`TOKEN-1` |
| `0x044L` | `0x00000440` | TOKEN-1 | Reference | 2 | [0x043L-token.md](reference/0x043L-token.md) | Par `TOKEN-0`·`TOKEN-1` |
| `0x05DL` | `0x000005D0` | REFERENCE-ISSUER-2WORD | Reference | 2 | [0x05DL-reference-issuer-2word.md](reference/0x05DL-reference-issuer-2word.md) |  |
| `0x05EL` | `0x000005E0` | REFERENCE-ISSUER-4WORD | Reference | 2 | [0x05EL-reference-issuer-4word.md](reference/0x05EL-reference-issuer-4word.md) |  |
| `0x05FL` | `0x000005F0` | REFERENCE-ISSUER-16WORD | Reference | 2 | [0x05FL-reference-issuer-16word.md](reference/0x05FL-reference-issuer-16word.md) |  |
| `0x060L` | `0x00000600` | BOOL | Value | 3 | [0x060L-bool.md](value/0x060L-bool.md) |  |
| `0x061L` | `0x00000610` | SIGNED-INTEGER | Value | 3 | [0x061L-signed-integer.md](value/0x061L-signed-integer.md) |  |
| `0x062L` | `0x00000620` | UNSIGNED-INTEGER | Value | 3 | [0x062L-unsigned-integer.md](value/0x062L-unsigned-integer.md) |  |
| `0x063L` | `0x00000630` | BINARY-FLOAT | Value | 3 | [0x063L-binary-float.md](value/0x063L-binary-float.md) |  |
| `0x064L` | `0x00000640` | COORDINATE-EARTH | Value | 3 | [0x064L-coordinate-earth.md](value/0x064L-coordinate-earth.md) |  |
| `0x065L` | `0x00000650` | COORDINATE-GEO | Value | 3 | [0x065L-coordinate-geo.md](value/0x065L-coordinate-geo.md) |  |
| `0x066L` | `0x00000660` | QUANTITY | Value | 3 | [0x066L-quantity.md](value/0x066L-quantity.md) |  |
| `0x067L` | `0x00000670` | FRACTION | Value | 3 | [0x067L-fraction.md](value/0x067L-fraction.md) |  |
| `0x068L` | `0x00000680` | SIGNED-DECIMAL | Value | 3 | [0x068L-signed-decimal.md](value/0x068L-signed-decimal.md) |  |
| `0x069L` | `0x00000690` | UNSIGNED-DECIMAL | Value | 3 | [0x069L-unsigned-decimal.md](value/0x069L-unsigned-decimal.md) |  |
| `0x06AL` | `0x000006A0` | GREGORIAN-DATE | Value | 3 | [0x06AL-gregorian-date.md](value/0x06AL-gregorian-date.md) |  |
| `0x06BL` | `0x000006B0` | CIVIL-TIME-NANOSECONDS | Value | 3 | [0x06BL-civil-time-nanoseconds.md](value/0x06BL-civil-time-nanoseconds.md) |  |
| `0x06CL` | `0x000006C0` | POSIX-TIMESTAMP-SECONDS | Value | 3 | [0x06CL-posix-timestamp-seconds.md](value/0x06CL-posix-timestamp-seconds.md) |  |
| `0x06DL` | `0x000006D0` | DURATION-SECONDS | Value | 3 | [0x06DL-duration-seconds.md](value/0x06DL-duration-seconds.md) |  |
| `0x06EL` | `0x000006E0` | EDTF-EVEN | Value | 3 | [0x06EL-edtf.md](value/0x06EL-edtf.md) | par·impar `EDTF` |
| `0x06FL` | `0x000006F0` | EDTF-ODD | Value | 3 | [0x06EL-edtf.md](value/0x06EL-edtf.md) | par·impar `EDTF` |
| `0x070L` | `0x00000700` | GEDCOM-DATE-EVEN | Value | 3 | [0x070L-gedcom-date.md](value/0x070L-gedcom-date.md) | par·impar `GEDCOM-DATE` |
| `0x071L` | `0x00000710` | GEDCOM-DATE-ODD | Value | 3 | [0x070L-gedcom-date.md](value/0x070L-gedcom-date.md) | par·impar `GEDCOM-DATE` |
| `0x072L` | `0x00000720` | UTF8-TEXT-EVEN | Value | 3 | [0x072L-utf8-text.md](value/0x072L-utf8-text.md) | par·impar `UTF8-TEXT` |
| `0x073L` | `0x00000730` | UTF8-TEXT-ODD | Value | 3 | [0x072L-utf8-text.md](value/0x072L-utf8-text.md) | par·impar `UTF8-TEXT` |
| `0x074L` | `0x00000740` | URI-EVEN | Value | 3 | [0x074L-uri.md](value/0x074L-uri.md) | par·impar `URI` |
| `0x075L` | `0x00000750` | URI-ODD | Value | 3 | [0x074L-uri.md](value/0x074L-uri.md) | par·impar `URI` |
| `0x076L` | `0x00000760` | LANGUAGE-BCP47-CODE-EVEN | Value | 3 | [0x076L-language-bcp47-code.md](value/0x076L-language-bcp47-code.md) | par·impar `LANGUAGE-BCP47-CODE` |
| `0x077L` | `0x00000770` | LANGUAGE-BCP47-CODE-ODD | Value | 3 | [0x076L-language-bcp47-code.md](value/0x076L-language-bcp47-code.md) | par·impar `LANGUAGE-BCP47-CODE` |
| `0x078L` | `0x00000780` | UTF8-LANGUAGE-TEXT-EVEN | Value | 3 | [0x078L-utf8-language-text.md](value/0x078L-utf8-language-text.md) | par·impar `UTF8-LANGUAGE-TEXT` |
| `0x079L` | `0x00000790` | UTF8-LANGUAGE-TEXT-ODD | Value | 3 | [0x078L-utf8-language-text.md](value/0x078L-utf8-language-text.md) | par·impar `UTF8-LANGUAGE-TEXT` |
| `0x07AL` | `0x000007A0` | LANGUAGE-SHORT-CODE | Value | 3 | [0x07AL-language-short-code.md](value/0x07AL-language-short-code.md) |  |
| `0x07BL` | `0x000007B0` | UUID | Value | 3 | [0x07BL-uuid.md](value/0x07BL-uuid.md) |  |
| `0x07CL` | `0x000007C0` | SHA-256-DIGEST | Value | 3 | [0x07CL-sha-256-digest.md](value/0x07CL-sha-256-digest.md) |  |
| `0x07DL` | `0x000007D0` | SHA1-DIGEST | Value | 3 | [0x07DL-sha1-digest.md](value/0x07DL-sha1-digest.md) |  |
| `0x07EL` | `0x000007E0` | OPAQUE-BYTES-EVEN | Value | 3 | [0x07EL-opaque-bytes.md](value/0x07EL-opaque-bytes.md) | par·impar `OPAQUE-BYTES` |
| `0x07FL` | `0x000007F0` | OPAQUE-BYTES-ODD | Value | 3 | [0x07EL-opaque-bytes.md](value/0x07EL-opaque-bytes.md) | par·impar `OPAQUE-BYTES` |
| `0x080L` | `0x00000800` | BIT-VECTOR | Value | 4 | [0x080L-bit-vector.md](value/0x080L-bit-vector.md) |  |
| `0x081L` | `0x00000810` | DURATION-NANOSECONDS | Value | 4 | [0x081L-duration-nanoseconds.md](value/0x081L-duration-nanoseconds.md) |  |
| `0x09DL` | `0x000009D0` | VALUE-ISSUER-2WORD | Value | 4 | [0x09DL-value-issuer-2word.md](value/0x09DL-value-issuer-2word.md) |  |
| `0x09EL` | `0x000009E0` | VALUE-ISSUER-4WORD | Value | 4 | [0x09EL-value-issuer-4word.md](value/0x09EL-value-issuer-4word.md) |  |
| `0x09FL` | `0x000009F0` | VALUE-ISSUER-16WORD | Value | 4 | [0x09FL-value-issuer-16word.md](value/0x09FL-value-issuer-16word.md) |  |
| `0x0A0L` | `0x00000A00` | REFERENCE-NODE | Edge | 5 | [0x0A0L-reference-node.md](edge/0x0A0L-reference-node.md) |  |
| `0x0A1L` | `0x00000A10` | SAME-NODE | Edge | 5 | [0x0A1L-same-node.md](edge/0x0A1L-same-node.md) |  |
| `0x0A2L` | `0x00000A20` | DIFFERENT-NODE | Edge | 5 | [0x0A2L-different-node.md](edge/0x0A2L-different-node.md) |  |
| `0x0A3L` | `0x00000A30` | BIND | Edge | 5 | [0x0A3L-bind.md](edge/0x0A3L-bind.md) |  |
| `0x0A4L` | `0x00000A40` | LABEL | Edge | 5 | [0x0A4L-label.md](edge/0x0A4L-label.md) |  |
| `0x0A5L` | `0x00000A50` | ALIAS | Edge | 5 | [0x0A5L-alias.md](edge/0x0A5L-alias.md) |  |
| `0x0A6L` | `0x00000A60` | DESCRIPTION | Edge | 5 | [0x0A6L-description.md](edge/0x0A6L-description.md) |  |
| `0x0A8L` | `0x00000A80` | VERB-SHORT | Edge | 5 | [0x0A8L-verb-short.md](edge/0x0A8L-verb-short.md) |  |
| `0x0A9L` | `0x00000A90` | VERB | Edge | 5 | [0x0A9L-verb.md](edge/0x0A9L-verb.md) |  |
| `0x0AAL` | `0x00000AA0` | TRIPLE | Edge | 5 | [0x0AAL-triple.md](edge/0x0AAL-triple.md) |  |
| `0x0ABL` | `0x00000AB0` | QUALIFIER | Edge | 5 | [0x0ABL-qualifier.md](edge/0x0ABL-qualifier.md) |  |
| `0x0B0L` | `0x00000B00` | WORLD | Edge | 5 | [0x0B0L-world.md](edge/0x0B0L-world.md) |  |
| `0x0B1L` | `0x00000B10` | TIMELINE | Edge | 5 | [0x0B1L-timeline.md](edge/0x0B1L-timeline.md) |  |
| `0x0B2L` | `0x00000B20` | SCENE | Edge | 5 | [0x0B2L-scene.md](edge/0x0B2L-scene.md) |  |
| `0x0B8L` | `0x00000B80` | PUBLICATION | Edge | 5 | [0x0B8L-publication.md](edge/0x0B8L-publication.md) |  |
| `0x0B9L` | `0x00000B90` | DEPRECATION | Edge | 5 | [0x0B9L-deprecation.md](edge/0x0B9L-deprecation.md) |  |
| `0x0BAL` | `0x00000BA0` | TOMBSTONE | Edge | 5 | [0x0BAL-tombstone.md](edge/0x0BAL-tombstone.md) |  |
| `0x0BBL` | `0x00000BB0` | DECLARE | Edge | 5 | [0x0BBL-declare.md](edge/0x0BBL-declare.md) |  |
| `0x0BCL` | `0x00000BC0` | FIELD | Edge | 5 | [0x0BCL-field.md](edge/0x0BCL-field.md) |  |
| `0x0BDL` | `0x00000BD0` | ENUM | Edge | 5 | [0x0BDL-enum.md](edge/0x0BDL-enum.md) |  |
| `0x0BEL` | `0x00000BE0` | CODEC | Edge | 5 | [0x0BEL-codec.md](edge/0x0BEL-codec.md) |  |
| `0x0C0L` | `0x00000C00` | SOURCE | Edge | 6 | [0x0C0L-source.md](edge/0x0C0L-source.md) |  |
| `0x0E1L` | `0x00000E10` | FUNCTION-DECLARE | Edge | 7 | [0x0E1L-function-declare.md](edge/0x0E1L-function-declare.md) |  |
| `0x0E2L` | `0x00000E20` | TYPE-DECLARE | Edge | 7 | [0x0E2L-type-declare.md](edge/0x0E2L-type-declare.md) |  |
| `0x0E8L` | `0x00000E80` | CONST | Edge | 7 | [0x0E8L-const.md](edge/0x0E8L-const.md) |  |
| `0x0E9L` | `0x00000E90` | UNARY | Edge | 7 | [0x0E9L-unary.md](edge/0x0E9L-unary.md) |  |
| `0x0EAL` | `0x00000EA0` | BINARY | Edge | 7 | [0x0EAL-binary.md](edge/0x0EAL-binary.md) |  |
| `0x0EBL` | `0x00000EB0` | CALL | Edge | 7 | [0x0EBL-call.md](edge/0x0EBL-call.md) |  |
| `0x0ECL` | `0x00000EC0` | MEMBER | Edge | 7 | [0x0ECL-member.md](edge/0x0ECL-member.md) |  |
| `0x0EDL` | `0x00000ED0` | INDEX | Edge | 7 | [0x0EDL-index.md](edge/0x0EDL-index.md) |  |
| `0x0EEL` | `0x00000EE0` | CONSTRUCT | Edge | 7 | [0x0EEL-construct.md](edge/0x0EEL-construct.md) |  |
| `0x0EFL` | `0x00000EF0` | CONDITIONAL | Edge | 7 | [0x0EFL-conditional.md](edge/0x0EFL-conditional.md) |  |
| `0x0F0L` | `0x00000F00` | BLOCK | Edge | 7 | [0x0F0L-block.md](edge/0x0F0L-block.md) |  |
| `0x0F1L` | `0x00000F10` | ASSIGN | Edge | 7 | [0x0F1L-assign.md](edge/0x0F1L-assign.md) |  |
| `0x0F2L` | `0x00000F20` | IF | Edge | 7 | [0x0F2L-if.md](edge/0x0F2L-if.md) |  |
| `0x0F3L` | `0x00000F30` | SWITCH | Edge | 7 | [0x0F3L-switch.md](edge/0x0F3L-switch.md) |  |
| `0x0F4L` | `0x00000F40` | WHILE | Edge | 7 | [0x0F4L-while.md](edge/0x0F4L-while.md) |  |
| `0x0F5L` | `0x00000F50` | FOREACH | Edge | 7 | [0x0F5L-foreach.md](edge/0x0F5L-foreach.md) |  |
| `0x0F6L` | `0x00000F60` | JUMP | Edge | 7 | [0x0F6L-jump.md](edge/0x0F6L-jump.md) |  |
| `0x0F7L` | `0x00000F70` | RETURN | Edge | 7 | [0x0F7L-return.md](edge/0x0F7L-return.md) |  |
| `0x0F8L` | `0x00000F80` | RAISE | Edge | 7 | [0x0F8L-raise.md](edge/0x0F8L-raise.md) |  |
| `0x0F9L` | `0x00000F90` | TRY | Edge | 7 | [0x0F9L-try.md](edge/0x0F9L-try.md) |  |
| `0x100L` | `0x00001000` | CASE-DECLARE | Edge | 8 | [0x100L-case-declare.md](toulmin/0x100L-case-declare.md) |  |
| `0x101L` | `0x00001010` | PREDICATE-DECLARE | Edge | 8 | [0x101L-predicate-declare.md](toulmin/0x101L-predicate-declare.md) |  |
| `0x102L` | `0x00001020` | SPEC-DECLARE | Edge | 8 | [0x102L-spec-declare.md](toulmin/0x102L-spec-declare.md) |  |
| `0x103L` | `0x00001030` | RULE-DECLARE | Edge | 8 | [0x103L-rule-declare.md](toulmin/0x103L-rule-declare.md) |  |
| `0x104L` | `0x00001040` | COUNTER-DECLARE | Edge | 8 | [0x104L-counter-declare.md](toulmin/0x104L-counter-declare.md) |  |
| `0x105L` | `0x00001050` | EXCEPT-DECLARE | Edge | 8 | [0x105L-except-declare.md](toulmin/0x105L-except-declare.md) |  |
| `0x108L` | `0x00001080` | ATTACKS | Edge | 8 | [0x108L-attacks.md](toulmin/0x108L-attacks.md) |  |
| `0x109L` | `0x00001090` | SUPERSEDES | Edge | 8 | [0x109L-supersedes.md](toulmin/0x109L-supersedes.md) |  |
| `0x10AL` | `0x000010A0` | SUPERSEDE-CHAIN | Edge | 8 | [0x10AL-supersede-chain.md](toulmin/0x10AL-supersede-chain.md) |  |
| `0x110L` | `0x00001100` | RUN | Edge | 8 | [0x110L-run.md](toulmin/0x110L-run.md) |  |
| `0x111L` | `0x00001110` | DO | Edge | 8 | [0x111L-do.md](toulmin/0x111L-do.md) |  |
| `0x112L` | `0x00001120` | DO-ONCE | Edge | 8 | [0x112L-do-once.md](toulmin/0x112L-do-once.md) |  |
| `0x113L` | `0x00001130` | UNDO | Edge | 8 | [0x113L-undo.md](toulmin/0x113L-undo.md) |  |
| `0x114L` | `0x00001140` | CHECKING | Edge | 8 | [0x114L-checking.md](toulmin/0x114L-checking.md) |  |
| `0x115L` | `0x00001150` | ENTRY | Edge | 8 | [0x115L-entry.md](toulmin/0x115L-entry.md) |  |
| `0x116L` | `0x00001160` | TRIGGER | Edge | 8 | [0x116L-trigger.md](toulmin/0x116L-trigger.md) |  |
| `0x118L` | `0x00001180` | VERDICT | Edge | 8 | [0x118L-verdict.md](toulmin/0x118L-verdict.md) |  |
| `0x119L` | `0x00001190` | EVIDENCE | Edge | 8 | [0x119L-evidence.md](toulmin/0x119L-evidence.md) |  |
| `0x120L` | `0x00001200` | SOURCE | Edge | 9 | [0x120L-source.md](toulmin/0x120L-source.md) |  |
| `0x121L` | `0x00001210` | TEXT | Edge | 9 | [0x121L-text.md](toulmin/0x121L-text.md) |  |
| `0x122L` | `0x00001220` | SECTION | Edge | 9 | [0x122L-section.md](toulmin/0x122L-section.md) |  |
| `0x123L` | `0x00001230` | CASE-BEGIN | Edge | 9 | [0x123L-case-begin.md](toulmin/0x123L-case-begin.md) |  |
| `0x124L` | `0x00001240` | CASE-END | Edge | 9 | [0x124L-case-end.md](toulmin/0x124L-case-end.md) |  |
| `0x125L` | `0x00001250` | PROSE | Edge | 9 | [0x125L-prose.md](toulmin/0x125L-prose.md) |  |
| `0x126L` | `0x00001260` | NAMESPACE | Edge | 9 | [0x126L-namespace.md](toulmin/0x126L-namespace.md) |  |
| `0x127L` | `0x00001270` | FUNC | Edge | 9 | [0x127L-func.md](toulmin/0x127L-func.md) |  |
| `0x128L` | `0x00001280` | FIELD | Edge | 9 | [0x128L-field.md](toulmin/0x128L-field.md) |  |
| `0x129L` | `0x00001290` | ALIAS | Edge | 9 | [0x129L-alias.md](toulmin/0x129L-alias.md) |  |
| `0x12AL` | `0x000012A0` | GROUP | Edge | 9 | [0x12AL-group.md](toulmin/0x12AL-group.md) |  |
| `0x12BL` | `0x000012B0` | REQUIRES | Edge | 9 | [0x12BL-requires.md](toulmin/0x12BL-requires.md) |  |
| `0x12CL` | `0x000012C0` | MEANS | Edge | 9 | [0x12CL-means.md](toulmin/0x12CL-means.md) |  |
| `0x12DL` | `0x000012D0` | HAS | Edge | 9 | [0x12DL-has.md](toulmin/0x12DL-has.md) |  |
| `0x12EL` | `0x000012E0` | RUNS | Edge | 9 | [0x12EL-runs.md](toulmin/0x12EL-runs.md) |  |
| `0x12FL` | `0x000012F0` | EVALUATES | Edge | 9 | [0x12FL-evaluates.md](toulmin/0x12FL-evaluates.md) |  |
| `0x130L` | `0x00001300` | TRIGGERS | Edge | 9 | [0x130L-triggers.md](toulmin/0x130L-triggers.md) |  |
| `0x131L` | `0x00001310` | UNTIL | Edge | 9 | [0x131L-until.md](toulmin/0x131L-until.md) |  |
| `0x132L` | `0x00001320` | SAME-AS | Edge | 9 | [0x132L-same-as.md](toulmin/0x132L-same-as.md) |  |
| `0x133L` | `0x00001330` | IMPORTED-FROM | Edge | 9 | [0x133L-imported-from.md](toulmin/0x133L-imported-from.md) |  |
| `0x134L` | `0x00001340` | LABEL | Edge | 9 | [0x134L-label.md](toulmin/0x134L-label.md) |  |
| `0x1BDL` | `0x00001BD0` | EDGE-ISSUER-2WORD | Edge | 13 | [0x1BDL-edge-issuer-2word.md](edge/0x1BDL-edge-issuer-2word.md) |  |
| `0x1BEL` | `0x00001BE0` | EDGE-ISSUER-4WORD | Edge | 13 | [0x1BEL-edge-issuer-4word.md](edge/0x1BEL-edge-issuer-4word.md) |  |
| `0x1BFL` | `0x00001BF0` | EDGE-ISSUER-16WORD | Edge | 13 | [0x1BFL-edge-issuer-16word.md](edge/0x1BFL-edge-issuer-16word.md) |  |
| `0x1C0L` | `0x00001C00` | DOC-1WORD | Meta | 14 | [0x1C0L-doc-1word.md](meta/0x1C0L-doc-1word.md) |  |
| `0x1C1L` | `0x00001C10` | DOC-2WORD | Meta | 14 | [0x1C1L-doc-2word.md](meta/0x1C1L-doc-2word.md) |  |
| `0x1C2L` | `0x00001C20` | DOC-4WORD | Meta | 14 | [0x1C2L-doc-4word.md](meta/0x1C2L-doc-4word.md) |  |
| `0x1C3L` | `0x00001C30` | BODY | Meta | 14 | [0x1C3L-body.md](meta/0x1C3L-body.md) |  |
| `0x1C4L` | `0x00001C40` | END | Meta | 14 | [0x1C4L-end.md](meta/0x1C4L-end.md) |  |
| `0x1C5L` | `0x00001C50` | SPEC-VERSION | Meta | 14 | [0x1C5L-spec-version.md](meta/0x1C5L-spec-version.md) |  |
| `0x1C6L` | `0x00001C60` | PROFILE | Meta | 14 | [0x1C6L-profile.md](meta/0x1C6L-profile.md) |  |
| `0x1C7L` | `0x00001C70` | DOC-ID | Meta | 14 | [0x1C7L-doc-id.md](meta/0x1C7L-doc-id.md) |  |
| `0x1C8L` | `0x00001C80` | EFFECTIVE-FROM | Meta | 14 | [0x1C8L-effective-from.md](meta/0x1C8L-effective-from.md) |  |
| `0x1C9L` | `0x00001C90` | EFFECTIVE-UNTIL | Meta | 14 | [0x1C9L-effective-until.md](meta/0x1C9L-effective-until.md) |  |
| `0x1CAL` | `0x00001CA0` | DEFAULT-LANGUAGE | Meta | 14 | [0x1CAL-default-language.md](meta/0x1CAL-default-language.md) |  |
| `0x1CBL` | `0x00001CB0` | AUTHOR | Meta | 14 | [0x1CBL-author.md](meta/0x1CBL-author.md) |  |
| `0x1CCL` | `0x00001CC0` | CO-AUTHOR | Meta | 14 | [0x1CCL-co-author.md](meta/0x1CCL-co-author.md) |  |
| `0x1CDL` | `0x00001CD0` | CREATED-AT | Meta | 14 | [0x1CDL-created-at.md](meta/0x1CDL-created-at.md) |  |
| `0x1CEL` | `0x00001CE0` | MODIFIED-AT | Meta | 14 | [0x1CEL-modified-at.md](meta/0x1CEL-modified-at.md) |  |
| `0x1CFL` | `0x00001CF0` | RECORDED-BY | Meta | 14 | [0x1CFL-recorded-by.md](meta/0x1CFL-recorded-by.md) |  |
| `0x1D0L` | `0x00001D00` | RECORDED-AT | Meta | 14 | [0x1D0L-recorded-at.md](meta/0x1D0L-recorded-at.md) |  |
| `0x1D1L` | `0x00001D10` | PARENT | Meta | 14 | [0x1D1L-parent.md](meta/0x1D1L-parent.md) |  |
| `0x1D2L` | `0x00001D20` | DERIVED-FROM | Meta | 14 | [0x1D2L-derived-from.md](meta/0x1D2L-derived-from.md) |  |
| `0x1D3L` | `0x00001D30` | GENERATED-BY | Meta | 14 | [0x1D3L-generated-by.md](meta/0x1D3L-generated-by.md) |  |
| `0x1D4L` | `0x00001D40` | TRANSFORMED-BY | Meta | 14 | [0x1D4L-transformed-by.md](meta/0x1D4L-transformed-by.md) |  |
| `0x1D5L` | `0x00001D50` | CHERRY-PICKED-FROM | Meta | 14 | [0x1D5L-cherry-picked-from.md](meta/0x1D5L-cherry-picked-from.md) |  |
| `0x1D6L` | `0x00001D60` | REVERTS | Meta | 14 | [0x1D6L-reverts.md](meta/0x1D6L-reverts.md) |  |
| `0x1D7L` | `0x00001D70` | REPLACES | Meta | 14 | [0x1D7L-replaces.md](meta/0x1D7L-replaces.md) |  |
| `0x1D8L` | `0x00001D80` | SQUASHED-FROM | Meta | 14 | [0x1D8L-squashed-from.md](meta/0x1D8L-squashed-from.md) |  |
| `0x1D9L` | `0x00001D90` | MESSAGE | Meta | 14 | [0x1D9L-message.md](meta/0x1D9L-message.md) |  |
| `0x1DAL` | `0x00001DA0` | TAG | Meta | 14 | [0x1DAL-tag.md](meta/0x1DAL-tag.md) |  |
| `0x1DBL` | `0x00001DB0` | DELTA-BASE | Meta | 14 | [0x1DBL-delta-base.md](meta/0x1DBL-delta-base.md) |  |
| `0x1DCL` | `0x00001DC0` | DELTA-REMOVE | Meta | 14 | [0x1DCL-delta-remove.md](meta/0x1DCL-delta-remove.md) |  |
| `0x1DDL` | `0x00001DD0` | NEXT-LOCAL-ID | Meta | 14 | [0x1DDL-next-local-id.md](meta/0x1DDL-next-local-id.md) |  |
| `0x1DEL` | `0x00001DE0` | LICENSE | Meta | 14 | [0x1DEL-license.md](meta/0x1DEL-license.md) |  |
| `0x1DFL` | `0x00001DF0` | ACCESS | Meta | 14 | [0x1DFL-access.md](meta/0x1DFL-access.md) |  |
| `0x1E0L` | `0x00001E00` | PRIVACY | Meta | 15 | [0x1E0L-privacy.md](meta/0x1E0L-privacy.md) |  |
| `0x1E1L` | `0x00001E10` | RETENTION | Meta | 15 | [0x1E1L-retention.md](meta/0x1E1L-retention.md) |  |
| `0x1E2L` | `0x00001E20` | CONSENT | Meta | 15 | [0x1E2L-consent.md](meta/0x1E2L-consent.md) |  |
| `0x1E3L` | `0x00001E30` | USAGE | Meta | 15 | [0x1E3L-usage.md](meta/0x1E3L-usage.md) |  |
| `0x1E4L` | `0x00001E40` | IMPORT-DOC | Meta | 15 | [0x1E4L-import-doc.md](meta/0x1E4L-import-doc.md) |  |
| `0x1E5L` | `0x00001E50` | ISSUER-KEY | Meta | 15 | [0x1E5L-issuer-key.md](meta/0x1E5L-issuer-key.md) |  |
| `0x1E6L` | `0x00001E60` | SIGNATURE | Meta | 15 | [0x1E6L-signature.md](meta/0x1E6L-signature.md) |  |
| `0x1E7L` | `0x00001E70` | SIGNED-OFF | Meta | 15 | [0x1E7L-signed-off.md](meta/0x1E7L-signed-off.md) |  |
| `0x1E8L` | `0x00001E80` | CONFIDENCE | Meta | 15 | [0x1E8L-confidence.md](meta/0x1E8L-confidence.md) |  |
| `0x1E9L` | `0x00001E90` | VERDICT | Meta | 15 | [0x1E9L-verdict.md](meta/0x1E9L-verdict.md) |  |
