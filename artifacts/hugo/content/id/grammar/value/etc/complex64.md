---
title: "COMPLEX64"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "COMPLEX64 adalah format Issuer ADHOC 7 WORD tetap yang memuat bilangan kompleks dengan dua komponen binary32, bagian riil dan imajiner."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COMPLEX64 adalah Value yang menyatakan bilangan kompleks dengan dua komponen IEEE 754 binary32 dalam urutan `(real, imag)`. Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, nomor format `0x0700`, keluarga NUMERIC.

## Layout

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  total 7 WORD
Issuer            1 WORD  0x0001 (ADHOC)
Nomor format      1 WORD  0x0700
Payload           [real binary32: 2 WORD][imag binary32: 2 WORD]
```

## Interpretasi dan validitas

- Setiap komponen adalah interchange bits binary32 dalam urutan WORD big-endian.
- Pola bit termasuk payload NaN dan signed zero dipertahankan apa adanya, dan tidak ada padding ABI.
- Payload tepat 4 WORD. Semua pola bit interchange kedua komponen binary32 dipertahankan.

## Dasar standar dan status format

- Bahwa `complex64` terdiri dari komponen real 32 bit dan komponen imaginary 32 bit mengikuti [ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html), dan urutan real-first sama dengan pemetaan raw-data complex pada [skema ONNX TensorProto](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3) resmi. Pola bit setiap komponen mengikuti [IEEE 754 binary32](https://standards.ieee.org/ieee/754/6210/).
- Raw data ONNX adalah little-endian berlebar tetap, tetapi format ini memakai framing WORD big-endian GEUL sehingga bukan serialisasi wire ONNX TensorProto itu sendiri.

## Panjang

- Total tepat 7 WORD, yaitu jumlah TAG 1 WORD, Issuer 1 WORD, nomor format 1 WORD, dan Payload 4 WORD, dengan panjang langsung `LLLL=0110`. Tidak ada Length extension TAG, descriptor, dan padding.
- Jika Payload bukan tepat 4 WORD, ditolak.

## Contoh

- Payload `3f80 0000 4000 0000` adalah `1.0 + 2.0i`.
