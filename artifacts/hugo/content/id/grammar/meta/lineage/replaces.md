---
title: "REPLACES"
weight: 55
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "REPLACES adalah Meta silsilah yang mencatat hash isi versi target yang ditulis ulang (git amend·rebase). Versi asal tidak dihapus."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Mencatat hash isi versi target yang ditulis ulang (git amend·rebase).

## Layout

```
TAG WORD          0001 1LLL L011 0110      Codec 0x36
[Length extension TAG]
Payload           satu Value SHA-256-DIGEST (16 WORD)
```

- Codec: Meta `0x36`, kelas silsilah (`011`)
- Payload: Value tersemat ([SHA-256-DIGEST](/id/grammar/value/binary/sha-256-digest/))
- Jumlah: boleh lebih dari satu

## Interpretasi dan validitas

- Versi asal tidak dihapus (versi lama dipertahankan).
- Format digest disematkan sebagai Value agar algoritma hash dapat diganti. Saat ini hash isi hanya SHA-256.
