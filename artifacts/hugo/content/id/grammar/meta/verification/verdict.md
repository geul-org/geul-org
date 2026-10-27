---
title: "VERDICT"
weight: 69
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "VERDICT adalah Meta verifikasi yang mencatat hasil putusan seluruh dokumen (Pass, Review, Fail) dalam 1 WORD."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Mencatat hasil putusan seluruh dokumen. Putusan pada tingkat node dan record ditangani oleh [TOULMIN](/id/grammar/edge/toulmin/) `VERDICT` (Edge `0x78`).

## Layout

```
TAG WORD          0001 1LLL L100 0100      Codec 0x44
[Length extension TAG]
Putusan           1 WORD (0 Pass, 1 Review, 2 Fail)
```

- Codec: Meta `0x44`, kelas verifikasi (`100`)
- Payload: nilai mentah (putusan 1 WORD)
- Jumlah: paling banyak satu

## Interpretasi dan validitas

- Karena kelas verifikasi, dikeluarkan dari hash isi.
- Putusan atas dokumen lain ditaruh di BODY dokumen yang berbeda dari target putusan.

## Masalah terbuka

- Apakah pelaku putusan dan dasarnya dicatat bersamanya.
