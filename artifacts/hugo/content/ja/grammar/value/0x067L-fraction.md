---
title: "FRACTION (0x067L)"
weight: 103
date: 2026-10-28T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "FRACTION は原文に書かれた分数を表記のまま表す Value である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `FRACTION` (規格ドキュメント BIND `FRACTION`) |
| TAG ID | `0x067L` |
| Codec ID | `0x00000670` |
| 規格ドキュメント | `0x00000000/codecs/0x00000670/` (DECLARE 対象 `0670`) |
| セクション | 3 `0011` (Value)、セクション内オフセット C = 7 |
| Kind | Value · 系列: NUMERIC |
| TAG WORD | `0000 0110 0111 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引説明 | 原文の表記を保存する分数: 整数・10 進数の分子、符号なし整数・10 進数の分母。約分しない |
| Hugo 側 | `value/numeric/fraction.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `numerator` | #2 | レコード | `0610` SIGNED-INTEGER, `0680` SIGNED-DECIMAL |  |
| 2 | `denominator` | #3 | レコード | `0620` UNSIGNED-INTEGER, `0690` UNSIGNED-DECIMAL |  |

FRACTION は原文に書かれた分数を表記のまま表す Value である。Value 直接コード `0x067L`、系列 NUMERIC である。分子と分母はそれぞれ完全な Value レコードである。約分しない。法令の「3分の2」「100分の5」や、登記の持分 `23.45/1256.1` のように、書かれたままが記録である分数を保持する。

## レイアウト {#레이아웃}

```
TAG WORD          0000 0110 0111 LLLL      Codec 0x067L
[Length 拡張 TAG] 全体が 15 WORD 以上のとき
numerator         Value レコード 1 個: SIGNED-INTEGER または SIGNED-DECIMAL
denominator       Value レコード 1 個: UNSIGNED-INTEGER または UNSIGNED-DECIMAL
```

## 解釈と有効性 {#해석과-유효성}

- numerator は [SIGNED-INTEGER](0x061L-signed-integer.md)(`0x061L`)または [SIGNED-DECIMAL](0x068L-signed-decimal.md)(`0x068L`)のレコードがちょうど 1 つである。
- denominator は [UNSIGNED-INTEGER](0x062L-unsigned-integer.md)(`0x062L`)または [UNSIGNED-DECIMAL](0x069L-unsigned-decimal.md)(`0x069L`)のレコードがちょうど 1 つである。
- 閉じた一覧である。その他の Value、FRACTION 自身(入れ子禁止)、プレースホルダ(`0x0000` など)は受けない。
- 二つのレコードはそれぞれ長さを持つので、境界は別に書かない。二つのレコードを読んだカーソルは Payload の末尾とちょうど一致しなければならない。
- 内側のレコードも各 Codec の正規形に従う(整数・coefficient は最小 WORD)。非正規の内側レコードがあれば FRACTION 全体が invalid である。
- 値は `numerator / denominator` である。

### 表記の保存 {#표기-보존}

- **整数と小数**: 原文の成分が整数(小数点なし)なら INTEGER レコード、小数点があれば DECIMAL レコードを使う。成分を指数 `E = 0` の DECIMAL で書くと invalid である。これにより同じ表記のバイト列は 1 つになる。
- DECIMAL 成分の C と E は原文の桁数のままである。`23.450` は `23450×10^-3` で、`23.45` とは別の Value である。
- **約分しない。** `2/4`、「100分の5」(`5/100`)はそのまま書く。バイト列が同じなら原文の表記が同じである。
- 分母が 1 の分数(`3/1`)も、原文がそう書いていればそのまま書く。原文が整数なら FRACTION ではなく整数 Codec を使う。原文が小数(`0.5`、`5%`)なら DECIMAL を使う。
- 符号は分子にのみ置く。分母は符号なしの Codec である。
- 分母の値が 0 なら invalid である(`0`、`0.0` いずれも)。

