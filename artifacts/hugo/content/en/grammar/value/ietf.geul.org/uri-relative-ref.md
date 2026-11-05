---
title: "URI-RELATIVE-REF"
weight: 1036
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "URI-RELATIVE-REF is a Value that holds an ASCII byte sequence of the RFC 3986 relative-ref grammar."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

URI-RELATIVE-REF is a Value that holds an ASCII byte sequence of the RFC 3986 `relative-ref` grammar. The base URI and the resolved result are not put in the Payload.

## Layout {#레이아웃}

- Code: Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000007` IETF, codec number `0x00008000` (even number of bytes) or `0x00008001` (odd number of bytes). Family TEXT.
- The number of bytes is determined by the least significant bit of the codec number and the number of Payload WORD. It is `2 × number of Payload WORD − least significant bit`, and there is no Byte Count ([Value](../_index.md)).

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[Length ext. TAG] when the total is 15 WORD or more
Issuer            2 WORD  0x00000007 (IETF)
Codec number      2 WORD  0x00008000/0x00008001
Payload WORD 1st ... Nth          relative-ref bytes / final zero padding
```

## Interpretation and validity {#해석과-유효성}

- The byte sequence must conform to the RFC 3986 grammar `relative-ref = relative-part [ "?" query ] [ "#" fragment ]`.
- The terminals of the URI grammar are US-ASCII characters. Allowed ASCII characters are stored as is, and when an octet is percent-encoded, the form `pct-encoded = "%" HEXDIG HEXDIG` is used. Non-ASCII characters must not be put in directly as literal bytes.
- Since `relative-part` can be `path-empty`, an empty byte sequence is also a grammatically valid `relative-ref`.
- The base URI, the resolution context, and the resolved result are context outside this format.
- Within a WORD, the upper byte comes first. If the number of bytes is odd (odd code), the unused lower byte of the last WORD must be `00`.
- The number of Payload WORD is `ceil(number of bytes / 2)`. If the code is odd and the lower byte of the last WORD is not `00`, it is rejected.

## Standards basis {#표준-근거}

- The `relative-ref`, URI character, and percent-encoding grammar follow [RFC 3986, Uniform Resource Identifier (URI): Generic Syntax](https://www.rfc-editor.org/rfc/rfc3986).
- The even/odd code pair, the zero padding, and the placement in GEUL TAG/Length and 16-bit WORD are framing rules of this format. The base URI and the result of reference resolution are context of the RFC but are not put in the Payload.

## Length {#길이}

- The total is the number of WORD obtained by adding TAG 1 WORD, the Length extension TAG (if present), Issuer 2 WORD, codec number 2 WORD, and the Payload. 14 WORD or fewer use the direct length, and 15 WORD or more use the `1110` or `1111` extended length, and the extension TAG is included in the total ([Length](../../record.md)).
- Zero bytes are semantically allowed as an empty `relative-ref` and have no Payload WORD. Its physical placement is an open problem below.

## Example {#예시}

- `a/b?x=1` is 7 bytes (odd), so the codec number is `0x00008001` and the Payload is `612F 623F 783D 3100`. The total is 9 WORD, so `LLLL=1000`. The whole record is `09D8 0000 0007 0000 8001 612F 623F 783D 3100`.

## Open problems {#열린-문제}

- The physical placement of an empty `relative-ref` (0 bytes). A record without a Payload does not fit the rule "Payload of at least 1 WORD", so it has not yet been decided.
