---
title: "BLAKE3-256-DIGEST"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "BLAKE3-256-DIGEST is a fixed-width Value that holds the first 32 octets (256 bits) of BLAKE3 default hash mode output."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BLAKE3-256-DIGEST is a fixed-width Value that holds the first 32 octets (256 bits) of BLAKE3 default hash mode output. It is Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, codec number `0x0000C000`, family BINARY. The Payload is exactly 16 WORD and does not hold keyed hash mode, key derivation mode, or XOF output of other lengths.

## Layout {#레이아웃}

```
TAG WORD          0x09DE (0000 1001 1101 1110)  LLLL=1110
Length ext. TAG   1 WORD  0x0016 (22 WORD in total)
Issuer            2 WORD  0x00000002 (ADHOC)
Codec number      2 WORD  0x0000C000
Payload           16 WORD  BLAKE3-256 Digest
```

## Interpretation and validity {#해석과-유효성}

- The Payload is the first 32 octets of the BLAKE3 default hash mode output stream. The output order is preserved, and within each WORD the most significant octet comes first.
- No separate GEUL endian conversion is applied to the output. The output octet sequence is grouped two octets at a time in order and framed as 16-bit big-endian WORD.
- A representation whose Payload is not 16 WORD, or which holds a result of keyed_hash, derive_key, or XOF of another length, is rejected. There is no descriptor and no padding.

## Standards basis {#표준-근거}

- The algorithm and the mode and output definitions follow the BLAKE3 team's [official implementation repository](https://github.com/BLAKE3-team/BLAKE3) and the [BLAKE3 specification](https://github.com/BLAKE3-team/BLAKE3-specs/blob/master/blake3.pdf).
- The GEUL TAG, Length, and 16-bit WORD framing are rules added by this format and are not part of the BLAKE3 algorithm.

## Length {#길이}

- The total is exactly 22 WORD: TAG 1 WORD, Length extension TAG 1 WORD, Issuer 2 WORD, codec number 2 WORD, and Payload 16 WORD, and it uses `LLLL=1110`. There is no descriptor and no padding.
- If the Payload is not exactly 16 WORD, it is rejected.

## Example {#예시}

- Output octets `d[0]` through `d[31]` are placed in the 16 Payload WORD in output order, two octets each. The total Length is always 22 WORD.
