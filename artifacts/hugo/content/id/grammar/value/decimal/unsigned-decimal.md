---
title: "UNSIGNED-DECIMAL"
weight: 18
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "UNSIGNED-DECIMAL adalah Value yang memuat desimal eksak C×10^E dari eksponen E bertanda 32 bit dan koefisien C tanpa tanda dengan WORD minimum."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UNSIGNED-DECIMAL adalah Value desimal eksak (exact decimal) dengan koefisien (coefficient) tanpa tanda. Kode langsung Value `0x11`, keluarga DECIMAL. 2 WORD pertama Payload adalah eksponen desimal `E` bertanda 32 bit, sisanya adalah koefisien `C` unsigned dengan WORD minimum, dan nilainya adalah `C×10^E`.

## Layout

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x11
[Length extension TAG] jika total 15 WORD atau lebih
Payload WORD 1st–2nd (32 bit)       Signed Base-10 Exponent E
Payload WORD 3rd–Nth (1 WORD atau lebih)  Unsigned Coefficient C
```

## Interpretasi

- `E` adalah bilangan bulat komplemen 2 big-endian bertanda 32 bit yang dicatat mulai dari WORD atas.
- `C` adalah magnitudo unsigned berpresisi sembarang yang dibaca dari seluruh WORD sisa mulai dari WORD atas.
- `C` mengikuti aturan WORD minimum yang sama dengan [UNSIGNED-INTEGER](/id/grammar/value/numeric/unsigned-integer/). 0 adalah `0000`, dan pada 2 WORD atau lebih WORD pertama `0000` dilarang.

## Panjang dan validitas

- Total adalah jumlah WORD TAG 1 WORD, Length extension TAG (jika ada), dan Payload. 14 WORD atau kurang memakai panjang langsung, dan 15 WORD atau lebih memakai panjang extension `1110`·`1111` dengan extension TAG juga masuk ke jumlah total ([Record dan TAG WORD](/id/grammar/record/)).
- Payload minimum 3 WORD karena eksponen 2 WORD dan koefisien 1 WORD atau lebih.
- Kekanonikan representasi byte hanya memeriksa representasi WORD minimum koefisien.

## Contoh

| Representasi nilai | Payload (`E` + `C`) | Penilaian |
|---|---|---|
| `1×10^0` | `0000 0000 0001` | Representasi byte kanonik |
| `10×10^-1` | `ffff ffff 000a` | Representasi byte kanonik, hubungan kanonik dengan representasi di atas adalah masalah terbuka |
| `1×10^0` | `0000 0000 0000 0001` | Tidak kanonik: `0000` di depan koefisien tidak perlu |
| Koefisien negatif | Tidak berlaku | invalid |

## Status format

- Penataan yang menggabungkan eksponen `E` bertanda 32 bit dan koefisien `C` unsigned WORD minimum ini adalah format khas GEUL, bukan interchange decimal IEEE 754 atau `DECIMAL` Apache Parquet.
- `DECIMAL` Parquet memakai unscaled value bertanda, `unscaledValue × 10^(-scale)`, dan metadata precision/scale wajib, dengan tipe fisik byte-array berupa komplemen 2 big-endian dan scale bernilai 0 atau lebih. Format ini bukan format yang sama karena `C` unsigned, `E` bertanda, dan tidak ada metadata precision.
- Untuk bertukar dengan decimal IEEE 754 atau `DECIMAL` Parquet, diperlukan konversi eksplisit yang menetapkan kebijakan tanda, rentang, precision/scale, quantum, dan nilai khusus.
- Dasar perbandingan: [IEEE 754-2019](https://standards.ieee.org/ieee/754/6210/), [Apache Parquet Logical Types — DECIMAL](https://parquet.apache.org/docs/file-format/types/logicaltypes/)

## Masalah terbuka

- Ada beberapa pasangan eksponen/koefisien yang menyatakan bilangan yang sama, seperti `10×10^-1` dan `1×10^0`.
- Belum ditetapkan apakah format ini mempertahankan quantum, bagaimana kesetaraan nilai dinilai, dan bagaimana eksponen kanonik dinormalisasi.
- Karena itu implementasi tidak boleh memaksakan secara sembarangan normalisasi eksponen/koefisien di luar aturan WORD minimum koefisien.
