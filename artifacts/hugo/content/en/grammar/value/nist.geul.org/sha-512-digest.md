---
title: "SHA-512-DIGEST"
weight: 1039
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA-512-DIGEST is a fixed-width Value that holds the entire result of SHA-512 of the SHA-2 family."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA-512-DIGEST is a fixed-width Value that holds the entire result of SHA-512 of the SHA-2 family. It is Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000015` NIST, codec number `0x0000C000`, family BINARY. The Payload is exactly 32 WORD (512 bits), and truncation is not allowed.

## Layout {#레이아웃}

```
TAG WORD          0x09DE (0000 1001 1101 1110)  LLLL=1110
Length ext. TAG   1 WORD  0x0026 (38 WORD in total)
Issuer            2 WORD  0x00000015 (NIST)
Codec number      2 WORD  0x0000C000
Payload           32 WORD  SHA-512 Digest
```

## Interpretation and validity {#해석과-유효성}

- The 64 Payload octets are read in the SHA-512 output order as is. Within each WORD, the upper octet comes first.
- No separate GEUL endian conversion is applied to the digest bit string. The output octet sequence is merely grouped two octets at a time in order and framed as 16-bit big-endian WORD.
- A representation whose Payload is not 32 WORD, or in which the result is arbitrarily truncated, is rejected. There is no descriptor and no padding.

## Standards basis {#표준-근거}

- The SHA-512 algorithm and the 512-bit result follow NIST [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final).
- The GEUL TAG, Length, and 16-bit WORD framing are rules added by this format and are not part of the SHA-2 algorithm.

## Length {#길이}

- The total is exactly 38 WORD: TAG 1 WORD, Length extension TAG 1 WORD, Issuer 2 WORD, codec number 2 WORD, and Payload 32 WORD, and it uses `LLLL=1110`. There is no descriptor and no padding.
- If the Payload is not exactly 32 WORD, it is rejected.

## Example {#예시}

- The digest octets `d[0]` through `d[63]` are placed in order as the Payload WORD `(d[0]<<8)|d[1]` through `(d[62]<<8)|d[63]`. The total Length is always 38 WORD.
