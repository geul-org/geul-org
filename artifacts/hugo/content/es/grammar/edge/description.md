---
title: "DESCRIPTION"
weight: 7
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DESCRIPTION es un Edge de afirmación que conecta una descripción corta por idioma del objeto Subject (Codec 0x06). Su layout es igual al de LABEL."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIPTION es un Edge de afirmación que conecta como Object una descripción en un idioma concreto del objeto Subject. Codec `0x06`.

La descripción es una frase corta que distingue al objeto (description de Wikidata, por ejemplo "capital y mayor ciudad de Alemania"). No es una definición ni una tesis sobre el objeto. Las proposiciones sobre el objeto se escriben con [TRIPLE](/es/grammar/edge/triple/). El layout es igual al de [LABEL](/es/grammar/edge/label/). La descripción y su idioma van en un solo Object, [UTF8-LANGUAGE-TEXT](/es/grammar/value/text/utf8-language-text/). No hay campos de valor crudo.

## Layout

```
TAG WORD          0001 0LLL L000 0110
[TAG de extensión de Length]
Edge Id           registro Reference LOCAL
Subject           1 registro Reference
Object            Value UTF8-LANGUAGE-TEXT o 1 registro Reference LOCAL
```

## Interpretación y validez

- Las reglas de Subject y Object son las de [LABEL](/es/grammar/edge/label/). Subject es exactamente un registro Reference completo. Object es exactamente un registro UTF8-LANGUAGE-TEXT (`0x4A`, `0x4B`) completo, o un Reference LOCAL que se resuelve en UTF8-LANGUAGE-TEXT mediante un enlace [REFERENCE-NODE](/es/grammar/edge/reference-node/) del mismo documento.
- Un texto sin idioma (UTF8-TEXT) no puede ser DESCRIPTION. Hay una descripción por idioma, y esa regla solo se sostiene si hay idioma. Una descripción común a varios idiomas se escribe con el idioma `mul`.
- Un Subject e idioma tienen como mucho una DESCRIPTION.
- La descripción sirve para distinguir objetos con el mismo nombre. Conviene que el par LABEL y DESCRIPTION de un mismo idioma no se repita en dos objetos, pero la especificación no lo comprueba (tampoco Wikidata lo impone; es solo una recomendación).
- El documento de especificación de geul.org limita Object a [CODEC](/es/grammar/edge/codec/) (`084A`, `084B`, `0008`, igual que LABEL).

## Longitud

```
total = 1 + N_len + N_id + N_subject + N_object WORD
```

- El registro de idioma de Object y el número de bytes del texto corren a cargo del registro Object. El cursor tras leer el último registro debe coincidir exactamente con el final del Edge.
- La descripción es más larga que la etiqueta, por lo que tanto Object como el Edge pasan fácilmente de 15 WORD. En ese caso se usa la extensión de Length ([Registro](/es/grammar/record/)).

## Ejemplo (no normativo)

Edge Id `0009`, Subject Q64 (`00A0 0040`), Object `capital and largest city of Germany` (en). El idioma es LANGUAGE-BCP47-CODE, por ser anterior al registro.

- Object es idioma `08C6 656E` (BCP47 `en`, 2 WORD) + texto de 35 byte (impar, 18 WORD), por lo que es `0x4B`, TAG 1 + TAG de extensión 1 + 20 = 22 WORD, `0F4B 0016 …`.
- El Edge es TAG 1 + TAG de extensión 1 + Edge Id 2 + Subject 2 + Object 22 = 28 WORD, así que `LLLL=1110`, TAG `1706`, TAG de extensión `001C`.

```
1706 001C 0088 0009 00A0 0040
0F4B 0016 08C6 656E 6361 7069 7461 6C20 616E 6420 6C61 7267 6573 7420 6369 7479 206F 6620 4765 726D 616E 7900
```

## Correspondencia con Wikidata

- Las `descriptions` de un elemento (una por idioma) → una DESCRIPTION por idioma. El código de idioma se traslada con la misma tabla de correspondencia de códigos de idioma que LABEL.

## Problemas abiertos

- Si hay casos en que convenga permitir descripciones UTF8-TEXT sin idioma (por ahora no se permiten).

## Páginas relacionadas

- [Edge](/es/grammar/edge/), [LABEL](/es/grammar/edge/label/), [ALIAS](/es/grammar/edge/alias/), [CODEC](/es/grammar/edge/codec/)
- [UTF8-LANGUAGE-TEXT](/es/grammar/value/text/utf8-language-text/), [LOCAL](/es/grammar/reference/local/), [REFERENCE-NODE](/es/grammar/edge/reference-node/)
