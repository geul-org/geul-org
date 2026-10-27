---
title: "Codec Specification Document"
weight: 90
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "codebook", "declare", "field"]
summary: "A codebook is also a GEUL document. Four Edges, DECLARE, FIELD, ENUM, and CODEC, declare the Payload layout of one Codec, and that one document handles validation, decomposition, and display together."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

How a Codec lays out its Payload is set by the codebook. The GEUL codebook is not a separate format but a **GEUL document**. One Codec has one specification document.

## Location of the Specification Document

The specification document of a direct code is published by the GEUL Issuer (`0x0000`). The document ID is the TAG WORD of that Codec (only the Kind and Codec positions, with Length as 0) widened to 4 WORDs.

```
/.well-known/geul/0x0000/0x000000000000<TAG>.geul
```

| Codec | TAG | Specification document |
|---|---|---|
| Reference LOCAL | `0008` | `0x0000/0x0000000000000008` |
| Value QUANTITY | `0806` | `0x0000/0x0000000000000806` |
| Edge TRIPLE | `100A` | `0x0000/0x000000000000100A` |
| Edge PUBLICATION | `1018` | `0x0000/0x0000000000001018` |

A decoder builds the address of the specification document from the TAG WORD alone. When it meets an unknown Codec, it fetches and reads that document.

- `<TAG>` is the 4-digit hex of the target TAG WORD. The Length position is `0000`, and for Reference the Quantifier bits are `000` (`0008` for LOCAL).
- Reference Codec `0000` is reserved, so there is no specification document whose target TAG WORD is `0x0000`. So specification documents do not collide with the GEUL Issuer's term definition index document (document ID `0`, [Issuer and Publication](/grammar/issuer/#term-definition-documents)). The [slot marker](/grammar/reference/slot-marker/) of Codec `0000` (`0x0000` to `0x0002`) also has no specification document. It is built into the decoder ([Layer 0](/grammar/publishing/#layers)).
- A specification document places a DOC-POINTER (`0x0000`, `0x000000000000<TAG>`, `0`) in `DOC-ID`. The version list record also uses this DOC-POINTER.
- Like other documents, a specification document binds a lowercase slug name in the GEUL Issuer's name index `0x0000/documents.geul`. Example: `publication` → `geul.org/publication/` = `0x0000/0x0000000000001018/` ([Publication Addresses and Version Lists](/grammar/publishing/#document-names)).
- The rules for versions, canonical addresses, and signatures are the same as for ordinary published documents.

### Document IDs of the GEUL Issuer

