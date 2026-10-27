---
title: "PARENT"
weight: 49
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "PARENT adalah Meta silsilah yang mencatat hash isi versi sebelumnya (git parent). Jika ada beberapa, itu merge."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Mencatat hash isi versi sebelumnya (git parent).

## Layout

```
TAG WORD          0001 1LLL L011 0000      Codec 0x30
[Length extension TAG]
Payload           satu Value SHA-256-DIGEST (16 WORD)
```

- Codec: Meta `0x30`, kelas silsilah (`011`)
- Payload: Value tersemat ([SHA-256-DIGEST](/id/grammar/value/binary/sha-256-digest/))
- Jumlah: boleh lebih dari satu (merge)

## Interpretasi dan validitas

- Jika tidak ada, itu versi pertama; jika ada beberapa, itu merge (git merge commit).
- Karena masuk ke [hash isi](/id/grammar/document/#hash-isi), seluruh riwayat menjadi rantai hash.
- Dokumen daftar versi menunjuk dokumen daftar sebelumnya ([PUBLICATION](/id/grammar/edge/publication/)).
- Format digest disematkan sebagai Value agar algoritma hash dapat diganti. Saat ini hash isi hanya SHA-256.

## Contoh

- `0x1F30 0x0014 0x0F61 0x0012 <16 WORD>` (Meta 20 WORD = TAG + Length extension + Value tersemat 18 WORD)
