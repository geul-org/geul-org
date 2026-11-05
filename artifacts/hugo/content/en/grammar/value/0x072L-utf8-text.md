---
title: "UTF8-TEXT (0x072L·0x073L)"
weight: 114
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "UTF8-TEXT is a Value that holds a UTF-8 string with no language."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UTF8-TEXT is a Value that holds a UTF-8 string with no language. It uses the even/odd byte code pair 0x072L/0x073L.

| Item | Value |
|---|---|
| Name | `UTF8-TEXT` (even/odd pair. Names per code are in the member table below) |
| TAG ID | `0x072L`·`0x073L` |
| Section | 3 `0011` (Value), offset within section C = 18~19 |
| Kind | Value · family: TEXT |
| Index description | Valid UTF-8 byte sequence that implies no normalization. Even/odd bytes |
| Hugo path | `value/text/utf8-text.md` |

## Members {#구성원}

This page covers the two codes of an even/odd pair together. The even code is for values with an even byte count, the odd code for an odd byte count ([Record and TAG WORD](../record.md#가변-길이-바이트열)). There is one codec document per code. The fields of the two codec documents are the same; only the DECLARE target and the name (BIND) differ.

| TAG ID | Name | Byte count | Codec ID | Spec document | TAG WORD |
|---|---|---|---|---|---|
| `0x072L` | `UTF8-TEXT-EVEN` | even | `0x00000720` | `0x00000000/codecs/0x00000720/` | `0000 0111 0010 LLLL` |
| `0x073L` | `UTF8-TEXT-ODD` | odd | `0x00000730` | `0x00000000/codecs/0x00000730/` | `0000 0111 0011 LLLL` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs in the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | remaining raw bytes (`0xFFFF`) |  |  |

UTF8-TEXT is a Value that holds a valid UTF-8 byte sequence per RFC 3629. Use it for strings with no language, such as identifiers, codes, and file names.

## Layout {#레이아웃}

- Code: Value direct codes `0x072L` (even bytes) and `0x073L` (odd bytes). Family TEXT.
- The byte count is set by the least significant bit of the Codec and the number of Payload WORDs. It is `2 × Payload WORD count − least significant bit`, and no Byte Count is stored ([Value](_index.md)).

```
TAG WORD          0000 0111 001P LLLL      Codec 0x072L/0x073L
[Length extension TAG] when the total is 15 WORDs or more
Payload WORD 1st ... Nth          UTF-8 bytes / final zero padding
```

## Interpretation and validity {#해석과-유효성}

- The byte sequence must be well-formed shortest-form UTF-8 that conforms to the RFC 3629 grammar. The decoded result contains only Unicode scalar values in the range `U+0000..U+10FFFF`, and does not contain the surrogate range `U+D800..U+DFFF`.
- A U+FEFF at the start of the Payload (UTF-8 bytes `EF BB BF`) is treated as the same character as U+FEFF at any other position, and is allowed. The handling of a leading U+FEFF signature (BOM) described in RFC 3629 is not performed. It is not stripped or interpreted as a signature, but preserved as is.
- Unicode normalization is not enforced. The decoded original scalar sequence is preserved as is.
- The valid UTF-8 byte sequence is placed in the Payload without conversion. Within a WORD, the upper byte comes first. If the byte count is odd (odd code), the unused lower byte of the last WORD must be `00`.
- The Payload WORD count is `ceil(byte count/2)`. If the code is odd but the lower byte of the last WORD is not `00`, it is rejected.

## Standards basis {#표준-근거}

- Scalar ranges and well-formed byte sequences of UTF-8 follow [RFC 3629](https://www.rfc-editor.org/rfc/rfc3629).
- The even/odd code pair, zero padding, and the placement of GEUL TAG/Length and 16-bit WORDs are the canonical framing rules of this format.

## Length {#길이}

- The total is the WORD count of the TAG 1 WORD, the Length extension TAG (if present), and the Payload added together. 14 WORDs or fewer use a direct length; 15 WORDs or more use the `1110`·`1111` extended length, and the extension TAG is also included in the total ([Length](../record.md)).
- A 0-byte string is written as a 1 WORD record (TAG WORD only) with the even code ([Value](_index.md)).

## Examples {#예시}

- `A` (`41`) is 1 byte (odd), so it is `UTF8-TEXT-ODD` (`0x073L`), Payload `4100`, 2 WORDs in total, `LLLL=0001`. The whole is `0731 4100`.
- The empty string is the 1 WORD `0720` (`UTF8-TEXT-EVEN`, TAG WORD only).

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00000720/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000072000000000
BODY
#1 DECLARE 0x0720
#2 FIELD #1 rest
#3 BIND #1 "UTF8-TEXT-EVEN"
#4 BIND #2 "bytes"
```

The above is the codec document of `UTF8-TEXT-EVEN` (`0x072L`). The codec document of the other member (`UTF8-TEXT-ODD`) differs only in the codec ID in the DOC-ID, the DECLARE target, and the name bound to `#1` (BIND).
