---
title: "Documento de especificación de Codec"
weight: 90
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "codebook", "declare", "field"]
summary: "El libro de códigos también es un documento GEUL. Cuatro Edge (DECLARE, FIELD, ENUM, CODEC) declaran la composición del Payload de un Codec, y ese único documento sirve a la vez para validar, descomponer y mostrar."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Cómo un Codec compone su Payload lo decide el libro de códigos. El libro de códigos de GEUL no es un formato aparte: es un **documento GEUL**. Un documento de especificación por cada Codec.

## Ubicación del documento de especificación

Los documentos de especificación de los códigos directos los publica el Issuer GEUL (`0x0000`). Su ID de documento es el TAG WORD de ese Codec (solo los campos de Kind y Codec; Length es 0) extendido a 4 WORD.

```
/.well-known/geul/0x0000/0x000000000000<TAG>.geul
```

| Codec | TAG | Documento de especificación |
|---|---|---|
| Reference LOCAL | `0008` | `0x0000/0x0000000000000008` |
| Value QUANTITY | `0806` | `0x0000/0x0000000000000806` |
| Edge TRIPLE | `100A` | `0x0000/0x000000000000100A` |
| Edge PUBLICATION | `1018` | `0x0000/0x0000000000001018` |

El decodificador construye la dirección del documento de especificación con solo ver el TAG WORD. Si encuentra un Codec desconocido, basta con descargar y leer ese documento.

