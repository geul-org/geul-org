---
title: "DESCRIPTION"
weight: 7
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T23:00:00+09:00
tags: ["grammar", "edge"]
summary: "DESCRIPTION is a description Edge that links one short per-language description of the Subject target (Codec 0x06). Its layout is the same as LABEL."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIPTION is a description Edge that links a description of the Subject target in a particular language as its Object. Codec `0x06`.

A description is a short phrase that distinguishes the target (Wikidata description, for example "capital and largest city of Germany"). It is not a definition or claim about the target. A proposition about the target is written as a [TRIPLE](/grammar/edge/triple/). The layout is the same as [LABEL](/grammar/edge/label/). The description and its language are held in one Object, [UTF8-LANGUAGE-TEXT](/grammar/value/text/utf8-language-text/). There are no raw-value fields.

## Layout

```
TAG WORD          0001 0LLL L000 0110
[Length extension TAG]
Edge Id           LOCAL Reference record
Subject           one Reference record
Object            one UTF8-LANGUAGE-TEXT Value or LOCAL Reference record
```

## Interpretation and Validity

- The rules for Subject and Object are the same as [LABEL](/grammar/edge/label/). Subject is exactly one complete Reference record. Object is exactly one complete UTF8-LANGUAGE-TEXT (`0x4A`, `0x4B`) record, or a LOCAL Reference that resolves to a UTF8-LANGUAGE-TEXT through a [REFERENCE-NODE](/grammar/edge/reference-node/) binding in the same document.
- Text with no language (UTF8-TEXT) cannot be a DESCRIPTION. A description is one per language, so the rule only holds if there is a language. A description common to several languages is written with the language `mul`.
- There is at most one DESCRIPTION per Subject and language.
- A description is used to tell a target apart from another target with the same name. It is better that the LABEL and DESCRIPTION pair in the same language does not overlap between two targets, but the specification does not check this (Wikidata also only recommends it and does not enforce it).
- A geul.org specification document restricts Object to [CODEC](/grammar/edge/codec/) (`084A`, `084B`, `0008`, the same as LABEL).

## Length

```
total = 1 + N_len + N_id + N_subject + N_object WORDs
```

- The language record and the text byte count of Object are handled by the Object record. The cursor after reading all of the last record must match the end of the Edge exactly.
- A description is longer than a label, so both Object and Edge easily exceed 15 WORDs. In that case, use the Length extension ([Records](/grammar/record/)).

## Example (non-normative)

Edge Id `0009`, Subject Q64 (`00A0 0040`), Object `capital and largest city of Germany` (en). The language is an example of the LANGUAGE-BCP47-CODE format (`en` has the registry number `0x0784`, so it can also be written as SHORT-CODE).

- Object is the language `08C6 656E` (BCP47 `en`, 2 WORDs) + text of 35 bytes (odd, 18 WORDs), so `0x4B`, TAG 1 + extension TAG 1 + 20 = 22 WORDs, `0F4B 0016 …`.
- The Edge is TAG 1 + extension TAG 1 + Edge Id 2 + Subject 2 + Object 22 = 28 WORDs, so `LLLL=1110`, TAG `1706`, extension TAG `001C`.

```
1706 001C 0088 0009 00A0 0040
0F4B 0016 08C6 656E 6361 7069 7461 6C20 616E 6420 6C61 7267 6573 7420 6369 7479 206F 6620 4765 726D 616E 7900
```

## Wikidata Correspondence

- An item's `descriptions` (one per language) → one DESCRIPTION per language. The language code is carried over with the same language code mapping table as LABEL.

## Open Questions

- Whether there is a case that would allow a description in language-less UTF8-TEXT (it is not allowed now).

## Related Pages

- [Edge](/grammar/edge/), [LABEL](/grammar/edge/label/), [ALIAS](/grammar/edge/alias/), [CODEC](/grammar/edge/codec/)
- [UTF8-LANGUAGE-TEXT](/grammar/value/text/utf8-language-text/), [LOCAL](/grammar/reference/local/), [REFERENCE-NODE](/grammar/edge/reference-node/)
