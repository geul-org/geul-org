---
title: "VERDICT (0x1E9L)"
weight: 489
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "Records the verdict on the whole document."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `VERDICT` (spec document BIND `VERDICT`) |
| TAG ID | `0x1E9L` |
| Codec ID | `0x00001E90` |
| Spec document | `0x00000000/codecs/0x00001E90/` (DECLARE target `1E90`) |
| Section | 15 `1111` (Meta), offset within section C = 9 |
| Kind | Meta · class: verification |
| TAG WORD | `0001 1110 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | The verdict on the whole document. Pass, Review, Fail. At node and record level, [TOULMIN](../toulmin/_index.md) `VERDICT` (Edge `0x118L`) |
| Hugo side | `meta/verification/verdict.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs within the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `verdict` | #2 | raw value 1 WORD |  | `0x0000` pass, `0x0001` review, `0x0002` fail |

Records the verdict on the whole document. Node-level and record-level verdicts are carried by [TOULMIN](../toulmin/_index.md) `VERDICT` (Edge `0x118L`).

## Layout {#레이아웃}

```
TAG WORD          0001 1110 1001 LLLL      Codec 0x1E9L
[Length extension TAG]
Verdict           1 WORD (0 Pass, 1 Review, 2 Fail)
```

- Codec: Meta `0x1E9L`, verification class
- Payload: raw value (verdict, 1 WORD)
- Count: at most one

## Interpretation and validity {#해석과-유효성}

- Being verification class, it is excluded from the content hash.
- A verdict on another document is placed in the BODY of a document other than the one being judged.

## Open issues {#열린-문제}

- Whether to also record who gave the verdict and on what basis.

## Spec document source {#규격-문서-원문}

The spec document `0x00000000/codecs/0x00001E90/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E9000000000
BODY
#1 DECLARE 0x1E90
#2 FIELD #1 0x0001
#3 ENUM #2 0x0000
#4 ENUM #2 0x0001
#5 ENUM #2 0x0002
#6 BIND #1 "VERDICT"
#7 BIND #2 "verdict"
#8 BIND #3 "pass"
#9 BIND #4 "review"
#10 BIND #5 "fail"
```
