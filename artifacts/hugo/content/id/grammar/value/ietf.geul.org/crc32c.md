---
title: "CRC32C"
weight: 1033
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "CRC32C adalah Value berlebar tetap yang memuat hasil CRC-32C."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CRC32C adalah Value berlebar tetap yang memuat hasil CRC-32C. Value `VALUE-ISSUER-2WORD`(`0x09DL`), Issuer `0x00000007` IETF, nomor Codec `0x0000C000`, keluarga BINARY. Payload tepat 2 WORD (32 bit).

## Layout {#레이아웃}

```
TAG WORD          0x09D6 (0000 1001 1101 0110)  total 7 WORD
Issuer            2 WORD  0x00000007 (IETF)
Nomor Codec       2 WORD  0x0000C000
Payload           2 WORD  CRC32C 16bit atas │ 16bit bawah
```

## Interpretasi dan validitas {#해석과-유효성}

- Dalam notasi parameter CRC: width 32, polinomial Castagnoli `0x1EDC6F41`, refin/refout true, init `0xFFFFFFFF`, xorout `0xFFFFFFFF`.
- Bilangan bulat unsigned 32bit hasil perhitungan disimpan dengan urutan WORD big-endian. Serialisasi ini bukan penempatan field Checksum SCTP pada RFC 3309 maupun pemetaan byte digest iSCSI pada RFC 3720.
- Jika Payload bukan 2 WORD, nilai ditolak.

## Dasar standar {#표준-근거}

- Perhitungan CRC-32C serta polinomial Castagnoli dan aturan refleksinya mengikuti definisi CRC32C pada [RFC 3309](https://www.rfc-editor.org/rfc/rfc3309.html) dan [RFC 3720](https://www.rfc-editor.org/rfc/rfc3720.html).
- TAG GEUL, Length, dan framing WORD big-endian 16bit untuk bilangan bulat 32bit hasil perhitungan adalah aturan yang ditambahkan format ini.

## Panjang {#길이}

- Totalnya tepat 7 WORD, yaitu jumlah TAG 1 WORD, Issuer 2 WORD, nomor Codec 2 WORD, dan Payload 2 WORD, dengan panjang langsung `LLLL=0110`. Tidak ada TAG ekstensi Length, descriptor, maupun padding.
- Jika Payload tidak tepat 2 WORD, nilai ditolak.

## Contoh {#예시}

Check value CRC-32C untuk ASCII `123456789` adalah `0xE3069283`:

```
09D6 0000 0007 0000 C000 E306 9283
```
