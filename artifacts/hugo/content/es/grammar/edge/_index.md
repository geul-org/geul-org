---
title: "Edge"
weight: 120
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "Un Edge es un registro que enuncia algo uniendo otros registros como componentes."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Un Edge es un registro que enuncia algo uniendo otros registros como componentes. Enunciados como «Q42 es una persona» o «El nombre en inglés de Q42 es Douglas Adams» son cada uno un único Edge.

## Layout {#레이아웃}

```
TAG WORD          000K KKKC CCCC LLLL      secciones 5~13 (0x0A0L~0x1BFL)
[TAG de extensión de Length]
[TAG de extensión de Codec]  en formato Issuer
Edge Id           Reference LOCAL
componentes       en el orden que fija el Codec
```

- `LLLL` es el número total de WORD, incluido el TAG WORD, menos 1. El decodificador salta al siguiente registro solo con Length, sin conocer el Codec.
- **El primer componente es siempre el Edge Id (Reference LOCAL).** Como es una Reference LOCAL (`0051` + ID, Identified `0x005L`), el Edge Id se puede leer sin conocer el codec.
- Cada componente encuentra su propio límite con su propio Length. La posición donde termina la lectura del último componente debe coincidir exactamente con el final del Edge.
- La composición (Payload) de los componentes la fija el documento de cada Codec de Edge.
- Los Codec con subformatos (WORLD, TIMELINE, SCENE) especifican el subformato con 1 TAG WORD propio de cada Codec.
- El orden entre registros Edge no tiene significado (salvo que el Codec lo fije aparte; por ejemplo, el documento [TOULMIN](../toulmin/_index.md)).
- Los demás Edge se señalan por su Edge Id. Los Edge de este documento se señalan como LOCAL, y los de otros documentos con una Reference de señalamiento (`EXTERNAL-POINTER-*`, `EXTERNAL-ISSUER-*`).

## Familias {#계열}

La zona de Edge es `0x0A0L~0x1BFL`. La familia de un código directo es `(código − 0xA0) >> 5` (el código son los tres primeros dígitos del TAG ID). Las familias son de 32 casillas y coinciden con `w >> 9` de la sección menos 5. Edge ocupa las secciones 5~13.

| Sección | Familia | Código directo | Qué hace |
|---|---|---|---|
| 5 | enunciado | `0x0A0L~0x0BFL` | Compone contenido sobre el mundo y los sucesos |
| 6 | fundamento | `0x0C0L~0x0DFL` | De dónde proceden los registros y los documentos ([SOURCE](0x0C0L-source.md)) |
| 7 | ejecución | `0x0E0L~0x0FFL` | Estructura de programa ejecutable (AST) |
| 8 | [TOULMIN](../toulmin/_index.md) | `0x100L~0x11BL` | Grafo de argumentación: afirmaciones, refutaciones, excepciones, relaciones de ataque, ejecución, resultados de veredicto |
| 9 | formato [TOULMIN](../toulmin/_index.md) | `0x120L~0x134L` | Texto original, particiones, nodos auxiliares y relaciones de un documento TOULMIN |

- Los códigos directos asignados son estas cinco familias. `0x11CL~0x11FL` es Reserved, y `0x135L~0x1BCL` es Reserved (las secciones 10~12 son Reserved enteras).
- `0x1BDL~0x1BFL` (las tres últimas casillas de la sección 13) son EDGE-ISSUER (véase Edge de formato Issuer más abajo). El formato Issuer no tiene regla de familia.

## Edge de enunciado {#서술-edge}

