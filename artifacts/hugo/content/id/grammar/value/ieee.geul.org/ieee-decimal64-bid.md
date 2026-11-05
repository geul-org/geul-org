---
title: "IEEE-DECIMAL64-BID"
weight: 1029
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL64-BID adalah Value yang menyatakan encoding interchange IEEE 754 decimal64 BID."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL64-BID adalah Value yang menyatakan encoding interchange IEEE 754 decimal64 BID. Value `VALUE-ISSUER-2WORD`(`0x09DL`), Issuer `0x0000000D` IEEE, nomor Codec `0x00002004`, keluarga DECIMAL. Pola bit BID dipertahankan apa adanya dan dibedakan dari DPD.

## Layout {#레이아웃}

```
TAG WORD          0x09D8  total 9 WORD
Issuer            2 WORD  0x0000000D (IEEE)
Nomor Codec       2 WORD  0x00002004
Payload           4 WORD (64bit)  IEEE decimal64 BID Interchange
```

## Interpretasi {#해석}

- Empat WORD Payload dibaca sebagai bit string interchange IEEE 754 decimal64 BID yang disambung mulai dari WORD teratas.
- Pola bit dipertahankan dan tidak ditafsirkan ulang secara sembarang sebagai DPD atau desimal eksak.
- Nilai khusus maupun payload tidak dinormalisasi secara sembarang.

## Validitas dan panjang {#유효성과-길이}

- Totalnya tepat 9 WORD, yaitu jumlah TAG 1 WORD, Issuer 2 WORD, nomor Codec 2 WORD, dan Payload 4 WORD, dengan panjang langsung `LLLL=1000`. Tidak ada TAG ekstensi Length, descriptor, maupun padding.
- Jika Payload tidak tepat 4 WORD, nilai ditolak.
- Validitas makna bit string mengikuti aturan interchange IEEE BID.

## Contoh {#예시}

| Struktur | Penilaian |
|---|---|
| `09D8 0000 000D 0000 2004` + bit string BID 4 WORD | struktur panjang yang benar |
| `09D8 0000 000D 0000 2004` + 8 WORD | tidak valid: lebar Payload tidak cocok |
| 64 bit yang sama dengan nomor Codec `0x00002001` | format DPD dan bukan tipe ini |

## Dasar standar {#표준-근거}

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): menerapkan encoding koefisien biner (BID) pada format interchange decimal64. Encoding 64 bit yang dipilih dipertahankan tanpa konversi numerik ke alternatif DPD yang diizinkan IEEE, dan GEUL hanya menambahkan TAG serta framing WORD big-endian.
