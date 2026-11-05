---
title: "SIGNED-DECIMAL (0x068L)"
weight: 104
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "SIGNED-DECIMAL は符号付き coefficient を持つ正確な 10 進数(exact decimal)Value である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `SIGNED-DECIMAL` (規格ドキュメント BIND `SIGNED-DECIMAL`) |
| TAG ID | `0x068L` |
| Codec ID | `0x00000680` |
| 規格ドキュメント | `0x00000000/codecs/0x00000680/` (DECLARE 対象 `0680`) |
| セクション | 3 `0011` (Value)、セクション内オフセット C = 8 |
| Kind | Value · 系列: DECIMAL |
| TAG WORD | `0000 0110 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引説明 | signed exponent `E` と最小 WORD の 2 の補数 coefficient `C` による `C×10^E` |
| Hugo 側 | `value/decimal/signed-decimal.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `exponent` | #2 | 生値 2 WORD |  |  |
| 2 | `coefficient` | #3 | 残りの生値(`0xFFFF`) |  |  |

SIGNED-DECIMAL は符号付き coefficient を持つ正確な 10 進数(exact decimal)Value である。Value 直接コード `0x068L`、系列 DECIMAL である。Payload の最初の 2 WORD は signed 32bit の 10 進 exponent `E`、残りは最小 WORD の 2 の補数 coefficient `C` で、値は `C×10^E` である。

## レイアウト {#레이아웃}

```
TAG WORD          0000 0110 1000 LLLL      Codec 0x068L
[Length 拡張 TAG] 全体が 15 WORD 以上のとき
Payload WORD 1st–2nd (32 ビット)     Signed Base-10 Exponent E
Payload WORD 3rd–Nth (1 WORD 以上)   Signed Two's-complement Coefficient C
```

## 解釈 {#해석}

- `E` は上位 WORD から記録した signed 32bit big-endian 2 の補数整数である。
- `C` は残りの WORD 全体を上位 WORD から連結した任意精度の 2 の補数整数である。
- `C` は [SIGNED-INTEGER](0x061L-signed-integer.md) と同じ最小 WORD 規則に従う。削除できる先頭の `0000` または `FFFF` WORD は禁止する。

## 長さと有効性 {#길이와-유효성}

- 全体は TAG 1 WORD、Length 拡張 TAG(あれば)、Payload を合わせた WORD 数である。14 WORD 以下は直接長、15 WORD 以上は `1110`・`1111` 拡張長を使い、拡張 TAG も全体数に含まれる([レコードと TAG WORD](../record.md))。
- Payload は exponent 2 WORD と coefficient 1 WORD 以上なので、最小 3 WORD である。
- バイト表現の正規性は、coefficient の最小 WORD 表現のみを検査する。

## 例 {#예시}

| 値の表現 | Payload (`E` + `C`) | 判定 |
|---|---|---|
| `1×10^0` | `0000 0000 0001` | バイト表現は正規 |
| `10×10^-1` | `FFFF FFFF 000A` | バイト表現は正規、上の表現との canonical 関係は未解決の問題 |
| `1×10^0` | `0000 0000 0000 0001` | 非正規: coefficient の先頭 `0000` は不要 |
| Payload 7 WORD | 直接長 `LLLL=0111`、全体 8 WORD | 正規の長さ構造 |

## 形式の位置づけ {#형식-지위}

- signed 32 ビット exponent `E` と最小 WORD coefficient `C` を組み合わせたこの配置は、IEEE 754 decimal interchange でも Apache Parquet `DECIMAL` でもない GEUL 固有の形式である。
- Parquet `DECIMAL` は `unscaledValue × 10^(-scale)` と必須の precision/scale metadata を使い、byte-array 物理型の unscaled value を big-endian 2 の補数で保存し、scale は 0 以上である。この形式は signed `E` を本文に入れ、precision metadata がないため、同じ形式ではない。
- IEEE 754 decimal や Parquet `DECIMAL` とやり取りするには、範囲、precision/scale、quantum、特殊値の方針を定めた明示的な変換が必要である。
- 比較の根拠: [IEEE 754-2019](https://standards.ieee.org/ieee/754/6210/), [Apache Parquet Logical Types — DECIMAL](https://parquet.apache.org/docs/file-format/types/logicaltypes/)

## 未解決の問題 {#열린-문제}

- `10×10^-1` と `1×10^0` のように、同じ数を表す exponent/coefficient の組が複数ある。
- この形式が quantum を保存するか、値の等価性をどう判定するか、canonical exponent をどう正規化するかは、まだ定めていない。
- したがって実装は、coefficient の最小 WORD 規則の外にある exponent/coefficient の正規化を恣意的に強制してはならない。

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00000680/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000068000000000
BODY
#1 DECLARE 0x0680
#2 FIELD #1 0x0002
#3 FIELD #1 rest
#4 BIND #1 "SIGNED-DECIMAL"
#5 BIND #2 "exponent"
#6 BIND #3 "coefficient"
```
