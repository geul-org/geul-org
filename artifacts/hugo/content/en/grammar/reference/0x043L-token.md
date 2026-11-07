---
title: "TOKEN-0·TOKEN-1 (0x043L·0x044L)"
weight: 67
date: 2026-11-07T12:00:00+09:00
lastmod: 2026-11-07T20:00:00+09:00
tags: ["grammar", "reference"]
summary: "TOKEN is a 2-WORD Reference that points to one entry of the GEUL token vocabulary. Joining the bytes of consecutive TOKEN records gives back the original text."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | TOKEN-0 | TOKEN-1 |
|---|---|---|
| Name | `TOKEN-0` (spec document BIND `TOKEN-0`) | `TOKEN-1` (spec document BIND `TOKEN-1`) |
| TAG ID | `0x043L` | `0x044L` |
| Codec ID | `0x00000430` | `0x00000440` |
| Spec document | `0x00000000/codecs/0x00000430/` (DECLARE target `0430`) | `0x00000000/codecs/0x00000440/` (DECLARE target `0440`) |
| Section | 2 `0010` (Reference other), offset within section C = 3 | 2 `0010`, C = 4 |
| Kind | Reference · category: declaration | Reference · category: declaration |
| TAG WORD | `0000 0100 0011 LLLL` | `0000 0100 0100 LLLL` |
| Token ID | `0`~`65,535` | `65,536`~`131,071` |
| Hugo side | `reference/token.md` | `reference/token.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs in the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `token-id` | #2 | raw 1 WORD |  | 60,536 ENUMs (token IDs `0x0000`~`0xEC77`). E.g. `0x0000` `<0x00>`, `0x021B` 가, `0x2DE5` ` the`, `0xE75E` 한국 … |

TOKEN is a Reference that points to one entry of the GEUL token vocabulary. The vocabulary is a BPE (Byte Pair Encoding) vocabulary trained on Korean and English, and one entry is one byte sequence. Joining the byte sequences of consecutive TOKEN records in order gives the bytes of the original text.

- If the vocabulary has no more than 65,536 entries, only TOKEN-0 is used. If it grows beyond that, the overflowing entries go to TOKEN-1. Even when TOKEN-1 is not used, the name of the first codec is TOKEN-0.
- One token is written as one record. Because the size is fixed at 2 WORDs, the k-th record of a token sequence lies 4k bytes from the start.

## Layout {#레이아웃}

```
TAG WORD          0x0431 (0000 0100 0011 0001)  TOKEN-0, 2 WORDs in total
Payload WORD 1st (16 bits)           token ID (uint16)

