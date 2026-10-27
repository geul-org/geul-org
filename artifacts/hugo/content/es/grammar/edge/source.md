---
title: "SOURCE"
weight: 33
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "SOURCE es un Edge de fundamento que enlaza un registro, o el documento entero, con su fuente (Codec 0x20). Las propiedades de la fuente se escriben con un TRIPLE que tiene la fuente como Subject, y las de la cita (fecha de consulta, posición dentro de la fuente, hash del texto original) con los QUALIFIER añadidos a SOURCE. El SOURCE del documento entero va en el HEAD."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SOURCE es un Edge de fundamento que enlaza un registro (el destino) o el documento entero con la fuente de la que procede. Codec `0x20`. Es el único código directo de la familia de fundamento (`01`).

Una reference (conjunto de procedencia) de Wikidata es un SOURCE. Si un registro tiene varias procedencias, hay varios SOURCE.

## Layout

```
TAG WORD          0001 0LLL L010 0000
[TAG de extensión de Length]
Edge Id           registro Reference LOCAL
Target            registro Reference LOCAL (en el BODY, el Edge Id del Edge al que se añade el fundamento; en el HEAD, 0 = documento entero)
Origin            registro Reference, o marcador de posición 0x0000 ABSENT · 0x0001 UNKNOWN-VALUE
```

- Origin señala la fuente. Si hay un Reference adecuado para la fuente, ese (WIKIDATA-QID, DOC-POINTER o EXTERNAL-ISSUER de un documento GEUL, etc.); si no, un nodo LOCAL de este documento.
- Si la procedencia no describe la fuente (por ejemplo, una procedencia que solo tiene "imported from" (P143) de Wikidata o la fecha de consulta), Origin es [ABSENT](/es/grammar/reference/slot-marker/) (no escrito). Quien escribe simplemente no anotó la fuente, y no afirma nada sobre ella. El resto de la procedencia queda tal cual en los QUALIFIER.
- [UNKNOWN-VALUE](/es/grammar/reference/slot-marker/) se usa solo cuando quien escribe afirma que "hay una fuente pero no sé cuál" (un registro escrito por una persona, etc.). Un conversor que traslada desde un material de origen no afirma lo que el origen no dice, así que usa ABSENT.
- Un Origin ABSENT o UNKNOWN-VALUE es independiente en cada aparición. No se lee que las fuentes de dos SOURCE sean la misma.

## Dos capas

La información sobre la procedencia se divide en dos. No se mezclan.

| Capa | Qué es | Cómo se escribe | Ejemplo |
|---|---|---|---|
| Fuente | Propiedades de la fuente en sí. Son las mismas, la cite quien la cite | [TRIPLE](/es/grammar/edge/triple/) con la fuente como Subject (rank normal) | URL (P854), título (P1476), autor (P50, P2093), fecha de publicación (P577), publicación en que aparece (P1433), editorial (P123), idioma (P407) |
| Cita | Propiedades del acto en que este registro cita la fuente | [QUALIFIER](/es/grammar/edge/qualifier/) con el Edge Id de SOURCE como Target | fecha de consulta (P813), posición dentro de la fuente (página P304, sección P958, identificadores externos P227, P1417), de dónde se importó (P143), método de inferencia (P887), hash del texto original (P4092) |

- **El significado de SOURCE es el conjunto de todos los QUALIFIER que apuntan a su Edge Id.** Dos procedencias que consultaron la misma fuente en días distintos tienen la misma fuente y distintos QUALIFIER.
- Un TRIPLE de fuente es una aserción sobre la fuente. Una propiedad cuya capa no se puede decidir se pone en el lado de la cita (QUALIFIER). Es más seguro no afirmar nada sobre la fuente.
- Dentro de un documento, una misma fuente se declara una sola vez con un LOCAL, y varios SOURCE apuntan a él.
- Una fuente descrita solo por una URL se define con [REFERENCE-NODE](/es/grammar/edge/reference-node/) (LOCAL → URI). Es como la página de documento de un sitelink.

## Interpretación y validez

