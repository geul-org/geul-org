---
title: "ALIAS (0x0A5L)"
weight: 165
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "ALIAS is a statement Edge that connects, as Object, one other name (alias) for the target of Subject."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `ALIAS` (specification document BIND `ALIAS`) |
| TAG ID | `0x0A5L` |
| Codec ID | `0x00000A50` |
| Specification document | `0x00000000/codecs/0x00000A50/` (DECLARE target `0A50`) |
| Section | 5 `0101` (Edge statement), offset within section C = 5 |
| Kind | Edge · family: statement, group: pointing and names |
| TAG WORD | `0000 1010 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Connects another name (alias) of Subject. The layout is the same as LABEL |
| Hugo side | `edge/alias.md` |

## Fields (specification document) {#필드-규격-문서}

The order of FIELDs in the document is the order of the Payload fields ([Codec specification document](../codec-spec.md)). The Edge Id of an Edge is not declared as a FIELD.

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | record | Any record (excluding slot markers) |  |
| 2 | `object` | #3 | record | `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT, `0050` LOCAL |  |

ALIAS is a statement Edge that connects, as Object, one other name (alias) for the target of Subject. Codec `0x0A5L`.

[LABEL](0x0A4L-label.md) is the representative name in that language (at most one per language), and ALIAS is another name for the same target (several per language; Wikidata "also known as"). It is used mainly for search. The layout and validity are the same as LABEL.

## Layout {#레이아웃}

```
TAG WORD          0000 1010 0101 LLLL
[Length extension TAG]
Edge Id           LOCAL Reference record
Subject           1 Reference record
Object            1 UTF8-LANGUAGE-TEXT Value or LOCAL Reference record
```

## Interpretation and validity {#해석과-유효성}

- The rules for Subject and Object are the same as [LABEL](0x0A4L-label.md) (Object is [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md) or a LOCAL that resolves to it).
- Several ALIASes may be placed on the same Subject and language. The order is their order in the document.
- The same text as the LABEL of the same Subject and language is not placed as an ALIAS (one LABEL suffices for the representative name). This rule is a recommendation.
- The geul.org specification document restricts Object with [CODEC](0x0BEL-codec.md) (`0780`, `0790`, `0050`, same as LABEL).

## Example (non-normative) {#예시-비규범}

Edge Id `0003`, Subject Q42 (`0141 002A`), Object `DNA` (en): language `0761 656E` (BCP47 `en`) + 3 bytes of text (odd) → `UTF8-LANGUAGE-TEXT-ODD` (`0x079L`), `0794 0761 656E 444E 4100`.

- TAG 1 + Edge Id 2 + Subject 2 + Object 5 = 10 WORDs, `LLLL=1001`. The TAG is `0A59`.

```
0A59 0051 0003 0141 002A 0794 0761 656E 444E 4100
```

## Related pages {#관련-페이지}

- [Edge](_index.md), [LABEL](0x0A4L-label.md), [DESCRIPTION](0x0A6L-description.md), [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md)

## Specification document source {#규격-문서-원문}

This is the specification document `0x00000000/codecs/0x00000A50/latest.geul` as read with `geul show` (hexadecimal in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A5000000000
BODY
#1 DECLARE 0x0A50
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "ALIAS"
#5 BIND #2 "subject"
#6 BIND #3 "object"
#7 CODEC #3 0x0780
#8 CODEC #3 0x0790
#9 CODEC #3 0x0050
```
