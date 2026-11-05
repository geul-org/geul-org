---
title: "TAI-TIMESTAMP-SECONDS"
weight: 1022
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "TAI-TIMESTAMP-SECONDS adalah jumlah SI-second bertanda sejak 1970-01-01T00:00:00 TAI."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TAI-TIMESTAMP-SECONDS adalah jumlah SI-second bertanda sejak `1970-01-01T00:00:00 TAI`. Representasi count kumulatif ini bukan wire format standar BIPM, melainkan profil khas GEUL yang memetakan skala waktu TAI ke signed int64 berlebar tetap.

## Layout {#레이아웃}

- Kode: Value `VALUE-ISSUER-2WORD`(`0x09DL`), Issuer `0x00000013` BIPM, nomor Codec `0x00004000`. Keluarga TIME.

```
TAG WORD          0x09D8 (0000 1001 1101 1000)  total 9 WORD
Issuer            2 WORD  0x00000013 (BIPM)
Nomor Codec       2 WORD  0x00004000
Payload WORD 1st (bits 63..48)     Signed SI Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed SI Seconds
Payload WORD 3rd (bits 31..16)     Signed SI Seconds
Payload WORD 4th (bits 15..0)      Signed SI Seconds low 16bit
```

## Interpretasi dan validitas {#해석과-유효성}

- Seluruh 4 WORD Payload dibaca sebagai count bertanda komplemen dua 64 bit dengan urutan WORD big-endian.
- Rentang yang valid adalah `-2^63` hingga `2^63-1` detik. Nilai negatif adalah instant TAI sebelum epoch yang ditetapkan GEUL.
- Nilai kecil pun selalu memakai 4 WORD. Offset UTC maupun tabel leap-second tidak disimpan.

## Panjang {#길이}

- Totalnya tepat 9 WORD, yaitu jumlah TAG 1 WORD, Issuer 2 WORD, nomor Codec 2 WORD, dan Payload 4 WORD, dengan panjang langsung `LLLL=1000`. Tidak ada TAG ekstensi Length, descriptor, maupun padding.
- Jika Payload tidak tepat 4 WORD, nilai ditolak.

## Contoh {#예시}

- TAI epoch GEUL adalah Payload `0000 0000 0000 0000`, total 9 WORD, `LLLL=1000`.
- 1 detik setelah epoch adalah Payload `0000 0000 0000 0001`.
- 1 detik sebelum epoch adalah Payload `FFFF FFFF FFFF FFFF`.

## Dasar standar dan status format {#표준-근거와-형식-지위}

- [BIPM SI Brochure, 9th edition](https://www.bipm.org/documents/20126/41483022/SI-Brochure-9-EN.pdf/2d2b50bf-f2b4-9661-f402-5f9d66e4b507?version=1.10) menetapkan SI second dan skala waktu International Atomic Time (TAI).
- BIPM tidak mendefinisikan count kumulatif signed int64 sejak epoch `1970-01-01 TAI` maupun wire encoding-nya. Epoch, signed int64, dan penempatan WORD big-endian GEUL merupakan pemetaan khas GEUL.
- Int64 berlebar tetap dipilih demi konsistensi pertukaran dengan profil count TIME lainnya, dan tidak berarti format BIPM direproduksi apa adanya.
