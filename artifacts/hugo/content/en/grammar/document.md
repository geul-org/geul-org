---
title: "Document"
weight: 30
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "document", "version", "hash"]
summary: "The unit of GEUL data is the document. A document is opened with a declared length and closed with END, and is divided into a HEAD (Meta and the source of the whole document) and a BODY (Reference, Value, Edge). Each version is pinned by a content hash."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

The unit of GEUL data is one document (DOC). One file (`.geul`, media type `application/vnd.geul`) is one document.

## Structure

```
DOC-*            ← opens the document (total length)
  Meta …         ← HEAD: records about the document
  SOURCE …       ←   (the source of the whole document and its QUALIFIERs)
BODY             ← ends the HEAD and opens the BODY
  Reference, Value, Edge …
END              ← closes the document
```

| Record | TAG | Meaning |
|---|---|---|
| DOC-1WORD | `1880` + 1 WORD | Opens the document with the total length given in 1 WORD |
| DOC-2WORD | `1901` + 2 WORD | Total length in 2 WORDs |
| DOC-4WORD | `1A02` + 4 WORD | Total length in 4 WORDs |
| BODY | `180E` | 1 WORD. Ends the HEAD and starts the BODY |
| END | `180F` | 1 WORD. Closes the document |

- The value of DOC-* is the total WORD count from the start of the opening record to the end of END. Use the narrowest width that holds the value.
- END is required. If the position of END does not match the length in DOC-*, reject the document. If the input ends without END, the document is truncated.
- A decoder can skip the whole document at once using the length in DOC-*.
- There is no way to open a document without knowing its length. Real-time data whose end cannot be known in advance is cut into units of known length and sent as several documents.
- If the HEAD is empty, the BODY record is omitted. A document with no BODY record is all BODY. The BODY record appears only once. If the HEAD has even one record (a Meta or a HEAD Edge), the BODY record is placed.
- Documents are not nested. Another document is pointed to with [IMPORT](/grammar/meta/) or a pointer Reference.

## HEAD and BODY

