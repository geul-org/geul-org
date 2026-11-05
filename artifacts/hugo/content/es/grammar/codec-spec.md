---
title: "Documento de especificación de Codec"
weight: 40
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "codebook", "declare", "field"]
summary: "El codebook determina cómo un Codec compone su Payload."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

El codebook determina cómo un Codec compone su Payload. El codebook de GEUL no es un formato aparte: es un **documento GEUL**. A cada Codec le corresponde un documento de especificación.

## Ubicación del documento de especificación {#규격-문서의-위치}

El documento de especificación de un código directo lo publica el Issuer GEUL (`0x00000000`). Es un documento de Codec y no tiene ID de documento. El Codec ID es el valor de 32 bits que resulta de escribir el TAG WORD de ese Codec (solo la sección y la posición de Codec en `C`, con Length igual a 0).

```
/.well-known/geul/0x00000000/codecs/0x0000<TAG>/<ID de versión>.geul
```

| Codec | TAG | Documento de especificación |
|---|---|---|
| Reference LOCAL | `0050` | `0x00000000/codecs/0x00000050` |
| Value QUANTITY | `0660` | `0x00000000/codecs/0x00000660` |
| Edge TRIPLE | `0AA0` | `0x00000000/codecs/0x00000AA0` |
| Edge PUBLICATION | `0B80` | `0x00000000/codecs/0x00000B80` |

El decodificador construye la dirección del documento de especificación a partir del TAG WORD únicamente. Si encuentra un Codec desconocido, le basta con descargar ese documento y leerlo.

