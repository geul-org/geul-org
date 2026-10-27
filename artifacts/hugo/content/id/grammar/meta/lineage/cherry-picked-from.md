---
title: "CHERRY-PICKED-FROM"
weight: 53
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "CHERRY-PICKED-FROM adalah Meta silsilah yang mencatat hash isi versi asal tempat perubahan diambil dari silsilah lain (git cherry-pick -x)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Mencatat hash isi versi asal yang perubahannya diambil dari silsilah lain (git cherry-pick `-x`).

## Layout

```
TAG WORD          0001 1LLL L011 0100      Codec 0x34
[Length extension TAG]
Payload           satu Value SHA-256-DIGEST (16 WORD)
```

- Codec: Meta `0x34`, kelas silsilah (`011`)
- Payload: Value tersemat ([SHA-256-DIGEST](/id/grammar/value/binary/sha-256-digest/))
- Jumlah: boleh lebih dari satu

## Interpretasi dan validitas

- Format digest disematkan sebagai Value agar algoritma hash dapat diganti. Saat ini hash isi hanya SHA-256.
