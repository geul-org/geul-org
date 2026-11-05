---
title: "LICENSE (0x1DEL)"
weight: 478
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "Records the license of this document and of the works inside the byte sequence."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `LICENSE` (spec document BIND `LICENSE`) |
| TAG ID | `0x1DEL` |
| Codec ID | `0x00001DE0` |
| Spec document | `0x00000000/codecs/0x00001DE0/` (DECLARE target `1DE0`) |
| Section | 14 `1110` (Meta), offset within section C = 14 |
| Kind | Meta · class: policy |
| TAG WORD | `0001 1101 1110 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | License. Reference |
| Hugo side | `meta/policy/license.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs within the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `license` | #2 | record | `000F` all of Section 0 (wildcard, Reference), `020F` all of Section 1 (wildcard, Reference), `040F` all of Section 2 (wildcard, Reference), `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD, `0740` URI-EVEN, `0750` URI-ODD |  |

Records the license of this document and of the works inside the byte sequence.

## Layout {#레이아웃}

```
TAG WORD          0001 1101 1110 LLLL      Codec 0x1DEL
[Length extension TAG]
Payload           A Reference pointing at the license, or an SPDX identifier UTF8-TEXT, or a URI Value
```

- Codec: Meta `0x1DEL`, policy class
- Payload: embedded Reference or Value ([UTF8-TEXT](../value/0x072L-utf8-text.md), [URI](../value/0x074L-uri.md))
- Count: at most one

## Interpretation and validity {#해석과-유효성}

- Documents published on geul.org are CC0. A private publication is decided by the Issuer ([Issuer](../issuer.md)).
- Record the original license of the source work.

## Open issues {#열린-문제}

- Whether to hold an SPDX identifier as text or as a GEUL entity Reference.

## Spec document source {#규격-문서-원문}

The spec document `0x00000000/codecs/0x00001DE0/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DE000000000
BODY
#1 DECLARE 0x1DE0
#2 FIELD #1 record
#3 BIND #1 "LICENSE"
#4 BIND #2 "license"
#5 CODEC #2 0x000F
#10 CODEC #2 0x020F
#11 CODEC #2 0x040F
#6 CODEC #2 0x0720
#7 CODEC #2 0x0730
#8 CODEC #2 0x0740
#9 CODEC #2 0x0750
```
