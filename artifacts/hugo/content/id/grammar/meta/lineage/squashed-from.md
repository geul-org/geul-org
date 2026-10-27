---
title: "SQUASHED-FROM"
weight: 56
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "SQUASHED-FROM adalah Meta silsilah yang mencatat hash isi versi-versi asal yang digabung menjadi satu (git squash)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Mencatat hash isi versi-versi asal yang digabung menjadi satu (git squash).

## Layout

```
TAG WORD          0001 1LLL L011 0111      Codec 0x37
[Length extension TAG]
Payload           satu Value SHA-256-DIGEST (16 WORD)
```

- Codec: Meta `0x37`, kelas silsilah (`011`)
- Payload: Value tersemat ([SHA-256-DIGEST](/id/grammar/value/binary/sha-256-digest/))
- Jumlah: boleh lebih dari satu (satu untuk setiap versi asal)

## Interpretasi dan validitas

- Format digest disematkan sebagai Value agar algoritma hash dapat diganti. Saat ini hash isi hanya SHA-256.
