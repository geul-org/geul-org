---
title: "PROFILE"
weight: 18
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "PROFILE adalah Meta definisi yang menyatakan profil yang diterapkan pada dokumen sebagai teks nama dan versi."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Menyatakan profil yang diterapkan pada dokumen. Record yang sama diinterpretasikan dengan dokumen Codec yang ditetapkan profil (misalnya `tangeul-1.0` berarti [TOULMIN](/id/grammar/edge/toulmin/)).

## Layout

```
TAG WORD          0001 1LLL L001 0001      Codec 0x11
[Length extension TAG]
Payload           Value UTF8-TEXT "<nama>-<major>.<minor>"
```

- Codec: Meta `0x11`, kelas definisi (`001`)
- Payload: Value tersemat ([UTF8-TEXT](/id/grammar/value/text/utf8-text/))
- Jumlah: paling banyak satu

## Interpretasi dan validitas

- Profil dengan major berbeda ditolak. Perbedaan minor diizinkan (hanya perubahan penambahan).
- Jika tidak ada profil, dokumen dibaca hanya dengan tata bahasa dasar GEUL dan spesifikasi kode langsung.

## Contoh

- `tangeul-1.0`: `0x1B91 0x0B41 7461 6e67 6575 6c2d 312e 3000`

## Masalah terbuka

- Registri nama profil (geul.org) dan aturan penamaan.
- Apakah profil ditunjuk dengan ID dokumen (IMPORT) atau ditaruh sebagai teks.
