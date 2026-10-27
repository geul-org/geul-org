---
title: "UTF8-TEXT"
weight: 65
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "UTF8-TEXT is a Value that holds a UTF-8 string with no language. It uses the even-odd byte code pair 0x40/0x41."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UTF8-TEXT is a Value that holds a valid UTF-8 byte sequence of RFC 3629. It is used for strings with no language, such as identifiers, codes, and file names.

## Layout

- Code: Value direct codes `0x40` (even bytes) and `0x41` (odd bytes). Family TEXT.
- The byte count is set by the lowest bit of the Codec and the Payload WORD count. It is `2 × Payload WORD count − lowest bit`, and no Byte Count is placed ([Value](/grammar/value/)).

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x40/0x41
[Length extension TAG] when the total is 15 WORD or more
Payload WORD 1st ... Nth          UTF-8 bytes / final zero padding
```

## Interpretation and Validity

- The byte sequence must be well-formed shortest-form UTF-8 that matches the RFC 3629 grammar. The decoded result contains only Unicode scalar values in the range `U+0000..U+10FFFF`, and does not contain the surrogate range `U+D800..U+DFFF`.
- RFC 3629 describes handling of a leading U+FEFF signature depending on context. In addition, the GEUL canonical profile forbids the UTF-8 BOM byte sequence `EF BB BF` at the start of the Payload. A U+FEFF in another position is a character, not a BOM, so it is not forbidden by this rule.
- Unicode normalization is not enforced. The decoded original scalar sequence is preserved as it is.
- A valid UTF-8 byte sequence is put in the Payload without conversion. Within a WORD, the upper byte comes first. If the byte count is odd (odd code), the unused lower byte of the last WORD must be `00`.
- The Payload WORD count is `ceil(byte count/2)`. If it is an odd code but the lower byte of the last WORD is not `00`, reject.

## Standards Basis

- The scalar range of UTF-8, well-formed byte sequences, and the meaning of BOM handling follow [RFC 3629](https://www.rfc-editor.org/rfc/rfc3629).
- The BOM prohibition, the even-odd code pair, zero padding, and the GEUL TAG/Length and 16-bit WORD placement are the canonical framing rules of this format.

## Length

- The total is the WORD count of the TAG 1 WORD, the Length extension TAG (if any), and the Payload. 14 WORDs or fewer use a direct length, and 15 WORDs or more use the `1110`/`1111` extended length, with the extension TAG also counted in the total ([Length](/grammar/record/)).
- A 0-byte string is written as a 1 WORD record of the even code (the TAG WORD only) ([Value](/grammar/value/)).

## Examples

- `A` (`41`) is 1 byte (odd), so it is `UTF8-TEXT-ODD` (`0x41`), Payload `4100`, 2 WORD in total, `LLLL=0001`. The whole is `08C1 4100`.
- The empty string is `0840` (`UTF8-TEXT-EVEN`, the TAG WORD only), 1 WORD.
