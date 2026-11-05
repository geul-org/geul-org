---
title: "IEEE-DECIMAL32-BID"
weight: 1027
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL32-BID adalah Value yang menyatakan encoding interchange IEEE 754 decimal32 BID."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL32-BID adalah Value yang menyatakan encoding interchange IEEE 754 decimal32 BID. Value `VALUE-ISSUER-2WORD`(`0x09DL`), Issuer `0x0000000D` IEEE, nomor Codec `0x00002003`, keluarga DECIMAL. Pola bit BID dipertahankan apa adanya dan dibedakan dari DPD.

## Layout {#레이아웃}

```
TAG WORD          0x09D6  total 7 WORD
Issuer            2 WORD  0x0000000D (IEEE)
Nomor Codec       2 WORD  0x00002003
Payload           2 WORD (32bit)  IEEE decimal32 BID Interchange
```

## Interpretasi {#해석}

- Dua WORD Payload dibaca sebagai bit string interchange IEEE 754 decimal32 BID yang disambung mulai dari WORD teratas.
- Pola bit dipertahankan dan tidak ditafsirkan ulang secara sembarang sebagai DPD atau SIGNED-DECIMAL.
- Nilai khusus maupun payload tidak dinormalisasi secara sembarang.

## Validitas dan panjang {#유효성과-길이}

- Totalnya tepat 7 WORD, yaitu jumlah TAG 1 WORD, Issuer 2 WORD, nomor Codec 2 WORD, dan Payload 2 WORD, dengan panjang langsung `LLLL=0110`. Tidak ada TAG ekstensi Length, descriptor, maupun padding.
- Jika Payload tidak tepat 2 WORD, nilai ditolak.
- Validitas makna bit string mengikuti aturan interchange IEEE BID.

## Contoh {#예시}

| Struktur | Penilaian |
|---|---|
| `09D6 0000 000D 0000 2003` + bit string BID 2 WORD | struktur panjang yang benar |
| `09D6 0000 000D 0000 2003` + 4 WORD | tidak valid: lebar Payload tidak cocok |
| 32 bit yang sama dengan nomor Codec `0x00002000` | format DPD dan bukan tipe ini |

## Dasar standar {#표준-근거}

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): menerapkan encoding koefisien biner (BID) pada format interchange decimal32. Encoding 32 bit yang dipilih dipertahankan tanpa konversi numerik ke alternatif DPD yang diizinkan IEEE, dan GEUL hanya menambahkan TAG serta framing WORD big-endian.
