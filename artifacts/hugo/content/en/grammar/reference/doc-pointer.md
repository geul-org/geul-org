---
title: "DOC-POINTER"
weight: 8
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "DOC-POINTER is a pointer-declaration Reference that points to one version of a document published by an Issuer. Version ID 0 is the latest version."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DOC-POINTER is a pointer-declaration Reference that points to one version of a document published by an Issuer. It is the target of document publication, deprecation, deletion, edition citation, and statements about a document.

## Layout

```
TAG WORD          0000 0LLL L011 1QQQ      CCCC = 0111
[Length extension TAG]
Issuer            1/2/4/16 WORD
Document ID       4 WORD
Version ID        2 WORD
```

## Interpretation and Validity

- The Issuer width is what remains of the Payload after removing the 6 WORDs of document ID and version ID. The Codec does not split the width. If the width is not 1, 2, 4, or 16 WORD, or if the Issuer value fits a narrower width, it is invalid (Issuer canonical form).
- The version ID is not omitted. If omission were allowed, the Issuer width could not be determined from the Payload length alone (Issuer 4 WORD with no version and Issuer 2 WORD with a version are both 8 WORD).
- Version ID `0` is the latest version. It is bound to the current version at the time of interpretation. Any other value is pinned to that version ([PUBLICATION](/grammar/edge/publication/)).
- Document ID `0` is the Issuer's term definition index document. The Issuer itself is pointed to with [ISSUER-POINTER](/grammar/reference/issuer-pointer/).
- Only Quantifier `000` (Identified) is used. Other values are invalid.
- DOC-POINTER is the only form that points to an Issuer's document. Pointing to a document with `EXTERNAL-ISSUER-*` (Issuer, document ID, target ID `0`) or `EXTERNAL-POINTER-*` (IMPORT ID, target ID `0`) is invalid.
- Where it is used: Meta [DOC-ID](/grammar/meta/declaration/doc-id/) and [IMPORT-DOC](/grammar/meta/import/import-doc/), PUBLICATION, DEPRECATION, TOMBSTONE, and the BIND Subject in version lists, and the BIND Subject in the name index `documents.geul`.

## Example

The GEUL Issuer `0x0000`, document `0xffff000000000001`.

| Version | WORD sequence |
|---|---|
| 1 | `03B8 0000 ffff 0000 0000 0001 0000 0001` |
| Latest (`0`) | `03B8 0000 ffff 0000 0000 0001 0000 0000` |

- TAG 1 + Issuer 1 + document ID 4 + version ID 2 = 8 WORD, `LLLL=0111`. The TAG is `0000 0 0111 0111 000` = `03B8`.

## Related Pages

- [Reference](/grammar/reference/), [ISSUER-POINTER](/grammar/reference/issuer-pointer/), [EXTERNAL-ISSUER](/grammar/reference/external-issuer/), [PUBLICATION](/grammar/edge/publication/)
- [Issuer and Publication](/grammar/issuer/)
