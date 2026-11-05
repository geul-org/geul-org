---
title: "Meta"
weight: 110
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "provenance", "lineage", "import"]
summary: "Meta is a record about the document, not about the content concerning the world."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Meta is a record about the document, not about the content concerning the world. Except for the document structure records (DOC, BODY, END), all of them go in the HEAD of the document. Besides Meta, the HEAD also holds the document-wide evidence Edge [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) and its QUALIFIER.

## Layout {#레이아웃}

```
TAG WORD          000K KKKC CCCC LLLL      Sections 14 and 15 (0x1C0L~0x1FFL)
[Length extension TAG]
Payload           Raw value, or an embedded Value or Reference record
```

- Meta has no Issuer form. Meta is a common specification that all Issuers follow, and only GEUL defines it.
- `LLLL` is the total WORD count including the TAG WORD, minus 1. A Codec not in the table is Reserved.

## Payload forms {#payload-형식}

| Form | When | Examples |
|---|---|---|
| Raw value | When the form is fixed to one. It does not rely on other record Codecs | `DOC-*` length, `SPEC-VERSION`, `ISSUER-KEY` |
| Embedded Value | When choosing among several forms. The Value TAG tells the form | `PROFILE`, `EFFECTIVE-*`, times, content hash |
| Embedded Reference | When pointing at a target such as a person, organization, tool, or document | `DOC-ID`, `AUTHOR`, `CO-AUTHOR`, `RECORDED-BY`, `SIGNED-OFF`, the signer of `SIGNATURE` |
| None | A 1 WORD marker | `BODY`, `END` |

- An embedded record is not an independent record and belongs to its Meta. Each finds its boundary by its own Length, and the position after reading the last record must coincide exactly with the end of the Meta.
- Whether a Meta may appear only once or several times in a document is set by the "Count" of each Codec document.

## Classes {#클래스}

Meta numbers run on from `0x1C0L` without Reserved gaps. The bits of the number do not indicate the class. The class is known from the range table below.

| Class | Direct codes | What it covers |
|---|---|---|
| structure | `0x1C0L~0x1C4L` | Document boundary and length |
| declaration | `0x1C5L~0x1CAL` | Interpretation declarations |
| provenance | `0x1CBL~0x1D0L` | Who, when, where |
| lineage | `0x1D1L~0x1DDL` | What it came from and how |
| policy | `0x1DEL~0x1E3L` | How it is handled |
| IMPORT | `0x1E4L` | Imports an external document |
| verification | `0x1E5L~0x1E9L` | Whether it can be trusted |
| Reserved (verification only) | `0x1EAL~0x1FFL` | |

