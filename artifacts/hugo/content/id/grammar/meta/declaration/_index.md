---
title: "Meta — Definisi"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "Kelas definisi Meta (3 bit atas `001`, `0x10`~`0x1F`) adalah deklarasi interpretasi. Menetapkan edisi spesifikasi, profil, ID dokumen, masa berlaku, dan bahasa default."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Kelas definisi Meta (3 bit atas `001`, Codec `0x10`~`0x1F`) adalah deklarasi interpretasi. Karena deklarasi mengubah aturan interpretasi, semua decoder harus memprosesnya. Cakupan deklarasi adalah dokumen itu.

- `SPEC-VERSION` menentukan cara membaca record lainnya, sehingga hanya berisi bilangan bulat tanpa Value tersemat. GEUL v1 adalah `0x0001` (record `1890 0001`).
- `DOC-ID` adalah `DOC-POINTER` (Issuer, ID dokumen, versi `0`) yang menunjuk dokumen itu sendiri. Jika tidak ada, itu dokumen tanpa nama dan hanya dapat ditunjuk dengan hash isi.
- Nama untuk alamat dokumen tidak ditaruh sebagai Meta. Indeks nama Issuer `documents.geul` menempelkannya dengan pernyataan `BIND`, dan judul yang dibaca manusia ditempelkan dengan `LABEL` ([alamat publikasi dan daftar versi](/id/grammar/publishing/#nama-dokumen)).
