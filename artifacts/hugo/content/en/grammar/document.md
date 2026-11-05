---
title: "Document"
weight: 50
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "document", "version", "hash"]
summary: "The unit of GEUL data is one document (DOC)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

The unit of GEUL data is one document (DOC). One file (`.geul`, media type `application/vnd.geul`) is one document.

## Structure {#구조}

```
DOC-*            ← opens the document (total length)
  Meta …         ← HEAD: records about the document
  SOURCE …       ←   (source of the whole document and its QUALIFIER)
BODY             ← ends the HEAD and opens the BODY
  Reference, Value, Edge …
END              ← closes the document
```

| Record | TAG | Meaning |
|---|---|---|
| DOC-1WORD | `1C01` + 1 WORD | Opens the document, giving the total length in 1 WORD |
| DOC-2WORD | `1C12` + 2 WORD | Total length in 2 WORDs |
| DOC-4WORD | `1C24` + 4 WORD | Total length in 4 WORDs |
| BODY | `1C30` | 1 WORD. Ends the HEAD and starts the BODY |
| END | `1C40` | 1 WORD. Closes the document |

- The value of DOC-* is the total number of WORDs from the start of the opening record to the end of END. Use the narrowest width that holds the value.
- END is required. If the position of END does not match the length in DOC-*, reject the document. If the input ends without END, the document is truncated.
- A decoder can skip the whole document at once by the length in DOC-*.
- There is no way to open a document without knowing its length. Real-time data whose end cannot be known in advance is cut into units of known length and sent as several documents.
- If the HEAD is empty, the BODY is omitted. A document with no BODY record is entirely BODY. Place BODY only once. If the HEAD has even one record (Meta or HEAD Edge), place the BODY.
- Documents do not nest. Another document is pointed to with [IMPORT](meta/_index.md) or a directing Reference.

## HEAD and BODY {#head와-body}

