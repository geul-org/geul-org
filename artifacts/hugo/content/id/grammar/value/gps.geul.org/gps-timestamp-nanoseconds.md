---
title: "GPS-TIMESTAMP-NANOSECONDS"
weight: 1023
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GPS-TIMESTAMP-NANOSECONDS adalah jumlah nanosecond bertanda sejak GPS epoch 1980-01-06T00:00:00 GPS."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GPS-TIMESTAMP-NANOSECONDS adalah jumlah nanosecond bertanda sejak GPS epoch `1980-01-06T00:00:00 GPS`. Nilai ini tidak dibagi dengan nomor GPS week dan tidak dipotong pada lebar week rollover field broadcast.

Representasi count kumulatif ini bukan wire format broadcast IS-GPS-200, melainkan profil khas GEUL yang memetakan skala waktu GPS ke signed int64 berlebar tetap.

## Layout {#레이아웃}

- Kode: Value `VALUE-ISSUER-2WORD`(`0x09DL`), Issuer `0x00000016` GPS, nomor Codec `0x00004001`. Keluarga TIME.

```
TAG WORD          0x09D8 (0000 1001 1101 1000)  total 9 WORD
Issuer            2 WORD  0x00000016 (GPS)
Nomor Codec       2 WORD  0x00004001
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## Interpretasi dan validitas {#해석과-유효성}

- Seluruh 4 WORD Payload dibaca sebagai count bertanda komplemen dua 64 bit dengan urutan WORD big-endian.
- Rentang yang valid adalah `-2^63` hingga `2^63-1` ns. Nilai negatif adalah instant GPS-time sebelum GPS epoch.
- Count adalah nilai kontinu yang berlanjut sejak epoch. Truncation maupun rollover pada field week-number broadcast tidak diterapkan.
- Nilai kecil pun selalu memakai 4 WORD. Parameter konversi UTC tidak dimuat.

## Panjang {#길이}

- Totalnya tepat 9 WORD, yaitu jumlah TAG 1 WORD, Issuer 2 WORD, nomor Codec 2 WORD, dan Payload 4 WORD, dengan panjang langsung `LLLL=1000`. Tidak ada TAG ekstensi Length, descriptor, maupun padding.
- Jika Payload tidak tepat 4 WORD, nilai ditolak.

## Contoh {#예시}

- GPS epoch adalah Payload `0000 0000 0000 0000`, total 9 WORD, `LLLL=1000`.
- 1 ns setelah epoch adalah Payload `0000 0000 0000 0001`.
- 1 ns sebelum epoch adalah Payload `FFFF FFFF FFFF FFFF`.

## Dasar standar dan status format {#표준-근거와-형식-지위}

- [GPS.gov Technical Documentation](https://www.gps.gov/technical-documentation) adalah sumber distribusi resmi spesifikasi antarmuka GPS.
- [IS-GPS-200N](https://archive.gps.gov/technical/icwg/IS-GPS-200N.pdf) menetapkan bahwa GPS time adalah skala waktu kontinu dan week 0 dimulai pada tengah malam 1980-01-06, serta mendefinisikan field broadcast GPS week number dan time-of-week/Z-count.
- IS-GPS-200 tidak mendefinisikan wire representation signed int64 nanosecond kumulatif sejak epoch. Count kontinu tanpa rollover dalam satuan nanosecond, signed int64, dan penempatan WORD big-endian GEUL merupakan pemetaan khas GEUL.
