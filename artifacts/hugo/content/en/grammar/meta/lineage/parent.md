---
title: "PARENT"
weight: 49
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "PARENT is a lineage Meta that records the content hash of the previous version (git parent). Several means a merge."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Records the content hash of the previous version (git parent).

## Layout

```
TAG WORD          0001 1LLL L011 0000      Codec 0x30
[Length extension TAG]
Payload           one SHA-256-DIGEST Value (16 WORD)
```

- Codec: Meta `0x30`, lineage class (`011`)
- Payload: embedded Value ([SHA-256-DIGEST](/grammar/value/binary/sha-256-digest/))
- Count: several allowed (merge)

## Interpretation and Validity

- If absent, it is the first version; if several, it is a merge (git merge commit).
- It goes into the [content hash](/grammar/document/#content-hash), so the whole history becomes a hash chain.
- The version list document points to the previous list document ([PUBLICATION](/grammar/edge/publication/)).
- The digest format is embedded as a Value to leave room to change the hash algorithm. For now the content hash is only SHA-256.

## Example

- `0x1F30 0x0014 0x0F61 0x0012 <16 WORD>` (Meta 20 WORDs = TAG + Length extension + embedded Value 18 WORDs)
