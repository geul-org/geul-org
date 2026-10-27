---
title: "DELTA-BASE"
weight: 59
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "DELTA-BASE es un Meta de linaje que indica que el archivo de esta versión es un diff respecto de una versión base del mismo documento."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
Es la marca de que el archivo de esta versión no es un snapshot sino un **diff** respecto de una versión base del mismo documento (el delta de un packfile de git). La versión en sí se sigue definiendo como snapshot. El hash de contenido, la lista de versiones y las firmas se refieren siempre al snapshot restaurado aplicando el diff ([Almacenamiento como diff](/es/grammar/document/#almacenamiento-como-diff)).

## Layout

```
TAG WORD          0001 1LLL L011 1010      Codec 0x3A
ID de versión     2 WORD unsigned (la versión base del mismo documento)
```

- Codec: Meta `0x3A`, clase de linaje (`011`)
- Payload: ID de versión de 2 WORD (valor en bruto)
- Cantidad: como máximo uno

## Interpretación y validez

- Solo se usa en documentos con [DOC-ID](/es/grammar/meta/declaration/doc-id/) (documentos cuyas versiones se gestionan con una lista de versiones). Los `versions.geul`, `documents.geul` e `issuers.geul`, que no llevan control de versiones, y los documentos sin nombre no llevan diff.
- La versión base es una versión publicada del mismo `DOC-ID` y es anterior a esta versión. `0` (sin versión) es invalid.
- El hash de contenido del snapshot restaurado debe ser igual al hash de esta versión en la lista de versiones ([PUBLICATION](/es/grammar/edge/publication/)). Si no, este diff es invalid. Por eso dentro del diff no se anota aparte el hash del resultado.
- Solo pueden ser diff los documentos cuyos registros del BODY son todos Edge (registros con Edge Id). Esto se debe a que la unidad del diff es el LOCAL ID (Edge Id).
- La regla de restauración del snapshot sigue [Almacenamiento como diff](/es/grammar/document/#almacenamiento-como-diff). La eliminación la lleva [DELTA-REMOVE](/es/grammar/meta/lineage/delta-remove/).
- No hay una marca aparte de adición o revisión. Si el Edge Id de un Edge del BODY del diff existe en la base, es una revisión, y si no, una adición. Las adiciones reciben numeración a partir de [NEXT-LOCAL-ID](/es/grammar/meta/lineage/next-local-id/) de la lista de versiones. Reutilizar un LOCAL ID eliminado es invalid ([Revisión](/es/grammar/document/#revisión)).

## Ejemplo

Diff respecto de la versión base 3:

```
193A 0000 0003
```

- TAG `193A` (Meta `0x3A`, `LLLL=0010`, 3 WORD), ID de versión `0000 0003`.

## Problemas abiertos

1. Intervalo de snapshots: cada cuántas versiones colocar un snapshot completo (longitud de la cadena de diffs y coste de restauración).
2. Si limitar la versión base a la versión inmediatamente anterior.
3. Dónde guardar el archivo diff: si en el lugar del archivo de la versión (`<ID de versión>.geul`) y su relación con el almacén por dirección de contenido `h/` (`h/` se busca por el hash de contenido del snapshot).
