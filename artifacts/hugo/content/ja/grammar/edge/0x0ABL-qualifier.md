---
title: "QUALIFIER (0x0ABL)"
weight: 171
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "QUALIFIER は、別の Edge(主に TRIPLE)が収める命題を修飾する条件一つを付ける叙述 Edge である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `QUALIFIER` (規格ドキュメント BIND `QUALIFIER`) |
| TAG ID | `0x0ABL` |
| Codec ID | `0x00000AB0` |
| 規格ドキュメント | `0x00000000/codecs/0x00000AB0/` (DECLARE 対象 `0AB0`) |
| セクション | 5 `0101` (Edge 叙述)、セクション内オフセット C = 11 |
| Kind | Edge · 系列: 叙述、まとまり: 命題 |
| TAG WORD | `0000 1010 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | 別の Edge の命題を修飾する条件一つ。Property、Target(Edge Id)、Value(値、または UNKNOWN-VALUE・NO-VALUE のプレースホルダ)。命題の一部である |
| Hugo 側 | `edge/qualifier.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順序である([Codec 規格ドキュメント](../codec-spec.md))。Edge の Edge Id は FIELD で宣言しない。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受け取る形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `property` | #2 | レコード | 任意のレコード(プレースホルダを除く) |  |
| 2 | `target` | #3 | レコード | `0050` LOCAL |  |
| 3 | `value` | #4 | レコード | `000F` セクション 0 全体(ワイルドカード、Reference)、`020F` セクション 1 全体(ワイルドカード、Reference)、`040F` セクション 2 全体(ワイルドカード、Reference)、`060F` セクション 3 全体(ワイルドカード、Value)、`080F` セクション 4 全体(ワイルドカード、Value)、`0010` UNKNOWN-VALUE、`0020` NO-VALUE |  |

QUALIFIER は、別の Edge(主に [TRIPLE](0x0AAL-triple.md))が収める命題を修飾する条件一つを付ける叙述 Edge である。Codec `0x0ABL`。

ウィキデータの qualifier(snak)一つと同じである: プロパティ一つと値一つ。

## レイアウト {#레이아웃}

```
TAG WORD          0000 1010 1011 LLLL
[Length 拡張 TAG]
Edge Id           LOCAL Reference レコード
Property          Reference レコード (WIKIDATA-PID など)
Target            LOCAL Reference レコード (修飾する Edge の Edge Id)
Value             Reference または Value レコード、またはプレースホルダ 0x0010 UNKNOWN-VALUE·0x0020 NO-VALUE
```

- 構成要素の順序は TRIPLE と同じである(Property ↔ Predicate、Target ↔ Subject、Value ↔ Object)。デコーダは同じ経路で読む。役割は Codec が定める。

## 解釈と有効性 {#해석과-유효성}

