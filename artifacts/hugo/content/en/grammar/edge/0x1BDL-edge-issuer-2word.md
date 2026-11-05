---
title: "EDGE-ISSUER-2WORD (0x1BDL)"
weight: 445
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "EDGE-ISSUER-2WORD is an Edge format defined by an Issuer."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EDGE-ISSUER-2WORD is an Edge format defined by an Issuer. It is one of the last three slots of the Edge region, and the Issuer width is 2 WORD. The ISSUER layout is the same for all three Kinds ([Record and TAG WORD](../record.md#issuer-형식-레코드)).

| Item | Value |
|---|---|
| Name | `EDGE-ISSUER-2WORD` (spec document BIND `EDGE-ISSUER-2WORD`) |
| TAG ID | `0x1BDL` |
| Codec ID | `0x00001BD0` |
| Spec document | `0x00000000/codecs/0x00001BD0/` (DECLARE target `1BD0`) |
| Section | 13 `1101` (Edge (last 3 slots, ISSUER)), offset within section C = 29 |
| Kind | Edge · classification: Issuer format |
| TAG WORD | `0001 1011 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Issuer 2 WORD and Codec number 2 WORD. The format is defined by the Issuer's Codec document |
| Hugo page | `edge/_index.md` |

## Layout {#레이아웃}

```
TAG WORD          0001 1011 1101 LLLL      Codec 0x1BDL
[Length extension TAG]
Issuer            2 WORD
Codec number      2 WORD. Defined by the Issuer
Edge Id           LOCAL Reference record. The first element after the Issuer and Codec number
Remaining Payload Defined by the Codec document the Issuer published
```

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs within the document is the Payload field order ([Codec spec document](../codec-spec.md)). The Edge Id of an Edge is not declared as a FIELD. The Edge Id of an EDGE-ISSUER comes after the Codec number and before the `payload` field ([Layout](#레이아웃)).

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | raw value 2 WORD |  |  |
| 2 | `codec` | #3 | raw value 2 WORD |  |  |
| 3 | `payload` | #4 | remaining raw value (`0xFFFF`) |  |  |

The composition of `payload` is defined by that Issuer's Codec document.

## Interpretation and validity {#해석과-유효성}

- GEUL knows only the Payload boundary, through Length. A decoder that does not know the format knows up to Kind, Length, Issuer, and Codec number, and skips the rest by Length.
- The Payload starts with the Edge Id (LOCAL Reference) ([Edge](_index.md#레이아웃)). The components after the Edge Id are defined by the Issuer's Codec document.
- The Issuer is written in the shortest width that holds its value ([Issuer and publication](../issuer.md#issuer-등급)). Issuer 2 WORD can hold any value.
- The Codec number is 2 WORD. The Issuer assigns it without overlap within its own `codecs/`, regardless of Kind. If the numbers run out, obtain another Issuer.
- The Codec document is placed under that Issuer's `<Issuer>/codecs/<Codec number>/` ([Publication address and version list](../publishing.md#id-표기)).
- The license of an Issuer format is set by that Issuer ([Issuer and publication](../issuer.md#라이선스)).

## Related pages {#관련-페이지}

- [Edge — Issuer format Edge](_index.md#issuer-형식-edge), [EDGE-ISSUER-4WORD](0x1BEL-edge-issuer-4word.md), [EDGE-ISSUER-16WORD](0x1BFL-edge-issuer-16word.md)
- [Record and TAG WORD](../record.md#issuer-형식-레코드), [Issuer and publication](../issuer.md)

## Spec document source text {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00001BD0/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001BD000000000
BODY
#1 DECLARE 0x1BD0
#2 FIELD #1 0x0002
#3 FIELD #1 0x0002
#4 FIELD #1 rest
#5 BIND #1 "EDGE-ISSUER-2WORD"
#6 BIND #2 "issuer"
#7 BIND #3 "codec"
#8 BIND #4 "payload"
```
