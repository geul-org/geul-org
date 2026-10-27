---
title: "Meta — Asal-usul"
weight: 30
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "Kelas asal-usul Meta (3 bit atas `010`, `0x20`~`0x2F`) mencatat siapa yang membuat dan merekam dokumen, serta kapan. Materi sumber ditulis dengan Edge dasar SOURCE."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Kelas asal-usul Meta (3 bit atas `010`, Codec `0x20`~`0x2F`) mencatat siapa yang membuat dan merekam dokumen, serta kapan.

- Penulis, perekam, dan waktunya mengikuti model author dan committer git (`AUTHOR`·`CREATED-AT`, `RECORDED-BY`·`RECORDED-AT`).
- Menghapus asal-usul tidak mengubah isi pernyataan. Hanya bahan untuk menilai kepercayaan yang hilang.
- Materi sumber tidak ada di kelas ini. Sumber seluruh dokumen ditulis di HEAD, dan sumber setiap record di BODY, sebagai Edge dasar [SOURCE](/id/grammar/edge/source/). Rentang padanan di dalam teks asli, waktu perolehan, dan hash teks asli adalah QUALIFIER yang menempel pada SOURCE itu (halaman P304·bagian P958, tanggal akses P813, checksum P4092).
- Jika sifat yang menempel pada sumber (rentang teks asli, waktu perolehan) ditaruh sebagai Meta, tidak dapat ditentukan milik sumber yang mana saat sumbernya banyak. Karena itu ditulis sebagai QUALIFIER yang Target-nya SOURCE. Codec `0x26`~`0x2F` adalah cadangan.
