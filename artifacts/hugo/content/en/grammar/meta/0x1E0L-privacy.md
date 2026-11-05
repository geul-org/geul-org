---
title: "PRIVACY (0x1E0L)"
weight: 480
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "Records the privacy level of the document."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `PRIVACY` (spec document BIND `PRIVACY`) |
| TAG ID | `0x1E0L` |
| Codec ID | `0x00001E00` |
| Spec document | `0x00000000/codecs/0x00001E00/` (DECLARE target `1E00`) |
| Section | 15 `1111` (Meta), offset within section C = 0 |
| Kind | Meta · class: policy |
| TAG WORD | `0001 1110 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Privacy level |
| Hugo side | `meta/policy/privacy.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs within the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `level` | #2 | raw value 1 WORD |  |  |

Records the privacy level of the document.

## Layout {#레이아웃}

```
TAG WORD          0001 1110 0000 LLLL      Codec 0x1E0L
[Length extension TAG]
Level             1 WORD
```

- Codec: Meta `0x1E0L`, policy class
- Payload: raw value (level, 1 WORD)
- Count: at most one

## Interpretation and validity {#해석과-유효성}

- It does not change interpretation. It sets handling only.

## Open issues {#열린-문제}

- The level code table (correspondence with the classification of the Personal Information Protection Act).

## Spec document source {#규격-문서-원문}

The spec document `0x00000000/codecs/0x00001E00/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E0000000000
BODY
#1 DECLARE 0x1E00
#2 FIELD #1 0x0001
#3 BIND #1 "PRIVACY"
#4 BIND #2 "level"
```
