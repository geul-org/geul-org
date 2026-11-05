---
title: "LANGUAGE-SHORT-CODE (0x07AL)"
weight: 122
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-SHORT-CODE is a GEUL compressed language code that holds one BCP 47 tag assigned a number in the GEUL Language Registry in 1 WORD."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `LANGUAGE-SHORT-CODE` (spec document BIND `LANGUAGE-SHORT-CODE`) |
| TAG ID | `0x07AL` |
| Codec ID | `0x000007A0` |
| Spec document | `0x00000000/codecs/0x000007A0/` (DECLARE target `07A0`) |
| Section | 3 `0011` (Value), offset within section C = 26 |
| Kind | Value · family: TEXT |
| TAG WORD | `0000 0111 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | BCP 47 tag written as a GEUL Language Registry number (Payload 1 WORD) |
| Hugo path | `value/text/language-short-code.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs in the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `code` | #2 | raw 1 WORD |  | 8678 ENUMs. E.g. `0x0001` aa, `0x0002` aaa, `0x0003` aab, `0x0004` aac, `0x0005` aad … |

LANGUAGE-SHORT-CODE is a GEUL compressed language code that holds one BCP 47 tag assigned a number in the GEUL Language Registry in 1 WORD. The Payload is exactly 1 WORD.

## Layout {#레이아웃}

- Code: Value direct code `0x07AL`. Family TEXT.
- The Payload is exactly 1 WORD, an unsigned 16-bit code.

```
TAG WORD          0x07A1 (0000 0111 1010 0001)  2 WORDs in total
Payload WORD 1st (16 bits)           GEUL Language Registry number (uint16)
```

## Interpretation and validity {#해석과-유효성}

- Read the 1 Payload WORD as an unsigned 16-bit integer.
- This value is one tag assigned by the GEUL Language Registry. The canonical representation of the registry is the spec document `0x00000000/codecs/0x000007A0` of this Codec. For each code value there is one [ENUM](../edge/0x0BDL-enum.md) on the FIELD `code`, and the name bound by [BIND](../edge/0x0A3L-bind.md) to that ENUM Edge Id is the BCP 47 tag in canonical casing.
- The registry is a closed list. A value with no ENUM in the spec document is invalid. This Codec rule takes precedence over the general ENUM rule ("an undeclared code value is not an error").
- The following three are assigned.
  - Among the `Type: language` records of the IANA Language Subtag Registry, those except `Scope: private-use` (`qaa..qtz`). Collection, macrolanguage, and special (`mul`·`und`·`zxx`·`mis`) are not excluded.
  - Tags that IANA registered as a whole: grandfathered and redundant (`zh-Hans`, `sr-Latn`, `zh-min-nan`, etc.).
  - Valid combined tags observed in public CC0 sources (`pt-BR`, `en-GB`, `be-tarask`, etc.). These are tags made only of language, extlang, script, region, and variant subtags. Tags containing an extension (`-u-`·`-t-`) or private-use (`-x-`) are not accepted.
- A tag with no number cannot be written in this format. Write it as [LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md) (`0x076L`·`0x077L`). There is no escape path inside SHORT-CODE.
- `0x0000` and `0xFFFF` are never assigned. In this Value, both are invalid. Neither is used to mean `null`, `unknown`, or `und`.
- The value ranges are an assignment convention. A decoder does not infer the kind of tag from the range of the value. The meaning of a value comes only from the spec document.

| Range | Use |
|---|---|
| `0x0000` | unassigned (invalid) |
| `0x0001`–`0x3FFF` | tags with a single language subtag |
| `0x4000`–`0x7FFF` | tags with two or more subtags (whole IANA tags, observed combined tags) |
| `0x8000`–`0xFFFE` | overflow. When the blocks above are full, assignment continues here |
| `0xFFFF` | unassigned (invalid) |

