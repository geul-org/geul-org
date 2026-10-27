---
title: "GPS-TIMESTAMP-SECONDS"
weight: 1005
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GPS-TIMESTAMP-SECONDS adalah Value yang memuat jumlah detik bertanda sejak epoch GPS 1980-01-06T00:00:00 GPS (format Issuer GPS 0x4000)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GPS-TIMESTAMP-SECONDS adalah jumlah detik bertanda sejak epoch GPS `1980-01-06T00:00:00 GPS`. Tidak dibagi dengan nomor GPS week atau dipotong dengan lebar week rollover field broadcast.

Representasi count akumulatif ini bukan wire format broadcast IS-GPS-200, melainkan profil khas GEUL yang memetakan skala waktu GPS ke signed int64 berlebar tetap.

## Layout

- Kode: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0063` GPS, nomor format `0x4000`. Keluarga TIME.

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  total 7 WORD
Issuer            1 WORD  0x0063 (GPS)
Nomor format      1 WORD  0x4000
Payload WORD 1st (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Seconds
Payload WORD 3rd (bits 31..16)     Signed Seconds
Payload WORD 4th (bits 15..0)      Signed Seconds low 16bit
```

## Interpretasi dan validitas

- Seluruh 4 WORD Payload dibaca sebagai count bertanda komplemen 2 64 bit dalam urutan WORD big-endian.
- Rentang yang valid adalah `-2^63`~`2^63-1` detik. Negatif adalah instant waktu GPS sebelum epoch GPS.
- count adalah nilai kontinu yang berlanjut dari epoch. Truncation atau rollover field nomor week broadcast tidak diterapkan.
- Nilai kecil pun selalu memakai 4 WORD. Parameter konversi UTC tidak dimuat.

## Panjang

- Total tepat 7 WORD, yaitu jumlah TAG 1 WORD, Issuer 1 WORD, nomor format 1 WORD, dan Payload 4 WORD, dengan panjang langsung `LLLL=0110`. Tidak ada Length extension TAG, descriptor, dan padding.
- Jika Payload bukan tepat 4 WORD, ditolak.

## Contoh

- Epoch GPS adalah Payload `0000 0000 0000 0000`, total 7 WORD, `LLLL=0110`.
- 1 detik setelah epoch adalah Payload `0000 0000 0000 0001`.
- 1 detik sebelum epoch adalah Payload `ffff ffff ffff ffff`.

## Dasar standar dan status format

- [GPS.gov Technical Documentation](https://www.gps.gov/technical-documentation) adalah tempat distribusi resmi spesifikasi antarmuka GPS.
- [IS-GPS-200N](https://archive.gps.gov/technical/icwg/IS-GPS-200N.pdf) menetapkan bahwa waktu GPS adalah skala waktu kontinu dan week 0 dimulai pada tengah malam 1980-01-06, serta mendefinisikan nomor GPS week dan field broadcast time-of-week/Z-count.
- IS-GPS-200 tidak mendefinisikan representasi wire signed int64 akumulatif sejak epoch yang berlaku. Count kontinu tanpa rollover, signed int64, dan penataan WORD big-endian GEUL adalah pemetaan khas GEUL.
