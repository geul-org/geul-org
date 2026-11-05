---
title: "BLAKE3-256-DIGEST"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "BLAKE3-256-DIGEST adalah Value berlebar tetap yang memuat 32 octet pertama (256 bit) dari keluaran BLAKE3 default hash mode."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BLAKE3-256-DIGEST adalah Value berlebar tetap yang memuat 32 octet pertama (256 bit) dari keluaran BLAKE3 default hash mode. Value `VALUE-ISSUER-2WORD`(`0x09DL`), Issuer `0x00000002` ADHOC, nomor Codec `0x0000C000`, keluarga BINARY. Payload tepat 16 WORD dan tidak memuat keyed hash mode, key derivation mode, maupun keluaran XOF dengan panjang lain.

## Layout {#레이아웃}

```
TAG WORD          0x09DE (0000 1001 1101 1110)  LLLL=1110
TAG ekstensi Length   1 WORD  0x0016 (total 22 WORD)
Issuer            2 WORD  0x00000002 (ADHOC)
Nomor Codec       2 WORD  0x0000C000
Payload           16 WORD  BLAKE3-256 Digest
```

## Interpretasi dan validitas {#해석과-유효성}

- Payload adalah 32 octet pertama dari output stream BLAKE3 default hash mode. Urutan keluaran dipertahankan, dan dalam setiap WORD octet teratas datang lebih dulu.
- Konversi endian GEUL tidak diterapkan secara terpisah pada keluaran. Sequence octet keluaran dikelompokkan dua octet demi dua octet secara berurutan, lalu di-framing sebagai WORD big-endian 16 bit.
- Representasi yang Payload-nya bukan 16 WORD, atau yang memuat hasil keyed_hash, derive_key, atau XOF dengan panjang lain, ditolak. Tidak ada descriptor maupun padding.

## Dasar standar {#표준-근거}

- Definisi algoritma serta mode dan output mengikuti [repositori implementasi resmi](https://github.com/BLAKE3-team/BLAKE3) tim BLAKE3 dan [BLAKE3 specification](https://github.com/BLAKE3-team/BLAKE3-specs/blob/master/blake3.pdf).
- TAG GEUL, Length, dan framing WORD 16 bit adalah aturan yang ditambahkan format ini dan bukan bagian dari algoritma BLAKE3.

## Panjang {#길이}

- Totalnya tepat 22 WORD, yaitu jumlah TAG 1 WORD, TAG ekstensi Length 1 WORD, Issuer 2 WORD, nomor Codec 2 WORD, dan Payload 16 WORD, dengan `LLLL=1110`. Tidak ada descriptor maupun padding.
- Jika Payload tidak tepat 16 WORD, nilai ditolak.

## Contoh {#예시}

- Octet keluaran `d[0]` hingga `d[31]` ditempatkan pada 16 WORD Payload sesuai urutan keluaran, dua octet per WORD. Length total selalu 22 WORD.