- `<TAG>` son los 4 dígitos hexadecimales (en mayúsculas) del TAG WORD de destino. La posición de Length es `0000`. Hay un documento de Codec por cada código. El sistema Reference 5Q también tiene uno por cada código de cuantificación (LOCAL Identified `0050`, LOCAL Generic `0060`). Los códigos directos y los Codecs de Issuer usan la misma regla de direcciones `<Issuer>/codecs/<Codec ID>/` ([direcciones de publicación y lista de versiones](publishing.md#공표-주소)).
- Los [marcadores de posición](slot-marker.md) (`0x0000`, `0x0010`, `0x0020`) también tienen documento de especificación. Como no tienen Payload, solo contienen DECLARE y ningún FIELD. El significado de los marcadores y su regla de aceptación vienen integrados en el decodificador ([capa 0](publishing.md#층)). Un Codec cuyo layout aún no se ha fijado también empieza con un documento de especificación que contiene solo DECLARE.
- El documento de especificación pone como `DOC-ID` un [CODEC-POINTER](reference/0x042L-codec-pointer.md) (`0x00000000`, `0x0000<TAG>`, `0`). El registro de la lista de versiones usa también este CODEC-POINTER.
- Las reglas de versión, dirección canónica y firma son las mismas que las de un documento publicado ordinario.

### Codebook y edición de la especificación {#코덱북과-명세-판}

- Un documento de Codec también puede importarse con [IMPORT-DOC](meta/0x1E4L-import-doc.md). En ese caso, en la posición del documento se usa un [CODEC-POINTER](reference/0x042L-codec-pointer.md) en lugar de un DOC-POINTER. El [SPEC-VERSION](meta/0x1C5L-spec-version.md) del HEAD del documento determina qué codebook se sigue.
- Todo decodificador integra el codebook central o lo descarga desde esta dirección.
- Cuando una propuesta (Prefix `000`) se adopta como estándar, el layout se mantiene y solo el Prefix pasa a `001` ([visión general](_index.md#영역-구조)). Como el TAG WORD de destino cambia, la versión adoptada se convierte en un nuevo documento de especificación con otro Codec ID, y el documento de la propuesta permanece inmutable.

## Cuatro vocabularios {#네-어휘}

| Edge | Codec | Función |
|---|---|---|
| DECLARE | `0x0BBL` | Declara la composición del Payload de un Codec. El destino es 1 WORD de TAG WORD |
| FIELD | `0x0BCL` | Un campo del Payload. El DECLARE al que pertenece y su ancho |
| ENUM | `0x0BDL` | Asigna un significado a un valor de código de un campo de valor en bruto |
| CODEC | `0x0BEL` | Designa un Kind o Codec que admite el campo |

- El layout de los cuatro Edge viene integrado en el decodificador ([capa 0](publishing.md#층)), porque el documento de especificación debe poder leerse sin codebook. Para leer un documento de especificación no hace falta ningún otro documento de especificación.
- Todos los nombres (nombre del Codec, nombre de campo, nombre de valor de código) se enlazan con BIND.

### FIELD {#field}

```
Edge Id           LOCAL
DECLARE           LOCAL (el DECLARE al que pertenece este campo)
ancho             1 WORD: 0 = registro, n = valor en bruto de n WORD, 0xFFFF = valor en bruto restante
```

- El **orden dentro del documento** de los FIELD que apuntan al mismo DECLARE es el orden de los campos del Payload.
- Un campo de registro empieza con un TAG WORD y se lee tantos WORD como indique su Length.
- Un campo de valor en bruto es un entero sin signo que se lee con el número de WORD fijado. Los valores que requieren interpretación (signo, decimales, fechas) no se ponen como valor en bruto, sino como registro Value.
- Solo puede haber un valor en bruto restante (`0xFFFF`), y después de él solo pueden venir valores en bruto de ancho fijo.
- El Edge Id de un Edge no se declara como FIELD. Es implícito porque es el primer elemento de todo Edge. En EDGE-ISSUER es el primer elemento después del Issuer y del número de Codec ([EDGE-ISSUER-2WORD](edge/0x1BDL-edge-issuer-2word.md)).
- La posición a la que se llega leyendo los campos en orden debe coincidir exactamente con el final del registro.

### CODEC {#codec}

Designa el formato que admite un campo. El WORD de destino usa tal cual la posición de Codec del TAG WORD (sección `KKKK` y `C`).

| Posición de Length | Significado | Ejemplo |
|---|---|---|
| `0000` | Codec exacto | `0680` SIGNED-DECIMAL, `0050` LOCAL |
| `1111` | Comodín: independientemente del valor de `C`, abarca toda la sección `KKKK` (32 casillas). Se recomienda la primera casilla de la sección (`C = 0`) | `000F` toda la sección 0, `060F` toda la sección 3 |

- Si un Kind abarca varias secciones, se enumera un CODEC por cada sección. Cualquier Reference es `000F`·`020F`·`040F`, y cualquier Value es `060F`·`080F`.
- Para un grupo o una cuantificación indiferente se enumeran los Codecs exactos. El QID de Wikidata (cuantificación indiferente) son cinco: `0140`, `0150`, `0160`, `0170`, `0180`.

- Si un campo de registro no tiene CODEC, admite cualquier registro (excepto los marcadores de posición). Si tiene uno o más, debe ser uno de ellos (lista cerrada).
- Si a un campo de valor en bruto se le pone un CODEC, ese valor en bruto se interpreta como ese Value sin TAG.

### Campos opcionales y marcadores de posición {#선택-필드와-자리-표지}

Los [marcadores de posición](slot-marker.md) son un grupo de registros de 1 WORD asignados a las tres primeras casillas `0x000L~0x002L` de la sección 0 de Reference. Solo pueden ocupar una posición cuando la lista de CODEC del campo tiene ese WORD como destino exacto.

| Destino de CODEC | Marcador | Ese campo |
|---|---|---|
| `0000` | ABSENT, no escrito | es un **campo opcional**. Puede omitirse |
| `0010` | UNKNOWN-VALUE, desconocido | admite la aserción de que hay un valor pero no se sabe cuál |
| `0020` | NO-VALUE, sin valor | admite la aserción de que no hay valor |

- **Regla de aceptación:** un marcador solo es válido si el mismo WORD figura como destino exacto en la lista de CODEC de ese campo. Los comodines (`000F`, `060F` …) y los campos sin CODEC («cualquier registro») no aceptan marcadores. En las posiciones de registro de HEAD y BODY y en la posición de Edge Id es invalid.
- Para omitir un campo opcional se escribe en su posición un único WORD `0x0000` (ABSENT). Un campo opcional también ocupa siempre su posición. Por eso la notación de un registro es única y su descomposición queda determinada solo por la posición.
- Un marcador tiene su propio código Reference, no se solapa con otros registros, y un decodificador que no conozca la especificación lo salta como registro de 1 WORD.
- Los tres marcadores dicen cosas distintas. ABSENT habla del documento (esta posición no se ha rellenado), por lo que no afirma nada sobre el mundo. UNKNOWN-VALUE es la aserción de que existe un valor (`∃x`) y NO-VALUE la de que no existe (`¬∃x`, dentro de una condición de restricción). Omitir significa «no escrito», no «sin valor».
- Qué significa un marcador lo determina la especificación del Codec que lo recibe ([TRIPLE](edge/0x0AAL-triple.md), [QUALIFIER](edge/0x0ABL-qualifier.md)).

## Ejemplo: documento de especificación de TRIPLE {#예-triple-규격-문서}

Es el BODY de `0x00000000/codecs/0x00000AA0`.

| Edge | Contenido | Nombre (BIND) |
|---|---|---|
| #1 DECLARE | destino `0AA0` | `TRIPLE` |
| #2 FIELD | campo de #1, registro | `predicate` |
| #3 FIELD | campo de #1, registro | `subject` |
| #4 FIELD | campo de #1, registro | `object` |
| #5 FIELD | campo de #1, valor en bruto de 1 WORD | `rank` |
| #6~#8 ENUM | valores de código 0, 1, 2 de #5 | `normal`, `preferred`, `deprecated` |
| #17 CODEC | #5 se interpreta como UNSIGNED-INTEGER (`0620`) | |
| #18, #22, #23, #19, #24 CODEC | #4 es cualquier Reference (`000F`·`020F`·`040F`) o cualquier Value (`060F`·`080F`) | |
| #20, #21 CODEC | #4 admite también UNKNOWN-VALUE (`0010`) y NO-VALUE (`0020`) | |
| #25~#27 CODEC | #2 es cualquier Reference (`000F`·`020F`·`040F`) | |
| #28~#30 CODEC | #3 es cualquier Reference (`000F`·`020F`·`040F`) | |

Con este único documento, el decodificador divide un registro TRIPLE en campos, lo muestra con los nombres de los campos y comprueba que el formato es correcto.

## Ejemplo: documento de especificación de QUANTITY {#예-quantity-규격-문서}

En Value QUANTITY (`0660`), los cuatro campos son registros.

| Campo | CODEC |
|---|---|
| `amount` | `0610` SIGNED-INTEGER, `0620` UNSIGNED-INTEGER, `0630` BINARY-FLOAT (solo valores finitos), `0670` FRACTION, `0680` SIGNED-DECIMAL, `0690` UNSIGNED-DECIMAL |
| `unit` | `000F`·`020F`·`040F` cualquier Reference, `0000` opcional |
| `lower` | `0610`·`0620`·`0630`·`0670`·`0680`·`0690` (igual que amount), `0000` opcional |
| `upper` | `0610`·`0620`·`0630`·`0670`·`0680`·`0690` (igual que amount), `0000` opcional |

## Reglas {#규칙}

- Un documento de especificación contiene un solo DECLARE. El destino del DECLARE es igual al TAG WORD del Codec ID.
- En un mismo documento no se declara dos veces el mismo destino.
- Las variantes con distinta composición de campos no se expresan como ramas. Se declara cada Codec por separado.
- No se pueden declarar layouts con dos o más valores en bruto de longitud variable, ni layouts en los que el ancho de un valor en bruto dependa de otro valor. Esas partes se envuelven en un registro.
- El documento de especificación se publica por versiones, como cualquier otro documento. Pero el layout binario de un Codec no se revisa. Para cambiarlo se asigna un nuevo Codec.

## Problemas abiertos {#열린-문제}

- La correspondencia entre el valor de `SPEC-VERSION` (en v1, `0x0001`) y la versión del documento del codebook. Un Meta de linaje que una la versión adoptada con la propuesta.
