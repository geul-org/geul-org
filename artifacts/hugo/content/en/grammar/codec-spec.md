---
title: "Codec Specification Document"
weight: 40
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "codebook", "declare", "field"]
summary: "The codebook determines how a Codec lays out its Payload."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

The codebook determines how a Codec lays out its Payload. The GEUL codebook is not a separate format but a **GEUL document**. One Codec has one specification document.

## Location of the Specification Document {#규격-문서의-위치}

The specification document of a direct code is published by the GEUL Issuer (`0x00000000`). A specification document is a Codec document and has no document ID. The Codec ID is the TAG WORD of that Codec (only the section and the Codec position of `C`, with Length 0) written as 32 bits.

```
/.well-known/geul/0x00000000/codecs/0x0000<TAG>/<version ID>.geul
```

| Codec | TAG | Specification document |
|---|---|---|
| Reference LOCAL | `0050` | `0x00000000/codecs/0x00000050` |
| Value QUANTITY | `0660` | `0x00000000/codecs/0x00000660` |
| Edge TRIPLE | `0AA0` | `0x00000000/codecs/0x00000AA0` |
| Edge PUBLICATION | `0B80` | `0x00000000/codecs/0x00000B80` |

A decoder builds the address of the specification document from the TAG WORD alone. When it meets an unknown Codec, it fetches and reads that document.

