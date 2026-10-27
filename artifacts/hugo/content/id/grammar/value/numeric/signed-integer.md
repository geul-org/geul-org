---
title: "SIGNED-INTEGER"
weight: 2
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "SIGNED-INTEGER adalah Value yang memuat bilangan bulat bertanda sebagai komplemen 2 dengan WORD minimum."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SIGNED-INTEGER adalah Value yang menyatakan nilai bilangan bulat bertanda. Kode langsung Value `0x01`, keluarga NUMERIC. Seluruh Payload dibaca sebagai bilangan bulat komplemen 2 berpresisi sembarang dalam urutan WORD big-endian. Payload minimum 1 WORD dan hanya representasi kanonik WORD minimum yang diizinkan.

## Layout

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x01
[Length extension TAG] jika total 15 WORD atau lebih
Payload WORD 1st  (WORD atas)   Integer 1st
...
Payload WORD Nth  (WORD bawah)  Integer Nth
```

## Interpretasi

- Bit paling signifikan WORD Payload pertama adalah bit tanda seluruh bilangan bulat.
- Semua WORD Payload dibaca sebagai satu deretan bit komplemen 2 yang kontinu. WORD pertama adalah digit tertinggi dan WORD terakhir adalah digit terendah.
- Jika Payload N WORD, lebar interpretasi adalah `16N` bit. Lebar ini bukan lebar penyimpanan yang dideklarasikan melainkan lebar representasi nilai yang ditentukan oleh representasi kanonik.
- Tidak ada Byte Count atau descriptor bit width.

## Representasi kanonik

- 0 adalah Payload 1 WORD `0000`.
- WORD ekstensi tanda di depan yang tidak mengubah nilai dilarang.
- Jika Payload 2 WORD atau lebih, yang berikut tidak kanonik.
  - WORD pertama `0000` dan bit paling signifikan WORD berikutnya 0
  - WORD pertama `ffff` dan bit paling signifikan WORD berikutnya 1
- `0000` di depan yang menjaga tanda bilangan positif diizinkan jika bit paling signifikan WORD berikutnya 1.
- `ffff` di depan yang menjaga tanda bilangan negatif diizinkan jika bit paling signifikan WORD berikutnya 0.
- Decoder harus menolak representasi tidak kanonik.

## Panjang

- Total adalah jumlah WORD TAG 1 WORD, Length extension TAG (jika ada), dan Payload. 14 WORD atau kurang memakai panjang langsung, dan 15 WORD atau lebih memakai panjang extension `1110`·`1111` dengan extension TAG juga masuk ke jumlah total ([Record dan TAG WORD](/id/grammar/record/)).
- Lebar yang dideklarasikan seperti INT8·INT16·INT32 tidak dipertahankan, hanya nilai angkanya. `-32768`~`32767` adalah 1 WORD, dan jika di luar rentang ditambah WORD sebanyak yang diperlukan. Tidak ada format SIGNED-INT8 terpisah.

## Contoh

| Nilai | WORD Payload | Penilaian |
|---:|---|---|
| 0 | `0000` | Kanonik |
| 1 | `0001` | Kanonik |
| 32767 | `7fff` | Kanonik |
| 32768 | `0000 8000` | Kanonik: `0000` diperlukan untuk menjaga tanda positif |
| -1 | `ffff` | Kanonik |
| -32768 | `8000` | Kanonik |
| -32769 | `ffff 7fff` | Kanonik: `ffff` diperlukan untuk menjaga tanda negatif |
| 1 | `0000 0001` | Tidak kanonik: `0000` di depan tidak perlu |
| -1 | `ffff ffff` | Tidak kanonik: `ffff` di depan tidak perlu |

## Status format

- Komplemen 2 adalah konvensi yang luas dipakai, tetapi representasi yang menormalisasi nilai berpresisi sembarang menjadi deretan WORD 16 bit minimum lalu menggabungkannya dengan TAG GEUL ini adalah profil scalar khas GEUL.
- Saat bertukar dengan tipe eksternal berlebar tetap seperti INT8/16/32/64, diperlukan pemeriksaan rentang dan konversi lebar yang eksplisit.
