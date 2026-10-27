---
title: "NEXT-LOCAL-ID"
weight: 61
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "NEXT-LOCAL-ID es un Meta de linaje que anota en la lista de versiones el LOCAL ID que la siguiente versión del documento asignará a las nuevas afirmaciones (auto increment)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
Anota el LOCAL ID que la siguiente versión de ese documento asignará a las nuevas afirmaciones (el auto increment de un DBMS, `AUTO_INCREMENT` de MySQL). Todos los LOCAL ID asignados en cualquier versión del documento son menores que este valor.

## Layout

```
TAG WORD          0001 1LLL L011 1100      Codec 0x3C
Payload           siguiente LOCAL ID por asignar, entero unsigned del ancho más corto
```

- Codec: Meta `0x3C`, clase de linaje (`011`)
- Payload: valor en bruto (entero unsigned del ancho más corto)
- Cantidad: como máximo uno
- Dónde se coloca: el HEAD del documento de lista de versiones `versions.geul` ([PUBLICATION](/es/grammar/edge/publication/))

## Interpretación y validez

- El LOCAL ID (incluido el Edge Id) es una identidad que trasciende las versiones ([Revisión](/es/grammar/document/#revisión)). Una afirmación nueva recibe este valor y el valor aumenta en 1. Un LOCAL ID eliminado no se reutiliza. Por eso, aunque se elimine la afirmación que tenía el valor máximo, este valor no disminuye.
- El LOCAL ID `0` no se asigna, así que el primer valor es `1`. Si aún no hay versiones, no se coloca este Meta y el siguiente número es `1`.
- El lugar de publicación lo actualiza y anota en el nuevo documento de lista cuando publica una versión. Debe ser mayor que cualquier LOCAL ID usado en las versiones publicadas. Si es menor o igual, es invalid.
- El valor solo crece. Si es menor que el valor del documento de lista anterior ([PARENT](/es/grammar/meta/lineage/parent/)), es invalid.
- No existe en los documentos sin control de versiones (documentos sin `versions.geul`, documentos sin nombre). Tales documentos tampoco llevan diff ([DELTA-BASE](/es/grammar/meta/lineage/delta-base/)).
- No se coloca en el cuerpo del documento (documento de versión). La memoria de la numeración no es contenido del documento sino estado del lugar de publicación que va escribiendo el documento (del lado de refs de git, no de sus commits).

## Ejemplo

Siguiente número por asignar 524:

```
18BC 020C
```

- TAG `18BC` (Meta `0x3C`, `LLLL=0001`, 2 WORD), Payload `020C`.
