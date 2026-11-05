---
title: "URI (0x074L·0x075L)"
weight: 116
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "URI is a Value that holds an ASCII byte sequence in RFC 3986 URI (absolute URI with a scheme) grammar."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

URI is a Value that holds an ASCII byte sequence in RFC 3986 URI (absolute URI with a scheme) grammar. It uses the even/odd byte code pair 0x074L/0x075L.

| Item | Value |
|---|---|
| Name | `URI` (even/odd pair. Names per code are in the member table below) |
| TAG ID | `0x074L`·`0x075L` |
| Section | 3 `0011` (Value), offset within section C = 20~21 |
| Kind | Value · family: TEXT |
| Index description | ASCII byte sequence of the RFC 3986 `URI` production. Even/odd bytes |
| Hugo path | `value/text/uri.md` |

## Members {#구성원}

This page covers the two codes of an even/odd pair together. The even code is for values with an even byte count, the odd code for an odd byte count ([Record and TAG WORD](../record.md#가변-길이-바이트열)). There is one codec document per code. The fields of the two codec documents are the same; only the DECLARE target and the name (BIND) differ.

| TAG ID | Name | Byte count | Codec ID | Spec document | TAG WORD |
|---|---|---|---|---|---|
| `0x074L` | `URI-EVEN` | even | `0x00000740` | `0x00000000/codecs/0x00000740/` | `0000 0111 0100 LLLL` |
| `0x075L` | `URI-ODD` | odd | `0x00000750` | `0x00000000/codecs/0x00000750/` | `0000 0111 0101 LLLL` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs in the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | remaining raw bytes (`0xFFFF`) |  |  |

URI is a Value that holds an ASCII byte sequence in the RFC 3986 grammar `URI = scheme ":" hier-part [ "?" query ] [ "#" fragment ]`. Because it includes the scheme, no base URI is needed to interpret it.

## Layout {#레이아웃}

- Code: Value direct codes `0x074L` (even bytes) and `0x075L` (odd bytes). Family TEXT.
- The byte count is set by the least significant bit of the Codec and the number of Payload WORDs. It is `2 × Payload WORD count − least significant bit`, and no Byte Count is stored ([Value](_index.md)).

```
TAG WORD          0000 0111 010P LLLL      Codec 0x074L/0x075L
[Length extension TAG] when the total is 15 WORDs or more
Payload WORD 1st ... Nth          URI bytes / final zero padding
```

## Interpretation and validity {#해석과-유효성}

- The byte sequence must conform to the RFC 3986 grammar `URI = scheme ":" hier-part [ "?" query ] [ "#" fragment ]`. It may include a query and a fragment.
- The terminals of the URI grammar are US-ASCII characters. Allowed ASCII characters are stored as is, and when percent-encoding an octet, the form `pct-encoded = "%" HEXDIG HEXDIG` is used. Non-ASCII characters must not be placed directly as literal bytes.
- The `scheme` and `:` must be included. For a relative reference, use [URI-RELATIVE-REF](ietf.geul.org/uri-relative-ref.md) (IETF codec numbers `0x00008000`·`0x00008001`).
- The RFC 3986 URI production does not allow an empty string. A 0-byte record is not valid.
- Within a WORD, the upper byte comes first. If the byte count is odd (odd code), the unused lower byte of the last WORD must be `00`.
- The Payload WORD count is `ceil(byte count/2)`. If the code is odd but the lower byte of the last WORD is not `00`, it is rejected.

## Standards basis {#표준-근거}

- `URI`, URI characters, and the percent-encoding grammar follow [RFC 3986, Uniform Resource Identifier (URI): Generic Syntax](https://www.rfc-editor.org/rfc/rfc3986).
- The even/odd code pair, zero padding, and the placement of GEUL TAG/Length and 16-bit WORDs are the framing rules of this format.

## Length {#길이}

- The total is the WORD count of the TAG 1 WORD, the Length extension TAG (if present), and the Payload added together. 14 WORDs or fewer use a direct length; 15 WORDs or more use the `1110`·`1111` extended length, and the extension TAG is also included in the total ([Length](../record.md)).

## Example {#예시}

- `https://example.com/` is 20 ASCII bytes (even), so it is `URI-EVEN` (`0x074L`).
- The Payload is 10 WORDs: `6874 7470 733A 2F2F 6578 616D 706C 652E 636F 6D2F`.
- The TAG 1 WORD plus the 10 Payload WORDs make 11 WORDs in total, so `LLLL=1010`. The whole is `074A 6874 7470 733A 2F2F 6578 616D 706C 652E 636F 6D2F`.

## GEUL Archive URI {#geul-archive-uri}

`archive.geul.org` is conceived as an immutable content store for GEUL to reference large content such as external binaries and documents, and is not yet in operation. The recommended address form is `https://archive.geul.org/sha256/{digest}`. The same byte sequence must have the same URI, and once published, the bytes of the same URI must not be changed.

A URI Value only represents the location or address string of external content, and does not guarantee the identity or immutability of the target itself. Binaries and text that exceed the maximum range of an inline Value can be referenced by an archive URI. The metadata of a stored object must record the following items.

- Original URI and collection time
- SHA-256 and Byte Length
- MIME type
- License identifier and version
- Author, source, and notices
- License basis URI and, if needed, a copy of the basis at the time of collection

Whether something can be collected is judged not by whether it is freely accessible, but by whether the right to redistribute is explicitly confirmed. The applicable license conditions, such as attribution, non-commercial, no derivatives, and share-alike, must be observed. For documents and content, record an explicit license such as Creative Commons; for software, use an SPDX License ID where possible.

Even if provision is discontinued because of a rights issue or correction, different bytes must not be placed under the existing URI. That URI must return a tombstone containing the reason and time of discontinuation, and the original digest and audit records must be preserved. However, if a legal obligation prohibits preserving the audit records, that obligation takes precedence.

An archive URI provides both the access location and the content digest. This content-address and immutability rule is a policy of the GEUL Archive profile, and the general grammar of the URI Value does not depend on `archive.geul.org`.

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00000740/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000074000000000
BODY
#1 DECLARE 0x0740
#2 FIELD #1 rest
#3 BIND #1 "URI-EVEN"
#4 BIND #2 "bytes"
```

The above is the codec document of `URI-EVEN` (`0x074L`). The codec document of the other member (`URI-ODD`) differs only in the codec ID in the DOC-ID, the DECLARE target, and the name bound to `#1` (BIND).
