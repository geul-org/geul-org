---
title: "NO-VALUE (0x002L)"
weight: 2
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "ABSENT", "UNKNOWN-VALUE", "NO-VALUE"]
summary: "NO-VALUE is a slot marker meaning \"none\"."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

NO-VALUE is a [slot marker](../slot-marker.md) meaning "none". It is an assertion about the world: there is no value.

| Item | Value |
|---|---|
| Name | `NO-VALUE` (spec document BIND `NO-VALUE`) |
| TAG ID | `0x002L` |
| Codec ID | `0x00000020` |
| Spec document | `0x00000000/codecs/0x00000020/` (DECLARE target `0020`) |
| Section | 0 `0000` (Reference entity), offset within section C = 2 |
| Kind | Reference · category: slot marker |
| TAG WORD | `0000 0000 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | None. There is no value (Wikidata `novalue`) |
| Hugo side | `reference/slot-marker.md` |

## Layout {#레이아웃}

```
TAG WORD          0000 0000 0010 0000      WORD 0x0020, 1 WORD
```

- There is no Payload. There is no target ID and no Quantifier ([slot marker](../slot-marker.md#레이아웃)).
- For `0x002L`, forms with a Payload (L ≥ 1) are Reserved.
- Text notation in `geul show` and `geul add`: `NONE`.

## Meaning {#뜻}

| Item | None |
|---|---|
| What it speaks about | **The world**: there is no value |
| Logic | `¬∃x. P(s, x)` |
| World assumption | Closed world for (s, P, qualifying conditions) |
| Wikidata | `novalue` |

## Acceptance {#수용}

- Only a field with CODEC target `0020` accepts it. That field accepts the assertion "none". Examples: [TRIPLE](../edge/0x0AAL-triple.md) Object, [QUALIFIER](../edge/0x0ABL-qualifier.md) Value.
- It cannot be used in a wildcard, a field with no CODEC, a HEAD or BODY record slot, an Edge Id slot, or a raw-value field (the common rules of [slot marker](../slot-marker.md#수용-규칙)).

## Obligations of the reader {#읽는-쪽의-의무}

- **NO-VALUE is closed within the qualifying conditions of its proposition.** When a QUALIFIER is attached, it is closed only within that scope. Q30 P1304 NO-VALUE (P580 1811, P582 1816) means there was no central bank only during 1811 to 1816, and it does not contradict the value TRIPLE of the same property (Federal Reserve System, preferred).
- If a NO-VALUE and a value TRIPLE sit together with the same Subject and Predicate at the same rank, with no distinguishing qualifying condition, they contradict each other. The checker emits a warning. It does not reject. This state exists in Wikidata too, and the reader chooses by rank.
- **Rank applies as usual.** A NO-VALUE TRIPLE is also a candidate when choosing the representative value (truthy).
- **Used as a QUALIFIER value, it changes the meaning of that qualification.** `P582 = NONE` asserts that it has not ended. If there is no P582 QUALIFIER at all, it is not known whether it has ended.
- "None" can be said **only by writing** NO-VALUE. A TRIPLE missing from the document means not written (open world).

## Example {#예시}

`0x0020`, 1 WORD. Example: "no children" (P40) is `0AA8 0051 <Edge Id> 0191 0028 <Subject> 0020 0000` (TRIPLE, the Object slot is `0020`).

## Codec document {#코덱-문서}

The codec document holds only one DECLARE (target `0020`). With no Payload there is no FIELD. The decoder has the meaning and acceptance rules of the marker built in ([layer 0](../publishing.md#층)). Reading the marker does not require looking up the codec document.

## Related pages {#관련-페이지}

- [Slot marker](../slot-marker.md), [ABSENT](0x000L-absent.md), [UNKNOWN-VALUE](0x001L-unknown-value.md)
- [CODEC](../edge/0x0BEL-codec.md), [Codec spec document](../codec-spec.md), [TRIPLE](../edge/0x0AAL-triple.md), [QUALIFIER](../edge/0x0ABL-qualifier.md)

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00000020/latest.geul` as read by `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000002000000000
BODY
#1 DECLARE 0x0020
#2 BIND #1 "NO-VALUE"
```
