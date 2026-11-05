---
title: "TAI-TIMESTAMP-NANOSECONDS"
weight: 1021
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "TAI-TIMESTAMP-NANOSECONDSは、同じ TAI epoch 1970-01-01T00:00:00 TAI からの signed nanosecond 数である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TAI-TIMESTAMP-NANOSECONDSは、同じ TAI epoch `1970-01-01T00:00:00 TAI` からの signed nanosecond 数である。この累積 count の表現は BIPM の標準 wire format ではなく、TAI 時間尺度を固定幅の signed int64 にマッピングした GEUL 固有の profile である。

## レイアウト {#레이아웃}

- コード: Value `VALUE-ISSUER-2WORD`(`0x09DL`)、Issuer `0x00000013` BIPM、Codec 番号 `0x00004001`。系列 TIME。

```
TAG WORD          0x09D8 (0000 1001 1101 1000)  全体 9 WORD
Issuer            2 WORD  0x00000013 (BIPM)
Codec 番号        2 WORD  0x00004001
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## 解釈と有効性 {#해석과-유효성}

- Payload 4 WORD 全体を、big-endian WORD 順の64ビット2の補数 signed count として読む。
- 有効範囲は `-2^63`~`2^63-1`ns である。負の値は GEUL が定めた epoch より前の TAI instant である。
- 小さい値でも常に4 WORD を用いる。UTC offset や leap-second table は格納しない。

## 長さ {#길이}

- 全体は TAG 1 WORD、Issuer 2 WORD、Codec 番号 2 WORD と Payload 4 WORD を合わせた正確に9 WORD であり、直接長 `LLLL=1000` を用いる。Length 拡張 TAG、descriptor、padding はない。
- Payload が正確に4 WORD でなければ拒否する。

## 例 {#예시}

- GEUL の TAI epoch は Payload `0000 0000 0000 0000`、全体9 WORD、`LLLL=1000` である。
- epoch の1ns 後は Payload `0000 0000 0000 0001` である。
- epoch の1ns 前は Payload `FFFF FFFF FFFF FFFF` である。

## 標準上の根拠と形式上の位置づけ {#표준-근거와-형식-지위}

- [BIPM SI Brochure, 9th edition](https://www.bipm.org/documents/20126/41483022/SI-Brochure-9-EN.pdf/2d2b50bf-f2b4-9661-f402-5f9d66e4b507?version=1.10) は、SI second と International Atomic Time(TAI)の時間尺度を規定する。
- BIPM は `1970-01-01 TAI` epoch からの signed int64 の累積 nanosecond やその wire encoding を定義しない。epoch、単位ごとの count、signed int64 と GEUL の big-endian WORD 配置は GEUL 固有のマッピングである。
- 固定幅の int64 は、他の TIME count profile との交換上の一貫性のために選んだものであり、BIPM の形式をそのまま再現したという意味ではない。
