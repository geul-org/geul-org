---
title: "DESCRIPTION (0x0A6L)"
weight: 166
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DESCRIPTION is a statement Edge that connects, as Object, one description in a particular language for the target of Subject."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `DESCRIPTION` (specification document BIND `DESCRIPTION`) |
| TAG ID | `0x0A6L` |
| Codec ID | `0x00000A60` |
| Specification document | `0x00000000/codecs/0x00000A60/` (DECLARE target `0A60`) |
| Section | 5 `0101` (Edge statement), offset within section C = 6 |
| Kind | Edge · family: statement, group: pointing and names |
| TAG WORD | `0000 1010 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Connects a language description of Subject. The layout is the same as LABEL |
| Hugo side | `edge/description.md` |

## Fields (specification document) {#필드-규격-문서}

The order of FIELDs in the document is the order of the Payload fields ([Codec specification document](../codec-spec.md)). The Edge Id of an Edge is not declared as a FIELD.

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | record | Any record (excluding slot markers) |  |
| 2 | `object` | #3 | record | `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT, `0050` LOCAL |  |

DESCRIPTION is a statement Edge that connects, as Object, one description in a particular language for the target of Subject. Codec `0x0A6L`.

A description is a short phrase that distinguishes the target (Wikidata description, e.g. "capital and largest city of Germany"). It is not a definition of or a claim about the target. A proposition about the target is written as a [TRIPLE](0x0AAL-triple.md). The layout is the same as [LABEL](0x0A4L-label.md). The description and its language are carried in a single Object, [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md). There is no raw-value field.

## Layout {#레이아웃}

```
TAG WORD          0000 1010 0110 LLLL
[Length extension TAG]
Edge Id           LOCAL Reference record
Subject           1 Reference record
Object            1 UTF8-LANGUAGE-TEXT Value or LOCAL Reference record
```

## Interpretation and validity {#해석과-유효성}

- The rules for Subject and Object are the same as [LABEL](0x0A4L-label.md). Subject is exactly one complete Reference record. Object is exactly one complete UTF8-LANGUAGE-TEXT (`0x078L`, `0x079L`) record, or a LOCAL Reference that resolves to a UTF8-LANGUAGE-TEXT through a [REFERENCE-NODE](0x0A0L-reference-node.md) binding in the same document.
- Text without a language (UTF8-TEXT) cannot be a DESCRIPTION. There is one description per language, and that rule holds only when a language is present. A description common to several languages is written with language `mul`.
- There is at most one DESCRIPTION per Subject and language.
- A description is used to distinguish a target from other targets with the same name. In the same language it is preferable that the LABEL and DESCRIPTION pair not coincide for two targets, but the specification does not check this (Wikidata also only recommends this and does not enforce it).
- The geul.org specification document restricts Object with [CODEC](0x0BEL-codec.md) (`0780`, `0790`, `0050`, same as LABEL).

## Length {#길이}

```
total = 1 + N_len + N_id + N_subject + N_object WORD
```

- The language record of Object and the number of text bytes are handled by the Object record. The cursor after reading the last record must coincide exactly with the end of the Edge.
- A description is longer than a label, so both Object and Edge easily exceed 15 WORDs. In that case, use a Length extension ([Record](../record.md)).

## Example (non-normative) {#예시-비규범}

Edge Id `0009`, Subject Q64 (`0141 0040`), Object `capital and largest city of Germany` (en). The language is an example in the LANGUAGE-BCP47-CODE form (`en` has registry number `0x0784` and can also be used as SHORT-CODE).

- Object is language `0761 656E` (BCP47 `en`, 2 WORDs) + 35 bytes of text (odd, 18 WORDs), so it is `0x079L`, TAG 1 + extension TAG 1 + 20 = 22 WORDs, `079E 0016 …`.
- The Edge is TAG 1 + extension TAG 1 + Edge Id 2 + Subject 2 + Object 22 = 28 WORDs, so `LLLL=1110`, TAG `0A6E`, extension TAG `001C`.

```
0A6E 001C 0051 0009 0141 0040
079E 0016 0761 656E 6361 7069 7461 6C20 616E 6420 6C61 7267 6573 7420 6369 7479 206F 6620 4765 726D 616E 7900
```

## Wikidata correspondence {#위키데이터-대응}

- An item's `descriptions` (one per language) → one DESCRIPTION per language. Language codes are carried over by the same language-code correspondence table as LABEL.

## Open problems {#열린-문제}

- Whether there are cases that would justify allowing a language-less UTF8-TEXT description (not allowed at present).

## Related pages {#관련-페이지}

- [Edge](_index.md), [LABEL](0x0A4L-label.md), [ALIAS](0x0A5L-alias.md), [CODEC](0x0BEL-codec.md)
- [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md), [LOCAL](../reference/0x005L-local.md), [REFERENCE-NODE](0x0A0L-reference-node.md)

## Specification document source {#규격-문서-원문}

This is the specification document `0x00000000/codecs/0x00000A60/latest.geul` as read with `geul show` (hexadecimal in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A6000000000
BODY
#1 DECLARE 0x0A60
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "DESCRIPTION"
#5 BIND #2 "subject"
#6 BIND #3 "object"
#7 CODEC #3 0x0780
#8 CODEC #3 0x0790
#9 CODEC #3 0x0050
```
