---
title: "CIVIL-TIME-NANOSECONDS"
weight: 34
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "CIVIL-TIME-NANOSECONDS は、日付のない民事時刻を、午前0時以降の nanosecond 数で収める Value だ(Codec 0x21)。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CIVIL-TIME-NANOSECONDS は、日付のない民事時刻を、午前0時以降の nanosecond 数で表す。

## レイアウト

- コード: Value 直接コード `0x21`。系列 TIME。
- Parquet `TIME(isAdjustedToUTC=false, unit=NANOS)` と同じ固定幅 signed int64 の物理型を使う。

```
TAG WORD          0x0A21 (0000 1010 0010 0001)  全体 5 WORD
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## 解釈と有効性

- Payload 4 WORD 全体を、big-endian WORD 順の 64ビット2の補数 signed count として読む。
- 物理型は signed int64 だが、有効範囲は `0 <= value < 86,400×10^9`ns だ。負数と上限以上は拒否する。
- `24:00` とうるう秒の label は許さない。日付、タイムゾーン、UTC offset も収めない。
- 小さな値も、常に 4 WORD を使う。

## 長さ

- 全体は、TAG 1 WORD と Payload 4 WORD を合わせたちょうど 5 WORD で、直接長さ `LLLL=0100` を使う。Length 拡張 TAG、descriptor、padding はない。
- Payload がちょうど 4 WORD でなければ拒否する。

## 例

- 午前0時は Payload `0000 0000 0000 0000`、全体 5 WORD、`LLLL=0100` だ。
- 午前0時の 1ns 後は Payload `0000 0000 0000 0001` だ。
- `86,400×10^9`ns は上限と同じなので有効ではない。
- `ffff ffff ffff ffff` は signed int64 で -1 なので有効ではない。

## 標準の根拠

- [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) の `TIME(isAdjustedToUTC=false, unit=NANOS)` は、local time の午前0時以降の nanosecond を `int64` に保存し、signed の順序を使う。
- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) の authoritative な [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) は、NANOSECOND の Time を 64ビット signed integer と定義し、有効範囲を午前0時を含む 86,400 秒未満に制限して、うるう秒を許さない。GEUL は、TAG と big-endian 16ビット WORD framing だけを加える。
