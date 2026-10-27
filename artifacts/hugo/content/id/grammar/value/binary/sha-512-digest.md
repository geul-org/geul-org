---
title: "SHA-512-DIGEST"
weight: 1008
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA-512-DIGEST adalah format Issuer NIST 36 WORD tetap yang memuat seluruh 512 bit hasil SHA-512."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA-512-DIGEST adalah Value berlebar tetap yang memuat seluruh hasil SHA-512 keluarga SHA-2. Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0062` NIST, nomor format `0xC000`, keluarga BINARY. Payload tepat 32 WORD (512 bit) dan pemotongan (truncation) tidak diizinkan.

## Layout

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
Length extension TAG   1 WORD  0x0024 (total 36 WORD)
Issuer            1 WORD  0x0062 (NIST)
Nomor format      1 WORD  0xC000
Payload           32 WORD  SHA-512 Digest
```

## Interpretasi dan validitas

- 64 octet Payload dibaca apa adanya menurut urutan output SHA-512. Pada setiap WORD, octet atas datang lebih dulu.
- Konversi endian GEUL tidak diterapkan terpisah pada digest bit string. Urutan octet keluaran hanya dikelompokkan dua octet berurutan lalu di-framing sebagai WORD big-endian 16 bit.
- Representasi yang Payload-nya bukan 32 WORD, atau yang hasilnya dipotong sembarangan, ditolak. Tidak ada descriptor dan padding.

## Dasar standar

- Algoritma SHA-512 dan hasil 512 bit mengikuti NIST [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final).
- Framing TAG, Length, dan WORD 16 bit GEUL adalah aturan yang ditambahkan format ini dan bukan bagian algoritma SHA-2.

## Panjang

- Total tepat 36 WORD, yaitu jumlah TAG 1 WORD, Length extension TAG 1 WORD, Issuer 1 WORD, nomor format 1 WORD, dan Payload 32 WORD, dengan `LLLL=1110`. Tidak ada descriptor dan padding.
- Jika Payload bukan tepat 32 WORD, ditolak.

## Contoh

- Octet digest `d[0]` sampai `d[63]` ditaruh berurutan dari WORD Payload `(d[0]<<8)|d[1]` sampai `(d[62]<<8)|d[63]`. Length total selalu 36 WORD.
