---
title: "UNKNOWN-VALUE (0x001L)"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "ABSENT", "UNKNOWN-VALUE", "NO-VALUE"]
summary: "UNKNOWN-VALUE is a slot marker meaning \"unknown\"."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UNKNOWN-VALUE is a [slot marker](../slot-marker.md) meaning "unknown". It is an assertion about the world: a value exists, but what it is is not known.

| Item | Value |
|---|---|
| Name | `UNKNOWN-VALUE` (spec document BIND `UNKNOWN-VALUE`) |
| TAG ID | `0x001L` |
| Codec ID | `0x00000010` |
| Spec document | `0x00000000/codecs/0x00000010/` (DECLARE target `0010`) |
| Section | 0 `0000` (Reference entity), offset within section C = 1 |
| Kind | Reference · category: slot marker |
| TAG WORD | `0000 0000 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Unknown. A value exists, but what it is is not known (Wikidata `somevalue`) |
| Hugo side | `reference/slot-marker.md` |

## Layout {#레이아웃}

```
TAG WORD          0000 0000 0001 0000      WORD 0x0010, 1 WORD
```

- There is no Payload. There is no target ID and no Quantifier ([slot marker](../slot-marker.md#레이아웃)).
- For `0x001L`, forms with a Payload (L ≥ 1) are Reserved.
- Text notation in `geul show` and `geul add`: `UNKNOWN`.

## Meaning {#뜻}

| Item | Unknown |
|---|---|
| What it speaks about | **The world**: a value exists. What it is is not known |
| Logic | `∃x. P(s, x)`, x is not identified |
| World assumption | Existence is closed, identity is open |
| Wikidata | `somevalue` |

## Acceptance {#수용}

- Only a field with CODEC target `0010` accepts it. That field accepts the assertion "unknown". Examples: [TRIPLE](../edge/0x0AAL-triple.md) Object, [QUALIFIER](../edge/0x0ABL-qualifier.md) Value, [SOURCE](../edge/0x0C0L-source.md) Origin.
- It cannot be used in a wildcard, a field with no CODEC, a HEAD or BODY record slot, an Edge Id slot, or a raw-value field (the common rules of [slot marker](../slot-marker.md#수용-규칙)).

## Obligations of the reader {#읽는-쪽의-의무}

- **UNKNOWN-VALUE is an existence assertion, not a value.** It is neither equal to nor different from any other value (the comparison is undetermined). Two UNKNOWN-VALUEs are not treated as the same value either. Each occurrence is an independent existential quantification (like a Wikidata blank node).
- Therefore two byte-identical TRIPLEs (`P40 Q… UNKNOWN` ×2) are not duplicates. There may be two children, or one. A TRIPLE that holds UNKNOWN-VALUE is not merged as a duplicate.
- When the identity is later revealed, publish a new version that corrects that TRIPLE. UNKNOWN-VALUE cannot be pointed to. When coreference is needed, use a LOCAL Variable ([Reference](_index.md#quantifier) Variable).
- **Rank applies as usual.** An UNKNOWN-VALUE TRIPLE is also a candidate when choosing the representative value (truthy).
- **Used as a QUALIFIER value, it changes the meaning of that qualification.** `P582 = UNKNOWN` means it has ended and the time is unknown. Do not read it as a proposition that is still valid.
- UNKNOWN-VALUE is an assertion that "there is one", so write it only when the source says so. Do not write UNKNOWN-VALUE for a value that could not be carried over.

## Example {#예시}

`0x0010`, 1 WORD. Example: the end time (P582) of the Q30–Q34266 border is unknown: `0AB7 0051 0C58 0191 0246 0051 080C 0010` (QUALIFIER, the Value slot is `0010`).

## Codec document {#코덱-문서}

The codec document holds only one DECLARE (target `0010`). With no Payload there is no FIELD. The decoder has the meaning and acceptance rules of the marker built in ([layer 0](../publishing.md#층)). Reading the marker does not require looking up the codec document.

## Related pages {#관련-페이지}

- [Slot marker](../slot-marker.md), [ABSENT](0x000L-absent.md), [NO-VALUE](0x002L-no-value.md)
- [CODEC](../edge/0x0BEL-codec.md), [Codec spec document](../codec-spec.md), [TRIPLE](../edge/0x0AAL-triple.md), [QUALIFIER](../edge/0x0ABL-qualifier.md)

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00000010/latest.geul` as read by `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000001000000000
BODY
#1 DECLARE 0x0010
#2 BIND #1 "UNKNOWN-VALUE"
```
