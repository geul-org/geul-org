---
title: "TAI-TIMESTAMP-SECONDS"
weight: 1003
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "TAI-TIMESTAMP-SECONDS adalah Value yang memuat jumlah SI-second bertanda sejak 1970-01-01T00:00:00 TAI (format Issuer BIPM 0x4000)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TAI-TIMESTAMP-SECONDS adalah jumlah SI-second bertanda sejak `1970-01-01T00:00:00 TAI`. Representasi count akumulatif ini bukan wire format standar BIPM, melainkan profil khas GEUL yang memetakan skala waktu TAI ke signed int64 berlebar tetap.

## Layout

- Kode: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0060` BIPM, nomor format `0x4000`. Keluarga TIME.

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  total 7 WORD
Issuer            1 WORD  0x0060 (BIPM)
Nomor format      1 WORD  0x4000
Payload WORD 1st (bits 63..48)     Signed SI Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed SI Seconds
Payload WORD 3rd (bits 31..16)     Signed SI Seconds
Payload WORD 4th (bits 15..0)      Signed SI Seconds low 16bit
```

## Interpretasi dan validitas

- Seluruh 4 WORD Payload dibaca sebagai count bertanda komplemen 2 64 bit dalam urutan WORD big-endian.
- Rentang yang valid adalah `-2^63`~`2^63-1` detik. Negatif adalah instant TAI sebelum epoch yang ditetapkan GEUL.
- Nilai kecil pun selalu memakai 4 WORD. Offset UTC atau tabel detik kabisat tidak disimpan.

## Panjang

- Total tepat 7 WORD, yaitu jumlah TAG 1 WORD, Issuer 1 WORD, nomor format 1 WORD, dan Payload 4 WORD, dengan panjang langsung `LLLL=0110`. Tidak ada Length extension TAG, descriptor, dan padding.
- Jika Payload bukan tepat 4 WORD, ditolak.

## Contoh

- Epoch TAI GEUL adalah Payload `0000 0000 0000 0000`, total 7 WORD, `LLLL=0110`.
- 1 detik setelah epoch adalah Payload `0000 0000 0000 0001`.
- 1 detik sebelum epoch adalah Payload `ffff ffff ffff ffff`.

## Dasar standar dan status format

- [BIPM SI Brochure, 9th edition](https://www.bipm.org/documents/20126/41483022/SI-Brochure-9-EN.pdf/2d2b50bf-f2b4-9661-f402-5f9d66e4b507?version=1.10) menetapkan detik SI dan skala waktu International Atomic Time (TAI).
- BIPM tidak mendefinisikan count akumulatif signed int64 sejak epoch `1970-01-01 TAI` atau wire encoding-nya. Epoch, signed int64, dan penataan WORD big-endian GEUL adalah pemetaan khas GEUL.
- int64 berlebar tetap dipilih demi konsistensi pertukaran dengan profil count TIME lain, dan tidak berarti format BIPM direproduksi apa adanya.