| Document ID | Use |
|---|---|
| `0x0000000000000000` | Term definition index document |
| `0x00000000 0000xxxx` | Codec specification document. `xxxx` is the target TAG WORD |
| `0x0001xxxx xxxxxxxx` | geul.org term definition documents. One document per term ([Issuer and Publication](/grammar/issuer/#term-definition-documents)) |

- `0x00000000 0000xxxx` is reserved for Codec specification documents. Other documents of the GEUL Issuer (documents of GEUL-specific ISSUER formats placed when direct codes run short, and so on) do not use this range.

### Codebook and Spec Version

- A codebook document is not brought in with `IMPORT-DOC`. [SPEC-VERSION](/grammar/meta/declaration/spec-version/) in the document HEAD determines which codebook is followed.
- Every decoder either builds in the core codebook or fetches it from this address.
- When a proposal (Prefix `000`) is adopted as a standard, the layout stays as it is and only the Prefix changes to `001` ([Overview](/grammar/overview/#region-structure)). Since the target TAG WORD changes, the adopted version becomes a new specification document with a different document ID, and the proposal document remains immutable.

## Four Vocabulary Items

| Edge | Codec | What it does |
|---|---|---|
| DECLARE | `0x1B` | Declares the Payload layout of one Codec. Target TAG WORD, 1 WORD |
| FIELD | `0x1C` | One Payload field. The DECLARE it belongs to, and its width |
| ENUM | `0x1D` | Gives a meaning to one code value of a raw-value field |
| CODEC | `0x1E` | Specifies one Kind and Codec that a field accepts |

- The layouts of the four Edges are built into the decoder ([Layer 0](/grammar/publishing/#layers)), because a specification document must be readable without a codebook. Reading a specification document needs no other specification document.
- Names (Codec names, field names, code value names) are all bound with BIND.

### FIELD

```
Edge Id           LOCAL
DECLARE           LOCAL (the DECLARE this field belongs to)
Width             1 WORD: 0 = record, n = raw value of n WORDs, 0xFFFF = the remaining raw value
```

- The **order within the document** of the FIELDs that point to the same DECLARE is the order of the Payload fields.
- A record field starts with a TAG WORD and is read for as many WORDs as its Length says.
- A raw-value field is an unsigned integer read for a fixed number of WORDs. A value that needs interpretation, such as a sign, a fraction, or a date, is placed as a Value record, not as a raw value.
- Only one remaining raw value (`0xFFFF`) may be placed, and only fixed-width raw values may follow it.
- The Edge Id of an Edge is not declared with a FIELD. It is the first element of every Edge, so it is implicit.
- The position reached after reading the fields in order must match the end of the record exactly.

### CODEC

Specifies the format that a field accepts. The target WORD uses the Kind and Codec positions of the TAG WORD as they are.

| Length position | Meaning | Example |
|---|---|---|
| `0000` | Exact Codec | `0810` SIGNED-DECIMAL, `0008` LOCAL |
| `1111` | Wildcard: Codec bits that are 0 match anything | `0780` any Reference, `0F80` any Value, `07A0` Wikidata QID (any quantifier) |

- If a record field has no CODEC, it accepts any record (except slot markers). If it has one or more, it must be one of them (a closed list).
- If one CODEC is placed on a raw-value field, the raw value is interpreted as that Value without a TAG.

### Optional Fields and Slot Markers

A [slot marker](/grammar/reference/slot-marker/) is a set of 1 WORD records of the reserved Reference Codec `0000`. It can appear in a slot only when the field's CODEC list names that WORD as an exact target.

| CODEC target | Marker | That field |
|---|---|---|
| `0000` | ABSENT, not written | Is an **optional field**. It can be omitted |
| `0001` | UNKNOWN-VALUE, unknown | Accepts the assertion that a value exists but is unknown |
| `0002` | NO-VALUE, none | Accepts the assertion that there is no value |

- **Acceptance rule:** A marker is valid only when the same WORD is in the field's CODEC list as an exact target. A wildcard (`0780`, `0781`, `0F80` …) and a field with no CODEC ("any record") do not accept markers. In a HEAD or BODY record position and in an Edge Id position, it is invalid.
- To omit an optional field, write a single WORD `0x0000` (ABSENT) in its slot. An optional field also always occupies its slot. So a record has exactly one notation, and decomposition is determined by position alone.
- A marker is a reserved Reference Codec, so it does not collide with other records, and even a decoder that does not know the specification skips it as a 1 WORD record.
- The three markers are different statements. ABSENT is a statement about the document (this slot was not filled), so it asserts nothing about the world. UNKNOWN-VALUE asserts that a value exists (`∃x`), and NO-VALUE asserts that there is no value (`¬∃x`, within the qualifying conditions). Omission means "not written", not "no value".
- What a marker means is set by the specification of the Codec that accepts it ([TRIPLE](/grammar/edge/triple/), [QUALIFIER](/grammar/edge/qualifier/)).

## Example: The TRIPLE Specification Document

The BODY of `0x0000/0x000000000000100A`.

| Edge | Content | Name (BIND) |
|---|---|---|
| #1 DECLARE | target `100A` | `TRIPLE` |
| #2 FIELD | field of #1, record | `predicate` |
| #3 FIELD | field of #1, record | `subject` |
| #4 FIELD | field of #1, record | `object` |
| #5 FIELD | field of #1, raw value 1 WORD | `rank` |
| #6-#8 ENUM | code values 0, 1, 2 of #5 | `normal`, `preferred`, `deprecated` |
| #17 CODEC | #5 is interpreted as UNSIGNED-INTEGER (`0802`) | |
| #18, #19 CODEC | #4 is any Reference (`0780`) or any Value (`0F80`) | |
| #20, #21 CODEC | #4 also accepts UNKNOWN-VALUE (`0001`) and NO-VALUE (`0002`) | |

With this one document, a decoder splits a TRIPLE record into fields, displays it with field names, and checks that its format is correct.

## Example: The QUANTITY Specification Document

In Value QUANTITY (`0806`), all four fields are records.

| Field | CODEC |
|---|---|
| `amount` | `0810` SIGNED-DECIMAL |
| `unit` | `0780` any Reference, `0000` optional |
| `lower` | `0810` SIGNED-DECIMAL, `0000` optional |
| `upper` | `0810` SIGNED-DECIMAL, `0000` optional |

## Rules

- One specification document has one DECLARE. The target of the DECLARE equals the TAG WORD in the document ID.
- The same target is not declared twice in one document.
- Variants with different field layouts are not expressed as branches. Declare each Codec separately.
- A layout with two or more variable raw values, or where the width of a raw value depends on another value, cannot be declared. Wrap such a part in a record.
- A specification document is published with versions like any other document. However, the binary layout of a Codec is not revised. To change it, assign a new Codec.

## Open Questions

- The mapping from the `SPEC-VERSION` value (`0x0001` for v1) to the codebook document version. Lineage Meta linking the adopted version and the proposal.
