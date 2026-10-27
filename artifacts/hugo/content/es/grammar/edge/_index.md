---
title: "Edge"
weight: 60
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "Un Edge es un registro que enlaza Reference, Value y otros Edge para formular una afirmación. Su primer componente es siempre el Edge Id, y los 2 bits superiores del Codec son la familia (afirmación, fundamento, ejecución, TOULMIN)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Un Edge es un registro que enlaza otros registros como componentes para formular una afirmación. Afirmaciones como "Q42 es una persona" o "El nombre en inglés de Q42 es Douglas Adams" son cada una un Edge.

## Layout

```
TAG WORD          0001 0LLL LCCC CCCC
[TAG de extensión de Length]
[TAG de extensión de Codec]  si es formato Issuer
Edge Id           registro Reference LOCAL
componentes       en el orden que fija el Codec
```

- `LLLL` es el número total de WORD, incluido el TAG WORD, menos 1. Sin conocer el Codec, el decodificador salta al siguiente registro usando solo Length.
- **El primer componente es siempre el Edge Id (Reference LOCAL).** Al ser un Reference LOCAL (`0088` + ID, Quantifier `000`), el Edge Id se puede leer sin conocer el Codec.
- Cada componente encuentra sus límites con su propio Length. La posición a la que se llega tras leer el último componente debe coincidir exactamente con el final del Edge.
- La composición (Payload) de los componentes la fija el documento de cada Codec de Edge.
- En los Codec con subformato (WORLD, TIMELINE, SCENE), 1 WORD de TAG propio del Codec indica el subformato.
- El orden entre registros Edge no tiene significado (salvo que el Codec lo fije aparte; ejemplo: los documentos [TOULMIN](/es/grammar/edge/toulmin/)).
- Los demás Edge se señalan por su Edge Id. Los Edge de este documento, con LOCAL; los de otros documentos, con un Reference que apunta (`EXTERNAL-POINTER-*`, `EXTERNAL-ISSUER-*`).

## Familias

| 2 bits superiores | Familia | Código directo | Qué hace |
|---|---|---|---|
| `00` | Afirmación | `0x00`~`0x1F` | Compone contenido sobre el mundo y los sucesos |
| `01` | Fundamento | `0x20`~`0x3F` | De dónde salió cada registro ([SOURCE](/es/grammar/edge/source/)) |
| `10` | Ejecución | `0x40`~`0x5F` | Estructura de programa ejecutable (AST) |
| `11` | [TOULMIN](/es/grammar/edge/toulmin/) | `0x60`~`0x7B` | Grafo de argumentación: aserción, refutación, excepción, relaciones de ataque, ejecución, resultado del juicio |

## Edge de afirmación

