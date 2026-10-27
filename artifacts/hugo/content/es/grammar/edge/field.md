---
title: "FIELD"
weight: 29
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "FIELD es un Edge de afirmación que declara un campo del Payload de un Codec (Codec 0x1C). Anota el DECLARE al que pertenece y el ancho (registro, valor crudo de n WORD, valor crudo restante)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

FIELD es un Edge de afirmación que declara un campo del Payload de un Codec. Codec `0x1C`.

FIELD apunta a su propio [DECLARE](/es/grammar/edge/declare/). Los FIELD que apuntan a un mismo DECLARE componen el Payload en el orden en que aparecen en el documento. El layout viene integrado en el decodificador ([Documento de especificación de Codec](/es/grammar/codec-spec/)).

## Layout

```
TAG WORD          0001 0LLL L001 1100
Edge Id           registro Reference LOCAL
DECLARE           registro Reference LOCAL. El Edge DECLARE al que pertenece este campo
Ancho             1 WORD. 0 = registro, n (1~65534) = valor crudo de n WORD, 0xFFFF = valor crudo restante
```

## Interpretación y validez

- DECLARE apunta a un Edge DECLARE del mismo documento. Un FIELD pertenece a un solo DECLARE. El orden no se anota aparte; es el orden en que los registros FIELD aparecen en el documento.
- El documento de especificación de FIELD declara DECLARE como un campo de ancho `0` (registro), CODEC `0008` (LOCAL). Por eso en el grafo del visor se dibuja como una conexión FIELD → DECLARE.
- El ancho `0` es un campo de registro. Empieza con un TAG WORD y se lee tanto como indique la Length de ese TAG (reglas de interpretación de [DECLARE](/es/grammar/edge/declare/)).
- El ancho `n` (1~65534) es un campo de valor crudo. Siempre son exactamente n WORD.
- El ancho `0xFFFF` es el valor crudo restante. Solo se pone uno en un DECLARE, y puede estar al principio, en medio o al final. Su ancho es lo que queda de WORD, según la Length del TAG del registro exterior, menos los anchos de los campos posteriores. Por eso todos los campos posteriores al campo restante deben ser valores crudos de ancho fijo (un registro solo se sabe dónde acaba leyéndolo desde el principio). Puede ser de 0 WORD. No se le pone ENUM.
- El Kind y Codec que acepta el campo se designan con [CODEC](/es/grammar/edge/codec/). Un campo de registro sin CODEC acepta cualquier registro, y con CODEC debe ser uno de ellos. Si a un campo de valor crudo se le pone un CODEC, ese valor crudo se interpreta como ese Value sin el TAG.
- El nombre del campo se liga al Edge Id de FIELD con [BIND](/es/grammar/edge/bind/) (por ejemplo, `doc`, `hash`). Todo UTF8-TEXT que se pone a DECLARE, FIELD, ENUM y CODEC se hace con BIND, y no se pone con otros Edge como LABEL.
- El significado de los valores de código de un campo de valor crudo se añade con [ENUM](/es/grammar/edge/enum/).
- Un campo que en el grafo apunta a otro nodo no lleva marca aparte. Si el campo de registro es un Reference, esa es la conexión.

## Longitud

```
total = 1 + 2 + 2 + 1 WORD   (cuando Edge Id y DECLARE son IDs LOCAL de 1 WORD)
```

## Ejemplo (no normativo)

- Campo de registro: Edge Id 7, DECLARE #1, ancho `0`. TAG 1 + Edge Id 2 + DECLARE 2 + ancho 1 = 6 WORD. Para que acepte solo LOCAL, véase el ejemplo de [CODEC](/es/grammar/edge/codec/).

```
129C 0088 0007 0088 0001 0000
```

- Para un campo de valor crudo, como un hash de contenido, véase el ejemplo de [DECLARE](/es/grammar/edge/declare/).

## Páginas relacionadas

- [DECLARE](/es/grammar/edge/declare/), [ENUM](/es/grammar/edge/enum/), [CODEC](/es/grammar/edge/codec/), [BIND](/es/grammar/edge/bind/)
- [Documento de especificación de Codec](/es/grammar/codec-spec/)
