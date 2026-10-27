---
title: "SHA3-256-DIGEST"
weight: 1009
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA3-256-DIGEST is a fixed 20 WORD NIST Issuer format that holds the whole 256 bits of a SHA3-256 result."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA3-256-DIGEST is a fixed-width Value that holds the whole SHA3-256 result. It is Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0062` NIST, format number `0xC001`, family BINARY. The Payload is exactly 16 WORDs (256 bits), and truncation is not allowed.

## Layout

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
Length extension TAG   1 WORD  0x0014 (20 WORD in total)
Issuer            1 WORD  0x0062 (NIST)
Format number     1 WORD  0xC001
Payload           16 WORD  SHA3-256 Digest
```

## Interpretation and Validity

- The 32 Payload octets are read in the SHA3-256 output order as they are. Within each WORD, the upper octet comes first.
- No separate GEUL endian conversion is applied to the digest bit string. The output octet sequence is only grouped two octets at a time in order and framed as 16-bit big-endian WORDs.
- A representation whose Payload is not 16 WORDs, or in which the result was arbitrarily truncated, is rejected. There is no descriptor or padding.

## Standards Basis

- The SHA3-256 algorithm and the 256-bit result follow NIST [FIPS 202, SHA-3 Standard](https://csrc.nist.gov/pubs/fips/202/final). The NIST [Hash Functions project](https://csrc.nist.gov/Projects/hash-functions) also points to the SHA-3 standard.
- The GEUL TAG, Length, and 16-bit WORD framing are rules this format adds and are not part of the SHA-3 algorithm.

## Length

- The total is exactly 20 WORDs: the TAG 1 WORD, Length extension TAG 1 WORD, Issuer 1 WORD, format number 1 WORD, and Payload 16 WORD, using `LLLL=1110`. There is no descriptor or padding.
- If the Payload is not exactly 16 WORDs, reject.

## Example

- The digest octets `d[0]` to `d[31]` are placed two octets at a time in output order in the 16 Payload WORDs. The total Length is always 20 WORD.
