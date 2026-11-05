---
title: "DECLARE (0x0BBL)"
weight: 187
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DECLARE is a statement Edge that declares the Payload composition of one Codec."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `DECLARE` (specification document BIND `DECLARE`) |
| TAG ID | `0x0BBL` |
| Codec ID | `0x00000BB0` |
| Specification document | `0x00000000/codecs/0x00000BB0/` (DECLARE target `0BB0`) |
| Section | 5 `0101` (Edge statement), offset within section C = 27 |
| Kind | Edge · family: statement, group: other |
| TAG WORD | `0000 1011 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Declaration of the Payload composition of one Codec. Target Kind and Codec |
| Hugo side | `edge/declare.md` |

## Fields (specification document) {#필드-규격-문서}

The order of FIELDs in the document is the order of the Payload fields ([Codec specification document](../codec-spec.md)). The Edge Id of an Edge is not declared as a FIELD.

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `target` | #2 | raw value, 1 WORD |  |  |
| 2 | `issuer` | #3 | remaining raw value (`0xFFFF`) |  |  |

DECLARE is a statement Edge that declares the Payload composition of one Codec. Codec `0x0BBL`.

Together with [FIELD](0x0BCL-field.md) (`0x0BCL`), [ENUM](0x0BDL-enum.md) (`0x0BDL`), and [CODEC](0x0BEL-codec.md) (`0x0BEL`), it is the vocabulary for writing Codec specifications ([Codec specification document](../codec-spec.md)). The layouts of the four Edges are built into the decoder. Each Codec specification document written in this vocabulary is an ordinary document. One specification serves validation, decomposition, and display (viewer) together. A viewer draws according to the specification, without code for each Codec.

## Layout {#레이아웃}

```
TAG WORD          0000 1011 1011 LLLL
[Length extension TAG]
Edge Id           LOCAL Reference record
Target            1 WORD. Only the Codec slot (section and C) of the declared Codec's TAG WORD is used (LLLL = 0)
[Issuer, codec number]  When declaring an Issuer codec. Issuer and codec number, 2 WORDs. Same layout as the Codec extension TAG, and the same for all three Kinds
                  The specification document of the ISSUER code itself (GEUL Issuer) holds only the target
