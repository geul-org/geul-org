---
title: "SQUASHED-FROM"
weight: 56
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "SQUASHED-FROM is a lineage Meta that records the content hashes of the original versions merged into one (git squash)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Records the content hashes of the original versions merged into one (git squash).

## Layout

```
TAG WORD          0001 1LLL L011 0111      Codec 0x37
[Length extension TAG]
Payload           one SHA-256-DIGEST Value (16 WORD)
```

- Codec: Meta `0x37`, lineage class (`011`)
- Payload: embedded Value ([SHA-256-DIGEST](/grammar/value/binary/sha-256-digest/))
- Count: several allowed (one per original version)

## Interpretation and Validity

- The digest format is embedded as a Value to leave room to change the hash algorithm. For now the content hash is only SHA-256.