| Codec | Nombre | Componentes |
|---|---|---|
| `0x0A0L` | [REFERENCE-NODE](0x0A0L-reference-node.md) | Vínculo direccional: Subject (Reference) señala a Object |
| `0x0A1L` | [SAME-NODE](0x0A1L-same-node.md) | Dos Reference señalan el mismo objeto |
| `0x0A2L` | [DIFFERENT-NODE](0x0A2L-different-node.md) | Dos Reference señalan objetos distintos |
| `0x0A3L` | [BIND](0x0A3L-bind.md) | Liga a Subject un nombre para máquinas (UTF8-TEXT) |
| `0x0A4L` | [LABEL](0x0A4L-label.md) | Nombre de Subject por idioma (UTF8-LANGUAGE-TEXT) |
| `0x0A5L` | [ALIAS](0x0A5L-alias.md) | Otro nombre de Subject. El layout es igual que el de LABEL |
| `0x0A6L` | [DESCRIPTION](0x0A6L-description.md) | Descripción de Subject por idioma. El layout es igual que el de LABEL |
| `0x0A8L`/`0x0A9L` | [VERB-SHORT](0x0A8L-verb-short.md) / [VERB](0x0A9L-verb.md) | Enunciado verbal |
| `0x0AAL` | [TRIPLE](0x0AAL-triple.md) | Una proposición (Predicate, Subject, Object) y rank |
| `0x0ABL` | [QUALIFIER](0x0ABL-qualifier.md) | Una condición que califica la proposición de otro Edge |
| `0x0B0L~0x0B2L` | [WORLD](0x0B0L-world.md) / [TIMELINE](0x0B1L-timeline.md) / [SCENE](0x0B2L-scene.md) | Cosmovisión, orden de sucesos, estructura de escena |
| `0x0B8L~0x0BAL` | [PUBLICATION](0x0B8L-publication.md) / [DEPRECATION](0x0B9L-deprecation.md) / [TOMBSTONE](0x0BAL-tombstone.md) | Publicación, recomendación de desuso y eliminación de versiones de documento ([dirección de publicación y lista de versiones](../publishing.md#버전-목록)) |
| `0x0BBL~0x0BEL` | [DECLARE](0x0BBL-declare.md) / [FIELD](0x0BCL-field.md) / [ENUM](0x0BDL-enum.md) / [CODEC](0x0BEL-codec.md) | Vocabulario para escribir especificaciones de Codec ([documento de especificación de Codec](../codec-spec.md)) |

- `-SHORT` y la forma general se colocan como pareja par/impar (VERB-SHORT `0x0A8L`/VERB `0x0A9L`). LABEL recibe el idioma como registro de idioma dentro de Object (UTF8-LANGUAGE-TEXT), por lo que solo usa `0x0A4L`.
- PUBLICATION, DEPRECATION y TOMBSTONE los usa el documento de lista de versiones. Como la lista de versiones debe poder leerse sin libro de codecs, se integran en el decodificador ([dirección de publicación y lista de versiones](../publishing.md#층), capa 0).
- DECLARE, FIELD, ENUM y CODEC son el vocabulario para escribir especificaciones de Codec. Como el documento de especificación debe poder leerse sin libro de codecs, su layout se integra en el decodificador (capa 0). Cada documento de especificación de Codec escrito con ese vocabulario es un documento ordinario.

### TRIPLE {#triple}

Detalles: [TRIPLE](0x0AAL-triple.md)

```
TAG WORD          0000 1010 1010 LLLL
[TAG de extensión de Length]
Edge Id           Reference LOCAL
Predicate         Reference (propiedad de Wikidata, etc.)
Subject           Reference
Object            Reference o Value
Rank              1 WORD
```

| Rank | Nombre | Significado |
|---|---|---|
| `0` | normal | Por defecto |
| `1` | preferred | Valor actual, el más autorizado |
| `2` | deprecated | Valor juzgado erróneo u obsoleto pero conservado como registro |

- Rank es igual que el statement rank de Wikidata. Las fuentes que no asignan rank usan `0`.
- **El significado de un TRIPLE es todo lo reunido por los QUALIFIER que señalan su Edge Id.** Quien lee reúne los QUALIFIER antes de interpretar el TRIPLE.

Ejemplo: Q42 — P31 (instance of) — Q5 (persona), normal, Edge Id 2

```
0AA9  0051 0002  0191 001F  0141 002A  0141 0005  0000
TAG   #2         P31        Q42        Q5         normal
```

### QUALIFIER {#qualifier}

Detalles: [QUALIFIER](0x0ABL-qualifier.md)

```
TAG WORD          0000 1010 1011 LLLL
[TAG de extensión de Length]
Edge Id           Reference LOCAL
Property          Reference
Target            Reference LOCAL (Edge Id del Edge que se califica)
Value             Reference o Value
```

- QUALIFIER es parte de la proposición. No es una afirmación aparte sobre la proposición, sino que califica las condiciones en que la proposición es verdadera (momento de inicio y fin, ámbito de aplicación, etc.).
- Una afirmación aparte sobre la proposición (quién la afirmó, etc.) se escribe como TRIPLE.
- Target es un Edge del mismo documento. El orden de los QUALIFIER con el mismo Target es el orden dentro del documento.

Ejemplo: Q42 — P69 (educated at) — Q691283, inicio (P580) 1971

```
0AAA 0051 0003 0191 0045 0141 002A 0142 000A 8C53 0000   TRIPLE    #3 P69 Q42 Q691283 normal
0AB9 0051 0004 0191 0244 0051 0003 06E2 3139 3731        QUALIFIER #4 P580 #3 EDTF "1971"
```

### LABEL, ALIAS, DESCRIPTION {#label-alias-description}

Detalles: [LABEL](0x0A4L-label.md), [ALIAS](0x0A5L-alias.md), [DESCRIPTION](0x0A6L-description.md)

```
TAG WORD          0000 1010 0100 LLLL   (LABEL)
[TAG de extensión de Length]
Edge Id           Reference LOCAL
Subject           Reference
Object            UTF8-LANGUAGE-TEXT
```

- El nombre y el idioma van juntos en un solo Object (UTF8-LANGUAGE-TEXT).
- Para el mismo Subject e idioma hay como máximo un LABEL. Los otros nombres se escriben como ALIAS.
- Un nombre para máquinas sin idioma se escribe como BIND. LABEL debe tener idioma.

### BIND {#bind}

Detalles: [BIND](0x0A3L-bind.md)

- Liga a Subject un nombre (UTF8-TEXT) con el que casa la máquina. No tiene idioma y no se normaliza. Los nombres son iguales solo si los bytes son iguales.
- El ámbito del nombre es el documento que contiene el BIND. En un documento no se liga el mismo nombre a Subject distintos.
- Los demás registros se señalan por LOCAL ID, no por nombre. El nombre sirve para casar con el exterior (funciones del host, entrada de direcciones, personas).

### SAME-NODE, DIFFERENT-NODE, REFERENCE-NODE {#same-node-different-node-reference-node}

Detalles: [SAME-NODE](0x0A1L-same-node.md), [DIFFERENT-NODE](0x0A2L-different-node.md), [REFERENCE-NODE](0x0A0L-reference-node.md)

- SAME-NODE es la identidad: dos Reference señalan el mismo objeto. Es reflexiva, simétrica y transitiva.
- DIFFERENT-NODE es la no identidad: dos Reference son objetos distintos.
- REFERENCE-NODE es un vínculo direccional que define con Object qué es Subject (Reference). No es una afirmación de identidad. Ejemplo: define el URI al que señala un nodo LOCAL.

## Edge de fundamento {#근거-edge}

Añade fundamento a un registro individual dentro de BODY, o a todo el documento (HEAD). La familia de fundamento tiene un solo código directo: [SOURCE](0x0C0L-source.md) (`0x0C0L`).

| Codec | Nombre | Componentes |
|---|---|---|
| `0x0C0L` | [SOURCE](0x0C0L-source.md) | Target (Edge Id del Edge de BODY al que se añade fundamento; en HEAD, `0` = todo el documento), Origin (Reference de origen, ABSENT o UNKNOWN-VALUE) |
| `0x0C1L~0x0DFL` | Reserved | |

- Las propiedades del origen mismo (URL, título, autor, fecha de publicación …) se escriben como TRIPLE con el origen como Subject, y las propiedades de la cita (fecha de consulta, ubicación dentro del origen …) como QUALIFIER con el Edge Id de SOURCE como Target.
- El origen de todo el documento se escribe en HEAD como SOURCE con Target `0`, y el QUALIFIER que lo tiene como Target también va en HEAD. Estos dos son los únicos Edge que van en HEAD, y el Edge Id usa un solo espacio de numeración compartido entre HEAD y BODY ([procedencia de todo el documento](0x0C0L-source.md#문서-전체의-출처)).
- Otros fundamentos (rango del texto original, agente que lo hizo, confiabilidad, período de vigencia por artículo, registros antiguos) se escriben como QUALIFIER, y la versión en que entró por primera vez se calcula a partir del historial de versiones ([SOURCE](0x0C0L-source.md#다른-근거의-표현)).
- El resultado de veredicto por registro lo asume TOULMIN `VERDICT`.

### SOURCE {#source}

Detalles: [SOURCE](0x0C0L-source.md)

```
TAG WORD          0000 1100 0000 LLLL
[TAG de extensión de Length]
Edge Id           Reference LOCAL
Target            Reference LOCAL (Edge Id del Edge de BODY al que se añade fundamento; en HEAD, 0 = todo el documento)
Origin            Reference o marcador de posición 0x0000 ABSENT·0x0010 UNKNOWN-VALUE
```

Ejemplo: fuente del TRIPLE `#178` de Q42 P19, Britannica (Q5375741), y el identificador P1417 dentro de ella

```
SOURCE     #1347  #178   Q5375741
QUALIFIER  #1348  P1417  #1347  "biography/Douglas-Adams"
```

## Edge de ejecución {#실행-edge}

Estructura de programa no ligada a ningún lenguaje de programación concreto. Los componentes se señalan por el LOCAL ID de este documento.

| Grupo | Codec |
|---|---|
| declaración | [FUNCTION-DECLARE](0x0E1L-function-declare.md), [TYPE-DECLARE](0x0E2L-type-declare.md) |
| expresión | [CONST](0x0E8L-const.md), [UNARY](0x0E9L-unary.md), [BINARY](0x0EAL-binary.md), [CALL](0x0EBL-call.md), [MEMBER](0x0ECL-member.md), [INDEX](0x0EDL-index.md), [CONSTRUCT](0x0EEL-construct.md), [CONDITIONAL](0x0EFL-conditional.md) |
| sentencia | [BLOCK](0x0F0L-block.md), [ASSIGN](0x0F1L-assign.md), [IF](0x0F2L-if.md), [SWITCH](0x0F3L-switch.md), [WHILE](0x0F4L-while.md), [FOREACH](0x0F5L-foreach.md), [JUMP](0x0F6L-jump.md), [RETURN](0x0F7L-return.md) |
| error | [RAISE](0x0F8L-raise.md), [TRY](0x0F9L-try.md) |

- No es un formato que contenga tal cual código de un lenguaje externo. El código de un lenguaje externo se pone en formato Issuer.
- Los componentes se señalan por LOCAL ID (REF) de este documento. En el lugar de una expresión se pone un Edge de expresión o un símbolo. REF `0` significa ninguno.
- Una expresión produce un valor y una sentencia no. Una expresión puede ponerse en el lugar de sentencia de BLOCK (el valor se descarta).
- El `for` de estilo C se escribe como BLOCK (inicialización, WHILE), y `else if` como un IF en el lugar de falso.
- Un símbolo es un LOCAL ID y su nombre se liga con BIND. Los demás registros señalan el símbolo por LOCAL ID, no por nombre. Aunque el nombre sea igual, si el LOCAL ID es distinto, es otro símbolo.
- Qué es un símbolo (variable, parámetro, función, tipo) lo fija el registro que lo señala. Un símbolo sin definición en el documento lo proporciona el exterior (el host); si es el destino de un CALL, es una función del host.

Problemas abiertos: códigos de operador, representación de tipos, layout del Payload de cada Codec.

## Edge TOULMIN {#toulmin-edge}

Escribe grafos de veredicto y ejecución con el modelo de argumentación de Toulmin. Los códigos directos son `0x100L~0x11BL`, y los registros auxiliares son de la familia de formato TOULMIN `0x120L~0x134L`. Detalles: [TOULMIN](../toulmin/_index.md)

## Edge de formato Issuer {#issuer-형식-edge}

Un Issuer puede definir y usar su propio formato de Edge ([EDGE-ISSUER-2WORD](0x1BDL-edge-issuer-2word.md)·[4WORD](0x1BEL-edge-issuer-4word.md)·[16WORD](0x1BFL-edge-issuer-16word.md), Codec `0x1BDL`~`0x1BFL`). Son las tres últimas casillas de la zona de Edge. El TAG de extensión de Codec lleva 2 WORD con el Issuer y el número de Codec. El Edge Id es el primer elemento del Payload posterior (TAG, Issuer, número de Codec, Edge Id, resto del Payload). El número de Codec lo fija el Issuer y no tiene regla de familia. Sin importar el Kind, no se repite dentro de los `codecs/` de ese Issuer. El documento del codec se coloca bajo los `codecs/` de ese Issuer con el número de Codec del registro ([dirección de publicación y lista de versiones](../publishing.md)).

- Por ahora no hay ningún formato Edge ISSUER registrado.
