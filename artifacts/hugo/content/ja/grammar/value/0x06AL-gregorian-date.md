---
title: "GREGORIAN-DATE (0x06AL)"
weight: 106
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GREGORIAN-DATE は proleptic Gregorian 1970-01-01 を day 0 とする signed の日数である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `GREGORIAN-DATE` (規格ドキュメント BIND `GREGORIAN-DATE`) |
| TAG ID | `0x06AL` |
| Codec ID | `0x000006A0` |
| 規格ドキュメント | `0x00000000/codecs/0x000006A0/` (DECLARE 対象 `06A0`) |
| セクション | 3 `0011` (Value)、セクション内オフセット C = 10 |
| Kind | Value · 系列: TIME |
| TAG WORD | `0000 0110 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引説明 | proleptic Gregorian `1970-01-01` 基準の signed 日数 |
| Hugo 側 | `value/time/gregorian-date.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `days` | #2 | 生値 2 WORD |  |  |

GREGORIAN-DATE は proleptic Gregorian `1970-01-01` を day 0 とする signed の日数である。タイムゾーンと一日の中の時刻は保持しない。

## レイアウト {#레이아웃}

- コード: Value 直接コード `0x06AL`。系列 TIME。
- Arrow Date32、Parquet `DATE` と同じ固定幅 signed int32 の物理型を使う。

```
TAG WORD          0x06A2 (0000 0110 1010 0010)  全体 3 WORD
Payload WORD 1st (bits 31..16)     Signed Day Count high 16bit
Payload WORD 2nd (bits 15..0)      Signed Day Count low 16bit
```

## 解釈と有効性 {#해석과-유효성}

- Payload 2 WORD 全体を big-endian WORD 順の 32 ビット 2 の補数 signed day count として読む。
- 有効範囲は `-2^31`~`2^31-1` 日である。負数は epoch より前の日付である。
- day count から年・月・日を逆算するときは、歴史的な暦の切り替えなしに proleptic Gregorian calendar を使う。
- 小さな値も常に 2 WORD を使う。

## 長さ {#길이}

- 全体は TAG 1 WORD と Payload 2 WORD を合わせたちょうど 3 WORD で、直接長 `LLLL=0010` を使う。Length 拡張 TAG、descriptor、padding はない。
- Payload がちょうど 2 WORD でなければ拒否する。

## 例 {#예시}

| 日付 | Payload | 全体 Length |
|---|---|---:|
| `1970-01-01` | `0000 0000` | 3 WORD (`LLLL=0010`) |
| `1970-01-02` | `0000 0001` | 3 WORD (`LLLL=0010`) |
| `1969-12-31` | `FFFF FFFF` | 3 WORD (`LLLL=0010`) |

## EDTF との関係 {#edtf와의-관계}

- 日より粗い精度、不確実・おおよそ、区間は [EDTF](0x06EL-edtf.md) で書く。GREGORIAN-DATE で正確に書ける日付は EDTF で書かない(EDTF の正規形)。

## 標準の根拠 {#표준-근거}

- [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) の `DATE` は Unix epoch である 1970-01-01 からの日数を保存する `int32` で、signed 順序を使う。
- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) と authoritative な [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) の Date32 は、Unix epoch からの日数を 32 ビット signed integer で保存する。
- proleptic Gregorian による逆算は、この形式が採用した GEUL calendar profile である。Arrow/Parquet の int32 day-count の意味はそのままに、TAG と big-endian 16 ビット WORD のフレーミングだけを加える。

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x000006A0/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006A000000000
BODY
#1 DECLARE 0x06A0
#2 FIELD #1 0x0002
#3 BIND #1 "GREGORIAN-DATE"
#4 BIND #2 "days"
```
