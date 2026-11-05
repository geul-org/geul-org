---
title: "POSIX-TIMESTAMP-NANOSECONDS"
weight: 1032
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "POSIX-TIMESTAMP-NANOSECONDSは、Unix epoch 1970-01-01T00:00:00Z からの signed nanosecond 数である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POSIX-TIMESTAMP-NANOSECONDSは、Unix epoch `1970-01-01T00:00:00Z` からの signed nanosecond 数である。POSIX の seconds-since-the-Epoch と同様に、すべての日を正確に86,400秒とみなし、うるう秒を数えない。

## レイアウト {#레이아웃}

- コード: Value `VALUE-ISSUER-2WORD`(`0x09DL`)、Issuer `0x0000000D` IEEE、Codec 番号 `0x00004000`。系列 TIME。
- 産業データ交換のため、Parquet `TIMESTAMP(isAdjustedToUTC=true, unit=NANOS)` と同じ固定幅の signed int64 物理型を用いる。

```
TAG WORD          0x09D8 (0000 1001 1101 1000)  全体 9 WORD
Issuer            2 WORD  0x0000000D (IEEE)
Codec 番号        2 WORD  0x00004000
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## 解釈と有効性 {#해석과-유효성}

- Payload 4 WORD 全体を、big-endian WORD 順の64ビット2の補数 signed count として読む。
- 有効範囲は `-2^63`~`2^63-1`ns であり、instant の範囲は `1677-09-21 00:12:43.145224192Z`~`2262-04-11 23:47:16.854775807Z` である。
- 小さい値でも常に4 WORD を用いる。最小の WORD 整数表現に縮めてはならない。
- timezone、元の UTC offset、うるう秒の label、leap-second table は含めない。

## 長さ {#길이}

- 全体は TAG 1 WORD、Issuer 2 WORD、Codec 番号 2 WORD と Payload 4 WORD を合わせた正確に9 WORD であり、直接長 `LLLL=1000` を用いる。Length 拡張 TAG、descriptor、padding はない。
- Payload が正確に4 WORD でなければ拒否する。

## 例 {#예시}

- epoch は Payload `0000 0000 0000 0000`、全体9 WORD、`LLLL=1000` である。
- epoch の1ns 後は Payload `0000 0000 0000 0001` である。
- epoch の1ns 前は Payload `FFFF FFFF FFFF FFFF` である。

## 標準上の根拠 {#표준-근거}

- [POSIX.1-2024 `timespec`](https://pubs.opengroup.org/onlinepubs/9799919799/functions/V2_chap02.html) は、`time_t tv_sec` と `long tv_nsec` のメンバー、および `0 <= tv_nsec < 10^9` を定義する。`time_t` の具体的な幅と表現は実装環境に依存し、2つのメンバーを合わせた累積 nanosecond の signed int64 wire format は定義しない。
- [POSIX.1-2024 Seconds Since the Epoch](https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap04.html) は、1日を正確に86,400秒とみなす。
- [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) の `TIMESTAMP(isAdjustedToUTC=true, unit=NANOS)` は、Unix epoch からの nanosecond を単一の `int64` に格納する。GEUL はこの物理型に、TAG と big-endian 16ビット WORD の framing だけを加える。
