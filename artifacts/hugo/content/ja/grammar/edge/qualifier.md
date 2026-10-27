---
title: "QUALIFIER"
weight: 12
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "QUALIFIER は他の Edge(主に TRIPLE)の命題を限定する条件一つを付ける記述 Edge だ(Codec 0x0B)。Value には値の代わりに不明(UNKNOWN-VALUE)やなし(NO-VALUE)を使える。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUALIFIER は、他の Edge(主に [TRIPLE](/ja/grammar/edge/triple/))が収める命題を限定する条件一つを付ける記述 Edge だ。Codec `0x0B`。

Wikidata の qualifier(snak)一つと同じだ: プロパティ一つと値一つ。

## レイアウト

```
TAG WORD          0001 0LLL L000 1011
[Length 拡張 TAG]
Edge Id           LOCAL Reference レコード
Property          Reference レコード (WIKIDATA-PID など)
Target            LOCAL Reference レコード (限定する Edge の Edge Id)
Value             Reference または Value レコード、またはプレースホルダ 0x0001 UNKNOWN-VALUE・0x0002 NO-VALUE
```

- 構成要素の順序は TRIPLE と同じだ(Property ↔ Predicate、Target ↔ Subject、Value ↔ Object)。デコーダは同じ経路で読む。役割は Codec が決める。

## 解釈と有効性

- Property と Target は、ちょうど一つの完全な Reference レコードで、Target は LOCAL Reference だ。geul.org 規格ドキュメントは、Target に [CODEC](/ja/grammar/edge/codec/) LOCAL(`0008`)を置く。Value は、ちょうど一つの完全な Reference または Value レコード、または[プレースホルダ](/ja/grammar/reference/slot-marker/) `0x0001`(UNKNOWN-VALUE)・`0x0002`(NO-VALUE)の 1 WORD だ。規格ドキュメントは Value に CODEC `0780`、`0F80`、`0001`、`0002` を置く。ABSENT(`0x0000`)は受け付けない。Property・Target はプレースホルダを受け付けない。Value を読み終えたカーソルは、Edge の終わりと合わなければならない。
- Target は同じドキュメント内の Edge Id だ。QUALIFIER は、限定する Edge と同じドキュメントに置く。
- Target が HEAD の [SOURCE](/ja/grammar/edge/source/#ドキュメント全体の出典)(ドキュメント全体の原典)なら、QUALIFIER も HEAD の、その SOURCE の後ろに置く。それ以外の QUALIFIER は BODY に置く。HEAD の SOURCE を Target とする QUALIFIER が BODY にあれば invalid だ。
- Target は TRIPLE 以外の Edge でもよい。[SOURCE](/ja/grammar/edge/source/) に付いた QUALIFIER は引用行為を限定する(参照日、原典内の位置など)。SOURCE の意味も、それを指す QUALIFIER をすべて集めたものだ。
- **QUALIFIER は命題の一部だ。** 命題についての別個の主張ではなく、命題が真になる条件を限定する。対象 TRIPLE の意味は、それを指す QUALIFIER をすべて集めたものだ。
  - 命題の出典は [SOURCE](/ja/grammar/edge/source/) で書く。原典ノードの属性(タイトル、著者など)は、原典を Subject とする TRIPLE で書く。
- 同じ Target に同じ Property の QUALIFIER が複数あってもよい。同じ Target の QUALIFIER の順序は、ドキュメント内の順序だ(Edge の順序に意味を与える例外)。

## 不明となし

QUALIFIER の Value がプレースホルダなら、その限定の意味が変わる。終了時点(P582)を例にする。

| 対象 TRIPLE に付いたもの | 意味 | 今も有効な命題か |
|---|---|---|
| `QUALIFIER P582 #n EDTF("1974")` | 1974年に終わった | いいえ |
| `QUALIFIER P582 #n UNKNOWN` | 終わった。いつかは分からない(Wikidata `somevalue`) | いいえ |
| `QUALIFIER P582 #n NONE` | 終わっていないと断言する(Wikidata `novalue`) | はい |
| P582 QUALIFIER なし | 終わったか分からない(開いた世界) | 分からない |

- Wikidata qualifier の `somevalue`・`novalue` を捨てると、命題が広がる。終了時点の somevalue を捨てた国境 TRIPLE は、「今も有効な国境」と読まれる。そのため移すときはマーカーとして移す。
- UNKNOWN-VALUE 同士は同じ値と見なさない。比較結果は未定だ。

## 例 (非規範)

Q42 P69(educated at) Q691283(St John's College)、1971~1974。

```
TRIPLE     #9   P69   Q42  Q691283  rank 0
QUALIFIER  #10  P580  #9   EDTF "1971"
QUALIFIER  #11  P582  #9   EDTF "1974"
```

- `#10`: TAG 1 + Edge Id 2 + Property 2 + Target 2 + Value 3 = 10 WORD。Value は [EDTF](/ja/grammar/value/time/edtf/) `"1971"` だ。

```
148B 0088 000A 00A8 0244 0088 0009 0924 3139 3731
```

Q30(アメリカ)–Q34266(ロシア帝国)の国境(P47)、終了時点が不明。Edge Id `2060`・`3160`。

```
148A 0088 080C 00A8 002F 00A0 001E 00A0 85DA 0000      #2060 TRIPLE P47 Q30 Q34266 normal
138B 0088 0C58 00A8 0246 0088 080C 0001                #3160 QUALIFIER P582 #2060 UNKNOWN
```

- `138B` = `000 10 0111 0001011`: Edge、8 WORD、Codec `0x0B`。TAG 1 + Edge Id 2 + Property P582(`00A8 0246`) 2 + Target #2060(`0088 080C`) 2 + マーカー 1。

Q30 の中央銀行(P1304)NO-VALUE の TRIPLE `#3161` に期間を付ける。1811~1816年にだけなかった。

```
140A 0088 0C59 00A8 0518 00A0 001E 0002 0000           #3161 TRIPLE P1304 Q30 NONE normal
148B 0088 0C5A 00A8 0244 0088 0C59 0924 3138 3131      #3162 QUALIFIER P580 #3161 EDTF("1811")
148B 0088 0C5B 00A8 0246 0088 0C59 0924 3138 3136      #3163 QUALIFIER P582 #3161 EDTF("1816")
```

## 関連ページ

- [Edge](/ja/grammar/edge/)、[TRIPLE](/ja/grammar/edge/triple/)、[SOURCE](/ja/grammar/edge/source/)、[WIKIDATA-PID](/ja/grammar/reference/wikidata-pid/)、[EDTF](/ja/grammar/value/time/edtf/)、[プレースホルダ](/ja/grammar/reference/slot-marker/)
