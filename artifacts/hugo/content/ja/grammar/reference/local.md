---
title: "LOCAL"
weight: 2
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "LOCAL は、このドキュメントが発行した ID で対象を指す宣言 Reference だ。Edge Id も LOCAL だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LOCAL は、このドキュメントが発行した ID で対象を指す宣言 Reference だ。外部の Issuer なしでドキュメント内の対象を参照し、ドキュメントの外では意味がない。ドキュメントの外から指すには、ドキュメントに Meta [DOC-ID](/ja/grammar/meta/declaration/doc-id/) を置き、他のドキュメントが指示 Reference で指す。

## レイアウト

```
TAG WORD          0000 0LLL L000 1QQQ      CCCC = 0001
[Length 拡張 TAG]
LOCAL ID          最短幅の unsigned big-endian
```

| LOCAL ID | 全体 | TAG WORD (Identified) |
|---|---|---|
| `0..65535` | 2 WORD | `0x0088` |
| `65536..2^32-1` | 3 WORD | `0x0108` |
| `2^32..2^48-1` | 4 WORD | `0x0188` |
| `2^48..2^64-1` | 5 WORD | `0x0208` |

- TAG WORD は `0000 0 LLLL 0001 QQQ` だ。Identified(`000`)のとき、下位7ビットは `0x08` だ。
- 対象 ID を最短の WORD 数で書くという Reference 共通の規則に従う。

## Edge Id

- Edge Payload の最初の要素である LOCAL が、その Edge の Edge Id の宣言だ([Edge](/ja/grammar/edge/))。Edge Id を宣言する LOCAL の Quantifier は `000` だけを使う。
- Edge Payload のそれ以外の位置にある LOCAL は言及だ。このドキュメントの対象は、言及するたびに LOCAL で書く。このドキュメントの対象を指す指示コードは別にない。

## 識別子の割り当て

- ID は整数で、エンコーダが割り当てる。数字の大きさと割り当て順序は、同一性以外に何の意味もない。
- **UNIQUE(必須)。** 一つのドキュメントで、LOCAL ID 一つは対象一つだけを指す。Edge Id はドキュメントごとに一度だけ宣言する(HEAD Edge と BODY Edge が一つの番号空間)。同じ Edge Id を宣言する Edge が二つ以上あれば invalid だ。
- **AUTO INCREMENT(推奨)。** 新しい ID は、そのドキュメントでこれまで割り当てた ID の最大値 + 1 で割り当て、ドキュメントの順に増えるようにする。バージョンを越えても同じだ(削除した ID より大きい値で新しく作る)。推奨にすぎず有効性の条件ではなく、増加しないドキュメントも valid だ。デコーダは ID の大きさや連続性に依拠しない。
- ID `0` は割り当てない。どの対象も指さず、Edge Id としても使わない。対象 ID は `1` から割り当てる。
- ドキュメントは、そのドキュメントの中でも外でも [DOC-POINTER](/ja/grammar/reference/doc-pointer/) 一つだけで指す(自分自身は自分の `DOC-ID` の DOC-POINTER)。ドキュメントにも `BIND`・`LABEL`・判定 Edge を付けられる。
- Issuer 自身は [ISSUER-POINTER](/ja/grammar/reference/issuer-pointer/) で指す。ドキュメント ID `0` は、Issuer の用語定義インデックスドキュメントだ。
- 構成要素の位置の `0` に意味を与える Codec([TOULMIN](/ja/grammar/edge/toulmin/) の REF・実行 Edge の「なし」、HEAD [SOURCE](/ja/grammar/edge/source/#ドキュメント全体の出典) の Target の「ドキュメント全体」)は、その Codec の規則に従う。これは[プレースホルダ](/ja/grammar/reference/slot-marker/)とは異なる、その Codec 内の約束だ。
- 一度割り当てた ID は、同じドキュメントで再利用しない。
- 常に値を表現できる最小幅を使う。

## 同一性と範囲

- 同じドキュメントで LOCAL ID の整数値が同じなら、同じ対象だ。エンコード幅は同一性の一部ではない。
- Identified LOCAL は、識別された対象を表す。匿名・未指定・null・sentinel の用途に使わない。値はあるが分からない(UNKNOWN-VALUE)、あるいは値がない(NO-VALUE)という言葉は、そのマーカーを受け付けるフィールドに[プレースホルダ](/ja/grammar/reference/slot-marker/)として書く。
- 異なる LOCAL ID は異なる Reference にすぎず、現実の対象まで互いに異なるという意味ではない。
- LOCAL の同一性を、ドキュメントの外に広げない。他のドキュメントの同じ数字は無関係だ。
- Variable(`100`)の LOCAL は、名前のある談話変数だ([Reference](/ja/grammar/reference/) の Variable)。

## マージ

複数のドキュメントを一つにマージするときは、元のドキュメントごとに `old ID → new ID` の対応表を作り、すべての LOCAL ID を新しいドキュメントの ID に振り直して、参照をすべて置き換える。

- 同じ元のドキュメントで同じだった ID は、マージ後も同じでなければならない。
- 異なる元のドキュメントの同じ数字は無関係で、自動的に同じ Reference に統合しない。
- 置き換えられなかった LOCAL が一つでもあれば、マージを拒否する。

## 有効性

次のエンコードや割り当ては invalid だ。

- 先頭に `0x0000` WORD のある non-minimal エンコード(値 0 の `0x0000` 1 WORD は例外)
- Edge Id 宣言位置の Quantifier が `000` でない、または ID が `0` の場合
- 同じドキュメントで ID 一つを、異なる対象に重ねて割り当てた場合
- 同じドキュメントで同じ Edge Id を二度以上宣言した場合

## 例

| LOCAL ID | WORD sequence |
|---:|---|
| 1 | `0088 0001` |
| 65535 | `0088 ffff` |
| 65536 | `0108 0001 0000` |
| 4294967295 | `0108 ffff ffff` |
| 1、Variable | `008C 0001` |

## 関連ページ

- [Reference](/ja/grammar/reference/)、[DOC-POINTER](/ja/grammar/reference/doc-pointer/)、[ISSUER-POINTER](/ja/grammar/reference/issuer-pointer/)、[EXTERNAL-POINTER](/ja/grammar/reference/external-pointer/)
- [Edge](/ja/grammar/edge/)
