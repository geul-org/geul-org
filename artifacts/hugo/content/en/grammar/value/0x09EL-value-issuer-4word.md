---
title: "VALUE-ISSUER-4WORD (0x09EL)"
weight: 158
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text", "decimal", "time"]
summary: "VALUE-ISSUER-4WORD is a Value format defined by an Issuer."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

VALUE-ISSUER-4WORD is a Value format defined by an Issuer. It is one of the last three slots of the Value zone, and the Issuer width is 4 WORDs. The ISSUER layout is the same for all three Kinds ([Record and TAG WORD](../record.md#issuer-형식-레코드)).

| Item | Value |
|---|---|
| Name | `VALUE-ISSUER-4WORD` (spec document BIND `VALUE-ISSUER-4WORD`) |
| TAG ID | `0x09EL` |
| Codec ID | `0x000009E0` |
| Spec document | `0x00000000/codecs/0x000009E0/` (DECLARE target `09E0`) |
| Section | 4 `0100` (Value), offset within section C = 30 |
| Kind | Value · class: Issuer format |
| TAG WORD | `0000 1001 1110 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Issuer 4 WORDs and codec number 2 WORDs. The format is set by the Issuer's Codec document |
| Hugo path | `value/_index.md` |

## Layout {#레이아웃}

```
TAG WORD          0000 1001 1110 LLLL      Codec 0x09EL
[Length extension TAG]
Issuer            4 WORDs
Codec number      2 WORDs. Defined by the Issuer
Payload           Set by the Codec document the Issuer published
```

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs in the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | raw 4 WORDs |  |  |
| 2 | `codec` | #3 | raw 2 WORDs |  |  |
| 3 | `payload` | #4 | remaining raw bytes (`0xFFFF`) |  |  |

The composition of `payload` is set by the Codec document of that Issuer.

## Interpretation and validity {#해석과-유효성}

- GEUL knows only the Payload boundary through Length. A decoder that does not know the format knows the Kind, Length, Issuer, and codec number, and skips by Length.
- The interpretation of the Payload is set by the Issuer's Codec document. The Issuer-format Values registered so far are in the [Codec index](../codec-index.md#value-issuer-형식).
- The Issuer is written in the shortest width the value fits ([Issuer and publishing](../issuer.md#issuer-등급)). If the upper 2 WORDs of the Issuer value are 0, it is invalid. Write that value with the 2 WORD code ([VALUE-ISSUER-2WORD](0x09DL-value-issuer-2word.md)).
- The codec number is 2 WORDs. The Issuer assigns it without overlap inside its own `codecs/`, regardless of Kind. If the numbers run short, obtain one more Issuer.
- The codec document is placed under `<Issuer>/codecs/<codec number>/` of that Issuer ([Publishing addresses and version list](../publishing.md#id-표기)).
- The license of an Issuer format is set by that Issuer ([Issuer and publishing](../issuer.md#라이선스)).

## Related pages {#관련-페이지}

- [Value — Issuer format](_index.md#issuer-형식), [VALUE-ISSUER-2WORD](0x09DL-value-issuer-2word.md), [VALUE-ISSUER-16WORD](0x09FL-value-issuer-16word.md)
- [Record and TAG WORD](../record.md#issuer-형식-레코드), [Issuer and publishing](../issuer.md)

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x000009E0/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000009E000000000
BODY
#1 DECLARE 0x09E0
#2 FIELD #1 0x0004
#3 FIELD #1 0x0002
#4 FIELD #1 rest
#5 BIND #1 "VALUE-ISSUER-4WORD"
#6 BIND #2 "issuer"
#7 BIND #3 "codec"
#8 BIND #4 "payload"
```
