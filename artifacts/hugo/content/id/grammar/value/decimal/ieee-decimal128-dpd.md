---
title: "IEEE-DECIMAL128-DPD"
weight: 1003
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL128-DPD adalah Value 11 WORD tetap yang memuat apa adanya deretan bit interchange IEEE 754 decimal128 DPD."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL128-DPD adalah Value yang menyatakan encoding interchange IEEE 754 decimal128 DPD. Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0040` IEEE, nomor format `0x2002`, keluarga DECIMAL. Pola bit DPD dipertahankan apa adanya dan dibedakan dari BID.

## Layout

```
TAG WORD          0x0D7C  total 11 WORD
Issuer            1 WORD  0x0040 (IEEE)
Nomor format      1 WORD  0x2002
Payload           8 WORD (128 bit)  IEEE decimal128 DPD Interchange
```

## Interpretasi

- Delapan WORD Payload disambung mulai dari WORD atas dan dibaca sebagai deretan bit interchange IEEE 754 decimal128 DPD.
- Pola bit dipertahankan dan tidak diinterpretasikan ulang sembarangan sebagai BID atau format exact decimal.
- Nilai khusus atau payload tidak dinormalisasi sembarangan.

## Validitas dan panjang

- Total tepat 11 WORD, yaitu jumlah TAG 1 WORD, Issuer 1 WORD, nomor format 1 WORD, dan Payload 8 WORD, dengan panjang langsung `LLLL=1010`. Tidak ada Length extension TAG, descriptor, dan padding.
- Jika Payload bukan tepat 8 WORD, ditolak.
- Validitas semantik deretan bit mengikuti aturan interchange DPD IEEE.

## Contoh

| Struktur | Penilaian |
|---|---|
| `0D7C 0040 2002` + deretan bit DPD 8 WORD | Kanonik |
| Total bukan 11 WORD (`LLLL=1010`) | invalid: tidak sesuai lebar Payload tetap |

## Dasar standar

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): menerapkan decimal coefficient encoding (DPD) pada interchange format decimal128. Tidak mengonversi secara numerik ke alternatif BID yang diizinkan IEEE, melainkan mempertahankan encoding 128 bit yang dipilih, dan hanya menambahkan TAG GEUL serta framing big-endian WORD.
