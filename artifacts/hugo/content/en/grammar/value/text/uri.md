---
title: "URI"
weight: 69
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "URI is a Value that holds an ASCII byte sequence of the RFC 3986 URI grammar (an absolute URI including a scheme). It uses the even-odd byte code pair 0x44/0x45."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

URI is a Value that holds an ASCII byte sequence of the RFC 3986 grammar `URI = scheme ":" hier-part [ "?" query ] [ "#" fragment ]`. Since it includes a scheme, no base URI is needed for interpretation.

## Layout

- Code: Value direct codes `0x44` (even bytes) and `0x45` (odd bytes). Family TEXT.
- The byte count is set by the lowest bit of the Codec and the Payload WORD count. It is `2 × Payload WORD count − lowest bit`, and no Byte Count is placed ([Value](/grammar/value/)).

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x44/0x45
[Length extension TAG] when the total is 15 WORD or more
Payload WORD 1st ... Nth          URI bytes / final zero padding
```

## Interpretation and Validity

- The byte sequence must match the RFC 3986 grammar `URI = scheme ":" hier-part [ "?" query ] [ "#" fragment ]`. It can include a query and a fragment.
- The terminals of the URI grammar are US-ASCII characters. Allowed ASCII characters are stored as they are, and when percent-encoding an octet the form `pct-encoded = "%" HEXDIG HEXDIG` is used. Non-ASCII characters must not be put in directly as literal bytes.
- It must include a `scheme` and `:`. A relative reference uses [URI-RELATIVE-REF](/grammar/value/text/uri-relative-ref/) (IETF format numbers `0x8000`, `0x8001`).
- The URI production of RFC 3986 does not allow an empty string. A record of 0 bytes is not valid.
- Within a WORD, the upper byte comes first. If the byte count is odd (odd code), the unused lower byte of the last WORD must be `00`.
- The Payload WORD count is `ceil(byte count/2)`. If it is an odd code but the lower byte of the last WORD is not `00`, reject.

## Standards Basis

- The `URI`, URI character, and percent-encoding grammar follow [RFC 3986, Uniform Resource Identifier (URI): Generic Syntax](https://www.rfc-editor.org/rfc/rfc3986).
- The even-odd code pair, zero padding, and the GEUL TAG/Length and 16-bit WORD placement are the framing rules of this format.

## Length

- The total is the WORD count of the TAG 1 WORD, the Length extension TAG (if any), and the Payload. 14 WORDs or fewer use a direct length, and 15 WORDs or more use the `1110`/`1111` extended length, with the extension TAG also counted in the total ([Length](/grammar/record/)).

## Example

- `https://example.com/` is 20 ASCII bytes (even), so it is `URI-EVEN` (`0x44`).
- The Payload is 10 WORD: `6874 7470 733a 2f2f 6578 616d 706c 652e 636f 6d2f`.
- TAG 1 WORD plus Payload 10 WORD make 11 WORD in total, so `LLLL=1010`. The whole is `0D44 6874 7470 733a 2f2f 6578 616d 706c 652e 636f 6d2f`.

## GEUL Archive URI

`archive.geul.org` is an immutable content store for referencing large content such as external binaries and documents from GEUL. The recommended address format is `https://archive.geul.org/sha256/{digest}`. The same byte sequence must have the same URI, and once published, the bytes of the same URI must not be changed.

A URI Value only represents the location or address string of external content, and does not guarantee the identity or immutability of the target itself. Binaries and text beyond the maximum range of an inline Value can be referenced with an archive URI. The metadata of a stored object must record the following.

- The original URI and the time collected
- SHA-256 and Byte Length
- MIME type
- License identifier and version
- Author, source, and notices
- The URI of the license basis and, if needed, a copy of the basis at the time of collection

Whether something can be collected is judged not by whether it is free to access but by whether the right to redistribute is explicitly confirmed. The applicable license conditions, such as attribution, non-commercial, no derivatives, and share-alike, must be observed. For documents and content, record an explicit license such as Creative Commons; for software, use an SPDX License ID if possible.

Even if serving is stopped because of a rights issue or a correction, different bytes must not be placed under the existing URI. That URI must return a tombstone holding the reason and time of the stop, and the original digest and audit records must be preserved. However, if a legal obligation forbids retaining audit records, that obligation takes precedence.

An archive URI provides the access location and the content digest together. This content-address and immutability rule is a policy of the GEUL Archive profile, and the general grammar of the URI Value is not tied to `archive.geul.org`.
