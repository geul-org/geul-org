---
title: "COMPLEX128"
weight: 1003
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "COMPLEX128 adalah Value yang menyatakan bilangan kompleks dengan dua komponen IEEE 754 binary64 berurutan (real, imag)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COMPLEX128 adalah Value yang menyatakan bilangan kompleks dengan dua komponen IEEE 754 binary64 berurutan `(real, imag)`. Value `VALUE-ISSUER-2WORD`(`0x09DL`), Issuer `0x00000002` ADHOC, nomor Codec `0x00000701`, keluarga NUMERIC.

## Layout {#레이아웃}

```
TAG WORD          0x09DC (0000 1001 1101 1100)  total 13 WORD
Issuer            2 WORD  0x00000002 (ADHOC)
Nomor Codec       2 WORD  0x00000701
Payload           [real binary64: 4 WORD][imag binary64: 4 WORD]
```

## Interpretasi dan validitas {#해석과-유효성}

- Setiap komponen adalah interchange bits binary64 dengan urutan WORD big-endian.
- Pola bit, termasuk payload NaN dan signed zero, dipertahankan apa adanya, dan tidak ada ABI padding.
- Payload tepat 8 WORD. Semua pola bit interchange dari kedua komponen binary64 dipertahankan.

## Dasar standar dan status format {#표준-근거와-형식-지위}

- Makna `complex128` sebagai komponen real 64 bit dan komponen imaginer 64 bit mengikuti [ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html), dan urutan real-first sama dengan complex raw-data mapping pada [ONNX TensorProto schema](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3) resmi. Pola bit setiap komponen mengikuti [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- ONNX raw data berupa little-endian berlebar tetap, tetapi format ini memakai framing WORD big-endian GEUL, sehingga bukan wire serialization ONNX TensorProto itu sendiri.

## Panjang {#길이}

- Totalnya tepat 13 WORD, yaitu jumlah TAG 1 WORD, Issuer 2 WORD, nomor Codec 2 WORD, dan Payload 8 WORD, dengan panjang langsung `LLLL=1100`. Tidak ada TAG ekstensi Length, descriptor, maupun padding.
- Jika Payload tidak tepat 8 WORD, nilai ditolak.

## Contoh {#예시}

- Jika dua binary64 pada Payload adalah `1.0, -0.0`, nilainya memiliki bagian real 1.0 dan bagian imaginer -0.0.
