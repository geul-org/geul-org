---
title: "LABEL"
weight: 5
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T23:00:00+09:00
tags: ["grammar", "edge"]
summary: "LABEL es un Edge de afirmación que conecta un nombre por idioma del objeto Subject mediante un Object UTF8-LANGUAGE-TEXT (Codec 0x04)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LABEL es un Edge de afirmación que conecta como Object un nombre (label) en un idioma concreto del objeto Subject. Codec `0x04`. No es un Edge que represente el lema (lemma) de la lexicografía general.

El nombre y su idioma van en un solo Object, [UTF8-LANGUAGE-TEXT](/es/grammar/value/text/utf8-language-text/). No hay campos de valor crudo.

## Layout

```
TAG WORD          0001 0LLL L000 0100
[TAG de extensión de Length]
Edge Id           registro Reference LOCAL
Subject           1 registro Reference
Object            Value UTF8-LANGUAGE-TEXT o 1 registro Reference LOCAL
```

## Interpretación y validez

- Subject es exactamente un registro Reference completo. La frontera se halla con la Length del propio Subject; si no es un Reference o está incompleto, es inválido.
- Object es exactamente un registro [UTF8-LANGUAGE-TEXT](/es/grammar/value/text/utf8-language-text/) (`0x4A`, `0x4B`) completo. Las reglas del idioma y del texto (se admiten ambos formatos de idioma, comparación de un mismo idioma) siguen a ese formato.
- Object también puede ser un Reference LOCAL. En ese caso debe resolverse en UTF8-LANGUAGE-TEXT mediante un enlace [REFERENCE-NODE](/es/grammar/edge/reference-node/) del mismo documento. Si no se resuelve, o se resuelve en otra clase de objeto, es inválido.
- El documento de especificación de geul.org anota esta restricción con [CODEC](/es/grammar/edge/codec/) (Object = `084A`, `084B`, `0008`). El destino al que se resuelve el LOCAL no se expresa con CODEC.
- Si Object no es ninguno de los dos formatos anteriores, o el registro está incompleto, es inválido. Un texto sin idioma (UTF8-TEXT) no puede ser LABEL. Un nombre para máquinas sin idioma se escribe con [BIND](/es/grammar/edge/bind/). Un nombre común a varios idiomas se escribe con el idioma `mul`.
- Un Subject e idioma tienen como mucho un LABEL. Los demás nombres se escriben con [ALIAS](/es/grammar/edge/alias/).

## Longitud

```
total = 1 + N_len + N_id + N_subject + N_object WORD
```

- El registro de idioma de Object y el número de bytes del texto corren a cargo del registro Object, no del Edge. El cursor tras leer el último registro debe coincidir exactamente con el final del Edge.

## Ejemplo (no normativo)

El código de idioma `0784` de `en` es el número en el GEUL Language Registry v2 (documento de especificación `0x0000/0x0000000000000848` versión 2).

### LANGUAGE-SHORT-CODE

Edge Id `0007`, Subject Q22686 (`00A0 589e`), Object `Donald Trump` (en).

- Object es idioma `08C8 0784` (SHORT-CODE, 2 WORD) + texto de 12 byte (par, 6 WORD), por lo que es `UTF8-LANGUAGE-TEXT-EVEN` (`0x4A`), 9 WORD en total: `0C4A 08C8 0784 446f 6e61 6c64 2054 7275 6d70`.
- El Edge es TAG 1 + Edge Id 2 + Subject 2 + Object 9 = 14 WORD, `LLLL=1101`. El TAG es `1684`.

```
1684 0088 0007 00A0 589e 0C4A 08C8 0784 446f 6e61 6c64 2054 7275 6d70
```

### LANGUAGE-BCP47-CODE

Edge Id `0008`, Subject Q155 (`00A0 009b`), Object `Brasil` (pt-BR).

- Object es idioma `09C7 7074 2d42 5200` (BCP47 `pt-BR`, 4 WORD) + texto de 6 byte (par, 3 WORD), 8 WORD en total: `0BCA 09C7 7074 2d42 5200 4272 6173 696c`.
- El Edge es TAG 1 + Edge Id 2 + Subject 2 + Object 8 = 13 WORD, `LLLL=1100`. El TAG es `1604`.

```
1604 0088 0008 00A0 009b 0BCA 09C7 7074 2d42 5200 4272 6173 696c
```

## Páginas relacionadas

- [Edge](/es/grammar/edge/), [ALIAS](/es/grammar/edge/alias/), [DESCRIPTION](/es/grammar/edge/description/), [BIND](/es/grammar/edge/bind/)
- [UTF8-LANGUAGE-TEXT](/es/grammar/value/text/utf8-language-text/), [LANGUAGE-SHORT-CODE](/es/grammar/value/text/language-short-code/), [LANGUAGE-BCP47-CODE](/es/grammar/value/text/language-bcp47-code/)
- [LOCAL](/es/grammar/reference/local/), [REFERENCE-NODE](/es/grammar/edge/reference-node/)
