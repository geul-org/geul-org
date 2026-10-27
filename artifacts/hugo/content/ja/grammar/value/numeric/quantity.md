---
title: "QUANTITY"
weight: 7
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "QUANTITY は、数量一つを、正確な10進数の量、単位 Reference、下限・上限の四つのレコードで収める Value だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUANTITY は、数量一つを、正確な10進数、単位、下限・上限で表す Value だ。Value 直接コード `0x06`、系列 NUMERIC だ。四つの部分は、それぞれ完全なレコードだ。単位と境界は[オプションフィールド](/ja/grammar/codec-spec/)なので、省略するなら ABSENT(`0x0000`)を書く。

## レイアウト

```
TAG WORD          0000 1LLL L000 0110      Codec 0x06
[Length 拡張 TAG] 全体が 15 WORD 以上のとき
amount            SIGNED-DECIMAL Value レコード
unit              Reference レコード (単位項目)、単位なしなら 0x0000
lower             SIGNED-DECIMAL Value レコード、省略なら 0x0000 ABSENT
upper             SIGNED-DECIMAL Value レコード、省略なら 0x0000 ABSENT
```

## 解釈と有効性

- amount は [SIGNED-DECIMAL](/ja/grammar/value/decimal/signed-decimal/) `C×10^E` だ。C と E は元の表記の桁数をそのまま収める: `1.20` = `120×10^-2`、`1.2` = `12×10^-1`。二つの値は同じ数だが有効数字が異なるので、別の Value だ。coefficient の桁数に上限はない(最小 WORD の2の補数、可変長)。
- unit は、完全な Reference レコードがちょうど一つか、`0x0000` だ。単位項目を指す任意の Reference が使える(Wikidata の単位は WIKIDATA-QID)。`0x0000` は単位なし(個数、比率、人口など)だ。
- lower・upper は、それぞれ SIGNED-DECIMAL レコードか `0x0000` だ。どちらか一方だけでもよい。対称な範囲(`652 ± 1`)も下限・上限の二つで書く(`651`、`653`)。非対称な範囲があって、どのみち二つの値が必要なので、± 一つに縮める形式は置かない。
- 単位は値の一部だ。単位を QUALIFIER などで切り離さない(切り離すと `652` が km か m か分からない)。
- SI 単位に換算した値は収めない。単位と換算表から計算できる派生値だ。
- 四つのレコードを読み終えたカーソルは、Payload の終わりとちょうど合わなければならない。それ以外の形は invalid だ。
- geul.org 規格ドキュメントは、amount(`0810`)、unit(`0780`・`0000`)、lower・upper(`0810`・`0000`)の四つのレコードフィールドで書く([Codec 規格ドキュメント](/ja/grammar/codec-spec/))。

## 長さ

- 全体は、TAG 1 WORD + (Length 拡張 TAG)+ 四つのレコードだ。10進数レコードは、TAG 1 + 指数 2 + coefficient 1 WORD 以上だ。
- 単位なし・境界なしの小さな数は 8 WORD だ。15 WORD 以上なら拡張長さを使う([レコードと TAG WORD](/ja/grammar/record/))。

## 例

単位なし `1.20`:

```
0B86 0990 FFFF FFFE 0078 0000 0000 0000
```

- TAG `0B86`(Codec `0x06`、8 WORD)、amount `0990 FFFF FFFE 0078`(E = -2、C = 120)、unit・lower・upper `0000`。

`652 km`、範囲 `[651, 653]`(km = Q828224):

```
0F06 0011
0990 0000 0000 028C
0120 000C A340
0990 0000 0000 028B
0990 0000 0000 028D
```

- 全体 17 WORD なので `LLLL=1110`、拡張 TAG `0011`。

## Wikidata との対応

- `quantity` datavalue `{"amount","unit","lowerBound","upperBound"}` → amount・unit・lower・upper。amount と境界の文字列(`+1.20`、指数表記を含む)は、桁数をそのまま C と E に移す。
- unit `"1"` は単位なし(`0x0000`)、`http://www.wikidata.org/entity/Qn` は WIKIDATA-QID だ。それ以外の単位、形式の合わない数・境界は、変換せずに原文を UTF8-TEXT で保存する。
- Wikidata サンプル(ダンプ冒頭の quantity 約 4.2 万件): 単位なし 61%、境界あり 13%(そのうち対称 93%)、最長の amount 31 文字。

## 標準の根拠

- 10進表記と桁数の保存: [IEEE 754-2008](https://standards.ieee.org/ieee/754/6210/) decimal の coefficient・exponent・quantum の概念(GEUL SIGNED-DECIMAL)。
- Wikidata の数量モデル: Wikibase DataModel `QuantityValue`。

## 関連ページ

- [Value](/ja/grammar/value/)、[SIGNED-DECIMAL](/ja/grammar/value/decimal/signed-decimal/)、[COORDINATE-GEO](/ja/grammar/value/numeric/coordinate-geo/)、[CODEC](/ja/grammar/edge/codec/)、[WIKIDATA-QID](/ja/grammar/reference/wikidata-qid/)
