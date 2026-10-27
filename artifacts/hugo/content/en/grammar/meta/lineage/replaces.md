---
title: "REPLACES"
weight: 55
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "REPLACES is a lineage Meta that records the content hash of the version that was rewritten (git amend, rebase). The original version is not deleted."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Records the content hash of the version that was rewritten (git amend, rebase).

## Layout

```
TAG WORD          0001 1LLL L011 0110      Codec 0x36
[Length extension TAG]
Payload           one SHA-256-DIGEST Value (16 WORD)
```

- Codec: Meta `0x36`, lineage class (`011`)
- Payload: embedded Value ([SHA-256-DIGEST](/grammar/value/binary/sha-256-digest/))
- Count: several allowed

## Interpretation and Validity

- The original version is not deleted (the old law is preserved).
- The digest format is embedded as a Value to leave room to change the hash algorithm. For now the content hash is only SHA-256.
