---
title: "DELTA-BASE"
weight: 59
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "DELTA-BASE is a lineage Meta that marks this version file as a diff against a base version of the same document."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

A marker that this version file is not a snapshot but a **diff** against a base version of the same document (like a delta in a git packfile). The version itself is still defined as a snapshot. The content hash, version list, and signatures are all based on the snapshot restored by applying the diff ([Diff Storage](/grammar/document/#diff-storage)).

## Layout

```
TAG WORD          0001 1LLL L011 1010      Codec 0x3A
Version ID        2 WORD unsigned (the base version of the same document)
```

- Codec: Meta `0x3A`, lineage class (`011`)
- Payload: 2 WORD version ID (raw value)
- Count: at most one

## Interpretation and Validity

- Used only in documents that have a [DOC-ID](/grammar/meta/declaration/doc-id/) (documents whose versions are managed by a version list). `versions.geul`, `documents.geul`, `issuers.geul` (which do no version management) and unnamed documents are not stored as diffs.
- The base version is a published version of the same `DOC-ID` and is earlier than this version. `0` (no version) is invalid.
- The content hash of the restored snapshot must equal this version's hash in the version list ([PUBLICATION](/grammar/edge/publication/)). If it differs, this diff is invalid. So the resulting hash is not written separately in the diff.
- Only a document in which every record of the BODY is an Edge (a record with an Edge Id) can be stored as a diff, because the unit of a diff is the LOCAL ID (Edge Id).
- The snapshot restoration rules follow [Diff Storage](/grammar/document/#diff-storage). Deletion is handled by [DELTA-REMOVE](/grammar/meta/lineage/delta-remove/).
- There is no separate marker for addition or amendment. If the Edge Id in the diff BODY exists in the base it is an amendment; if not, it is an addition. An addition takes its number from [NEXT-LOCAL-ID](/grammar/meta/lineage/next-local-id/) in the version list. Reusing a deleted LOCAL ID is invalid ([Revisions](/grammar/document/#revisions)).

## Example

A diff against base version 3:

```
193A 0000 0003
```

- TAG `193A` (Meta `0x3A`, `LLLL=0010`, 3 WORDs), version ID `0000 0003`.

## Open Questions

1. Snapshot interval: after how many versions to place a full snapshot (the length of the diff chain versus the cost of restoration).
2. Whether to restrict the base version to the immediately previous version.
3. Where to store diff files: in the version file position (`<version ID>.geul`), and the relation to the content-addressed store `h/` (`h/` is looked up by the content hash of the snapshot).
