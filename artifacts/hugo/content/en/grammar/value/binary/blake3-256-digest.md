---
title: "BLAKE3-256-DIGEST"
weight: 1003
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "BLAKE3-256-DIGEST is a fixed 20 WORD Issuer format that holds the first 32 octets of the output of BLAKE3 default hash mode."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BLAKE3-256-DIGEST is a fixed-width Value that holds the first 32 octets (256 bits) of the output of the BLAKE3 default hash mode. It is Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, format number `0xC000`, family BINARY. The Payload is exactly 16 WORDs, and it does not hold keyed hash mode, key derivation mode, or XOF output of another length.

## Layout

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
Length extension TAG   1 WORD  0x0014 (20 WORD in total)
Issuer            1 WORD  0x0001 (ADHOC)
Format number     1 WORD  0xC000
Payload           16 WORD  BLAKE3-256 Digest
```

## Interpretation and Validity

- The Payload is the first 32 octets of the BLAKE3 default hash mode output stream. The output order is preserved, and within each WORD the upper octet comes first.
- No separate GEUL endian conversion is applied to the output. The output octet sequence is grouped two octets at a time in order and framed as 16-bit big-endian WORDs.
- A representation whose Payload is not 16 WORDs, or that holds keyed_hash, derive_key, or XOF output of another length, is rejected. There is no descriptor or padding.

## Standards Basis

- The algorithm and the definition of modes and output follow the BLAKE3 team's [official implementation repository](https://github.com/BLAKE3-team/BLAKE3) and the [BLAKE3 specification](https://github.com/BLAKE3-team/BLAKE3-specs/blob/master/blake3.pdf).
- The GEUL TAG, Length, and 16-bit WORD framing are rules this format adds and are not part of the BLAKE3 algorithm.

## Length

- The total is exactly 20 WORDs: the TAG 1 WORD, Length extension TAG 1 WORD, Issuer 1 WORD, format number 1 WORD, and Payload 16 WORD, using `LLLL=1110`. There is no descriptor or padding.
- If the Payload is not exactly 16 WORDs, reject.

## Example

- Output octets `d[0]` to `d[31]` are placed two octets at a time in output order in the 16 Payload WORDs. The total Length is always 20 WORD.