- `<TAG>` son los 4 dígitos hex del TAG WORD de destino. El campo Length es `0000`, y en Reference los bits de Quantifier se dejan en `000` (para LOCAL, `0008`).
- El Codec `0000` de Reference está reservado, así que no existe un documento de especificación cuyo TAG WORD de destino sea `0x0000`. Por eso los documentos de especificación no chocan con el documento índice de definición de términos del Issuer GEUL (ID de documento `0`, [Issuer y publicación](/es/grammar/issuer/#documentos-de-definición-de-términos)). Tampoco hay documento de especificación para los [marcadores de posición](/es/grammar/reference/slot-marker/) (`0x0000`~`0x0002`) del Codec `0000`; vienen incorporados en el decodificador ([capa 0](/es/grammar/publishing/#capas)).
- El documento de especificación pone como `DOC-ID` un DOC-POINTER (`0x0000`, `0x000000000000<TAG>`, `0`). El registro de la lista de versiones también usa este DOC-POINTER.
- Como cualquier otro documento, el documento de especificación vincula un nombre con slug en minúsculas en el índice de nombres `0x0000/documents.geul` del Issuer GEUL. Ej.: `publication` → `geul.org/publication/` = `0x0000/0x0000000000001018/` ([Direcciones de publicación y lista de versiones](/es/grammar/publishing/#nombre-del-documento)).
- Las reglas de versión, dirección canónica y firma son las mismas que las de un documento publicado normal.

### ID de documento del Issuer GEUL

| ID de documento | Uso |
|---|---|
| `0x0000000000000000` | Documento índice de definición de términos |
| `0x00000000 0000xxxx` | Documento de especificación de Codec. `xxxx` es el TAG WORD de destino |
| `0x0001xxxx xxxxxxxx` | Documento de definición de términos de geul.org. Un documento por término ([Issuer y publicación](/es/grammar/issuer/#documentos-de-definición-de-términos)) |

- `0x00000000 0000xxxx` se reserva para los documentos de especificación de Codec. Los demás documentos del Issuer GEUL (por ejemplo, documentos de formatos ISSUER propios de GEUL que se colocan cuando faltan códigos directos) no usan este rango.

### Libro de códigos y versión de la especificación

- Los documentos del libro de códigos no se importan con `IMPORT-DOC`. El [SPEC-VERSION](/es/grammar/meta/declaration/spec-version/) del HEAD del documento decide qué libro de códigos se sigue.
- Todo decodificador incorpora el libro de códigos central o lo descarga de esta dirección.
- Cuando una propuesta (Prefix `000`) se adopta como estándar, el layout se mantiene y solo el Prefix pasa a `001` ([Visión general](/es/grammar/overview/#estructura-de-regiones)). Como el TAG WORD de destino cambia, la versión adoptada es un nuevo documento de especificación con otro ID de documento, y el documento de la propuesta permanece inmutable.

## Cuatro vocabularios

| Edge | Codec | Qué hace |
|---|---|---|
| DECLARE | `0x1B` | Declara la composición del Payload de un Codec. 1 WORD de TAG WORD de destino |
| FIELD | `0x1C` | Un campo del Payload. El DECLARE al que pertenece y el ancho |
| ENUM | `0x1D` | Da significado a un valor de código de un campo en bruto |
| CODEC | `0x1E` | Indica un Kind y Codec que acepta el campo |

- El layout de los cuatro Edge viene incorporada en el decodificador ([capa 0](/es/grammar/publishing/#capas)), porque los documentos de especificación deben poder leerse sin libro de códigos. Leer un documento de especificación no requiere otro documento de especificación.
- Todos los nombres (nombre del Codec, de los campos, de los valores de código) se vinculan con BIND.

### FIELD

```
Edge Id           LOCAL
DECLARE           LOCAL (el DECLARE al que pertenece este campo)
ancho             1 WORD: 0 = registro, n = valor en bruto de n WORD, 0xFFFF = valor en bruto restante
```

- El **orden dentro del documento** de los FIELD que apuntan al mismo DECLARE es el orden de los campos del Payload.
- Un campo de registro comienza con un TAG WORD y se lee hasta la cantidad indicada por su Length.
- Un campo en bruto es un entero sin signo que se lee con un número fijo de WORD. Los valores que requieren interpretación, como signo, decimales o fechas, no se ponen como valor en bruto sino como registro Value.
- Solo puede haber un valor en bruto restante (`0xFFFF`), y después de él solo pueden venir valores en bruto de ancho fijo.
- El Edge Id de un Edge no se declara como FIELD. Es implícito, por ser el primer elemento de todo Edge.
- La posición a la que se llega leyendo los campos en orden debe coincidir exactamente con el final del registro.

### CODEC

Indica el formato que acepta un campo. El WORD de destino usa tal cual los campos de Kind y Codec del TAG WORD.

| Campo Length | Significado | Ejemplo |
|---|---|---|
| `0000` | Codec exacto | `0810` SIGNED-DECIMAL, `0008` LOCAL |
| `1111` | Comodín: los bits de Codec que valen 0 admiten cualquier valor | `0780` cualquier Reference, `0F80` cualquier Value, `07A0` QID de Wikidata (sin importar la cuantificación) |

- Si un campo de registro no tiene CODEC, acepta cualquier registro (excepto los marcadores de posición). Si tiene uno o más, debe ser uno de ellos (lista cerrada).
- Si a un campo en bruto se le pone un CODEC, ese valor en bruto se interpreta como ese Value sin TAG.

### Campos opcionales y marcadores de posición

Los [marcadores de posición](/es/grammar/reference/slot-marker/) son el conjunto de registros de 1 WORD del Codec `0000` reservado de Reference. Solo pueden aparecer en una posición si la lista CODEC del campo incluye ese WORD como destino exacto.

| Destino CODEC | Marcador | Ese campo |
|---|---|---|
| `0000` | ABSENT, no declarado | Es un **campo opcional**. Puede omitirse |
| `0001` | UNKNOWN-VALUE, desconocido | Acepta la afirmación de que hay un valor pero se ignora cuál |
| `0002` | NO-VALUE, sin valor | Acepta la afirmación de que no hay valor |

- **Regla de aceptación:** un marcador solo es válido si el mismo WORD figura como destino exacto en la lista CODEC del campo. Los comodines (`0780`, `0781`, `0F80` …) y los campos sin CODEC ("cualquier registro") no aceptan marcadores. En las posiciones de registros de HEAD·BODY y en la posición del Edge Id, es invalid.
- Para omitir un campo opcional se escribe en su posición un único WORD `0x0000` (ABSENT). Un campo opcional también ocupa siempre su posición. Así, un registro tiene una sola notación y la descomposición queda determinada solo por la posición.
- Como los marcadores pertenecen al Codec reservado de Reference, no se solapan con otros registros, y un decodificador que no conozca la especificación los salta como registros de 1 WORD.
- Los tres marcadores dicen cosas distintas. ABSENT habla del documento (esta posición no se rellenó), por lo que no afirma nada sobre el mundo. UNKNOWN-VALUE afirma que hay un valor (`∃x`) y NO-VALUE afirma que no hay valor (`¬∃x`, dentro de la condición que lo acota). Omitir significa "no declarado", no "sin valor".
- Qué significa un marcador lo decide la especificación del Codec que lo recibe ([TRIPLE](/es/grammar/edge/triple/), [QUALIFIER](/es/grammar/edge/qualifier/)).

## Ejemplo: documento de especificación de TRIPLE

Es el BODY de `0x0000/0x000000000000100A`.

| Edge | Contenido | Nombre (BIND) |
|---|---|---|
| #1 DECLARE | destino `100A` | `TRIPLE` |
| #2 FIELD | campo de #1, registro | `predicate` |
| #3 FIELD | campo de #1, registro | `subject` |
| #4 FIELD | campo de #1, registro | `object` |
| #5 FIELD | campo de #1, valor en bruto de 1 WORD | `rank` |
| #6~#8 ENUM | valores de código 0, 1, 2 de #5 | `normal`, `preferred`, `deprecated` |
| #17 CODEC | #5 se interpreta como UNSIGNED-INTEGER (`0802`) | |
| #18, #19 CODEC | #4 es cualquier Reference (`0780`) o cualquier Value (`0F80`) | |
| #20, #21 CODEC | #4 también acepta UNKNOWN-VALUE (`0001`) y NO-VALUE (`0002`) | |

Con este único documento, el decodificador divide un registro TRIPLE en campos, lo muestra con los nombres de campo y comprueba que el formato sea correcto.

## Ejemplo: documento de especificación de QUANTITY

En el Value QUANTITY (`0806`), los cuatro campos son registros.

| Campo | CODEC |
|---|---|
| `amount` | `0810` SIGNED-DECIMAL |
| `unit` | `0780` cualquier Reference, `0000` opcional |
| `lower` | `0810` SIGNED-DECIMAL, `0000` opcional |
| `upper` | `0810` SIGNED-DECIMAL, `0000` opcional |

## Reglas

- Un documento de especificación tiene un solo DECLARE. El destino del DECLARE es igual al TAG WORD del ID de documento.
- Un mismo documento no declara dos veces el mismo destino.
- Las variantes con distinta composición de campos no se expresan como ramas. Se declara cada Codec por separado.
- No se pueden declarar layouts con dos o más valores en bruto variables, ni cuyo ancho de valor en bruto dependa de otro valor. Esas partes se envuelven en un registro.
- El documento de especificación se publica por versiones como cualquier otro documento. Sin embargo, el layout binario de un Codec no se revisa. Para cambiarla se asigna un nuevo Codec.

## Problemas abiertos

- La correspondencia entre el valor de `SPEC-VERSION` (v1 es `0x0001`) y la versión del documento del libro de códigos. Un Meta de linaje que conecte la versión adoptada con la propuesta.
