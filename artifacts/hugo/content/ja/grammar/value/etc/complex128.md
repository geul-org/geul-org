---
title: "COMPLEX128"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "COMPLEX128 は、実部・虚部の binary64 二つの成分で複素数を収める固定 11 WORD の ADHOC Issuer 形式だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COMPLEX128 は、`(real, imag)` 順の IEEE 754 binary64 二つの成分で複素数を表す Value だ。Value `ISSUER-1WORD`(`0x7C`)、Issuer `0x0001` ADHOC、形式番号 `0x0701`、系列 NUMERIC だ。

## レイアウト

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  全体 11 WORD
Issuer            1 WORD  0x0001 (ADHOC)
形式番号          1 WORD  0x0701
Payload           [real binary64: 4 WORD][imag binary64: 4 WORD]
```

## 解釈と有効性

- 各成分は big-endian WORD 順の binary64 interchange bits だ。
- NaN payload と signed zero を含む bit pattern をそのまま保存し、ABI padding はない。
- Payload はちょうど 8 WORD だ。二つの binary64 成分のすべての interchange bit pattern を保存する。

## 標準の根拠と形式の位置づけ

- `complex128` が 64bit の real 成分と 64bit の imaginary 成分からなるという意味は [ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html) に従い、real-first の順序は、公式の [ONNX TensorProto schema](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3) の complex raw-data mapping と同じだ。各成分の bit pattern は [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/) に従う。
- ONNX の raw data は fixed-width little-endian だが、この形式は GEUL の big-endian WORD framing を使うので、ONNX TensorProto の wire serialization そのものではない。

## 長さ

- 全体は、TAG 1 WORD、Issuer 1 WORD、形式番号 1 WORD、Payload 8 WORD を合わせたちょうど 11 WORD で、直接長さ `LLLL=1010` を使う。Length 拡張 TAG、descriptor、padding はない。
- Payload がちょうど 8 WORD でなければ拒否する。

## 例

- Payload の二つの binary64 が `1.0, -0.0` なら、実部 1.0、虚部 -0.0 の値だ。
