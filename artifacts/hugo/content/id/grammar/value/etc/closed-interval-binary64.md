---
title: "CLOSED-INTERVAL-BINARY64"
weight: 1004
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "CLOSED-INTERVAL-BINARY64 adalah format Issuer ADHOC 11 WORD tetap yang memuat interval tertutup berhingga yang tidak kosong dengan batas bawah·atas binary64."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CLOSED-INTERVAL-BINARY64 adalah Value yang menyatakan interval tertutup dengan dua endpoint IEEE 754 binary64 dalam urutan `(lower, upper)`. Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, nomor format `0x0703`, keluarga NUMERIC.

## Layout

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  total 11 WORD
Issuer            1 WORD  0x0001 (ADHOC)
Nomor format      1 WORD  0x0703
Payload           [lower binary64: 4 WORD][upper binary64: 4 WORD]
```

## Interpretasi dan validitas

- Kedua endpoint adalah binary64 dalam urutan WORD big-endian dan kedua ujungnya termasuk.
- Pola bit signed zero endpoint yang valid dipertahankan apa adanya. Tidak ada padding ABI.
- Payload tepat 8 WORD dan harus `lower ≤ upper`.
- NaN tidak dapat dibandingkan sehingga ditolak. Endpoint infinity juga ditolak karena menjadi interval unbounded.
- Interval empty, unbounded, open, dan NaI tidak dapat dinyatakan dengan format ini dan ditolak.

## Dasar standar dan status format

- Format numerik endpoint mengikuti [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/), dan arti pasangan endpoint tertutup merujuk pada model interval [IEEE 1788, Standard for Interval Arithmetic](https://standards.ieee.org/ieee/1788/4431/) dan simplified flavor [IEEE 1788.1-2017](https://ieeexplore.ieee.org/document/8241734).
- Format ini adalah profil GEUL sederhana yang hanya mengizinkan interval tertutup berhingga yang tidak kosong. Tidak mengimplementasikan atau men-serialisasi apa adanya decorations, NaI, interval empty/unbounded, dan seluruh model operasi·interchange IEEE 1788/1788.1.

## Panjang

- Total tepat 11 WORD, yaitu jumlah TAG 1 WORD, Issuer 1 WORD, nomor format 1 WORD, dan Payload 8 WORD, dengan panjang langsung `LLLL=1010`. Tidak ada Length extension TAG, descriptor, dan padding.
- Jika Payload bukan tepat 8 WORD, ditolak.

## Contoh

- Endpoint `(1.0, 2.0)` adalah `[1.0, 2.0]` dan valid. `(2.0, 1.0)` dan `(NaN, 1.0)` adalah invalid.
