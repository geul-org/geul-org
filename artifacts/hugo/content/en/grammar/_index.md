---
title: "GEUL Grammar"
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "specification"]
summary: "The GEUL v1 grammar specification. It defines records over 16-bit words, the four Kinds, document structure, Issuers, and publication rules."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
showContent: true
---

GEUL (General Encoding Unified Language) is an artificial language and binary format for humans and AI to exchange information without ambiguity.

These documents define the GEUL v1 grammar. The current edition is a pre-publication draft and may change. The specification is released under [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/).

## At a Glance {#한눈에-보기}

- All data is a sequence of **16-bit words (WORD)**, written in big-endian order.
- The unit of data is the **record**. A record begins with one TAG WORD, and that TAG WORD states the record's type and length.
- There are four kinds of record (**Kind**).

| Kind | What it does | Example |
|---|---|---|
| Reference | Points to a target | Wikidata Q42, #7 in this document |
| Value | Holds a value itself | A date, a quantity, text with a language tag |
| Edge | Binds other records together to make a statement | "Q42 is a human", "The English name of Q42 is Douglas Adams" |
| Meta | Speaks about the document | Specification edition, document ID, author, signature |

- Records are held in a single **document**. Like HTML, a document is divided into HEAD (Meta, plus the document-wide source SOURCE and its QUALIFIER) and BODY (Reference, Value, Edge).
- A document is issued by an **Issuer**, and each version is fixed by its content hash. A published version is never changed.

## Design Principles {#설계-원칙}

1. **Records can be skipped without a codebook.** A record's type and length are in the 16 bits of the TAG WORD. A decoder that does not know how to interpret a record (the codebook) can still count and skip it.
2. **It holds statements, not facts.** A document records who made a statement, when, and from what source, using Meta and evidence Edges.
3. **Identification is done by Reference.** Targets are pointed to by ID, not by name. Names are attached by Edge.
4. **What is published is not changed.** Corrections are issued as a new version. An ID inside a document points to the same target across versions.
5. **Leave space empty.** Most of the bit space is left for the future. Direct codes cannot be reclaimed, so only those whose frequency has been confirmed are assigned.

## Sub-documents {#하위-문서}

If you are reading for the first time, read the table from the top in order.

| Document | Contents |
|---|---|
| [Record Structure](record.md) | TAG WORD layout, Length, Codec, extended TAG |
| [Issuer and Publication](issuer.md) | Issuer tiers, the 2-WORD assignment table, disclosure methods, signatures, verification keys |
| [Publication Addresses and Version List](publishing.md) | ID notation, publication addresses, format specifiers, Issuer list, version list, trust layers |
| [Codec Specification Document](codec-spec.md) | Codebooks written with DECLARE, FIELD, ENUM, CODEC |
| [General Document](document.md) | DOC, HEAD, BODY, END, document ID, content hash, versions and revisions |
| [Codec Index](codec-index.md) | All 227 assigned slots, Codec tables by Kind and family |
| [Section Layout](layout.md) | The 16 sections and slot layout, assigned and Reserved ranges |
| [Slot Markers](slot-marker.md) | ABSENT, UNKNOWN-VALUE, NO-VALUE, acceptance rules |
| [Reference](reference/_index.md) | Target identification, LOCAL, external references, Quantifier, slot markers |
| [Value](value/_index.md) | Value families, direct codes, text, quantity, date |
| [Meta](meta/_index.md) | Structure, definition, provenance, lineage, verification, policy, IMPORT |
| [Edge](edge/_index.md) | Statement, evidence, execution, and TOULMIN families; TRIPLE, QUALIFIER, LABEL |
| [TOULMIN](toulmin/_index.md) | Judgment and execution graph family; NODE, LINK, SOURCE layouts |
| [Example: A Wikidata Item](example.md) | Reading one document word by word |

## What Can Be Known Without a Codebook {#코덱북-없이-알-수-있는-것}

| Information | Without a codebook | Basis |
|---|---|---|
| Kind | Known | The section `w >> 9` range of the TAG WORD (Reference 0-2, Value 3-4, Edge 5-13, Meta 14-15) |
| Total record length, position of the next record | Known | Length in the TAG WORD |
| Codec number | Known | The TAG WORD (for the Issuer format, the Issuer and codec number in the extended TAG) |
| Family, class | Partly known | Only the family of an Edge direct code is known from the bits. The family of Value direct codes and Issuer formats, and the Meta class, are not known from the bits. For the Issuer format, the Issuer and codec number are known. The Meta verification class is known from `C >= 5` in section 15 (`w >= 0x1E50`) |
| Edge Id of an Edge | Known | The first component of an Edge (sections 5-13) is always a LOCAL Reference |
| Slot markers (not stated, unknown, none) | Known | WORD value `0x0000`, `0x0010`, `0x0020` (Reference, C < 3, L 0). [Slot Markers](slot-marker.md) |
| Quantifier | Known | By the offset `C` within the section: in section 0, `5 <= C < 30`; in section 1, `C < 30`; then `C % 5` |
| TAG length per Codec, Payload start position | Not known | Codebook |
| Payload interpretation, roles of Edge components | Not known | Codebook |

- A decoder without a codebook can skip through records and count them by Kind and Codec, but cannot follow the graph structure.
- Every decoder must handle the Meta structure, definition, and IMPORT classes. These Codecs belong to the GEUL core codebook, and the decoder knows them from a built-in number table ([Meta](meta/_index.md)).

Codebooks are published as GEUL documents ([Codec Specification Document](codec-spec.md)). A decoder therefore only needs to fetch and read the specification document it requires.

## Region Structure {#영역-구조}

The upper bits of the TAG WORD divide the space into regions.

| Prefix | Region | Share | Definition |
|---|---|---|---|
| `1` | Far future | 50% | Reserved (far future). Not used |
| `01` | Future | 25% | Reserved (near future). Not used |
| `001` | Standard | 12.5% | Grammar officially adopted and in operation |
| `000` | Free / proposal | 12.5% | The current grammar. When adopted, the layout stays as is and only the Prefix moves to `001` |

All of the current grammar is in the `000` region. Every TAG WORD in this specification begins with `000`.

- A v1 decoder rejects any TAG WORD whose Prefix is not `000`. The other regions are decided by later editions.
- The `000` region is a proposal space. No registration or protection applies at present.