| Codec | Nombre | Componentes |
|---|---|---|
| `0x00` | [REFERENCE-NODE](/es/grammar/edge/reference-node/) | Vínculo dirigido: el Subject (Reference) designa un Object |
| `0x01` | [SAME-NODE](/es/grammar/edge/same-node/) | Dos Reference designan el mismo objeto |
| `0x02` | [DIFFERENT-NODE](/es/grammar/edge/different-node/) | Dos Reference designan objetos distintos |
| `0x03` | [BIND](/es/grammar/edge/bind/) | Vincula al Subject un nombre para máquinas (UTF8-TEXT) |
| `0x04` | [LABEL](/es/grammar/edge/label/) | Nombre del Subject por idioma (UTF8-LANGUAGE-TEXT) |
| `0x05` | [ALIAS](/es/grammar/edge/alias/) | Otro nombre del Subject. El layout es el mismo que el de LABEL |
| `0x06` | [DESCRIPTION](/es/grammar/edge/description/) | Descripción del Subject por idioma. El layout es el mismo que el de LABEL |
| `0x08`/`0x09` | VERB-SHORT / VERB | Afirmación verbal |
| `0x0A` | [TRIPLE](/es/grammar/edge/triple/) | Una proposición (Predicate, Subject, Object) y rank |
| `0x0B` | [QUALIFIER](/es/grammar/edge/qualifier/) | Una condición que acota la proposición de otro Edge |
| `0x10`~`0x12` | WORLD / TIMELINE / SCENE | Cosmovisión, orden de sucesos, estructura de escena |
| `0x18`~`0x1A` | [PUBLICATION](/es/grammar/edge/publication/) / DEPRECATION / TOMBSTONE | Publicación, recomendación de deprecación y eliminación de una versión de documento ([Direcciones de publicación y lista de versiones](/es/grammar/publishing/#lista-de-versiones)) |
| `0x1B`~`0x1E` | [DECLARE](/es/grammar/edge/declare/) / [FIELD](/es/grammar/edge/field/) / [ENUM](/es/grammar/edge/enum/) / [CODEC](/es/grammar/edge/codec/) | Vocabulario para escribir especificaciones de Codec ([Documento de especificación de Codec](/es/grammar/codec-spec/)) |

- La forma `-SHORT` y la forma general se colocan como pareja par/impar (VERB-SHORT `0x08` / VERB `0x09`). LABEL recibe el idioma como registro de idioma dentro del Object (UTF8-LANGUAGE-TEXT), así que usa solo `0x04`.
- PUBLICATION, DEPRECATION y TOMBSTONE los escribe el documento de la lista de versiones. Como la lista de versiones debe poder leerse sin libro de códigos, vienen incorporados en el decodificador (capa 0 de [Direcciones de publicación y lista de versiones](/es/grammar/publishing/#capas)).
- DECLARE, FIELD, ENUM y CODEC son el vocabulario para escribir especificaciones de Codec. Como los documentos de especificación deben poder leerse sin libro de códigos, su layout viene incorporado en el decodificador (capa 0). Los documentos de especificación de cada Codec escritos con ese vocabulario son documentos normales.

### TRIPLE

Detalles: [TRIPLE](/es/grammar/edge/triple/)

```
TAG WORD          0001 0LLL L000 1010
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
| `2` | deprecated | Valor que se juzgó erróneo u obsoleto pero se conserva como registro |

- Rank es igual al statement rank de Wikidata. Las fuentes que no asignan rank usan `0`.
- **El significado de un TRIPLE es la suma de todos los QUALIFIER que apuntan a su Edge Id.** Quien lee reúne los QUALIFIER antes de interpretar el TRIPLE.

Ejemplo: Q42 — P31 (instance of) — Q5 (persona), normal, Edge Id 2

```
148A  0088 0002  00A8 001F  00A0 002A  00A0 0005  0000
TAG   #2         P31        Q42        Q5         normal
```

### QUALIFIER

Detalles: [QUALIFIER](/es/grammar/edge/qualifier/)

```
TAG WORD          0001 0LLL L000 1011
[TAG de extensión de Length]
Edge Id           Reference LOCAL
Property          Reference
Target            Reference LOCAL (Edge Id del Edge que se acota)
Value             Reference o Value
```

- El QUALIFIER es parte de la proposición. No es una afirmación aparte sobre la proposición, sino que acota las condiciones en que la proposición es verdadera (momento de inicio y fin, ámbito de aplicación, etc.).
- Las afirmaciones aparte sobre la proposición (quién la afirmó, etc.) se escriben con un TRIPLE.
- El Target es un Edge del mismo documento. El orden de los QUALIFIER con el mismo Target es su orden dentro del documento.

Ejemplo: Q42 — P69 (educated at) — Q691283, inicio (P580) 1971

```
150A 0088 0003 00A8 0045 00A0 002A 0120 000A 8C53 0000   TRIPLE    #3 P69 Q42 Q691283 normal
148B 0088 0004 00A8 0244 0088 0003 0924 3139 3731        QUALIFIER #4 P580 #3 EDTF "1971"
```

### LABEL, ALIAS, DESCRIPTION

Detalles: [LABEL](/es/grammar/edge/label/), [ALIAS](/es/grammar/edge/alias/), [DESCRIPTION](/es/grammar/edge/description/)

```
TAG WORD          0001 0LLL L000 0100   (LABEL)
[TAG de extensión de Length]
Edge Id           Reference LOCAL
Subject           Reference
Object            UTF8-LANGUAGE-TEXT
```

- El nombre y el idioma van juntos en un único Object (UTF8-LANGUAGE-TEXT).
- Para un mismo Subject e idioma hay, como máximo, un LABEL. Los otros nombres se escriben con ALIAS.
- Los nombres para máquinas, sin idioma, se escriben con BIND. LABEL debe tener idioma.

### BIND

Detalles: [BIND](/es/grammar/edge/bind/)

- Vincula al Subject un nombre con el que la máquina hace coincidir (UTF8-TEXT). No tiene idioma y no se normaliza. Dos nombres son iguales solo si sus bytes son iguales.
- El ámbito del nombre es el documento que contiene el BIND. En un mismo documento no se vincula el mismo nombre a Subject distintos.
- Los demás registros apuntan por LOCAL ID, no por nombre. El nombre sirve para coincidir con el exterior (funciones del host, entrada de direcciones, personas).

### SAME-NODE, DIFFERENT-NODE, REFERENCE-NODE

Detalles: [SAME-NODE](/es/grammar/edge/same-node/), [DIFFERENT-NODE](/es/grammar/edge/different-node/), [REFERENCE-NODE](/es/grammar/edge/reference-node/)

- SAME-NODE es la identidad: dos Reference apuntan al mismo objeto. Es reflexiva, simétrica y transitiva.
- DIFFERENT-NODE es la no identidad: dos Reference son objetos distintos.
- REFERENCE-NODE es un vínculo dirigido que define con un Object qué es el Subject (Reference). No es una afirmación de identidad. Ejemplo: define el URI al que apunta un nodo LOCAL.

## Edge de fundamento

Adjunta un fundamento a cada registro del BODY o al documento entero (HEAD). El único código directo de la familia de fundamento es [SOURCE](/es/grammar/edge/source/) (`0x20`).

| Codec | Nombre | Componentes |
|---|---|---|
| `0x20` | [SOURCE](/es/grammar/edge/source/) | Target (Edge Id del Edge del BODY al que se adjunta el fundamento; en el HEAD, `0` = documento entero), Origin (Reference del origen, ABSENT o UNKNOWN-VALUE) |
| `0x21`~`0x3F` | Reserved | |

- La naturaleza del propio origen (URL, título, autor, fecha de publicación …) se escribe con un TRIPLE que tiene el origen como Subject, y la naturaleza de la cita (fecha de consulta, ubicación dentro del origen …) con un QUALIFIER que tiene como Target el Edge Id del SOURCE.
- La fuente del documento entero se escribe en el HEAD con un SOURCE de Target `0`, y los QUALIFIER que lo tienen como Target también van en el HEAD. Estos son los únicos Edge que pueden ir en el HEAD, y el Edge Id usa un solo espacio de numeración para HEAD y BODY ([Procedencia del documento entero](/es/grammar/edge/source/#procedencia-del-documento-entero)).
- Otros fundamentos (alcance en el texto original, agente productor, confiabilidad, periodo de vigencia por artículo, registros antiguos) se escriben con QUALIFIER, y la primera versión en que entró se calcula a partir del historial de versiones ([SOURCE](/es/grammar/edge/source/#expresión-de-otros-fundamentos)).
- El resultado del juicio por registro corresponde a TOULMIN `VERDICT`.

### SOURCE

Detalles: [SOURCE](/es/grammar/edge/source/)

```
TAG WORD          0001 0LLL L010 0000
[TAG de extensión de Length]
Edge Id           Reference LOCAL
Target            Reference LOCAL (Edge Id del Edge del BODY al que se adjunta el fundamento; en el HEAD, 0 = documento entero)
Origin            Reference o marcador de posición 0x0000 ABSENT · 0x0001 UNKNOWN-VALUE
```

Ejemplo: el origen del TRIPLE `#178` de Q42 P19 es la Encyclopaedia Britannica (Q5375741), con el identificador P1417 dentro de ella

```
SOURCE     #1347  #178   Q5375741
QUALIFIER  #1348  P1417  #1347  "biography/Douglas-Adams"
```

## Edge de ejecución

Estructura de programa no ligada a un lenguaje de programación concreto. Los componentes se señalan con LOCAL ID de este documento.

| Grupo | Codec |
|---|---|
| Declaración | FUNCTION-DECLARE, TYPE-DECLARE |
| Expresión | CONST, UNARY, BINARY, CALL, MEMBER, INDEX, CONSTRUCT, CONDITIONAL |
| Sentencia | BLOCK, ASSIGN, IF, SWITCH, WHILE, FOREACH, JUMP, RETURN |
| Error | RAISE, TRY |

- No es un formato que contenga tal cual código de un lenguaje externo. El código de un lenguaje externo se coloca como formato Issuer.
- Los componentes se señalan con LOCAL ID (REF) de este documento. En la posición de una expresión se coloca un Edge de expresión o un símbolo. REF `0` significa sin valor.
- Una expresión produce un valor y una sentencia no. Una expresión puede colocarse en la posición de sentencia de un BLOCK (el valor se descarta).
- El `for` al estilo C se escribe como BLOCK (inicialización, WHILE), y `else if` como un IF en la posición falsa.
- Un símbolo es un LOCAL ID y su nombre se vincula con BIND. Los demás registros apuntan a los símbolos por LOCAL ID, no por nombre. Aunque el nombre sea igual, si el LOCAL ID es distinto, es otro símbolo.
- Lo que es un símbolo (variable, parámetro, función, tipo) lo decide el registro que apunta a él. Un símbolo sin definición dentro del documento lo proporciona el exterior (el host); si es el destino de un CALL, es una función del host.

Problemas abiertos: códigos de operadores, representación de tipos, layout del Payload de cada Codec.

## Edge TOULMIN

Detalles: [TOULMIN](/es/grammar/edge/toulmin/)

Escribe grafos de juicio y ejecución con el modelo de argumentación de Toulmin. Es la familia central para que GEUL describa sus propias reglas en GEUL y se corrija a sí mismo.

| Grupo | Codec |
|---|---|
| Declaración | CASE-DECLARE (caso), [PREDICATE-DECLARE](/es/grammar/edge/toulmin/expr/) (predicado), SPEC-DECLARE (criterio de juicio), RULE-DECLARE (aserción), COUNTER-DECLARE (refutación), EXCEPT-DECLARE (excepción) — [NODE](/es/grammar/edge/toulmin/node/) |
| Relación | ATTACKS (ataque), SUPERSEDES (exclusión) — [LINK](/es/grammar/edge/toulmin/link/), SUPERSEDE-CHAIN (cadena de prioridad, layout sin decidir) |
| Ejecución | RUN, DO, DO-ONCE, UNDO, CHECKING — [LINK](/es/grammar/edge/toulmin/link/), ENTRY, TRIGGER — [NODE](/es/grammar/edge/toulmin/node/) |
| Resultado | VERDICT (resultado del juicio: Pass·Review·Fail), EVIDENCE (evidencia del juicio) — layout sin decidir |

- El texto original, las divisiones y los nodos y relaciones auxiliares son formatos ISSUER del Issuer GEUL (`0xC000`~`0xC029`) ([SOURCE y divisiones](/es/grammar/edge/toulmin/source/)).
- El resultado del juicio se coloca en un documento distinto del objeto juzgado. El documento de resultado importa y apunta al documento de destino. Por eso, juzgar no cambia el hash de contenido del documento de destino.

## Edge de formato Issuer

Un Issuer puede definir y usar sus propios formatos de Edge (Codec `0x7C`~`0x7F`). Los códigos directos `0x7C`~`0x7F` están dentro del rango TOULMIN pero son códigos ISSUER comunes, y la familia se decide por los 2 bits superiores del número de formato.

| Issuer | Número de formato | Nombre | Familia |
|---|---|---|---|
| `0x0000` GEUL | `0xC000`~`0xC005` | [SOURCE, TEXT, SECTION, CASE-BEGIN, CASE-END, PROSE](/es/grammar/edge/toulmin/source/) | TOULMIN |
| `0x0000` GEUL | `0xC010`~`0xC014` | [NAMESPACE, FUNC, FIELD, ALIAS, GROUP](/es/grammar/edge/toulmin/node/) | TOULMIN |
| `0x0000` GEUL | `0xC020`~`0xC029` | [REQUIRES … LABEL](/es/grammar/edge/toulmin/link/) | TOULMIN |
