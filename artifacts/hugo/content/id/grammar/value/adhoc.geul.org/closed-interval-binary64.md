---
title: "CLOSED-INTERVAL-BINARY64"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "CLOSED-INTERVAL-BINARY64 adalah Value yang menyatakan interval tertutup dengan dua endpoint IEEE 754 binary64 berurutan (lower, upper)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CLOSED-INTERVAL-BINARY64 adalah Value yang menyatakan interval tertutup dengan dua endpoint IEEE 754 binary64 berurutan `(lower, upper)`. Value `VALUE-ISSUER-2WORD`(`0x09DL`), Issuer `0x00000002` ADHOC, nomor Codec `0x00000703`, keluarga NUMERIC.

## Layout {#레이아웃}

```
TAG WORD          0x09DC (0000 1001 1101 1100)  total 13 WORD
Issuer            2 WORD  0x00000002 (ADHOC)
Nomor Codec       2 WORD  0x00000703
Payload           [lower binary64: 4 WORD][upper binary64: 4 WORD]
```

## Interpretasi dan validitas {#해석과-유효성}

- Kedua endpoint berupa binary64 dengan urutan WORD big-endian, dan kedua ujungnya termasuk dalam interval.
- Pola bit signed zero pada endpoint yang valid dipertahankan apa adanya. Tidak ada ABI padding.
- Payload tepat 8 WORD dan harus berlaku `lower ≤ upper`.
- NaN tidak dapat dibandingkan sehingga ditolak. Endpoint infinity juga ditolak karena menghasilkan interval unbounded.
- Interval kosong, unbounded, open, dan NaI tidak dapat dinyatakan dengan format ini dan ditolak.

## Dasar standar dan status format {#표준-근거와-형식-지위}

- Format numerik endpoint mengikuti [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/), dan makna pasangan endpoint tertutup merujuk pada model interval dalam [IEEE 1788, Standard for Interval Arithmetic](https://standards.ieee.org/ieee/1788/4431/) dan [IEEE 1788.1-2017](https://ieeexplore.ieee.org/document/8241734) sebagai simplified flavor.
- Format ini adalah profil GEUL sederhana yang hanya mengizinkan interval tertutup yang berhingga dan tidak kosong. Format ini tidak mengimplementasikan atau menserialisasikan apa adanya decorations, NaI, interval empty/unbounded, maupun seluruh model operasi dan interchange IEEE 1788/1788.1.

## Panjang {#길이}

- Totalnya tepat 13 WORD, yaitu jumlah TAG 1 WORD, Issuer 2 WORD, nomor Codec 2 WORD, dan Payload 8 WORD, dengan panjang langsung `LLLL=1100`. Tidak ada TAG ekstensi Length, descriptor, maupun padding.
- Jika Payload tidak tepat 8 WORD, nilai ditolak.

## Contoh {#예시}

- Endpoint `(1.0, 2.0)` adalah `[1.0, 2.0]` dan valid. `(2.0, 1.0)` dan `(NaN, 1.0)` tidak valid.
