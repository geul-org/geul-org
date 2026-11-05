---
title: "CRC32C"
weight: 1033
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "CRC32C is a fixed-width Value that holds a CRC-32C result."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CRC32C is a fixed-width Value that holds a CRC-32C result. It is Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000007` IETF, codec number `0x0000C000`, family BINARY. The Payload is exactly 2 WORD (32 bits).

## Layout {#레이아웃}

```
TAG WORD          0x09D6 (0000 1001 1101 0110)  7 WORD in total
Issuer            2 WORD  0x00000007 (IETF)
Codec number      2 WORD  0x0000C000
Payload           2 WORD  CRC32C upper 16bit │ lower 16bit
```

## Interpretation and validity {#해석과-유효성}

- In CRC parameter notation: width 32, Castagnoli polynomial `0x1EDC6F41`, refin/refout true, init `0xFFFFFFFF`, xorout `0xFFFFFFFF`.
- The computed result, an unsigned 32-bit integer, is stored in big-endian WORD order. This serialization is not the SCTP Checksum field layout of RFC 3309 or the iSCSI digest byte mapping of RFC 3720 itself.
- If the Payload is not 2 WORD, it is rejected.

## Standards basis {#표준-근거}

- The CRC-32C computation and the Castagnoli polynomial and reflection rules follow the CRC32C definitions of [RFC 3309](https://www.rfc-editor.org/rfc/rfc3309.html) and [RFC 3720](https://www.rfc-editor.org/rfc/rfc3720.html).
- The GEUL TAG, Length, and the 16-bit big-endian WORD framing of the computed 32-bit integer are rules added by this format.

## Length {#길이}

- The total is exactly 7 WORD: TAG 1 WORD, Issuer 2 WORD, codec number 2 WORD, and Payload 2 WORD, and it uses the direct length `LLLL=0110`. There is no Length extension TAG, no descriptor, and no padding.
- If the Payload is not exactly 2 WORD, it is rejected.

## Example {#예시}

The CRC-32C check value `0xE3069283` of ASCII `123456789`:

```
09D6 0000 0007 0000 C000 E306 9283
```
