---
title: "BBOX2-BINARY64"
weight: 1000
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "BBOX2-BINARY64は、(minX, minY, maxX, maxY) の順に並ぶ IEEE 754 binary64 の4成分からなる2次元バウンディングボックスである。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BBOX2-BINARY64は、`(minX, minY, maxX, maxY)` の順に並ぶ IEEE 754 binary64 の4成分からなる2次元バウンディングボックスである。

## レイアウト {#레이아웃}

- コード: Value `VALUE-ISSUER-2WORD`(`0x09DL`)、Issuer `0x00000002` ADHOC、Codec 番号 `0x0000050C`。系列 NUMERIC。

```
TAG WORD          0x09DE (0000 1001 1101 1110)  LLLL=1110
Length 拡張 TAG   1 WORD  0x0016 (全体 22 WORD)
Issuer            2 WORD  0x00000002 (ADHOC)
Codec 番号        2 WORD  0x0000050C
Payload: [minX: 4 WORD][minY: 4 WORD][maxX: 4 WORD][maxY: 4 WORD]
```

## 解釈規則 {#해석-규칙}

- 各成分は binary64 であり、上位 WORD から読む。signed zero の bit pattern を保存する。
- CRS、軸の意味・順序および単位は外部の文脈である。ABI padding はない。

## 有効性 {#유효성}

- Payload は正確に16 WORD でなければならず、`minX ≤ maxX`、`minY ≤ maxY` でなければならない。
- NaN は比較できないので、どの成分にあっても拒否する。

## 標準上の根拠と形式上の位置づけ {#표준-근거와-형식-지위}

- 最小・最大座標の意味は OGC [GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html) の bounding envelope を参考にし、各成分は [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/) に従う。
- GeoPackage envelope の2D配列順は `[minx, maxx, miny, maxy]` である。この形式の `(minX, minY, maxX, maxY)` の順序は、その wire order ではなく GEUL が定めた compact tuple であり、WKB/GeoPackage header も含まない。CRS、軸の意味および単位は外部の文脈である。

## 長さ {#길이}

- 全体は TAG 1 WORD、Length 拡張 TAG 1 WORD、Issuer 2 WORD、Codec 番号 2 WORD、Payload 16 WORD を合わせた正確に22 WORD であり、`LLLL=1110` を用いる。descriptor と padding はない。
- Payload が正確に16 WORD でなければ拒否する。

## 例 {#예시}

- 成分が `(0.0, 1.0, 2.0, 3.0)` なら有効であり、`(2.0, 1.0, 0.0, 3.0)` なら invalid である。
