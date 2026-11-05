---
title: "Edge"
weight: 120
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "Edge は、ほかのレコードを構成要素としてまとめて叙述するレコードである。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Edge は、ほかのレコードを構成要素としてまとめて叙述するレコードである。「Q42 は人である」「Q42 の英語名は Douglas Adams である」のような叙述が Edge 一つである。

## レイアウト {#레이아웃}

```
TAG WORD          000K KKKC CCCC LLLL      セクション 5~13 (0x0A0L~0x1BFL)
[Length 拡張 TAG]
[Codec 拡張 TAG]  Issuer 形式のとき
Edge Id           LOCAL Reference レコード
構成要素          Codec が定めた順序
```

- `LLLL` は TAG WORD を含む全体の WORD 数 − 1 である。デコーダは Codec を知らなくても Length だけで次のレコードへ読み飛ばせる。
- **最初の構成要素は常に Edge Id(LOCAL Reference)である。** LOCAL Reference(`0051` + ID、Identified `0x005L`)なので、Codec を知らなくても Edge Id を読める。
- 構成要素はそれぞれ自分の Length で境界を見つける。最後の構成要素を読み終えた位置が Edge の終端とちょうど一致しなければならない。
- 構成要素の構成(Payload)は各 Edge Codec のドキュメントが定める。
- 下位形式をもつ Codec(WORLD、TIMELINE、SCENE)では、Codec ごとの TAG 1 WORD が下位形式を指定する。
- Edge レコード間の順序に意味はない(Codec が別に定めた場合を除く。例: [TOULMIN](../toulmin/_index.md) のドキュメント)。
- 別の Edge は Edge Id で指す。このドキュメントの Edge は LOCAL で、別のドキュメントの Edge は指示 Reference(`EXTERNAL-POINTER-*`、`EXTERNAL-ISSUER-*`)で指す。

## 系列 {#계열}

Edge 領域は `0x0A0L~0x1BFL` である。直接コードの系列は `(コード − 0xA0) >> 5` である(コードは TAG ID の上位 3 桁)。系列は 32 マスずつで、セクション `w >> 9` から 5 を引いた値と等しい。Edge はセクション 5~13 である。

| セクション | 系列 | 直接コード | 役割 |
|---|---|---|---|
| 5 | 叙述 | `0x0A0L~0x0BFL` | 世界と出来事に関する内容を構成する |
| 6 | 根拠 | `0x0C0L~0x0DFL` | レコードとドキュメントがどこから来たか([SOURCE](0x0C0L-source.md)) |
| 7 | 実行 | `0x0E0L~0x0FFL` | 実行可能なプログラム構造(AST) |
| 8 | [TOULMIN](../toulmin/_index.md) | `0x100L~0x11BL` | 論証グラフ: 主張・反駁・例外、攻撃関係、実行、判定結果 |
| 9 | [TOULMIN](../toulmin/_index.md) 形式 | `0x120L~0x134L` | TOULMIN ドキュメントの原文・区画・補助ノードと関係 |

- 割り当て済みの直接コードはこの五つの系列である。`0x11CL~0x11FL` は Reserved で、`0x135L~0x1BCL` は Reserved である(セクション 10~12 はセクション全体が Reserved)。
- `0x1BDL~0x1BFL`(セクション 13 の末尾三マス)は EDGE-ISSUER である(下記 Issuer 形式 Edge)。Issuer 形式には系列の規則がない。

## 叙述 Edge {#서술-edge}

