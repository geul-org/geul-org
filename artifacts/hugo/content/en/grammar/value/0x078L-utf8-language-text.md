---
title: "UTF8-LANGUAGE-TEXT (0x078L·0x079L)"
weight: 120
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "UTF8-LANGUAGE-TEXT is language-tagged text that holds one language Value record and UTF-8 text in a single Value (Codec 0x078L/0x079L)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UTF8-LANGUAGE-TEXT is language-tagged text that holds one language Value record and UTF-8 text in a single Value (Codec 0x078L/0x079L).

| Item | Value |
|---|---|
| Name | `UTF8-LANGUAGE-TEXT` (even/odd pair. Names per code are in the member table below) |
| TAG ID | `0x078L`·`0x079L` |
| Section | 3 `0011` (Value), offset within section C = 24~25 |
| Kind | Value · family: TEXT |
| Index description | Language-tagged text. A language Value record (LANGUAGE-SHORT-CODE or LANGUAGE-BCP47-CODE) and UTF-8 bytes. Even/odd refers to the text bytes |
| Hugo path | `value/text/utf8-language-text.md` |

## Members {#구성원}

This page covers the two codes of an even/odd pair together. The even code is for values with an even byte count, the odd code for an odd byte count ([Record and TAG WORD](../record.md#가변-길이-바이트열)). There is one codec document per code. The fields of the two codec documents are the same; only the DECLARE target and the name (BIND) differ.

| TAG ID | Name | Byte count | Codec ID | Spec document | TAG WORD |
|---|---|---|---|---|---|
| `0x078L` | `UTF8-LANGUAGE-TEXT-EVEN` | even | `0x00000780` | `0x00000000/codecs/0x00000780/` | `0000 0111 1000 LLLL` |
| `0x079L` | `UTF8-LANGUAGE-TEXT-ODD` | odd | `0x00000790` | `0x00000000/codecs/0x00000790/` | `0000 0111 1001 LLLL` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs in the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `language` | #2 | record | `07A0` LANGUAGE-SHORT-CODE, `0760` LANGUAGE-BCP47-CODE-EVEN, `0770` LANGUAGE-BCP47-CODE-ODD |  |
| 2 | `bytes` | #3 | remaining raw bytes (`0xFFFF`) |  |  |

UTF8-LANGUAGE-TEXT is language-tagged text. It holds one language Value record and a UTF-8 byte sequence in a single Value.

[UTF8-TEXT](0x072L-utf8-text.md) is a string with no language (identifier, code, file name, raw bytes), while this format is text with a language (name, title, slogan, sentence). The two are different values even if the bytes are the same. "Paris" (string) and "Paris" (French) are not equal. This is the same as RDF separating `xsd:string` from `rdf:langString`.

## Layout {#레이아웃}

- Code: Value direct codes `0x078L` (text with even bytes) and `0x079L` (text with odd bytes). Family TEXT.

```
TAG WORD          0000 0111 100P LLLL      Codec 0x078L/0x079L (P = text has odd bytes)
[Length extension TAG] when the total is 15 WORDs or more
Language          one LANGUAGE-SHORT-CODE or LANGUAGE-BCP47-CODE Value record (including TAG)
Text WORD 1st ... Nth             UTF-8 bytes / last 0x00 if odd
```

## Interpretation and validity {#해석과-유효성}

- The Payload starts with a language record. Read the first Payload WORD as a TAG; its Length is the language record, and the rest is the text bytes. The language record is required. If there is no language, use UTF8-TEXT instead of this format.
- The language record is exactly one complete [LANGUAGE-SHORT-CODE](0x07AL-language-short-code.md) (`0x07AL`) or [LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md) (`0x076L`·`0x077L`) record. A different Codec or an incomplete record is invalid. The validity of the language record follows the rules of its format.
- Both language formats may be used. The rule for comparing whether two are the same language is the same as for [LABEL](../edge/0x0A4L-label.md). A SHORT-CODE and the BCP 47 tag that the registry binds to that number are the same language.
- `zxx` (no linguistic content) is not used. Such a string is UTF8-TEXT. `und` (undetermined language) and `mul` (multiple languages) are text with a language, so they may be used.
- The text bytes follow the same rules as UTF8-TEXT. They must be well-formed UTF-8, a leading U+FEFF is allowed as a character, normalization is not enforced, and the original is preserved as is. The side that compares and indexes aligns to NFC when comparing.
- The text byte count is `2 × (Payload WORD count − language record WORD count) − P`. P (the least significant bit of the Codec) indicates only the parity of the text bytes. If odd, the lower byte of the last WORD must be `00`.
- Empty text (0 bytes) is the even code with only the language record.

## Where to use {#쓰는-곳}

- Wikidata monolingualtext values: `{"text":"Bundesrepublik Deutschland","language":"de"}` becomes a single value of this format. It goes as is into the Object of [TRIPLE](../edge/0x0AAL-triple.md) and the Value of [QUALIFIER](../edge/0x0ABL-qualifier.md). The property, rank, and qualifiers are handled by TRIPLE.
- The Object of [LABEL](../edge/0x0A4L-label.md) and [ALIAS](../edge/0x0A5L-alias.md). This one value holds both the name and the language.
- Text whose language is fixed, such as titles of statutes and papers.

## Language code mapping (Wikidata) {#언어-코드-대응-위키데이터}

- Not all Wikidata and Wikimedia language codes are BCP 47 (for example, `simple`, `map-bms`). They are mapped to BCP 47 tags by a mapping table. Codes that cannot be mapped are handled differently depending on use.
  - Values (monolingualtext): preserve the original datavalue as UTF8-TEXT. A value is part of the statement, so dropping it changes the statement.
  - Labels, descriptions, aliases: skip them and note them in the report. These Edges only hold with a language (text without a language is invalid), and the original remains in the source data.
- If the mapped tag has a number in the GEUL Language Registry, write it as LANGUAGE-SHORT-CODE; otherwise, as LANGUAGE-BCP47-CODE.

## Length {#길이}

- The total is the sum of the TAG 1 WORD, the Length extension TAG (if present), the language record, and the text WORDs. 14 WORDs or fewer use a direct length; 15 WORDs or more use an extended length ([Length](../record.md)).
- The language record is 2 WORDs for a SHORT-CODE, and `ceil(tag bytes/2) + 1` WORDs for BCP 47 (`de` is 2 WORDs, `zh-Hant` is 5 WORDs).

## Examples {#예시}

The languages are all examples in the LANGUAGE-BCP47-CODE form. `fr`, `ko`, and `de` have registry numbers, so they can also be written as SHORT-CODE (2 WORDs).

| Value | Text bytes | Total WORDs |
|---|---|---|
| "Paris" (fr) | 5 (odd) | `0795 0761 6672 5061 7269 7300` |
| "" (ko) | 0 | `0782 0761 6B6F` |
| "Bundesrepublik Deutschland" (de) | 26 (even) | `078E 0011 0761 6465 4275 6E64 6573 7265 7075 626C 696B 2044 6575 7473 6368 6C61 6E64` |

- "Paris": TAG `0795` (Codec `0x079L`, `LLLL=0101`, 6 WORDs in total), language `0761 6672` (BCP 47 `fr`), text `5061 7269 7300` (5 bytes, last `00`).
- The third is 17 WORDs in total, so it uses a Length extension (`LLLL=1110` in `078E`, extension TAG `0011`).

## Standards basis {#표준-근거}

- Language tag: [RFC 5646 (BCP 47)](https://www.rfc-editor.org/rfc/rfc5646). `zxx`, `und`, and `mul` are special codes of the IANA Language Subtag Registry.
- Text: [RFC 3629](https://www.rfc-editor.org/rfc/rfc3629).
- Distinction between a string and language-tagged text: [RDF 1.1 Concepts — language-tagged string](https://www.w3.org/TR/rdf11-concepts/#dfn-language-tagged-string).

## Open problems {#열린-문제}

- BCP 47 tag grammar checking in the schema. For now it checks only that the tag is ASCII and non-empty.

## Related pages {#관련-페이지}

- [Value](_index.md), [UTF8-TEXT](0x072L-utf8-text.md), [LANGUAGE-SHORT-CODE](0x07AL-language-short-code.md), [LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md), [LABEL](../edge/0x0A4L-label.md)

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00000780/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000078000000000
BODY
#1 DECLARE 0x0780
#2 FIELD #1 record
#3 FIELD #1 rest
#4 BIND #1 "UTF8-LANGUAGE-TEXT-EVEN"
#5 BIND #2 "language"
#6 BIND #3 "bytes"
#7 CODEC #2 0x07A0
#8 CODEC #2 0x0760
#9 CODEC #2 0x0770
```

The above is the codec document of `UTF8-LANGUAGE-TEXT-EVEN` (`0x078L`). The codec document of the other member (`UTF8-LANGUAGE-TEXT-ODD`) differs only in the codec ID in the DOC-ID, the DECLARE target, and the name bound to `#1` (BIND).
