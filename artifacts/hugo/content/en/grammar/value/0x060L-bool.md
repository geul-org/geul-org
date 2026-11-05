---
title: "BOOL (0x060L)"
weight: 96
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "BOOL is a Value that represents the logical values false and true."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `BOOL` (spec document BIND `BOOL`) |
| TAG ID | `0x060L` |
| Codec ID | `0x00000600` |
| Spec document | `0x00000000/codecs/0x00000600/` (DECLARE target `0600`) |
| Section | 3 `0011` (Value), offset C within the section = 0 |
| Kind | Value · family: NUMERIC |
| TAG WORD | `0000 0110 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | false or true in a fixed 1 WORD |
| Hugo side | `value/numeric/bool.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs in the document is the order of the Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Receiving format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `code` | #2 | raw value, 1 WORD |  | `0x0000` false, `0x0001` true |

BOOL is a Value that represents the logical values false and true. Its direct Value code is `0x060L`, family NUMERIC. It is a different type from SIGNED-INTEGER and UNSIGNED-INTEGER, which hold the numbers 0 and 1.

## Layout {#레이아웃}

```
TAG WORD          0x0601 (0000 0110 0000 0001)  total 2 WORD
Payload           1 WORD  Boolean Code
```

## Interpretation and validity {#해석과-유효성}

- Payload `0000` is false and `0001` is true.
- There is no padding or descriptor.
- The Payload is exactly `0000` or `0001`. Any other 16-bit value is rejected as invalid.
- Every other Length representation is rejected as invalid.

## Length {#길이}

- The total is exactly 2 WORD, the TAG 1 WORD plus the Payload 1 WORD, and uses the direct length `LLLL=0001`. There is no Length extension TAG, descriptor, or padding.
- If the Payload is not exactly 1 WORD, it is rejected.

## Examples {#예시}

| Full record (TAG + Payload) | Payload | Verdict |
|---|---|---|
| `0601 0000` | `0000` | false, canonical |
| `0601 0001` | `0001` | true, canonical |
| `0601 0002` | `0002` | invalid |
| `0601 FFFF` | `FFFF` | invalid |
| TAG with Length other than `0001` + `0000` or `0001` | `0000` or `0001` | invalid |

## Format status {#형식-지위}

- This representation, which binds a 16-bit code word of `0000`/`0001` to a GEUL TAG, is a GEUL-specific scalar profile.
- The logical value itself is universal, but no single industry standard is claimed to correspond to this 1 WORD representation.

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00000600/latest.geul` as read with `geul show` (hexadecimal in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000060000000000
BODY
#1 DECLARE 0x0600
#2 FIELD #1 0x0001
#3 ENUM #2 0x0000
#4 ENUM #2 0x0001
#5 BIND #1 "BOOL"
#6 BIND #2 "code"
#7 BIND #3 "false"
#8 BIND #4 "true"
```