TAG WORD          0x0441 (0000 0100 0100 0001)  TOKEN-1, 2 WORDs in total
Payload WORD 1st (16 bits)           token ID − 65,536 (uint16)
```

- Code: Reference direct codes `0x043L`·`0x044L` (section 2).
- The Payload is the target ID. As in the [Reference common layout](_index.md), it is an unsigned big-endian integer written in the shortest width, and since the target ID is always `0`~`65,535`, the Payload is always 1 WORD (`0` is `0x0000`).
- There is no quantification (quantification is read only in the 5Q scheme).

## Interpretation and validity {#해석과-유효성}

- The target ID of each codec is the Payload value. The token ID in the whole vocabulary is the target ID for TOKEN-0, and 65,536 + the target ID for TOKEN-1.
- The canonical representation of a token is the spec document of its codec. For each token ID there is one [ENUM](../edge/0x0BDL-enum.md) on the FIELD `token-id`, and the name bound by [BIND](../edge/0x0A3L-bind.md) to that ENUM Edge Id is the byte sequence of the token. The ENUM code value of TOKEN-1 is the Payload value (token ID − 65,536).
- The vocabulary is a closed list. A token ID with no ENUM in the spec document is invalid. This Codec rule takes precedence over the general ENUM rule ("an undeclared code value is not an error").
- **Byte tokens:** Token IDs `0`~`255` are single bytes. The token ID is the byte value itself. A character not in the vocabulary, such as one outside Korean and English, has its UTF-8 bytes written as byte tokens. The BIND name of a byte token is the machine name `<0x00>`~`<0xFF>`, and its meaning is set by this rule.
- **Other tokens:** The byte sequence is valid UTF-8, and the BIND name is that byte sequence as is.
- **Decoding:** Read the sequence of TOKEN records from the beginning and join the byte sequence of each token. A UTF-8 character made of consecutive byte tokens is also restored by this joining. The result is identical, byte for byte, to the text before encoding.
- **Encoding:** How to split text into a token sequence (the splitting rule and the merge order) belongs to the vocabulary edition. The same text can give a different token sequence under a different vocabulary edition. The decoding result is the same regardless of edition.
- **Edition:** A vocabulary edition is a version of the spec document. Each edition records the hashes of the vocabulary file and the training log as the [SOURCE](../edge/0x0C0L-source.md) of the spec document HEAD. When the edition that produced a token sequence must be stated, leave its version ([CODEC-POINTER](0x042L-codec-pointer.md) (`0x00000000`, `0x00000430`, version ID `n`)) alongside.
- **Append-only:** A new edition only appends ENUMs and BINDs at the end. The byte sequence of a token ID once given is never changed, deleted, or rewritten. So every edition is a superset of the previous one, and a token sequence made with an earlier edition decodes identically with a later one. If the vocabulary is retrained from scratch and the meanings change, this codec is not used; a new codec number is assigned instead.
- Because a token is a Reference, it can be the subject of [BIND](../edge/0x0A3L-bind.md), [LABEL](../edge/0x0A4L-label.md), and [TRIPLE](../edge/0x0AAL-triple.md) (e.g. the frequency of a token, its language).

## Length {#길이}

- The total is exactly 2 WORDs, the TAG 1 WORD plus the Payload 1 WORD, and uses the direct length `LLLL=0001`. There is no Length extension TAG, Codec extension TAG, or Codec-specific TAG.
- If the Payload is not exactly 1 WORD, it is rejected.

## Example {#예시}

These are the numbers of vocabulary edition 1 (spec document `0x00000000/codecs/0x00000430` version 1). 60,536 tokens are assigned: bytes 256, basic characters 283 (space·newline·tab, ASCII, Hangul jamo, symbols), Hangul syllables 11,172 (`0x021B` 가 ~ `0x2DBE` 힣), merges 48,825. `0xEC78`~`0xFFFF` is left empty for appending.

| Token (byte sequence) | Token ID | Full WORDs |
|---|---|---|
| byte `0xE3` | `0x00E3` | `0431 00E3` |
| `가` | `0x021B` | `0431 021B` |
| ` the` (preceded by a space) | `0x2DE5` | `0431 2DE5` |
| ` GEUL` (preceded by a space) | `0x377F` | `0431 377F` |
| `한국어` | `0xD0B8` | `0431 D0B8` |

- In the spec document, ` the` is `ENUM #2 0x2DE5` and the `BIND " the"` bound to its Edge Id.
- A space attaches to the word after it. So ` the` and `the` (`0x328D`) are different tokens.

## Open problems {#열린-문제}

- The format for carrying a token sequence in a document. It is not decided which Edge or Value field accepts a sequence of TOKEN records.
- The canonical form of encoding. How to write the splitting rule and merge order in the spec document, and whether to fix a single token sequence for the same text.
- Interpretation across editions. When a reader meets a token ID newer than the edition it has, whether to discard it as invalid or keep the raw value and treat it as an "unknown token".

## Related pages {#관련-페이지}

- [Reference](_index.md), [CODEC-POINTER](0x042L-codec-pointer.md)
- [Codec spec document](../codec-spec.md), [ENUM](../edge/0x0BDL-enum.md), [BIND](../edge/0x0A3L-bind.md), [SOURCE](../edge/0x0C0L-source.md)
- A registry of the same kind: [LANGUAGE-SHORT-CODE](../value/0x07AL-language-short-code.md)

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00000430/latest.geul` as read with `geul show` (hex in uppercase). The two SOURCEs in HEAD are the SHA-256 of the vocabulary file and of the training log.

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000043000000000
#121077 SOURCE #0 ABSENT
#121078 QUALIFIER P4092 #121077 SHA-256-DIGEST(0xE4DEEA8BA9FE74BEAAD836FEBE06CF4DAC32B30D1E9A85308D0A6E0A9CB6A417)
#121079 SOURCE #0 ABSENT
#121080 QUALIFIER P4092 #121079 SHA-256-DIGEST(0x5B2C82701BCFFD3589DC9640B398B3F07F0AC7F18E483486AF5221C3D30D4D9C)
BODY
#1 DECLARE 0x0430
#2 FIELD #1 0x0001
#3 BIND #1 "TOKEN-0"
#4 BIND #2 "token-id"
#5 ENUM #2 0x0000
#6 BIND #5 "<0x00>"
#7 ENUM #2 0x0001
#8 BIND #7 "<0x01>"
… (ENUM·BIND 121,064 lines omitted)
#121073 ENUM #2 0xEC76
#121074 BIND #121073 "etap"
#121075 ENUM #2 0xEC77
#121076 BIND #121075 " Aman"
```
