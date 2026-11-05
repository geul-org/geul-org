---
title: "Reference"
weight: 90
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "LOCAL", "quantifier"]
summary: "Reference es un registro que señala un objeto."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Reference es un registro que señala un objeto. El objeto puede ser una entidad, un concepto, un documento u otro Edge. Se señala con un ID, no con un nombre.

## Layout {#레이아웃}

```
TAG WORD          000K KKKC CCCC LLLL      secciones 0~2 (0x000L~0x05FL)
[TAG de extensión de Length]
[IMPORT ID]       cuando es EXTERNAL-POINTER (1/2/4 WORD)
[Issuer]          cuando es EXTERNAL-ISSUER (2/4/16 WORD)
[ID de documento] cuando es EXTERNAL-ISSUER (4 WORD)
ID de destino     todo el resto
```

- `LLLL` es el número total de WORD incluido el TAG WORD − 1 ([Registros y TAG WORD](../record.md)).
- Reference ocupa 96 casillas en las secciones 0~2 (`w < 0x0600`). Sección 0, entidades: `0x000L~0x01FL`; sección 1, EXTERNAL: `0x020L~0x03FL`; sección 2, otros: `0x040L~0x05FL`.
- El Codec se escribe como tabla de códigos (tabla de abajo). En el sistema 5Q, un código contiene a la vez el sistema de identificación y la cuantificación. La cuantificación de REFERENCE-ISSUER la fija el documento del Issuer.
- El ID de destino es un entero big-endian sin signo y se escribe con el **ancho más corto**. El ancho es el resto de Length tras restar los campos anteriores.
- El ID de destino `0` se escribe como 1 WORD `0x0000`. En los demás casos no se antepone ningún WORD `0x0000`.
- Si el valor entero es igual, es el mismo ID. El ancho no forma parte del ID.
- Todos los Codec usan el ancho más corto. El Codec no fija el ancho del ID de destino.
- [ISSUER-POINTER](0x040L-issuer-pointer.md), [DOC-POINTER](0x041L-doc-pointer.md) y [CODEC-POINTER](0x042L-codec-pointer.md) no siguen este layout. No tienen ID de destino y solo contienen el Issuer (y el ID de documento, el Codec ID y el ID de versión).
- [REFERENCE-ISSUER](#reference-issuer) tampoco sigue este layout. Es TAG, Issuer, número de Codec de 2 WORD y Payload. El Payload lo fija el documento de Codec publicado por el Issuer.

## Codec {#codec}

| TAG ID | Nombre | Clasificación | Destino |
|---|---|---|---|
| `0x000L~0x002L` | [Marcador de posición](../slot-marker.md) | marcador de posición | No señala ningún objeto. Solo se usan marcadores de 1 WORD: `0x0000` ABSENT (no escrito), `0x0010` UNKNOWN-VALUE (desconocido), `0x0020` NO-VALUE (ninguno) |
| `0x005L~0x009L` | [LOCAL](0x005L-local.md) | declaración | ID emitido por este documento |
| `0x00AL~0x00EL` | [GEUL](0x00AL-geul.md) | declaración | entidad que emite geul.org |
| `0x00FL~0x013L` | [GEUL-SIDX](0x00FL-geul-sidx.md) | declaración | identificador de alineación semántica que lleva significado en los bits |
| `0x014L~0x018L` | [WIKIDATA-QID](0x014L-wikidata-qid.md) | declaración | elemento de Wikidata. Entero tras la `Q` |
| `0x019L~0x01DL` | [WIKIDATA-PID](0x019L-wikidata-pid.md) | declaración | propiedad de Wikidata. Entero tras la `P` |
| `0x020L~0x02EL` | [EXTERNAL-POINTER-1/2/4WORD](0x020L-external-pointer-1word.md) | designación | LOCAL ID de un documento importado con IMPORT |
| `0x02FL~0x03DL` | [EXTERNAL-ISSUER-2/4/16WORD](0x02FL-external-issuer-2word.md) | designación y declaración | LOCAL ID de un documento publicado por un Issuer |
| `0x040L` | [ISSUER-POINTER](0x040L-issuer-pointer.md) | designación y declaración | el propio Issuer |
| `0x041L` | [DOC-POINTER](0x041L-doc-pointer.md) | designación y declaración | una versión de un documento publicado por un Issuer |
| `0x042L` | [CODEC-POINTER](0x042L-codec-pointer.md) | designación y declaración | una versión de un Codec publicado por un Issuer |
| `0x05DL~0x05FL` | [REFERENCE-ISSUER-2/4/16WORD](#reference-issuer) | formato de Issuer | Lo define el Issuer. La clasificación y la casilla del ID de destino las fija el documento del Issuer |

- Reserved son `0x003L~0x004L`, `0x01EL~0x01FL` (sección 0), `0x03EL~0x03FL` (sección 1) y `0x043L~0x05CL` (sección 2, espacio para nuevos sistemas de identificación).
- El número de sistema se lee con el desplazamiento dentro de la sección `C`. En la sección 0, si `5 <= C < 30`, el sistema es `C / 5` (1~5); en la sección 1, si `C < 30`, el sistema es `6 + C / 5` (6~11).

| Sistema | Nombre | Identified | Generic | Free-choice | Universal | Variable |
|---:|---|---|---|---|---|---|
| 1 | LOCAL | `0x005L` | `0x006L` | `0x007L` | `0x008L` | `0x009L` |
| 2 | GEUL | `0x00AL` | `0x00BL` | `0x00CL` | `0x00DL` | `0x00EL` |
| 3 | GEUL-SIDX | `0x00FL` | `0x010L` | `0x011L` | `0x012L` | `0x013L` |
| 4 | WIKIDATA-QID | `0x014L` | `0x015L` | `0x016L` | `0x017L` | `0x018L` |
| 5 | WIKIDATA-PID | `0x019L` | `0x01AL` | `0x01BL` | `0x01CL` | `0x01DL` |
| 6 | EXTERNAL-POINTER-1WORD | `0x020L` | `0x021L` | `0x022L` | `0x023L` | `0x024L` |
| 7 | EXTERNAL-POINTER-2WORD | `0x025L` | `0x026L` | `0x027L` | `0x028L` | `0x029L` |
| 8 | EXTERNAL-POINTER-4WORD | `0x02AL` | `0x02BL` | `0x02CL` | `0x02DL` | `0x02EL` |
| 9 | EXTERNAL-ISSUER-2WORD | `0x02FL` | `0x030L` | `0x031L` | `0x032L` | `0x033L` |
| 10 | EXTERNAL-ISSUER-4WORD | `0x034L` | `0x035L` | `0x036L` | `0x037L` | `0x038L` |
| 11 | EXTERNAL-ISSUER-16WORD | `0x039L` | `0x03AL` | `0x03BL` | `0x03CL` | `0x03DL` |

- La **declaración** identifica directamente el objeto con un ID fijado por quien lo emite.
- La **designación** señala un LOCAL dentro de un documento importado con un IMPORT ID. El ancho del IMPORT ID lo fija el sistema: si sistema − 6 es 0, 1 o 2, es 1, 2 o 4 WORD.
- La **designación y declaración** señala con un solo registro, sin IMPORT, otro documento y un objeto dentro de él. El ancho del Issuer de EXTERNAL-ISSUER es 2, 4 o 16 WORD si sistema − 9 es 0, 1 o 2.
- `0x020L~0x03DL` (sección 1, sistemas 6~11) señalan LOCAL de otros documentos. Los demás sistemas de declaración identifican directamente el objeto (LOCAL de este documento, ID emitido). Los punteros (sección 2, `0x040L~0x042L`) señalan al propio Issuer, documento o Codec. REFERENCE-ISSUER queda fuera de esta distinción.
- `0x000L~0x002L` son códigos asignados a marcadores de posición y no se usan como Reference que señale un objeto. Los WORD `0x0000`, `0x0010` y `0x0020` (L 0, 1 WORD) son [marcadores de posición](../slot-marker.md) (`0x0000` ABSENT, `0x0010` UNKNOWN-VALUE, `0x0020` NO-VALUE). Un marcador solo es válido en la posición de un campo de registro que tenga exactamente ese WORD como destino CODEC. No lo aceptan los comodines ni los campos sin CODEC, y en las posiciones de registro de HEAD·BODY y en las de Edge Id es invalid. La forma de TAG con Payload en C 0~2 (L ≥ 1) es Reserved.
- Solo los códigos directos y las publicaciones que ofrece geul.org son CC0. No se ponen como código directo sistemas de identificación que no sean CC0 (WordNet, etc.). La licencia de un formato de Issuer la fija ese Issuer.

### TAG de uso frecuente {#자주-쓰는-tag}

| Registro | WORD |
|---|---|
| LOCAL 1 | `0051 0001` |
| LOCAL 65536 | `0052 0001 0000` |
| Wikidata Q5 (ser humano) | `0141 0005` |
| Wikidata Q691283 | `0142 000A 8C53` |
| Wikidata P31 (instancia de) | `0191 001F` |
| Marcador de posición ABSENT / UNKNOWN-VALUE / NO-VALUE | `0000` / `0010` / `0020` |

## LOCAL {#local}

LOCAL es un ID emitido por este documento.

- **Es único.** En un documento, un LOCAL ID señala un solo objeto.
- **El 0 no se asigna.** Los ID de destino se asignan desde 1.
- **Se recomienda asignar de forma creciente** (auto increment). El tamaño del ID no significa nada.
- Señala el mismo objeto a través de las versiones. Un ID eliminado no se vuelve a usar (revisión del [documento](../document.md)).
- Para que se pueda señalar desde fuera del documento, el documento debe tener `DOC-ID`.
- Que dos LOCAL ID sean distintos no significa que en la realidad sean objetos distintos. Si son iguales se unen con un Edge `SAME-NODE`, y si son distintos, con `DIFFERENT-NODE`.

### Edge Id {#edge-id}

Todo Edge pone un Reference LOCAL como primer elemento de su Payload. Ese LOCAL ID es el **Edge Id**.

- El Edge Id se puede leer sin conocer el libro de códigos.
- El LOCAL en la posición de Edge Id es una declaración, y el LOCAL en las demás posiciones del Edge es una mención.
- Para declarar un Edge Id solo se usa LOCAL Identified (`0x005L`).
- Los demás Edge se señalan por Edge Id. Los Edge de este documento se señalan con LOCAL y los de otros documentos con un Reference de designación.

## Señalar otros documentos {#다른-문서-가리키기}

| Qué | Cómo |
|---|---|
| El propio Issuer | `ISSUER-POINTER` (Issuer) |
| Una versión de un documento | `DOC-POINTER` (Issuer, ID de documento de 4 WORD, ID de versión de 2 WORD). La versión `0` es la más reciente |
| Una versión de un Codec | `CODEC-POINTER` (Issuer, Codec ID de 2 WORD, ID de versión de 2 WORD). La versión `0` es la más reciente |
| Un objeto dentro de un documento publicado (el más reciente) | `EXTERNAL-ISSUER-*` (Issuer, ID de documento, LOCAL ID) |
| Un objeto dentro de un documento importado (edición fija) | Asignar un IMPORT ID con el Meta `IMPORT-DOC` y usar `EXTERNAL-POINTER-*` (IMPORT ID, LOCAL ID) |

- Un documento en sí se señala, dentro o fuera de sí mismo, únicamente con un DOC-POINTER. A sí mismo se señala con el DOC-POINTER de su propio `DOC-ID`. Como excepción, el documento de Codec se señala con CODEC-POINTER (su `DOC-ID` también es CODEC-POINTER).
- EXTERNAL-ISSUER sigue la versión más reciente. Para fijar la edición se usa IMPORT.
- El Issuer se escribe con el ancho más corto en que quepa el valor (2/4/16 WORD) y se elige el Codec que corresponde a ese ancho. EXTERNAL-ISSUER y REFERENCE-ISSUER son iguales.
- El ID de documento `0` de cada Issuer se reserva como documento índice de los términos definidos por ese Issuer (herramientas, roles, etc.). El documento índice se recomienda a todo Issuer y no es obligatorio ([Issuer y publicación](../issuer.md#용어-정의-문서)).

Ejemplo: LOCAL 7 dentro del documento `0x0000000000000002` del Issuer `0x00000002`

```
02F7 0000 0002 0000 0000 0000 0002 0007
```

## Quantifier {#quantifier}

| `C % 5` | Nombre | Significado | Ejemplo |
|---|---|---|---|
| `0` | Identified | Individuo identificado | Elon Musk, Corea del Sur |
| `1` | Generic | Enunciado general sobre toda una clase. Admite excepciones | Los soldados obedecen las órdenes |
| `2` | Free-choice | Cualquier objeto que cumpla la condición | Cualquier soldado |
| `3` | Universal | Todos los objetos del ámbito | Todos los soldados |
| `4` | Variable | Variable de discurso | esa persona, esta mujer |

- **La cuantificación solo se lee en el sistema 5Q (sistemas 1~11).** Con el desplazamiento dentro de la sección `C`, la cuantificación es `C % 5` cuando `5 <= C < 30` en la sección 0 y cuando `C < 30` en la sección 1. Como una sección tiene 32 casillas, dividir entre 5 la posición del Codec de 9 bits (`w >> 4`) desalinea la sección 1. Los marcadores (sección 0, `C < 3`) y la sección 2 (punteros, REFERENCE-ISSUER) no tienen cuantificación. El marcador `0x0010` UNKNOWN-VALUE no es Generic. La cuantificación de REFERENCE-ISSUER la fija el documento de Codec publicado por el Issuer.
- Generic, a diferencia de Universal, no significa que se aplique sin excepción a todo objeto individual. Una expresión definitoria como «qué es un soldado» puede escribirse como Generic. Si hace falta una definición estricta de concepto o clasificación, se concreta con una relación aparte.
- El alcance y la negación de la cuantificación los fija el Edge que la usa, no el Reference.
- **Variable** es un objeto del discurso cuyo tipo se conoce pero que aún no está identificado.
  - Una variable con nombre se escribe añadiendo Variable a LOCAL. El mismo LOCAL ID es la misma variable. El tipo se une con un Edge.
  - Una variable anónima se escribe añadiendo Variable a un Codec de declaración que señale el tipo (GEUL, WIKIDATA-*) (por ejemplo, «presidente» de Wikidata + Variable). No se sigue la correferencia y no se puede volver a señalar. Dos variables anónimas no se consideran la misma variable.
  - Cuando más tarde se confirma el objeto, la variable se une a ese objeto con `SAME-NODE`. Todas las expresiones que señalan la misma variable se interpretan a la vez como ese objeto.
  - Que dos variables sean distintas tampoco significa que los objetos reales sean distintos. Si son iguales se unen con `SAME-NODE`, y si son distintos, con `DIFFERENT-NODE`.
  - Variable en los Codec de designación externa (EXTERNAL-POINTER-*, EXTERNAL-ISSUER-*) es la variable LOCAL del documento señalado.
  - Ejemplo: en «El presidente dio un discurso», si la persona no está determinada, se usa Variable de «presidente». Para volver a mencionarla, se pone un LOCAL Variable y se une con un Edge al tipo «presidente». Si más tarde se confirma que es Obama, esa variable se une con `SAME-NODE` a Obama Identified. Todas las expresiones que señalan la misma variable se interpretan a la vez como Obama.
- Ejemplo: Q5 de Wikidata (ser humano) usado como Generic es `0151 0005` («el ser humano …»).

## REFERENCE-ISSUER {#reference-issuer}

REFERENCE-ISSUER es un formato de Reference definido por un Issuer. Son las tres últimas casillas de la zona Reference. Su layout es igual al de ISSUER de Value y Edge ([Registros y TAG WORD](../record.md#issuer-형식-레코드)).

### Layout {#레이아웃-1}

```
TAG WORD          0000 0101 11WW LLLL      Codec 0x05DL / 0x05EL / 0x05FL (WW = ancho del Issuer: 01 2, 10 4, 11 16 WORD)
[TAG de extensión de Length]
Issuer            2/4/16 WORD (el Codec fija el ancho)
Número de Codec   2 WORD. Lo define el Issuer
Payload           Lo fija el documento de Codec publicado por el Issuer
```

| Codec | Nombre | Ancho del Issuer |
|---|---|---|
| `0x05DL` | [REFERENCE-ISSUER-2WORD](0x05DL-reference-issuer-2word.md) | 2 WORD |
| `0x05EL` | [REFERENCE-ISSUER-4WORD](0x05EL-reference-issuer-4word.md) | 4 WORD |
| `0x05FL` | [REFERENCE-ISSUER-16WORD](0x05FL-reference-issuer-16word.md) | 16 WORD |

- Cada código tiene su página: [REFERENCE-ISSUER-2WORD](0x05DL-reference-issuer-2word.md), [REFERENCE-ISSUER-4WORD](0x05EL-reference-issuer-4word.md), [REFERENCE-ISSUER-16WORD](0x05FL-reference-issuer-16word.md).
- El documento de Codec del Issuer GEUL es uno por código y contiene tres FIELD: Issuer (2·4·16 WORD), número de Codec (2 WORD) y Payload (lo fija el Codec del Issuer).

### Interpretación y validez {#해석과-유효성}

- GEUL solo conoce por Length el límite del Payload. El Payload no se interpreta sin libro de códigos.
- El significado del número de Codec y la cuantificación los fija el Issuer. Lo que se señala también lo fija el documento de Codec publicado por el Issuer.
- No se aplican las reglas comunes de Reference: el ancho mínimo del ID de destino, la escritura en 1 WORD del ID de destino `0`, el Quantifier, la lectura de cuantificación y sistema por el desplazamiento dentro de la sección, la clasificación en declaración y designación, y lo que se señala.
- El número de Codec de 2 WORD es igual al del ISSUER de Value y Edge. Si los números no alcanzan, se obtiene otro Issuer.
- Un decodificador que no conoce el formato llega a conocer el Kind, el Length, el Issuer y el número de Codec, y salta con Length.
- La licencia de un formato de Issuer la fija ese Issuer ([Issuer y publicación](../issuer.md#라이선스)).

### Páginas relacionadas {#관련-페이지}

- [Registros y TAG WORD](../record.md), [Issuer y publicación](../issuer.md)
