---
title: "ALIAS"
weight: 6
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "ALIAS es un Edge de afirmación que conecta otro nombre (alias) del objeto Subject (Codec 0x05). Su layout es igual al de LABEL."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ALIAS es un Edge de afirmación que conecta como Object otro nombre (alias) del objeto Subject. Codec `0x05`.

[LABEL](/es/grammar/edge/label/) es el nombre principal en ese idioma (como mucho uno por idioma) y ALIAS es otro nombre del mismo objeto (varios por idioma; el "also known as" de Wikidata). Se usa sobre todo en la búsqueda. El layout y la validez son los mismos que en LABEL.

## Layout

```
TAG WORD          0001 0LLL L000 0101
[TAG de extensión de Length]
Edge Id           registro Reference LOCAL
Subject           1 registro Reference
Object            Value UTF8-LANGUAGE-TEXT o 1 registro Reference LOCAL
```

## Interpretación y validez

- Las reglas de Subject y Object son las de [LABEL](/es/grammar/edge/label/) (Object es [UTF8-LANGUAGE-TEXT](/es/grammar/value/text/utf8-language-text/) o un LOCAL que se resuelve en él).
- Se pueden poner varios ALIAS para el mismo Subject e idioma. El orden es el orden dentro del documento.
- No se pone como ALIAS el mismo texto que el LABEL del mismo Subject e idioma (para el nombre principal basta un LABEL). Esta regla es una recomendación.
- El documento de especificación de geul.org limita Object a [CODEC](/es/grammar/edge/codec/) (`084A`, `084B`, `0008`, igual que LABEL).

## Ejemplo (no normativo)

Edge Id `0003`, Subject Q42 (`00A0 002a`), Object `DNA` (en): idioma `08C6 656e` (BCP47 `en`) + texto de 3 byte (impar) → `UTF8-LANGUAGE-TEXT-ODD` (`0x4B`), `0A4B 08C6 656e 444e 4100`.

- TAG 1 + Edge Id 2 + Subject 2 + Object 5 = 10 WORD, `LLLL=1001`. El TAG es `1485`.

```
1485 0088 0003 00A0 002a 0A4B 08C6 656e 444e 4100
```

## Páginas relacionadas

- [Edge](/es/grammar/edge/), [LABEL](/es/grammar/edge/label/), [DESCRIPTION](/es/grammar/edge/description/), [UTF8-LANGUAGE-TEXT](/es/grammar/value/text/utf8-language-text/)
