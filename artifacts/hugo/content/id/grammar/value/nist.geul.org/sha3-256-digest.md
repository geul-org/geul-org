---
title: "SHA3-256-DIGEST"
weight: 1040
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA3-256-DIGEST adalah Value berlebar tetap yang memuat seluruh hasil SHA3-256."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA3-256-DIGEST adalah Value berlebar tetap yang memuat seluruh hasil SHA3-256. Value `VALUE-ISSUER-2WORD`(`0x09DL`), Issuer `0x00000015` NIST, nomor Codec `0x0000C001`, keluarga BINARY. Payload tepat 16 WORD (256 bit) dan pemotongan (truncation) tidak diizinkan.

## Layout {#레이아웃}

```
TAG WORD          0x09DE (0000 1001 1101 1110)  LLLL=1110
TAG ekstensi Length   1 WORD  0x0016 (total 22 WORD)
Issuer            2 WORD  0x00000015 (NIST)
Nomor Codec       2 WORD  0x0000C001
Payload           16 WORD  SHA3-256 Digest
```

## Interpretasi dan validitas {#해석과-유효성}

- 32 octet Payload dibaca sesuai urutan keluaran SHA3-256. Dalam setiap WORD, octet teratas datang lebih dulu.
- Konversi endian GEUL tidak diterapkan secara terpisah pada digest bit string. Sequence octet keluaran hanya dikelompokkan dua octet demi dua octet secara berurutan, lalu di-framing sebagai WORD big-endian 16bit.
- Representasi yang Payload-nya bukan 16 WORD, atau yang hasilnya dipotong secara sembarang, ditolak. Tidak ada descriptor maupun padding.

## Dasar standar {#표준-근거}

- Algoritma SHA3-256 dan hasil 256bit mengikuti NIST [FIPS 202, SHA-3 Standard](https://csrc.nist.gov/pubs/fips/202/final). [Proyek Hash Functions](https://csrc.nist.gov/Projects/hash-functions) NIST juga memuat panduan tentang standar SHA-3.
- TAG GEUL, Length, dan framing WORD 16bit adalah aturan yang ditambahkan format ini dan bukan bagian dari algoritma SHA-3.

## Panjang {#길이}

- Totalnya tepat 22 WORD, yaitu jumlah TAG 1 WORD, TAG ekstensi Length 1 WORD, Issuer 2 WORD, nomor Codec 2 WORD, dan Payload 16 WORD, dengan `LLLL=1110`. Tidak ada descriptor maupun padding.
- Jika Payload tidak tepat 16 WORD, nilai ditolak.

## Contoh {#예시}

- Octet digest `d[0]` hingga `d[31]` ditempatkan pada 16 WORD Payload sesuai urutan keluaran, dua octet per WORD. Length total selalu 22 WORD.
