---
title: "UNSIGNED-INTEGER"
weight: 3
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "UNSIGNED-INTEGER adalah Value yang memuat bilangan bulat tanpa tanda sebagai magnitudo big-endian dengan WORD minimum."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UNSIGNED-INTEGER adalah Value yang menyatakan nilai bilangan bulat tanpa tanda. Kode langsung Value `0x02`, keluarga NUMERIC. Seluruh Payload dibaca sebagai magnitudo unsigned berpresisi sembarang dalam urutan WORD big-endian. Payload minimum 1 WORD dan hanya representasi kanonik WORD minimum yang diizinkan.

## Layout

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x02
[Length extension TAG] jika total 15 WORD atau lebih
Payload WORD 1st  (WORD atas)   Unsigned Magnitude 1st
...
Payload WORD Nth  (WORD bawah)  Unsigned Magnitude Nth
```

## Interpretasi

- WORD Payload pertama adalah digit tertinggi dan WORD terakhir adalah digit terendah.
- Jika Payload N WORD, dibaca sebagai satu magnitudo unsigned `16N` bit.
- Lebar ini bukan lebar penyimpanan yang dideklarasikan dan tidak ada descriptor bit width.

## Representasi kanonik

- 0 adalah Payload 1 WORD `0000`.
- Jika Payload 2 WORD atau lebih dan WORD pertama `0000`, nilainya sama walaupun dihapus sehingga tidak kanonik.
- Decoder harus menolak representasi yang memiliki WORD zero di depan yang tidak perlu.

## Panjang

- Total adalah jumlah WORD TAG 1 WORD, Length extension TAG (jika ada), dan Payload. 14 WORD atau kurang memakai panjang langsung, dan 15 WORD atau lebih memakai panjang extension `1110`·`1111` dengan extension TAG juga masuk ke jumlah total ([Record dan TAG WORD](/id/grammar/record/)).
- Lebar yang dideklarasikan seperti UINT8·UINT16·UINT32 tidak dipertahankan, hanya nilai angkanya.

## Contoh

| Nilai | WORD Payload | Penilaian |
|---:|---|---|
| 0 | `0000` | Kanonik |
| 1 | `0001` | Kanonik |
| 65535 | `ffff` | Kanonik |
| 65536 | `0001 0000` | Kanonik |
| 1 | `0000 0001` | Tidak kanonik: `0000` di depan tidak perlu |
| Payload 7 WORD | 7 WORD setelah TAG `0b82` (panjang langsung `LLLL=0111`, total 8 WORD) | Kanonik |
| Payload 7 WORD | 7 WORD setelah TAG panjang extension dan nilai extension `0009` | Tidak kanonik: 14 WORD atau kurang ditulis dengan panjang langsung |

## Status format

- Representasi yang menormalisasi magnitudo unsigned berpresisi sembarang menjadi deretan WORD 16 bit minimum lalu menggabungkannya dengan TAG GEUL ini adalah profil scalar khas GEUL.
- Saat bertukar dengan tipe eksternal berlebar tetap seperti UINT8/16/32/64, diperlukan pemeriksaan rentang dan konversi lebar yang eksplisit.
