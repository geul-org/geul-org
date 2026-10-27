---
title: "Value — Waktu"
weight: 30
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "Format tanggal·waktu keluarga TIME (Codec `0x20`~`0x3F`, nomor format `0x4000`~`0x7FFF`): tanggal kalender Gregorian, timestamp, waktu berlalu, EDTF, tanggal GEDCOM."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Keluarga TIME adalah format tanggal dan waktu. Ditaruh pada kode langsung `0x20`~`0x3F` dan nomor format Issuer `0x4000`~`0x7FFF`.

| Presisi | Format |
|---|---|
| Tanggal (kalender Gregorian) | GREGORIAN-DATE |
| Tahun·bulan, tidak pasti, interval | EDTF |
| Notasi asli kalender lain (Julian, dan lain-lain) | GEDCOM-DATE |
| Waktu | Timestamp POSIX·TAI·GPS |
| Waktu berlalu | DURATION-SECONDS, DURATION-NANOSECONDS |

- Tanggal yang dapat ditulis sebagai GREGORIAN-DATE tidak ditulis sebagai EDTF.
- Timestamp nanodetik serta format TAI·GPS adalah format di bawah Issuer lembaga standar masing-masing (IEEE, BIPM, GPS).