- The verification class is the records in Section 15 with `C >= 5`, that is, `w >= 0x1E50`. With this, the verification class is known without a codebook and is removed from the content hash.
- The trailing Reserved range `0x1EAL~0x1FFL` is verification only. A new Meta outside verification cannot be placed before verification, and if placed in the trailing Reserved range it is excluded from the content hash.
- The structure, declaration, and IMPORT classes are not read from bits. The decoder knows them from a built-in number table.
- **Meta required for interpretation**: structure, declaration, IMPORT. If removed, the records cannot be read or the interpretation changes. Every decoder must handle them. These Codecs belong to the **GEUL core codebook**.
- **Meta that does not change interpretation**: provenance, lineage, verification, policy. If removed, the content of the statements stays the same. Only the material for trust judgment and handling disappears.
- Evidence is written not as Meta but with the evidence Edge [SOURCE](../edge/0x0C0L-source.md) and QUALIFIER. Evidence for an individual record goes in the BODY, and the origin of the whole document goes in the HEAD as a SOURCE with Target `0` ([document](../document.md#head와-body)).

## Structure {#구조}

The Meta structure class (Codec `0x1C0L~0x1C4L`) sets the boundary and length of the document. The unit of GEUL data is one document.

```
DOC-*                  ← HEAD starts
  declaration, provenance, lineage, verification, policy, IMPORT Meta
  document-wide SOURCE and its QUALIFIER
BODY                   ← BODY starts
  Reference, Value, Edge
END                    ← closes the document
```

- Every document is opened by `DOC-1WORD/2WORD/4WORD`, which specifies the total length. A decoder can skip the whole document at once with this length.
- `BODY` and `END` are 1 WORD records with no Payload. `END` is required.
- Documents do not nest. Other documents are pointed at with IMPORT.
- If the HEAD (Meta, the document-wide SOURCE and its QUALIFIER) is empty, `BODY` is omitted. `BODY` may appear only once per document.

The whole document structure is in [document](../document.md).

| Codec | Name | Meaning |
|---|---|---|
| `0x1C0L~0x1C2L` | [DOC-1WORD / 2WORD / 4WORD](0x1C0L-doc-1word.md) | Opens the document, specifying the total length |
| `0x1C3L` | [BODY](0x1C3L-body.md) | Ends the HEAD and opens the BODY |
| `0x1C4L` | [END](0x1C4L-end.md) | Closes the document |

Detailed rules are in [document](../document.md).

## Declaration {#정의}

The Meta declaration class (Codec `0x1C5L~0x1CAL`) is interpretation declarations. A declaration changes the interpretation rules, so every decoder must handle it. The scope of a declaration is that document.

- `SPEC-VERSION` determines how the remaining records are read, so it holds a plain integer with no embedded Value. GEUL v1 is `0x0001` (record `1C51 0001`).
- `DOC-ID` is a `DOC-POINTER` (Issuer, document ID, version `0`) pointing at the document itself. A codec document uses `CODEC-POINTER` (Issuer, codec ID, version `0`). If absent, the document is unnamed and can be pointed at only by its content hash.
- There is no document name address. A human-readable title is attached with a statement `LABEL` ([publication addresses and version lists](../publishing.md#문서-이름)).

| Codec | Name | Meaning |
|---|---|---|
| `0x1C5L` | [SPEC-VERSION](0x1C5L-spec-version.md) | The specification edition followed. A single integer |
| `0x1C6L` | [PROFILE](0x1C6L-profile.md) | The applied profile |
| `0x1C7L` | [DOC-ID](0x1C7L-doc-id.md) | The identifier of this document. A DOC-POINTER (version 0) pointing at itself. A codec document uses CODEC-POINTER (version 0) |
| `0x1C8L` | [EFFECTIVE-FROM](0x1C8L-effective-from.md) | The effective date of this version. If absent, the publication time |
| `0x1C9L` | [EFFECTIVE-UNTIL](0x1C9L-effective-until.md) | The end of the validity period of this version (time-limited law). If absent, until the next version takes effect |
| `0x1CAL` | [DEFAULT-LANGUAGE](0x1CAL-default-language.md) | The default language |

- There is no document name address ([publication addresses and version lists](../publishing.md#문서-이름)). A human-readable title is attached with a LABEL in the BODY.

## Provenance {#출처}

The Meta provenance class (Codec `0x1CBL~0x1D0L`) records who created and recorded the document, and when.

- The author, the recorder, and their times follow git's author and committer model (`AUTHOR` and `CREATED-AT`, `RECORDED-BY` and `RECORDED-AT`).
- Removing provenance does not change the content of the statements. Only the material for trust judgment disappears.
- Source material is not in this class. The origin of the whole document is written in the HEAD, and the origin of an individual record in the BODY, with the evidence Edge [SOURCE](../edge/0x0C0L-source.md). The corresponding range in the source text, the acquisition time, and the source-text hash are QUALIFIERs attached to that SOURCE (page P304 and section P958, retrieval date P813, checksum P4092).
- If properties attached to a source (source-text range, acquisition time) were kept as Meta, it could not be decided which source they belong to when there are several sources. So they are written as QUALIFIERs that take the SOURCE as Target.

| Codec | Name | Meaning |
|---|---|---|
| `0x1CBL` | [AUTHOR](0x1CBL-author.md) | The author (Reference) |
| `0x1CCL` | [CO-AUTHOR](0x1CCL-co-author.md) | The co-author |
| `0x1CDL` | [CREATED-AT](0x1CDL-created-at.md) | Creation time |
| `0x1CEL` | [MODIFIED-AT](0x1CEL-modified-at.md) | Modification time |
| `0x1CFL` | [RECORDED-BY](0x1CFL-recorded-by.md) | The recorder |
| `0x1D0L` | [RECORDED-AT](0x1D0L-recorded-at.md) | Recording time |

- Source material is written not as Meta but as the evidence Edge [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) in the HEAD (Target `0`), and the source-text range, acquisition time, and source-text hash are written as QUALIFIERs attached to that SOURCE.

## Lineage {#계보}

The Meta lineage class (Codec `0x1D1L~0x1DDL`) records what the document came from and how. Lineage follows git's commit model, and the unit corresponding to a commit is the document.

- The **content hash** points at one complete copy of the document content (git commit id). It is the SHA-256 from the opening record (`DOC-*`) up to just before `END`, and records of the verification class (`C >= 5` in Section 15, `w >= 0x1E50`) are excluded from the computation.
- The **version ID** is a 2 WORD integer numbered from 1 in publication order within a named document. `0` means no version is written.
- Lineage Meta points at versions by content hash. The `PARENT` inside a document also enters the hash, so the content hash becomes a hash chain linking the whole history.
- History is not erased. A correction is issued as a new version. A pointer that changes, like a branch, is not placed in the document.
- `DELTA-BASE` and `DELTA-REMOVE` are a format that stores a version as a diff against a base version. A version is always defined as a snapshot.

Revision rules are in [document](../document.md).

Lineage follows git's commit model. The unit corresponding to a commit is the document.

| Codec | Name | Meaning |
|---|---|---|
| `0x1D1L` | [PARENT](0x1D1L-parent.md) | The content hash of the immediately preceding version. If several, a merge |
| `0x1D2L` | [DERIVED-FROM](0x1D2L-derived-from.md) | Derived from material of another lineage |
| `0x1D3L` | [GENERATED-BY](0x1D3L-generated-by.md) | The generating agent (person, model, rule engine) |
| `0x1D4L` | [TRANSFORMED-BY](0x1D4L-transformed-by.md) | The conversion tool and its source version (commit digest) |
| `0x1D5L` | [CHERRY-PICKED-FROM](0x1D5L-cherry-picked-from.md) | The original version of an imported change |
| `0x1D6L` | [REVERTS](0x1D6L-reverts.md) | The version that was reverted |
| `0x1D7L` | [REPLACES](0x1D7L-replaces.md) | The version that was rewritten. The original version is not deleted |
| `0x1D8L` | [SQUASHED-FROM](0x1D8L-squashed-from.md) | The original versions merged into one |
| `0x1D9L` | [MESSAGE](0x1D9L-message.md) | The reason for a change. One per language |
| `0x1DAL` | [TAG](0x1DAL-tag.md) | An immutable name given to a version |
| `0x1DBL` | [DELTA-BASE](0x1DBL-delta-base.md) | This file is a diff against a base version |
| `0x1DCL` | [DELTA-REMOVE](0x1DCL-delta-remove.md) | The list of LOCAL IDs to remove in the diff |
| `0x1DDL` | [NEXT-LOCAL-ID](0x1DDL-next-local-id.md) | The LOCAL ID to assign next. Placed in the version-list document |

- History is not erased. A correction is issued as a new version.
- A pointer that changes, like a branch, is not placed in the document. The repository and the index manage it.

## Verification {#검증}

The Meta verification class (Codec `0x1E5L~0x1E9L`) records the material for judging whether the document can be trusted: the public key of a self-issued Issuer, signatures, confirmation of the right to contribute, confidence, and the verdict on the whole document.

- The verification class is excluded from the content hash computation. So putting a signature inside the document, or adding several signatures, does not change the content hash (the same approach as git `gpgsig`).
- The verification class is the records in Section 15 with `C >= 5`, that is, `w >= 0x1E50`, so the hash can be computed without a codebook. The trailing Reserved range `0x1EAL~0x1FFL` is also verification only and is excluded from the hash.
- Node-level and record-level verdicts are carried by the [TOULMIN](../toulmin/_index.md) Edge `VERDICT` (`0x118L`).

| Codec | Name | Meaning |
|---|---|---|
| `0x1E5L` | [ISSUER-KEY](0x1E5L-issuer-key.md) | The signature algorithm and public key of a self-issued Issuer |
| `0x1E6L` | [SIGNATURE](0x1E6L-signature.md) | A signature over the content hash. Algorithm, signer, signature |
| `0x1E7L` | [SIGNED-OFF](0x1E7L-signed-off.md) | Confirmation of the right to contribute |
| `0x1E8L` | [CONFIDENCE](0x1E8L-confidence.md) | Confidence |
| `0x1E9L` | [VERDICT](0x1E9L-verdict.md) | The verdict on the whole document (Pass, Review, Fail) |

- The verification class is excluded from the content hash computation. So putting a signature inside the document, or adding several signatures, does not change the content hash.

## Policy {#정책}

The Meta policy class (Codec `0x1DEL~0x1E3L`) sets how the document is handled: license, scope of disclosure, privacy level, retention period, consent, and usage restrictions.

- A policy does not change interpretation; it sets how to handle the document.
- The original license of a work inside a byte sequence is recorded with `LICENSE`.

| Codec | Name | Meaning |
|---|---|---|
| `0x1DEL` | [LICENSE](0x1DEL-license.md) | License |
| `0x1DFL` | [ACCESS](0x1DFL-access.md) | Scope of disclosure |
| `0x1E0L` | [PRIVACY](0x1E0L-privacy.md) | Privacy level |
| `0x1E1L` | [RETENTION](0x1E1L-retention.md) | Retention period |
| `0x1E2L` | [CONSENT](0x1E2L-consent.md) | Scope and basis of consent |
| `0x1E3L` | [USAGE](0x1E3L-usage.md) | Usage restrictions |

- A policy does not change interpretation; it sets how to handle the document.

## IMPORT {#import}

The Meta IMPORT class (Codec `0x1E4L`) imports an external document under an IMPORT ID. The only Codec is `IMPORT-DOC` (`0x1E4L`).

- IMPORT imports only documents. Targets inside the imported document are pointed at by the BODY Reference `EXTERNAL-POINTER-*` (IMPORT ID, LOCAL ID) ([Reference](../reference/_index.md)).
- If a version ID is given, it binds to that edition; if `0`, to the latest edition at interpretation time. Published documents state the version.
- The HEAD of the imported document is not imported. Reference and Value records are copied, not imported.

```
TAG WORD          0001 1110 0100 LLLL      IMPORT-DOC (0x1E4L)
[Length extension TAG]
Document          DOC-POINTER record (Issuer, document ID, version ID). A codec document uses CODEC-POINTER
IMPORT ID         The rest. An integer of the shortest width
```

- Only [IMPORT-DOC](0x1E4L-import-doc.md) (`0x1E4L`) is used. IMPORT imports only documents. Targets inside the imported document are pointed at by `EXTERNAL-POINTER-*` (IMPORT ID, LOCAL ID) in the BODY.
- If a version ID is given, it binds to that edition; if `0`, to the latest edition at interpretation time. Published documents state the version.
- The same IMPORT ID is not assigned twice in one document.
- The HEAD of the imported document is not imported. Targets of that document are interpreted as that document declares.

Example: import the latest version of document `0x0000000000000002` of Issuer `0x00000002` as IMPORT ID 1.

```
1E4A 0418 0000 0002 0000 0000 0000 0002 0000 0000 0001
```
