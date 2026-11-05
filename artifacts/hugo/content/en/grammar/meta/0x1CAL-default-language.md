---
title: "DEFAULT-LANGUAGE (0x1CAL)"
weight: 458
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "Declares the default language of the document text."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `DEFAULT-LANGUAGE` (spec document BIND `DEFAULT-LANGUAGE`) |
| TAG ID | `0x1CAL` |
| Codec ID | `0x00001CA0` |
| Spec document | `0x00000000/codecs/0x00001CA0/` (DECLARE target `1CA0`) |
| Section | 14 `1110` (Meta), offset within section C = 10 |
| Kind | Meta · class: declaration |
| TAG WORD | `0001 1100 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Default language |
| Hugo side | `meta/declaration/default-language.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs within the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `language` | #2 | record | `07A0` LANGUAGE-SHORT-CODE, `0760` LANGUAGE-BCP47-CODE-EVEN, `0770` LANGUAGE-BCP47-CODE-ODD |  |

Declares the default language of the document text. Text with no language given is in this language.

## Layout {#레이아웃}

```
TAG WORD          0001 1100 1010 LLLL      Codec 0x1CAL
[Length extension TAG]
Payload           One language Value
```

- Codec: Meta `0x1CAL`, declaration class
- Payload: embedded Value ([LANGUAGE-BCP47-CODE](../value/0x076L-language-bcp47-code.md) or [LANGUAGE-SHORT-CODE](../value/0x07AL-language-short-code.md))
- Count: at most one

## Interpretation and validity {#해석과-유효성}

- A TANGEUL document states its authoring locale (for example, `en`, `ko`).

## Example {#예시}

- `en`: `0x1CA2 0x0761 0x656E`

## Spec document source {#규격-문서-원문}

The spec document `0x00000000/codecs/0x00001CA0/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001CA000000000
BODY
#1 DECLARE 0x1CA0
#2 FIELD #1 record
#3 BIND #1 "DEFAULT-LANGUAGE"
#4 BIND #2 "language"
#5 CODEC #2 0x07A0
#6 CODEC #2 0x0760
#7 CODEC #2 0x0770
```
