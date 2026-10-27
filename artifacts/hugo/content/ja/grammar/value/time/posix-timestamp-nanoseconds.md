---
title: "POSIX-TIMESTAMP-NANOSECONDS"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "POSIX-TIMESTAMP-NANOSECONDS は、Unix epoch からの signed int64 nanosecond 数を収める Value だ(IEEE Issuer 形式 0x4000)。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POSIX-TIMESTAMP-NANOSECONDS は、Unix epoch `1970-01-01T00:00:00Z` からの signed nanosecond 数だ。POSIX の seconds-since-the-Epoch のように、すべての日をちょうど 86,400 秒と見て、うるう秒を数えない。

## レイアウト

- コード: Value `ISSUER-1WORD`(`0x7C`)、Issuer `0x0040` IEEE、形式番号 `0x4000`。系列 TIME。
- 産業データ交換のために、Parquet `TIMESTAMP(isAdjustedToUTC=true, unit=NANOS)` と同じ固定幅 signed int64 の物理型を使う。

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  全体 7 WORD
Issuer            1 WORD  0x0040 (IEEE)
形式番号          1 WORD  0x4000
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## 解釈と有効性

- Payload 4 WORD 全体を、big-endian WORD 順の 64ビット2の補数 signed count として読む。
- 有効範囲は `-2^63`~`2^63-1`ns で、instant の範囲は `1677-09-21 00:12:43.145224192Z`~`2262-04-11 23:47:16.854775807Z` だ。
- 小さな値も、常に 4 WORD を使う。最小 WORD の整数表現に縮めてはならない。
- timezone、元の UTC offset、うるう秒 label、leap-second table は収めない。

## 長さ

- 全体は、TAG 1 WORD、Issuer 1 WORD、形式番号 1 WORD と Payload 4 WORD を合わせたちょうど 7 WORD で、直接長さ `LLLL=0110` を使う。Length 拡張 TAG、descriptor、padding はない。
- Payload がちょうど 4 WORD でなければ拒否する。

## 例

- epoch は Payload `0000 0000 0000 0000`、全体 7 WORD、`LLLL=0110` だ。
- epoch の 1ns 後は Payload `0000 0000 0000 0001` だ。
- epoch の 1ns 前は Payload `ffff ffff ffff ffff` だ。

## 標準の根拠

- [POSIX.1-2024 `timespec`](https://pubs.opengroup.org/onlinepubs/9799919799/functions/V2_chap02.html) は、`time_t tv_sec` と `long tv_nsec` のメンバ、`0 <= tv_nsec < 10^9` を定義する。`time_t` の具体的な幅と表現は実装環境に従い、二つのメンバを合わせた累積 nanosecond の signed int64 wire format は定義しない。
- [POSIX.1-2024 Seconds Since the Epoch](https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap04.html) は、一日をちょうど 86,400 秒と見る。
- [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) の `TIMESTAMP(isAdjustedToUTC=true, unit=NANOS)` は、Unix epoch からの nanosecond を単一の `int64` に保存する。GEUL は、この物理型に TAG と big-endian 16ビット WORD framing だけを加える。
