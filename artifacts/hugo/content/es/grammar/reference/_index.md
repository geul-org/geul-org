---
title: "Reference"
weight: 40
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference", "LOCAL", "quantifier"]
summary: "Reference es un registro que apunta a un objeto. Los 4 bits de Codec fijan el sistema de identificación (LOCAL, Wikidata, documento externo, etc.) y los 3 bits de Quantifier fijan la cuantificación (identificado, genérico, universal, variable, etc.). El Codec reservado 0000 es el conjunto de marcadores de posición."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Reference es un registro que apunta a un objeto. El objeto puede ser una entidad, un concepto, un documento u otro Edge. Se apunta con un ID, no con un nombre.

## Layout

```
TAG WORD          0000 0LLL LCCC CQQQ
[TAG de extensión de Length]
[IMPORT ID]       si es EXTERNAL-POINTER (1/2/4/8 WORD)
[Issuer]          si es EXTERNAL-ISSUER (1/2/4/16 WORD)
[ID de documento] si es EXTERNAL-ISSUER (4 WORD)
ID de destino     todo el resto
```

- `LLLL` es el número total de WORD, incluido el TAG WORD, menos 1 ([Registro y TAG WORD](/es/grammar/record/)).
- El Codec son los 4 bits `CCCC` y el Quantifier los 3 bits `QQQ`. Los 7 bits inferiores del TAG WORD son `CCCC << 3 | QQQ`.
- El ID de destino es un entero sin signo big endian y se escribe con el **ancho más corto**. El ancho es lo que queda de Length al restar los campos anteriores.
- El ID de destino `0` se escribe con 1 WORD `0x0000`. En los demás casos no se antepone un WORD `0x0000`.
- Si el valor entero es el mismo, es el mismo ID. El ancho no forma parte del ID.
- Todos los Codec usan el ancho más corto. El Codec no fija el ancho del ID de destino.
- [ISSUER-POINTER](/es/grammar/reference/issuer-pointer/) y [DOC-POINTER](/es/grammar/reference/doc-pointer/) no siguen este layout. No tienen ID de destino y solo llevan el Issuer (y el ID de documento y el ID de versión).

## Codec (`CCCC`)

| CCCC | Nombre | Clasificación | Destino |
|---|---|---|---|
| `0000` | [Marcador de posición](/es/grammar/reference/slot-marker/) | Reservado | No apunta a ningún objeto. Solo se usan marcadores de 1 WORD cuyos 3 bits inferiores son el número de marcador: `0x0000` ABSENT (no declarado), `0x0001` UNKNOWN-VALUE (desconocido), `0x0002` NO-VALUE (sin valor) |
| `0001` | [LOCAL](/es/grammar/reference/local/) | Declara | ID emitido por este documento |
| `0010` | [GEUL](/es/grammar/reference/geul/) | Declara | Entidad emitida por geul.org |
| `0011` | [GEUL-SIDX](/es/grammar/reference/geul-sidx/) | Declara | Identificador de alineación semántica que lleva significado en sus bits |
| `0100` | [WIKIDATA-QID](/es/grammar/reference/wikidata-qid/) | Declara | Elemento de Wikidata. El entero que sigue a `Q` |
| `0101` | [WIKIDATA-PID](/es/grammar/reference/wikidata-pid/) | Declara | Propiedad de Wikidata. El entero que sigue a `P` |
| `0110` | [ISSUER-POINTER](/es/grammar/reference/issuer-pointer/) | Señala y declara | El propio Issuer |
| `0111` | [DOC-POINTER](/es/grammar/reference/doc-pointer/) | Señala y declara | Una versión de un documento publicado por un Issuer |
| `1000`~`1011` | [EXTERNAL-POINTER-1/2/4/8WORD](/es/grammar/reference/external-pointer/) | Señala | LOCAL ID de un documento importado con IMPORT |
| `1100`~`1111` | [EXTERNAL-ISSUER-1/2/4/16WORD](/es/grammar/reference/external-issuer/) | Señala y declara | LOCAL ID de un documento publicado por un Issuer |

