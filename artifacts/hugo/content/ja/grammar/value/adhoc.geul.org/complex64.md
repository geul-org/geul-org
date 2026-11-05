---
title: "COMPLEX64"
weight: 1004
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "COMPLEX64は、(real, imag) の順に並ぶ IEEE 754 binary32 の2成分で複素数を表す Value である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COMPLEX64は、`(real, imag)` の順に並ぶ IEEE 754 binary32 の2成分で複素数を表す Value である。Value `VALUE-ISSUER-2WORD`(`0x09DL`)、Issuer `0x00000002` ADHOC、Codec 番号 `0x00000700`、系列 NUMERIC である。

## レイアウト {#레이아웃}

```
TAG WORD          0x09D8 (0000 1001 1101 1000)  全体 9 WORD
Issuer            2 WORD  0x00000002 (ADHOC)
Codec 番号        2 WORD  0x00000700
Payload           [real binary32: 2 WORD][imag binary32: 2 WORD]
```

## 解釈と有効性 {#해석과-유효성}

- 各成分は big-endian WORD 順の binary32 interchange bits である。
- NaN payload と signed zero を含む bit pattern をそのまま保存し、ABI padding はない。
- Payload は正確に4 WORD である。2つの binary32 成分のすべての interchange bit pattern を保存する。

## 標準上の根拠と形式上の位置づけ {#표준-근거와-형식-지위}

- `complex64` が32bit の real 成分と32bit の imaginary 成分からなるという意味は [ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html) に従い、real-first の順序は公式の [ONNX TensorProto schema](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3) の complex raw-data mapping と同じである。各成分の bit pattern は [IEEE 754 binary32](https://standards.ieee.org/ieee/754/6210/) に従う。
- ONNX raw data は固定幅の little-endian であるが、この形式は GEUL の big-endian WORD framing を用いるので、ONNX TensorProto の wire serialization そのものではない。

## 長さ {#길이}

- 全体は TAG 1 WORD、Issuer 2 WORD、Codec 番号 2 WORD、Payload 4 WORD を合わせた正確に9 WORD であり、直接長 `LLLL=1000` を用いる。Length 拡張 TAG、descriptor、padding はない。
- Payload が正確に4 WORD でなければ拒否する。

## 例 {#예시}

- Payload `3F80 0000 4000 0000` は `1.0 + 2.0i` である。
