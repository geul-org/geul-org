---
title: "COMPLEX64"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "COMPLEX64 は、実部・虚部の binary32 二つの成分で複素数を収める固定 7 WORD の ADHOC Issuer 形式だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COMPLEX64 は、`(real, imag)` 順の IEEE 754 binary32 二つの成分で複素数を表す Value だ。Value `ISSUER-1WORD`(`0x7C`)、Issuer `0x0001` ADHOC、形式番号 `0x0700`、系列 NUMERIC だ。

## レイアウト

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  全体 7 WORD
Issuer            1 WORD  0x0001 (ADHOC)
形式番号          1 WORD  0x0700
Payload           [real binary32: 2 WORD][imag binary32: 2 WORD]
```

## 解釈と有効性

- 各成分は big-endian WORD 順の binary32 interchange bits だ。
- NaN payload と signed zero を含む bit pattern をそのまま保存し、ABI padding はない。
- Payload はちょうど 4 WORD だ。二つの binary32 成分のすべての interchange bit pattern を保存する。

## 標準の根拠と形式の位置づけ

- `complex64` が 32bit の real 成分と 32bit の imaginary 成分からなるという意味は [ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html) に従い、real-first の順序は、公式の [ONNX TensorProto schema](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3) の complex raw-data mapping と同じだ。各成分の bit pattern は [IEEE 754 binary32](https://standards.ieee.org/ieee/754/6210/) に従う。
- ONNX の raw data は fixed-width little-endian だが、この形式は GEUL の big-endian WORD framing を使うので、ONNX TensorProto の wire serialization そのものではない。

## 長さ

- 全体は、TAG 1 WORD、Issuer 1 WORD、形式番号 1 WORD、Payload 4 WORD を合わせたちょうど 7 WORD で、直接長さ `LLLL=0110` を使う。Length 拡張 TAG、descriptor、padding はない。
- Payload がちょうど 4 WORD でなければ拒否する。

## 例

- Payload `3f80 0000 4000 0000` は `1.0 + 2.0i` だ。
