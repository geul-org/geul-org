---
title: "USAGE (0x1E3L)"
weight: 483
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "Records usage restrictions (for example, no training, no commercial use)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `USAGE` (spec document BIND `USAGE`) |
| TAG ID | `0x1E3L` |
| Codec ID | `0x00001E30` |
| Spec document | `0x00000000/codecs/0x00001E30/` (DECLARE target `1E30`) |
| Section | 15 `1111` (Meta), offset within section C = 3 |
| Kind | Meta · class: policy |
| TAG WORD | `0001 1110 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Usage restrictions |
| Hugo side | `meta/policy/usage.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs within the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `usage` | #2 | record | `000F` all of Section 0 (wildcard, Reference), `020F` all of Section 1 (wildcard, Reference), `040F` all of Section 2 (wildcard, Reference), `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD, `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT |  |

Records usage restrictions (for example, no training, no commercial use).

## Layout {#레이아웃}

```
TAG WORD          0001 1110 0011 LLLL      Codec 0x1E3L
[Length extension TAG]
Payload           Text or a Reference expressing the usage restriction
```

- Codec: Meta `0x1E3L`, policy class
- Payload: embedded Value or Reference
- Count: several allowed

## Open issues {#열린-문제}

- The code table of restriction kinds.

## Spec document source {#규격-문서-원문}

The spec document `0x00000000/codecs/0x00001E30/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E3000000000
BODY
#1 DECLARE 0x1E30
#2 FIELD #1 record
#3 BIND #1 "USAGE"
#4 BIND #2 "usage"
#5 CODEC #2 0x000F
#10 CODEC #2 0x020F
#11 CODEC #2 0x040F
#6 CODEC #2 0x0720
#7 CODEC #2 0x0730
#8 CODEC #2 0x0780
#9 CODEC #2 0x0790
```
