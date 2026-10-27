---
title: "SHA3-256-DIGEST"
weight: 1009
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA3-256-DIGEST adalah format Issuer NIST 20 WORD tetap yang memuat seluruh 256 bit hasil SHA3-256."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA3-256-DIGEST adalah Value berlebar tetap yang memuat seluruh hasil SHA3-256. Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0062` NIST, nomor format `0xC001`, keluarga BINARY. Payload tepat 16 WORD (256 bit) dan pemotongan (truncation) tidak diizinkan.

## Layout

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
Length extension TAG   1 WORD  0x0014 (total 20 WORD)
Issuer            1 WORD  0x0062 (NIST)
Nomor format      1 WORD  0xC001
Payload           16 WORD  SHA3-256 Digest
```

## Interpretasi dan validitas

- 32 octet Payload dibaca apa adanya menurut urutan output SHA3-256. Pada setiap WORD, octet atas datang lebih dulu.
- Konversi endian GEUL tidak diterapkan terpisah pada digest bit string. Urutan octet keluaran hanya dikelompokkan dua octet berurutan lalu di-framing sebagai WORD big-endian 16 bit.
- Representasi yang Payload-nya bukan 16 WORD, atau yang hasilnya dipotong sembarangan, ditolak. Tidak ada descriptor dan padding.

## Dasar standar

- Algoritma SHA3-256 dan hasil 256 bit mengikuti NIST [FIPS 202, SHA-3 Standard](https://csrc.nist.gov/pubs/fips/202/final). [Proyek Hash Functions](https://csrc.nist.gov/Projects/hash-functions) NIST juga memandu standar SHA-3.
- Framing TAG, Length, dan WORD 16 bit GEUL adalah aturan yang ditambahkan format ini dan bukan bagian algoritma SHA-3.

## Panjang

- Total tepat 20 WORD, yaitu jumlah TAG 1 WORD, Length extension TAG 1 WORD, Issuer 1 WORD, nomor format 1 WORD, dan Payload 16 WORD, dengan `LLLL=1110`. Tidak ada descriptor dan padding.
- Jika Payload bukan tepat 16 WORD, ditolak.

## Contoh

- Octet digest `d[0]` sampai `d[31]` ditaruh pada 16 WORD Payload menurut urutan keluaran, dua octet per WORD. Length total selalu 20 WORD.