### 比較 {#비교}

- 比較層は FRACTION を正確な有理数 `(C1 × 10^E1) / (C2 × 10^E2)` として計算する(INTEGER 成分は `E = 0`)。浮動小数で近似しない。
- 比較・整列・重複判定はこの値で行い、保存・署名・コンテンツハッシュは表記(バイト列)で行う。`2/4`、`1/2`、`0.5` は値が同じでバイト列が異なる。
- 定足数の判定(「出席した株主の議決権の 3 分の 2 以上」)はこの正確な値で比較する。

## 長さ {#길이}

- 全体は TAG 1 WORD + (Length 拡張 TAG) + 二つのレコードである。整数レコードは TAG 1 + Payload 1 WORD 以上、10 進数レコードは TAG 1 + 指数 2 + coefficient 1 WORD 以上である。
- 小さな整数の分数は 5 WORD、小さな小数の分数は 9 WORD である。15 WORD 以上なら拡張長を使う([レコードと TAG WORD](../record.md))。

| 原文 | 成分 | 全体 |
|---|---|---|
| `2/3` | INTEGER 2 WORD + INTEGER 2 WORD | 5 WORD |
| `5/100` | INTEGER 2 WORD + INTEGER 2 WORD | 5 WORD |
| `23.45/1256.1` | DECIMAL 4 WORD + DECIMAL 4 WORD | 9 WORD |

## 例 {#예시}

`2/3`:

```
0674 0611 0002 0621 0003
```

- TAG `0674`(Codec `0x067L`、5 WORD)、numerator `0611 0002`(SIGNED-INTEGER 2)、denominator `0621 0003`(UNSIGNED-INTEGER 3)。

`23.45/1256.1`:

```
0678 0683 FFFF FFFE 0929 0693 FFFF FFFF 3111
```

- TAG `0678`(9 WORD)、numerator `0683 FFFF FFFE 0929`(SIGNED-DECIMAL E = -2、C = 2345)、denominator `0693 FFFF FFFF 3111`(UNSIGNED-DECIMAL E = -1、C = 12561)。

## 他の形式との関係 {#다른-형식과의-관계}

- [QUANTITY](0x066L-quantity.md) の amount・lower・upper は FRACTION を受ける。「出席議決権の 3 分の 2」は amount `2/3`、単位なしの QUANTITY で書ける。
- geul.org の規格ドキュメント `0x00000000/codecs/0x00000670` は、numerator(`0610`・`0680`)、denominator(`0620`・`0690`)の二つのレコードフィールドで記述する([Codec 規格ドキュメント](../codec-spec.md))。
- 約分を強制する固定 int64 の分数が必要なら、Issuer 形式 [RATIONAL-I64](adhoc.geul.org/rational-i64.md) を使う。

## 未解決の問題 {#열린-문제}

1. 帯分数(`1と2/3`)の表記保存。
2. 成分に単位がある分数(面積/面積)を QUANTITY 二つで保持する形式。FRACTION は単位を保持しない。
3. パーセント・パーミル(`5%`、`5‰`)を DECIMAL と単位で置くか、FRACTION(`5/100`)で置くかの表記基準。
4. 繁分数(分子・分母に FRACTION)。現在は禁止する。

## 関連ページ {#관련-페이지}

- [Value](_index.md), [QUANTITY](0x066L-quantity.md), [SIGNED-INTEGER](0x061L-signed-integer.md), [SIGNED-DECIMAL](0x068L-signed-decimal.md), [RATIONAL-I64](adhoc.geul.org/rational-i64.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00000670/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000067000000000
BODY
#1 DECLARE 0x0670
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "FRACTION"
#5 BIND #2 "numerator"
#6 BIND #3 "denominator"
#7 CODEC #2 0x0610
#8 CODEC #2 0x0680
#9 CODEC #3 0x0620
#10 CODEC #3 0x0690
```
