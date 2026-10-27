---
title: "Overview"
weight: 10
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "overview"]
summary: "GEUL v1 is a sequence of records made of 16-bit words. There are four kinds of records, Reference, Value, Edge, and Meta, and the records are held in a single document."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL (General Encoding Unified Language) is an artificial language and binary format that lets people and AI exchange information without ambiguity. This document defines the grammar of GEUL v1.

## At a Glance

- All data is a sequence of **16-bit words (WORD)**, written in big-endian order.
- The unit of data is the **record**. A record begins with one TAG WORD, and that TAG WORD gives the kind and length of the record.
- There are four kinds of records (**Kind**).

| Kind | What it does | Examples |
|---|---|---|
| Reference | Points to a target | Wikidata Q42, #7 in this document |
| Value | Holds a value itself | A date, a quantity, text with a language |
| Edge | Binds other records together to make a statement | "Q42 is a human", "The English name of Q42 is Douglas Adams" |
| Meta | Speaks about the document | Spec version, document ID, author, signature |

- Records are held in a single **document**. Like HTML, a document is divided into a HEAD (Meta, plus the SOURCE for the whole document and its QUALIFIERs) and a BODY (Reference, Value, Edge).
- A document is published by an **Issuer** and each version is pinned by a content hash. A published version never changes.

## Design Principles

1. **Records can be skipped without a codebook.** The kind and length of a record are in the 16 bits of the TAG WORD. A decoder that does not know how to interpret the record (the codebook) can still count and skip records.
2. **A document holds statements, not facts.** A document records, through Meta and evidence Edges, who made a statement, when, and from what.
3. **Identification is done with a Reference.** Things are pointed to by ID, not by name. Names are attached with an Edge.
4. **What is published does not change.** A correction is issued as a new version. An ID inside a document points to the same target across versions.
5. **Leave space empty.** Most of the bit space is left for the future. Direct codes cannot be taken back, so only forms whose frequency has been confirmed get one.

## Region Structure

The upper bits of the TAG WORD divide the space into regions.

| Prefix | Region | Share | Definition |
|---|---|---|---|
| `1` | Far future | 50% | Reserved for the far future. Not used |
| `01` | Future | 25% | Reserved for the near future. Not used |
| `001` | Standard | 12.5% | Grammar officially adopted and in operation |
| `000` | Free / proposal | 12.5% | The current grammar. When adopted, the layout stays as it is and only the Prefix moves to `001` |

The current grammar lies entirely in the `000` region. Every TAG WORD in this specification begins with `000`.

- A v1 decoder rejects a TAG WORD whose Prefix is not `000`. The other regions are decided by later versions.
- The `000` region is a proposal space. No registration or protection applies to it for now. However, the Issuer format layout is reserved on the assumption of a registration system after the official standard is launched.

## What You Can Know Without a Codebook

| Information | Without a codebook | Basis |
|---|---|---|
| Kind | Known | TAG WORD |
| Total record length, position of the next record | Known | Length in the TAG WORD |
| Codec number | Known | TAG WORD (for an Issuer format, the Issuer and format number in the extension TAG) |
| Family and class | Known | Upper bits of the Codec number or format number |
| Edge Id of an Edge | Known | The first component of an Edge is always a LOCAL Reference |
| Slot marker (ABSENT, UNKNOWN-VALUE, NO-VALUE) | Known | The WORD value is `0` to `7` (Reference Codec `0000`, 1 WORD). [Slot marker](/grammar/reference/slot-marker/) |
| Per-Codec TAG length, start of the Payload | Not known | Codebook |
| Payload interpretation, roles of Edge components | Not known | Codebook |

- A decoder without a codebook can skip records and count them by Kind and Codec, but it cannot follow the graph structure.
- Every decoder must handle the Meta structure, declaration, and IMPORT classes. These Codecs belong to the GEUL core codebook ([Meta](/grammar/meta/)).

The codebook is published as a GEUL document ([Codec specification document](/grammar/codec-spec/)). A decoder therefore only needs to fetch and read the specification documents it requires.

## Sub-documents

| Document | Contents |
|---|---|
| [Records and the TAG WORD](/grammar/record/) | TAG WORD layout, Length, Codec, extension TAG |
| [Document](/grammar/document/) | DOC, HEAD, BODY, END, document ID, content hash, versions and revisions |
| [Reference](/grammar/reference/) | Identifying targets, LOCAL, external references, Quantifier, slot markers |
| [Value](/grammar/value/) | Value families, direct codes, text, quantities, dates |
| [Edge](/grammar/edge/) | Description, evidence, execution, and TOULMIN families; TRIPLE, QUALIFIER, LABEL |
| [Meta](/grammar/meta/) | Structure, declaration, provenance, lineage, verification, policy, IMPORT |
| [Issuer and Publication](/grammar/issuer/) | Issuer tiers, 1 WORD assignment table, disclosure methods, signatures, verification keys |
| [Publication Addresses and Version Lists](/grammar/publishing/) | ID notation, publication addresses, format specification, name index, version lists, trust layers |
| [Codec specification document](/grammar/codec-spec/) | A codebook written with DECLARE, FIELD, ENUM, and CODEC |
| [Example: A Wikidata Item](/grammar/example/) | Reading one document word by word |

## Open Questions

- The Kind of boundary cases. Cases such as a statement about a statement, where it is unclear whether to place it under Reference, Value, Edge, or Meta.
