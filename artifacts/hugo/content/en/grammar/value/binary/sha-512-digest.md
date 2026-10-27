---
title: "SHA-512-DIGEST"
weight: 1008
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA-512-DIGEST is a fixed 36 WORD NIST Issuer format that holds the whole 512 bits of a SHA-512 result."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA-512-DIGEST is a fixed-width Value that holds the whole result of SHA-512 of the SHA-2 family. It is Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0062` NIST, format number `0xC000`, family BINARY. The Payload is exactly 32 WORDs (512 bits), and truncation is not allowed.

## Layout

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
Length extension TAG   1 WORD  0x0024 (36 WORD in total)
Issuer            1 WORD  0x0062 (NIST)
Format number     1 WORD  0xC000
Payload           32 WORD  SHA-512 Digest
```

## Interpretation and Validity

- The 64 Payload octets are read in the SHA-512 output order as they are. Within each WORD, the upper octet comes first.
- No separate GEUL endian conversion is applied to the digest bit string. The output octet sequence is only grouped two octets at a time in order and framed as 16-bit big-endian WORDs.
- A representation whose Payload is not 32 WORDs, or in which the result was arbitrarily truncated, is rejected. There is no descriptor or padding.

## Standards Basis

- The SHA-512 algorithm and the 512-bit result follow NIST [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final).
- The GEUL TAG, Length, and 16-bit WORD framing are rules this format adds and are not part of the SHA-2 algorithm.

## Length

- The total is exactly 36 WORDs: the TAG 1 WORD, Length extension TAG 1 WORD, Issuer 1 WORD, format number 1 WORD, and Payload 32 WORD, using `LLLL=1110`. There is no descriptor or padding.
- If the Payload is not exactly 32 WORDs, reject.

## Example

- The digest octets `d[0]` to `d[63]` are placed in order as the Payload WORDs `(d[0]<<8)|d[1]` to `(d[62]<<8)|d[63]`. The total Length is always 36 WORD.
