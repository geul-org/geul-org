---
title: "GEDCOM-DATE (0x070L·0x071L)"
weight: 112
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GEDCOM-DATE は GEDCOM 7 の日付値文字列で、ユリウス暦など他の暦の日付を記された表記のまま保存する Value である(Codec 0x070L/0x071L)。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEDCOM-DATE は GEDCOM 7 の日付値文字列で、ユリウス暦など他の暦の日付を記された表記のまま保存する Value である(Codec 0x070L/0x071L)。

| 項目 | 値 |
|---|---|
| 名前 | `GEDCOM-DATE` (偶奇の組。コードごとの名前は下の構成員の表) |
| TAG ID | `0x070L`·`0x071L` |
| セクション | 3 `0011` (Value)、セクション内オフセット C = 16~17 |
| Kind | Value · 系列: TIME |
| 索引の説明 | GEDCOM 7 の日付値文字列。他の暦(ユリウス暦など)の原表記を保存。偶数・奇数バイト |
| Hugo 側 | `value/time/gedcom-date.md` |

## 構成員 {#구성원}

このページは偶奇の組をなす二つのコードをまとめて扱う。偶数コードはバイト数が偶数、奇数コードは奇数の値である([レコードと TAG WORD](../record.md#가변-길이-바이트열))。Codec ドキュメントはコードごとに一つである。二つの Codec ドキュメントのフィールドは同じで、DECLARE の対象と名前(BIND)だけが異なる。

| TAG ID | 名前 | バイト数 | Codec ID | 規格ドキュメント | TAG WORD |
|---|---|---|---|---|---|
| `0x070L` | `GEDCOM-DATE-EVEN` | 偶数 | `0x00000700` | `0x00000000/codecs/0x00000700/` | `0000 0111 0000 LLLL` |
| `0x071L` | `GEDCOM-DATE-ODD` | 奇数 | `0x00000710` | `0x00000000/codecs/0x00000710/` | `0000 0111 0001 LLLL` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | 残り生値(`0xFFFF`) |  |  |

GEDCOM-DATE は [GEDCOM 7](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html)(FamilySearch)の日付値(`DateValue`)文字列を収める Value である。原本がグレゴリオ暦以外の暦(ユリウス暦など)で記した日付を**記されたまま**保存する。

## レイアウト {#레이아웃}

- コード: Value 直接コード `0x070L`(偶数バイト)·`0x071L`(奇数バイト)。系列 TIME。
- バイト数は Codec の最下位ビットと Payload WORD 数で決まる。`2 × Payload WORD 数 − 最下位ビット`であり、Byte Count は置かない([Value](_index.md))。

```
TAG WORD          0000 0111 000P LLLL      Codec 0x070L/0x071L (P = 奇数バイト)
[Length 拡張 TAG] 全体が 15 WORD 以上のとき
Payload WORD 1st ... Nth          GEDCOM 日付文字列の ASCII バイト / 奇数なら最後に 0x00
```

## 解釈と有効性 {#해석과-유효성}

- バイト列は GEDCOM 7 `DateValue` の文法に従う ASCII 文字列である。空文字列は invalid である。GEDCOM は空の `DateValue` を許すが、値がなければレコードを書かない。
- 文法の要点: `[暦] [[日] 月] 年 [BCE]`。先頭に `ABT`·`CAL`·`EST`(おおよそ)、`BEF`·`AFT`·`BET … AND …`(範囲)、`FROM … TO …`(期間)を付ける。区切りは空白一つである。
- 暦: `GREGORIAN`(省略時の既定)、`JULIAN`、`FRENCH_R`、`HEBREW`、拡張タグ。月名は暦ごとに定まっている(ユリウス暦はグレゴリオ暦と同じ `JAN`…`DEC`)。
- 年は**歴史式**である。0 年がなく、紀元前は `BCE` を付ける(`44 BCE` = 紀元前 44 年)。EDTF·GREGORIAN-DATE の天文式とは 1 年の差が出る。
- schema はバイト形式だけを検査する: ASCII `0x20`~`0x7E`、空でないこと、前後に空白がないこと。文法と実在する日かどうかは生産者が検査する。例: `github.com/cacack/gedcom-go/v3`(MIT)の `gedcom.ParseDate`。このライブラリの `Validate` はグレゴリオ暦でしか日を検査せず `JULIAN 30 FEB 1100` を通してしまい、`ToGregorian` は年·月精度を実際には変換しない。日付の実在検査と正規化は別に行う。
- **使う場所:** グレゴリオ暦の日付は [GREGORIAN-DATE](0x06AL-gregorian-date.md)か [EDTF](0x06EL-edtf.md)で書く。GEDCOM-DATE は原表記を保存すべき他の暦の日付に使う。

## 正規化された値と併用する {#정규화된-값과-함께-쓰기}

- 同じ日付を時間軸で比較·索引するにはグレゴリオ暦の値が必要である。日精度は同じ日の GREGORIAN-DATE、年·月精度はその期間のグレゴリオ暦区間 EDTF(`JULIAN 1300` → `1300-01-09/1301-01-08`)が正確な対応である。
- 原表記(GEDCOM-DATE)と正規化された値を二つの Value として併せて収める方法はまだ決めていない(未解決の問題)。

## 長さ {#길이}

- 全体は TAG 1 WORD、Length 拡張 TAG(あれば)と Payload を合わせた WORD 数である([Length](../record.md))。

## 例 {#예시}

| 日付 | バイト | 全体 WORD |
|---|---|---|
| `JULIAN 1300` | 11 (奇数) | `0716 4A55 4C49 414E 2031 3330 3000` |

## 標準の根拠 {#표준-근거}

- [FamilySearch GEDCOM 7, Data types — Date](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html#date), [Appendix A: Calendars and Dates](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html#A-calendars). 仕様リポジトリのライセンスは Apache 2.0 である。GEUL は形式を参照するだけで、仕様本文を転載しない。
- ISO 8601、EDTF、XSD、CLDR の暦識別子(`u-ca`)にはユリウス暦がない。GEDCOM 7 は暦の接頭辞·紀元前·精度·修飾子を一つの文法で扱う公開の交換形式である。

## 未解決の問題 {#열린-문제}

- 原表記と正規化された値を併せて書く方法(一つの TRIPLE に両者をつなぐ方法)。
- schema の GEDCOM 文法検査。
- 世紀·10 年精度。GEDCOM にはそのような形式がない。Wikidata から移せない日付は原文を UTF8-TEXT に残す。

## 関連ページ {#관련-페이지}

- [Value](_index.md), [EDTF](0x06EL-edtf.md), [GREGORIAN-DATE](0x06AL-gregorian-date.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00000700/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000070000000000
BODY
#1 DECLARE 0x0700
#2 FIELD #1 rest
#3 BIND #1 "GEDCOM-DATE-EVEN"
#4 BIND #2 "bytes"
```

上は `GEDCOM-DATE-EVEN`(`0x070L`)の Codec ドキュメントである。他の構成員(`GEDCOM-DATE-ODD`)の Codec ドキュメントは、DOC-ID の Codec ID、DECLARE の対象、`#1` に結び付けた名前(BIND)だけが異なる。
