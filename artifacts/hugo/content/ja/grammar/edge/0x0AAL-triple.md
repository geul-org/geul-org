---
title: "TRIPLE (0x0AAL)"
weight: 170
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "TRIPLE は、命題一つ(Predicate、Subject、Object)とその等級(rank)を収める叙述 Edge である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `TRIPLE` (規格ドキュメント BIND `TRIPLE`) |
| TAG ID | `0x0AAL` |
| Codec ID | `0x00000AA0` |
| 規格ドキュメント | `0x00000000/codecs/0x00000AA0/` (DECLARE 対象 `0AA0`) |
| セクション | 5 `0101` (Edge 叙述)、セクション内オフセット C = 10 |
| Kind | Edge · 系列: 叙述、まとまり: 命題 |
| TAG WORD | `0000 1010 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | Predicate、Subject、Object の順の命題と rank。Object は値、または UNKNOWN-VALUE・NO-VALUE のプレースホルダ。意味は、その Edge Id を指す QUALIFIER をすべて集めたものである |
| Hugo 側 | `edge/triple.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順序である([Codec 規格ドキュメント](../codec-spec.md))。Edge の Edge Id は FIELD で宣言しない。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受け取る形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `predicate` | #2 | レコード | `000F` セクション 0 全体(ワイルドカード、Reference)、`020F` セクション 1 全体(ワイルドカード、Reference)、`040F` セクション 2 全体(ワイルドカード、Reference) |  |
| 2 | `subject` | #3 | レコード | `000F` セクション 0 全体(ワイルドカード、Reference)、`020F` セクション 1 全体(ワイルドカード、Reference)、`040F` セクション 2 全体(ワイルドカード、Reference) |  |
| 3 | `object` | #4 | レコード | `000F` セクション 0 全体(ワイルドカード、Reference)、`020F` セクション 1 全体(ワイルドカード、Reference)、`040F` セクション 2 全体(ワイルドカード、Reference)、`060F` セクション 3 全体(ワイルドカード、Value)、`080F` セクション 4 全体(ワイルドカード、Value)、`0010` UNKNOWN-VALUE、`0020` NO-VALUE |  |
| 4 | `rank` | #5 | 生値 1 WORD | `0620` UNSIGNED-INTEGER | `0x0000` normal, `0x0001` preferred, `0x0002` deprecated |

TRIPLE は、命題一つ(Predicate、Subject、Object)とその等級(rank)を収める叙述 Edge である。Codec `0x0AAL`。

命題を修飾する条件(開始・終了時点、適用範囲など)は、TRIPLE の Edge Id を指す [QUALIFIER](0x0ABL-qualifier.md) で付ける。出典(ウィキデータの references)は、TRIPLE の Edge Id を指す根拠 Edge [SOURCE](0x0C0L-source.md) で付ける。

## レイアウト {#레이아웃}

```
TAG WORD          0000 1010 1010 LLLL
[Length 拡張 TAG]
Edge Id           LOCAL Reference レコード
Predicate         Reference レコード (WIKIDATA-PID など)
Subject           Reference レコード
Object            Reference または Value レコード、またはプレースホルダ 0x0010 UNKNOWN-VALUE·0x0020 NO-VALUE
Rank              1 WORD (ENUM)
```

## Rank {#rank}

| コード | 名前 | 意味 |
|---|---|---|
| `0` | normal | 既定 |
| `1` | preferred | 現在の値、最も権威ある値 |
| `2` | deprecated | 誤り、または古いと判定されたが記録として残した値 |

- ウィキデータの statement rank と同じである。代表値(ウィキデータの truthy)は、同じ Subject・Predicate の中で preferred があれば preferred、なければ normal である。
- rank を別に付けない出典は `0`(normal)を使う。
- それ以外のコードは invalid である。

## 解釈と有効性 {#해석과-유효성}

- Predicate と Subject は、ちょうど一つの完全な Reference レコードである。
- Object は、ちょうど一つの完全な Reference または Value レコード、または[プレースホルダ](../slot-marker.md) `0x0010`(UNKNOWN-VALUE)・`0x0020`(NO-VALUE)の 1 WORD である。ABSENT(`0x0000`)は受け付けない。Object は省略可能なフィールドではない。
- Object を読み終えた後、ちょうど 1 WORD(Rank)が残らなければならない。
- geul.org の規格ドキュメントは、Rank 生値フィールドに [CODEC](0x0BEL-codec.md) UNSIGNED-INTEGER(`0620`)と [ENUM](0x0BDL-enum.md) 0・1・2 を置く。Object フィールドには CODEC `000F`・`020F`・`040F`(任意の Reference)、`060F`・`080F`(任意の Value)、`0010`(UNKNOWN-VALUE)、`0020`(NO-VALUE)を置く。Predicate・Subject フィールドには CODEC `000F`・`020F`・`040F`(任意の Reference)を置く。ワイルドカードなのでプレースホルダは受け付けない。
- **TRIPLE の意味は、同じドキュメントでその Edge Id を指す QUALIFIER をすべて集めたものである。** 読み手は TRIPLE を解釈する前に QUALIFIER を集める。QUALIFIER なしで読んだ TRIPLE は、修飾が欠けた命題である可能性がある(例: 時間の修飾が欠けた「行政府の長」)。

