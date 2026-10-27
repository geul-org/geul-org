---
title: "ALIAS"
weight: 6
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "ALIAS is a description Edge that links one other name (alias) of the Subject target (Codec 0x05). Its layout is the same as LABEL."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ALIAS is a description Edge that links one other name (alias) of the Subject target as its Object. Codec `0x05`.

[LABEL](/grammar/edge/label/) is the representative name in that language (at most one per language), and ALIAS is another name for the same target (several per language, like Wikidata "also known as"). It is used mainly for search. The layout and validity are the same as LABEL.

## Layout

```
TAG WORD          0001 0LLL L000 0101
[Length extension TAG]
Edge Id           LOCAL Reference record
Subject           one Reference record
Object            one UTF8-LANGUAGE-TEXT Value or LOCAL Reference record
```

## Interpretation and Validity

- The rules for Subject and Object are the same as [LABEL](/grammar/edge/label/) (Object is [UTF8-LANGUAGE-TEXT](/grammar/value/text/utf8-language-text/) or a LOCAL that resolves to it).
- Several ALIASes can be placed on the same Subject and language. The order is the order in the document.
- The same text as the LABEL of the same Subject and language is not placed as an ALIAS (one LABEL is enough for the representative name). This rule is a recommendation.
- A geul.org specification document restricts Object to [CODEC](/grammar/edge/codec/) (`084A`, `084B`, `0008`, the same as LABEL).

## Example (non-normative)

Edge Id `0003`, Subject Q42 (`00A0 002a`), Object `DNA` (en): the language `08C6 656e` (BCP47 `en`) + text of 3 bytes (odd) → `UTF8-LANGUAGE-TEXT-ODD` (`0x4B`), `0A4B 08C6 656e 444e 4100`.

- TAG 1 + Edge Id 2 + Subject 2 + Object 5 = 10 WORDs, `LLLL=1001`. The TAG is `1485`.

```
1485 0088 0003 00A0 002a 0A4B 08C6 656e 444e 4100
```

## Related Pages

- [Edge](/grammar/edge/), [LABEL](/grammar/edge/label/), [DESCRIPTION](/grammar/edge/description/), [UTF8-LANGUAGE-TEXT](/grammar/value/text/utf8-language-text/)
