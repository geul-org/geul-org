---
title: "POINT2-BINARY64"
weight: 1017
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "POINT2-BINARY64は、(x, y) の順に並ぶ IEEE 754 binary64 の2成分からなる2次元の点である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POINT2-BINARY64は、`(x, y)` の順に並ぶ IEEE 754 binary64 の2成分からなる2次元の点である。

## レイアウト {#레이아웃}

- コード: Value `VALUE-ISSUER-2WORD`(`0x09DL`)、Issuer `0x00000002` ADHOC、Codec 番号 `0x0000050A`。系列 NUMERIC。

```
TAG WORD          0x09DC (0000 1001 1101 1100)  全体 13 WORD
Issuer            2 WORD  0x00000002 (ADHOC)
Codec 番号        2 WORD  0x0000050A
Payload: [x binary64: 4 WORD][y binary64: 4 WORD]
```

## 解釈規則 {#해석-규칙}

- 各成分は上位 WORD から読み、NaN payload と signed zero の bit pattern を保存する。
- CRS、軸の意味・順序および単位は外部の文脈である。ABI padding はない。

## 有効性 {#유효성}

- Payload は正確に8 WORD であり、4 WORD ずつの各区間は binary64 interchange bits である。

## 標準上の根拠と形式上の位置づけ {#표준-근거와-형식-지위}

- 点の `x, y` の座標順は OGC [GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html) の Point/WKB axis order を参考にし、各成分は [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/) に従う。
- この Payload は WKB の type/byte-order header や GeoPackage header を含まない GEUL compact profile であり、OGC WKB wire format ではない。CRS、軸の意味および単位は外部の文脈である。

## 長さ {#길이}

- 全体は TAG 1 WORD、Issuer 2 WORD、Codec 番号 2 WORD と Payload 8 WORD を合わせた正確に13 WORD であり、直接長 `LLLL=1100` を用いる。Length 拡張 TAG、descriptor、padding はない。
- Payload が正確に8 WORD でなければ拒否する。

## 例 {#예시}

- Payload `3FF0 0000 0000 0000 4000 0000 0000 0000` は `(1.0, 2.0)` である。