## 不明と無 {#알-수-없음과-없음}

Object の位置のプレースホルダは、値ではなく命題についての断言である。

| Object | 意味 | 論理 |
|---|---|---|
| 値 v | Subject の Predicate の値の一つが v である | `P(s, v)` |
| UNKNOWN-VALUE (`0x0010`) | 値がある。何であるかは分からない(ウィキデータの `somevalue`) | `∃x. P(s, x)` |
| NO-VALUE (`0x0020`) | 値がない(ウィキデータの `novalue`) | `¬∃x. P(s, x)` |
| TRIPLE なし | 何も断言しない(開世界) | |

- **修飾条件の中で読む。** `∃`・`¬∃` の範囲は、その TRIPLE を指す QUALIFIER が定める。QUALIFIER が付けば、その範囲でのみ閉じる。「1811~1816 年には中央銀行がなかった」は、NO-VALUE の TRIPLE に P580・P582 の QUALIFIER を付けて書く。同じ Predicate の別の時期の値の TRIPLE とは矛盾しない。
- **rank は同じように適用される。** 代表値(truthy)を選ぶとき、UNKNOWN-VALUE・NO-VALUE の TRIPLE も候補に入る。preferred があれば preferred だけが残る。
- **UNKNOWN-VALUE どうしは等しくない。** UNKNOWN-VALUE はどの値とも等しくも異なりもせず(比較結果は未定)、二つの UNKNOWN-VALUE どうしも同じ値とは見なさない。出現ごとに独立した存在量化である。したがって、バイト列が同じ UNKNOWN-VALUE の TRIPLE 二つは重複ではなく、マージしない(子が二人かもしれず、一人かもしれない)。
- 同じ Subject・Predicate・rank に、NO-VALUE と値(または UNKNOWN-VALUE)の TRIPLE が、修飾条件で区別されないまま共存すれば矛盾である。検証器は警告する。拒否はしない(ウィキデータにもある状態である)。
- 移せなかった値(出典には値がある)を UNKNOWN-VALUE として書かない。

## 例 (非規範) {#예시-비규범}

Q42(Douglas Adams) P31(instance of) Q5(human)、normal。Edge Id `0005`。

- TAG 1 + Edge Id 2 + Predicate 2 + Subject 2 + Object 2 + Rank 1 = 10 WORD、`LLLL=1001`。TAG は `0000 1010 1010 1001` = `0AA9` である。

```
0AA9 0051 0005 0191 001F 0141 002A 0141 0005 0000
```

Q30(アメリカ合衆国) P1304(中央銀行) NO-VALUE、normal。1811~1816 年には中央銀行がなかった(P580・P582 の QUALIFIER は [QUALIFIER](0x0ABL-qualifier.md) の例)。Edge Id `3161`。

- TAG 1 + Edge Id 2 + Predicate 2 + Subject 2 + Object 1 + Rank 1 = 9 WORD、`LLLL=1000`。TAG は `0000 1010 1010 1000` = `0AA8` である。

```
0AA8 0051 0C59 0191 0518 0141 001E 0020 0000      #3161 TRIPLE P1304 Q30 NONE normal
```

- 「子(P40)なし」は `0AA8 0051 <Edge Id> 0191 0028 <Subject> 0020 0000` である。

## 未解決の問題 {#열린-문제}

- scope(主張の文脈: 世界、観点): 用途が生じたときに定める。
- TRIPLE と QUALIFIER を一つのレコードに畳む短縮形: 繰り返しフィールド宣言([DECLARE](0x0BBL-declare.md)の未解決の問題)ができた後。

## 関連ページ {#관련-페이지}

- [Edge](_index.md), [QUALIFIER](0x0ABL-qualifier.md), [SOURCE](0x0C0L-source.md), [LABEL](0x0A4L-label.md), [ALIAS](0x0A5L-alias.md), [プレースホルダ](../slot-marker.md)
- [WIKIDATA-PID](../reference/0x019L-wikidata-pid.md), [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00000AA0/latest.geul` を `geul show` で読んだ姿である(16進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000AA000000000
BODY
#1 DECLARE 0x0AA0
#2 FIELD #1 record
#3 FIELD #1 record
#4 FIELD #1 record
#5 FIELD #1 0x0001
#6 ENUM #5 0x0000
#7 ENUM #5 0x0001
#8 ENUM #5 0x0002
#9 BIND #1 "TRIPLE"
#10 BIND #2 "predicate"
#11 BIND #3 "subject"
#12 BIND #4 "object"
#13 BIND #5 "rank"
#14 BIND #6 "normal"
#15 BIND #7 "preferred"
#16 BIND #8 "deprecated"
#17 CODEC #5 0x0620
#18 CODEC #4 0x000F
#22 CODEC #4 0x020F
#23 CODEC #4 0x040F
#19 CODEC #4 0x060F
#24 CODEC #4 0x080F
#20 CODEC #4 0x0010
#21 CODEC #4 0x0020
#25 CODEC #2 0x000F
#26 CODEC #2 0x020F
#27 CODEC #2 0x040F
#28 CODEC #3 0x000F
#29 CODEC #3 0x020F
#30 CODEC #3 0x040F
```
