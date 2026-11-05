---
title: "SHA-512-DIGEST"
weight: 1039
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA-512-DIGEST adalah Value berlebar tetap yang memuat seluruh hasil SHA-512 dari keluarga SHA-2."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA-512-DIGEST adalah Value berlebar tetap yang memuat seluruh hasil SHA-512 dari keluarga SHA-2. Value `VALUE-ISSUER-2WORD`(`0x09DL`), Issuer `0x00000015` NIST, nomor Codec `0x0000C000`, keluarga BINARY. Payload tepat 32 WORD (512 bit) dan pemotongan (truncation) tidak diizinkan.

## Layout {#레이아웃}

```
TAG WORD          0x09DE (0000 1001 1101 1110)  LLLL=1110
TAG ekstensi Length   1 WORD  0x0026 (total 38 WORD)
Issuer            2 WORD  0x00000015 (NIST)
Nomor Codec       2 WORD  0x0000C000
Payload           32 WORD  SHA-512 Digest
```

## Interpretasi dan validitas {#해석과-유효성}

- 64 octet Payload dibaca sesuai urutan keluaran SHA-512. Dalam setiap WORD, octet teratas datang lebih dulu.
- Konversi endian GEUL tidak diterapkan secara terpisah pada digest bit string. Sequence octet keluaran hanya dikelompokkan dua octet demi dua octet secara berurutan, lalu di-framing sebagai WORD big-endian 16bit.
- Representasi yang Payload-nya bukan 32 WORD, atau yang hasilnya dipotong secara sembarang, ditolak. Tidak ada descriptor maupun padding.

## Dasar standar {#표준-근거}

- Algoritma SHA-512 dan hasil 512bit mengikuti NIST [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final).
- TAG GEUL, Length, dan framing WORD 16bit adalah aturan yang ditambahkan format ini dan bukan bagian dari algoritma SHA-2.

## Panjang {#길이}

- Totalnya tepat 38 WORD, yaitu jumlah TAG 1 WORD, TAG ekstensi Length 1 WORD, Issuer 2 WORD, nomor Codec 2 WORD, dan Payload 32 WORD, dengan `LLLL=1110`. Tidak ada descriptor maupun padding.
- Jika Payload tidak tepat 32 WORD, nilai ditolak.

## Contoh {#예시}

- Octet digest `d[0]` hingga `d[63]` ditempatkan berurutan sebagai WORD Payload `(d[0]<<8)|d[1]` hingga `(d[62]<<8)|d[63]`. Length total selalu 38 WORD.
