---
title: "EXTERNAL-POINTER"
weight: 9
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "EXTERNAL-POINTER is a pointer Reference that points to a LOCAL ID in a document brought in by IMPORT-DOC in the HEAD."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXTERNAL-POINTER is a pointer Reference that points to a LOCAL ID in a document brought in by [IMPORT-DOC](/grammar/meta/import/import-doc/) in the HEAD.

## Layout

```
TAG WORD          0000 0LLL L10W WQQQ      CCCC = 10WW
[Length extension TAG]
IMPORT ID         width set by WW (00=1, 01=2, 10=4, 11=8 WORD)
Target ID         everything that remains. The LOCAL ID in the imported document, shortest width
```

| CCCC | Name | IMPORT ID width |
|---|---|---|
| `1000` | EXTERNAL-POINTER-1WORD | 1 WORD |
| `1001` | EXTERNAL-POINTER-2WORD | 2 WORD |
| `1010` | EXTERNAL-POINTER-4WORD | 4 WORD |
| `1011` | EXTERNAL-POINTER-8WORD | 8 WORD |

- Use the narrowest Codec that fits the IMPORT ID value.
- The IMPORT ID is a value assigned by this document's `IMPORT-DOC` and is valid only inside this document. EXTERNAL-POINTER does not write an Issuer. The Issuer and document ID come from that `IMPORT-DOC`. The version is also set by that `IMPORT-DOC` (pinned or latest).
- The same LOCAL ID in the imported document is the same target whether used as a LOCAL inside that document or as an EXTERNAL-POINTER here.
- A Variable is a LOCAL variable of the imported document.

## Validity

- If this document has no `IMPORT-DOC` that assigned that IMPORT ID, it is invalid.
- If the IMPORT ID fits a narrower Codec but a wider Codec is used, it is rejected as non-minimal.
- If the target ID is `0`, it is invalid. The imported document itself is pointed to with [DOC-POINTER](/grammar/reference/doc-pointer/).
- A leading `0x0000` WORD in the target ID is forbidden.

## Examples

| Target | WORD sequence |
|---|---|
| LOCAL 5 of IMPORT ID 1 | `0140 0001 0005` |
| LOCAL 65536 of IMPORT ID 1 | `01C0 0001 0001 0000` |
| LOCAL 5 of IMPORT ID 70000 | `01C8 0001 1170 0005` |

## Related Pages

- [Reference](/grammar/reference/), [LOCAL](/grammar/reference/local/), [EXTERNAL-ISSUER](/grammar/reference/external-issuer/), [DOC-POINTER](/grammar/reference/doc-pointer/)
- [IMPORT-DOC](/grammar/meta/import/import-doc/)
