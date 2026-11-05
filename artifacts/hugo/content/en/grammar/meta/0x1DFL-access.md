---
title: "ACCESS (0x1DFL)"
weight: 479
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "Records the scope of disclosure of the document."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `ACCESS` (spec document BIND `ACCESS`) |
| TAG ID | `0x1DFL` |
| Codec ID | `0x00001DF0` |
| Spec document | `0x00000000/codecs/0x00001DF0/` (DECLARE target `1DF0`) |
| Section | 14 `1110` (Meta), offset within section C = 15 |
| Kind | Meta · class: policy |
| TAG WORD | `0001 1101 1111 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Scope of disclosure |
| Hugo side | `meta/policy/access.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs within the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `level` | #2 | raw value 1 WORD |  | `0x0000` public, `0x0001` internal, `0x0002` confidential |

Records the scope of disclosure of the document.

## Layout {#레이아웃}

```
TAG WORD          0001 1101 1111 LLLL      Codec 0x1DFL
[Length extension TAG]
Level             1 WORD (0 public, 1 internal, 2 confidential, others Reserved)
```

- Codec: Meta `0x1DFL`, policy class
- Payload: raw value (level, 1 WORD)
- Count: at most one

## Interpretation and validity {#해석과-유효성}

- Confidential documents are not published ([Issuer](../issuer.md)).
- It does not change interpretation. It sets handling only.

## Open issues {#열린-문제}

- The level code table.

## Spec document source {#규격-문서-원문}

The spec document `0x00000000/codecs/0x00001DF0/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DF000000000
BODY
#1 DECLARE 0x1DF0
#2 FIELD #1 0x0001
#3 ENUM #2 0x0000
#4 ENUM #2 0x0001
#5 ENUM #2 0x0002
#6 BIND #1 "ACCESS"
#7 BIND #2 "level"
#8 BIND #3 "public"
#9 BIND #4 "internal"
#10 BIND #5 "confidential"
```
