---
title: "GEUL-SIDX"
weight: 4
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "GEUL-SIDX es un Reference de declaración que apunta a un objeto con un GEUL SIDX (Semantic-aligned Index), que lleva el significado en los propios bits."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
GEUL-SIDX es un Reference de declaración que apunta a un objeto con un GEUL SIDX (Semantic-aligned Index). SIDX es un identificador que lleva el significado (tipo, atributos) en los propios bits.

## Layout

```
TAG WORD          0000 0LLL L001 1QQQ      CCCC = 0011
[TAG de extensión de Length]
SIDX              todo el resto
```

- El Quantifier es igual que en los demás Codec de declaración. Si es Variable, es una variable anónima de ese tipo (Variable de [Reference](/es/grammar/reference/)). La cuantificación se hace solo con `QQQ`. No se mete cuantificación en el valor del SIDX.
- El documento de especificación declara el SIDX como un único campo de valor en bruto de ancho "el resto". Se cambiará cuando se fije la regla de ancho.

## Ejemplo

| SIDX | Secuencia de WORD |
|---|---|
| (no normativo) 64 bits `0x1234 5678 9abc def0`, Identified | `0218 1234 5678 9abc def0` |

## Criterio de asignación

- Su papel es distinto del de [GEUL](/es/grammar/reference/geul/). GEUL es un ID de identidad que se asigna más o menos en orden (auto increment), y GEUL-SIDX es una dirección semántica que da valores cercanos a objetos de significado cercano.
- El grado de cercanía se fija con estadísticas acumuladas de datos de uso. Antes de que se junten las estadísticas se usan ID de GEUL y, tras asignar el SIDX, se enlazan el GEUL y el GEUL-SIDX del mismo objeto con [SAME-NODE](/es/grammar/edge/same-node/).

## Problemas abiertos

- **Ancho.** Se fijará viendo las estadísticas. Se estudian 4 WORD (64 bits) y 16 WORD, entre otros. El SIDX tiene significado en los bits superiores, por lo que no puede usar tal cual la regla del "ancho más corto" (prohibido el `0x0000` inicial) de los demás Codec de declaración. Por eso será de ancho fijo (o de ancho fijo por subformato). Hasta que se fije, el documento de especificación declara el SIDX como valor en bruto del ancho restante.
- **Estabilidad de la asignación.** En Reference, si el valor entero es el mismo es el mismo objeto, y un ID asignado no se reutiliza. Para no mover los SIDX ya asignados aunque cambien las estadísticas, hace falta una asignación append-only (asignación dispersa que deja huecos en los lugares de significado cercano). Si hubiera que mover con frecuencia, se decidirá si definir el SIDX no como identificador permanente sino como un índice ligado a la edición del registro.
- **Unicidad.** Si el SIDX se genera por significado en bits y puede haber colisiones, no encaja con la premisa de que "si el valor entero es el mismo, es el mismo objeto". Al asignar, se resuelven las colisiones para garantizar la unicidad.
- Libro de códigos y formato de divulgación del registro.

## Páginas relacionadas

- [Reference](/es/grammar/reference/), [GEUL](/es/grammar/reference/geul/)
