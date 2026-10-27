---
title: "COMPLEX128"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "COMPLEX128 adalah format Issuer ADHOC 11 WORD tetap yang memuat bilangan kompleks dengan dua komponen binary64, bagian riil dan imajiner."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COMPLEX128 adalah Value yang menyatakan bilangan kompleks dengan dua komponen IEEE 754 binary64 dalam urutan `(real, imag)`. Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, nomor format `0x0701`, keluarga NUMERIC.

## Layout

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  total 11 WORD
Issuer            1 WORD  0x0001 (ADHOC)
Nomor format      1 WORD  0x0701
Payload           [real binary64: 4 WORD][imag binary64: 4 WORD]
```

## Interpretasi dan validitas

- Setiap komponen adalah interchange bits binary64 dalam urutan WORD big-endian.
- Pola bit termasuk payload NaN dan signed zero dipertahankan apa adanya, dan tidak ada padding ABI.
- Payload tepat 8 WORD. Semua pola bit interchange kedua komponen binary64 dipertahankan.

## Dasar standar dan status format

- Bahwa `complex128` terdiri dari komponen real 64 bit dan komponen imaginary 64 bit mengikuti [ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html), dan urutan real-first sama dengan pemetaan raw-data complex pada [skema ONNX TensorProto](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3) resmi. Pola bit setiap komponen mengikuti [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- Raw data ONNX adalah little-endian berlebar tetap, tetapi format ini memakai framing WORD big-endian GEUL sehingga bukan serialisasi wire ONNX TensorProto itu sendiri.

## Panjang

- Total tepat 11 WORD, yaitu jumlah TAG 1 WORD, Issuer 1 WORD, nomor format 1 WORD, dan Payload 8 WORD, dengan panjang langsung `LLLL=1010`. Tidak ada Length extension TAG, descriptor, dan padding.
- Jika Payload bukan tepat 8 WORD, ditolak.

## Contoh

- Jika dua binary64 Payload adalah `1.0, -0.0`, nilainya adalah bagian riil 1.0 dan bagian imajiner -0.0.
