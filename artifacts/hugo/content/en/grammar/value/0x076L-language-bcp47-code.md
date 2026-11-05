---
title: "LANGUAGE-BCP47-CODE (0x076L·0x077L)"
weight: 118
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-BCP47-CODE is a Value that holds a complete BCP 47 language tag as an ASCII byte sequence."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LANGUAGE-BCP47-CODE is a Value that holds a complete BCP 47 language tag as an ASCII byte sequence. It uses the even/odd byte code pair 0x076L/0x077L.

| Item | Value |
|---|---|
| Name | `LANGUAGE-BCP47-CODE` (even/odd pair. Names per code are in the member table below) |
| TAG ID | `0x076L`·`0x077L` |
| Section | 3 `0011` (Value), offset within section C = 22~23 |
| Kind | Value · family: TEXT |
| Index description | ASCII byte sequence of a complete BCP 47 language tag in canonical casing. Even/odd bytes |
| Hugo path | `value/text/language-bcp47-code.md` |

## Members {#구성원}

This page covers the two codes of an even/odd pair together. The even code is for values with an even byte count, the odd code for an odd byte count ([Record and TAG WORD](../record.md#가변-길이-바이트열)). There is one codec document per code. The fields of the two codec documents are the same; only the DECLARE target and the name (BIND) differ.

| TAG ID | Name | Byte count | Codec ID | Spec document | TAG WORD |
|---|---|---|---|---|---|
| `0x076L` | `LANGUAGE-BCP47-CODE-EVEN` | even | `0x00000760` | `0x00000000/codecs/0x00000760/` | `0000 0111 0110 LLLL` |
| `0x077L` | `LANGUAGE-BCP47-CODE-ODD` | odd | `0x00000770` | `0x00000000/codecs/0x00000770/` | `0000 0111 0111 LLLL` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs in the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | remaining raw bytes (`0xFFFF`) |  |  |

LANGUAGE-BCP47-CODE is a Value that holds a complete BCP 47 language tag. Use it to state a language precisely, down to script, region, and variant.

## Layout {#레이아웃}

- Code: Value direct codes `0x076L` (even bytes) and `0x077L` (odd bytes). Family TEXT.
- The byte count is set by the least significant bit of the Codec and the number of Payload WORDs. It is `2 × Payload WORD count − least significant bit`, and no Byte Count is stored ([Value](_index.md)).
- The Payload is not UTF-8 text but the ASCII bytes of a BCP 47 tag.

```
TAG WORD          0000 0111 011P LLLL      Codec 0x076L/0x077L
[Length extension TAG] when the total is 15 WORDs or more
Payload WORD 1st ... Nth          BCP 47 tag bytes / final zero padding
```

## Interpretation and validity {#해석과-유효성}

- The byte sequence must be a well-formed BCP 47 language tag per RFC 5646. An empty string is not allowed.
- The Payload uses only ASCII letters, digits, and the hyphen-minus `-`. The separator must be ASCII `-`; `_`, spaces, and non-ASCII characters are not allowed.
- BCP 47 tag comparison is case-insensitive. The GEUL canonical profile writes all separators as `-`, and serializes language/extlang/variant/extension/private-use subtags in lowercase, script in Titlecase, and region in uppercase.
- Being well-formed is not enough. The validity of registered subtags and grandfathered tags is judged against a specific IANA Language Subtag Registry snapshot, and the date of that snapshot or the registry version must be preserved with it.
- Private-use tags and private-use subtags are allowed if they are well-formed under the RFC 5646 grammar. However, their meaning depends on agreement among the parties and is not defined by the IANA registry, so public interoperability is not guaranteed.
- If a deprecated subtag or grandfathered tag has a Preferred-Value in the same snapshot, the canonical GEUL form writes that replacement in canonical casing. A tag in its deprecated notation can be interpreted as input, but is not a canonical storage form.
- BCP 47 is an ASCII profile, so Unicode normalization requirements such as UTF-8 NFC do not apply.
- Within a WORD, the upper byte comes first. If the byte count is odd (odd code), the unused lower byte of the last WORD must be `00`.
- The Payload WORD count is `ceil(byte count/2)`. If the code is odd but the lower byte of the last WORD is not `00`, it is rejected.

## Standards basis {#표준-근거}

- The language tag grammar, case-insensitive interpretation, and the concepts of deprecated/Preferred-Value follow [RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646).
- The registry that judges tag validity is the [IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry).
- The even/odd code pair, zero padding, the canonical-casing storage policy, and the Length calculation are GEUL framing rules.

## Length {#길이}

- The total is the WORD count of the TAG 1 WORD, the Length extension TAG (if present), and the Payload added together. 14 WORDs or fewer use a direct length; 15 WORDs or more use the `1110`·`1111` extended length, and the extension TAG is also included in the total ([Length](../record.md)).

## Relation to LANGUAGE-SHORT-CODE {#language-short-code와의-관계}

- A tag that has a number in the GEUL Language Registry can be written as a 1 WORD [LANGUAGE-SHORT-CODE](0x07AL-language-short-code.md).
- A tag with no number in the registry (including tags that contain extension or private-use subtags) is written as LANGUAGE-BCP47-CODE. LANGUAGE-BCP47-CODE is also used when the original text of the full tag must be preserved.
- SHORT-CODE `n` and the LANGUAGE-BCP47-CODE of the tag the registry binds to `n` (ignoring case) denote the same language.

## Example {#예시}

- `ko-KR` is 5 ASCII bytes (odd), so it is `LANGUAGE-BCP47-CODE-ODD` (`0x077L`), and the Payload is `6B6F 2D4B 5200`.
- With the TAG 1 WORD and 3 Payload WORDs, the total is 4 WORDs and `LLLL=0011`. The whole is `0773 6B6F 2D4B 5200`.

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00000760/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000076000000000
BODY
#1 DECLARE 0x0760
#2 FIELD #1 rest
#3 BIND #1 "LANGUAGE-BCP47-CODE-EVEN"
#4 BIND #2 "bytes"
```

The above is the codec document of `LANGUAGE-BCP47-CODE-EVEN` (`0x076L`). The codec document of the other member (`LANGUAGE-BCP47-CODE-ODD`) differs only in the codec ID in the DOC-ID, the DECLARE target, and the name bound to `#1` (BIND).
