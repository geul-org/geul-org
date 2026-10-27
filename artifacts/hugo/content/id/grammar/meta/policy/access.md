---
title: "ACCESS"
weight: 82
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "ACCESS adalah Meta kebijakan yang mencatat cakupan publikasi dokumen (publik, internal, rahasia) sebagai tingkat 1 WORD."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Mencatat cakupan publikasi dokumen.

## Layout

```
TAG WORD          0001 1LLL L101 0001      Codec 0x51
[Length extension TAG]
Tingkat           1 WORD (0 publik, 1 internal, 2 rahasia, lainnya dicadangkan)
```

- Codec: Meta `0x51`, kelas kebijakan (`101`)
- Payload: nilai mentah (tingkat 1 WORD)
- Jumlah: paling banyak satu

## Interpretasi dan validitas

- Dokumen rahasia tidak diterbitkan ([Issuer](/id/grammar/issuer/)).
- Tidak mengubah interpretasi. Hanya menetapkan penanganan.

## Masalah terbuka

- Tabel kode tingkat.