- The HEAD holds only Meta and **HEAD Edges**. Both are descriptions of the **document** that contains them.
  - Meta: structure, definitions, source, lineage, verification, policy, and IMPORT of the document.
  - HEAD Edge: the evidence Edge [SOURCE](edge/0x0C0L-source.md#문서-전체의-출처) (Target `0`) that records the origin of the whole document, and the [QUALIFIER](edge/0x0ABL-qualifier.md) that takes that SOURCE as its Target (original-text hash, time received, extent of the original text, and so on). A QUALIFIER is placed after its SOURCE.
- The BODY holds only Reference, Value, and Edge. The source of an individual record is written with the evidence Edge [SOURCE](edge/0x0C0L-source.md) inside the BODY, and other evidence such as confidence is written with a QUALIFIER attached to that record. A SOURCE with Target `0`, and a QUALIFIER whose Target is a HEAD SOURCE, cannot be placed in the BODY.
- A decoder reads the HEAD from the start and classifies as it goes. Meta is HEAD. A SOURCE with Target `0` is HEAD, and the decoder remembers its Edge Id. A QUALIFIER whose Target is a remembered SOURCE is HEAD. When any other record comes: if the HEAD is empty, the BODY was omitted (the BODY starts at that record); otherwise it is invalid for a missing BODY.
- **HEAD and BODY share one Edge Id number space.** An Edge Id is unique within the document and, like a BODY Edge, is obtained from [NEXT-LOCAL-ID](meta/0x1DDL-next-local-id.md). If the Origin of a HEAD Edge is LOCAL, its definition is placed in the BODY (LOCAL is scoped to the whole document).
- Meta can hold a Value record inside its Payload. The held Value is not an independent record but part of that Meta.
- The scope of a declaration (Meta definition class) is that document.

## Basic Declarations {#기본-선언}

Each of the two declarations appears at most once. The conditions below determine which documents must have them.

| Meta | Meaning | Documents that must have it |
|---|---|---|
| [SPEC-VERSION](meta/0x1C5L-spec-version.md) | The specification edition followed. It determines how the remaining records are read. Reject or warn on an unknown edition. The value for v1 documents is `0x0001` | Published documents. If absent, the decoder reads with the edition it knows |
| [DOC-ID](meta/0x1C7L-doc-id.md) | The document's own identifier. Required to point to this document and its contents from outside the document | Version documents under `docs/<document ID>/` and `codecs/<Codec ID>/` in `.well-known/geul/` (including specification documents). Not placed in the version list `versions.geul` or in list documents (`issuers/`) |

- `SPEC-VERSION` holds just one integer so that a decoder of any edition can read it (v1 is `1C51 0001`). It does not rely on Value codes.
- `DOC-ID` is a DOC-POINTER (Issuer, document ID, version `0`) that points to the document itself. A document ID is 4 WORDs. A Codec document has no document ID, so it uses a [CODEC-POINTER](reference/0x042L-codec-pointer.md) (Issuer, Codec ID, version `0`). Every Issuer reserves the document IDs `0x0000000000000000` and `0xFFFFFFFFFFFFFFFF` ([Issuer and publication](issuer.md#용어-정의-문서)).
- A document without `DOC-ID` is an unnamed document. It can be pointed to only by its content hash.

## Content Hash {#내용-해시}

A copy of a document is pointed to by its **content hash** (the same role as a git commit ID).

- It is the SHA-256 from the opening record (DOC-*) up to just before END. 16 WORDs.
- Verification-class Meta (signatures and so on; records with `C >= 5` in section 15, that is, `w >= 0x1E50`) is excluded from the calculation. So placing a signature inside the document creates no circularity.
- In the calculation, the length of DOC-* is replaced by the length without the verification records, and the width is also replaced by the narrowest width that fits that length. So the content hash is the same before and after attaching a signature.
- The content hash is not recorded in the document but computed. It is written as a value only when pointing to another version (`PARENT` and so on).
- `PARENT` inside a document also enters the calculation, so the content hash forms a hash chain linking the whole history.
- Meta attached later outside the document (annotations in a separate store, and so on) does not change the content hash (like git notes).
- The binary is the canonical form of a document. The content hash and signatures are computed only from the binary.

## Version {#버전}

A named document (a document with `DOC-ID`) has versions.

- The **version ID** is a 2 WORD integer numbered from 1 within one document in publication order. `0` means "version not written" and is treated as the latest version.
- The version ID is assigned by the publisher at publication. The mapping between version IDs and content hashes is kept in the version list signed by the publisher ([Publication addresses and version lists](publishing.md#버전-목록)).
- The same content is not published again. If the content hash already exists, the existing version ID is returned.
- When the 2 WORDs are used up, issue under a new document ID.
- For v2 and later, the HEAD records `PARENT` (the content hash of the previous version). Since it enters the content hash, the versions are linked in a hash chain. It is not placed in the first version.

## Revision {#개정}

GEUL documents are revised like statutes.

- **Versions are immutable.** A published version is neither changed nor deleted. The only exceptions are legal deletion and deletion by authority ([TOMBSTONE](edge/0x0BAL-tombstone.md)).
- History is not erased. A correction is issued as a new version, and the original version is not overwritten (preservation of the old statute). A rewritten version is linked to the original version with [REPLACES](meta/0x1D7L-replaces.md).
- Pointers that change, such as branch, HEAD, and reflog, are not placed in the document. They are managed outside the document (in a repository or index).
- A new version can create, revise, or delete definitions. It promises no compatibility with the previous version. A change in the definition of the same term is also a revision (example: in the Korean Civil Act, "adult" (성년) from age 20 to 19; in the Criminal Act, the object of the crime of rape from "woman" (부녀) to "person" (사람)).
- **A LOCAL ID is an identity that persists across versions** (like an article number). The same LOCAL ID points to the same object even in different versions.
  - Creation: receive a new LOCAL ID. An ID carries no order, so no insertion like "Article X-2" is needed. A new number is obtained from `NEXT-LOCAL-ID` in the version list (auto increment).
  - Revision: change the content of the same LOCAL ID.
  - Deletion: remove that LOCAL ID in the new version. **A deleted ID is not reused.**
  - Move, split, merge: receive a new LOCAL ID and attach a QUALIFIER P1365 (replaces, value is the old LOCAL ID) to the new record to link the old ID. Since the old ID is not reused, it points to that record in the previous version.
- Tools that regenerate a document from source material also follow this rule. A statement identical to the previous version gets the same LOCAL ID, and only changed or newly arisen statements get new numbers. Renumbering from 1 every time is not allowed.
- A citation specifies an edition. A citation that fixes the version is bound to that version, and a latest (version `0`) citation is bound to the version in force at the time of interpretation. A document dealing with a past event cites the version in force at that time, fixed.
- Publication and enforcement differ. The version list records the publication time, and the document records the period of enforcement.
  - [EFFECTIVE-FROM](meta/0x1C8L-effective-from.md), [EFFECTIVE-UNTIL](meta/0x1C9L-effective-until.md): the enforcement period of the whole version
  - QUALIFIER P580 (start) and P582 (end) on a provision Edge: when the enforcement date differs by provision
- **The edition in force at time T is the highest version whose enforcement date is T or earlier.** If provision-level P580 and P582 QUALIFIERs exist, they take precedence. An edition past its validity period (`EFFECTIVE-UNTIL`) is not in force.
- Rules that decide which edition applies, such as transitional provisions ("the previous provisions apply"), the law at the time of the act, and the choice of a new law favorable to the defendant, belong to the verdict ([TOULMIN](toulmin/_index.md)). The enforcement information is its material.
- Narrowing or widening the interpretation of a term by an interpretive opinion or a precedent is not a document revision but a verdict rule. Where an interpretation is fixed by legislation (example: the new definition of "one week" in the Labor Standards Act), it is a revision.
- The binary (wire) layout of a Codec and of a Codec number is not revised, because records encoded with a Codec number are read without pinning a codebook version. To change a layout, assign a new number. A deleted Codec number is not reused for another format.

## Diff Storage {#diff-저장}

A version is always defined as the whole document (a snapshot). A diff is only a format for storing and transmitting that snapshot in less space.

- Only a document that has `DOC-ID` and whose BODY consists entirely of Edges can be stored as a diff. The version list `versions.geul`, which has no `DOC-ID`, list documents (versions of `issuers/`), and unnamed documents have no diff.
- A diff document is an ordinary GEUL document and places [DELTA-BASE](meta/0x1DBL-delta-base.md) (the base version ID) in its HEAD.
- Deletion is written with [DELTA-REMOVE](meta/0x1DCL-delta-remove.md) (a list of LOCAL IDs to remove), and addition and revision are written as Edges in the BODY. There is no separate marker for addition or revision. If the Edge Id exists in the base, it is a revision; if not, it is an addition.
- Snapshot restoration must be deterministic (so that the hash matches).
  1. Restore the snapshot of the base version. If the base is also a diff, restore it recursively.
  2. Replace the HEAD wholesale with the diff's HEAD minus `DELTA-BASE` and `DELTA-REMOVE`. HEAD Edges change with it (they are not listed in `DELTA-REMOVE`).
  3. The BODY keeps the base order. Remove the IDs in `DELTA-REMOVE`, and if an Edge Id in the diff BODY exists in the base, replace it in place.
  4. Edge Ids not in the base are appended at the end in the order they appear in the diff.
  5. The content hash of the result must equal this version's hash in the version list. If not, it is invalid.
- Reusing a deleted LOCAL ID in a diff is invalid. The Edge Id of a removed HEAD Edge is also not reused.
- The content hash, version list, and signatures are all based on the restored snapshot.
