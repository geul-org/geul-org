---
title: "QUATERNION-BINARY32"
weight: 1019
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "QUATERNION-BINARY32は、(x, y, z, w) の順に並ぶ IEEE 754 binary32 の4成分で quaternion を表す Value である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUATERNION-BINARY32は、`(x, y, z, w)` の順に並ぶ IEEE 754 binary32 の4成分で quaternion を表す Value である。Value `VALUE-ISSUER-2WORD`(`0x09DL`)、Issuer `0x00000002` ADHOC、Codec 番号 `0x00000704`、系列 NUMERIC である。

## レイアウト {#레이아웃}

```
TAG WORD          0x09DC (0000 1001 1101 1100)  全体 13 WORD
Issuer            2 WORD  0x00000002 (ADHOC)
Codec 番号        2 WORD  0x00000704
Payload           [x: 2 WORD][y: 2 WORD][z: 2 WORD][w: 2 WORD]
```

## 解釈と有効性 {#해석과-유효성}

- 各成分は big-endian WORD 順の binary32 interchange bits である。
- frame、handedness、unit norm、`q/-q` の等価性は外部の文脈であり、この形式の意味には含まれない。
- NaN payload と signed zero の bit pattern を保存し、ABI padding はない。
- Payload は正確に8 WORD である。この形式は unit norm や `q/-q` の正規化を強制しない。

## 標準上の根拠と形式上の位置づけ {#표준-근거와-형식-지위}

- `x, y, z, w` の順序は Khronos [glTF 2.0 specification/registry](https://registry.khronos.org/glTF/) の quaternion 成分の順序と同じであり、各成分は [IEEE 754 binary32](https://standards.ieee.org/ieee/754/6210/) である。
- glTF の node rotation は、W が scalar である unit quaternion を要求する。この形式は unit norm や rotation の意味を強制しない一般の quaternion なので、外部の profile がその条件を加えない限り、glTF の rotation と同じとはみなせない。

## 長さ {#길이}

- 全体は TAG 1 WORD、Issuer 2 WORD、Codec 番号 2 WORD、Payload 8 WORD を合わせた正確に13 WORD であり、直接長 `LLLL=1100` を用いる。Length 拡張 TAG、descriptor、padding はない。
- Payload が正確に8 WORD でなければ拒否する。

## 例 {#예시}

- 成分 `(0.0, 0.0, 0.0, 1.0)` は、4つの bit pattern を順に格納した有効な値である。
