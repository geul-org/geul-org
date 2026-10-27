---
title: "REVERTS"
weight: 54
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "REVERTS is a lineage Meta that records the content hash of the version whose change was reverted (git revert)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Records the content hash of the version whose change was reverted (git revert).

## Layout

```
TAG WORD          0001 1LLL L011 0101      Codec 0x35
[Length extension TAG]
Payload           one SHA-256-DIGEST Value (16 WORD)
```

- Codec: Meta `0x35`, lineage class (`011`)
- Payload: embedded Value ([SHA-256-DIGEST](/grammar/value/binary/sha-256-digest/))
- Count: several allowed

## Interpretation and Validity

- The digest format is embedded as a Value to leave room to change the hash algorithm. For now the content hash is only SHA-256.