```

- The field list is not placed in DECLARE. Each [FIELD](0x0BCL-field.md) points to its own DECLARE, and the order of those FIELDs in the document is the order of the Payload fields.

## Interpretation rules {#해석-규칙}

These are the rules for reading and notating a record by its Codec specification.

- A raw-value field is read as many WORDs as the fixed count that FIELD declares. One field may be a remaining raw value (width `0xFFFF`), which reads the remaining WORDs minus the widths of the fixed fields after it. Only fixed-width raw values are placed after the remaining field.
- A record field starts with a TAG WORD and is read for the Length of that TAG.
- A raw-value field is an n-WORD big-endian unsigned integer. It is notated as `0x` + width×4 hex digits, and if an ENUM of the same value exists, its BIND name is notated together.
- The meaning of a record field is set by the Codec specification of that record. Values that need interpretation, such as sign, fraction, or date, are placed as a Value record, not as a raw value.

There are no other boundary rules. A Codec with two or more variable raw values, with a record or variable field after a variable raw value, or whose raw-value width depends on another field's value or the document state cannot be declared in this vocabulary. Such a layout wraps the variable part in a record so that only one remains (e.g. the signer of SIGNATURE is a Reference record).

## Validity {#유효성}

- The Kind of the target is one of Reference, Value, Edge, and Meta. The specification document of a GEUL direct code is one per code. The 5Q scheme of Reference is also declared separately per quantifier code (LOCAL Identified `0050`, Generic `0060`, ...). The pointers (`0x040L`, `0x041L`, `0x042L`), slot markers, and ISSUER codes are likewise declared as those codes themselves. An Issuer codec determined by the Issuer and codec number after an ISSUER code is defined by that Issuer's document.
- A [slot marker](../slot-marker.md) (Reference `0x000L~0x002L`) is also a DECLARE target. It has no Payload, so only DECLARE is placed, without FIELD. The meaning and acceptance rules of a marker are built into the decoder (layer 0). A Codec whose layout is not yet defined (SUPERSEDE-CHAIN, VERDICT, EVIDENCE, etc.) also holds only DECLARE.
- The Edge Id of an Edge is not declared as a FIELD. It is implicit, being the first element of every Edge ([Edge](_index.md)). For EDGE-ISSUER it is the first element after the Issuer and codec number ([EDGE-ISSUER-2WORD](0x1BDL-edge-issuer-2word.md)).
- The fields of a DECLARE are the FIELDs that point to it, and there may be zero. One FIELD belongs to only one DECLARE. Even fields of the same shape get separate FIELDs per DECLARE.
- DECLARE holds nothing other than the target (and, for an Issuer-form target, the Issuer and codec number).
- The cursor after reading the fields in order must coincide exactly with the end of the record. If anything is left over or missing, that record violates the specification.
- The same target is not declared twice in one document.
- A variant with a different tail field is not used as a branch. A separate DECLARE is placed per Codec.

## Specification document {#규격-문서}

- The specification document of a direct code is a codec document of the GEUL Issuer `0x00000000`. The codec ID is the target TAG WORD (L=0) written as 32 bits (`0x0B80` → `0x00000B80`), and it is published at `<Issuer>/codecs/<codec ID>/` with version IDs and `versions.geul` ([Codec specification document](../codec-spec.md)).
- The codec document of an Issuer codec is placed at that Issuer's `<Issuer>/codecs/<codec number>/`. The codec number does not collide within that Issuer regardless of Kind. An interpreter treats it as an error if the Kind of the record differs from the Kind of the DECLARE target ([publication addresses and version list](../publishing.md#id-표기)).
- One specification document has one DECLARE, and its target must equal the TAG WORD of the codec ID. `DOC-ID` is the [CODEC-POINTER](../reference/0x042L-codec-pointer.md) (`0x00000000`, that codec ID, `0`).

## Names {#이름}

- A Codec name is bound to the DECLARE Edge Id with [BIND](0x0A3L-bind.md) (e.g. `PUBLICATION`). All UTF8-TEXT attached to DECLARE, FIELD, ENUM, and CODEC is attached with BIND, never with another Edge such as LABEL.
- Field names and enum names are bound to FIELD and ENUM in the same way.

## Example {#예시}

The specification document `0x00000000/codecs/0x00000B80/` of PUBLICATION (Edge `0x0B8L`): after the Edge Id, a DOC-POINTER record and a 16-WORD content hash.

```
0BB3 0051 0001 0B80                 DECLARE #1  Edge 0x0B8L               (BIND "PUBLICATION")
0BC5 0051 0002 0051 0001 0000       FIELD #2    DECLARE #1, record        (BIND "doc")
0BE5 0051 0009 0051 0002 0410       CODEC #9    FIELD #2, DOC-POINTER
0BE5 0051 000A 0051 0002 0420       CODEC #10   FIELD #2, CODEC-POINTER (codec version list)
0BC5 0051 0004 0051 0001 0010       FIELD #4    DECLARE #1, raw value 16 WORD   (BIND "hash")
```

- DECLARE: TAG 1 + Edge Id 2 + target 1 = 4 WORDs, `LLLL = 0011`.
- FIELD: TAG 1 + Edge Id 2 + DECLARE 2 + width 1 = 6 WORDs (`LLLL = 0101`). The accepted Kind and Codec are placed separately with [CODEC](0x0BEL-codec.md) (`0410` = DOC-POINTER, `0420` = CODEC-POINTER).
- An optional field is declared with CODEC target `0000`. In an omitted slot, ABSENT (`0x0000`) is written ([CODEC](0x0BEL-codec.md) optional fields).
- The field order is the order in which FIELD #2 and #4 are placed in the document. Edge Ids need not be consecutive (LOCAL AUTO INCREMENT is recommended).

## Open problems {#열린-문제}

- Repetition. A composition in which a preceding raw value sets the count, like "arguments × argument count" of `CALL`. It cannot be declared at present.
- How to declare a Codec that has subforms (Codec-specific TAG) (WORLD, etc.).
- Which version bundle of the direct-code specification documents `SPEC-VERSION` means.

## Related pages {#관련-페이지}

- [FIELD](0x0BCL-field.md), [ENUM](0x0BDL-enum.md), [CODEC](0x0BEL-codec.md), [BIND](0x0A3L-bind.md)
- [Edge](_index.md), [Codec specification document](../codec-spec.md)

## Specification document source {#규격-문서-원문}

This is the specification document `0x00000000/codecs/0x00000BB0/latest.geul` as read with `geul show` (hexadecimal in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000BB000000000
BODY
#1 DECLARE 0x0BB0
#2 FIELD #1 0x0001
#3 FIELD #1 rest
#4 BIND #1 "DECLARE"
#5 BIND #2 "target"
#6 BIND #3 "issuer"
```
