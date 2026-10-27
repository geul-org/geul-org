---
title: "PRIVACY"
weight: 83
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "PRIVACY adalah Meta kebijakan yang mencatat tingkat data pribadi dokumen dalam 1 WORD."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Mencatat tingkat data pribadi dokumen.

## Layout

```
TAG WORD          0001 1LLL L101 0010      Codec 0x52
[Length extension TAG]
Tingkat           1 WORD
```

- Codec: Meta `0x52`, kelas kebijakan (`101`)
- Payload: nilai mentah (tingkat 1 WORD)
- Jumlah: paling banyak satu

## Interpretasi dan validitas

- Tidak mengubah interpretasi. Hanya menetapkan penanganan.

## Masalah terbuka

- Tabel kode tingkat (korespondensi dengan klasifikasi undang-undang pelindungan data pribadi).
