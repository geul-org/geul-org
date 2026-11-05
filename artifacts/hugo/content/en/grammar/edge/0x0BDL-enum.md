---
title: "ENUM (0x0BDL)"
weight: 189
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "ENUM is a statement Edge that attaches a meaning to one code value of a raw-value field."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `ENUM` (specification document BIND `ENUM`) |
| TAG ID | `0x0BDL` |
| Codec ID | `0x00000BD0` |
| Specification document | `0x00000000/codecs/0x00000BD0/` (DECLARE target `0BD0`) |
| Section | 5 `0101` (Edge statement), offset within section C = 29 |
| Kind | Edge · family: statement, group: other |
| TAG WORD | `0000 1011 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | One code value of a raw-value field. Field, code value |
| Hugo side | `edge/enum.md` |

## Fields (specification document) {#필드-규격-문서}

The order of FIELDs in the document is the order of the Payload fields ([Codec specification document](../codec-spec.md)). The Edge Id of an Edge is not declared as a FIELD.

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `field` | #2 | record | `0050` LOCAL |  |
| 2 | `code` | #3 | remaining raw value (`0xFFFF`) |  |  |

ENUM is a statement Edge that attaches a meaning to one code value of a raw-value field. Codec `0x0BDL`.

Together with [FIELD](0x0BCL-field.md), it is the vocabulary for writing Codec specifications. The layout is built into the decoder ([Codec specification document](../codec-spec.md)).

## Layout {#레이아웃}

```
TAG WORD          0000 1011 1101 LLLL
[Length extension TAG]
Edge Id           LOCAL Reference record
Field             LOCAL Reference record pointing to a FIELD Edge
Code value        Raw value. The same number of WORDs as that FIELD's width
```

## Interpretation and validity {#해석과-유효성}

- The field must be a raw-value FIELD (width `n ≥ 1`). ENUM is not attached to a record field. The meaning of a record is stated by the Codec of that record.
- The code value is exactly the width of that FIELD. The boundary is checked by the Length of the ENUM record.
- The same code value is not declared twice for one field.
- The name of a code value is bound to the ENUM Edge Id with [BIND](0x0A3L-bind.md). All UTF8-TEXT attached to DECLARE, FIELD, ENUM, and CODEC is attached with BIND, never with another Edge such as LABEL.
- An undeclared code value is not an error. A viewer shows it as the raw value. Whether to close the allowed values is up to the Codec specification, and the present vocabulary has no marker for closing.

## Length {#길이}

```
total = 1 + N_len + N_id + N_field + n WORD
```

## Example (non-normative) {#예시-비규범}

Declare code `0x0001` on the reason-category field (FIELD #4, raw value of 1 WORD) of the TOMBSTONE specification document. Edge Id 10. The name is bound separately with BIND. The reason-category code table is not yet defined, so the code value is an example.

- TAG 1 + Edge Id 2 + field 2 + code value 1 = 6 WORDs, `LLLL = 0101`.

```
0BD5 0051 000A 0051 0004 0001
```

The TRIPLE specification document places three ENUMs (`0`, `1`, `2`) on the Rank field (FIELD #5) and BINDs them as `normal`, `preferred`, and `deprecated` respectively ([TRIPLE](0x0AAL-triple.md)).

## Related pages {#관련-페이지}

- [DECLARE](0x0BBL-declare.md), [FIELD](0x0BCL-field.md), [CODEC](0x0BEL-codec.md), [BIND](0x0A3L-bind.md)
- [Codec specification document](../codec-spec.md)

## Specification document source {#규격-문서-원문}

This is the specification document `0x00000000/codecs/0x00000BD0/latest.geul` as read with `geul show` (hexadecimal in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000BD000000000
BODY
#1 DECLARE 0x0BD0
#2 FIELD #1 record
#3 FIELD #1 rest
#4 BIND #1 "ENUM"
#5 BIND #2 "field"
#6 BIND #3 "code"
#7 CODEC #2 0x0050
```
