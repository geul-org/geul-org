---
title: "SOURCE (0x0C0L)"
weight: 192
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "SOURCE es el Edge de fundamento que vincula un registro (el objetivo) o un documento completo con la fuente de la que procede."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `SOURCE` (BIND `SOURCE` del documento de especificación) |
| TAG ID | `0x0C0L` |
| Codec ID | `0x00000C00` |
| Documento de especificación | `0x00000000/codecs/0x00000C00/` (destino de DECLARE `0C00`) |
| Sección | 6 `0110` (fundamento de Edge), desplazamiento C dentro de la sección = 0 |
| Kind | Edge · familia: fundamento |
| TAG WORD | `0000 1100 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Vincula un registro o un documento completo con su fuente. Target (Edge Id de BODY; en HEAD, `0` = documento completo), Origin (Reference, ABSENT o UNKNOWN-VALUE). La naturaleza de la fuente la expresa un TRIPLE que tiene a la fuente como Subject; la naturaleza de la cita (fecha de consulta, posición, hash del texto original) la expresa un QUALIFIER asociado al SOURCE. El SOURCE del documento completo y su QUALIFIER van en HEAD |
| Lado Hugo | `edge/source.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)). El Edge Id de un Edge no se declara como FIELD.

| Orden | Campo (BIND) | FIELD | Ancho | Formato aceptado (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `target` | #2 | registro | `0050` LOCAL |  |
| 2 | `origin` | #3 | registro | `000F` sección 0 completa (comodín, Reference), `020F` sección 1 completa (comodín, Reference), `040F` sección 2 completa (comodín, Reference), `0010` UNKNOWN-VALUE, `0000` ABSENT (campo opcional) |  |

SOURCE es el Edge de fundamento que vincula un registro (el objetivo) o un documento completo con la fuente de la que procede. Codec `0x0C0L`. Es el único código directo de la familia de fundamento (`01`).

Una referencia de Wikidata (un grupo de procedencia) equivale a un SOURCE. Si un registro tiene varias procedencias, hay varios SOURCE.

## Layout {#레이아웃}

```
TAG WORD          0000 1100 0000 LLLL
[TAG de extensión de Length]
Edge Id           registro Reference LOCAL
Target            registro Reference LOCAL (en BODY, el Edge Id del Edge al que se adjunta el fundamento; en HEAD, 0 = documento completo)
Origin            registro Reference, o marcador de posición 0x0000 ABSENT·0x0010 UNKNOWN-VALUE
```

- Origin señala la fuente. Si existe un Reference adecuado para la fuente, se usa ese (WIKIDATA-QID, DOC-POINTER o EXTERNAL-ISSUER de un documento GEUL, etc.); si no, un nodo LOCAL de este documento.
- Si la procedencia no describe una fuente (por ejemplo, una procedencia con solo «imported from» (P143) de Wikidata y la fecha de consulta), Origin es [ABSENT](../slot-marker.md) (no consignado). Quien escribe simplemente no consignó la fuente; no afirma nada sobre ella. El resto de la procedencia queda tal cual en los QUALIFIER.
- [UNKNOWN-VALUE](../slot-marker.md) se usa solo cuando quien escribe afirma que «hay una fuente pero no se sabe cuál» (registros hechos por una persona, etc.). Un conversor que traslada material de origen no afirma lo que la fuente no dice, así que usa ABSENT.
- Un Origin ABSENT o UNKNOWN-VALUE es independiente en cada aparición. No se interpreta que las fuentes de dos SOURCE sean la misma.

## Dos capas {#두-층}

La información sobre la procedencia se divide en dos. No se mezclan.

| Capa | Qué es | Cómo se escribe | Ejemplo |
|---|---|---|---|
| Fuente | La naturaleza de la fuente en sí. Es la misma sea quien sea quien cite | [TRIPLE](0x0AAL-triple.md) con la fuente como Subject (rank normal) | URL (P854), título (P1476), autor (P50·P2093), fecha de publicación (P577), publicado en (P1433), editor (P123), idioma (P407) |
| Cita | La naturaleza del acto por el que este registro citó la fuente | [QUALIFIER](0x0ABL-qualifier.md) con el Edge Id del SOURCE como Target | fecha de consulta (P813), posición dentro de la fuente (página P304, sección P958, identificador externo P227·P1417), obtenido de (P143), método de inferencia (P887), hash del texto original (P4092) |

- **El significado de un SOURCE es el conjunto de todos los QUALIFIER que apuntan a su Edge Id.** Dos procedencias que consultaron la misma fuente en días distintos tienen la misma fuente y QUALIFIER distintos.
- El TRIPLE de la fuente es una afirmación sobre la fuente. Una propiedad cuya capa no se pueda determinar va en el lado de la cita (QUALIFIER). Es más seguro no afirmar nada sobre la fuente.
- Dentro de un documento, una misma fuente se declara una sola vez como un LOCAL y varios SOURCE la señalan en común.
- Una fuente descrita solo por una URL se define con [REFERENCE-NODE](0x0A0L-reference-node.md) (LOCAL → URI). Es igual que la página de documento de un sitelink.

## Interpretación y validez {#해석과-유효성}

- Target y Origin son, cada uno, exactamente un registro completo. El cursor tras leer Origin debe coincidir con el final del Edge.
- Target es un Reference LOCAL. El SOURCE de BODY señala un Edge Id del BODY del mismo documento. `0` (documento completo) lo usa solo el SOURCE de HEAD ([procedencia del documento completo](#문서-전체의-출처)). Un SOURCE con Target `0` en BODY es invalid. A un registro de otro documento se le adjunta el fundamento dentro de ese documento.
- Origin es un Reference. Como marcadores de posición solo admite `0x0000` (ABSENT) y `0x0010` (UNKNOWN-VALUE). No admite NO-VALUE (`0x0020`) ni Value.
- El documento de especificación de geul.org `0x00000000/codecs/0x00000C00` (nombre `source`) pone en Target un [CODEC](0x0BEL-codec.md) LOCAL (`0050`) y en Origin los CODEC `000F`·`020F`·`040F` (cualquier Reference), `0000` (ABSENT, opcional) y `0010` (UNKNOWN-VALUE).
- El orden entre los SOURCE de un mismo Target no tiene significado. El orden de los elementos dentro de una procedencia tampoco (el orden de los valores de una misma propiedad se conserva como orden del documento).
- SOURCE no cambia la verdad o falsedad del objetivo. Solo consigna de dónde vino. El resultado del juicio lo gestiona [TOULMIN](../toulmin/_index.md) `VERDICT`.

## Procedencia del documento completo {#문서-전체의-출처}

La fuente del documento completo (volcado original, edición, archivo de texto original) se escribe como **un SOURCE con Target `0` en HEAD**. Los QUALIFIER que tienen ese SOURCE como Target (hash del texto original P4092, hora de recepción P813, alcance del texto original, etc.) también van en HEAD ([documento](../document.md#head와-body)).

- En HEAD solo pueden ir estos dos Edge. Cualquier otro Edge va en BODY.
- El QUALIFIER de HEAD va después del SOURCE de HEAD al que apunta. El decodificador lee desde el principio y separa HEAD y BODY.
- Un QUALIFIER en BODY que tenga como Target un SOURCE de HEAD es invalid. Los SOURCE y QUALIFIER de BODY no señalan Edge de HEAD.
- **HEAD y BODY comparten un único espacio de numeración de Edge Id.** Es único dentro del documento, se recibe de [NEXT-LOCAL-ID](../meta/0x1DDL-next-local-id.md) como en los demás Edge y, al regenerar, si el contenido es el mismo hereda el mismo número. Aunque una versión carezca de un Edge de HEAD, su número no se reutiliza.
- Si Origin es LOCAL, su definición (REFERENCE-NODE, TRIPLE de la fuente) va en BODY. El alcance de un LOCAL es el documento completo.
- Los Edge de HEAD no son Meta de clase verificación, así que entran en el [hash de contenido](../document.md#내용-해시). En un diff cambian en bloque junto con HEAD (no se consignan en `DELTA-REMOVE`).
- No hay un Meta específico para la procedencia del documento completo. Con el alcance del texto original o la hora de obtención escritos como Meta, cuando hay varias fuentes no se puede determinar a cuál se refieren. El QUALIFIER asociado al SOURCE lo determina mediante Target.

Ejemplo: HEAD de un documento de Q42 trasladado desde un volcado de Wikidata (los Edge Id son ilustrativos).

```
SPEC-VERSION  0x0001
DOC-ID        0x00000001/0x510000000000002A
TRANSFORMED-BY …
#1738 SOURCE     #0     #1735                                         versión (revision) de la entidad
#1741 SOURCE     #0     #1740                                         archivo de volcado
#1742 QUALIFIER  P4092  #1741  SHA-256-DIGEST(0xA249…0774)            hash del archivo
#1743 QUALIFIER  P813   #1741  POSIX-TIMESTAMP-SECONDS(1792996483)    hora de recepción
BODY
#1736 TRIPLE     P577   #1735  POSIX-TIMESTAMP-SECONDS(1792210885) normal                      hora de guardado de la versión
#1737 TRIPLE     P854   #1735  <https://www.wikidata.org/w/index.php?oldid=2557857485> normal  enlace permanente de la versión
#1739 REFERENCE-NODE    #1740  <https://dumps.wikimedia.org/wikidatawiki/entities/20261019/wikidata-20261019-all.json.bz2>
…
```

- La versión y el volcado son fuentes distintas, por lo que hay dos SOURCE. La versión es la fuente del contenido (con el enlace permanente se puede volver a obtener el mismo contenido), y el volcado es el archivo en que se recibió esa versión. El hash del archivo y la hora de recepción son propiedades del lado de la cita sobre el archivo de volcado, por lo que se adjuntan al SOURCE del volcado.

## Representación de otros fundamentos {#다른-근거의-표현}

En la familia de fundamento solo existe SOURCE. Los demás fundamentos se escriben con QUALIFIER.

| Fundamento | Cómo se escribe | Property |
|---|---|---|
| Alcance dentro del texto original | QUALIFIER en SOURCE. Un SOURCE por alcance | página P304, sección P958, cita textual P1683. El alcance en caracteres es un término GEUL (sin definir) |
| Hora en que se recibió el material de origen | QUALIFIER en SOURCE | fecha de consulta P813 |
| Hash en bytes del texto original (fija la edición) | QUALIFIER en SOURCE | suma de verificación P4092; el valor es [SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md), etc. |
| Agente que lo produjo (persona, modelo, motor de reglas) | QUALIFIER en SOURCE (agente que hizo la cita) o en el objetivo | término GEUL (sin definir) |
| Confianza | QUALIFIER en el objetivo | término GEUL (sin definir); el valor va de 0 a 1, como el Meta [CONFIDENCE](../meta/0x1E8L-confidence.md) |
| Periodo de vigencia por artículo | QUALIFIER en el objetivo | inicio P580, fin P582 |
| Registro anterior a un traslado, división o fusión | QUALIFIER en el objetivo; el valor es el Edge Id anterior (LOCAL) | P1365 (replaces) |
| Versión en que entró por primera vez | No se almacena. Se calcula a partir del historial de versiones (git blame) | |

## Ejemplo (no normativo) {#예시-비규범}

Q42 P19 (lugar de nacimiento) Q350, TRIPLE objetivo `#178`. En el volcado de Wikidata del 2026-10-19, esta proposición tiene cinco procedencias, de las cuales se muestran tres. ③ el artículo del Telegraph (`#1358`~`#1367`) tiene la misma forma que ②, y ⑤ Store norske leksikon (Q746368) la misma que ①, por lo que se omitieron.

```
SOURCE     #1347  #178   Q5375741                     ① Britannica: sin descripción de la fuente, solo un P248
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

- En ① no hay descripción de la fuente y solo hay un P248, así que la fuente es ese elemento. `#1347` es TAG 1 + Edge Id 2 + Target 2 + Q5375741 3 = 8 WORD, TAG `0C07`.

```
0C07 0051 0543 0051 00B2 0142 0052 06FD
```

- Procedencia con una sola URL: `REFERENCE-NODE #1383 #1384 <http://www.eskimo.com/~rkj/weekly/aa051701a.htm>`, `SOURCE #1385 #180 #1384`.
- Procedencia con solo «imported from» Wikipedia en inglés: `SOURCE #n #t ABSENT`, `QUALIFIER P143 #n Q328`. Origin `0x0000` ocupa 1 WORD.

## Problemas abiertos {#열린-문제}

- Términos GEUL (documento de definición de términos e ID) para expresar el alcance en caracteres, el agente que lo produjo y la confianza.
- Cuando la descripción de la fuente no identifica la fuente (una procedencia con solo el idioma, etc.), compartir esa descripción en un único LOCAL llevaría a afirmar que fuentes distintas son la misma.
- Lista de propiedades de fuente y de cita para procedencias fuera de Wikidata (legislación, citas web).
- Procedencia de la procedencia (cadena): si añadir de nuevo un SOURCE al LOCAL de la fuente.

## Páginas relacionadas {#관련-페이지}

- [Edge](_index.md), [TRIPLE](0x0AAL-triple.md), [QUALIFIER](0x0ABL-qualifier.md), [REFERENCE-NODE](0x0A0L-reference-node.md), [marcador de posición](../slot-marker.md)
- [Documento](../document.md) (HEAD y BODY), [Meta — procedencia](../meta/_index.md#출처)

## Texto original del documento de especificación {#규격-문서-원문}

Así se ve el documento de especificación `0x00000000/codecs/0x00000C00/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000C0000000000
BODY
#1 DECLARE 0x0C00
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "SOURCE"
#5 BIND #2 "target"
#6 BIND #3 "origin"
#7 CODEC #2 0x0050
#8 CODEC #3 0x000F
#11 CODEC #3 0x020F
#12 CODEC #3 0x040F
#9 CODEC #3 0x0010
#10 CODEC #3 0x0000
```