- **Declara** identifica directamente el objeto con un ID fijado por la entidad emisora.
- **Señala** apunta a un LOCAL dentro de un documento importado con un IMPORT ID. Los 2 bits inferiores son el ancho del IMPORT ID (`00`=1, `01`=2, `10`=4, `11`=8 WORD).
- **Señala y declara** apunta con un solo registro, sin IMPORT, a otro documento y al objeto que contiene.
- Si el bit más significativo es `0`, identifica directamente el objeto (un LOCAL de este documento, un ID emitido, el propio Issuer o documento), y si es `1`, apunta a un LOCAL de otro documento.
- El Codec `0000` está reservado y no se usa como Reference que apunte a un objeto. La excepción es un único conjunto: los WORD `0x0000`~`0x0007` (Codec `0000`, 1 WORD) son [marcadores de posición](/es/grammar/reference/slot-marker/). Ahora se usan tres (`0x0000` ABSENT, `0x0001` UNKNOWN-VALUE, `0x0002` NO-VALUE). Un marcador es válido solo en una posición de campo de registro que tenga exactamente ese WORD como destino CODEC. No se aceptan comodines ni campos sin CODEC, y en las posiciones de registro de HEAD·BODY y en la posición de Edge Id es invalid. `0x0003`~`0x0007` y el Codec `0000` con Payload están reservados.
- Los sistemas de identificación que no son CC0 (WordNet, etc.) no se ponen como Codec de Reference. Reference tampoco tiene códigos ISSUER, así que no hay dónde trasladarlos como formato Issuer.

### TAG de uso frecuente

| Registro | WORD |
|---|---|
| LOCAL 1 | `0088 0001` |
| LOCAL 65536 | `0108 0001 0000` |
| Q5 de Wikidata (persona) | `00A0 0005` |
| Q691283 de Wikidata | `0120 000a 8c53` |
| P31 de Wikidata (instance of) | `00A8 001f` |
| Marcador de posición ABSENT / UNKNOWN-VALUE / NO-VALUE | `0000` / `0001` / `0002` |

## LOCAL

LOCAL es un ID emitido por este documento. Solo tiene sentido dentro del documento.

- **Es único.** En un documento, un LOCAL ID apunta a un solo objeto.
- **El 0 no se asigna.** Los ID de destino se asignan desde 1.
- **Se recomienda asignar de forma creciente** (auto increment). El mayor o menor valor del ID no tiene significado.
- Apunta al mismo objeto a lo largo de las versiones. Un ID eliminado no se reutiliza ([Documento](/es/grammar/document/), Revisión).
- Para que se pueda apuntar desde fuera del documento, el documento debe tener `DOC-ID`.
- Que dos LOCAL ID sean distintos no significa que sean objetos distintos en la realidad. Si son iguales, se enlazan con un Edge `SAME-NODE`; si son distintos, con `DIFFERENT-NODE`.

### Edge Id

Todo Edge pone como primer elemento del Payload un Reference LOCAL. Ese LOCAL ID es el **Edge Id**.

- El Edge Id se puede leer sin conocer el libro de códigos.
- El LOCAL en la posición de Edge Id es una declaración, y el LOCAL en las demás posiciones del Edge es una mención.
- El LOCAL que declara un Edge Id usa solo el Quantifier `000`.
- Los demás Edge se señalan por su Edge Id. Los Edge de este documento, con LOCAL; los de otros documentos, con un Reference que señala.

## Apuntar a otros documentos

| Qué | Cómo |
|---|---|
| El propio Issuer | `ISSUER-POINTER` (Issuer) |
| Una versión de un documento | `DOC-POINTER` (Issuer, ID de documento de 4 WORD, ID de versión de 2 WORD). La versión `0` es la última |
| Un objeto dentro de un documento publicado (última versión) | `EXTERNAL-ISSUER-*` (Issuer, ID de documento, LOCAL ID) |
| Un objeto dentro de un documento importado (edición fijada) | Se asigna un IMPORT ID con el Meta `IMPORT-DOC` y se usa `EXTERNAL-POINTER-*` (IMPORT ID, LOCAL ID) |

