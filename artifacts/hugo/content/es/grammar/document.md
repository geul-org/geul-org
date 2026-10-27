---
title: "Documento"
weight: 30
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "document", "version", "hash"]
summary: "La unidad de los datos GEUL es el documento. Un documento se abre indicando su longitud, se cierra con END y se divide en HEAD (Meta y la procedencia del documento entero) y BODY (Reference, Value, Edge). Cada versión queda fijada por su hash de contenido."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

La unidad de los datos GEUL es un documento (DOC). Un archivo (`.geul`, tipo de medio `application/vnd.geul`) es un documento.

## Estructura

```
DOC-*            ← abre el documento (longitud total)
  Meta …         ← HEAD: registros sobre el documento
  SOURCE …       ←   (la procedencia del documento entero y sus QUALIFIER)
BODY             ← termina el HEAD y abre el BODY
  Reference, Value, Edge …
END              ← cierra el documento
```

| Registro | TAG | Significado |
|---|---|---|
| DOC-1WORD | `1880` + 1 WORD | Abre el documento indicando la longitud total en 1 WORD |
| DOC-2WORD | `1901` + 2 WORD | Longitud total en 2 WORD |
| DOC-4WORD | `1A02` + 4 WORD | Longitud total en 4 WORD |
| BODY | `180E` | 1 WORD. Termina el HEAD y comienza el BODY |
| END | `180F` | 1 WORD. Cierra el documento |

- El valor de DOC-* es el número total de WORD desde el inicio del registro de apertura hasta el final de END. Se usa el ancho más estrecho en que quepa el valor.
- END es obligatorio. Si la posición de END no coincide con la longitud de DOC-*, se rechaza. Si la entrada termina sin END, el documento está truncado.
- El decodificador puede saltar el documento entero de una vez usando la longitud de DOC-*.
- No hay forma de abrir un documento sin conocer su longitud. Los datos en tiempo real, cuyo final no se conoce de antemano, se cortan en unidades de longitud conocida y se envían como varios documentos.
- Si el HEAD está vacío, se omite el BODY. Un documento sin registros BODY es todo BODY. El BODY se coloca una sola vez. Si el HEAD tiene al menos un registro (Meta o Edge del HEAD), se coloca el BODY.
- Los documentos no se anidan. Otros documentos se señalan con [IMPORT](/es/grammar/meta/) o con un Reference que apunta.

## HEAD y BODY

