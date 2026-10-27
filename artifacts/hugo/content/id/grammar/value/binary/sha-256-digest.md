---
title: "SHA-256-DIGEST"
weight: 98
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA-256-DIGEST adalah Value 18 WORD tetap yang memuat seluruh 256 bit hasil SHA-256."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA-256-DIGEST adalah Value berlebar tetap yang memuat seluruh hasil SHA-256 keluarga SHA-2. Kode langsung Value `0x61`, keluarga BINARY. Payload tepat 16 WORD (256 bit) dan pemotongan (truncation) tidak diizinkan.

## Layout

```
TAG WORD          0x0F61 (0000 1111 0110 0001)  LLLL=1110
Length extension TAG   1 WORD  0x0012 (total 18 WORD)
Payload           16 WORD  SHA-256 Digest
```

## Interpretasi dan validitas

- 32 octet Payload dibaca apa adanya menurut urutan output SHA-256. Pada setiap WORD, octet atas datang lebih dulu.
- Konversi endian GEUL tidak diterapkan terpisah pada digest bit string. Urutan octet keluaran hanya dikelompokkan dua octet berurutan lalu di-framing sebagai WORD big-endian 16 bit.
- Representasi yang Payload-nya bukan 16 WORD, atau yang hasilnya dipotong sembarangan, ditolak. Tidak ada descriptor dan padding.

## Dasar standar

- Algoritma SHA-256 dan hasil 256 bit mengikuti NIST [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final).
- Framing TAG, Length, dan WORD 16 bit GEUL adalah aturan yang ditambahkan format ini dan bukan bagian algoritma SHA-2.

## Panjang

- Total tepat 18 WORD, yaitu jumlah TAG 1 WORD, Length extension TAG 1 WORD, dan Payload 16 WORD, dengan `LLLL=1110`. Tidak ada descriptor dan padding.
- Jika Payload bukan tepat 16 WORD, ditolak.

## Contoh

- Octet digest `d[0]` sampai `d[31]` ditaruh berurutan dari WORD Payload `(d[0]<<8)|d[1]` sampai `(d[30]<<8)|d[31]`. Length total selalu 18 WORD.
