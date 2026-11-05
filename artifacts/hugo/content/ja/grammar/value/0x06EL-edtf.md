---
title: "EDTF (0x06EL·0x06FL)"
weight: 110
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "EDTF は ISO 8601-2 拡張日付文字列で、年・月精度、紀元前、不確実、区間などの日付を保持する Value である(Codec 0x06EL/0x06FL)。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EDTF は ISO 8601-2 拡張日付文字列で、年・月精度、紀元前、不確実、区間などの日付を保持する Value である(Codec 0x06EL/0x06FL)。

| 項目 | 値 |
|---|---|
| 名前 | `EDTF` (偶奇のまとまり。コードごとの名前は下の構成要素の表) |
| TAG ID | `0x06EL`·`0x06FL` |
| セクション | 3 `0011` (Value)、セクション内オフセット C = 14~15 |
| Kind | Value · 系列: TIME |
| 索引説明 | EDTF(ISO 8601-2)日付文字列。偶数・奇数バイト。GREGORIAN-DATE で書ける日付には使わない |
| Hugo 側 | `value/time/edtf.md` |

## 構成要素 {#구성원}

このページは偶奇の対となる二つのコードをあわせて扱う。偶数コードはバイト数が偶数、奇数コードは奇数の値である([レコードと TAG WORD](../record.md#가변-길이-바이트열))。Codec ドキュメントはコードごとに一つである。二つの Codec ドキュメントのフィールドは同じで、DECLARE 対象と名前(BIND)だけが異なる。

| TAG ID | 名前 | バイト数 | Codec ID | 規格ドキュメント | TAG WORD |
|---|---|---|---|---|---|
| `0x06EL` | `EDTF-EVEN` | 偶数 | `0x000006E0` | `0x00000000/codecs/0x000006E0/` | `0000 0110 1110 LLLL` |
| `0x06FL` | `EDTF-ODD` | 奇数 | `0x000006F0` | `0x00000000/codecs/0x000006F0/` | `0000 0110 1111 LLLL` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | 残りの生値(`0xFFFF`) |  |  |

EDTF は [Extended Date/Time Format](https://www.loc.gov/standards/datetime/edtf.html)(米国議会図書館、ISO 8601-2:2019)の文字列で日付を保持する Value である。日より粗い精度、紀元前、不確実・おおよそ・一部不明、区間を表す。

## レイアウト {#레이아웃}

- コード: Value 直接コード `0x06EL`(偶数バイト)・`0x06FL`(奇数バイト)。系列 TIME。Payload は文字列だが TIME 系列に置く。
- バイト数は Codec の最下位ビットと Payload WORD 数で決まる。`2 × Payload WORD 数 − 最下位ビット` であり、Byte Count は置かない([Value](_index.md))。

```
TAG WORD          0000 0110 111P LLLL      Codec 0x06EL/0x06FL (P = 奇数バイト)
[Length 拡張 TAG] 全体が 15 WORD 以上のとき
Payload WORD 1st ... Nth          EDTF 文字列の ASCII バイト / 奇数なら最後に 0x00
```

## 解釈と有効性 {#해석과-유효성}

- バイト列は EDTF Level 0・1・2 の文法に従う ASCII 文字列である。空文字列は invalid である。
- 例: 日 `1952-03-11`、月 `1952-03`、年 `1952`、10 年 `195X`、紀元前 44 年 `-0043`、不確実 `1974?`、おおよそ `~1974`、区間 `1952/2001`、大きな年 `Y-13799999999`。
- 年は ISO 8601 の天文学式である。`0000` は紀元前 1 年、`-0043` は紀元前 44 年である。歴史式の表記から移すときは一年ずらす。
- グレゴリオ暦である。EDTF は他の暦を扱わない。ユリウス暦など他の暦の元の表記は [GEDCOM-DATE](0x070L-gedcom-date.md) で保存する。その日付と同じ日・期間をグレゴリオ暦に移した値は、EDTF や GREGORIAN-DATE で書ける。
- **正規形:** [GREGORIAN-DATE](0x06AL-gregorian-date.md) で正確に書ける日付、すなわち限定子(`?`、`~`、`%`)・不明桁(`X`)・区間・`Y` 接頭辞のない `[-]YYYY-MM-DD` は、GREGORIAN-DATE で書く。このような日付を EDTF で書くと invalid である。同じ日が一つの形式でのみ書かれて初めて、時間として索引・比較できる。
- schema はまだ EDTF 文法を検査しない。生産者が EDTF パーサで検査する。例: `github.com/sfomuseum/go-edtf`(BSD-3-Clause)の `parser.ParseString`。`parser.IsValid` は文法だけを見て `2023-02-29`、`1974-13` も通すので使わない。このパーサは `Y` 接頭辞の年をまだサポートしていない。

## 長さ {#길이}

- 全体は TAG 1 WORD、Length 拡張 TAG(あれば)と Payload を合わせた WORD 数である([Length](../record.md))。

## 例 {#예시}

| 日付 | バイト | 全体 WORD |
|---|---|---|
| `1974` | 4 (偶数) | `06E2 3139 3734` |
| `197X` | 4 (偶数) | `06E2 3139 3758` |
| `1952-03` | 7 (奇数) | `06F4 3139 3532 2D30 3300` |

## 標準の根拠 {#표준-근거}

- [Library of Congress, Extended Date/Time Format (EDTF) Specification](https://www.loc.gov/standards/datetime/edtf.html)。Level 0 は ISO 8601-1 の部分集合、Level 1・2 は ISO 8601-2 の機能である。
- RDF ではデータ型 `http://id.loc.gov/datatypes/edtf` で同じ文字列を表示する。

## 未解決の問題 {#열린-문제}

- 検査器の EDTF 文法検査(検査器が外部ライブラリに依拠するかどうか)。
- Wikidata の世紀・千年紀の精度を EDTF の不明桁に移す規則。

## 関連ページ {#관련-페이지}

- [Value](_index.md), [GREGORIAN-DATE](0x06AL-gregorian-date.md), [GEDCOM-DATE](0x070L-gedcom-date.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x000006E0/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006E000000000
BODY
#1 DECLARE 0x06E0
#2 FIELD #1 rest
#3 BIND #1 "EDTF-EVEN"
#4 BIND #2 "bytes"
```

上は `EDTF-EVEN`(`0x06EL`)の Codec ドキュメントである。他の構成要素(`EDTF-ODD`)の Codec ドキュメントは、DOC-ID の Codec ID、DECLARE 対象、`#1` に結びつけた名前(BIND)だけが異なる。
