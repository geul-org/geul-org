---
title: "CRC32C"
weight: 1004
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "CRC32C adalah format Issuer IETF 5 WORD tetap yang memuat 32 bit hasil CRC-32C Castagnoli."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CRC32C adalah Value berlebar tetap yang memuat hasil CRC-32C. Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0020` IETF, nomor format `0xC000`, keluarga BINARY. Payload tepat 2 WORD (32 bit).

## Layout

```
TAG WORD          0x0A7C (0000 1010 0111 1100)  total 5 WORD
Issuer            1 WORD  0x0020 (IETF)
Nomor format      1 WORD  0xC000
Payload           2 WORD  CRC32C 16 bit atas │ 16 bit bawah
```

## Interpretasi dan validitas

- Dalam notasi parameter CRC: width 32, polinomial Castagnoli `0x1EDC6F41`, refin/refout true, init `0xffffffff`, xorout `0xffffffff`.
- Bilangan bulat unsigned 32 bit hasil perhitungan disimpan dalam urutan WORD big-endian. Serialisasi ini bukan penataan field Checksum SCTP RFC 3309 atau pemetaan byte digest iSCSI RFC 3720 itu sendiri.
- Jika Payload bukan 2 WORD, ditolak.

## Dasar standar

- Perhitungan CRC-32C serta aturan polinomial Castagnoli·refleksi mengikuti definisi CRC32C pada [RFC 3309](https://www.rfc-editor.org/rfc/rfc3309.html) dan [RFC 3720](https://www.rfc-editor.org/rfc/rfc3720.html).
- Framing TAG, Length, dan WORD big-endian 16 bit untuk bilangan bulat 32 bit hasil perhitungan GEUL adalah aturan yang ditambahkan format ini.

## Panjang

- Total tepat 5 WORD, yaitu jumlah TAG 1 WORD, Issuer 1 WORD, nomor format 1 WORD, dan Payload 2 WORD, dengan panjang langsung `LLLL=0100`. Tidak ada Length extension TAG, descriptor, dan padding.
- Jika Payload bukan tepat 2 WORD, ditolak.

## Contoh

Check value CRC-32C `0xe3069283` dari ASCII `123456789`:

```
0A7C 0020 C000 e306 9283
```
