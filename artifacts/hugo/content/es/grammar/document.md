---
title: "Documento"
weight: 50
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "document", "version", "hash"]
summary: "La unidad de los datos GEUL es un documento (DOC)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

La unidad de los datos GEUL es un documento (DOC). Un archivo (`.geul`, tipo de medio `application/vnd.geul`) es un documento.

## Estructura {#구조}

```
DOC-*            ← abre el documento (longitud total)
  Meta …         ← HEAD: registros sobre el documento
  SOURCE …       ←   (procedencia del documento completo y sus QUALIFIER)
BODY             ← cierra el HEAD y abre el BODY
  Reference, Value, Edge …
END              ← cierra el documento
```

| Registro | TAG | Significado |
|---|---|---|
| DOC-1WORD | `1C01` + 1 WORD | Abre el documento fijando la longitud total en 1 WORD |
| DOC-2WORD | `1C12` + 2 WORD | Longitud total en 2 WORD |
| DOC-4WORD | `1C24` + 4 WORD | Longitud total en 4 WORD |
| BODY | `1C30` | 1 WORD. Cierra el HEAD e inicia el BODY |
| END | `1C40` | 1 WORD. Cierra el documento |

- El valor de DOC-* es el número total de WORD desde el inicio del registro de apertura hasta el final de END. Se usa el ancho más estrecho en que quepa el valor.
- END es obligatorio. Si la posición de END no coincide con la longitud de DOC-*, se rechaza. Si la entrada termina sin END, el documento está truncado.
- El decodificador puede saltar el documento completo de una vez usando la longitud de DOC-*.
- No existe forma de abrir un documento sin conocer su longitud. Los datos en tiempo real cuyo final no se conoce de antemano se cortan en unidades de longitud conocida y se envían como varios documentos.
- Si el HEAD está vacío, se omite el BODY. Un documento sin registro BODY es todo BODY. El BODY se pone una sola vez. Si el HEAD tiene al menos un registro (Meta o HEAD Edge), se pone el BODY.
- Los documentos no se anidan. Otro documento se señala con [IMPORT](meta/_index.md) o con un Reference de designación.

## HEAD y BODY {#head와-body}