- `<TAG>` is the 4-digit hex (uppercase) of the target TAG WORD. The Length position is `0000`. There is one Codec document per code. The Reference 5Q scheme also has a separate one for each quantifier code (LOCAL Identified `0050`, LOCAL Generic `0060`). Direct codes and Issuer Codecs use the same address rule `<Issuer>/codecs/<Codec ID>/` ([Publication addresses and version lists](publishing.md#공표-주소)).
- [Slot markers](slot-marker.md) (`0x0000`, `0x0010`, `0x0020`) also have specification documents. They have no Payload, so they contain only DECLARE and no FIELD. The meaning of a marker and its acceptance rule are built into the decoder ([Layer 0](publishing.md#층)). A Codec whose layout is not yet decided also starts as a specification document containing only DECLARE.
- A specification document places a [CODEC-POINTER](reference/0x042L-codec-pointer.md) (`0x00000000`, `0x0000<TAG>`, `0`) in `DOC-ID`. The version list record also uses this CODEC-POINTER.
- The rules for versions, canonical addresses, and signatures are the same as for ordinary published documents.

### Codebook and Specification Edition {#코덱북과-명세-판}

- A Codec document can also be brought in with [IMPORT-DOC](meta/0x1E4L-import-doc.md). In that case, the document slot takes a [CODEC-POINTER](reference/0x042L-codec-pointer.md) instead of a DOC-POINTER. The [SPEC-VERSION](meta/0x1C5L-spec-version.md) in the document HEAD determines which codebook the document follows.
- Every decoder either builds in the core codebook or fetches it from this address.
- When a proposal (Prefix `000`) is adopted as a standard, the layout stays the same and only the Prefix changes to `001` ([Overview](_index.md#영역-구조)). Since the target TAG WORD changes, the adopted version becomes a new specification document with a different Codec ID, and the proposal document remains immutable.

## Four Vocabularies {#네-어휘}

| Edge | Codec | What it does |
|---|---|---|
| DECLARE | `0x0BBL` | Declares the Payload layout of one Codec. The target TAG WORD, 1 WORD |
| FIELD | `0x0BCL` | One Payload field. The DECLARE it belongs to, and its width |
| ENUM | `0x0BDL` | Gives a meaning to one code value of a raw-value field |
| CODEC | `0x0BEL` | Designates one Kind or Codec that a field accepts |

- The layouts of the four Edges are built into the decoder ([Layer 0](publishing.md#층)), because a specification document must be readable without a codebook. Reading a specification document requires no other specification document.
- All names (Codec names, field names, code value names) are bound with BIND.

### FIELD {#field}

```
Edge Id           LOCAL
DECLARE           LOCAL (the DECLARE this field belongs to)
Width             1 WORD: 0 = record, n = n WORDs of raw value, 0xFFFF = remaining raw value
```

- The **order within the document** of the FIELDs that point to the same DECLARE is the Payload field order.
- A record field starts with a TAG WORD and reads as many WORDs as its Length.
- A raw-value field is an unsigned integer read for a fixed number of WORDs. A value that needs interpretation, such as a sign, a fraction, or a date, is not a raw value but a Value record.
- The remaining raw value (`0xFFFF`) can appear only once, and only fixed-width raw values may follow it.
- The Edge Id of an Edge is not declared as a FIELD. It is implicit, because it is the first element of every Edge. For EDGE-ISSUER it is the first element after the Issuer and Codec number ([EDGE-ISSUER-2WORD](edge/0x1BDL-edge-issuer-2word.md)).
- The position reached after reading the fields in order must coincide exactly with the end of the record.

### CODEC {#codec}

It designates the format a field accepts. The target WORD uses the Codec position of the TAG WORD (section `KKKK` and `C`) as it is.

| Length position | Meaning | Example |
|---|---|---|
| `0000` | Exact Codec | `0680` SIGNED-DECIMAL, `0050` LOCAL |
| `1111` | Wildcard: regardless of the `C` value, the whole section `KKKK` (32 slots). Using the first slot of the section (`C = 0`) is recommended | `000F` all of section 0, `060F` all of section 3 |

- When a Kind spans several sections, list a CODEC for each section. Any Reference is `000F`, `020F`, `040F`, and any Value is `060F`, `080F`.
- For a quantifier-agnostic set or a bundle, list the exact Codecs. The Wikidata QID (quantifier-agnostic) is five: `0140`, `0150`, `0160`, `0170`, `0180`.

- If a record field has no CODEC, it accepts any record (except slot markers). If it has one or more, it must be one of them (a closed list).
- If a CODEC is placed on a raw-value field, that raw value is interpreted as that Value without a TAG.

### Optional Fields and Slot Markers {#선택-필드와-자리-표지}

A [slot marker](slot-marker.md) is a set of 1 WORD records assigned to the first three slots `0x000L~0x002L` of Reference section 0. It can appear in a slot only when the field's CODEC list names that WORD as an exact target.

| CODEC target | Marker | The field is |
|---|---|---|
| `0000` | ABSENT, not written | an **optional field**. It can be omitted |
| `0010` | UNKNOWN-VALUE, unknown | accepts the assertion that a value exists but is unknown |
| `0020` | NO-VALUE, none | accepts the assertion that no value exists |

- **Acceptance rule:** A marker is valid only when the same WORD is an exact target in the field's CODEC list. Wildcards (`000F`, `060F` …) and fields with no CODEC ("any record") do not accept markers. In the HEAD and BODY record slots and in the Edge Id slot, a marker is invalid.
- To omit an optional field, write a single WORD `0x0000` (ABSENT) in its slot. An optional field also always occupies its slot. So a record has exactly one notation, and decomposition is determined by position alone.
- A marker has its own Reference code, so it does not collide with other records, and a decoder that does not know the specification skips it as a 1 WORD record.
- The three markers mean different things. ABSENT is a statement about the document (this slot was not filled), so it asserts nothing about the world. UNKNOWN-VALUE asserts that a value exists (`∃x`), and NO-VALUE asserts that no value exists (`¬∃x`, within a qualifying condition). Omission means "not written", not "no value".
- What a marker means is determined by the specification of the Codec that accepts it ([TRIPLE](edge/0x0AAL-triple.md), [QUALIFIER](edge/0x0ABL-qualifier.md)).

## Example: TRIPLE Specification Document {#예-triple-규격-문서}

This is the BODY of `0x00000000/codecs/0x00000AA0`.

| Edge | Content | Name (BIND) |
|---|---|---|
| #1 DECLARE | target `0AA0` | `TRIPLE` |
| #2 FIELD | a field of #1, record | `predicate` |
| #3 FIELD | a field of #1, record | `subject` |
| #4 FIELD | a field of #1, record | `object` |
| #5 FIELD | a field of #1, raw value 1 WORD | `rank` |
| #6~#8 ENUM | code values 0, 1, 2 of #5 | `normal`, `preferred`, `deprecated` |
| #17 CODEC | #5 is interpreted as UNSIGNED-INTEGER (`0620`) | |
| #18, #22, #23, #19, #24 CODEC | #4 is any Reference (`000F`·`020F`·`040F`) or any Value (`060F`·`080F`) | |
| #20, #21 CODEC | #4 also accepts UNKNOWN-VALUE (`0010`) and NO-VALUE (`0020`) | |
| #25~#27 CODEC | #2 is any Reference (`000F`·`020F`·`040F`) | |
| #28~#30 CODEC | #3 is any Reference (`000F`·`020F`·`040F`) | |

With this one document, a decoder splits a TRIPLE record into fields, displays it with field names, and checks that its form is correct.

## Example: QUANTITY Specification Document {#예-quantity-규격-문서}

In Value QUANTITY (`0660`), all four fields are records.

| Field | CODEC |
|---|---|
| `amount` | `0610` SIGNED-INTEGER, `0620` UNSIGNED-INTEGER, `0630` BINARY-FLOAT (finite values only), `0670` FRACTION, `0680` SIGNED-DECIMAL, `0690` UNSIGNED-DECIMAL |
| `unit` | `000F`·`020F`·`040F` any Reference, `0000` optional |
| `lower` | `0610`·`0620`·`0630`·`0670`·`0680`·`0690` (same as amount), `0000` optional |
| `upper` | `0610`·`0620`·`0630`·`0670`·`0680`·`0690` (same as amount), `0000` optional |

## Rules {#규칙}

- A specification document has exactly one DECLARE. The target of the DECLARE equals the TAG WORD of the Codec ID.
- The same target is not declared twice in one document.
- A variant with a different field composition is not expressed as a branch. Declare it separately for each Codec.
- A layout with two or more variable raw values, or one in which the width of a raw value depends on another value, cannot be declared. Wrap such a part in a record.
- A specification document is published with versions like other documents. However, the binary layout of a Codec is not revised. To change it, assign a new Codec.

## Open Problems {#열린-문제}

- The mapping from the `SPEC-VERSION` value (v1 is `0x0001`) to the codebook document version. A lineage Meta that links the adopted version to the proposed version.
