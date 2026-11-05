---
title: "ABSENT (0x000L)"
weight: 0
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "ABSENT", "UNKNOWN-VALUE", "NO-VALUE"]
summary: "ABSENT is a slot marker meaning \"not written\"."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ABSENT is a [slot marker](../slot-marker.md) meaning "not written". It is a statement about the document: this slot was not filled. It asserts nothing about the world.

| Item | Value |
|---|---|
| Name | `ABSENT` (spec document BIND `ABSENT`) |
| TAG ID | `0x000L` |
| Codec ID | `0x00000000` |
| Spec document | `0x00000000/codecs/0x00000000/` (DECLARE target `0000`) |
| Section | 0 `0000` (Reference entity), offset within section C = 0 |
| Kind | Reference · category: slot marker |
| TAG WORD | `0000 0000 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Not written. An optional field was omitted. Asserts nothing about the world |
| Hugo side | `reference/slot-marker.md` |

## Layout {#레이아웃}

```
TAG WORD          0000 0000 0000 0000      WORD 0x0000, 1 WORD
```

- There is no Payload. There is no target ID and no Quantifier ([slot marker](../slot-marker.md#레이아웃)).
- For `0x000L`, forms with a Payload (L ≥ 1) are Reserved.
- Text notation in `geul show` and `geul add`: `ABSENT`.

## Meaning {#뜻}

| Item | Not written |
|---|---|
| What it speaks about | **The document**: this slot was not filled |
| Logic | Asserts nothing |
| World assumption | Open world (no information) |
| Wikidata | The snak does not exist |

## Acceptance {#수용}

- Only a field with CODEC target `0000` accepts it. That field is an **optional field**. To omit an optional field, write a single WORD `0x0000` in its place. An optional field still always occupies its slot ([Codec spec document](../codec-spec.md#선택-필드와-자리-표지)). Examples: the Origin of [SOURCE](../edge/0x0C0L-source.md), and the unit, lower bound, and upper bound of [QUANTITY](../value/0x066L-quantity.md).
- It cannot be used in a wildcard, a field with no CODEC, a HEAD or BODY record slot, an Edge Id slot, or a raw-value field (the common rules of [slot marker](../slot-marker.md#수용-규칙)).

## Obligations of the reader {#읽는-쪽의-의무}

- **ABSENT says nothing about the world.** Do not read it as UNKNOWN-VALUE or NO-VALUE.
- A converter must not write UNKNOWN-VALUE for a value it failed to carry over (a value that exists in the source), because the source knows the value. A slot the source did not speak to (for example, the Origin of a [SOURCE](../edge/0x0C0L-source.md) whose provenance the source does not describe) is also written by the converter as ABSENT.
- In a judgment graph, ABSENT and "no statement" leave every comparison operator undetermined (U). To read ABSENT as empty, the input side must declare a closed world ([TOULMIN](../toulmin/_index.md#미상-위에서-판정하기)).

## Example {#예시}

`0x0000`, 1 WORD. Example: the unit slot of a QUANTITY whose unit is not written.

## Codec document {#코덱-문서}

The codec document holds only one DECLARE (target `0000`). With no Payload there is no FIELD. The decoder has the meaning and acceptance rules of the marker built in ([layer 0](../publishing.md#층)). Reading the marker does not require looking up the codec document.

## Related pages {#관련-페이지}

- [Slot marker](../slot-marker.md), [UNKNOWN-VALUE](0x001L-unknown-value.md), [NO-VALUE](0x002L-no-value.md)
- [CODEC](../edge/0x0BEL-codec.md), [Codec spec document](../codec-spec.md), [TRIPLE](../edge/0x0AAL-triple.md), [QUALIFIER](../edge/0x0ABL-qualifier.md)

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00000000/latest.geul` as read by `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000000000000000
BODY
#1 DECLARE 0x0000
#2 BIND #1 "ABSENT"
```