- En el HEAD solo van Meta y **HEAD Edge**. Ambos son enunciados sobre el **documento** que los contiene.
  - Meta: estructura, definición, procedencia, linaje, verificación, política e IMPORT del documento.
  - HEAD Edge: el Edge de fundamento [SOURCE](edge/0x0C0L-source.md#문서-전체의-출처) (Target `0`), que registra el origen del documento completo, y el [QUALIFIER](edge/0x0ABL-qualifier.md) que tiene ese SOURCE como Target (hash del texto original, hora de recepción, rango del texto original, etc.). El QUALIFIER va después de ese SOURCE.
- En el BODY solo van Reference, Value y Edge. La procedencia de un registro individual se escribe con el Edge de fundamento [SOURCE](edge/0x0C0L-source.md) dentro del BODY, y otros fundamentos como la confianza, con un QUALIFIER adjunto a ese registro. En el BODY no pueden ir un SOURCE con Target `0` ni un QUALIFIER que tenga como Target el SOURCE del HEAD.
- El decodificador lee el HEAD desde el principio y lo separa. Un Meta es HEAD. Un SOURCE con Target `0` es HEAD y se recuerda su Edge Id. Un QUALIFIER que tiene como Target el SOURCE recordado es HEAD. Si llega cualquier otro registro: si el HEAD está vacío, se omitió el BODY (el BODY empieza en ese registro); si no, es invalid por falta de BODY.
- **El HEAD y el BODY comparten un único espacio de numeración de Edge Id.** Es único dentro del documento y, como en los Edge del BODY, se recibe de [NEXT-LOCAL-ID](meta/0x1DDL-next-local-id.md). Si el Origin de un HEAD Edge es LOCAL, su definición se pone en el BODY (el alcance de LOCAL es todo el documento).
- Un Meta puede contener registros Value dentro de su Payload. El Value contenido no es un registro independiente, sino parte de ese Meta.
- El alcance de una declaración (clase de definición de Meta) es ese documento.

## Declaraciones básicas {#기본-선언}

Cada una de las dos declaraciones aparece como máximo una vez. La condición siguiente determina en qué documento debe haber cada una.

| Meta | Significado | Documento donde debe estar |
|---|---|---|
| [SPEC-VERSION](meta/0x1C5L-spec-version.md) | Edición de la especificación que se sigue. Determina cómo leer los demás registros. Si la edición es desconocida, se rechaza o se advierte. El valor de un documento v1 es `0x0001` | Documento publicado. Si falta, el decodificador lo lee con la edición que conoce |
| [DOC-ID](meta/0x1C7L-doc-id.md) | Identificador del propio documento. Debe existir para señalar este documento y los objetos que contiene desde fuera | Documento de versión bajo `docs/<ID de documento>/` y `codecs/<Codec ID>/` en `.well-known/geul/` (incluidos los documentos de especificación). No se pone en la lista de versiones `versions.geul` ni en los documentos de lista (`issuers/`) |

- `SPEC-VERSION` contiene solo un entero para que lo lea un decodificador de cualquier edición (en v1, `1C51 0001`). No depende de códigos Value.
- `DOC-ID` es un DOC-POINTER que se señala a sí mismo (Issuer, ID de documento, versión `0`). El ID de documento es de 4 WORD. Un documento de Codec no tiene ID de documento, así que usa un [CODEC-POINTER](reference/0x042L-codec-pointer.md) (Issuer, Codec ID, versión `0`). Todo Issuer reserva los ID de documento `0x0000000000000000` y `0xFFFFFFFFFFFFFFFF` ([Issuer y publicación](issuer.md#용어-정의-문서)).
- Un documento sin `DOC-ID` es un documento sin nombre. Solo se puede señalar por su hash de contenido.

## Hash de contenido {#내용-해시}

Una edición de un documento se señala con el **hash de contenido** (cumple la misma función que el ID de commit de git).

- Es el SHA-256 desde el registro de apertura (DOC-*) hasta justo antes de END. 16 WORD.
- Los Meta de la clase de verificación (firmas, etc.; en la sección 15, registros con `C >= 5`, es decir `w >= 0x1E50`) se excluyen del cálculo. Por eso, aunque la firma esté dentro del documento, no se produce circularidad.
- Al calcular, la longitud de DOC-* se sustituye por la longitud sin los registros de verificación, y el ancho también por el más estrecho que quepa en esa longitud. Por eso el hash de contenido es el mismo antes y después de añadir la firma.
- El hash de contenido no se registra en el documento, sino que se calcula. Solo se escribe como valor al señalar otra versión (`PARENT`, etc.).
- El `PARENT` dentro del documento también entra en el cálculo, por lo que el hash de contenido forma una cadena de hashes que enlaza todo el historial.
- Los Meta añadidos después desde fuera del documento (anotaciones en un almacén aparte, etc.) no cambian el hash de contenido (igual que git notes).
- La forma canónica del documento es el binario. El hash de contenido y la firma se calculan solo sobre el binario.

## Versión {#버전}

Un documento con nombre (un documento con `DOC-ID`) tiene versiones.

- El **ID de versión** es un entero de 2 WORD que se numera desde 1 en orden de publicación dentro de un documento. `0` significa «versión no indicada» y se trata como la última versión.
- El ID de versión lo asigna el publicador al publicar. La correspondencia entre ID de versión y hash de contenido se pone en la lista de versiones firmada por el publicador ([direcciones de publicación y lista de versiones](publishing.md#버전-목록)).
- El mismo contenido no se vuelve a publicar. Si el hash de contenido ya existe, se devuelve su ID de versión.
- Si se agotan los 2 WORD, se emite con un nuevo ID de documento.
- Las versiones v2 en adelante indican en el HEAD `PARENT` (el hash de contenido de la versión anterior). Como entra en el hash de contenido, las versiones quedan enlazadas en una cadena de hashes. No se pone en la primera versión.

## Revisión {#개정}

Los documentos GEUL se revisan como las leyes.

- **Las versiones son inmutables.** Una versión publicada no se modifica ni se borra. Las únicas excepciones son la supresión legal y la supresión de oficio ([TOMBSTONE](edge/0x0BAL-tombstone.md)).
- El historial no se borra. Lo corregido se emite como una nueva versión y no se sobrescribe la versión original (conservación de la ley antigua). La versión reescrita se enlaza con la original mediante [REPLACES](meta/0x1D7L-replaces.md).
- Los punteros que cambian, como branch, HEAD o reflog, no se ponen en el documento. Se gestionan fuera (repositorio o índice).
- Una versión nueva puede crear, revisar o eliminar definiciones. No promete compatibilidad con la versión anterior. Que cambie la definición de un mismo término también es una revisión (por ejemplo, la mayoría de edad del Código Civil coreano, de 20 a 19 años; el objeto del delito de violación del Código Penal coreano, de «mujer» (부녀) a «persona»).
- **El LOCAL ID es una identidad que trasciende las versiones** (como el número de artículo). El mismo LOCAL ID señala el mismo objeto aunque la versión sea distinta.
  - Alta: recibe un nuevo LOCAL ID. Como el ID no tiene sentido de orden, no hace falta intercalar como «artículo X bis». El nuevo número se recibe del `NEXT-LOCAL-ID` de la lista de versiones (auto increment).
  - Revisión: se cambia el contenido del mismo LOCAL ID.
  - Baja: ese LOCAL ID se quita de la nueva versión. **Un ID eliminado no se vuelve a usar.**
  - Traslado, división, fusión: recibe un nuevo LOCAL ID y al nuevo registro se le añade un QUALIFIER P1365 (replaces, con el LOCAL ID antiguo como valor) para enlazar el ID antiguo. Como el ID antiguo no se reutiliza, sigue señalando ese registro de la versión anterior.
- Las herramientas que regeneran un documento a partir de material de origen también respetan esta regla. A un enunciado igual al de la versión anterior se le da el mismo LOCAL ID, y solo a los enunciados cambiados o nuevos se les da un número nuevo. No se debe renumerar desde 1 cada vez.
- Una cita determina la edición. Una cita con versión fijada queda atada a esa versión, y una cita a la última (versión `0`) queda atada a la versión vigente en el momento de la interpretación. Un documento que trata un hecho pasado cita fijando la versión que estaba en vigor en ese momento.
- La publicación y la entrada en vigor son distintas. La hora de publicación la indica la lista de versiones y el período de vigencia, el documento.
  - [EFFECTIVE-FROM](meta/0x1C8L-effective-from.md)·[EFFECTIVE-UNTIL](meta/0x1C9L-effective-until.md): período de vigencia de toda la versión
  - QUALIFIER P580 (inicio) y P582 (fin) del Edge de artículo: cuando la fecha de entrada en vigor difiere según el artículo
- **La edición en vigor en el instante T es la versión más alta cuya fecha de entrada en vigor es menor o igual que T.** Si hay QUALIFIER P580·P582 por artículo, estos tienen prioridad. Una edición cuyo período de validez (`EFFECTIVE-UNTIL`) ha pasado no está en vigor.
- Las reglas que determinan qué edición aplicar, como las disposiciones transitorias («se rige por la norma anterior») o la elección entre la ley vigente en el momento del hecho y la ley nueva más favorable al acusado, corresponden al veredicto ([TOULMIN](toulmin/_index.md)). La información de vigencia es su material.
- Que una interpretación administrativa o una sentencia restrinja o amplíe la interpretación de un término no es una revisión del documento, sino una regla de veredicto. Si la interpretación se fija por ley (por ejemplo, la nueva definición de «1 semana» en la Ley de Normas Laborales de Corea), es una revisión.
- El layout binario (wire) de los Codec y de los números de Codec no se revisa, porque un registro codificado con un número de Codec se lee sin fijar la versión del codebook. Para cambiar un layout se asigna un número nuevo. Un número de Codec eliminado no se reutiliza para otro formato.

## Almacenamiento diff {#diff-저장}

Una versión se define siempre como documento completo (instantánea). El diff es solo un formato para almacenar y transmitir esa instantánea con menos datos.

- Solo puede guardarse como diff un documento que tenga `DOC-ID` y cuyo BODY sea todo Edge. La lista de versiones `versions.geul`, que no lleva `DOC-ID`, los documentos de lista (versiones de `issuers/`) y los documentos sin nombre no llevan diff.
- Un documento diff es un documento GEUL ordinario y pone en el HEAD [DELTA-BASE](meta/0x1DBL-delta-base.md) (ID de la versión base).
- La eliminación se escribe con [DELTA-REMOVE](meta/0x1DCL-delta-remove.md) (lista de LOCAL ID que se quitan), y las altas y revisiones, con Edge en el BODY. No hay marca separada de alta o revisión: si el Edge Id existe en la base, es revisión; si no, es alta.
- La restauración de la instantánea debe ser determinista (para que el hash coincida).
  1. Se restaura la instantánea de la versión base. Si la base también es un diff, se restaura recursivamente.
  2. El HEAD se sustituye por completo por el HEAD del diff sin `DELTA-BASE` ni `DELTA-REMOVE`. Los HEAD Edge también cambian con él (no se escriben en `DELTA-REMOVE`).
  3. El BODY mantiene el orden de la base. Se quitan los ID de `DELTA-REMOVE`, y si el Edge Id de un Edge del BODY del diff existe en la base, se sustituye en esa posición.
  4. Los Edge Id que no están en la base se añaden al final en el orden en que aparecen en el diff.
  5. El hash de contenido del resultado debe ser igual al hash de esta versión en la lista de versiones. Si difiere, es invalid.
- Reutilizar en el diff un LOCAL ID eliminado es invalid. Tampoco se reutiliza el Edge Id de un HEAD Edge eliminado.
- El hash de contenido, la lista de versiones y las firmas se calculan siempre sobre la instantánea restaurada.
