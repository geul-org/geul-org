---
title: "IEEE-DECIMAL128-DPD"
weight: 1026
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL128-DPD adalah Value yang menyatakan encoding interchange IEEE 754 decimal128 DPD."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL128-DPD adalah Value yang menyatakan encoding interchange IEEE 754 decimal128 DPD. Value `VALUE-ISSUER-2WORD`(`0x09DL`), Issuer `0x0000000D` IEEE, nomor Codec `0x00002002`, keluarga DECIMAL. Pola bit DPD dipertahankan apa adanya dan dibedakan dari BID.

## Layout {#레이아웃}

```
TAG WORD          0x09DC  total 13 WORD
Issuer            2 WORD  0x0000000D (IEEE)
Nomor Codec       2 WORD  0x00002002
Payload           8 WORD (128bit)  IEEE decimal128 DPD Interchange
```

## Interpretasi {#해석}

- Delapan WORD Payload dibaca sebagai bit string interchange IEEE 754 decimal128 DPD yang disambung mulai dari WORD teratas.
- Pola bit dipertahankan dan tidak ditafsirkan ulang secara sembarang sebagai BID atau desimal eksak.
- Nilai khusus maupun payload tidak dinormalisasi secara sembarang.

## Validitas dan panjang {#유효성과-길이}

- Totalnya tepat 13 WORD, yaitu jumlah TAG 1 WORD, Issuer 2 WORD, nomor Codec 2 WORD, dan Payload 8 WORD, dengan panjang langsung `LLLL=1100`. Tidak ada TAG ekstensi Length, descriptor, maupun padding.
- Jika Payload tidak tepat 8 WORD, nilai ditolak.
- Validitas makna bit string mengikuti aturan interchange IEEE DPD.

## Contoh {#예시}

| Struktur | Penilaian |
|---|---|
| `09DC 0000 000D 0000 2002` + bit string DPD 8 WORD | Benar |
| Total bukan 13 WORD (`LLLL=1100`) | tidak valid: tidak cocok dengan lebar Payload tetap |

## Dasar standar {#표준-근거}

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): menerapkan encoding koefisien desimal (DPD) pada format interchange decimal128. Encoding 128 bit yang dipilih dipertahankan tanpa konversi numerik ke alternatif BID yang diizinkan IEEE, dan GEUL hanya menambahkan TAG serta framing WORD big-endian.
