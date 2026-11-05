---
title: "MESSAGE (0x1D9L)"
weight: 473
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Records the reason for a change (git commit message)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `MESSAGE` (spec document BIND `MESSAGE`) |
| TAG ID | `0x1D9L` |
| Codec ID | `0x00001D90` |
| Spec document | `0x00000000/codecs/0x00001D90/` (DECLARE target `1D90`) |
| Section | 14 `1110` (Meta), offset within section C = 9 |
| Kind | Meta · class: lineage |
| TAG WORD | `0001 1101 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | The reason for a change. A UTF8-LANGUAGE-TEXT Value, one per language (git commit message) |
| Hugo side | `meta/lineage/message.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs within the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `message` | #2 | record | `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT |  |

Records the reason for a change (git commit message).

## Layout {#레이아웃}

```
TAG WORD          0001 1101 1001 LLLL      Codec 0x1D9L
[Length extension TAG]
Message           1 UTF8-LANGUAGE-TEXT Value
```

- Codec: Meta `0x1D9L`, lineage class
- Payload: embedded Value ([UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md))
- Count: at most one per language

## Interpretation and validity {#해석과-유효성}

- The message and its language go into a single UTF8-LANGUAGE-TEXT. There is one MESSAGE per language.
- The geul.org spec document writes this with [CODEC](../edge/0x0BEL-codec.md) `0780`, `0790`.

## Spec document source {#규격-문서-원문}

The spec document `0x00000000/codecs/0x00001D90/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D9000000000
BODY
#1 DECLARE 0x1D90
#2 FIELD #1 record
#3 BIND #1 "MESSAGE"
#4 BIND #2 "message"
#5 CODEC #2 0x0780
#6 CODEC #2 0x0790
```
