---
title: "POINT2-BINARY64"
weight: 1011
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "POINT2-BINARY64 是由 (x, y) 顺序的 IEEE 754 binary64 两个分量构成的二维点 Value（ADHOC Issuer 格式 0x050A）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POINT2-BINARY64 是由 `(x, y)` 顺序的 IEEE 754 binary64 两个分量构成的二维点。

## 布局

- 码：Value `ISSUER-1WORD`（`0x7C`），Issuer `0x0001` ADHOC，格式编号 `0x050A`。系列 NUMERIC。

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  总计 11 WORD
Issuer            1 WORD  0x0001 (ADHOC)
格式编号          1 WORD  0x050A
Payload: [x binary64: 4 WORD][y binary64: 4 WORD]
```

## 解读规则

- 每个分量从高位 WORD 起读取，保留 NaN payload 和 signed zero bit pattern。
- CRS、轴的含义·顺序和单位属于外部上下文。没有 ABI padding。

## 有效性

- Payload 恰好是 8 WORD，每个 4 WORD 区间是 binary64 interchange bits。

## 标准依据与格式地位

- 点的 `x, y` 坐标顺序参考 OGC [GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html) 的 Point/WKB axis order，每个分量遵循 [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/)。
- 这个 Payload 是不承载 WKB type/byte-order header 或 GeoPackage header 的 GEUL compact profile，不是 OGC WKB wire format。CRS、轴的含义和单位属于外部上下文。

## 长度

- 总计是 TAG 1 WORD、Issuer 1 WORD、格式编号 1 WORD 与 Payload 8 WORD 之和，恰好 11 WORD，使用直接长度 `LLLL=1010`。没有 Length 扩展 TAG、descriptor、padding。
- Payload 不是恰好 8 WORD 则拒绝。

## 示例

- Payload `3ff0 0000 0000 0000 4000 0000 0000 0000` 是 `(1.0, 2.0)`。
