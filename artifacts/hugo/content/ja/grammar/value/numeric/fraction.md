---
title: "FRACTION"
weight: 8
date: 2026-10-28T12:00:00+09:00
lastmod: 2026-10-28T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "FRACTION は、分子(整数・10進数)と分母(符号なし整数・10進数)を原文の表記どおり、約分せずに収める分数 Value だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

FRACTION は、原文に書かれた分数を表記どおりに表す Value だ。Value 直接コード `0x07`、系列 NUMERIC だ。分子と分母は、それぞれ完全な Value レコードだ。約分しない。法令の「3分の2」「100分の5」や、登記の小数の持分 `23.45/1256.1` のように、書かれたとおりのものが記録である分数を収める。

## レイアウト

```
TAG WORD          0000 1LLL L000 0111      Codec 0x07
[Length 拡張 TAG] 全体が 15 WORD 以上のとき
numerator         Value レコード 1 個: SIGNED-INTEGER または SIGNED-DECIMAL
denominator       Value レコード 1 個: UNSIGNED-INTEGER または UNSIGNED-DECIMAL
```

## 解釈と有効性

- numerator は [SIGNED-INTEGER](/ja/grammar/value/numeric/signed-integer/)(`0x01`)または [SIGNED-DECIMAL](/ja/grammar/value/decimal/signed-decimal/)(`0x10`)のレコードちょうど一つだ。
- denominator は [UNSIGNED-INTEGER](/ja/grammar/value/numeric/unsigned-integer/)(`0x02`)または [UNSIGNED-DECIMAL](/ja/grammar/value/decimal/unsigned-decimal/)(`0x11`)のレコードちょうど一つだ。
- 閉じたリストだ。その他の Value、FRACTION 自身(入れ子禁止)、位置標識(`0x0000` など)は受け付けない。
- 二つのレコードはそれぞれ自分の長さを持つので、境界を別に書かない。二つのレコードを読んだカーソルは Payload の終わりとちょうど一致しなければならない。
- 内側のレコードも各 Codec の正規形に従う(整数・coefficient は最小 WORD)。非正規の内側レコードがあれば FRACTION 全体が invalid だ。
- 値は `numerator / denominator` だ。

### 表記の保存

- **整数と小数**: 原文の成分が整数(小数点なし)なら INTEGER レコード、小数点があれば DECIMAL レコードを使う。成分を指数 `E = 0` の DECIMAL で書くと invalid だ。だから同じ表記のバイト列は一つだ。
- DECIMAL 成分の C と E は原文の桁数をそのまま収める。`23.450` は `23450×10^-3` で、`23.45` とは別の Value だ。
- **約分しない。** `2/4`、「100分の5」(`5/100`)はそのまま書く。バイトが同じなら原文の表記が同じだ。
- 分母が 1 の分数(`3/1`)も、原文がそう書いていればそのまま書く。原文が整数なら FRACTION ではなく整数 Codec を使う。原文が小数(`0.5`、`5%`)なら DECIMAL を使う。
- 符号は分子だけに置く。分母は符号なしの Codec だ。
- 分母の値が 0 なら invalid だ(`0`、`0.0` とも)。

### 比較

- 比較層は FRACTION を正確な有理数 `(C1 × 10^E1) / (C2 × 10^E2)` として計算する(INTEGER 成分は `E = 0`)。浮動小数点で近似しない。
- 比較・整列・重複判定はこの値で行い、保存・署名・内容ハッシュは表記(バイト)で行う。`2/4`、`1/2`、`0.5` は値が同じでバイトが異なる。
- 定足数の判定(「出席した株主の議決権の3分の2以上」)はこの正確な値で比較する。

## 長さ

- 全体は、TAG 1 WORD + (Length 拡張 TAG)+ 二つのレコードだ。整数レコードは TAG 1 + Payload 1 WORD 以上、10進数レコードは TAG 1 + 指数 2 + coefficient 1 WORD 以上だ。
- 小さな整数の分数は 5 WORD、小さな小数の分数は 9 WORD だ。15 WORD 以上なら拡張長さを使う([レコードと TAG WORD](/ja/grammar/record/))。

| 原文 | 成分 | 全体 |
|---|---|---|
| `2/3` | INTEGER 2 WORD + INTEGER 2 WORD | 5 WORD |
| `5/100` | INTEGER 2 WORD + INTEGER 2 WORD | 5 WORD |
| `23.45/1256.1` | DECIMAL 4 WORD + DECIMAL 4 WORD | 9 WORD |

## 例

`2/3`:

```
0A07 0881 0002 0882 0003
```

- TAG `0A07`(Codec `0x07`、5 WORD)、numerator `0881 0002`(SIGNED-INTEGER 2)、denominator `0882 0003`(UNSIGNED-INTEGER 3)。

`23.45/1256.1`:

```
0C07 0990 FFFF FFFE 0929 0991 FFFF FFFF 3111
```

- TAG `0C07`(9 WORD)、numerator `0990 FFFF FFFE 0929`(SIGNED-DECIMAL E = -2、C = 2345)、denominator `0991 FFFF FFFF 3111`(UNSIGNED-DECIMAL E = -1、C = 12561)。

## 他の形式との関係

- [QUANTITY](/ja/grammar/value/numeric/quantity/) の amount・lower・upper は FRACTION を受け付ける。「出席議決権の3分の2」は amount が `2/3` の単位なし QUANTITY で書ける。
- geul.org 規格文書 `0x0000/0x0000000000000807` は numerator(`0801`・`0810`)、denominator(`0802`・`0811`)の二つのレコードフィールドで書く([Codec 規格文書](/ja/grammar/codec-spec/))。
- 約分を強制する固定 int64 の分数が必要なら、Issuer 形式 [RATIONAL-I64](/ja/grammar/value/etc/rational-i64/) を使う。

## 未解決の問題

1. 帯分数(`1と2/3`)の表記の保存。
2. 成分に単位がある分数(面積/面積)を QUANTITY 二つで収める形式。FRACTION は単位を収めない。
3. パーセント・パーミル(`5%`、`5‰`)を DECIMAL と単位で置くか、FRACTION(`5/100`)で置くかの表記基準。
4. 繁分数(分子・分母に FRACTION)。今は禁止する。

## 関連ページ

- [Value](/ja/grammar/value/)、[QUANTITY](/ja/grammar/value/numeric/quantity/)、[SIGNED-INTEGER](/ja/grammar/value/numeric/signed-integer/)、[SIGNED-DECIMAL](/ja/grammar/value/decimal/signed-decimal/)、[RATIONAL-I64](/ja/grammar/value/etc/rational-i64/)
