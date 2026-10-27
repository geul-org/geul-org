---
title: "DECLARE"
weight: 28
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DECLARE is a description Edge that declares the Payload composition of one Codec (Codec 0x1B). Together with FIELD, ENUM, and CODEC it is the vocabulary for writing Codec specification documents."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DECLARE is a description Edge that declares the Payload composition of one Codec. Codec `0x1B`.

Together with [FIELD](/grammar/edge/field/) (`0x1C`), [ENUM](/grammar/edge/enum/) (`0x1D`), and [CODEC](/grammar/edge/codec/) (`0x1E`), it is the vocabulary for writing Codec specifications ([Codec specification document](/grammar/codec-spec/)). The layouts of the four Edges are built into the decoder. Each Codec specification document written in this vocabulary is an ordinary document. One specification does validation, decomposition, and display (the viewer) together. The viewer does not hold code for each Codec; it draws by the specification.

## Layout

```
TAG WORD          0001 0LLL L001 1011
[Length extension TAG]
Edge Id           LOCAL Reference record
Target            1 WORD. Uses only the Kind and Codec positions of the declared Codec's TAG WORD (LLLL = 0)
[Issuer, format number]  when the target is an Issuer format. Same layout as the Codec extension TAG
```

- The field list is not placed in DECLARE. Each [FIELD](/grammar/edge/field/) points to its own DECLARE, and the order of those FIELDs in the document is the Payload field order.

## Interpretation Rules

These are the rules for reading and displaying a record by a Codec specification.

- A raw-value field is read for the fixed WORD count the FIELD declares. One field may be a rest raw value (width `0xFFFF`), which reads the remaining WORDs minus the widths of the fixed fields after it. After a rest field, only fixed-width raw values are placed.
- A record field starts with a TAG WORD and is read for the Length of that TAG.
- A raw-value field is an n WORD big-endian unsigned integer. It is displayed as `0x` + width×4 hex digits, and if an ENUM with the same value exists, its BIND name is displayed with it.
- The meaning of a record field is set by that record's Codec specification. A value that needs interpretation, such as a sign, a fraction, or a date, is placed as a Value record, not as a raw value.

There are no other boundary rules. A Codec with two or more variable raw values, with a record or variable field after a variable raw value, or whose raw-value width depends on another field's value or on document state, cannot be declared in this vocabulary. Such a layout wraps the variable part in a record so that only one remains (for example, the signer of SIGNATURE is a Reference record).

## Validity

- The Kind of the target is one of Reference, Value, Edge, or Meta. The Codec of a Reference is the `CCCC` position, with the Quantifier left at 0.
- A [slot marker](/grammar/reference/slot-marker/) (Reference Codec `0000`) cannot be the target of a DECLARE. It is built into the decoder (Layer 0).
- The Edge Id of an Edge is not declared with a FIELD. It is the first element of every Edge and so is implicit ([Edge](/grammar/edge/)).
- The fields of a DECLARE are the FIELDs that point to it, and there may be 0. One FIELD belongs to only one DECLARE. Even fields of the same shape get a separate FIELD for each DECLARE.
- A DECLARE has nothing besides the target (and, for an Issuer-format target, the Issuer and format number).
- The cursor after reading the fields in order must match the end of the record exactly. If it is left over or short, the record violates the specification.
- The same target is not declared twice in one document.
- Variants whose tail fields differ are not written as branches. Each Codec gets its own DECLARE.

## Specification Documents

- The specification document of a direct code is an ordinary document of the GEUL Issuer `0x0000`. Its document ID is the target TAG WORD widened to 4 WORDs (`0x1018` → `0x0000000000001018`), and it is published in the same way as other Issuer documents (version ID, `versions.geul`) ([Codec specification document](/grammar/codec-spec/)).
- A specification document has one DECLARE, and its target must equal the TAG WORD of the document ID. `DOC-ID` is a DOC-POINTER (`0x0000`, that document ID, `0`).

## Names

- The Codec name is bound to the DECLARE Edge Id with [BIND](/grammar/edge/bind/) (for example, `PUBLICATION`). All UTF8-TEXT attached to DECLARE, FIELD, ENUM, and CODEC is done with BIND, not with another Edge such as LABEL.
- Field names and enum names are bound to FIELD and ENUM in the same way.

## Example

The specification document `geul.org/publication` for PUBLICATION (Edge `0x18`): after the Edge Id, a DOC-POINTER record and a content hash of 16 WORDs.

```
119B 0088 0001 1018                 DECLARE #1  Edge 0x18                 (BIND "PUBLICATION")
129C 0088 0002 0088 0001 0000       FIELD #2    DECLARE #1, record        (BIND "doc")
129E 0088 0009 0088 0002 0038       CODEC #9    FIELD #2, DOC-POINTER
129C 0088 0004 0088 0001 0010       FIELD #4    DECLARE #1, raw value 16 WORD   (BIND "hash")
```

- DECLARE: TAG 1 + Edge Id 2 + target 1 = 4 WORDs, `LLLL = 0011`.
- FIELD: TAG 1 + Edge Id 2 + DECLARE 2 + width 1 = 6 WORDs (`LLLL = 0101`). The Kind and Codec it accepts are set separately with [CODEC](/grammar/edge/codec/) (`0038` = DOC-POINTER).
- An optional field is declared with CODEC target `0000`. In the omitted position ABSENT (`0x0000`) is written ([CODEC](/grammar/edge/codec/), optional fields).
- The field order is the order in which FIELD #2 and #4 lie in the document. Edge Ids need not be consecutive (LOCAL AUTO INCREMENT is a recommendation).

## Open Questions

- Repetition. A composition where a preceding raw value sets the count, such as the "argument × argument count" of `CALL`. It cannot be declared now.
- How to declare a Codec that has subformats (a Codec-specific TAG), such as WORLD.
- How to find the specification document of an Issuer format (Issuer and format number → specification document address).
- Which version set of the direct-code specification documents `SPEC-VERSION` means.

## Related Pages

- [FIELD](/grammar/edge/field/), [ENUM](/grammar/edge/enum/), [CODEC](/grammar/edge/codec/), [BIND](/grammar/edge/bind/)
- [Edge](/grammar/edge/), [Codec specification document](/grammar/codec-spec/)
