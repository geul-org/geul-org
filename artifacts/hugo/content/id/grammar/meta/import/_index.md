---
title: "Meta — IMPORT"
weight: 70
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "import"]
summary: "Kelas IMPORT Meta (3 bit atas `110`, `0x60`~`0x6F`) mengimpor dokumen eksternal dengan IMPORT ID."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Kelas IMPORT Meta (3 bit atas `110`, Codec `0x60`~`0x6F`) mengimpor dokumen eksternal dengan IMPORT ID. Codec-nya hanya satu, `IMPORT-DOC` (`0x60`).

- IMPORT hanya mengimpor dokumen. Target di dalam dokumen yang diimpor ditunjuk dengan Reference `EXTERNAL-POINTER-*` (IMPORT ID, LOCAL ID) di BODY ([Reference](/id/grammar/reference/)).
- Jika ID versi ditulis, terikat pada edisi itu; jika `0`, terikat pada edisi terbaru pada saat interpretasi. Dokumen terbitan menulis versi.
- HEAD dokumen yang diimpor tidak ikut diimpor. Record Reference·Value tidak diimpor, melainkan disalin.
