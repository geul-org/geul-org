---
title: "TRIPLE"
weight: 11
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "TRIPLE は命題一つ(Predicate、Subject、Object)とその等級(rank)を収める記述 Edge だ(Codec 0x0A)。Object には値の代わりに不明(UNKNOWN-VALUE)やなし(NO-VALUE)を使える。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TRIPLE は、命題一つ(Predicate、Subject、Object)とその等級(rank)を収める記述 Edge だ。Codec `0x0A`。

命題を限定する条件(開始・終了時点、適用範囲など)は、TRIPLE の Edge Id を指す [QUALIFIER](/ja/grammar/edge/qualifier/) で付ける。出典(Wikidata references)は、TRIPLE の Edge Id を指す根拠 Edge [SOURCE](/ja/grammar/edge/source/) で付ける。

## レイアウト

```
TAG WORD          0001 0LLL L000 1010
[Length 拡張 TAG]
Edge Id           LOCAL Reference レコード
Predicate         Reference レコード (WIKIDATA-PID など)
Subject           Reference レコード
Object            Reference または Value レコード、またはプレースホルダ 0x0001 UNKNOWN-VALUE・0x0002 NO-VALUE
Rank              1 WORD (ENUM)
```

## Rank

| コード | 名前 | 意味 |
|---|---|---|
| `0` | normal | 既定 |
| `1` | preferred | 現在の値、最も権威のある値 |
| `2` | deprecated | 誤りまたは古いと判定されたが、記録として残した値 |

- Wikidata の statement rank と同じだ。代表値(Wikidata truthy)は、同じ Subject・Predicate の中で preferred があれば preferred、なければ normal だ。
- rank を別に付けない出典は `0`(normal)を使う。
- それ以外のコードは invalid だ。

## 解釈と有効性

- Predicate と Subject は、ちょうど一つの完全な Reference レコードだ。
- Object は、ちょうど一つの完全な Reference または Value レコード、または[プレースホルダ](/ja/grammar/reference/slot-marker/) `0x0001`(UNKNOWN-VALUE)・`0x0002`(NO-VALUE)の 1 WORD だ。ABSENT(`0x0000`)は受け付けない。Object はオプションフィールドではない。
- Object を読んだ後に、ちょうど 1 WORD(Rank)が残らなければならない。
- geul.org 規格ドキュメントは、Rank 生値フィールドに [CODEC](/ja/grammar/edge/codec/) UNSIGNED-INTEGER(`0802`)と [ENUM](/ja/grammar/edge/enum/) 0・1・2 を置く。Object フィールドには CODEC `0780`(任意の Reference)、`0F80`(任意の Value)、`0001`(UNKNOWN-VALUE)、`0002`(NO-VALUE)を置く。Predicate・Subject はプレースホルダを受け付けない。
- **TRIPLE の意味は、同じドキュメントでその Edge Id を指す QUALIFIER をすべて集めたものだ。** 読む側は TRIPLE を解釈する前に QUALIFIER を集める。QUALIFIER なしで読んだ TRIPLE は、限定が欠けた命題かもしれない(例: 時間の限定が抜けた「行政府の長」)。

## 不明となし

Object の位置のプレースホルダは、値ではなく命題についての断言だ。

| Object | 意味 | 論理 |
|---|---|---|
| 値 v | Subject の Predicate の値のうち一つが v だ | `P(s, v)` |
| UNKNOWN-VALUE (`0x0001`) | 値がある。何かは分からない(Wikidata `somevalue`) | `∃x. P(s, x)` |
| NO-VALUE (`0x0002`) | 値がない(Wikidata `novalue`) | `¬∃x. P(s, x)` |
| TRIPLE なし | 何も断言しない(開いた世界) | |

- **限定条件の中で読む。** `∃`・`¬∃` の範囲は、その TRIPLE を指す QUALIFIER が決める。QUALIFIER が付けば、その範囲でのみ閉じる。「1811~1816年には中央銀行がなかった」は、NO-VALUE TRIPLE に P580・P582 QUALIFIER を付けて書く。同じ Predicate の別の時期の値の TRIPLE と矛盾しない。
- **rank も同様に適用される。** 代表値(truthy)を選ぶとき、UNKNOWN-VALUE・NO-VALUE TRIPLE も候補に入る。preferred があれば preferred だけが残る。
- **UNKNOWN-VALUE 同士は同じではない。** UNKNOWN-VALUE はどの値とも同じでも異なるでもなく(比較結果は未定)、二つの UNKNOWN-VALUE 同士も同じ値と見なさない。出現ごとに独立した存在量化だ。そのためバイトが同じ UNKNOWN-VALUE TRIPLE が二つあっても重複ではなく、マージしない(子が二人かもしれないし、一人かもしれない)。
- 同じ Subject・Predicate・rank に NO-VALUE と値(または UNKNOWN-VALUE)の TRIPLE が、限定条件で区別されないまま併存していれば矛盾だ。検査器は警告する。拒否はしない(Wikidata にもある状態だ)。
- 移せなかった値(原典には値がある)を UNKNOWN-VALUE として書かない。

## 例 (非規範)

Q42(Douglas Adams) P31(instance of) Q5(human)、normal。Edge Id `0005`。

- TAG 1 + Edge Id 2 + Predicate 2 + Subject 2 + Object 2 + Rank 1 = 10 WORD、`LLLL=1001`。TAG は `0001 0 1001 0001010` = `148A` だ。

```
148A 0088 0005 00A8 001f 00A0 002a 00A0 0005 0000
```

Q30(アメリカ) P1304(中央銀行) NO-VALUE、normal。1811~1816年には中央銀行がなかった(P580・P582 QUALIFIER は [QUALIFIER](/ja/grammar/edge/qualifier/) の例)。Edge Id `3161`。

- TAG 1 + Edge Id 2 + Predicate 2 + Subject 2 + Object 1 + Rank 1 = 9 WORD、`LLLL=1000`。TAG は `0001 0 1000 0001010` = `140A` だ。

```
140A 0088 0C59 00A8 0518 00A0 001E 0002 0000      #3161 TRIPLE P1304 Q30 NONE normal
```

- 「子(P40)なし」は `140A 0088 <Edge Id> 00A8 0028 <Subject> 0002 0000` だ。

## 未解決の問題

- scope(主張の文脈: 世界、観点): 用途が生じたときに決める。
- TRIPLE と QUALIFIER を一つのレコードに畳む短縮形: 繰り返しフィールドの宣言([DECLARE](/ja/grammar/edge/declare/) の未解決の問題)ができた後。

## 関連ページ

- [Edge](/ja/grammar/edge/)、[QUALIFIER](/ja/grammar/edge/qualifier/)、[SOURCE](/ja/grammar/edge/source/)、[LABEL](/ja/grammar/edge/label/)、[ALIAS](/ja/grammar/edge/alias/)、[プレースホルダ](/ja/grammar/reference/slot-marker/)
- [WIKIDATA-PID](/ja/grammar/reference/wikidata-pid/)、[WIKIDATA-QID](/ja/grammar/reference/wikidata-qid/)
