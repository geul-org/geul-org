---
title: "Reference"
weight: 40
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference", "LOCAL", "quantifier"]
summary: "A Reference is a record that points to a target. A 4-bit Codec sets the identification scheme (LOCAL, Wikidata, external documents, and so on), and a 3-bit Quantifier sets the quantification (identified, generic, universal, variable, and so on). The reserved Codec 0000 is the set of slot markers."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

A Reference is a record that points to a target. The target can be an entity, a concept, a document, or another Edge. It is pointed to by ID, not by name.

## Layout

```
TAG WORD          0000 0LLL LCCC CQQQ
[Length extension TAG]
[IMPORT ID]       for EXTERNAL-POINTER (1/2/4/8 WORD)
[Issuer]          for EXTERNAL-ISSUER (1/2/4/16 WORD)
[Document ID]     for EXTERNAL-ISSUER (4 WORD)
Target ID         everything that remains
```

- `LLLL` is the total WORD count including the TAG WORD, minus 1 ([Records and the TAG WORD](/grammar/record/)).
- The Codec is the 4 bits `CCCC`, and the Quantifier is the 3 bits `QQQ`. The lower 7 bits of the TAG WORD are `CCCC << 3 | QQQ`.
- The target ID is an unsigned big-endian integer written in the **shortest width**. The width is what remains of the Length after the preceding fields.
- Target ID `0` is written as 1 WORD `0x0000`. Otherwise, no leading `0x0000` WORD is added.
- The same integer value is the same ID. The width is not part of the ID.
- Every Codec uses the shortest width. No Codec fixes the width of the target ID.
- [ISSUER-POINTER](/grammar/reference/issuer-pointer/) and [DOC-POINTER](/grammar/reference/doc-pointer/) do not follow this layout. They have no target ID and hold only an Issuer (and a document ID and version ID).

## Codec (`CCCC`)

| CCCC | Name | Class | Target |
|---|---|---|---|
| `0000` | [Slot marker](/grammar/reference/slot-marker/) | Reserved | Points to no target. Only 1 WORD markers whose lower 3 bits are the marker number are used: `0x0000` ABSENT (not written), `0x0001` UNKNOWN-VALUE (unknown), `0x0002` NO-VALUE (none) |
| `0001` | [LOCAL](/grammar/reference/local/) | Declaration | An ID issued by this document |
| `0010` | [GEUL](/grammar/reference/geul/) | Declaration | An entity issued by geul.org |
| `0011` | [GEUL-SIDX](/grammar/reference/geul-sidx/) | Declaration | A semantically aligned identifier that carries meaning in its bits |
| `0100` | [WIKIDATA-QID](/grammar/reference/wikidata-qid/) | Declaration | A Wikidata item. The integer after `Q` |
| `0101` | [WIKIDATA-PID](/grammar/reference/wikidata-pid/) | Declaration | A Wikidata property. The integer after `P` |
| `0110` | [ISSUER-POINTER](/grammar/reference/issuer-pointer/) | Pointer-declaration | The Issuer itself |
| `0111` | [DOC-POINTER](/grammar/reference/doc-pointer/) | Pointer-declaration | One version of a document published by an Issuer |
| `1000`-`1011` | [EXTERNAL-POINTER-1/2/4/8WORD](/grammar/reference/external-pointer/) | Pointer | A LOCAL ID in a document brought in by IMPORT |
| `1100`-`1111` | [EXTERNAL-ISSUER-1/2/4/16WORD](/grammar/reference/external-issuer/) | Pointer-declaration | A LOCAL ID in a document published by an Issuer |

- A **declaration** identifies a target directly with an ID set by the issuing party.
- A **pointer** points to a LOCAL inside a document brought in with an IMPORT ID. The lower 2 bits are the IMPORT ID width (`00` = 1, `01` = 2, `10` = 4, `11` = 8 WORD).
- A **pointer-declaration** points to another document and a target inside it with a single record, without IMPORT.
- If the top bit is `0`, the target is identified directly (a LOCAL of this document, an issued ID, an Issuer or a document itself); if `1`, it points to a LOCAL in another document.
- Codec `0000` is reserved and is not used as a Reference that points to a target. There is one exception, a group: the WORDs `0x0000` to `0x0007` (Codec `0000`, 1 WORD) are [slot markers](/grammar/reference/slot-marker/). Three are used now (`0x0000` ABSENT, `0x0001` UNKNOWN-VALUE, `0x0002` NO-VALUE). A marker is valid only in a record field slot whose CODEC target names that exact WORD. Wildcards and fields with no CODEC do not accept it, and in a HEAD or BODY record position and in an Edge Id position it is invalid. `0x0003` to `0x0007`, and Codec `0000` with a Payload, are reserved.
- Identification schemes that are not CC0 (WordNet and the like) are not made Reference Codecs. Reference has no ISSUER code either, so there is no place to move them as an Issuer format.

### Frequently Used TAGs

| Record | WORD |
|---|---|
| LOCAL 1 | `0088 0001` |
| LOCAL 65536 | `0108 0001 0000` |
| Wikidata Q5 (human) | `00A0 0005` |
| Wikidata Q691283 | `0120 000a 8c53` |
| Wikidata P31 (instance of) | `00A8 001f` |
| Slot marker ABSENT / UNKNOWN-VALUE / NO-VALUE | `0000` / `0001` / `0002` |