- Target y Origin son cada uno exactamente un registro completo. El cursor tras leer Origin debe coincidir con el final del Edge.
- Target es un Reference LOCAL. El SOURCE del BODY apunta a un Edge Id del BODY del mismo documento. `0` (documento entero) solo lo usa un SOURCE del HEAD ([Procedencia del documento entero](#procedencia-del-documento-entero)). Si hay en el BODY un SOURCE con Target `0`, es invalid. A un registro de otro documento se le añade el fundamento dentro de ese documento.
- Origin es un Reference. De los marcadores de posición solo acepta `0x0000` (ABSENT) y `0x0001` (UNKNOWN-VALUE). No acepta NO-VALUE (`0x0002`) ni Value.
- El documento de especificación de geul.org `0x0000/0x0000000000001020` (nombre `source`) pone en Target el [CODEC](/es/grammar/edge/codec/) LOCAL (`0008`), y en Origin los CODEC `0780` (cualquier Reference), `0000` (ABSENT, opcional) y `0001` (UNKNOWN-VALUE).
- El orden entre los SOURCE de un mismo Target no tiene significado. Tampoco el orden de los elementos dentro de una procedencia (el orden de los valores de una misma propiedad se conserva como orden del documento).
- SOURCE no cambia la verdad o falsedad del destino. Solo anota de dónde viene. El resultado del juicio lo lleva [TOULMIN](/es/grammar/edge/toulmin/) `VERDICT`.

## Procedencia del documento entero

La fuente del documento entero (volcado original, edición, archivo de texto original) se escribe con **un SOURCE de Target `0` en el HEAD**. Los QUALIFIER que tienen ese SOURCE como Target (hash del texto original P4092, hora de recepción P813, rango del texto original, etc.) también van en el HEAD ([Documento](/es/grammar/document/#head-y-body)).

- Estos dos son los únicos Edge que pueden ir en el HEAD. Los demás Edge van en el BODY.
- Los QUALIFIER del HEAD van después del SOURCE del HEAD al que apuntan. El decodificador lee desde el principio y separa HEAD y BODY.
- Si un QUALIFIER que tiene como Target un SOURCE del HEAD se pone en el BODY, es invalid. Los SOURCE y QUALIFIER del BODY no apuntan a Edge del HEAD.
- **El Edge Id usa un solo espacio de numeración para HEAD y BODY.** Es único dentro del documento, se toma de [NEXT-LOCAL-ID](/es/grammar/meta/lineage/next-local-id/) como los demás Edge, y al regenerar, si el contenido es el mismo, se hereda el mismo número. Aunque una versión carezca de un Edge del HEAD, ese número no se reutiliza.
- Si Origin es un LOCAL, su definición (REFERENCE-NODE, TRIPLE de fuente) va en el BODY. El ámbito de LOCAL es el documento entero.
- Los Edge del HEAD no son Meta de clase de verificación, así que entran en el [hash de contenido](/es/grammar/document/#hash-de-contenido). En un diff cambian por completo junto con el HEAD (no se anotan en `DELTA-REMOVE`).
- No hay un Meta aparte para la procedencia del documento entero. El rango del texto original o la hora de adquisición escritos como Meta no permiten decidir a qué fuente se refieren cuando hay varias. Un QUALIFIER añadido a SOURCE lo decide mediante su Target.

Ejemplo: el HEAD de un documento de Q42 trasladado de un volcado de Wikidata (los Edge Id son solo ilustrativos).

```
SPEC-VERSION  0x0001
DOC-ID        0x00010000/0x510000000000002a
TRANSFORMED-BY …
#1738 SOURCE     #0     #1735                                         versión de la entidad (revision)
#1741 SOURCE     #0     #1740                                         archivo de volcado
#1742 QUALIFIER  P4092  #1741  SHA-256-DIGEST(0xa249…0774)            hash del archivo
#1743 QUALIFIER  P813   #1741  POSIX-TIMESTAMP-SECONDS(1792996483)    hora de recepción
BODY
#1736 TRIPLE     P577   #1735  POSIX-TIMESTAMP-SECONDS(1792210885) normal                      hora de guardado de la versión
#1737 TRIPLE     P854   #1735  <https://www.wikidata.org/w/index.php?oldid=2557857485> normal  dirección permanente de la versión
#1739 REFERENCE-NODE    #1740  <https://dumps.wikimedia.org/wikidatawiki/entities/20261019/wikidata-20261019-all.json.bz2>
…
```

- La versión y el volcado son fuentes distintas, así que hay dos SOURCE. La versión es la fuente del contenido (con la dirección permanente se puede volver a obtener el mismo contenido), y el volcado es el archivo del que se recibió esa versión. El hash del archivo y la hora de recepción son propiedades del lado de la cita sobre el archivo de volcado, por lo que se añaden al SOURCE del volcado.

## Expresión de otros fundamentos

En la familia de fundamento solo hay SOURCE. Los demás fundamentos se escriben con QUALIFIER.

| Fundamento | Cómo se escribe | Property |
|---|---|---|
| Rango dentro del texto original | QUALIFIER sobre SOURCE. Un SOURCE por rango | página P304, sección P958, cita textual P1683. El rango de caracteres es un término de GEUL (por definir) |
| Hora en que se recibió el material de origen | QUALIFIER sobre SOURCE | fecha de consulta P813 |
| Hash de bytes del texto original (fija la edición) | QUALIFIER sobre SOURCE | checksum P4092; el valor es [SHA-256-DIGEST](/es/grammar/value/binary/sha-256-digest/), etc. |
| Agente que lo produjo (persona, modelo, motor de reglas) | SOURCE (el agente que hizo la cita) o QUALIFIER sobre el destino | término de GEUL (por definir) |
| Confianza | QUALIFIER sobre el destino | término de GEUL (por definir); el valor es de 0 a 1 como el Meta [CONFIDENCE](/es/grammar/meta/verification/confidence/) |
| Periodo de vigencia por artículo | QUALIFIER sobre el destino | inicio P580, fin P582 |
| Registro antiguo antes de un traslado, división o fusión | QUALIFIER sobre el destino, con el valor del Edge Id antiguo (LOCAL) | P1365 (replaces) |
| Versión en que entró por primera vez | No se almacena. Se calcula a partir del historial de versiones (git blame) | |

## Ejemplo (no normativo)

Q42 P19 (lugar de nacimiento) Q350, TRIPLE destino `#178`. Cuatro procedencias del volcado de Wikidata del 2026-10-19.

```
SOURCE     #1347  #178   Q5375741                     ① Britannica: sin descripción de fuente, solo un P248
QUALIFIER  #1348  P1417  #1347  "biography/Douglas-Adams"

TRIPLE     #1350  P50    #1349  Q18145749  normal     ② artículo de The Guardian #1349
TRIPLE     #1351  P407   #1349  Q1860      normal
TRIPLE     #1352  P577   #1349  GREGORIAN-DATE(2001-05-15)  normal
TRIPLE     #1353  P854   #1349  <http://www.theguardian.com/news/2001/may/15/guardianobituaries.books>  normal
TRIPLE     #1354  P1433  #1349  Q5614018   normal
TRIPLE     #1355  P1476  #1349  "Obituary: Douglas Adams"@en  normal
SOURCE     #1356  #178   #1349
QUALIFIER  #1357  P813   #1356  GREGORIAN-DATE(2013-12-07)

SOURCE     #1368  #178   #1158                        ④ GND: LOCAL #1158 declarado antes (P248 Q36578, P407 Q188)
QUALIFIER  #1369  P227   #1368  "119033364"
QUALIFIER  #1370  P813   #1368  GREGORIAN-DATE(2022-10-09)
```

- ① no tiene descripción de fuente y tiene un solo P248, así que la fuente es ese elemento. `#1347` es TAG 1 + Edge Id 2 + Target 2 + Q5375741 3 = 8 WORD, TAG `13A0`.

```
13A0 0088 0543 0088 00B2 0120 0052 06FD
```

- Procedencia con una sola URL: `REFERENCE-NODE #1383 #1384 <http://www.eskimo.com/~rkj/weekly/aa051701a.htm>`, `SOURCE #1385 #180 #1384`.
- Procedencia que solo tiene "imported from" Wikipedia en inglés: `SOURCE #n #t ABSENT`, `QUALIFIER P143 #n Q328`. Origin `0x0000` ocupa 1 WORD.

## Problemas abiertos

- Los términos de GEUL (documento de definición de términos e ID) para expresar rango de caracteres, agente productor y confianza.
- Cuando la descripción de la fuente no identifica la fuente (una procedencia que solo tiene idioma, etc.), compartir esa misma descripción con un LOCAL llevaría a afirmar que fuentes distintas son la misma.
- Lista de propiedades de fuente y de cita para procedencias ajenas a Wikidata (leyes, citas web).
- Procedencia de la procedencia (cadena): si añadir de nuevo un SOURCE al LOCAL de la fuente.

## Páginas relacionadas

- [Edge](/es/grammar/edge/), [TRIPLE](/es/grammar/edge/triple/), [QUALIFIER](/es/grammar/edge/qualifier/), [REFERENCE-NODE](/es/grammar/edge/reference-node/), [Marcador de posición](/es/grammar/reference/slot-marker/)
- [Documento](/es/grammar/document/) (HEAD y BODY), [Meta — procedencia](/es/grammar/meta/provenance/)