| Codec | 名前 | 構成要素 |
|---|---|---|
| `0x0A0L` | [REFERENCE-NODE](0x0A0L-reference-node.md) | Subject(Reference)が Object を指すという方向性バインディング |
| `0x0A1L` | [SAME-NODE](0x0A1L-same-node.md) | 二つの Reference が同じ対象を指す |
| `0x0A2L` | [DIFFERENT-NODE](0x0A2L-different-node.md) | 二つの Reference が異なる対象を指す |
| `0x0A3L` | [BIND](0x0A3L-bind.md) | Subject に機械用の名前(UTF8-TEXT)を結びつける |
| `0x0A4L` | [LABEL](0x0A4L-label.md) | Subject の言語別の名前(UTF8-LANGUAGE-TEXT) |
| `0x0A5L` | [ALIAS](0x0A5L-alias.md) | Subject の別名。レイアウトは LABEL と同じ |
| `0x0A6L` | [DESCRIPTION](0x0A6L-description.md) | Subject の言語別の説明。レイアウトは LABEL と同じ |
| `0x0A8L`/`0x0A9L` | [VERB-SHORT](0x0A8L-verb-short.md) / [VERB](0x0A9L-verb.md) | 動詞の叙述 |
| `0x0AAL` | [TRIPLE](0x0AAL-triple.md) | 命題一つ(Predicate、Subject、Object)と rank |
| `0x0ABL` | [QUALIFIER](0x0ABL-qualifier.md) | 別の Edge の命題を修飾する条件一つ |
| `0x0B0L~0x0B2L` | [WORLD](0x0B0L-world.md) / [TIMELINE](0x0B1L-timeline.md) / [SCENE](0x0B2L-scene.md) | 世界観、出来事の順序、場面構造 |
| `0x0B8L~0x0BAL` | [PUBLICATION](0x0B8L-publication.md) / [DEPRECATION](0x0B9L-deprecation.md) / [TOMBSTONE](0x0BAL-tombstone.md) | ドキュメントバージョンの公表・廃止勧告・削除 ([公表アドレスとバージョン一覧](../publishing.md#버전-목록)) |
| `0x0BBL~0x0BEL` | [DECLARE](0x0BBL-declare.md) / [FIELD](0x0BCL-field.md) / [ENUM](0x0BDL-enum.md) / [CODEC](0x0BEL-codec.md) | Codec 規格を書く語彙 ([Codec 規格ドキュメント](../codec-spec.md)) |

- `-SHORT` と一般形は偶数・奇数のペアに置く(VERB-SHORT `0x0A8L`/VERB `0x0A9L`)。LABEL は言語を Object(UTF8-LANGUAGE-TEXT)内の言語レコードとして受け取るので、`0x0A4L` 一つだけを使う。
- PUBLICATION・DEPRECATION・TOMBSTONE はバージョン一覧ドキュメントが使う。バージョン一覧をコードブックなしで読む必要があるので、デコーダに内蔵する([公表アドレスとバージョン一覧](../publishing.md#층)の 0 層)。
- DECLARE・FIELD・ENUM・CODEC は Codec 規格を書く語彙である。規格ドキュメントをコードブックなしで読む必要があるので、レイアウトをデコーダに内蔵する(0 層)。その語彙で書いた各 Codec 規格ドキュメントは一般のドキュメントである。

### TRIPLE {#triple}

詳細: [TRIPLE](0x0AAL-triple.md)

```
TAG WORD          0000 1010 1010 LLLL
[Length 拡張 TAG]
Edge Id           LOCAL Reference
Predicate         Reference (ウィキデータのプロパティなど)
Subject           Reference
Object            Reference または Value
Rank              1 WORD
```

| Rank | 名前 | 意味 |
|---|---|---|
| `0` | normal | 既定 |
| `1` | preferred | 現在の値、最も権威ある値 |
| `2` | deprecated | 誤り、または古いと判定されたが記録として残した値 |

- Rank はウィキデータの statement rank と同じである。rank を別に付けない出典は `0` を使う。
- **TRIPLE の意味は、その Edge Id を指す QUALIFIER をすべて集めたものである。** 読み手は TRIPLE を解釈する前に QUALIFIER を集める。

例: Q42 — P31(instance of) — Q5(人)、normal、Edge Id 2

```
0AA9  0051 0002  0191 001F  0141 002A  0141 0005  0000
TAG   #2         P31        Q42        Q5         normal
```

### QUALIFIER {#qualifier}

詳細: [QUALIFIER](0x0ABL-qualifier.md)

```
TAG WORD          0000 1010 1011 LLLL
[Length 拡張 TAG]
Edge Id           LOCAL Reference
Property          Reference
Target            LOCAL Reference (修飾する Edge の Edge Id)
Value             Reference または Value
```

- QUALIFIER は命題の一部である。命題についての別個の主張ではなく、命題が真となる条件(開始・終了時点、適用範囲など)を修飾する。
- 命題についての別個の主張(誰が主張したかなど)は TRIPLE で書く。
- Target は同じドキュメントの Edge である。同じ Target の QUALIFIER の順序はドキュメント内の順序である。

例: Q42 — P69(educated at) — Q691283、開始(P580) 1971

```
0AAA 0051 0003 0191 0045 0141 002A 0142 000A 8C53 0000   TRIPLE    #3 P69 Q42 Q691283 normal
0AB9 0051 0004 0191 0244 0051 0003 06E2 3139 3731        QUALIFIER #4 P580 #3 EDTF "1971"
```

### LABEL, ALIAS, DESCRIPTION {#label-alias-description}

詳細: [LABEL](0x0A4L-label.md), [ALIAS](0x0A5L-alias.md), [DESCRIPTION](0x0A6L-description.md)

```
TAG WORD          0000 1010 0100 LLLL   (LABEL)
[Length 拡張 TAG]
Edge Id           LOCAL Reference
Subject           Reference
Object            UTF8-LANGUAGE-TEXT
```

- 名前と言語は Object(UTF8-LANGUAGE-TEXT)一つに収める。
- 同じ Subject・言語の LABEL は多くても一つである。別の名前は ALIAS で書く。
- 言語のない機械用の名前は BIND で書く。LABEL には言語が必要である。

### BIND {#bind}

詳細: [BIND](0x0A3L-bind.md)

- Subject に機械が照合する名前(UTF8-TEXT)を結びつける。言語がなく、正規化しない。バイト列が同じなら同じ名前である。
- 名前の範囲は BIND を収めたドキュメントである。一つのドキュメントで同じ名前を別の Subject に結びつけない。
- 他のレコードは名前ではなく LOCAL ID で指す。名前は外部(ホスト関数、アドレス入力、人)との照合に使う。

### SAME-NODE, DIFFERENT-NODE, REFERENCE-NODE {#same-node-different-node-reference-node}

詳細: [SAME-NODE](0x0A1L-same-node.md), [DIFFERENT-NODE](0x0A2L-different-node.md), [REFERENCE-NODE](0x0A0L-reference-node.md)

- SAME-NODE は、二つの Reference が同じ対象を指すという同一性である。反射的・対称的・推移的である。
- DIFFERENT-NODE は、二つの Reference が異なる対象であるという非同一性である。
- REFERENCE-NODE は、Subject(Reference)が何であるかを Object で定義する方向性バインディングである。同一性の主張ではない。例: LOCAL ノードが指す URI を定義する。

## 根拠 Edge {#근거-edge}

BODY 内の個別レコード、またはドキュメント全体(HEAD)に根拠を付ける。根拠系列の直接コードは [SOURCE](0x0C0L-source.md)(`0x0C0L`)一つだけである。

| Codec | 名前 | 構成要素 |
|---|---|---|
| `0x0C0L` | [SOURCE](0x0C0L-source.md) | Target(根拠を付ける BODY Edge の Edge Id、HEAD では `0` = ドキュメント全体)、Origin(原典 Reference、ABSENT または UNKNOWN-VALUE) |
| `0x0C1L~0x0DFL` | Reserved | |

- 原典そのものの性質(URL、タイトル、著者、発行日 …)は原典を Subject とする TRIPLE で、引用の性質(参照日、原典内の位置 …)は SOURCE の Edge Id を Target とする QUALIFIER で書く。
- ドキュメント全体の原典は HEAD に Target `0` の SOURCE で書き、それを Target とする QUALIFIER も HEAD に置く。HEAD に来る Edge はこの二つだけで、Edge Id は HEAD と BODY が一つの番号空間を使う([ドキュメント全体の出典](0x0C0L-source.md#문서-전체의-출처))。
- そのほかの根拠(原文の範囲、作成した主体、信頼度、条文ごとの施行期間、旧レコード)は QUALIFIER で書き、最初に入ったバージョンはバージョン履歴から計算する([SOURCE](0x0C0L-source.md#다른-근거의-표현))。
- レコード単位の判定結果は TOULMIN `VERDICT` が担う。

### SOURCE {#source}

詳細: [SOURCE](0x0C0L-source.md)

```
TAG WORD          0000 1100 0000 LLLL
[Length 拡張 TAG]
Edge Id           LOCAL Reference
Target            LOCAL Reference (根拠を付ける BODY Edge の Edge Id、HEAD では 0 = ドキュメント全体)
Origin            Reference またはプレースホルダ 0x0000 ABSENT・0x0010 UNKNOWN-VALUE
```

例: Q42 P19 TRIPLE `#178` の出典ブリタニカ(Q5375741)、その中の識別子 P1417

```
SOURCE     #1347  #178   Q5375741
QUALIFIER  #1348  P1417  #1347  "biography/Douglas-Adams"
```

## 実行 Edge {#실행-edge}

特定のプログラミング言語に縛られないプログラム構造である。構成要素はこのドキュメントの LOCAL ID で指す。

| まとまり | Codec |
|---|---|
| 宣言 | [FUNCTION-DECLARE](0x0E1L-function-declare.md), [TYPE-DECLARE](0x0E2L-type-declare.md) |
| 式 | [CONST](0x0E8L-const.md), [UNARY](0x0E9L-unary.md), [BINARY](0x0EAL-binary.md), [CALL](0x0EBL-call.md), [MEMBER](0x0ECL-member.md), [INDEX](0x0EDL-index.md), [CONSTRUCT](0x0EEL-construct.md), [CONDITIONAL](0x0EFL-conditional.md) |
| 文 | [BLOCK](0x0F0L-block.md), [ASSIGN](0x0F1L-assign.md), [IF](0x0F2L-if.md), [SWITCH](0x0F3L-switch.md), [WHILE](0x0F4L-while.md), [FOREACH](0x0F5L-foreach.md), [JUMP](0x0F6L-jump.md), [RETURN](0x0F7L-return.md) |
| エラー | [RAISE](0x0F8L-raise.md), [TRY](0x0F9L-try.md) |

- 外部言語のコードをそのまま収める形式ではない。外部言語のコードは Issuer 形式に置く。
- 構成要素はこのドキュメントの LOCAL ID(REF)で指す。式の位置には式 Edge または記号を置く。REF `0` は「なし」である。
- 式は値を生み、文は値を生まない。式は BLOCK の文の位置に置ける(値は捨てる)。
- C 式の `for` は BLOCK(初期化、WHILE)で、`else if` は偽の位置の IF で書く。
- 記号は LOCAL ID であり、名前は BIND で結びつける。他のレコードは名前ではなく LOCAL ID で記号を指す。名前が同じでも LOCAL ID が異なれば別の記号である。
- 記号が何であるか(変数、パラメータ、関数、型)は、その記号を指すレコードが定める。ドキュメント内に定義のない記号は外部(ホスト)が提供し、CALL の対象ならホスト関数である。

未解決の問題: 演算子コード、型表現、各 Codec の Payload レイアウト。

## TOULMIN Edge {#toulmin-edge}

トゥールミン論証モデルで判定・実行グラフを書く。直接コード `0x100L~0x11BL`、補助レコードは TOULMIN 形式系列 `0x120L~0x134L` である。詳細: [TOULMIN](../toulmin/_index.md)

## Issuer 形式 Edge {#issuer-형식-edge}

Issuer は独自の Edge 形式を定義して使える([EDGE-ISSUER-2WORD](0x1BDL-edge-issuer-2word.md)・[4WORD](0x1BEL-edge-issuer-4word.md)・[16WORD](0x1BFL-edge-issuer-16word.md)、Codec `0x1BDL`~`0x1BFL`)。Edge 領域の末尾三マスである。Codec 拡張 TAG に Issuer と Codec 番号の 2 WORD を置く。Edge Id はその後の Payload の最初の要素である(TAG、Issuer、Codec 番号、Edge Id、残りの Payload)。Codec 番号は Issuer が定め、系列の規則がない。Kind に関係なく、その Issuer の `codecs/` 内で重複しない。Codec ドキュメントはその Issuer の `codecs/` 以下にレコードの Codec 番号で置く([公表アドレスとバージョン一覧](../publishing.md))。

- 現在登録されている Edge ISSUER 形式はない。
