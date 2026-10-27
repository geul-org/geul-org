---
title: "IEEE-DECIMAL64-DPD"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL64-DPD adalah Value 7 WORD tetap yang memuat apa adanya deretan bit interchange IEEE 754 decimal64 DPD."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL64-DPD adalah Value yang menyatakan encoding interchange IEEE 754 decimal64 DPD. Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0040` IEEE, nomor format `0x2001`, keluarga DECIMAL. Pola bit DPD dipertahankan apa adanya dan dibedakan dari BID.

## Layout

```
TAG WORD          0x0B7C  total 7 WORD
Issuer            1 WORD  0x0040 (IEEE)
Nomor format      1 WORD  0x2001
Payload           4 WORD (64 bit)  IEEE decimal64 DPD Interchange
```

## Interpretasi

- Empat WORD Payload disambung mulai dari WORD atas dan dibaca sebagai deretan bit interchange IEEE 754 decimal64 DPD.
- Pola bit dipertahankan dan tidak diinterpretasikan ulang sembarangan sebagai BID atau format exact decimal.
- Nilai khusus atau payload tidak dinormalisasi sembarangan.

## Validitas dan panjang

- Total tepat 7 WORD, yaitu jumlah TAG 1 WORD, Issuer 1 WORD, nomor format 1 WORD, dan Payload 4 WORD, dengan panjang langsung `LLLL=0110`. Tidak ada Length extension TAG, descriptor, dan padding.
- Jika Payload bukan tepat 4 WORD, ditolak.
- Validitas semantik deretan bit mengikuti aturan interchange DPD IEEE.

## Contoh

| Struktur | Penilaian |
|---|---|
| `0B7C 0040 2001` + deretan bit DPD 4 WORD | Struktur panjang kanonik |
| `0B7C 0040 2001` + 2 WORD | invalid: lebar Payload tidak sesuai |
| Nomor format `0x2004` untuk 64 bit yang sama | Format BID, bukan tipe ini |

## Dasar standar

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): menerapkan decimal coefficient encoding (DPD) pada interchange format decimal64. Tidak mengonversi secara numerik ke alternatif BID yang diizinkan IEEE, melainkan mempertahankan encoding 64 bit yang dipilih, dan hanya menambahkan TAG GEUL serta framing big-endian WORD.
