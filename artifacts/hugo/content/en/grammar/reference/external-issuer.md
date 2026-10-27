---
title: "EXTERNAL-ISSUER"
weight: 13
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "EXTERNAL-ISSUER is a pointer-declaration Reference that cites a LOCAL ID in a document published by an Issuer with a single record, without IMPORT."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXTERNAL-ISSUER is a pointer-declaration Reference that cites a LOCAL ID in a document published by an Issuer without IMPORT. A single record is complete in meaning, and it follows the latest version.

## Layout

```
TAG WORD          0000 0LLL L11W WQQQ      CCCC = 11WW
[Length extension TAG]
Issuer            width set by WW (00=1, 01=2, 10=4, 11=16 WORD)
Document ID       4 WORD
Target ID         everything that remains. The LOCAL ID in that document, shortest width
```

| CCCC | Name | Issuer width |
|---|---|---|
| `1100` | EXTERNAL-ISSUER-1WORD | 1 WORD (assigned by geul.org) |
| `1101` | EXTERNAL-ISSUER-2WORD | 2 WORD (registered with geul.org, domain proof) |
| `1110` | EXTERNAL-ISSUER-4WORD | 4 WORD (registered with geul.org, no proof) |
| `1111` | EXTERNAL-ISSUER-16WORD | 16 WORD (computed from a public key) |

- An Issuer ID is an integer value. The same value means the same Issuer. Write the Issuer in the shortest width that fits the value and pick the Codec of that width (2 WORD only when the value exceeds `0xFFFF`, 4 WORD only when it is `2^32` or more, 16 WORD only when it is `2^64` or more). A notation in a wider width is invalid ([Issuer](/grammar/issuer/)).
- Issuer registration and management are handled by geul.org.
- The version is not written, and it follows the latest version. To pin a version, use [IMPORT-DOC](/grammar/meta/import/import-doc/) and [EXTERNAL-POINTER](/grammar/reference/external-pointer/).
- The location is found by the publication address rules ([Publication Addresses and Version Lists](/grammar/publishing/)).
- The same LOCAL ID in that document is the same target whether used as a LOCAL inside that document, as an EXTERNAL-ISSUER in another document, or as an EXTERNAL-POINTER after IMPORT.
- It points only to a LOCAL in a document. A document itself is pointed to with [DOC-POINTER](/grammar/reference/doc-pointer/), and an Issuer itself with [ISSUER-POINTER](/grammar/reference/issuer-pointer/). So the target ID is not `0`. Document ID `0` is the Issuer's term definition index document.

## Validity

- If the Issuer width does not match the Codec, or the value fits a narrower width, it is invalid.
- If the target ID is `0`, it is invalid. Target ID `0` (the document itself) is the job of DOC-POINTER.
- A leading `0x0000` WORD in the target ID is forbidden.

## Examples

| Target | WORD sequence |
|---|---|
| Issuer `0x0001`, document `0x…0002`, LOCAL 7 | `0360 0001 0000 0000 0000 0002 0007` |
| Issuer `0x00012345`, document `0x…0002`, LOCAL 7 | `03E8 0001 2345 0000 0000 0000 0002 0007` |

## Related Pages

- [Reference](/grammar/reference/), [DOC-POINTER](/grammar/reference/doc-pointer/), [ISSUER-POINTER](/grammar/reference/issuer-pointer/), [EXTERNAL-POINTER](/grammar/reference/external-pointer/)
- [Issuer and Publication](/grammar/issuer/)
