---
title: "BIT-VECTOR"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "BIT-VECTOR adalah format Issuer GEUL yang memuat N bit secara MSB-first setelah jumlah bit N 32 bit."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BIT-VECTOR adalah raw bit sequence yang panjangnya dinyatakan. Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0000` GEUL, nomor format `0xC002`, keluarga BINARY. 2 WORD Payload pertama adalah bit count `N` unsigned 32 bit, dan diikuti `ceil(N/16)` WORD.

## Layout

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length extension TAG] jika total 15 WORD atau lebih
Issuer            1 WORD  0x0000 (GEUL)
Nomor format      1 WORD  0xC002
Payload WORD 1st–2nd       Bit Count N (16 bit atas │ 16 bit bawah)
Payload WORD 3rd ... Nth   Payload bits, MSB-first
```

## Interpretasi dan validitas

- `N` adalah nilai yang diperoleh dengan membaca 2 WORD Payload pertama sebagai bilangan bulat unsigned 32 bit big-endian.
- Bit payload diisi berurutan mulai dari bit paling signifikan setiap WORD.
- Jumlah WORD payload tepat `ceil(N/16)`, dan semua bit bawah yang tidak dipakai pada WORD terakhir harus 0.
- Jika `N=0`, tidak ada WORD payload. Dua WORD count sudah membentuk Payload sehingga tidak bertentangan dengan aturan Payload minimum 1 WORD.

## Status format

- Bit count unsigned 32 bit, penataan MSB-first, dan zero padding pada WORD terakhir bukan kutipan standar industri eksternal melainkan framing khas GEUL.
- Halaman ini mendefinisikan representasinya, termasuk aturan TAG, Length, dan WORD 16 bit GEUL.

## Panjang

- Total adalah jumlah WORD TAG 1 WORD, Length extension TAG (jika ada), Issuer 1 WORD, nomor format 1 WORD, dan Payload. 14 WORD atau kurang memakai panjang langsung, dan 15 WORD atau lebih memakai panjang extension `1110`·`1111` dengan extension TAG juga masuk ke jumlah total ([Record dan TAG WORD](/id/grammar/record/)).

## Contoh

- Bit vector kosong adalah count `0000 0000`, tanpa payload, total 5 WORD, `LLLL=0100`.
- Bit sequence `101` adalah count `0000 0003`, payload `a000`, total 6 WORD, `LLLL=0101`.
