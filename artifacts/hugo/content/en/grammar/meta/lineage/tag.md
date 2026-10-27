---
title: "TAG"
weight: 58
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "TAG is a lineage Meta that records an immutable name attached to a version (git annotated tag)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Records an immutable name attached to a version (git annotated tag).

## Layout

```
TAG WORD          0001 1LLL L011 1001      Codec 0x39
[Length extension TAG]
Name              UTF8-TEXT-* Value
Target            SHA-256-DIGEST Value, or the omission marker 0x0000 (optional field). If omitted, this version
```

- Codec: Meta `0x39`, lineage class (`011`)
- Payload: embedded Value (text + an optional content hash)
- Count: several allowed

## Interpretation and Validity

- The name is [UTF8-TEXT](/grammar/value/text/utf8-text/), and the target is [SHA-256-DIGEST](/grammar/value/binary/sha-256-digest/).
- If the target is omitted (ABSENT `0x0000`, [CODEC](/grammar/edge/codec/) optional field), the name is attached to this document itself. A document cannot write its own content hash inside itself. The geul.org specification `0x1839` has two record fields: name (`0840`, `0841`) and target (`0861`, `0000`).
- The same name is not reused for another version.

## Example

- Name `v1`, this version: `19B9 08C0 7631 0000`

## Open Questions

- Whether TAG is needed even though version IDs (sequence numbers) exist, and how its role differs from the document name (`BIND`).
