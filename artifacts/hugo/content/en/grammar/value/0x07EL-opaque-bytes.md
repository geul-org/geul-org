---
title: "OPAQUE-BYTES (0x07EL·0x07FL)"
weight: 126
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "OPAQUE-BYTES is an arbitrary byte sequence whose meaning and format are not set by this format itself."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

OPAQUE-BYTES is an arbitrary byte sequence whose meaning and format are not set by this format itself. It uses the Value direct codes `0x07EL` (even bytes) and `0x07FL` (odd bytes), family BINARY. The byte count is set by the least significant bit of the Codec and the number of Payload WORDs. It is `2 × Payload WORD count − least significant bit`, and no Byte Count is stored ([Value](_index.md)).

| Item | Value |
|---|---|
| Name | `OPAQUE-BYTES` (even/odd pair. Names per code are in the member table below) |
| TAG ID | `0x07EL`·`0x07FL` |
| Section | 3 `0011` (Value), offset within section C = 30~31 |
| Kind | Value · family: BINARY |
| Index description | Byte sequence of unknown meaning and format. Even/odd bytes |
| Hugo path | `value/binary/opaque-bytes.md` |

## Members {#구성원}

This page covers the two codes of an even/odd pair together. The even code is for values with an even byte count, the odd code for an odd byte count ([Record and TAG WORD](../record.md#가변-길이-바이트열)). There is one codec document per code. The fields of the two codec documents are the same; only the DECLARE target and the name (BIND) differ.

| TAG ID | Name | Byte count | Codec ID | Spec document | TAG WORD |
|---|---|---|---|---|---|
| `0x07EL` | `OPAQUE-BYTES-EVEN` | even | `0x000007E0` | `0x00000000/codecs/0x000007E0/` | `0000 0111 1110 LLLL` |
| `0x07FL` | `OPAQUE-BYTES-ODD` | odd | `0x000007F0` | `0x00000000/codecs/0x000007F0/` | `0000 0111 1111 LLLL` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs in the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | remaining raw bytes (`0xFFFF`) |  |  |

## Layout {#레이아웃}

```
TAG WORD          0000 0111 111P LLLL      Codec 0x07EL/0x07FL
[Length extension TAG] when the total is 15 WORDs or more
Payload WORD 1st ... Nth   bytes / final zero padding
```

## Interpretation and validity {#해석과-유효성}

- Read as many bytes as the byte count from the Payload in order. Within a WORD, the upper byte comes first.
- The Payload WORD count is `ceil(byte count/2)`. If the code is odd but the lower byte of the last WORD is not `00`, it is rejected.
- If the even/odd code, the Payload WORD count, and the zero padding do not agree with each other, it is rejected.

## Format status {#형식-지위}

- The even/odd code pair (`0x07EL` even, `0x07FL` odd), the payload arrangement, and the zero padding of the last WORD do not cite an external industry standard; they are GEUL's own framing.

## Length {#길이}

- The total is the WORD count of the TAG 1 WORD, the Length extension TAG (if present), and the Payload added together. 14 WORDs or fewer use a direct length; 15 WORDs or more use the `1110`·`1111` extended length, and the extension TAG is also included in the total ([Record and TAG WORD](../record.md)).
- 0 bytes is written as a 1 WORD record (TAG WORD only) with the even code (`0x07EL`) ([Value](_index.md)).

## Examples {#예시}

The bytes `AB CD EF` are 3 bytes (odd), so it is `OPAQUE-BYTES-ODD` (`0x07FL`), Payload `ABCD EF00`. The total is 3 WORDs, so `LLLL=0010`.

```
07F2 ABCD EF00
```

The empty byte sequence is the 1 WORD `07E0` (`OPAQUE-BYTES-EVEN`, TAG WORD only).

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x000007E0/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007E000000000
BODY
#1 DECLARE 0x07E0
#2 FIELD #1 rest
#3 BIND #1 "OPAQUE-BYTES-EVEN"
#4 BIND #2 "bytes"
```

The above is the codec document of `OPAQUE-BYTES-EVEN` (`0x07EL`). The codec document of the other member (`OPAQUE-BYTES-ODD`) differs only in the codec ID in the DOC-ID, the DECLARE target, and the name bound to `#1` (BIND).
