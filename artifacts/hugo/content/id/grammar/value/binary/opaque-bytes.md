---
title: "OPAQUE-BYTES"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "OPAQUE-BYTES adalah format Issuer GEUL yang memuat deretan byte sembarang yang tidak menetapkan sendiri makna dan formatnya."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

OPAQUE-BYTES adalah deretan byte sembarang yang makna dan formatnya tidak ditetapkan oleh format ini sendiri. Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0000` GEUL, nomor format `0xC000`·`0xC001` (byte genap·ganjil), keluarga BINARY. Jumlah byte ditetapkan oleh bit paling tidak signifikan nomor format dan jumlah WORD Payload. Yaitu `2 × jumlah WORD Payload − bit paling tidak signifikan`, dan Byte Count tidak ditaruh ([Value](/id/grammar/value/)).

## Layout

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length extension TAG] jika total 15 WORD atau lebih
Issuer            1 WORD  0x0000 (GEUL)
Nomor format      1 WORD  0xC000/0xC001
Payload WORD 1st ... Nth   byte / zero padding terakhir
```

## Interpretasi dan validitas

- Dari Payload, byte dibaca berurutan sebanyak jumlah byte. Dalam WORD, byte atas datang lebih dulu.
- Jumlah WORD Payload adalah `ceil(jumlah byte/2)`. Jika kodenya ganjil tetapi byte bawah WORD terakhir bukan `00`, ditolak.
- Jika kode genap·ganjil, jumlah WORD Payload, dan zero padding tidak saling sesuai, ditolak.

## Status format

- Pasangan kode genap·ganjil, penataan payload, dan zero padding pada WORD terakhir bukan kutipan standar industri eksternal melainkan framing khas GEUL.

## Panjang

- Total adalah jumlah WORD TAG 1 WORD, Length extension TAG (jika ada), Issuer 1 WORD, nomor format 1 WORD, dan Payload. 14 WORD atau kurang memakai panjang langsung, dan 15 WORD atau lebih memakai panjang extension `1110`·`1111` dengan extension TAG juga masuk ke jumlah total ([Record dan TAG WORD](/id/grammar/record/)).
- 0 byte ditulis dengan nomor format genap (`0xC000`) sebagai record 3 WORD tanpa Payload (TAG, Issuer, nomor format).

## Contoh

Byte `ab cd ef` adalah 3 byte (ganjil) sehingga nomor format `0xC001`, Payload `abcd ef00`. Karena total 5 WORD maka `LLLL=0100`.

```
0A7C 0000 C001 abcd ef00
```
