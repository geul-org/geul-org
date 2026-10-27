---
title: "Meta — Silsilah"
weight: 40
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Kelas silsilah Meta (3 bit atas `011`, `0x30`~`0x3F`) mencatat dari mana dan bagaimana sebuah dokumen dihasilkan, dengan model commit git."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Kelas silsilah Meta (3 bit atas `011`, Codec `0x30`~`0x3F`) mencatat dari mana dan bagaimana sebuah dokumen dihasilkan. Silsilah mengikuti model commit git, dan satuan yang setara dengan commit adalah dokumen.

- **Hash isi** menunjuk isi satu salinan dokumen (git commit id). Ini adalah SHA-256 dari record pembuka (`DOC-*`) sampai tepat sebelum `END`, dan record kelas verifikasi (`100`) dikeluarkan dari perhitungan.
- **ID versi** adalah bilangan bulat 2 WORD yang diberi nomor mulai dari 1 menurut urutan publikasi di dalam dokumen bernama. `0` berarti versi tidak dicatat.
- Meta silsilah menunjuk versi dengan hash isi. `PARENT` di dalam dokumen juga masuk ke hash, sehingga hash isi menjadi rantai hash yang menyambung seluruh riwayat.
- Riwayat tidak dihapus. Perbaikan diterbitkan sebagai versi baru. Pointer yang berubah seperti branch tidak ditaruh di dokumen.
- `DELTA-BASE` dan `DELTA-REMOVE` adalah format yang menyimpan versi sebagai diff terhadap versi dasar. Versi selalu didefinisikan sebagai snapshot.

Aturan revisi ada di [Dokumen](/id/grammar/document/).
