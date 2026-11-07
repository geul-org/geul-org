---
title: "Reference"
weight: 90
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "LOCAL", "quantifier"]
summary: "A Reference is a record that points to a target."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

A Reference is a record that points to a target. The target can be an entity, a concept, a document, or another Edge. It points by ID, not by name.

## Layout {#레이아웃}

```
TAG WORD          000K KKKC CCCC LLLL      Sections 0~2 (0x000L~0x05FL)
[Length extension TAG]
[IMPORT ID]       for EXTERNAL-POINTER (1/2/4 WORD)
[Issuer]          for EXTERNAL-ISSUER (2/4/16 WORD)
[Document ID]     for EXTERNAL-ISSUER (4 WORD)
Target ID         all the rest
```

- `LLLL` is the total number of WORDs including the TAG WORD, minus 1 ([Record and TAG WORD](../record.md)).
- Reference occupies 96 slots in sections 0~2 (`w < 0x0600`). Section 0 is entities `0x000L~0x01FL`, section 1 is EXTERNAL `0x020L~0x03FL`, and section 2 is other `0x040L~0x05FL`.
- The Codec is written as a code table (table below). In the 5Q scheme, one code carries both the identification scheme and the quantification. The quantification of REFERENCE-ISSUER is set by the Issuer's document.
- The target ID is an unsigned big-endian integer and is written in the **shortest width**. The width is what remains of Length after the preceding fields.
- Target ID `0` is written as the 1 WORD `0x0000`. Otherwise no `0x0000` WORD is placed in front.
- The same integer value is the same ID. The width is not part of the ID.
- Every Codec uses the shortest width. No Codec fixes the target ID width.
- [ISSUER-POINTER](0x040L-issuer-pointer.md), [DOC-POINTER](0x041L-doc-pointer.md), and [CODEC-POINTER](0x042L-codec-pointer.md) do not follow this layout. They have no target ID, and hold only the Issuer (and the document ID, codec ID, and version ID).
- [REFERENCE-ISSUER](#reference-issuer) does not follow this layout either. It is TAG, Issuer, a 2 WORD codec number, and Payload. The Payload is set by the Codec document the Issuer published.

## Codec {#codec}

| TAG ID | Name | Category | Target |
|---|---|---|---|
| `0x000L~0x002L` | [Slot marker](../slot-marker.md) | Slot marker | Points to no target. Only a 1 WORD marker is used: `0x0000` ABSENT (not written), `0x0010` UNKNOWN-VALUE (unknown), `0x0020` NO-VALUE (none) |
| `0x005L~0x009L` | [LOCAL](0x005L-local.md) | Declaration | An ID issued by this document |
| `0x00AL~0x00EL` | [GEUL](0x00AL-geul.md) | Declaration | An entity issued by geul.org |
| `0x00FL~0x013L` | [GEUL-SIDX](0x00FL-geul-sidx.md) | Declaration | A semantic-aligned identifier that carries meaning in its bits |
| `0x014L~0x018L` | [WIKIDATA-QID](0x014L-wikidata-qid.md) | Declaration | A Wikidata item. The integer after `Q` |
| `0x019L~0x01DL` | [WIKIDATA-PID](0x019L-wikidata-pid.md) | Declaration | A Wikidata property. The integer after `P` |
| `0x020L~0x02EL` | [EXTERNAL-POINTER-1/2/4WORD](0x020L-external-pointer-1word.md) | Pointer | A LOCAL ID in a document brought in by IMPORT |
| `0x02FL~0x03DL` | [EXTERNAL-ISSUER-2/4/16WORD](0x02FL-external-issuer-2word.md) | Pointer-declaration | A LOCAL ID in a document published by an Issuer |
| `0x040L` | [ISSUER-POINTER](0x040L-issuer-pointer.md) | Pointer-declaration | An Issuer itself |
| `0x041L` | [DOC-POINTER](0x041L-doc-pointer.md) | Pointer-declaration | One version of a document published by an Issuer |
| `0x042L` | [CODEC-POINTER](0x042L-codec-pointer.md) | Pointer-declaration | One version of a codec published by an Issuer |
| `0x043L~0x044L` | [TOKEN-0·TOKEN-1](0x043L-token.md) | Declaration | An entry of the GEUL token vocabulary. Token ID 1 WORD, 2 WORDs in total |
| `0x05DL~0x05FL` | [REFERENCE-ISSUER-2/4/16WORD](#reference-issuer) | Issuer form | Defined by the Issuer. The category and the target ID slots are set by the Issuer's document |

- Reserved are `0x003L~0x004L`, `0x01EL~0x01FL` (section 0), `0x03EL~0x03FL` (section 1), and `0x045L~0x05CL` (section 2, slots for new identification schemes).
- The scheme number is read from the offset within the section, `C`. In section 0, if `5 <= C < 30` the scheme is `C / 5` (1~5); in section 1, if `C < 30` the scheme is `6 + C / 5` (6~11).

| Scheme | Name | Identified | Generic | Free-choice | Universal | Variable |
|---:|---|---|---|---|---|---|
| 1 | LOCAL | `0x005L` | `0x006L` | `0x007L` | `0x008L` | `0x009L` |
| 2 | GEUL | `0x00AL` | `0x00BL` | `0x00CL` | `0x00DL` | `0x00EL` |
| 3 | GEUL-SIDX | `0x00FL` | `0x010L` | `0x011L` | `0x012L` | `0x013L` |
| 4 | WIKIDATA-QID | `0x014L` | `0x015L` | `0x016L` | `0x017L` | `0x018L` |
| 5 | WIKIDATA-PID | `0x019L` | `0x01AL` | `0x01BL` | `0x01CL` | `0x01DL` |
| 6 | EXTERNAL-POINTER-1WORD | `0x020L` | `0x021L` | `0x022L` | `0x023L` | `0x024L` |
| 7 | EXTERNAL-POINTER-2WORD | `0x025L` | `0x026L` | `0x027L` | `0x028L` | `0x029L` |
| 8 | EXTERNAL-POINTER-4WORD | `0x02AL` | `0x02BL` | `0x02CL` | `0x02DL` | `0x02EL` |
| 9 | EXTERNAL-ISSUER-2WORD | `0x02FL` | `0x030L` | `0x031L` | `0x032L` | `0x033L` |
| 10 | EXTERNAL-ISSUER-4WORD | `0x034L` | `0x035L` | `0x036L` | `0x037L` | `0x038L` |
| 11 | EXTERNAL-ISSUER-16WORD | `0x039L` | `0x03AL` | `0x03BL` | `0x03CL` | `0x03DL` |

- A **declaration** directly identifies a target by an ID set by the issuing party.
- A **pointer** points to a LOCAL in a document brought in by an IMPORT ID. The IMPORT ID width is set by the scheme: if the scheme − 6 is 0, 1, or 2, it is 1, 2, or 4 WORD.
- A **pointer-declaration** points to another document and a target inside it with a single record, without IMPORT. The Issuer width of EXTERNAL-ISSUER is 2, 4, or 16 WORD if the scheme − 9 is 0, 1, or 2.
- `0x020L~0x03DL` (section 1, schemes 6~11) point to a LOCAL of another document. The other declaration schemes directly identify a target (a LOCAL of this document, an issued ID). The pointers (section 2, `0x040L~0x042L`) point to an Issuer, a document, or a codec itself. REFERENCE-ISSUER is outside this distinction.
- `0x000L~0x002L` are codes assigned to slot markers, and are not used as a Reference that points to a target. The WORDs `0x0000`, `0x0010`, and `0x0020` (L 0, 1 WORD) are [slot markers](../slot-marker.md) (`0x0000` ABSENT, `0x0010` UNKNOWN-VALUE, `0x0020` NO-VALUE). A marker is valid only in a record field slot that has exactly that WORD as its CODEC target. It is not accepted by a wildcard or a field with no CODEC, and is invalid in a HEAD or BODY record slot and in an Edge Id slot. TAG forms with a Payload in C 0~2 (L ≥ 1) are Reserved.
- Only the direct codes and publications provided by geul.org are CC0. An identification scheme that is not CC0 (such as WordNet) is not made a direct code. The license of an Issuer form is set by that Issuer.

### Frequently used TAGs {#자주-쓰는-tag}

| Record | WORD |
|---|---|
| LOCAL 1 | `0051 0001` |
| LOCAL 65536 | `0052 0001 0000` |
| Wikidata Q5 (human) | `0141 0005` |
| Wikidata Q691283 | `0142 000A 8C53` |
| Wikidata P31 (instance of) | `0191 001F` |
| Slot marker ABSENT / UNKNOWN-VALUE / NO-VALUE | `0000` / `0010` / `0020` |

## LOCAL {#local}

A LOCAL is an ID issued by this document.

- **It is unique.** In a document, one LOCAL ID points to only one target.
- **0 is not assigned.** Target IDs are assigned from 1.
- **Assigning in increasing order is recommended** (auto increment). The magnitude of an ID has no meaning.
- It points to the same target across versions. A deleted ID is not reused (revision of the [document](../document.md)).
- To be pointed to from outside the document, the document must have a `DOC-ID`.
- Different LOCAL IDs do not mean the targets are different in reality. Link them with a `SAME-NODE` Edge if they are the same, or a `DIFFERENT-NODE` Edge if they are different.

### Edge Id {#edge-id}

Every Edge places a LOCAL Reference as the first element of its Payload. That LOCAL ID is the **Edge Id**.

- An Edge Id can be read without knowing the codebook.
- A LOCAL in the Edge Id slot is a declaration, and a LOCAL in any other slot of the Edge is a mention.
- A LOCAL that declares an Edge Id uses only Identified (`0x005L`).
- Another Edge is pointed to by its Edge Id. An Edge of this document is pointed to by a LOCAL, and an Edge of another document by a pointer Reference.

## Pointing to another document {#다른-문서-가리키기}

| What | How |
|---|---|
| An Issuer itself | `ISSUER-POINTER` (Issuer) |
| One version of a document | `DOC-POINTER` (Issuer, document ID 4 WORD, version ID 2 WORD). Version `0` is the latest |
| One version of a codec | `CODEC-POINTER` (Issuer, codec ID 2 WORD, version ID 2 WORD). Version `0` is the latest |
| A target in a published document (latest) | `EXTERNAL-ISSUER-*` (Issuer, document ID, LOCAL ID) |
| A target in an imported document (edition pinned) | Assign an IMPORT ID with Meta `IMPORT-DOC` and use `EXTERNAL-POINTER-*` (IMPORT ID, LOCAL ID) |

- A document itself is pointed to, whether from inside that document or outside it, only by a single DOC-POINTER. It points to itself with the DOC-POINTER of its own `DOC-ID`. A codec document is the exception and is pointed to by CODEC-POINTER (its `DOC-ID` is also a CODEC-POINTER).
- EXTERNAL-ISSUER follows the latest version. To pin an edition, use IMPORT.
- The Issuer is written in the shortest width that fits the value (2/4/16 WORD), and the Codec that matches that width is chosen. EXTERNAL-ISSUER and REFERENCE-ISSUER are the same.
- Document ID `0` of each Issuer is reserved for the index document of the terms (tools, roles, and so on) that Issuer defines. The index document is recommended for every Issuer and is not required ([Issuer and publication](../issuer.md#용어-정의-문서)).

Example: LOCAL 7 in document `0x0000000000000002` of Issuer `0x00000002`

```
02F7 0000 0002 0000 0000 0000 0002 0007
```

## Quantifier {#quantifier}

| `C % 5` | Name | Meaning | Example |
|---|---|---|---|
| `0` | Identified | An identified individual | Elon Musk, South Korea |
| `1` | Generic | A general statement about a whole kind. Allows exceptions | Soldiers obey orders |
| `2` | Free-choice | Any target that satisfies the condition | Any soldier |
| `3` | Universal | Every target in the range | Every soldier |
| `4` | Variable | A discourse variable | that person, this woman |

- **Quantification is read only in the 5Q schemes (schemes 1~11).** With the offset within the section `C`, the quantification is `C % 5` when `5 <= C < 30` in section 0 and when `C < 30` in section 1. A section has 32 slots, so dividing the 9-bit Codec position (`w >> 4`) by 5 would misalign section 1. Markers (section 0, `C < 3`) and section 2 (pointers, REFERENCE-ISSUER) have no quantification. The marker `0x0010` UNKNOWN-VALUE is not Generic. The quantification of REFERENCE-ISSUER is set by the Codec document the Issuer published.
- Unlike Universal, Generic does not mean it applies to every individual target without exception. A definitional expression such as "what is a soldier" can be written as Generic. When a strict definition of a concept or classification is needed, make it concrete with a separate relation.
- The scope and negation of a quantification are set not by the Reference but by the Edge that uses it.
- A **Variable** is a target in the discourse whose kind is known but which has not yet been identified.
  - A named variable attaches Variable to a LOCAL. The same LOCAL ID is the same variable. The kind is linked by an Edge.
  - An anonymous variable attaches Variable to a declaration Codec that points to a kind (GEUL, WIKIDATA-*) (for example, Wikidata "president" + Variable). Coreference is not tracked and it cannot be pointed to again. Anonymous variables are not treated as the same variable.
  - When the target is later confirmed, link the variable to that target with `SAME-NODE`. Every expression that points to the same variable is then interpreted as that target together.
  - Even different variables do not mean the actual targets are different. Link them with `SAME-NODE` if they are the same, or `DIFFERENT-NODE` if they are different.
  - The Variable of an external pointer Codec (EXTERNAL-POINTER-*, EXTERNAL-ISSUER-*) is a LOCAL variable of the document it points to.
  - Example: in "The president gave a speech", if the person is not determined, use the "president" Variable. To mention it again, place a LOCAL Variable and link the kind "president" by an Edge. If it is later confirmed to be Obama, link that variable to Obama Identified with `SAME-NODE`. Every expression that points to the same variable is interpreted as Obama together.
- Example: using Wikidata Q5 (human) as Generic gives `0151 0005` ("Humans are …").

## REFERENCE-ISSUER {#reference-issuer}

REFERENCE-ISSUER is a Reference form defined by an Issuer. It is the last three slots of the Reference range. The layout is the same as ISSUER in Value and Edge ([Record and TAG WORD](../record.md#issuer-형식-레코드)).

### Layout {#레이아웃-1}

```
TAG WORD          0000 0101 11WW LLLL      Codec 0x05DL / 0x05EL / 0x05FL (WW = Issuer width: 01 2, 10 4, 11 16 WORD)
[Length extension TAG]
Issuer            2/4/16 WORD (the Codec sets the width)
Codec number      2 WORD. Defined by the Issuer
Payload           Set by the Codec document the Issuer published
```

| Codec | Name | Issuer width |
|---|---|---|
| `0x05DL` | [REFERENCE-ISSUER-2WORD](0x05DL-reference-issuer-2word.md) | 2 WORD |
| `0x05EL` | [REFERENCE-ISSUER-4WORD](0x05EL-reference-issuer-4word.md) | 4 WORD |
| `0x05FL` | [REFERENCE-ISSUER-16WORD](0x05FL-reference-issuer-16word.md) | 16 WORD |

- Each code has its own page: [REFERENCE-ISSUER-2WORD](0x05DL-reference-issuer-2word.md), [REFERENCE-ISSUER-4WORD](0x05EL-reference-issuer-4word.md), [REFERENCE-ISSUER-16WORD](0x05FL-reference-issuer-16word.md).
- The codec document of a GEUL Issuer is one per code and has three FIELDs: Issuer (2, 4, or 16 WORD), codec number (2 WORD), and Payload (set by the Issuer codec).

### Interpretation and validity {#해석과-유효성}

- GEUL knows only the Payload boundary from Length. The Payload is not interpreted without a codebook.
- The meaning and quantification of the codec number are set by the Issuer. What it points to is also set by the Codec document the Issuer published.
- The common Reference rules do not apply: the shortest width of the target ID, the 1 WORD notation of target ID `0`, the Quantifier, the reading of quantification and scheme from the offset within the section, the declaration and pointer classification, and what it points to.
- The 2 WORD codec number is the same as ISSUER in Value and Edge. If the numbers run out, obtain one more Issuer.
- A decoder that does not know the form knows the Kind, Length, Issuer, and codec number, and skips the rest by Length.
- The license of an Issuer form is set by that Issuer ([Issuer and publication](../issuer.md#라이선스)).

### Related pages {#관련-페이지}

- [Record and TAG WORD](../record.md), [Issuer and publication](../issuer.md)
