---
title: "LOCAL (0x005L~0x009L)"
weight: 5
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "LOCAL は、このドキュメントが発行した ID で対象を指す宣言 Reference だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `LOCAL` (5Q グループ。コードごとの名前は下のメンバー表) |
| TAG ID | `0x005L~0x009L` |
| セクション | 0 `0000` (Reference エンティティ)、セクション内オフセット C = 5~9 |
| Kind | Reference · 分類: 宣言 |
| Hugo 側 | `reference/local.md` |

## メンバー {#구성원}

このページは 5Q 体系の 1 セット、コード 5 つをまとめて扱う。量化はセクション内オフセット `C % 5` だ([Reference](_index.md#quantifier))。Codec ドキュメントはコードごとに 1 つある。5 つの Codec ドキュメントはフィールドが同じで、DECLARE 対象と名前(BIND)だけが異なる。

| TAG ID | 名前 | 量化 | Codec ID | 規格ドキュメント | TAG WORD |
|---|---|---|---|---|---|
| `0x005L` | `LOCAL-IDENTIFIED` | Identified | `0x00000050` | `0x00000000/codecs/0x00000050/` | `0000 0000 0101 LLLL` |
| `0x006L` | `LOCAL-GENERIC` | Generic | `0x00000060` | `0x00000000/codecs/0x00000060/` | `0000 0000 0110 LLLL` |
| `0x007L` | `LOCAL-FREE-CHOICE` | Free-choice | `0x00000070` | `0x00000000/codecs/0x00000070/` | `0000 0000 0111 LLLL` |
| `0x008L` | `LOCAL-UNIVERSAL` | Universal | `0x00000080` | `0x00000000/codecs/0x00000080/` | `0000 0000 1000 LLLL` |
| `0x009L` | `LOCAL-VARIABLE` | Variable | `0x00000090` | `0x00000000/codecs/0x00000090/` | `0000 0000 1001 LLLL` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順だ([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受け取る形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `local-id` | #2 | 残り全部の生値(`0xFFFF`) |  |  |

LOCAL は、このドキュメントが発行した ID で対象を指す宣言 Reference だ。外部 Issuer なしにドキュメント内の対象を参照する。ドキュメントの外から指すには、ドキュメントに Meta [DOC-ID](../meta/0x1C7L-doc-id.md) を置き、別のドキュメントが指示 Reference で指す。

## レイアウト {#레이아웃}

```
TAG WORD          0000 0000 0101 LLLL      Codec 0x005L~0x009L (Identified 0x005L)
[Length 拡張 TAG]
LOCAL ID          最短幅の unsigned big-endian
```

| LOCAL ID | 全体 | TAG WORD (Identified) |
|---|---|---|
| `0..65535` | 2 WORD | `0x0051` |
| `65536..2^32-1` | 3 WORD | `0x0052` |
| `2^32..2^48-1` | 4 WORD | `0x0053` |
| `2^48..2^64-1` | 5 WORD | `0x0054` |

- Codec は `0x005L`(Identified)、`0x006L`(Generic)、`0x007L`(Free-choice)、`0x008L`(Universal)、`0x009L`(Variable)だ。Identified の TAG WORD は `0000 0000 0101 LLLL` だ。
- 対象 ID を最短の WORD 数で書く Reference 共通規則に従う。

## Edge Id {#edge-id}

- Edge Payload の最初の要素である LOCAL が、その Edge の Edge Id 宣言だ([Edge](../edge/_index.md))。Edge Id を宣言する LOCAL は Identified(`0x005L`)だけを使う。
- Edge Payload のそれ以外の位置にある LOCAL は言及だ。このドキュメントの対象は、言及するたびに LOCAL で書く。このドキュメントの対象を指す指示コードは別にない。

## 識別子の割り当て {#식별자-할당}

- ID は整数で、エンコーダが割り当てる。数の大きさと割り当て順は、同一性以外に何の意味もない。
- **UNIQUE(必須)。** 1 つのドキュメントで LOCAL ID 1 つは対象 1 つだけを指す。Edge Id はドキュメントごとに 1 回だけ宣言する(HEAD Edge と BODY Edge は 1 つの番号空間)。同じ Edge Id を宣言する Edge が 2 つ以上あれば invalid だ。
- **AUTO INCREMENT(推奨)。** 新しい ID は、そのドキュメントでこれまでに割り当てた ID の最大値 + 1 で割り当て、ドキュメント順に増えるようにする。バージョンをまたいでも同じだ(削除した ID より大きい値で新しく作る)。推奨にすぎず有効性の条件ではなく、増加しないドキュメントも valid だ。デコーダは ID の大きさや連続性に依存しない。
- ID `0` は割り当てない。どの対象も指さず、Edge Id にも使わない。対象 ID は `1` から割り当てる。
- ドキュメントは、そのドキュメントの内でも外でも [DOC-POINTER](0x041L-doc-pointer.md) 1 つだけで指す(自分自身は自分の `DOC-ID` の DOC-POINTER)。ドキュメントにも `BIND`・`LABEL`・判定 Edge を付けられる。
- Issuer 自身は [ISSUER-POINTER](0x040L-issuer-pointer.md) で指す。ドキュメント ID `0` は Issuer の用語定義索引ドキュメントだ。
- 構成要素位置の `0` に意味を与える Codec([TOULMIN](../toulmin/_index.md) REF・実行 Edge の「なし」、HEAD [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) Target の「ドキュメント全体」)は、その Codec の規則に従う。これは[プレースホルダ](../slot-marker.md)とは別の、その Codec 内の約束だ。
- 一度割り当てた ID は、同じドキュメントで再利用しない。
- 常に値を表現できる最小幅を使う。

## 同一性と範囲 {#동일성과-범위}

- 同じドキュメントで LOCAL ID の整数値が同じなら同じ対象だ。エンコード幅は同一性の一部ではない。
- Identified LOCAL は識別された対象を表す。匿名・未指定・null・sentinel の用途には使わない。値はあるが分からない(UNKNOWN-VALUE)、あるいは値がない(NO-VALUE)という言明は、そのマーカーを受け取るフィールドに[プレースホルダ](../slot-marker.md)として書く。
- 異なる LOCAL ID は異なる Reference であるにすぎず、現実の対象まで異なるという意味ではない。
- LOCAL の同一性をドキュメントの外へ広げない。別のドキュメントの同じ数字は無関係だ。
- Variable(`0x009L`)LOCAL は名前付きの談話変数だ([Reference](_index.md) Variable)。

## マージ {#병합}

複数のドキュメントを 1 つにマージするときは、元のドキュメントごとに `old ID → new ID` の対応表を作り、すべての LOCAL ID を新しいドキュメントの ID に振り直して参照をすべて置き換える。

- 同じ元ドキュメントで同じだった ID は、マージ後も同じでなければならない。
- 異なる元ドキュメントの同じ数字は無関係で、自動的に同じ Reference にまとめない。
- 置き換えられなかった LOCAL が 1 つでもあれば、マージを拒否する。

## 有効性 {#유효성}

次のエンコードや割り当ては invalid だ。

- 先頭に `0x0000` WORD がある non-minimal エンコード(値 0 の `0x0000` 1 WORD は例外)
- Edge Id 宣言位置の Codec が Identified(`0x005L`)でない、または ID が `0` の場合
- 同じドキュメントで ID 1 つを異なる対象に重複して割り当てた場合
- 同じドキュメントで同じ Edge Id を 2 回以上宣言した場合

## 例 {#예시}

| LOCAL ID | WORD sequence |
|---:|---|
| 1 | `0051 0001` |
| 65535 | `0051 FFFF` |
| 65536 | `0052 0001 0000` |
| 4294967295 | `0052 FFFF FFFF` |
| 1, Variable | `0091 0001` |

## 関連ページ {#관련-페이지}

- [Reference](_index.md)、[DOC-POINTER](0x041L-doc-pointer.md)、[ISSUER-POINTER](0x040L-issuer-pointer.md)、[EXTERNAL-POINTER](0x020L-external-pointer-1word.md)
- [Edge](../edge/_index.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00000050/latest.geul` を `geul show` で読んだ様子だ(16進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000005000000000
BODY
#1 DECLARE 0x0050
#2 FIELD #1 rest
#3 BIND #1 "LOCAL-IDENTIFIED"
#4 BIND #2 "local-id"
```

上は `LOCAL-IDENTIFIED`(`0x005L`)の Codec ドキュメントだ。ほかのメンバー(`LOCAL-GENERIC`、`LOCAL-FREE-CHOICE`、`LOCAL-UNIVERSAL`、`LOCAL-VARIABLE`)の Codec ドキュメントは、DOC-ID の Codec ID、DECLARE 対象、`#1` に結んだ名前(BIND)だけが異なる。
