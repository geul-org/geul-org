---
title: "ISSUER-POINTER (0x040L)"
weight: 64
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "ISSUER-POINTER is a pointer-declaration Reference that points to an Issuer itself."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `ISSUER-POINTER` (spec document BIND `ISSUER-POINTER`) |
| TAG ID | `0x040L` |
| Codec ID | `0x00000400` |
| Spec document | `0x00000000/codecs/0x00000400/` (DECLARE target `0400`) |
| Section | 2 `0010` (Reference other), offset within section C = 0 |
| Kind | Reference · category: pointer-declaration |
| TAG WORD | `0000 0100 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Hugo side | `reference/issuer-pointer.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs in the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | Remaining raw value (`0xFFFF`) |  |  |

ISSUER-POINTER is a pointer-declaration Reference that points to an Issuer itself. It can be the target of an Issuer name `BIND`, a `LABEL`, and a judgment Edge.

## Layout {#레이아웃}

```
TAG WORD          0000 0100 0000 LLLL      Codec 0x040L
[Length extension TAG]
Issuer            2/4/16 WORD
```

- The Issuer width is the whole Payload. The Codec does not split the width. It is invalid if the width is not 2, 4, or 16 WORD, or if the Issuer value fits a narrower width (Issuer canonical form).
- If the Issuer is 16 WORD, the total is 17 WORD, so 1 WORD of Length extension is added.
- It is a single Codec slot, `0x040L`. There is no quantification (Identified).
- The Issuer value follows the assignment in [Issuer](../issuer.md).
- Uses: the BIND Subject in the Issuer list `issuers/` ([Publication addresses and version list](../publishing.md#issuer-목록)), the LABEL of an Issuer display name, a judgment about an Issuer, a signer, and other slots where the Issuer itself is the target.
- ISSUER-POINTER is the only form that points to an Issuer itself. Pointing to an Issuer with `EXTERNAL-ISSUER-*` using document ID `0` and target ID `0` is invalid.

## Examples {#예시}

| Issuer | WORD sequence |
|---|---|
| GEUL `0x00000000` | `0402 0000 0000` |
| IEEE `0x0000000D` | `0402 0000 000D` |

## Related pages {#관련-페이지}

- [Reference](_index.md), [DOC-POINTER](0x041L-doc-pointer.md), [EXTERNAL-ISSUER](0x02FL-external-issuer-2word.md), [Issuer and publication](../issuer.md)

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00000400/latest.geul` as read by `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000040000000000
BODY
#1 DECLARE 0x0400
#2 FIELD #1 rest
#3 BIND #1 "ISSUER-POINTER"
#4 BIND #2 "issuer"
```
