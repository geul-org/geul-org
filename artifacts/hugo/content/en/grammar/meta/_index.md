---
title: "Meta"
weight: 70
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance", "lineage", "import"]
summary: "Meta is a record about the document, not about the world. It is divided into seven classes (structure, declaration, provenance, lineage, verification, policy, IMPORT) and is placed in the HEAD of the document."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Meta is a record about the document, not content about the world. Apart from the document structure records (DOC, BODY, END), all of it is placed in the HEAD of the document. Besides Meta, the HEAD also holds the evidence Edge [SOURCE](/grammar/edge/source/#source-of-the-whole-document) for the whole document and its QUALIFIERs.

## Layout

```
TAG WORD          0001 1LLL LCCC CCCC
[Length extension TAG]
Payload           raw values, or embedded Value and Reference records
```

- Meta has no Issuer format. Meta is a common specification that every Issuer follows, and only GEUL defines it.
- `LLLL` is the total WORD count including the TAG WORD, minus 1. A Codec not in the table is reserved.

## Payload Forms

| Form | When | Examples |
|---|---|---|
| Raw value | When the form is fixed to one. It does not rely on another record Codec | `DOC-*` length, `SPEC-VERSION`, `ISSUER-KEY` |
| Embedded Value | When choosing among several forms. The Value TAG tells the form | `PROFILE`, `EFFECTIVE-*`, times, content hash |
| Embedded Reference | When pointing to a target such as a person, organization, tool, or document | `DOC-ID`, `AUTHOR`, `CO-AUTHOR`, `RECORDED-BY`, `SIGNED-OFF`, the signer of `SIGNATURE` |
| None | A 1 WORD marker | `BODY`, `END` |

- An embedded record is not an independent record; it belongs to its Meta. Each finds its boundary by its own Length, and the position after reading the last record must match the end of the Meta exactly.
- Which Meta may appear only once per document and which may appear several times is decided by "Count" in each Codec's page.

## Classes

The upper 3 bits of the Codec are the class.

| Upper 3 bits | Class | Direct codes | What it covers |
|---|---|---|---|
| `000` | Structure | `0x00`-`0x0F` | Document boundaries and length |
| `001` | Declaration | `0x10`-`0x1F` | Interpretation declarations |
| `010` | Provenance | `0x20`-`0x2F` | Who, when, where |
| `011` | Lineage | `0x30`-`0x3F` | What it came from and how |
| `100` | Verification | `0x40`-`0x4F` | Whether it can be trusted |
| `101` | Policy | `0x50`-`0x5F` | How to handle it |
| `110` | IMPORT | `0x60`-`0x6F` | Import an external document |
| `111` | Reserved | `0x70`-`0x7F` | |

- **Meta needed for interpretation**: structure, declaration, IMPORT. If removed, the records cannot be read or their interpretation changes. Every decoder must handle them. These Codecs belong to the **GEUL core codebook**.
- **Meta that does not change interpretation**: provenance, lineage, verification, policy. If removed, the content of the statements stays the same. Only the material for judging trust and handling is lost.
- Evidence is written not as Meta but with the evidence Edge [SOURCE](/grammar/edge/source/) and QUALIFIER. The evidence for an individual record goes in the BODY, and the source of the whole document goes in the HEAD as a SOURCE with Target `0` ([Document](/grammar/document/#head-and-body)).

## Structure

Bundle page: [Meta — Structure](/grammar/meta/structure/)

| Codec | Name | Meaning |
|---|---|---|
| `0x00`-`0x02` | [DOC-1WORD / 2WORD / 4WORD](/grammar/meta/structure/doc/) | Opens the document with the total length given |
| `0x0E` | [BODY](/grammar/meta/structure/body/) | Ends the HEAD and opens the BODY |
| `0x0F` | [END](/grammar/meta/structure/end/) | Closes the document |

The detailed rules are in [Document](/grammar/document/).

## Declaration

Bundle page: [Meta — Declaration](/grammar/meta/declaration/)

| Codec | Name | Meaning |
|---|---|---|
| `0x10` | [SPEC-VERSION](/grammar/meta/declaration/spec-version/) | The spec version followed. One integer |
| `0x11` | [PROFILE](/grammar/meta/declaration/profile/) | The applied profile |
| `0x12` | [DOC-ID](/grammar/meta/declaration/doc-id/) | This document's identifier. A DOC-POINTER (version 0) that points to itself |
| `0x13` | [EFFECTIVE-FROM](/grammar/meta/declaration/effective-from/) | The date this version takes effect. If absent, the publication time |
| `0x14` | [EFFECTIVE-UNTIL](/grammar/meta/declaration/effective-until/) | The end of this version's period of validity (a temporary law). If absent, until the next version takes effect |
| `0x16` | [DEFAULT-LANGUAGE](/grammar/meta/declaration/default-language/) | The default language |

- A name for addressing a document is not placed as Meta. The Issuer's name index `documents.geul` attaches it with BIND ([Publication Addresses and Version Lists](/grammar/publishing/#document-names)). A human-readable title is attached with a LABEL in the BODY.

## Provenance

Bundle page: [Meta — Provenance](/grammar/meta/provenance/)

| Codec | Name | Meaning |
|---|---|---|
| `0x20` | [AUTHOR](/grammar/meta/provenance/author/) | Author (Reference) |
| `0x21` | [CO-AUTHOR](/grammar/meta/provenance/co-author/) | Co-author |
| `0x22` | [CREATED-AT](/grammar/meta/provenance/created-at/) | Creation time |
| `0x23` | [MODIFIED-AT](/grammar/meta/provenance/modified-at/) | Modification time |
| `0x24` | [RECORDED-BY](/grammar/meta/provenance/recorded-by/) | The party that recorded it |
| `0x25` | [RECORDED-AT](/grammar/meta/provenance/recorded-at/) | The time it was recorded |
| `0x26`-`0x2F` | Reserved | |

- The source material is written not as Meta but as the HEAD evidence Edge [SOURCE](/grammar/edge/source/#source-of-the-whole-document) (Target `0`), and the range within the source, the time it was obtained, and the source hash are written as QUALIFIERs attached to that SOURCE.

## Lineage

Bundle page: [Meta — Lineage](/grammar/meta/lineage/)

Lineage follows git's commit model. The unit that corresponds to a commit is the document.

| Codec | Name | Meaning |
|---|---|---|
| `0x30` | [PARENT](/grammar/meta/lineage/parent/) | Content hash of the previous version. Several means a merge |
| `0x31` | [DERIVED-FROM](/grammar/meta/lineage/derived-from/) | Derived from material of another lineage |
| `0x32` | [GENERATED-BY](/grammar/meta/lineage/generated-by/) | The generating party (person, model, rule engine) |
| `0x33` | [TRANSFORMED-BY](/grammar/meta/lineage/transformed-by/) | The transformation tool and its source version (commit digest) |
| `0x34` | [CHERRY-PICKED-FROM](/grammar/meta/lineage/cherry-picked-from/) | The original version of a picked change |
| `0x35` | [REVERTS](/grammar/meta/lineage/reverts/) | The version that was reverted |
| `0x36` | [REPLACES](/grammar/meta/lineage/replaces/) | The version that was rewritten. The original version is not deleted |
| `0x37` | [SQUASHED-FROM](/grammar/meta/lineage/squashed-from/) | The original versions merged into one |
| `0x38` | [MESSAGE](/grammar/meta/lineage/message/) | The reason for the change. One per language |
| `0x39` | [TAG](/grammar/meta/lineage/tag/) | An immutable name attached to a version |
| `0x3A` | [DELTA-BASE](/grammar/meta/lineage/delta-base/) | This file is a diff against the base version |
| `0x3B` | [DELTA-REMOVE](/grammar/meta/lineage/delta-remove/) | List of LOCAL IDs to remove in a diff |
| `0x3C` | [NEXT-LOCAL-ID](/grammar/meta/lineage/next-local-id/) | The next LOCAL ID to assign. Placed in the version list document |

- History is not erased. A correction is issued as a new version.
- Pointers that change, like a branch, are not placed in the document. The repository and index manage them.

## Verification

Bundle page: [Meta — Verification](/grammar/meta/verification/)

| Codec | Name | Meaning |
|---|---|---|
| `0x40` | [ISSUER-KEY](/grammar/meta/verification/issuer-key/) | Signature algorithm and public key of a self-issued Issuer |
| `0x41` | [SIGNATURE](/grammar/meta/verification/signature/) | A signature over the content hash. Algorithm, signer, signature |
| `0x42` | [SIGNED-OFF](/grammar/meta/verification/signed-off/) | Confirmation of the right to contribute |
| `0x43` | [CONFIDENCE](/grammar/meta/verification/confidence/) | Confidence |
| `0x44` | [VERDICT](/grammar/meta/verification/verdict/) | The judgment result for the whole document (Pass, Review, Fail) |

- The verification class is left out of the content hash calculation. So the content hash does not change whether a signature is placed inside the document or several signatures are added.

## Policy

Bundle page: [Meta — Policy](/grammar/meta/policy/)

| Codec | Name | Meaning |
|---|---|---|
| `0x50` | [LICENSE](/grammar/meta/policy/license/) | License |
| `0x51` | [ACCESS](/grammar/meta/policy/access/) | Scope of disclosure |
| `0x52` | [PRIVACY](/grammar/meta/policy/privacy/) | Privacy level |
| `0x53` | [RETENTION](/grammar/meta/policy/retention/) | Retention period |
| `0x54` | [CONSENT](/grammar/meta/policy/consent/) | Scope and basis of consent |
| `0x55` | [USAGE](/grammar/meta/policy/usage/) | Usage restrictions |

- A policy does not change interpretation; it sets how to handle the document.

## IMPORT

Bundle page: [Meta — IMPORT](/grammar/meta/import/)

```
TAG WORD          0001 1LLL L110 0000      IMPORT-DOC (0x60)
[Length extension TAG]
Document          DOC-POINTER record (Issuer, document ID, version ID)
IMPORT ID         the rest. An integer in the shortest width
```

- Only [IMPORT-DOC](/grammar/meta/import/import-doc/) (`0x60`) is used. IMPORT imports documents only. A target inside the imported document is pointed to with `EXTERNAL-POINTER-*` (IMPORT ID, LOCAL ID) in the BODY.
- If a version ID is written, it is bound to that edition; if `0`, to the latest edition at the time of interpretation. A published document writes the version.
- The same IMPORT ID is not assigned twice in one document.
- The HEAD of the imported document is not imported. Targets in that document are interpreted as that document declares.

Example: with Issuer `0x0001` and document `0x0000000000000002`, import the latest version as IMPORT ID 1.

```
1CE0 03B8 0001 0000 0000 0000 0002 0000 0000 0001
```
