---
title: "REFERENCE-ISSUER-4WORD (0x05EL)"
weight: 94
date: 2026-11-03T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "issuer"]
summary: "REFERENCE-ISSUER-4WORD is a Reference form defined by an Issuer."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

REFERENCE-ISSUER-4WORD is a Reference form defined by an Issuer. It is one of the last three slots of the Reference range, and the Issuer width is 4 WORD. The ISSUER layout is the same in all three Kinds ([Record and TAG WORD](../record.md#issuer-형식-레코드)).

| Item | Value |
|---|---|
| Name | `REFERENCE-ISSUER-4WORD` (spec document BIND `REFERENCE-ISSUER-4WORD`) |
| TAG ID | `0x05EL` |
| Codec ID | `0x000005E0` |
| Spec document | `0x00000000/codecs/0x000005E0/` (DECLARE target `05E0`) |
| Section | 2 `0010` (Reference other), offset within section C = 30 |
| Kind | Reference · category: Issuer form |
| TAG WORD | `0000 0101 1110 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Issuer 4 WORD and codec number 2 WORD. The form is set by the Issuer's Codec document |
| Hugo side | `reference/reference-issuer.md` |

## Layout {#레이아웃}

```
TAG WORD          0000 0101 1110 LLLL      Codec 0x05EL
[Length extension TAG]
Issuer            4 WORD
Codec number      2 WORD. Defined by the Issuer
Payload           Set by the Codec document the Issuer published
```

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs in the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | Raw value, 4 WORD |  |  |
| 2 | `codec` | #3 | Raw value, 2 WORD |  |  |
| 3 | `payload` | #4 | Remaining raw value (`0xFFFF`) |  |  |

The composition of `payload` is set by the Codec document of that Issuer.

## Interpretation and validity {#해석과-유효성}

- GEUL knows only the Payload boundary from Length. A decoder that does not know the form knows the Kind, Length, Issuer, and codec number, and skips the rest by Length.
- The meaning of the codec number, the quantification, and what it points to are set by the Codec document the Issuer published. The common Reference rules, such as the shortest width for a target ID and the reading of quantification, do not apply ([REFERENCE-ISSUER](_index.md#해석과-유효성)).
- Write the Issuer in the shortest width that fits the value ([Issuer and publication](../issuer.md#issuer-등급)). A value whose upper 2 WORD of the Issuer are 0 is invalid. Write that value with the 2 WORD code ([REFERENCE-ISSUER-2WORD](0x05DL-reference-issuer-2word.md)).
- The codec number is 2 WORD. The Issuer assigns it so that it does not collide within its own `codecs/`, regardless of Kind. If the numbers run out, obtain one more Issuer.
- A codec document is placed under `<Issuer>/codecs/<codec number>/` of that Issuer ([Publication addresses and version list](../publishing.md#id-표기)).
- The license of an Issuer form is set by that Issuer ([Issuer and publication](../issuer.md#라이선스)).

## Related pages {#관련-페이지}

- [REFERENCE-ISSUER](_index.md#reference-issuer), [REFERENCE-ISSUER-2WORD](0x05DL-reference-issuer-2word.md), [REFERENCE-ISSUER-16WORD](0x05FL-reference-issuer-16word.md)
- [Record and TAG WORD](../record.md#issuer-형식-레코드), [Issuer and publication](../issuer.md)

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x000005E0/latest.geul` as read by `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000005E000000000
BODY
#1 DECLARE 0x05E0
#2 FIELD #1 0x0004
#3 FIELD #1 0x0002
#4 FIELD #1 rest
#5 BIND #1 "REFERENCE-ISSUER-4WORD"
#6 BIND #2 "issuer"
#7 BIND #3 "codec"
#8 BIND #4 "payload"
```
