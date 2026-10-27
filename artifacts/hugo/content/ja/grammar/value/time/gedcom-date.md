---
title: "GEDCOM-DATE"
weight: 39
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GEDCOM-DATE は、GEDCOM 7 の日付値文字列で、ユリウス暦のような他の暦の日付を書かれたままに保存する Value だ(Codec 0x26/0x27)。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEDCOM-DATE は、[GEDCOM 7](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html)(FamilySearch)の日付値(`DateValue`)文字列を収める Value だ。元がグレゴリオ暦ではない暦(ユリウス暦など)で書いた日付を、**書かれたまま**保存する。

## レイアウト

- コード: Value 直接コード `0x26`(偶数バイト)・`0x27`(奇数バイト)。系列 TIME。
- バイト数は、Codec の最下位ビットと Payload WORD 数で決まる。`2 × Payload WORD 数 − 最下位ビット` で、Byte Count は置かない([Value](/ja/grammar/value/))。

```
TAG WORD          0000 1LLL L010 011P      Codec 0x26/0x27 (P = 奇数バイト)
[Length 拡張 TAG] 全体が 15 WORD 以上のとき
Payload WORD 1st ... Nth          GEDCOM 日付文字列の ASCII バイト / 奇数なら最後に 0x00
```

## 解釈と有効性

- バイト列は、GEDCOM 7 の `DateValue` 文法に従う ASCII 文字列だ。空文字列は invalid だ。GEDCOM は空の `DateValue` を許すが、値がなければレコードを書かない。
- 文法の要点: `[暦] [[日] 月] 年 [BCE]`。前に `ABT`・`CAL`・`EST`(おおよそ)、`BEF`・`AFT`・`BET … AND …`(範囲)、`FROM … TO …`(期間)を付ける。区切りは空白一つだ。
- 暦: `GREGORIAN`(省略すれば既定)、`JULIAN`、`FRENCH_R`、`HEBREW`、拡張タグ。月の名前は暦ごとに決まっている(ユリウス暦はグレゴリオ暦と同じ `JAN`…`DEC`)。
- 年は**歴史式**だ。0年がなく、紀元前は `BCE` を付ける(`44 BCE` = 紀元前44年)。EDTF・GREGORIAN-DATE の天文式とは、一年の差がある。
- schema はバイト形式だけを検査する: ASCII `0x20`~`0x7E`、空でない、前後に空白がない。文法と実在する日かは、生産者が検査する。例: `github.com/cacack/gedcom-go/v3`(MIT)の `gedcom.ParseDate`。このライブラリの `Validate` はグレゴリオ暦でのみ日を検査して `JULIAN 30 FEB 1100` を通し、`ToGregorian` は年・月の精度を実際には変換しない。日付の実在検査と正規化は別に行う。
- **使う場所:** グレゴリオ暦の日付は、[GREGORIAN-DATE](/ja/grammar/value/time/gregorian-date/) か [EDTF](/ja/grammar/value/time/edtf/) で書く。GEDCOM-DATE は、原表記を保存する必要のある他の暦の日付に使う。

## 正規化された値と一緒に使う

- 同じ日付を時間軸で比較・インデックスするには、グレゴリオ暦の値が必要だ。日の精度は同じ日の GREGORIAN-DATE、年・月の精度はその期間のグレゴリオ暦の区間 EDTF(`JULIAN 1300` → `1300-01-09/1301-01-08`)が正確な対応だ。
- 原表記(GEDCOM-DATE)と正規化された値を、二つの Value として一緒に収める方法は、まだ決めていない(未解決の問題)。

## 長さ

- 全体は、TAG 1 WORD、Length 拡張 TAG(あれば)と Payload を合わせた WORD 数だ([Length](/ja/grammar/record/))。

## 例

| 日付 | バイト | 全体 WORD |
|---|---|---|
| `JULIAN 1300` | 11 (奇数) | `0B27 4a55 4c49 414e 2031 3330 3000` |

## 標準の根拠

- [FamilySearch GEDCOM 7, Data types — Date](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html#date)、[Appendix A: Calendars and Dates](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html#A-calendars)。仕様リポジトリのライセンスは Apache 2.0 だ。GEUL は形式を参照するだけで、仕様の本文は移さない。
- ISO 8601、EDTF、XSD、CLDR の暦識別子(`u-ca`)にユリウス暦はない。GEDCOM 7 は、暦のプレフィックス・紀元前・精度・修飾子を一つの文法で扱う公開交換形式だ。

## 未解決の問題

- 原表記と正規化された値を一緒に書く方法(一つの TRIPLE に二つを結ぶ方法)。
- schema の GEDCOM 文法の検査。
- 世紀・10年の精度。GEDCOM には該当する形式がない。Wikidata から移せない日付は、原文を UTF8-TEXT で残す。

## 関連ページ

- [Value](/ja/grammar/value/)、[EDTF](/ja/grammar/value/time/edtf/)、[GREGORIAN-DATE](/ja/grammar/value/time/gregorian-date/)
