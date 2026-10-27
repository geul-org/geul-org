---
title: "GPS-TIMESTAMP-NANOSECONDS"
weight: 1006
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GPS-TIMESTAMP-NANOSECONDS は、GPS epoch 1980-01-06T00:00:00 GPS からの signed nanosecond 数を収める Value だ(GPS Issuer 形式 0x4001)。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GPS-TIMESTAMP-NANOSECONDS は、GPS epoch `1980-01-06T00:00:00 GPS` からの signed nanosecond 数だ。GPS week 番号で割ったり、broadcast field の week rollover 幅で切り詰めたりしない。

この累積 count 表現は、IS-GPS-200 の broadcast wire format ではなく、GPS 時間尺度を固定幅 signed int64 に対応づけた GEUL 固有の profile だ。

## レイアウト

- コード: Value `ISSUER-1WORD`(`0x7C`)、Issuer `0x0063` GPS、形式番号 `0x4001`。系列 TIME。

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  全体 7 WORD
Issuer            1 WORD  0x0063 (GPS)
形式番号          1 WORD  0x4001
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## 解釈と有効性

- Payload 4 WORD 全体を、big-endian WORD 順の 64ビット2の補数 signed count として読む。
- 有効範囲は `-2^63`~`2^63-1`nsだ。負数は GPS epoch より前の GPS-time instant だ。
- count は epoch から続く連続値だ。broadcast week-number field の truncation や rollover を適用しない。
- 小さな値も、常に 4 WORD を使う。UTC 変換パラメータは収めない。

## 長さ

- 全体は、TAG 1 WORD、Issuer 1 WORD、形式番号 1 WORD と Payload 4 WORD を合わせたちょうど 7 WORD で、直接長さ `LLLL=0110` を使う。Length 拡張 TAG、descriptor、padding はない。
- Payload がちょうど 4 WORD でなければ拒否する。

## 例

- GPS epoch は Payload `0000 0000 0000 0000`、全体 7 WORD、`LLLL=0110` だ。
- epoch の 1ns 後は Payload `0000 0000 0000 0001` だ。
- epoch の 1ns 前は Payload `ffff ffff ffff ffff` だ。

## 標準の根拠と形式の位置づけ

- [GPS.gov Technical Documentation](https://www.gps.gov/technical-documentation) は、GPS インターフェース規格の公式の配布元だ。
- [IS-GPS-200N](https://archive.gps.gov/technical/icwg/IS-GPS-200N.pdf) は、GPS time が連続した時間尺度で、week 0 が 1980-01-06 の午前0時に始まることを定め、GPS week number と time-of-week/Z-count の broadcast field を定義する。
- IS-GPS-200 は、epoch からの累積 nanosecond の signed int64 wire representation を定義していない。nanosecond 単位の rollover のない連続 count、signed int64 と GEUL big-endian WORD の配置は、GEUL 固有の対応づけだ。
