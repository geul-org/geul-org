---
title: "DELTA-REMOVE"
weight: 60
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "DELTA-REMOVE es un Meta de linaje que anota la lista de LOCAL ID (Edge Id) que se quitan del BODY del snapshot base en un diff."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
En un diff ([DELTA-BASE](/es/grammar/meta/lineage/delta-base/)), anota los LOCAL ID (Edge Id) de los registros que se quitan del BODY del snapshot base ("artículo X derogado").

## Layout

```
TAG WORD          0001 1LLL L011 1011      Codec 0x3B
[TAG de extensión de Length]
LOCAL ID a eliminar   registro Reference LOCAL × 1 o más
```

- Codec: Meta `0x3B`, clase de linaje (`011`)
- Payload: uno o más registros Reference [LOCAL](/es/grammar/reference/local/)
- Cantidad: como máximo uno

## Interpretación y validez

- Solo se coloca en documentos que tienen `DELTA-BASE`.
- Cada LOCAL ID debe ser un Edge Id que exista en el BODY del snapshot base. Si no, es invalid. Poner el mismo ID dos veces es invalid.
- Volver a poner el mismo Edge Id en el BODY del mismo diff es invalid (no se puede eliminar y revisar a la vez).
- Un LOCAL ID eliminado no se reasigna a otro objeto en versiones posteriores ([Revisión](/es/grammar/document/#revisión)).
- Que el BODY del diff no tenga un registro significa "sin cambios". Por eso la eliminación se expresa solo con este Meta.
- No se anotan los Edge del HEAD (el [SOURCE](/es/grammar/edge/source/#procedencia-del-documento-entero) del documento entero y sus QUALIFIER). El HEAD cambia por completo con el HEAD del diff ([Almacenamiento como diff](/es/grammar/document/#almacenamiento-como-diff)).

## Ejemplo

Eliminar los LOCAL `#7` y `#12`:

```
1A3B 0088 0007 0088 000C
```

- TAG `1A3B` (Meta `0x3B`, `LLLL=0100`, 5 WORD), Reference LOCAL `0088 0007`, `0088 000C`.