## LOCAL

A LOCAL is an ID issued by this document. It has meaning only inside the document.

- **It is unique.** Within one document, one LOCAL ID points to only one target.
- **0 is not assigned.** Target IDs are assigned from 1.
- **Assigning in increasing order is recommended** (auto increment). The magnitude of an ID has no meaning.
- It points to the same target across versions. A deleted ID is not reused ([Document](/grammar/document/), Revisions).
- To be pointed to from outside the document, the document must have a `DOC-ID`.
- Different LOCAL IDs do not necessarily mean different targets in reality. If they are the same, link them with a `SAME-NODE` Edge; if different, with a `DIFFERENT-NODE` Edge.

### Edge Id

Every Edge places a LOCAL Reference as the first element of its Payload. That LOCAL ID is the **Edge Id**.

- The Edge Id can be read even without the codebook.
- A LOCAL in the Edge Id position is a declaration, and a LOCAL in any other position of an Edge is a mention.
- A LOCAL that declares an Edge Id uses only Quantifier `000`.
- Another Edge is pointed to by its Edge Id. An Edge in this document is pointed to with a LOCAL, and an Edge in another document with a pointer Reference.

## Pointing to Other Documents

| What | How |
|---|---|
| The Issuer itself | `ISSUER-POINTER` (Issuer) |
| One version of a document | `DOC-POINTER` (Issuer, document ID 4 WORD, version ID 2 WORD). Version `0` is the latest |
| A target in a published document (latest) | `EXTERNAL-ISSUER-*` (Issuer, document ID, LOCAL ID) |
| A target in an imported document (edition pinned) | Assign an IMPORT ID with Meta `IMPORT-DOC`, and use `EXTERNAL-POINTER-*` (IMPORT ID, LOCAL ID) |

- A document itself, whether from inside or outside that document, is pointed to only with a single DOC-POINTER. A document points to itself with the DOC-POINTER of its own `DOC-ID`.
- EXTERNAL-ISSUER follows the latest version. To pin an edition, use IMPORT.
- Write the Issuer in the shortest width that fits the value (1/2/4/16 WORD), and pick the Codec that matches that width.
- Document ID `0` of each Issuer is reserved for the index document of the terms (tools, roles, and so on) that Issuer defines. An index document is recommended for every Issuer and is not required ([Issuer and Publication](/grammar/issuer/#term-definition-documents)).

Example: Issuer `0x0001`, LOCAL 7 in document `0x0000000000000002`

```
0360 0001 0000 0000 0000 0002 0007
```

## Quantifier (`QQQ`)

| QQQ | Name | Meaning | Example |
|---|---|---|---|
| `000` | Identified | An identified individual | Elon Musk, South Korea |
| `001` | Generic | A general statement about a whole kind. Allows exceptions | Soldiers obey orders |
| `010` | Free-choice | Any target that satisfies the condition | Any soldier at all |
| `011` | Universal | Every target within the scope | All soldiers |
| `100` | Variable | A discourse variable | That person, this woman |
| `101`-`111` | Reserved | | |

- **Exception: in Codec `0000` (slot marker), the lower 3 bits are the marker number, not a Quantifier.** The meaning of a marker number and a Quantifier do not carry over (`0x0001` UNKNOWN-VALUE is not Generic). The Quantifiers in this table apply only to Codecs `0001` to `1111`.
- Unlike Universal, Generic does not mean it applies to every individual without exception. A definitional expression such as "what a soldier is" can be written as Generic. When a strict definition of a concept or classification is needed, make it concrete with a separate relation.
- The scope and negation of quantification are set by the Edge that uses the Reference, not by the Reference.
- A **Variable** is a target in the discourse whose kind is known but which is not yet identified.
  - A named variable attaches Variable to a LOCAL. The same LOCAL ID is the same variable. The kind is linked with an Edge.
  - An anonymous variable attaches Variable to a declaration Codec that points to a kind (GEUL, WIKIDATA-*) (for example Wikidata "president" + Variable). Coreference is not tracked, and it cannot be pointed to again. Anonymous variables are not treated as the same variable.
  - When the target is confirmed later, link the variable to that target with `SAME-NODE`. All expressions that point to the same variable are then interpreted as that target together.
  - Even different variables do not necessarily mean different actual targets. If they are the same, link with `SAME-NODE`; if different, with `DIFFERENT-NODE`.
  - A variable is valid only inside its document and is not used as a permanent identifier.
  - A Variable in an external pointer Codec (EXTERNAL-POINTER-*, EXTERNAL-ISSUER-*) is a LOCAL variable of the document it points to.
  - Example: in "The president gave a speech", if the person is not determined, use a 'president' Variable. To mention it again, place a LOCAL Variable and link the kind 'president' with an Edge. If it is later confirmed to be Obama, link that variable to Obama Identified with `SAME-NODE`. All expressions that point to the same variable are then interpreted as Obama together.
- Example: using Wikidata Q5 (human) as Generic gives `00A1 0005` ("Humans are …").
