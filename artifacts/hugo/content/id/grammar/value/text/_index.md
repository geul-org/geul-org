---
title: "Value — Teks"
weight: 40
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "Format keluarga TEXT (Codec `0x40`~`0x5F`, nomor format `0x8000`~`0xBFFF`): teks UTF-8, teks dengan bahasa, URI, kode bahasa."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Keluarga TEXT adalah format teks dan pengenal string. Ditaruh pada kode langsung `0x40`~`0x5F` dan nomor format Issuer `0x8000`~`0xBFFF`.

- String tanpa bahasa adalah UTF8-TEXT, dan teks dengan bahasa seperti nama·judul·kalimat adalah UTF8-LANGUAGE-TEXT.
- Kode bahasa (LANGUAGE-SHORT-CODE, LANGUAGE-BCP47-CODE) juga keluarga TEXT.
- Deretan byte panjang variabel ditaruh sebagai pasangan Codec genap·ganjil. Jika bit paling tidak signifikan `1`, jumlah byte ganjil dan byte bawah WORD terakhir adalah padding `0x00` ([Record dan TAG WORD](/id/grammar/record/)).
