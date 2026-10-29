---
title: "UTF8-LANGUAGE-TEXT"
weight: 75
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T23:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "UTF8-LANGUAGE-TEXT is text with a language, holding one language Value record and UTF-8 text in one Value (Codec 0x4A/0x4B)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UTF8-LANGUAGE-TEXT is text with a language. It holds one language Value record and a UTF-8 byte sequence in one Value.

[UTF8-TEXT](/grammar/value/text/utf8-text/) is a string with no language (identifiers, codes, file names, source bytes), and this format is text with a language (names, titles, slogans, sentences). The two are different values even if the bytes are the same. "Paris" (a string) and "Paris" (French) are not equal. This is the same as RDF separating `xsd:string` and `rdf:langString`.

## Layout

- Code: Value direct codes `0x4A` (text of even bytes) and `0x4B` (text of odd bytes). Family TEXT.

```
TAG WORD          0000 1LLL L100 101P      Codec 0x4A/0x4B (P = the text has an odd byte count)
[Length extension TAG] when the total is 15 WORD or more
Language          one LANGUAGE-SHORT-CODE or LANGUAGE-BCP47-CODE Value record (including its TAG)
Text WORD 1st ... Nth             UTF-8 bytes / a trailing 0x00 if odd
```

## Interpretation and Validity

- The Payload starts with the language record. Read the first Payload WORD as a TAG; the language record is that Length, and the rest is the text bytes. The language record is required. If there is no language, use UTF8-TEXT, not this format.
- The language record is exactly one complete [LANGUAGE-SHORT-CODE](/grammar/value/text/language-short-code/) (`0x48`) or [LANGUAGE-BCP47-CODE](/grammar/value/text/language-bcp47-code/) (`0x46`, `0x47`) record. If it is another Codec or incomplete, it is invalid. The validity of the language record follows the rules of that format.
- Both language formats can be used. The rule for comparing whether languages are the same is the same as [LABEL](/grammar/edge/label/). A SHORT-CODE and the BCP 47 tag the registry binds to its number are the same language.
- `zxx` (no linguistic content) is not used. Such a string is UTF8-TEXT. `und` (undetermined language) and `mul` (multiple languages) are text with a language, so they can be used.
- The text bytes follow the same rules as UTF8-TEXT. They must be well-formed UTF-8, a leading BOM is forbidden, no normalization is enforced, and the original is preserved as it is. The side that compares and indexes aligns to NFC to compare.
- The text byte count is `2 × (Payload WORD count − language record WORD count) − P`. P (the lowest bit of the Codec) only indicates whether the text bytes are odd or even. If odd, the lower byte of the last WORD must be `00`.
- Empty text (0 bytes) places only the language record, with the even code.

## Where It Is Used

- Wikidata monolingualtext values: `{"text":"Bundesrepublik Deutschland","language":"de"}` becomes this one format. It goes as is into the Object of a [TRIPLE](/grammar/edge/triple/) or the Value of a [QUALIFIER](/grammar/edge/qualifier/). The property, rank, and qualifiers are handled by the TRIPLE.
- The Object of [LABEL](/grammar/edge/label/) and [ALIAS](/grammar/edge/alias/). This one value holds the name and the language.
- Text whose language is fixed, such as titles of statutes and papers.

## Language Code Mapping (Wikidata)

- Not all Wikidata and Wikimedia language codes are BCP 47 (for example, `simple`, `map-bms`). They are carried over to BCP 47 tags with a mapping table. Codes that cannot be carried over are handled differently depending on use.
  - Values (monolingualtext): preserve the datavalue original as UTF8-TEXT. A value is part of the proposition, so dropping it changes the proposition.
  - Labels, descriptions, aliases: skip them and note them in the report. These Edges hold only with a language (text with no language is invalid), and the original remains in the source data.
- If the mapped tag has a number in the GEUL Language Registry, LANGUAGE-SHORT-CODE is used; otherwise LANGUAGE-BCP47-CODE.

## Length

- The total is the sum of the TAG 1 WORD, the Length extension TAG (if any), the language record, and the text WORDs. 14 WORDs or fewer use a direct length, and 15 WORDs or more use an extended length ([Length](/grammar/record/)).
- The language record is 2 WORD for a SHORT-CODE, and `ceil(tag bytes/2) + 1` WORD for BCP 47 (`de` 2 WORD, `zh-Hant` 5 WORD).

## Examples

The languages are all examples of the LANGUAGE-BCP47-CODE format. `fr`, `ko` and `de` have registry numbers, so they can also be written as SHORT-CODE (2 WORDs).

| Value | Text bytes | Whole WORDs |
|---|---|---|
| "Paris" (fr) | 5 (odd) | `0ACB 08C6 6672 5061 7269 7300` |
| "" (ko) | 0 | `094A 08C6 6B6F` |
| "Bundesrepublik Deutschland" (de) | 26 (even) | `0F4A 0011 08C6 6465 4275 6E64 6573 7265 7075 626C 696B 2044 6575 7473 6368 6C61 6E64` |

- "Paris": TAG `0ACB` (Codec `0x4B`, `LLLL=0101`, 6 WORD in total), language `08C6 6672` (BCP 47 `fr`), text `5061 7269 7300` (5 bytes, final `00`).
- The third is 17 WORD in total, so it uses the Length extension (`LLLL=1110` of `0F4A`, extension TAG `0011`).

## Standards Basis

- Language tags: [RFC 5646 (BCP 47)](https://www.rfc-editor.org/rfc/rfc5646). `zxx`, `und`, and `mul` are special codes of the IANA Language Subtag Registry.
- Text: [RFC 3629](https://www.rfc-editor.org/rfc/rfc3629).
- The distinction between a string and text with a language: [RDF 1.1 Concepts — language-tagged string](https://www.w3.org/TR/rdf11-concepts/#dfn-language-tagged-string).

## Open Questions

- Checking the BCP 47 tag grammar in the schema. For now it only checks that it is ASCII and non-empty.

## Related Pages

- [Value](/grammar/value/), [UTF8-TEXT](/grammar/value/text/utf8-text/), [LANGUAGE-SHORT-CODE](/grammar/value/text/language-short-code/), [LANGUAGE-BCP47-CODE](/grammar/value/text/language-bcp47-code/), [LABEL](/grammar/edge/label/)
