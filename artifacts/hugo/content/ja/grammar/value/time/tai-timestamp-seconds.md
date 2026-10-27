---
title: "TAI-TIMESTAMP-SECONDS"
weight: 1003
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "TAI-TIMESTAMP-SECONDS は、1970-01-01T00:00:00 TAI からの signed SI-second 数を収める Value だ(BIPM Issuer 形式 0x4000)。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TAI-TIMESTAMP-SECONDS は、`1970-01-01T00:00:00 TAI` からの signed SI-second 数だ。この累積 count 表現は、BIPM 標準の wire format ではなく、TAI 時間尺度を固定幅 signed int64 に対応づけた GEUL 固有の profile だ。

## レイアウト

- コード: Value `ISSUER-1WORD`(`0x7C`)、Issuer `0x0060` BIPM、形式番号 `0x4000`。系列 TIME。

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  全体 7 WORD
Issuer            1 WORD  0x0060 (BIPM)
形式番号          1 WORD  0x4000
Payload WORD 1st (bits 63..48)     Signed SI Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed SI Seconds
Payload WORD 3rd (bits 31..16)     Signed SI Seconds
Payload WORD 4th (bits 15..0)      Signed SI Seconds low 16bit
```

## 解釈と有効性

- Payload 4 WORD 全体を、big-endian WORD 順の 64ビット2の補数 signed count として読む。
- 有効範囲は `-2^63`~`2^63-1`秒だ。負数は GEUL が定めた epoch より前の TAI instant だ。
- 小さな値も、常に 4 WORD を使う。UTC offset や leap-second table は保存しない。

## 長さ

- 全体は、TAG 1 WORD、Issuer 1 WORD、形式番号 1 WORD と Payload 4 WORD を合わせたちょうど 7 WORD で、直接長さ `LLLL=0110` を使う。Length 拡張 TAG、descriptor、padding はない。
- Payload がちょうど 4 WORD でなければ拒否する。

## 例

- GEUL TAI epoch は Payload `0000 0000 0000 0000`、全体 7 WORD、`LLLL=0110` だ。
- epoch の 1秒 後は Payload `0000 0000 0000 0001` だ。
- epoch の 1秒 前は Payload `ffff ffff ffff ffff` だ。

## 標準の根拠と形式の位置づけ

- [BIPM SI Brochure, 9th edition](https://www.bipm.org/documents/20126/41483022/SI-Brochure-9-EN.pdf/2d2b50bf-f2b4-9661-f402-5f9d66e4b507?version=1.10) は、SI second と International Atomic Time(TAI)の時間尺度を規定する。
- BIPM は、`1970-01-01 TAI` epoch からの signed int64 累積 count やその wire encoding を定義しない。epoch、signed int64 と GEUL big-endian WORD の配置は、GEUL 固有の対応づけだ。
- 固定幅の int64 は、他の TIME count profile との交換の一貫性のために選んだもので、BIPM の形式をそのまま再現したという意味ではない。
