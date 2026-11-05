---
title: "COMPLEX64"
weight: 1004
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "COMPLEX64 adalah Value yang menyatakan bilangan kompleks dengan dua komponen IEEE 754 binary32 berurutan (real, imag)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COMPLEX64 adalah Value yang menyatakan bilangan kompleks dengan dua komponen IEEE 754 binary32 berurutan `(real, imag)`. Value `VALUE-ISSUER-2WORD`(`0x09DL`), Issuer `0x00000002` ADHOC, nomor Codec `0x00000700`, keluarga NUMERIC.

## Layout {#레이아웃}

```
TAG WORD          0x09D8 (0000 1001 1101 1000)  total 9 WORD
Issuer            2 WORD  0x00000002 (ADHOC)
Nomor Codec       2 WORD  0x00000700
Payload           [real binary32: 2 WORD][imag binary32: 2 WORD]
```

## Interpretasi dan validitas {#해석과-유효성}

- Setiap komponen adalah interchange bits binary32 dengan urutan WORD big-endian.
- Pola bit, termasuk payload NaN dan signed zero, dipertahankan apa adanya, dan tidak ada ABI padding.
- Payload tepat 4 WORD. Semua pola bit interchange dari kedua komponen binary32 dipertahankan.

## Dasar standar dan status format {#표준-근거와-형식-지위}

- Makna `complex64` sebagai komponen real 32 bit dan komponen imaginer 32 bit mengikuti [ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html), dan urutan real-first sama dengan complex raw-data mapping pada [ONNX TensorProto schema](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3) resmi. Pola bit setiap komponen mengikuti [IEEE 754 binary32](https://standards.ieee.org/ieee/754/6210/).
- ONNX raw data berupa little-endian berlebar tetap, tetapi format ini memakai framing WORD big-endian GEUL, sehingga bukan wire serialization ONNX TensorProto itu sendiri.

## Panjang {#길이}

- Totalnya tepat 9 WORD, yaitu jumlah TAG 1 WORD, Issuer 2 WORD, nomor Codec 2 WORD, dan Payload 4 WORD, dengan panjang langsung `LLLL=1000`. Tidak ada TAG ekstensi Length, descriptor, maupun padding.
- Jika Payload tidak tepat 4 WORD, nilai ditolak.

## Contoh {#예시}

- Payload `3F80 0000 4000 0000` adalah `1.0 + 2.0i`.
