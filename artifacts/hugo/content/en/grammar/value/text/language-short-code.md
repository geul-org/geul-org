---
title: "LANGUAGE-SHORT-CODE"
weight: 73
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T23:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-SHORT-CODE is a GEUL language code Value that holds, in 1 WORD, one BCP 47 tag numbered by the GEUL Language Registry (Codec 0x48). The registry is the ENUMs of this Codec's spec document."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LANGUAGE-SHORT-CODE is a GEUL compressed language code that holds, in 1 WORD, one BCP 47 tag that has a number in the GEUL Language Registry. The Payload is exactly 1 WORD.

## Layout

- Code: Value direct code `0x48`. Family TEXT.
- The Payload is exactly one WORD, an unsigned 16-bit code.

```
TAG WORD          0x08C8 (0000 1000 1100 1000)  2 WORD in total
Payload WORD 1st (16 bits)           GEUL Language Registry number (uint16)
```

## Interpretation and Validity

- The 1 Payload WORD is read as an unsigned 16-bit integer.
- This value is one tag assigned by the GEUL Language Registry. The normative form of the registry is this Codec's spec document `0x0000/0x0000000000000848`. Each code value has one [ENUM](/grammar/edge/enum/) on the FIELD `code`, and the name bound to that ENUM's Edge Id with [BIND](/grammar/edge/bind/) is the BCP 47 tag in canonical casing.
- The registry is a closed list. A value with no ENUM in the spec document is invalid. This Codec rule takes precedence over the general ENUM rule ("an undeclared code value is not an error").
- Three kinds of tag are assigned:
  - The `Type: language` records of the IANA Language Subtag Registry, except `Scope: private-use` (`qaa..qtz`). Collections, macrolanguages and special (`mul`, `und`, `zxx`, `mis`) are not excluded.
  - Tags IANA registers whole: grandfathered and redundant (`zh-Hans`, `sr-Latn`, `zh-min-nan` and so on).
  - Valid combined tags observed in public CC0 sources (`pt-BR`, `en-GB`, `be-tarask` and so on). They consist only of language, extlang, script, region and variant subtags. Tags with an extension (`-u-`, `-t-`) or private-use (`-x-`) are not taken.
- A tag without a number cannot be written in this format. Write it as [LANGUAGE-BCP47-CODE](/grammar/value/text/language-bcp47-code/) (`0x46`, `0x47`). SHORT-CODE has no escape path.
- `0x0000` and `0xffff` are never assigned. Both are invalid in this Value. Neither is used to mean `null`, `unknown` or `und`.
- The value ranges are an assignment convention. A decoder does not infer the kind of tag from the range of the value. The meaning of a value comes only from the spec document.

| Range | Use |
|---|---|
| `0x0000` | Never assigned (invalid) |
| `0x0001`–`0x3fff` | Tags of a single language subtag |
| `0x4000`–`0x7fff` | Tags of two or more subtags (IANA whole tags, observed combined tags) |
| `0x8000`–`0xfffe` | Overflow. When a block above is full, assignment continues here |
| `0xffff` | Never assigned (invalid) |

- The initial edition numbers tags within each block in lowercase ASCII order. In the `0x4000` block, the IANA whole tags (grandfathered and redundant mixed, ASCII order) come first, then the observed combined tags (ASCII order). Neither the physical order of the IANA file nor frequency of use is a numbering rule.
- Assignment is append-only. A new tag is appended at the end of its block, and when the block is full, in the overflow range. The tag (case-insensitive) of a number once given is never changed, deleted or reused.
- A new tag enters by appending an ENUM and a BIND in a new version of the spec document. Existing ENUMs and BINDs are not modified, so every version is a superset of the version before.
- When all 65,534 numbers are taken, no more are assigned. Later new tags are written as LANGUAGE-BCP47-CODE. Expressiveness is not reduced; only the compression gain is lost.
- Same language: SHORT-CODE `n` and the LANGUAGE-BCP47-CODE of the tag the registry binds to `n` (case-insensitive) are the same language.
- A registry edition is a version of the spec document. Each edition records the IANA registry file it is based on (File-Date, SHA-256) as a [SOURCE](/grammar/edge/source/) in the spec document's HEAD. When the edition used to interpret a value must be stated, keep that version (`0x0000/0x0000000000000848@n`) with it.
- A Codec spec may hold the same 1 WORD code in a raw-value field with no TAG (a [CODEC](/grammar/codec-spec/#codec) on a raw-value field). That is a rule of that Codec spec, and the wire form of a standalone Value is always TAG 1 WORD + Payload 1 WORD.

## Standards Basis

- The meaning of tags and the validity of subtags follow the [IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry) and [RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646). IANA and the IETF place their rights in the protocol registries under CC0 1.0 ([IANA Licensing Terms](https://www.iana.org/help/licensing-terms)).
- The registry numbers (ASCII-ordered append-only assignment, block layout, `0x0000` and `0xffff` never assigned, closed list), the spec document's ENUMs being the normative form, and the distinction from TAG-less embedding in a raw-value field are GEUL rules.

## Length

- The total is exactly 2 WORDs, the TAG 1 WORD plus the Payload 1 WORD, using the direct length `LLLL=0001`. There is no Length extension TAG, descriptor, or padding.
- If the Payload is not exactly 1 WORD, reject.

## Example

Numbers of registry v2 (spec document `0x0000/0x0000000000000848` version 2, IANA File-Date 2026-09-17). It assigns 8,678 tags (language 8,275, grandfathered 26, redundant 67, observed combined 310).

| tag | Code | All WORDs |
|---|---|---|
| `en` | `0x0784` | `08C8 0784` |
| `ko` | `0x0d06` | `08C8 0D06` |
| `zh-Hans` | `0x404c` | `08C8 404C` |
| `pt-BR` | `0x4130` | `08C8 4130` |

- In the spec document, `en` is `ENUM #2 0x0784` and the `BIND "en"` on its Edge Id.
- `de-x-formal` (private-use) and `nl-u-sd-bebru` (extension) have no number, so they are written as LANGUAGE-BCP47-CODE.

## Open Questions

- Reading across editions: whether a number newer than the reader's edition is discarded as invalid or kept as an "unknown code" with its raw value. Being append-only, the latest edition always suffices, but offline decoders need a rule.
- Canonical form: whether a tag that has a number SHOULD or MUST be written as SHORT-CODE. MUST fixes one spelling, but a new edition would make documents written earlier non-canonical.
- How to express deprecated tags and Preferred-Value in the spec document (the current edition has none).
- The procedure for appending observed combined tags (sources, observation threshold).

## Related Pages

- [LANGUAGE-BCP47-CODE](/grammar/value/text/language-bcp47-code/), [UTF8-LANGUAGE-TEXT](/grammar/value/text/utf8-language-text/), [LABEL](/grammar/edge/label/)
- [Codec specification document](/grammar/codec-spec/), [ENUM](/grammar/edge/enum/), [BIND](/grammar/edge/bind/), [SOURCE](/grammar/edge/source/)
