---
title: "ALIAS"
weight: 6
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "ALIAS est un Edge de description (Codec 0x05) qui rattache un autre nom (alias) à la cible du Subject. Sa disposition est identique à celle de LABEL."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ALIAS est un Edge de description qui rattache comme Object un autre nom (alias) à la cible du Subject. Codec `0x05`.

[LABEL](/fr/grammar/edge/label/) est le nom représentatif dans cette langue (au plus un par langue), tandis qu'ALIAS est un autre nom de la même cible (plusieurs par langue, « also known as » de Wikidata). Il sert surtout à la recherche. La disposition et la validité sont celles de LABEL.

## Disposition

```
TAG WORD          0001 0LLL L000 0101
[TAG d'extension de Length]
Edge Id           enregistrement Reference LOCAL
Subject           1 enregistrement Reference
Object            Value UTF8-LANGUAGE-TEXT ou 1 enregistrement Reference LOCAL
```

## Interprétation et validité

- Les règles de Subject et d'Object sont celles de [LABEL](/fr/grammar/edge/label/) (Object est [UTF8-LANGUAGE-TEXT](/fr/grammar/value/text/utf8-language-text/) ou un LOCAL qui s'y résout).
- On peut placer plusieurs ALIAS pour un même Subject et une même langue. L'ordre est celui du document.
- On ne place pas en ALIAS le même texte que le LABEL du même Subject et de la même langue (le nom représentatif tient dans un seul LABEL). Cette règle est une recommandation.
- Le document de spécification de geul.org limite Object par [CODEC](/fr/grammar/edge/codec/) (`084A`, `084B`, `0008`, comme LABEL).

## Exemple (non normatif)

Edge Id `0003`, Subject Q42 (`00A0 002a`), Object `DNA` (en) : langue `08C6 656e` (BCP47 `en`) + texte de 3 octets (impair) → `UTF8-LANGUAGE-TEXT-ODD` (`0x4B`), `0A4B 08C6 656e 444e 4100`.

- TAG 1 + Edge Id 2 + Subject 2 + Object 5 = 10 WORD, `LLLL=1001`. Le TAG est `1485`.

```
1485 0088 0003 00A0 002a 0A4B 08C6 656e 444e 4100
```

## Pages liées

- [Edge](/fr/grammar/edge/), [LABEL](/fr/grammar/edge/label/), [DESCRIPTION](/fr/grammar/edge/description/), [UTF8-LANGUAGE-TEXT](/fr/grammar/value/text/utf8-language-text/)