- The HEAD holds only two kinds of record: Meta and **HEAD Edges**. Both are statements about the **document** that contains them.
  - Meta: the document's structure, definitions, provenance, lineage, verification, policy, and IMPORT.
  - HEAD Edge: the evidence Edge [SOURCE](/grammar/edge/source/#source-of-the-whole-document) (Target `0`) that writes the source of the whole document, and the [QUALIFIER](/grammar/edge/qualifier/)s that have that SOURCE as their Target (source hash, time received, range within the source, and so on). A QUALIFIER is placed after its SOURCE.
- The BODY holds only Reference, Value, and Edge. The origin of an individual record is written with the evidence Edge [SOURCE](/grammar/edge/source/) inside the BODY, and other evidence such as confidence is written as a QUALIFIER attached to that record. A SOURCE with Target `0`, and a QUALIFIER whose Target is a HEAD SOURCE, cannot be placed in the BODY.
- A decoder reads the HEAD from the front and separates the two as it goes. A Meta is HEAD. A SOURCE with Target `0` is HEAD, and the decoder remembers its Edge Id. A QUALIFIER whose Target is a remembered SOURCE is HEAD. When any other record arrives: if the HEAD is empty, the BODY record was omitted (the BODY starts from that record); otherwise the BODY record is missing and the document is invalid.
- **The HEAD and the BODY share one Edge Id number space.** An Edge Id is unique within the document and, like an Edge in the BODY, is taken from [NEXT-LOCAL-ID](/grammar/meta/lineage/next-local-id/). If the Origin of a HEAD Edge is a LOCAL, its definition is placed in the BODY (a LOCAL is scoped to the whole document).
- A Meta may carry a Value record inside its Payload. A carried Value is not an independent record but part of that Meta.
- The scope of a declaration (the Meta declaration class) is that document.

## Basic Declarations

Each of the two declarations appears at most once. The conditions below determine which documents must have them.

| Meta | Meaning | Documents that must have it |
|---|---|---|
| [SPEC-VERSION](/grammar/meta/declaration/spec-version/) | The spec version followed. It determines how to read the remaining records. If the version is unknown, reject or warn. The value for a v1 document is `0x0001` | Published documents. If absent, the document is read as the version the decoder knows |
| [DOC-ID](/grammar/meta/declaration/doc-id/) | The document's own identifier. Required to point to this document and the targets inside it from outside the document | Documents under `.well-known/geul/` whose names start with `0x` (version documents, specification documents). Not placed in version lists or name indexes |

- `SPEC-VERSION` holds just one integer so that a decoder of any version can read it (`1890 0001` for v1). It does not depend on Value codes.
- `DOC-ID` is a DOC-POINTER that points to the document itself (Issuer, document ID, version `0`). The document ID is 4 WORDs.
- A document without `DOC-ID` is an unnamed document. It can be pointed to only by its content hash.

## Content Hash

A document is pointed to by its **content hash** (the same role as a commit ID in git).

- It is the SHA-256 from the opening record (DOC-*) up to just before END. 16 WORDs.
- Meta of the verification class (signatures and so on) is left out of the calculation. So placing a signature inside the document creates no cycle.
- When calculating, the length in DOC-* is replaced with the length excluding the verification records, and the width is replaced with the narrowest width that fits that length. So the content hash is the same before and after a signature is attached.
- The content hash is not recorded in the document; it is calculated. It is written as a value only when pointing to another version (`PARENT` and so on).
- A `PARENT` inside the document is also part of the calculation, so the content hash becomes a hash chain linking the whole history.
- Meta attached later from outside the document (annotations in a separate store and so on) does not change the content hash (the same as git notes).
- The binary is the canonical form of a document. The content hash and signatures are calculated only from the binary.

## Versions

A named document (a document with `DOC-ID`) has versions.

- The **version ID** is a 2 WORD integer assigned within one document, starting at 1 in the order of publication. `0` means "version not written" and is treated as the latest version.
- The version ID is assigned by the publisher at publication. The mapping between version IDs and content hashes is kept in the version list signed by the publisher ([Publication Addresses and Version Lists](/grammar/publishing/#version-lists)).
- The same content is not published again. If the content hash already exists, its version ID is returned.
- When the 2 WORDs are used up, publish under a new document ID.
- From v2 on, a version writes `PARENT` (the content hash of the previous version) in its HEAD. Since it goes into the content hash, the versions are linked in a hash chain. The first version does not have it.

## Revisions

GEUL documents are revised like statutes.

- **A version is immutable.** A published version is neither changed nor deleted. The only exceptions are legal deletion and deletion by authority ([TOMBSTONE](/grammar/edge/publication/)).
- History is not erased. A correction is issued as a new version and does not overwrite the original (the old law is preserved). A rewritten version is linked to the original version by [REPLACES](/grammar/meta/lineage/replaces/).
- Pointers that change, such as a branch, HEAD, or reflog, are not placed in the document. They are managed outside the document (in a repository or index).
- A new version may add, revise, or delete definitions. It does not promise compatibility with earlier versions. A change in the definition of the same term is also a revision (for example, the Korean Civil Code "adult" changed from age 20 to 19, and the object of the rape offense in the Korean Criminal Act changed from "woman" to "person").
- **A LOCAL ID is an identity that persists across versions** (like an article number). The same LOCAL ID points to the same target even in different versions.
  - Addition: a new LOCAL ID is taken. An ID has no ordering meaning, so insertions like "Article X-2" are unnecessary. The new number is taken from `NEXT-LOCAL-ID` in the version list (auto increment).
  - Amendment: the content of the same LOCAL ID is changed.
  - Deletion: that LOCAL ID is removed from the new version. **A deleted ID is never reused.**
  - Move, split, merge: a new LOCAL ID is taken, and QUALIFIER P1365 (replaces, the value is the old LOCAL ID) is attached to the new record to link the old ID. Since the old ID is never reused, it points to that record in the previous version.
- A tool that rebuilds a document from source material also follows this rule. A statement that is the same as in the previous version gets the same LOCAL ID, and only statements that changed or are new get new numbers. The numbers must not be reassigned from 1 each time.
- A citation specifies an edition. A citation that pins a version is bound to that version, and a citation to the latest (version `0`) is bound to the version in force at the time of interpretation. A document about past events cites the version that was in force at that time, pinned.
- Publication and entry into force are different. The publication time is written by the version list, and the period in force is written by the document.
  - [EFFECTIVE-FROM](/grammar/meta/declaration/effective-from/), [EFFECTIVE-UNTIL](/grammar/meta/declaration/effective-until/): the period in force for the whole version
  - QUALIFIER P580 (start) and P582 (end) on an article's Edge: when the date in force differs article by article
- **The edition in force at time T is the highest version whose date in force is T or earlier.** If an article has P580 or P582 QUALIFIERs, they take precedence. An edition whose period of validity (`EFFECTIVE-UNTIL`) has passed is not in force.
- Rules that decide which edition applies, such as transitional provisions ("the former provisions apply") and the choice between the law at the time of the act and a newer law more favorable to the defendant, are the job of judgment ([TOULMIN](/grammar/edge/toulmin/)). The in-force information is its material.
- When an interpretive ruling or a court precedent narrows or widens the interpretation of a term, that is a judgment rule, not a document revision. When the interpretation is fixed by legislation (for example, the new definition of "1 week" in the Labor Standards Act), it is a revision.
- The binary (wire) layout of a Codec and format number is not revised. A record encoded with a format number can be read without pinning a codebook version. To change a layout, assign a new number. A deleted format number is not reused for another format.

## Diff Storage

A version is always defined as a whole document (a snapshot). A diff is only a format for storing and transmitting that snapshot in less space.

- Only a document that has `DOC-ID` and whose BODY is all Edges can be stored as a diff. `versions.geul`, `documents.geul`, `issuers.geul` (which do no version management), and unnamed documents are not stored as diffs.
- A diff document is an ordinary GEUL document and carries [DELTA-BASE](/grammar/meta/lineage/delta-base/) (the base version ID) in its HEAD.
- Deletions are written with [DELTA-REMOVE](/grammar/meta/lineage/delta-remove/) (a list of LOCAL IDs to remove), and additions and amendments are written as Edges in the BODY. There is no separate marker for addition or amendment. If the Edge Id exists in the base it is an amendment; if not, it is an addition.
- Restoring the snapshot must be deterministic (otherwise the hash will not match).
  1. Restore the snapshot of the base version. If the base is also a diff, restore it recursively.
  2. The HEAD is replaced wholesale with the diff's HEAD minus `DELTA-BASE` and `DELTA-REMOVE`. HEAD Edges change with it (they are not listed in `DELTA-REMOVE`).
  3. The BODY keeps the base order. IDs in `DELTA-REMOVE` are removed, and if an Edge Id in the diff BODY exists in the base, it replaces that one in place.
  4. Edge Ids not in the base are appended at the end in the order they appear in the diff.
  5. The content hash of the result must equal this version's hash in the version list. If it differs, the diff is invalid.
- Reusing a deleted LOCAL ID in a diff is invalid. The Edge Id of a HEAD Edge that was dropped is not reused either.
- The content hash, version list, and signatures are all based on the restored snapshot.
