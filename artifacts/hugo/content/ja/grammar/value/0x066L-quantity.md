---
title: "QUANTITY (0x066L)"
weight: 102
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "QUANTITY は一つの数量を、数、単位、下限・上限で表す Value である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `QUANTITY` (規格ドキュメント BIND `QUANTITY`) |
| TAG ID | `0x066L` |
| Codec ID | `0x00000660` |
| 規格ドキュメント | `0x00000000/codecs/0x00000660/` (DECLARE 対象 `0660`) |
| セクション | 3 `0011` (Value)、セクション内オフセット C = 6 |
| Kind | Value · 系列: NUMERIC |
| TAG WORD | `0000 0110 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引説明 | 数値 Value の amount(整数・BINARY-FLOAT・10 進数・分数)、単位 Reference、下限・上限。単位・境界は省略可能(ABSENT `0x0000`) |
| Hugo 側 | `value/numeric/quantity.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `amount` | #2 | レコード | `0680` SIGNED-DECIMAL, `0610` SIGNED-INTEGER, `0620` UNSIGNED-INTEGER, `0630` BINARY-FLOAT, `0670` FRACTION, `0690` UNSIGNED-DECIMAL |  |
| 2 | `unit` | #3 | レコード | `000F` セクション 0 全体(ワイルドカード、Reference)、`020F` セクション 1 全体(ワイルドカード、Reference)、`040F` セクション 2 全体(ワイルドカード、Reference)、`0000` ABSENT(任意フィールド) |  |
| 3 | `lower` | #4 | レコード | `0680` SIGNED-DECIMAL, `0000` ABSENT(任意フィールド), `0610` SIGNED-INTEGER, `0620` UNSIGNED-INTEGER, `0630` BINARY-FLOAT, `0670` FRACTION, `0690` UNSIGNED-DECIMAL |  |
| 4 | `upper` | #5 | レコード | `0680` SIGNED-DECIMAL, `0000` ABSENT(任意フィールド), `0610` SIGNED-INTEGER, `0620` UNSIGNED-INTEGER, `0630` BINARY-FLOAT, `0670` FRACTION, `0690` UNSIGNED-DECIMAL |  |

QUANTITY は一つの数量を、数、単位、下限・上限で表す Value である。Value 直接コード `0x066L`、系列 NUMERIC である。四つの部分はそれぞれ完全なレコードである。単位と境界は[任意フィールド](../codec-spec.md)なので、省略するときは ABSENT(`0x0000`)を書く。

## レイアウト {#레이아웃}

```
TAG WORD          0000 0110 0110 LLLL      Codec 0x066L
[Length 拡張 TAG] 全体が 15 WORD 以上のとき
amount            数値 Value レコード (整数・BINARY-FLOAT・10 進数・分数)
unit              Reference レコード (単位項目)、単位なしなら 0x0000
lower             数値 Value レコード、省略なら 0x0000 ABSENT
upper             数値 Value レコード、省略なら 0x0000 ABSENT
```

## 解釈と有効性 {#해석과-유효성}

- amount は完全な数値 Value レコード 1 つである。受ける Codec は [SIGNED-INTEGER](0x061L-signed-integer.md)(`0x061L`)、[UNSIGNED-INTEGER](0x062L-unsigned-integer.md)(`0x062L`)、[BINARY-FLOAT](0x063L-binary-float.md)(`0x063L`)、[FRACTION](0x067L-fraction.md)(`0x067L`)、[SIGNED-DECIMAL](0x068L-signed-decimal.md)(`0x068L`)、[UNSIGNED-DECIMAL](0x069L-unsigned-decimal.md)(`0x069L`)の六つである。閉じた一覧でありワイルドカードではない。BOOL、COORDINATE-EARTH・COORDINATE-GEO、QUANTITY 自身(入れ子禁止、深さ固定)、その他の Value は受けない。amount にはプレースホルダ(`0x0000` など)を使えない。
- 内側のレコードも各 Codec の正規形に従う(整数・coefficient は最小 WORD、BINARY-FLOAT は 1/2/4/8 WORD、FRACTION はその規則)。非正規の内側レコードがあれば QUANTITY 全体が invalid である。
- amount・lower・upper が BINARY-FLOAT なら有限の値でなければならない。NaN と ±Infinity は invalid である([COORDINATE-EARTH](0x064L-coordinate-earth.md)の緯度・経度と同じ規則)。
- 数の形式は元の表記にそのまま従う。整数の原文は INTEGER、小数の原文は DECIMAL、分数の原文は FRACTION、IEEE 754 binary 値は BINARY-FLOAT に保持し、エンコーダは形式を変えて正規化しない。DECIMAL の C と E は元の表記の桁数をそのまま保持する: `1.20` = `120×10^-2`、`1.2` = `12×10^-1`。二つの値は同じ数だが有効数字が異なるため別の Value である。整数と coefficient の桁数に上限はない(最小 WORD、可変長)。
- unit は完全な Reference レコードがちょうど 1 つ、または `0x0000` である。単位項目を指す Reference ならどれでも使える(Wikidata の単位は WIKIDATA-QID)。`0x0000` は単位なし(個数、比率、人口など)である。
- lower・upper はそれぞれ amount と同じ六つの Codec のいずれかのレコード、または `0x0000` ABSENT である。プレースホルダは ABSENT による省略のみ受ける。どちらか一方だけでもよい。三つの数の Codec が同じである必要はない。
- lower ≤ amount ≤ upper は、バイト列や Codec ではなく数値として比較する。型が異なっても数として比較する(例: SIGNED-INTEGER `652` と SIGNED-DECIMAL `651.5`)。FRACTION は正確な有理数として比較する。対称な範囲(`652 ± 1`)も下限・上限の二つで書く(`651`、`653`)。非対称な範囲があり、どのみち二つの値が必要なので、± 一つに縮める形式は置かない。
- 単位は値の一部である。単位を QUALIFIER などに切り離さない(切り離すと `652` が km なのか m なのか分からない)。
- amount レコードを取り出せば、そのまま独立した Value レコードである。単位を除いた数が必要なら、再エンコードせずそのレコードを使う。
- SI 単位に換算した値は保持しない。単位と換算表から計算できる派生値である。
- 四つのレコードを読んだカーソルは Payload の末尾とちょうど一致しなければならない。それ以外の形は invalid である。
- geul.org の規格ドキュメントは、amount(`0610`・`0620`・`0630`・`0670`・`0680`・`0690`)、unit(`000F`・`020F`・`040F`・`0000`)、lower・upper(`0610`・`0620`・`0630`・`0670`・`0680`・`0690`・`0000`)の四つのレコードフィールドで記述する([Codec 規格ドキュメント](../codec-spec.md))。

