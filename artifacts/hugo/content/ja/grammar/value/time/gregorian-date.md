---
title: "GREGORIAN-DATE"
weight: 33
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GREGORIAN-DATE は、proleptic Gregorian の 1970-01-01 を day 0 とする signed int32 の日数 Value だ(Codec 0x20)。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GREGORIAN-DATE は、proleptic Gregorian の `1970-01-01` を day 0 とする signed の日数だ。タイムゾーンと一日の中の時刻は収めない。

## レイアウト

- コード: Value 直接コード `0x20`。系列 TIME。
- Arrow Date32、Parquet `DATE` と同じ固定幅 signed int32 の物理型を使う。

```
TAG WORD          0x0920 (0000 1001 0010 0000)  全体 3 WORD
Payload WORD 1st (bits 31..16)     Signed Day Count high 16bit
Payload WORD 2nd (bits 15..0)      Signed Day Count low 16bit
```

## 解釈と有効性

- Payload 2 WORD 全体を、big-endian WORD 順の 32ビット2の補数 signed day count として読む。
- 有効範囲は `-2^31`~`2^31-1` 日だ。負数は epoch より前の日付だ。
- day count を年・月・日に逆算するときは、歴史的な暦法の切り替えなしに、proleptic Gregorian calendar を使う。
- 小さな値も、常に 2 WORD を使う。

## 長さ

- 全体は、TAG 1 WORD と Payload 2 WORD を合わせたちょうど 3 WORD で、直接長さ `LLLL=0010` を使う。Length 拡張 TAG、descriptor、padding はない。
- Payload がちょうど 2 WORD でなければ拒否する。

## 例

| 日付 | Payload | 全体 Length |
|---|---|---:|
| `1970-01-01` | `0000 0000` | 3 WORD (`LLLL=0010`) |
| `1970-01-02` | `0000 0001` | 3 WORD (`LLLL=0010`) |
| `1969-12-31` | `ffff ffff` | 3 WORD (`LLLL=0010`) |

## EDTF との関係

- 日より粗い精度、不確実・おおよそ、区間は、[EDTF](/ja/grammar/value/time/edtf/) で書く。GREGORIAN-DATE でちょうど書ける日付は、EDTF で書かない(EDTF の正規形)。

## 標準の根拠

- [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) の `DATE` は、Unix epoch の 1970-01-01 からの日数を保存する `int32` で、signed の順序を使う。
- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) と authoritative な [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) の Date32 は、Unix epoch からの日数を 32ビット signed integer で保存する。
- proleptic Gregorian の逆算は、この形式が採用した GEUL calendar profile だ。Arrow/Parquet の int32 day-count の意味はそのままで、TAG と big-endian 16ビット WORD framing だけを加える。
