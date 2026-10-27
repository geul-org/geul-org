---
title: "CRC32C"
weight: 1004
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "CRC32C is a fixed 5 WORD IETF Issuer format that holds the 32 bits of a Castagnoli CRC-32C result."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CRC32C is a fixed-width Value that holds a CRC-32C result. It is Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0020` IETF, format number `0xC000`, family BINARY. The Payload is exactly 2 WORDs (32 bits).

## Layout

```
TAG WORD          0x0A7C (0000 1010 0111 1100)  5 WORD in total
Issuer            1 WORD  0x0020 (IETF)
Format number     1 WORD  0xC000
Payload           2 WORD  CRC32C upper 16bit │ lower 16bit
```

## Interpretation and Validity

- In CRC parameter notation: width 32, Castagnoli polynomial `0x1EDC6F41`, refin/refout true, init `0xffffffff`, xorout `0xffffffff`.
- The unsigned 32-bit integer that results from the calculation is stored in big-endian WORD order. This serialization is not the SCTP Checksum field layout of RFC 3309 or the iSCSI digest byte mapping of RFC 3720 itself.
- If the Payload is not 2 WORDs, reject.

## Standards Basis

- The CRC-32C calculation and the Castagnoli polynomial and reflection rules follow the CRC32C definitions of [RFC 3309](https://www.rfc-editor.org/rfc/rfc3309.html) and [RFC 3720](https://www.rfc-editor.org/rfc/rfc3720.html).
- The GEUL TAG, Length, and the 16-bit big-endian WORD framing of the calculated 32-bit integer are rules this format adds.

## Length

- The total is exactly 5 WORDs: the TAG 1 WORD, Issuer 1 WORD, format number 1 WORD, and Payload 2 WORD, using the direct length `LLLL=0100`. There is no Length extension TAG, descriptor, or padding.
- If the Payload is not exactly 2 WORDs, reject.

## Example

The CRC-32C check value `0xe3069283` of ASCII `123456789`:

```
0A7C 0020 C000 e306 9283
```