- Property と Target は、ちょうど一つの完全な Reference レコードであり、Target は LOCAL Reference である。geul.org の規格ドキュメントは Target に [CODEC](0x0BEL-codec.md) LOCAL(`0050`)を置く。Value は、ちょうど一つの完全な Reference または Value レコード、または[プレースホルダ](../slot-marker.md) `0x0010`(UNKNOWN-VALUE)・`0x0020`(NO-VALUE)の 1 WORD である。規格ドキュメントは Value に CODEC `000F`、`020F`、`040F`(任意の Reference)、`060F`、`080F`(任意の Value)、`0010`、`0020` を置く。ABSENT(`0x0000`)は受け付けない。Property と Target はプレースホルダを受け付けない。Value を読み終えたカーソルは Edge の終端と一致しなければならない。
- Target は同じドキュメント内の Edge Id である。QUALIFIER は、修飾する Edge と同じドキュメントに置く。
- Target が HEAD の [SOURCE](0x0C0L-source.md#문서-전체의-출처)(ドキュメント全体の原典)であれば、QUALIFIER も HEAD の、その SOURCE の後に置く。それ以外の QUALIFIER は BODY に置く。HEAD の SOURCE を Target とする QUALIFIER が BODY にあれば invalid である。
- Target は TRIPLE 以外の Edge でもよい。[SOURCE](0x0C0L-source.md) に付いた QUALIFIER は引用行為を修飾する(参照日、原典内の位置など)。SOURCE の意味も、それを指す QUALIFIER をすべて集めたものである。
- **QUALIFIER は命題の一部である。** 命題についての別個の主張ではなく、命題が真となる条件を修飾する。対象 TRIPLE の意味は、それを指す QUALIFIER をすべて集めたものである。
  - 命題の出典は [SOURCE](0x0C0L-source.md) で書く。原典ノードの属性(タイトル、著者など)は、原典を Subject とする TRIPLE で書く。
- 同じ Target に同じ Property の QUALIFIER が複数あってもよい。同じ Target の QUALIFIER の順序はドキュメント内の順序である(Edge の順序に意味を与える例外)。

## 不明と無 {#알-수-없음과-없음}

QUALIFIER の Value がプレースホルダであれば、その修飾の意味が変わる。終了時点(P582)を例にとる。

| 対象 TRIPLE に付いたもの | 意味 | 今も有効な命題か |
|---|---|---|
| `QUALIFIER P582 #n EDTF("1974")` | 1974 年に終わった | いいえ |
| `QUALIFIER P582 #n UNKNOWN` | 終わった。いつかは分からない(ウィキデータの `somevalue`) | いいえ |
| `QUALIFIER P582 #n NONE` | 終わっていないと断言する(ウィキデータの `novalue`) | はい |
| P582 の QUALIFIER なし | 終わったか分からない(開世界) | 不明 |

- ウィキデータの qualifier の `somevalue`・`novalue` を捨てると、命題が広がる。終了時点が somevalue であることを捨てた国境の TRIPLE は、「今も有効な国境」と読まれる。そのため、移すときはプレースホルダとして移す。
- UNKNOWN-VALUE どうしは同じ値とは見なさない。比較結果は未定である。

## 例 (非規範) {#예시-비규범}

Q42 P69(educated at) Q691283(St John's College)、1971~1974。

```
TRIPLE     #9   P69   Q42  Q691283  rank 0
QUALIFIER  #10  P580  #9   EDTF "1971"
QUALIFIER  #11  P582  #9   EDTF "1974"
```

- `#10`: TAG 1 + Edge Id 2 + Property 2 + Target 2 + Value 3 = 10 WORD。Value は [EDTF](../value/0x06EL-edtf.md) `"1971"` である。

```
0AB9 0051 000A 0191 0244 0051 0009 06E2 3139 3731
```

Q30(アメリカ合衆国)–Q34266(ロシア帝国)の国境(P47)、終了時点が不明。Edge Id `2060`・`3160`。

```
0AA9 0051 080C 0191 002F 0141 001E 0141 85DA 0000      #2060 TRIPLE P47 Q30 Q34266 normal
0AB7 0051 0C58 0191 0246 0051 080C 0010                #3160 QUALIFIER P582 #2060 UNKNOWN
```

- `0AB7` = `000 0101 01011 0111`(セクション 5): Edge、Codec `0x0ABL`、8 WORD。TAG 1 + Edge Id 2 + Property P582(`0191 0246`) 2 + Target #2060(`0051 080C`) 2 + プレースホルダ 1。

Q30 の中央銀行(P1304)NO-VALUE の TRIPLE `#3161` に期間を付ける。1811~1816 年にだけなかった。

```
0AA8 0051 0C59 0191 0518 0141 001E 0020 0000           #3161 TRIPLE P1304 Q30 NONE normal
0AB9 0051 0C5A 0191 0244 0051 0C59 06E2 3138 3131      #3162 QUALIFIER P580 #3161 EDTF("1811")
0AB9 0051 0C5B 0191 0246 0051 0C59 06E2 3138 3136      #3163 QUALIFIER P582 #3161 EDTF("1816")
```

## 関連ページ {#관련-페이지}

- [Edge](_index.md), [TRIPLE](0x0AAL-triple.md), [SOURCE](0x0C0L-source.md), [WIKIDATA-PID](../reference/0x019L-wikidata-pid.md), [EDTF](../value/0x06EL-edtf.md), [プレースホルダ](../slot-marker.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00000AB0/latest.geul` を `geul show` で読んだ姿である(16進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000AB000000000
BODY
#1 DECLARE 0x0AB0
#2 FIELD #1 record
#3 FIELD #1 record
#4 FIELD #1 record
#5 BIND #1 "QUALIFIER"
#6 BIND #2 "property"
#7 BIND #3 "target"
#8 BIND #4 "value"
#9 CODEC #3 0x0050
#10 CODEC #4 0x000F
#14 CODEC #4 0x020F
#15 CODEC #4 0x040F
#11 CODEC #4 0x060F
#16 CODEC #4 0x080F
#12 CODEC #4 0x0010
#13 CODEC #4 0x0020
```
