---
title: "SIGNED-DECIMAL"
weight: 17
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "SIGNED-DECIMAL は、signed 32ビットの指数 E と最小 WORD の2の補数係数 C で、正確な10進数 C×10^E を収める Value だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SIGNED-DECIMAL は、符号付き coefficient を持つ正確な10進数(exact decimal)の Value だ。Value 直接コード `0x10`、系列 DECIMAL だ。Payload の最初の 2 WORD は signed 32bit の10進 exponent `E`、残りは最小 WORD の2の補数 coefficient `C` で、値は `C×10^E` だ。

## レイアウト

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x10
[Length 拡張 TAG] 全体が 15 WORD 以上のとき
Payload WORD 1st–2nd (32ビット)       Signed Base-10 Exponent E
Payload WORD 3rd–Nth (1 WORD 以上)    Signed Two's-complement Coefficient C
```

## 解釈

- `E` は、上位 WORD から記録した signed 32bit big-endian の2の補数整数だ。
- `C` は、残りの WORD 全体を上位 WORD から連ねた任意精度の2の補数整数だ。
- `C` は [SIGNED-INTEGER](/ja/grammar/value/numeric/signed-integer/) と同じ最小 WORD 規則に従う。消せる先頭の `0000` または `ffff` WORD は禁止する。

## 長さと有効性

- 全体は、TAG 1 WORD、Length 拡張 TAG(あれば)、Payload を合わせた WORD 数だ。14 WORD 以下は直接長さ、15 WORD 以上は `1110`・`1111` の拡張長さを使い、拡張 TAG も全体の数に入る([レコードと TAG WORD](/ja/grammar/record/))。
- Payload は exponent 2 WORD と coefficient 1 WORD 以上なので、最小 3 WORD だ。
- バイト表現の正規性は、coefficient の最小 WORD 表現だけを検査する。

## 例

| 値の表現 | Payload (`E` + `C`) | 判定 |
|---|---|---|
| `1×10^0` | `0000 0000 0001` | バイト表現として正規 |
| `10×10^-1` | `ffff ffff 000a` | バイト表現として正規、上の表現との canonical 関係は未解決の問題 |
| `1×10^0` | `0000 0000 0000 0001` | 非正規: coefficient の先頭の `0000` は不要 |
| Payload 7 WORD | 直接長さ `LLLL=0111`、全体 8 WORD | 正規の長さ構造 |

## 形式の位置づけ

- signed 32ビットの exponent `E` と最小 WORD の coefficient `C` を束ねたこの配置は、IEEE 754 decimal interchange や Apache Parquet `DECIMAL` ではない、GEUL 固有の形式だ。
- Parquet `DECIMAL` は `unscaledValue × 10^(-scale)` と必須の precision/scale metadata を使い、byte-array 物理型の unscaled value を big-endian の2の補数で保存し、scale は 0 以上だ。この形式は signed な `E` を本体に入れ、precision metadata がないので、同じ形式ではない。
- IEEE 754 decimal や Parquet `DECIMAL` とやり取りするには、範囲、precision/scale、quantum、特殊値のポリシーを定めた明示的な変換が必要だ。
- 比較の根拠: [IEEE 754-2019](https://standards.ieee.org/ieee/754/6210/)、[Apache Parquet Logical Types — DECIMAL](https://parquet.apache.org/docs/file-format/types/logicaltypes/)

## 未解決の問題

- `10×10^-1` と `1×10^0` のように、同じ数を表す exponent/coefficient の組が複数ある。
- この形式が quantum を保存するか、値の同値性をどう判定するか、canonical exponent をどう正規化するかは、まだ決めていない。
- そのため実装は、coefficient の最小 WORD 規則の外にある exponent/coefficient の正規化を、勝手に強制してはならない。