## 長さ {#길이}

- 全体は TAG 1 WORD + (Length 拡張 TAG) + 四つのレコードである。整数レコードは TAG 1 + Payload 1 WORD 以上、BINARY-FLOAT レコードは 2・3・5・9 WORD、10 進数レコードは TAG 1 + 指数 2 + coefficient 1 WORD 以上、FRACTION レコードは 5 WORD 以上である。
- 単位なし・境界なしの小さな整数は 6 WORD、小さな 10 進数は 8 WORD である。15 WORD 以上なら拡張長を使う([レコードと TAG WORD](../record.md))。

## 例 {#예시}

単位なし `1.20`:

```
0667 0683 FFFF FFFE 0078 0000 0000 0000
```

- TAG `0667`(Codec `0x066L`、8 WORD)、amount `0683 FFFF FFFE 0078`(E = -2、C = 120)、unit・lower・upper `0000`。

単位なしの整数 `42`:

```
0665 0611 002A 0000 0000 0000
```

- TAG `0665`(6 WORD)、amount `0611 002A`(SIGNED-INTEGER 42)、unit・lower・upper `0000`。

単位なしの分数 `2/3`(出席議決権の 3 分の 2):

```
0668 0674 0611 0002 0621 0003 0000 0000 0000
```

- TAG `0668`(9 WORD)、amount `0674 0611 0002 0621 0003`([FRACTION](0x067L-fraction.md) 2/3)、unit・lower・upper `0000`。

`652 km`、範囲 `[651, 653]`(km = Q828224):

```
066E 0011
0683 0000 0000 028C
0142 000C A340
0683 0000 0000 028B
0683 0000 0000 028D
```

- 全体 17 WORD なので `LLLL=1110`、拡張 TAG `0011`。

## Wikidata との対応 {#위키데이터-대응}

- `quantity` datavalue `{"amount","unit","lowerBound","upperBound"}` → amount・unit・lower・upper。amount と境界の文字列(`+1.20`、指数表記を含む)は桁数のまま C と E に移す。
- Wikidata の amount・境界は 10 進文字列なので、整数の形(`+652`)でも SIGNED-DECIMAL に移す。Wikidata の変換は他の数値 Codec を使わない。
- unit `"1"` は単位なし(`0x0000`)、`http://www.wikidata.org/entity/Qn` は WIKIDATA-QID である。それ以外の単位や、形式が合わない数・境界は変換せず原文を UTF8-TEXT で保存する。
- Wikidata 標本(ダンプ先頭部分の quantity 約 4.2 万件): 単位なし 61%、境界あり 13%(うち対称 93%)、最長の amount 31 文字。

## 標準の根拠 {#표준-근거}

- 10 進表記と桁数の保存: [IEEE 754-2008](https://standards.ieee.org/ieee/754/6210/) decimal の coefficient・exponent・quantum の概念(GEUL SIGNED-DECIMAL)。
- Wikidata の数量モデル: Wikibase DataModel `QuantityValue`。

## 関連ページ {#관련-페이지}

- [Value](_index.md), [SIGNED-DECIMAL](0x068L-signed-decimal.md), [COORDINATE-GEO](0x065L-coordinate-geo.md), [CODEC](../edge/0x0BEL-codec.md), [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00000660/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000066000000000
BODY
#1 DECLARE 0x0660
#2 FIELD #1 record
#3 FIELD #1 record
#4 FIELD #1 record
#5 FIELD #1 record
#6 BIND #1 "QUANTITY"
#7 BIND #2 "amount"
#8 BIND #3 "unit"
#9 BIND #4 "lower"
#10 BIND #5 "upper"
#11 CODEC #2 0x0680
#12 CODEC #3 0x000F
#33 CODEC #3 0x020F
#34 CODEC #3 0x040F
#13 CODEC #3 0x0000
#14 CODEC #4 0x0680
#15 CODEC #4 0x0000
#16 CODEC #5 0x0680
#17 CODEC #5 0x0000
#18 CODEC #2 0x0610
#19 CODEC #2 0x0620
#20 CODEC #2 0x0630
#21 CODEC #2 0x0670
#22 CODEC #2 0x0690
#23 CODEC #4 0x0610
#24 CODEC #4 0x0620
#25 CODEC #4 0x0630
#26 CODEC #4 0x0670
#27 CODEC #4 0x0690
#28 CODEC #5 0x0610
#29 CODEC #5 0x0620
#30 CODEC #5 0x0630
#31 CODEC #5 0x0670
#32 CODEC #5 0x0690
```
