---
title: "QUATERNION-BINARY32"
weight: 1005
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "QUATERNION-BINARY32 は、(x, y, z, w) 順の binary32 四つの成分で quaternion を収める固定 11 WORD の ADHOC Issuer 形式だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUATERNION-BINARY32 は、`(x, y, z, w)` 順の IEEE 754 binary32 四つの成分で quaternion を表す Value だ。Value `ISSUER-1WORD`(`0x7C`)、Issuer `0x0001` ADHOC、形式番号 `0x0704`、系列 NUMERIC だ。

## レイアウト

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  全体 11 WORD
Issuer            1 WORD  0x0001 (ADHOC)
形式番号          1 WORD  0x0704
Payload           [x: 2 WORD][y: 2 WORD][z: 2 WORD][w: 2 WORD]
```

## 解釈と有効性

- 各成分は big-endian WORD 順の binary32 interchange bits だ。
- frame、handedness、unit norm、`q/-q` の同値性は外部の文脈で、この形式の意味には含まれない。
- NaN payload と signed zero の bit pattern を保存し、ABI padding はない。
- Payload はちょうど 8 WORD だ。この形式は unit norm や `q/-q` の正規化を強制しない。

## 標準の根拠と形式の位置づけ

- `x, y, z, w` の順序は、Khronos [glTF 2.0 specification/registry](https://registry.khronos.org/glTF/) の quaternion 成分順序と同じで、各成分は [IEEE 754 binary32](https://standards.ieee.org/ieee/754/6210/) だ。
- glTF の node rotation は、W が scalar の unit quaternion を要求する。この形式は unit norm や rotation の意味を強制しない一般の quaternion なので、外部 profile がその条件を加えない限り、glTF rotation と同じとは見なせない。

## 長さ

- 全体は、TAG 1 WORD、Issuer 1 WORD、形式番号 1 WORD、Payload 8 WORD を合わせたちょうど 11 WORD で、直接長さ `LLLL=1010` を使う。Length 拡張 TAG、descriptor、padding はない。
- Payload がちょうど 8 WORD でなければ拒否する。

## 例

- 成分 `(0.0, 0.0, 0.0, 1.0)` は、四つの bit pattern を順に保存した有効な値だ。
