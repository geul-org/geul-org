---
title: "Meta — Verifikasi"
weight: 50
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "Kelas verifikasi Meta (3 bit atas `100`, `0x40`~`0x4F`) mencatat bahan untuk menilai apakah dokumen dapat dipercaya (kunci publik, tanda tangan, tingkat kepercayaan, putusan)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Kelas verifikasi Meta (3 bit atas `100`, Codec `0x40`~`0x4F`) mencatat bahan untuk menilai apakah dokumen dapat dipercaya. Isinya kunci publik Issuer yang menerbitkan sendiri, tanda tangan, konfirmasi hak kontribusi, tingkat kepercayaan, dan hasil putusan seluruh dokumen.

- Kelas verifikasi dikeluarkan dari perhitungan hash isi. Karena itu hash isi tidak berubah walaupun tanda tangan ditaruh di dalam dokumen atau ditambah beberapa kali (sama dengan `gpgsig` git).
- Kelas dapat diketahui dari 3 bit atas Codec, sehingga hash dapat dihitung tanpa codebook.
- Putusan pada tingkat node dan record ditangani oleh Edge [TOULMIN](/id/grammar/edge/toulmin/) `VERDICT` (`0x78`).
