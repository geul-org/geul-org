---
title: "UNSIGNED-DECIMAL (0x069L)"
weight: 105
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "UNSIGNED-DECIMAL は符号なし coefficient を持つ正確な 10 進数(exact decimal)Value である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `UNSIGNED-DECIMAL` (規格ドキュメント BIND `UNSIGNED-DECIMAL`) |
| TAG ID | `0x069L` |
| Codec ID | `0x00000690` |
| 規格ドキュメント | `0x00000000/codecs/0x00000690/` (DECLARE 対象 `0690`) |
| セクション | 3 `0011` (Value)、セクション内オフセット C = 9 |
| Kind | Value · 系列: DECIMAL |
| TAG WORD | `0000 0110 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引説明 | signed exponent `E` と最小 WORD unsigned coefficient `C` による `C×10^E` |
| Hugo 側 | `value/decimal/unsigned-decimal.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `exponent` | #2 | 生値 2 WORD |  |  |
| 2 | `coefficient` | #3 | 残りの生値(`0xFFFF`) |  |  |

UNSIGNED-DECIMAL は符号なし coefficient を持つ正確な 10 進数(exact decimal)Value である。Value 直接コード `0x069L`、系列 DECIMAL である。Payload の最初の 2 WORD は signed 32bit の 10 進 exponent `E`、残りは最小 WORD の unsigned coefficient `C` で、値は `C×10^E` である。

## レイアウト {#레이아웃}

```
TAG WORD          0000 0110 1001 LLLL      Codec 0x069L
[Length 拡張 TAG] 全体が 15 WORD 以上のとき
Payload WORD 1st–2nd (32 ビット)     Signed Base-10 Exponent E
Payload WORD 3rd–Nth (1 WORD 以上)   Unsigned Coefficient C
```

## 解釈 {#해석}

- `E` は上位 WORD から記録した signed 32bit big-endian 2 の補数整数である。
- `C` は残りの WORD 全体を上位 WORD から読んだ任意精度の unsigned magnitude である。
- `C` は [UNSIGNED-INTEGER](0x062L-unsigned-integer.md) と同じ最小 WORD 規則に従う。0 は `0000` であり、2 WORD 以上で最初の WORD が `0000` なのは禁止する。

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
| 負の coefficient | 該当なし | invalid |

## 形式の位置づけ {#형식-지위}

- signed 32 ビット exponent `E` と unsigned 最小 WORD coefficient `C` を組み合わせたこの配置は、IEEE 754 decimal interchange でも Apache Parquet `DECIMAL` でもない GEUL 固有の形式である。
- Parquet `DECIMAL` は signed unscaled value、`unscaledValue × 10^(-scale)`、必須の precision/scale metadata を使い、byte-array 物理型は big-endian 2 の補数で、scale は 0 以上である。この形式は unsigned `C`、signed `E`、precision metadata の不在のため、同じ形式ではない。
- IEEE 754 decimal や Parquet `DECIMAL` とやり取りするには、符号、範囲、precision/scale、quantum、特殊値の方針を定めた明示的な変換が必要である。
- 比較の根拠: [IEEE 754-2019](https://standards.ieee.org/ieee/754/6210/), [Apache Parquet Logical Types — DECIMAL](https://parquet.apache.org/docs/file-format/types/logicaltypes/)

## 未解決の問題 {#열린-문제}

- `10×10^-1` と `1×10^0` のように、同じ数を表す exponent/coefficient の組が複数ある。
- この形式が quantum を保存するか、値の等価性をどう判定するか、canonical exponent をどう正規化するかは、まだ定めていない。
- したがって実装は、coefficient の最小 WORD 規則の外にある exponent/coefficient の正規化を恣意的に強制してはならない。

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00000690/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000069000000000
BODY
#1 DECLARE 0x0690
#2 FIELD #1 0x0002
#3 FIELD #1 rest
#4 BIND #1 "UNSIGNED-DECIMAL"
#5 BIND #2 "exponent"
#6 BIND #3 "coefficient"
```
