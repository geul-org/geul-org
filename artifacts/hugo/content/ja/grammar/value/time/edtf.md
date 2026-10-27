---
title: "EDTF"
weight: 37
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "EDTF は、ISO 8601-2 拡張日付文字列で、年・月の精度、紀元前、不確実、区間のような日付を収める Value だ(Codec 0x24/0x25)。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EDTF は、[Extended Date/Time Format](https://www.loc.gov/standards/datetime/edtf.html)(米国議会図書館、ISO 8601-2:2019)の文字列で日付を収める Value だ。日より粗い精度、紀元前、不確実・おおよそ・一部不明、区間を表す。

## レイアウト

- コード: Value 直接コード `0x24`(偶数バイト)・`0x25`(奇数バイト)。系列 TIME。Payload は文字列だが TIME 系列に置いて、デコーダとインデックスが形式を知らなくても時間の値として扱えるようにする。
- バイト数は、Codec の最下位ビットと Payload WORD 数で決まる。`2 × Payload WORD 数 − 最下位ビット` で、Byte Count は置かない([Value](/ja/grammar/value/))。

```
TAG WORD          0000 1LLL L010 010P      Codec 0x24/0x25 (P = 奇数バイト)
[Length 拡張 TAG] 全体が 15 WORD 以上のとき
Payload WORD 1st ... Nth          EDTF 文字列の ASCII バイト / 奇数なら最後に 0x00
```

## 解釈と有効性

- バイト列は、EDTF Level 0・1・2 の文法に従う ASCII 文字列だ。空文字列は invalid だ。
- 例: 日 `1952-03-11`、月 `1952-03`、年 `1952`、10年 `195X`、紀元前44年 `-0043`、不確実 `1974?`、おおよそ `~1974`、区間 `1952/2001`、大きな年 `Y-13799999999`。
- 年は ISO 8601 の天文式だ。`0000` は紀元前1年、`-0043` は紀元前44年だ。歴史式の表記から移すときは、一年ずらす。
- グレゴリオ暦だ。EDTF は他の暦を扱わない。ユリウス暦のような他の暦の原表記は、[GEDCOM-DATE](/ja/grammar/value/time/gedcom-date/) で保存する。その日付と同じ日・期間をグレゴリオ暦に移した値は、EDTF や GREGORIAN-DATE で書ける。
- **正規形:** [GREGORIAN-DATE](/ja/grammar/value/time/gregorian-date/) でちょうど書ける日付、つまり修飾子(`?`、`~`、`%`)・不明な桁(`X`)・区間・`Y` プレフィックスのない `[-]YYYY-MM-DD` は、GREGORIAN-DATE で書く。そのような日付を EDTF で書けば invalid だ。同じ日が一つの形式でのみ書かれて初めて、時間としてインデックス・比較できる。
- schema は、まだ EDTF 文法を検査しない。生産者が EDTF パーサーで検査する。例: `github.com/sfomuseum/go-edtf`(BSD-3-Clause)の `parser.ParseString`。`parser.IsValid` は文法だけを見て、`2023-02-29`、`1974-13` も通すので使わない。このパーサーは、`Y` プレフィックスの年にまだ対応していない。

## 長さ

- 全体は、TAG 1 WORD、Length 拡張 TAG(あれば)と Payload を合わせた WORD 数だ([Length](/ja/grammar/record/))。

## 例

| 日付 | バイト | 全体 WORD |
|---|---|---|
| `1974` | 4 (偶数) | `0924 3139 3734` |
| `197X` | 4 (偶数) | `0924 3139 3758` |
| `1952-03` | 7 (奇数) | `0A25 3139 3532 2d30 3300` |

## 標準の根拠

- [Library of Congress, Extended Date/Time Format (EDTF) Specification](https://www.loc.gov/standards/datetime/edtf.html)。Level 0 は ISO 8601-1 の部分集合、Level 1・2 は ISO 8601-2 の機能だ。
- RDF では、データ型 `http://id.loc.gov/datatypes/edtf` で同じ文字列を表示する。

## 未解決の問題

- 検査器の EDTF 文法の検査(検査器が外部ライブラリに依拠するか)。
- Wikidata の世紀・千年の精度を EDTF の不明な桁に移す規則。

## 関連ページ

- [Value](/ja/grammar/value/)、[GREGORIAN-DATE](/ja/grammar/value/time/gregorian-date/)、[GEDCOM-DATE](/ja/grammar/value/time/gedcom-date/)