- The initial edition gives numbers within a block in lowercase ASCII order of the tag. The `0x4000` block has the whole IANA tags (grandfathered and redundant mixed, in ASCII order) followed by the observed combined tags (in ASCII order). The physical order of the IANA file and usage frequency are not numbering rules.
- Assignment is append-only. A new tag is appended at the end of its block, and when a block is full, appended to the overflow range. The tag of an already given number (ignoring case) is not changed, deleted, or reused.
- New tags are added by appending ENUM and BIND in a new version of the spec document. Existing ENUMs and BINDs are not modified. So any version is a superset of the previous version.
- When all 65,534 are used, no more are assigned. Later new tags are written as LANGUAGE-BCP47-CODE. Expressive power is not reduced; only the compression gain is absent.
- Same language: SHORT-CODE `n` and the LANGUAGE-BCP47-CODE of the tag the registry binds to `n` (ignoring case) denote the same language.
- The registry edition is the version of the spec document. Each edition records the IANA registry file it is based on (File-Date, SHA-256) as the [SOURCE](../edge/0x0C0L-source.md) of the spec document HEAD. When the edition used to interpret a value must be stated, leave its version ([CODEC-POINTER](../reference/0x042L-codec-pointer.md) (`0x00000000`, `0x000007A0`, version ID `n`)) alongside.
- A Codec spec may hold the same 1 WORD code as a raw value field without a TAG ([CODEC](../codec-spec.md#codec) of a raw value field). This is a rule of that Codec spec; the wire form of a standalone Value is always TAG 1 WORD + Payload 1 WORD.

## Standards basis {#표준-근거}

- The meaning of a tag and the validity of subtags follow the [IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry) and [RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646). IANA and the IETF place their rights in protocol registries under CC0 1.0 ([IANA Licensing Terms](https://www.iana.org/help/licensing-terms)).
- The registry numbers (append-only assignment in ASCII order, block layout, `0x0000`·`0xFFFF` unassigned, closed list), the fact that the spec document ENUM is the canonical representation, and the distinction from embedding as a raw value field without a TAG are GEUL rules.

## Length {#길이}

- The total is exactly 2 WORDs, the TAG 1 WORD plus the Payload 1 WORD, and uses the direct length `LLLL=0001`. There is no Length extension TAG, descriptor, or padding.
- If the Payload is not exactly 1 WORD, it is rejected.

## Examples {#예시}

These are the numbers of registry v2 (spec document `0x00000000/codecs/0x000007A0` version 2, IANA File-Date 2026-09-17). 8,678 are assigned (language 8,275, grandfathered 26, redundant 67, observed combined 310).

| tag | Code | Total WORDs |
|---|---|---|
| `en` | `0x0784` | `07A1 0784` |
| `ko` | `0x0D06` | `07A1 0D06` |
| `zh-Hans` | `0x404C` | `07A1 404C` |
| `pt-BR` | `0x4130` | `07A1 4130` |

- In the spec document, `en` is `ENUM #2 0x0784` and the `BIND "en"` bound to that Edge Id.
- `de-x-formal` (private-use) and `nl-u-sd-bebru` (extension) have no number, so they are written as LANGUAGE-BCP47-CODE.

## Open problems {#열린-문제}

- Interpretation across editions: when a reader meets a number newer than the edition it has, whether to discard it as invalid or to keep the original value and treat it as an "unknown code". Because assignment is append-only, the latest edition alone is always enough, but a rule is needed for offline decoders.
- Canonical form: must (SHOULD/MUST) a tag that has a number be written as SHORT-CODE? With MUST the notation is unique, but when a new edition appears, previously written documents stop being canonical.
- How to represent deprecated tags and Preferred-Value in the spec document (not in the current edition).
- The procedure for appending observed combined tags (source, observation threshold).

## Related pages {#관련-페이지}

- [LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md), [UTF8-LANGUAGE-TEXT](0x078L-utf8-language-text.md), [LABEL](../edge/0x0A4L-label.md)
- [Codec spec document](../codec-spec.md), [ENUM](../edge/0x0BDL-enum.md), [BIND](../edge/0x0A3L-bind.md), [SOURCE](../edge/0x0C0L-source.md)

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x000007A0/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007A000000000
#17368 SOURCE #0 #17362
#17369 QUALIFIER P577 #17368 GREGORIAN-DATE(2026-09-17)
#17370 QUALIFIER P813 #17368 GREGORIAN-DATE(2026-10-29)
#17371 QUALIFIER P4092 #17368 SHA-256-DIGEST(0x755FAD43283BE7B41EBE3C89AD054B6EAF928F404F9C0EDB74799E0EAB74BEB1)
#17372 SOURCE #0 Q2013
#17373 QUALIFIER P813 #17372 GREGORIAN-DATE(2026-10-29)
BODY
#1 DECLARE 0x07A0
#2 FIELD #1 0x0001
#3 BIND #1 "LANGUAGE-SHORT-CODE"
#4 BIND #2 "code"
#5 ENUM #2 0x0001
#6 BIND #5 "aa"
#7 ENUM #2 0x0002
#8 BIND #7 "aaa"
#9 ENUM #2 0x0003
#10 BIND #9 "aab"
#11 ENUM #2 0x0004
#12 BIND #11 "aac"
#13 ENUM #2 0x0005
#14 BIND #13 "aad"
… (17346 lines of ENUM·BIND omitted)
#17361 REFERENCE-NODE #17362 <https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry>
#17363 TRIPLE P275 #17362 Q6938433 normal
#17364 REFERENCE-NODE #17365 <https://www.iana.org/help/licensing-terms>
#17366 SOURCE #17363 #17365
#17367 QUALIFIER P813 #17366 GREGORIAN-DATE(2026-10-29)
```
