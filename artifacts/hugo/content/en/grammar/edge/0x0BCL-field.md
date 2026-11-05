---
title: "FIELD (0x0BCL)"
weight: 188
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "FIELD is a statement Edge that declares one field of a Codec Payload."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `FIELD` (specification document BIND `FIELD`) |
| TAG ID | `0x0BCL` |
| Codec ID | `0x00000BC0` |
| Specification document | `0x00000000/codecs/0x00000BC0/` (DECLARE target `0BC0`) |
| Section | 5 `0101` (Edge statement), offset within section C = 28 |
| Kind | Edge · family: statement, group: other |
| TAG WORD | `0000 1011 1100 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | One Payload field. The DECLARE it belongs to, width: record (TAG's Length) or raw value of n WORDs |
| Hugo side | `edge/field.md` |

## Fields (specification document) {#필드-규격-문서}

The order of FIELDs in the document is the order of the Payload fields ([Codec specification document](../codec-spec.md)). The Edge Id of an Edge is not declared as a FIELD.

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `declare` | #2 | record | `0050` LOCAL |  |
| 2 | `width` | #3 | raw value, 1 WORD |  | `0x0000` record, `0xFFFF` rest |

FIELD is a statement Edge that declares one field of a Codec Payload. Codec `0x0BCL`.

A FIELD points to its own [DECLARE](0x0BBL-declare.md). The FIELDs pointing to one DECLARE compose the Payload in their order in the document. The layout is built into the decoder ([Codec specification document](../codec-spec.md)).

## Layout {#레이아웃}

```
TAG WORD          0000 1011 1100 LLLL
Edge Id           LOCAL Reference record
DECLARE           LOCAL Reference record. The DECLARE Edge this field belongs to
Width             1 WORD. 0 = record, n (1~65534) = raw value of n WORDs, 0xFFFF = remaining raw value
```

## Interpretation and validity {#해석과-유효성}

- DECLARE points to a DECLARE Edge in the same document. One FIELD belongs to only one DECLARE. The order is not written separately; it is the order in which the FIELD records are placed in the document.
- The FIELD specification document declares DECLARE as a field of width `0` (record) with CODEC `0050` (LOCAL). So in the viewer graph it is drawn as a FIELD → DECLARE connection.
- Width `0` is a record field. It starts with a TAG WORD and is read for the Length of that TAG (interpretation rules of [DECLARE](0x0BBL-declare.md)).
- Width `n` (1~65534) is a raw-value field. It is always exactly n WORDs.
- Width `0xFFFF` is the remaining raw value. Only one is placed in a DECLARE, and it may be at the start, middle, or end. Its width is the remaining WORDs set by the TAG Length of the enclosing record minus the widths of the fields after it. So all fields after the remaining field must be fixed-width raw values (a record must be read from the front to know its end). It may be 0 WORDs. No ENUM is attached.
- The Kind and Codec a field accepts are specified with [CODEC](0x0BEL-codec.md). A record field accepts any record if there is no CODEC, and must be one of them if there is. If one CODEC is placed on a raw-value field, that raw value is interpreted as that Value without its TAG.
- A field name is bound to the FIELD Edge Id with [BIND](0x0A3L-bind.md) (e.g. `doc`, `hash`). All UTF8-TEXT attached to DECLARE, FIELD, ENUM, and CODEC is attached with BIND, never with another Edge such as LABEL.
- The meaning of the code values of a raw-value field is attached with [ENUM](0x0BDL-enum.md).
- A field that points to another node in the graph is not marked separately. If a record field is a Reference, that is the connection.

## Length {#길이}

```
total = 1 + 2 + 2 + 1 WORD   (when Edge Id and DECLARE are LOCAL 1-WORD IDs)
```

## Examples (non-normative) {#예시-비규범}

- Record field: Edge Id 7, DECLARE #1, width `0`. TAG 1 + Edge Id 2 + DECLARE 2 + width 1 = 6 WORDs. To accept only LOCAL, see the [CODEC](0x0BEL-codec.md) example.

```
0BC5 0051 0007 0051 0001 0000
```

- For a raw-value field such as a content hash, see the [DECLARE](0x0BBL-declare.md) example.

## Related pages {#관련-페이지}

- [DECLARE](0x0BBL-declare.md), [ENUM](0x0BDL-enum.md), [CODEC](0x0BEL-codec.md), [BIND](0x0A3L-bind.md)
- [Codec specification document](../codec-spec.md)

## Specification document source {#규격-문서-원문}

This is the specification document `0x00000000/codecs/0x00000BC0/latest.geul` as read with `geul show` (hexadecimal in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000BC000000000
BODY
#1 DECLARE 0x0BC0
#2 FIELD #1 record
#13 CODEC #2 0x0050
#3 FIELD #1 0x0001
#5 ENUM #3 0x0000
#6 ENUM #3 0xFFFF
#7 BIND #1 "FIELD"
#8 BIND #2 "declare"
#9 BIND #3 "width"
#11 BIND #5 "record"
#12 BIND #6 "rest"
```
