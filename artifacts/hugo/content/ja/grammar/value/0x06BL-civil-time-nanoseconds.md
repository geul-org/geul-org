---
title: "CIVIL-TIME-NANOSECONDS (0x06BL)"
weight: 107
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "CIVIL-TIME-NANOSECONDS は日付のない常用時刻を、午前 0 時からの nanosecond 数で表す。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `CIVIL-TIME-NANOSECONDS` (規格ドキュメント BIND `CIVIL-TIME-NANOSECONDS`) |
| TAG ID | `0x06BL` |
| Codec ID | `0x000006B0` |
| 規格ドキュメント | `0x00000000/codecs/0x000006B0/` (DECLARE 対象 `06B0`) |
| セクション | 3 `0011` (Value)、セクション内オフセット C = 11 |
| Kind | Value · 系列: TIME |
| TAG WORD | `0000 0110 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引説明 | 暦日の午前 0 時からの unsigned nanosecond 計数 |
| Hugo 側 | `value/time/civil-time-nanoseconds.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `nanoseconds` | #2 | 生値 4 WORD |  |  |

CIVIL-TIME-NANOSECONDS は日付のない常用時刻を、午前 0 時からの nanosecond 数で表す。

## レイアウト {#레이아웃}

- コード: Value 直接コード `0x06BL`。系列 TIME。
- Parquet `TIME(isAdjustedToUTC=false, unit=NANOS)` と同じ固定幅 signed int64 の物理型を使う。

```
TAG WORD          0x06B4 (0000 0110 1011 0100)  全体 5 WORD
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## 解釈と有効性 {#해석과-유효성}

- Payload 4 WORD 全体を big-endian WORD 順の 64 ビット 2 の補数 signed count として読む。
- 物理型は signed int64 だが、有効範囲は `0 <= value < 86,400×10^9` ns である。負数と上限以上は拒否する。
- `24:00` と閏秒 label は許可しない。日付、タイムゾーン、UTC offset も保持しない。
- 小さな値も常に 4 WORD を使う。

## 長さ {#길이}

- 全体は TAG 1 WORD と Payload 4 WORD を合わせたちょうど 5 WORD で、直接長 `LLLL=0100` を使う。Length 拡張 TAG、descriptor、padding はない。
- Payload がちょうど 4 WORD でなければ拒否する。

## 例 {#예시}

- 午前 0 時は Payload `0000 0000 0000 0000`、全体 5 WORD、`LLLL=0100` である。
- 午前 0 時の 1 ns 後は Payload `0000 0000 0000 0001` である。
- `86,400×10^9` ns は上限と等しいので有効ではない。
- `FFFF FFFF FFFF FFFF` は signed int64 で -1 なので有効ではない。

## 標準の根拠 {#표준-근거}

- [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) の `TIME(isAdjustedToUTC=false, unit=NANOS)` は、local time の午前 0 時からの nanosecond を `int64` に保存し、signed 順序を使う。
- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) の authoritative な [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) は、NANOSECOND Time を 64 ビット signed integer と定義し、有効範囲を午前 0 時を含み 86,400 秒未満に制限して、閏秒を許可しない。GEUL は TAG と big-endian 16 ビット WORD のフレーミングだけを加える。

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x000006B0/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006B000000000
BODY
#1 DECLARE 0x06B0
#2 FIELD #1 0x0004
#3 BIND #1 "CIVIL-TIME-NANOSECONDS"
#4 BIND #2 "nanoseconds"
```
