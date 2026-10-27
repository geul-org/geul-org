---
title: "SHA-256-DIGEST"
weight: 98
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA-256-DIGEST is a fixed 18 WORD Value that holds the whole 256 bits of a SHA-256 result."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA-256-DIGEST is a fixed-width Value that holds the whole result of SHA-256 of the SHA-2 family. It is Value direct code `0x61`, family BINARY. The Payload is exactly 16 WORDs (256 bits), and truncation is not allowed.

## Layout

```
TAG WORD          0x0F61 (0000 1111 0110 0001)  LLLL=1110
Length extension TAG   1 WORD  0x0012 (18 WORD in total)
Payload           16 WORD  SHA-256 Digest
```

## Interpretation and Validity

- The 32 Payload octets are read in the SHA-256 output order as they are. Within each WORD, the upper octet comes first.
- No separate GEUL endian conversion is applied to the digest bit string. The output octet sequence is only grouped two octets at a time in order and framed as 16-bit big-endian WORDs.
- A representation whose Payload is not 16 WORDs, or in which the result was arbitrarily truncated, is rejected. There is no descriptor or padding.

## Standards Basis

- The SHA-256 algorithm and the 256-bit result follow NIST [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final).
- The GEUL TAG, Length, and 16-bit WORD framing are rules this format adds and are not part of the SHA-2 algorithm.

## Length

- The total is exactly 18 WORDs: the TAG 1 WORD, Length extension TAG 1 WORD, and Payload 16 WORD, using `LLLL=1110`. There is no descriptor or padding.
- If the Payload is not exactly 16 WORDs, reject.

## Example

- The digest octets `d[0]` to `d[31]` are placed in order as the Payload WORDs `(d[0]<<8)|d[1]` to `(d[30]<<8)|d[31]`. The total Length is always 18 WORD.