- En el HEAD solo se colocan Meta y **Edge del HEAD**. Todos son una descripción del **documento** que los contiene.
  - Meta: estructura, definición, procedencia, linaje, verificación, política e IMPORT del documento.
  - Edge del HEAD: el Edge de fundamento [SOURCE](/es/grammar/edge/source/#procedencia-del-documento-entero) (Target `0`) que anota la fuente del documento entero, y los [QUALIFIER](/es/grammar/edge/qualifier/) que tienen ese SOURCE como Target (hash del texto original, hora de recepción, rango del texto original, etc.). Los QUALIFIER van después de ese SOURCE.
- En el BODY solo se colocan Reference, Value y Edge. La procedencia de cada registro se escribe con el Edge de fundamento [SOURCE](/es/grammar/edge/source/) dentro del BODY, y otros fundamentos, como la confiabilidad, con un QUALIFIER que se adjunta a ese registro. Un SOURCE con Target `0` y un QUALIFIER que tenga como Target un SOURCE del HEAD no pueden ir en el BODY.
- El decodificador lee el HEAD desde el principio y lo separa. Un Meta es HEAD. Un SOURCE con Target `0` es HEAD, y se recuerda su Edge Id. Un QUALIFIER que tiene como Target un SOURCE recordado es HEAD. Si llega cualquier otro registro: si el HEAD está vacío, el BODY se omitió (desde ese registro empieza el BODY); si no, es invalid por falta del BODY.
- **El Edge Id usa un solo espacio de numeración para HEAD y BODY.** Es único dentro del documento y se toma de [NEXT-LOCAL-ID](/es/grammar/meta/lineage/next-local-id/) como los Edge del BODY. Si el Origin de un Edge del HEAD es un LOCAL, su definición va en el BODY (el ámbito de LOCAL es el documento entero).
- Un Meta puede contener un registro Value dentro de su Payload. El Value contenido no es un registro independiente sino parte de ese Meta.
- El alcance de una declaración (clase de definición de Meta) es ese documento.

## Declaraciones básicas

Ambas declaraciones son, como máximo, una. Las condiciones siguientes establecen en qué documento debe estar cada una.

| Meta | Significado | Documento donde debe estar |
|---|---|---|
| [SPEC-VERSION](/es/grammar/meta/declaration/spec-version/) | Versión de la especificación que se sigue. Decide cómo leer el resto de registros. Si es una versión desconocida, se rechaza o se advierte. El valor en un documento v1 es `0x0001` | Documentos publicados. Si falta, el decodificador lo lee con la versión que conoce |
| [DOC-ID](/es/grammar/meta/declaration/doc-id/) | Identificador del propio documento. Debe estar para poder apuntar desde fuera a este documento y a los objetos que contiene | Documentos de `.well-known/geul/` cuyo nombre empieza por `0x` (documentos de versión, documentos de especificación). No se coloca en la lista de versiones ni en el índice de nombres |

- `SPEC-VERSION` contiene un solo entero para que lo pueda leer el decodificador de cualquier versión (en v1, `1890 0001`). No depende del código de Value.
- `DOC-ID` es un DOC-POINTER que se apunta a sí mismo (Issuer, ID de documento, versión `0`). El ID de documento es de 4 WORD.
- Un documento sin `DOC-ID` es un documento sin nombre. Solo se puede apuntar a él por su hash de contenido.

## Hash de contenido

Un ejemplar de documento se señala con su **hash de contenido** (cumple el papel del ID de commit de git).

- Es el SHA-256 desde el registro de apertura (DOC-*) hasta justo antes de END. 16 WORD.
- Los Meta de la clase de verificación (firmas, etc.) se excluyen del cálculo. Los Edge del HEAD no son Meta de la clase de verificación, así que sí entran. Por eso, colocar la firma dentro del documento no crea circularidad.
- Al calcular, la longitud de DOC-* se sustituye por la longitud sin los registros de verificación, y el ancho también se sustituye por el más estrecho que admita esa longitud. Así, el hash de contenido es el mismo antes y después de añadir la firma.
- El hash de contenido no se registra en el documento sino que se calcula. Solo se escribe como valor cuando se apunta a otra versión (`PARENT`, etc.).
- Como el `PARENT` dentro del documento también entra en el cálculo, el hash de contenido forma una cadena de hashes que enlaza todo el historial.
- Los Meta añadidos después desde fuera del documento (anotaciones en un repositorio aparte, etc.) no cambian el hash de contenido (igual que git notes).
- La versión canónica del documento es el binario. El hash de contenido y la firma se calculan solo sobre el binario.

## Versión

Los documentos con nombre (los que tienen `DOC-ID`) tienen versiones.

- El **ID de versión** es un entero de 2 WORD que se numera desde 1 en el orden de publicación dentro de un mismo documento. `0` significa "versión no indicada" y se trata como la última versión.
- El ID de versión lo asigna el lugar de publicación al publicar. La correspondencia entre ID de versión y hash de contenido se pone en la lista de versiones firmada por el lugar de publicación ([Direcciones de publicación y lista de versiones](/es/grammar/publishing/#lista-de-versiones)).
- El mismo contenido no se vuelve a publicar. Si el hash de contenido ya existe, se devuelve ese ID de versión.
- Si se agotan los 2 WORD, se emite con un nuevo ID de documento.
- Las versiones posteriores a v2 escriben en el HEAD `PARENT` (hash de contenido de la versión anterior). Como entra en el hash de contenido, las versiones quedan enlazadas en una cadena de hashes. No se coloca en la primera versión.

## Revisión

Los documentos GEUL se revisan como las leyes.

- **Las versiones son inmutables.** Una versión publicada no se modifica ni se borra. Las únicas excepciones son la eliminación legal y la eliminación de oficio ([TOMBSTONE](/es/grammar/edge/publication/)).
- El historial no se borra. Lo corregido se emite como una nueva versión y no se sobrescribe la versión original (conservación de la ley anterior). Una versión reescrita se enlaza con la original mediante [REPLACES](/es/grammar/meta/lineage/replaces/).
- Los punteros mutables, como branch, HEAD o reflog, no se colocan en el documento. Se gestionan fuera de él (repositorio, índice).
- Una nueva versión puede crear, revisar o eliminar definiciones. No se promete compatibilidad con la versión anterior. También es una revisión que cambie la definición de un mismo término (ejemplo: en el Código Civil coreano, la "mayoría de edad" pasó de 20 a 19 años; en el Código Penal, el objeto del delito de violación pasó de "mujer" a "persona").
- **El LOCAL ID es una identidad que trasciende las versiones** (como el número de un artículo). El mismo LOCAL ID apunta al mismo objeto aunque cambie la versión.
  - Creación: se recibe un nuevo LOCAL ID. Como el ID no tiene sentido de orden, no hacen falta intercalaciones como "artículo X bis". El nuevo número se obtiene de `NEXT-LOCAL-ID` de la lista de versiones (auto increment).
  - Revisión: se cambia el contenido bajo el mismo LOCAL ID.
  - Eliminación: se quita ese LOCAL ID en la nueva versión. **Un ID eliminado no se reutiliza.**
  - Traslado, división, fusión: se recibe un nuevo LOCAL ID y se enlaza con el ID antiguo añadiendo al nuevo registro un QUALIFIER P1365 (replaces, con el valor del LOCAL ID antiguo). Como el ID antiguo no se reutiliza, sigue apuntando a ese registro de la versión anterior.
- Las herramientas que regeneran un documento desde el material de origen también respetan esta regla. A las afirmaciones iguales a las de la versión anterior se les da el mismo LOCAL ID, y solo a las que cambian o son nuevas se les da un número nuevo. No se debe renumerar desde 1 cada vez.
- Una cita especifica la edición. Una cita con versión fijada queda ligada a esa versión, y una cita a la última (versión `0`) queda ligada a la versión vigente en el momento de la interpretación. Un documento que trate un hecho pasado cita fijando la versión que estaba vigente en aquel momento.
- Publicación y entrada en vigor son cosas distintas. El momento de publicación lo anota la lista de versiones y el periodo de vigencia lo anota el documento.
  - [EFFECTIVE-FROM](/es/grammar/meta/declaration/effective-from/)·[EFFECTIVE-UNTIL](/es/grammar/meta/declaration/effective-until/): periodo de vigencia de la versión completa
  - QUALIFIER P580 (inicio)·P582 (fin) en el Edge de un artículo: cuando la fecha de entrada en vigor difiere por artículo
- **La edición vigente en el momento T es la versión más alta cuya fecha de entrada en vigor sea igual o anterior a T.** Si existen QUALIFIER P580·P582 por artículo, estos prevalecen. Una edición cuyo periodo de validez (`EFFECTIVE-UNTIL`) ya pasó no está vigente.
- Las reglas que deciden qué edición se aplica, como las disposiciones transitorias ("se aplica la disposición anterior"), o la elección entre la ley vigente al momento del hecho y la nueva ley más favorable al acusado, corresponden al juicio ([TOULMIN](/es/grammar/edge/toulmin/)). La información de entrada en vigor es su materia prima.
- Que una interpretación administrativa o una sentencia restrinja o amplíe la interpretación de un término no es una revisión del documento sino una regla de juicio. Cuando la interpretación se fija por legislación (ejemplo: la nueva definición de "1 semana" en la Ley de Normas Laborales), sí es una revisión.
- El layout binario (wire) de los Codec y de los números de formato no se revisa. Esto se debe a que los registros codificados con un número de formato se leen sin fijar la versión del libro de códigos. Para cambiar el layout se asigna un nuevo número. Un número de formato eliminado no se reutiliza para otro formato.

## Almacenamiento como diff

Una versión siempre se define como el documento completo (snapshot). El diff es solo un formato para almacenar y transmitir ese snapshot en menos espacio.

- Solo pueden ser diff los documentos que tienen `DOC-ID` y cuyo BODY es todo Edge. Los `versions.geul`, `documents.geul` e `issuers.geul`, que no llevan control de versiones, y los documentos sin nombre no llevan diff.
- Un documento diff es un documento GEUL normal y lleva en el HEAD [DELTA-BASE](/es/grammar/meta/lineage/delta-base/) (ID de la versión base).
- Las eliminaciones se escriben con [DELTA-REMOVE](/es/grammar/meta/lineage/delta-remove/) (lista de LOCAL ID que se quitan), y las adiciones y revisiones con Edge en el BODY. No hay marca aparte de adición o revisión: si el Edge Id existe en la base es una revisión, y si no, una adición.
- La restauración del snapshot debe ser determinista (para que el hash coincida).
  1. Se restaura el snapshot de la versión base. Si la base también es un diff, se restaura recursivamente.
  2. El HEAD se sustituye por completo por el HEAD del diff sin `DELTA-BASE` ni `DELTA-REMOVE`. Los Edge del HEAD también cambian con él (no se anotan en `DELTA-REMOVE`).
  3. El BODY mantiene el orden de la base. Se quitan los ID de `DELTA-REMOVE` y, si el Edge Id de un Edge del BODY del diff existe en la base, se reemplaza en esa posición.
  4. Los Edge Id que no existen en la base se añaden al final en el orden en que aparecen en el diff.
  5. El hash de contenido del resultado debe ser igual al hash de esta versión en la lista de versiones. Si no, es invalid.
- Es invalid reutilizar en un diff un LOCAL ID eliminado. Tampoco se reutiliza el Edge Id de un Edge del HEAD que falta.
- El hash de contenido, la lista de versiones y las firmas se refieren siempre al snapshot restaurado.
