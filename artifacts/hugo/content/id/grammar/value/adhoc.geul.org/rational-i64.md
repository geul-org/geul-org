---
title: "RATIONAL-I64"
weight: 1020
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "RATIONAL-I64 adalah Value yang menyatakan bilangan rasional sebagai pecahan tak tereduksi dari numerator int64 dan denominator int64 big-endian."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

RATIONAL-I64 adalah Value yang menyatakan bilangan rasional sebagai pecahan tak tereduksi dari numerator int64 dan denominator int64 big-endian. Value `VALUE-ISSUER-2WORD`(`0x09DL`), Issuer `0x00000002` ADHOC, nomor Codec `0x00000702`, keluarga NUMERIC.

## Layout {#레이아웃}

```
TAG WORD          0x09DC (0000 1001 1101 1100)  total 13 WORD
Issuer            2 WORD  0x00000002 (ADHOC)
Nomor Codec       2 WORD  0x00000702
Payload           [numerator int64: 4 WORD][denominator int64: 4 WORD]
```

## Interpretasi dan validitas {#해석과-유효성}

- Setiap int64 adalah bilangan bulat komplemen dua berlebar tetap yang disambung mulai dari WORD teratas, dan nilainya adalah `numerator / denominator`.
- Tidak ada ABI padding.
- Payload tepat 8 WORD dan denominator harus positif.
- Hanya bentuk tak tereduksi dengan `gcd(|numerator|, denominator) = 1` yang diizinkan. Nol hanya ditulis sebagai `0/1`.

## Status format {#형식-지위}

- Dua int64, denominator positif, faktor persekutuan terbesar 1, dan kanonikalisasi `0/1` bukan hasil mengadopsi standar wire eksternal, melainkan format khas GEUL.
- Halaman ini mendefinisikan representasinya secara lengkap, termasuk interpretasi komplemen dua setiap int64, urutan komponen, dan framing WORD big-endian.

## Panjang {#길이}

- Totalnya tepat 13 WORD, yaitu jumlah TAG 1 WORD, Issuer 2 WORD, nomor Codec 2 WORD, dan Payload 8 WORD, dengan panjang langsung `LLLL=1100`. Tidak ada TAG ekstensi Length, descriptor, maupun padding.
- Jika Payload tidak tepat 8 WORD, nilai ditolak.

## Contoh {#예시}

- Numerator `1` dan denominator `2` adalah `1/2` yang valid. `2/4`, `0/2`, dan denominator `-2` tidak valid.
