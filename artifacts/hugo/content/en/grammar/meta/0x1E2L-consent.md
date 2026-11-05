---
title: "CONSENT (0x1E2L)"
weight: 482
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "Records the scope and basis of consent."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `CONSENT` (spec document BIND `CONSENT`) |
| TAG ID | `0x1E2L` |
| Codec ID | `0x00001E20` |
| Spec document | `0x00000000/codecs/0x00001E20/` (DECLARE target `1E20`) |
| Section | 15 `1111` (Meta), offset within section C = 2 |
| Kind | Meta · class: policy |
| TAG WORD | `0001 1110 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Scope and basis of consent |
| Hugo side | `meta/policy/consent.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs within the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `consent` | #2 | record | `000F` all of Section 0 (wildcard, Reference), `020F` all of Section 1 (wildcard, Reference), `040F` all of Section 2 (wildcard, Reference), `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD, `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT |  |

Records the scope and basis of consent.

## Layout {#레이아웃}

```
TAG WORD          0001 1110 0010 LLLL      Codec 0x1E2L
[Length extension TAG]
Payload           A Reference pointing at the basis of consent, or text
```

- Codec: Meta `0x1E2L`, policy class
- Payload: embedded Reference or Value
- Count: several allowed

## Open issues {#열린-문제}

- The structure for expressing scope (purpose, period, provision to third parties).

## Spec document source {#규격-문서-원문}

The spec document `0x00000000/codecs/0x00001E20/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E2000000000
BODY
#1 DECLARE 0x1E20
#2 FIELD #1 record
#3 BIND #1 "CONSENT"
#4 BIND #2 "consent"
#5 CODEC #2 0x000F
#10 CODEC #2 0x020F
#11 CODEC #2 0x040F
#6 CODEC #2 0x0720
#7 CODEC #2 0x0730
#8 CODEC #2 0x0780
#9 CODEC #2 0x0790
```
