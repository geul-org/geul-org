---
title: "IEEE-DECIMAL32-BID"
weight: 1004
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL32-BID adalah Value 5 WORD tetap yang memuat apa adanya deretan bit interchange IEEE 754 decimal32 BID."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL32-BID adalah Value yang menyatakan encoding interchange IEEE 754 decimal32 BID. Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0040` IEEE, nomor format `0x2003`, keluarga DECIMAL. Pola bit BID dipertahankan apa adanya dan dibedakan dari DPD.

## Layout

```
TAG WORD          0x0A7C  total 5 WORD
Issuer            1 WORD  0x0040 (IEEE)
Nomor format      1 WORD  0x2003
Payload           2 WORD (32 bit)  IEEE decimal32 BID Interchange
```

## Interpretasi

- Dua WORD Payload disambung mulai dari WORD atas dan dibaca sebagai deretan bit interchange IEEE 754 decimal32 BID.
- Pola bit dipertahankan dan tidak diinterpretasikan ulang sembarangan sebagai DPD atau SIGNED-DECIMAL.
- Nilai khusus atau payload tidak dinormalisasi sembarangan.

## Validitas dan panjang

- Total tepat 5 WORD, yaitu jumlah TAG 1 WORD, Issuer 1 WORD, nomor format 1 WORD, dan Payload 2 WORD, dengan panjang langsung `LLLL=0100`. Tidak ada Length extension TAG, descriptor, dan padding.
- Jika Payload bukan tepat 2 WORD, ditolak.
- Validitas semantik deretan bit mengikuti aturan interchange BID IEEE.

## Contoh

| Struktur | Penilaian |
|---|---|
| `0A7C 0040 2003` + deretan bit BID 2 WORD | Struktur panjang kanonik |
| `0A7C 0040 2003` + 4 WORD | invalid: lebar Payload tidak sesuai |
| Nomor format `0x2000` untuk 32 bit yang sama | Format DPD, bukan tipe ini |

## Dasar standar

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): menerapkan binary coefficient encoding (BID) pada interchange format decimal32. Tidak mengonversi secara numerik ke alternatif DPD yang diizinkan IEEE, melainkan mempertahankan encoding 32 bit yang dipilih, dan hanya menambahkan TAG GEUL serta framing big-endian WORD.
