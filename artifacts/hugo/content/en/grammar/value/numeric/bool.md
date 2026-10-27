---
title: "BOOL"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "BOOL is a fixed 2 WORD Value that holds the logical values false and true."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BOOL is a Value that represents the logical values false and true. It is Value direct code `0x00`, family NUMERIC. It is a different type from SIGNED-INTEGER and UNSIGNED-INTEGER, which hold the numbers 0 and 1.

## Layout

```
TAG WORD          0x0880 (0000 1000 1000 0000)  2 WORD in total
Payload           1 WORD  Boolean Code
```

## Interpretation and Validity

- Payload `0000` is false and `0001` is true.
- There is no padding or descriptor.
- The Payload is exactly `0000` or `0001`. Any other 16-bit value is rejected as invalid.
- Every other Length representation is rejected as invalid.

## Length

- The total is exactly 2 WORDs, the TAG 1 WORD plus the Payload 1 WORD, and uses the direct length `LLLL=0001`. There is no Length extension TAG, descriptor, or padding.
- If the Payload is not exactly 1 WORD, reject.

## Examples

| Whole record (TAG + Payload) | Payload | Verdict |
|---|---|---|
| `0880 0000` | `0000` | false, canonical |
| `0880 0001` | `0001` | true, canonical |
| `0880 0002` | `0002` | invalid |
| `0880 ffff` | `ffff` | invalid |
| A TAG whose Length is not `0001` + `0000` or `0001` | `0000` or `0001` | invalid |

## Format Status

- This representation, which combines the 16-bit code words `0000`/`0001` with a GEUL TAG, is a GEUL-specific scalar profile.
- The logical value itself is universal, but no single industry standard is claimed for this 1 WORD representation.
