---
title: "URI-RELATIVE-REF"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "URI-RELATIVE-REF is a Value that holds an ASCII byte sequence of the RFC 3986 relative-ref grammar. It uses the format numbers 0x8000/0x8001 of the IETF Issuer."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

URI-RELATIVE-REF is a Value that holds an ASCII byte sequence of the RFC 3986 `relative-ref` grammar. The base URI and the resolved result are not put in the Payload.

## Layout

- Code: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0020` IETF, format numbers `0x8000` (even bytes) and `0x8001` (odd bytes). Family TEXT.
- The byte count is set by the lowest bit of the format number and the Payload WORD count. It is `2 × Payload WORD count − lowest bit`, and no Byte Count is placed ([Value](/grammar/value/)).

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length extension TAG] when the total is 15 WORD or more
Issuer            1 WORD  0x0020 (IETF)
Format number     1 WORD  0x8000/0x8001
Payload WORD 1st ... Nth          relative-ref bytes / final zero padding
```

## Interpretation and Validity

- The byte sequence must match the RFC 3986 grammar `relative-ref = relative-part [ "?" query ] [ "#" fragment ]`.
- The terminals of the URI grammar are US-ASCII characters. Allowed ASCII characters are stored as they are, and when percent-encoding an octet the form `pct-encoded = "%" HEXDIG HEXDIG` is used. Non-ASCII characters must not be put in directly as literal bytes.
- `relative-part` can be `path-empty`, so an empty byte sequence is also a grammatically valid `relative-ref`.
- The base URI, the resolution context, and the resolved result are context outside this format.
- Within a WORD, the upper byte comes first. If the byte count is odd (odd code), the unused lower byte of the last WORD must be `00`.
- The Payload WORD count is `ceil(byte count/2)`. If it is an odd code but the lower byte of the last WORD is not `00`, reject.

## Standards Basis

- The `relative-ref`, URI character, and percent-encoding grammar follow [RFC 3986, Uniform Resource Identifier (URI): Generic Syntax](https://www.rfc-editor.org/rfc/rfc3986).
- The even-odd code pair, zero padding, and the GEUL TAG/Length and 16-bit WORD placement are the framing rules of this format. The base URI and the result of reference resolution are RFC context but are not put in the Payload.

## Length

- The total is the WORD count of the TAG 1 WORD, the Length extension TAG (if any), Issuer 1 WORD, format number 1 WORD, and the Payload. 14 WORDs or fewer use a direct length, and 15 WORDs or more use the `1110`/`1111` extended length, with the extension TAG also counted in the total ([Length](/grammar/record/)).
- 0 bytes is semantically allowed as an empty `relative-ref` and has no Payload WORD. Its physical layout is an open question below.

## Example

- `a/b?x=1` is 7 bytes (odd), so the format number is `0x8001` and the Payload is `612f 623f 783d 3100`. The total is 7 WORD, so `LLLL=0110`. The whole is `0B7C 0020 8001 612f 623f 783d 3100`.

## Open Questions

- The physical layout of an empty `relative-ref` (0 bytes). Not yet decided because a record with no Payload does not fit the "Payload of at least 1 WORD" rule.
