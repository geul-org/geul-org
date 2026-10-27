---
title: "OPAQUE-BYTES"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "OPAQUE-BYTES is a GEUL Issuer format that holds an arbitrary byte sequence whose meaning and format it does not itself set."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

OPAQUE-BYTES is an arbitrary byte sequence whose meaning and format this format itself does not set. It is Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0000` GEUL, format numbers `0xC000` and `0xC001` (even and odd bytes), family BINARY. The byte count is set by the lowest bit of the format number and the Payload WORD count. It is `2 × Payload WORD count − lowest bit`, and no Byte Count is placed ([Value](/grammar/value/)).

## Layout

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length extension TAG] when the total is 15 WORD or more
Issuer            1 WORD  0x0000 (GEUL)
Format number     1 WORD  0xC000/0xC001
Payload WORD 1st ... Nth   bytes / final zero padding
```

## Interpretation and Validity

- Read as many bytes as the byte count from the Payload in order. Within a WORD, the upper byte comes first.
- The Payload WORD count is `ceil(byte count/2)`. If it is an odd code but the lower byte of the last WORD is not `00`, reject.
- If the even-odd code, the Payload WORD count, and the zero padding do not match each other, reject.

## Format Status

- The even-odd code pair, the payload placement, and the zero padding of the last WORD are not cited from an external industry standard but are GEUL-specific framing.

## Length

- The total is the WORD count of the TAG 1 WORD, the Length extension TAG (if any), Issuer 1 WORD, format number 1 WORD, and the Payload. 14 WORDs or fewer use a direct length, and 15 WORDs or more use the `1110`/`1111` extended length, with the extension TAG also counted in the total ([Records and the TAG WORD](/grammar/record/)).
- 0 bytes is written as a 3 WORD record with no Payload (TAG, Issuer, format number) under the even format number (`0xC000`).

## Example

The bytes `ab cd ef` are 3 bytes (odd), so the format number is `0xC001` and the Payload is `abcd ef00`. The total is 5 WORD, so `LLLL=0100`.

```
0A7C 0000 C001 abcd ef00
```
