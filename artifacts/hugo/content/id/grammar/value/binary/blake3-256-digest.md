---
title: "BLAKE3-256-DIGEST"
weight: 1003
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "BLAKE3-256-DIGEST adalah format Issuer 20 WORD tetap yang memuat 32 octet pertama keluaran mode hash default BLAKE3."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BLAKE3-256-DIGEST adalah Value berlebar tetap yang memuat 32 octet (256 bit) pertama keluaran mode hash default BLAKE3. Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, nomor format `0xC000`, keluarga BINARY. Payload tepat 16 WORD, dan keyed hash mode, key derivation mode, serta keluaran XOF dengan panjang lain tidak dimuat.

## Layout

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
Length extension TAG   1 WORD  0x0014 (total 20 WORD)
Issuer            1 WORD  0x0001 (ADHOC)
Nomor format      1 WORD  0xC000
Payload           16 WORD  BLAKE3-256 Digest
```

## Interpretasi dan validitas

- Payload adalah 32 octet pertama output stream mode hash default BLAKE3. Urutan keluaran dipertahankan dan pada setiap WORD octet atas datang lebih dulu.
- Konversi endian GEUL tidak diterapkan terpisah pada keluaran. Urutan octet keluaran dikelompokkan dua octet berurutan lalu di-framing sebagai WORD big-endian 16 bit.
- Representasi yang Payload-nya bukan 16 WORD, atau yang memuat hasil keyed_hash, derive_key, atau XOF dengan panjang lain, ditolak. Tidak ada descriptor dan padding.

## Dasar standar

- Definisi algoritma serta mode·output mengikuti [repositori implementasi resmi](https://github.com/BLAKE3-team/BLAKE3) tim BLAKE3 dan [spesifikasi BLAKE3](https://github.com/BLAKE3-team/BLAKE3-specs/blob/master/blake3.pdf).
- Framing TAG, Length, dan WORD 16 bit GEUL adalah aturan yang ditambahkan format ini dan bukan bagian algoritma BLAKE3.

## Panjang

- Total tepat 20 WORD, yaitu jumlah TAG 1 WORD, Length extension TAG 1 WORD, Issuer 1 WORD, nomor format 1 WORD, dan Payload 16 WORD, dengan `LLLL=1110`. Tidak ada descriptor dan padding.
- Jika Payload bukan tepat 16 WORD, ditolak.

## Contoh

- Octet output `d[0]` sampai `d[31]` ditaruh pada 16 WORD Payload menurut urutan keluaran, dua octet per WORD. Length total selalu 20 WORD.
