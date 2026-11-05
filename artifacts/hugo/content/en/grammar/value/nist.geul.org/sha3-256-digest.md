---
title: "SHA3-256-DIGEST"
weight: 1040
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA3-256-DIGEST is a fixed-width Value that holds the entire result of SHA3-256."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA3-256-DIGEST is a fixed-width Value that holds the entire result of SHA3-256. It is Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000015` NIST, codec number `0x0000C001`, family BINARY. The Payload is exactly 16 WORD (256 bits), and truncation is not allowed.

## Layout {#레이아웃}

```
TAG WORD          0x09DE (0000 1001 1101 1110)  LLLL=1110
Length ext. TAG   1 WORD  0x0016 (22 WORD in total)
Issuer            2 WORD  0x00000015 (NIST)
Codec number      2 WORD  0x0000C001
Payload           16 WORD  SHA3-256 Digest
```

## Interpretation and validity {#해석과-유효성}

- The 32 Payload octets are read in the SHA3-256 output order as is. Within each WORD, the upper octet comes first.
- No separate GEUL endian conversion is applied to the digest bit string. The output octet sequence is merely grouped two octets at a time in order and framed as 16-bit big-endian WORD.
- A representation whose Payload is not 16 WORD, or in which the result is arbitrarily truncated, is rejected. There is no descriptor and no padding.

## Standards basis {#표준-근거}

- The SHA3-256 algorithm and the 256-bit result follow NIST [FIPS 202, SHA-3 Standard](https://csrc.nist.gov/pubs/fips/202/final). The NIST [Hash Functions project](https://csrc.nist.gov/Projects/hash-functions) also introduces the SHA-3 standard.
- The GEUL TAG, Length, and 16-bit WORD framing are rules added by this format and are not part of the SHA-3 algorithm.

## Length {#길이}

- The total is exactly 22 WORD: TAG 1 WORD, Length extension TAG 1 WORD, Issuer 2 WORD, codec number 2 WORD, and Payload 16 WORD, and it uses `LLLL=1110`. There is no descriptor and no padding.
- If the Payload is not exactly 16 WORD, it is rejected.

## Example {#예시}

- The digest octets `d[0]` through `d[31]` are placed in the 16 Payload WORD in output order, two octets each. The total Length is always 22 WORD.