- El documento en sí, tanto desde dentro como desde fuera del documento, se señala solo con un DOC-POINTER. Uno mismo es el DOC-POINTER de su propio `DOC-ID`.
- EXTERNAL-ISSUER sigue la última versión. Para fijar la edición se usa IMPORT.
- El Issuer se escribe con el ancho más corto en que quepa el valor (1/2/4/16 WORD) y se elige el Codec que corresponde a ese ancho.
- El ID de documento `0` de cada Issuer se reserva para el documento índice de los términos (herramientas, roles, etc.) que ese Issuer define. El documento índice se recomienda a todos los Issuer y no es obligatorio ([Issuer y publicación](/es/grammar/issuer/#documentos-de-definición-de-términos)).

Ejemplo: LOCAL 7 dentro del documento del Issuer `0x0001` con ID de documento `0x0000000000000002`

```
0360 0001 0000 0000 0000 0002 0007
```

## Quantifier (`QQQ`)

| QQQ | Nombre | Significado | Ejemplo |
|---|---|---|---|
| `000` | Identified | Entidad identificada | Elon Musk, Corea del Sur |
| `001` | Generic | Afirmación general sobre una clase entera. Admite excepciones | Los soldados obedecen las órdenes |
| `010` | Free-choice | Cualquier objeto que cumpla la condición | Cualquier soldado |
| `011` | Universal | Todos los objetos del ámbito | Todos los soldados |
| `100` | Variable | Variable del discurso | esa persona, esta mujer |
| `101`~`111` | Reservado | | |

- **Excepción: en el Codec `0000` (marcador de posición), los 3 bits inferiores no son un Quantifier sino el número de marcador.** El número de marcador y el significado del Quantifier no se corresponden (`0x0001` UNKNOWN-VALUE no es Generic). El Quantifier de esta tabla solo se aplica a los Codec `0001`~`1111`.
- Generic, a diferencia de Universal, no significa que se aplique sin excepción a todos los objetos individuales. Una expresión de tipo definitorio como "¿qué es un soldado?" puede escribirse como Generic. Si se necesita una definición estricta de concepto o clasificación, se concreta con una relación aparte.
- El alcance de la cuantificación y la negación los fija no el Reference sino el Edge que lo usa.
- **Variable** es un objeto del discurso cuyo tipo se conoce pero que aún no se ha identificado.
  - Una variable con nombre se escribe añadiendo Variable a un LOCAL. El mismo LOCAL ID es la misma variable. El tipo se enlaza con un Edge.
  - Una variable anónima se escribe añadiendo Variable al Codec de declaración que señala el tipo (GEUL, WIKIDATA-*) (ejemplo: "presidente" de Wikidata + Variable). No se sigue la correferencia y no se puede volver a señalar. Dos variables anónimas no se consideran la misma variable.
  - Cuando más tarde se confirma el objeto, la variable se enlaza con ese objeto mediante `SAME-NODE`. Todas las expresiones que apuntan a la misma variable se interpretan juntas como ese objeto.
  - Que dos variables sean distintas no significa que sus objetos reales sean distintos. Si son iguales, se enlazan con `SAME-NODE`; si son distintos, con `DIFFERENT-NODE`.
  - La variable solo es válida dentro de ese documento y no se usa como identificador permanente.
  - La Variable de los Codec de señalamiento externo (EXTERNAL-POINTER-*, EXTERNAL-ISSUER-*) es una variable LOCAL del documento al que apunta.
  - Ejemplo: en "El presidente pronunció un discurso", si la persona no está determinada, se usa la Variable "presidente". Para volver a mencionarla, se pone una Variable LOCAL y se enlaza el tipo "presidente" con un Edge. Si más tarde se confirma que es Obama, esa variable se enlaza con Obama Identified mediante `SAME-NODE`. Todas las expresiones que apuntan a la misma variable se interpretan juntas como Obama.
- Ejemplo: si se usa Q5 (persona) de Wikidata como Generic, es `00A1 0005` ("las personas …").
