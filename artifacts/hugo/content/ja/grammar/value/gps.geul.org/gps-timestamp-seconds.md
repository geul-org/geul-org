---
title: "GPS-TIMESTAMP-SECONDS"
weight: 1024
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GPS-TIMESTAMP-SECONDSは、GPS epoch 1980-01-06T00:00:00 GPS からの signed second 数である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GPS-TIMESTAMP-SECONDSは、GPS epoch `1980-01-06T00:00:00 GPS` からの signed second 数である。GPS week 番号で割ったり、broadcast field の week rollover 幅で切り詰めたりしない。

この累積 count の表現は IS-GPS-200 の broadcast wire format ではなく、GPS 時間尺度を固定幅の signed int64 にマッピングした GEUL 固有の profile である。

## レイアウト {#레이아웃}

- コード: Value `VALUE-ISSUER-2WORD`(`0x09DL`)、Issuer `0x00000016` GPS、Codec 番号 `0x00004000`。系列 TIME。

```
TAG WORD          0x09D8 (0000 1001 1101 1000)  全体 9 WORD
Issuer            2 WORD  0x00000016 (GPS)
Codec 番号        2 WORD  0x00004000
Payload WORD 1st (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Seconds
Payload WORD 3rd (bits 31..16)     Signed Seconds
Payload WORD 4th (bits 15..0)      Signed Seconds low 16bit
```

## 解釈と有効性 {#해석과-유효성}

- Payload 4 WORD 全体を、big-endian WORD 順の64ビット2の補数 signed count として読む。
- 有効範囲は `-2^63`~`2^63-1`秒である。負の値は GPS epoch より前の GPS-time instant である。
- count は epoch から続く連続値である。broadcast の week-number field の truncation や rollover は適用しない。
- 小さい値でも常に4 WORD を用いる。UTC 変換パラメータは含めない。

## 長さ {#길이}

- 全体は TAG 1 WORD、Issuer 2 WORD、Codec 番号 2 WORD と Payload 4 WORD を合わせた正確に9 WORD であり、直接長 `LLLL=1000` を用いる。Length 拡張 TAG、descriptor、padding はない。
- Payload が正確に4 WORD でなければ拒否する。

## 例 {#예시}

- GPS epoch は Payload `0000 0000 0000 0000`、全体9 WORD、`LLLL=1000` である。
- epoch の1秒後は Payload `0000 0000 0000 0001` である。
- epoch の1秒前は Payload `FFFF FFFF FFFF FFFF` である。

## 標準上の根拠と形式上の位置づけ {#표준-근거와-형식-지위}

- [GPS.gov Technical Documentation](https://www.gps.gov/technical-documentation) は、GPS インタフェース仕様の公式配布先である。
- [IS-GPS-200N](https://archive.gps.gov/technical/icwg/IS-GPS-200N.pdf) は、GPS time が連続した時間尺度であり、week 0 が 1980-01-06 の午前0時に始まることを定め、GPS week number と time-of-week/Z-count の broadcast field を定義する。
- IS-GPS-200 は、現行 epoch の累積 signed int64 wire representation を定義しない。rollover を適用しない連続 count、signed int64 と GEUL の big-endian WORD 配置は GEUL 固有のマッピングである。
