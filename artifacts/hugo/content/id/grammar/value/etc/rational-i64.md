---
title: "RATIONAL-I64"
weight: 1003
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "RATIONAL-I64 adalah format Issuer ADHOC 11 WORD tetap yang memuat bilangan rasional sebagai pecahan tak tereduksi dari pembilang int64 dan penyebut int64 positif."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

RATIONAL-I64 adalah Value yang menyatakan bilangan rasional sebagai pecahan tak tereduksi dari numerator int64 big-endian dan denominator int64. Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, nomor format `0x0702`, keluarga NUMERIC.

## Layout

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  total 11 WORD
Issuer            1 WORD  0x0001 (ADHOC)
Nomor format      1 WORD  0x0702
Payload           [numerator int64: 4 WORD][denominator int64: 4 WORD]
```

## Interpretasi dan validitas

- Setiap int64 adalah bilangan bulat komplemen 2 berlebar tetap yang disambung mulai dari WORD atas, dan nilainya adalah `numerator / denominator`.
- Tidak ada padding ABI.
- Payload tepat 8 WORD dan denominator harus positif.
- Hanya bentuk tak tereduksi dengan `gcd(|numerator|, denominator) = 1` yang diizinkan. 0 hanya ditulis sebagai `0/1`.

## Status format

- Dua int64, denominator positif, faktor persekutuan terbesar 1, dan kanonikalisasi `0/1` bukan mengadopsi standar wire eksternal melainkan format khas GEUL.
- Halaman ini mendefinisikan representasi secara lengkap, termasuk interpretasi komplemen 2 setiap int64, urutan komponen, dan framing WORD big-endian.

## Panjang

- Total tepat 11 WORD, yaitu jumlah TAG 1 WORD, Issuer 1 WORD, nomor format 1 WORD, dan Payload 8 WORD, dengan panjang langsung `LLLL=1010`. Tidak ada Length extension TAG, descriptor, dan padding.
- Jika Payload bukan tepat 8 WORD, ditolak.

## Contoh

- Numerator `1`, denominator `2` adalah `1/2` yang valid. `2/4`, `0/2`, dan denominator `-2` adalah invalid.
