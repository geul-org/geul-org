---
title: "Edge"
weight: 60
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "Edge は Reference・Value・他の Edge を束ねて記述するレコードだ。最初の構成要素は常に Edge Id で、Codec の上位2ビットが系列(記述、根拠、実行、TOULMIN)だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Edge は、他のレコードを構成要素として束ねて記述するレコードだ。「Q42 は人間である」、「Q42 の英語名は Douglas Adams である」のような記述が Edge 一つになる。

## レイアウト

```
TAG WORD          0001 0LLL LCCC CCCC
[Length 拡張 TAG]
[Codec 拡張 TAG]  Issuer 形式のとき
Edge Id           LOCAL Reference レコード
構成要素          Codec が定めた順序
```

- `LLLL` は TAG WORD を含む全 WORD 数 − 1 だ。デコーダは Codec を知らなくても、Length だけで次のレコードへ読み飛ばせる。
- **最初の構成要素は常に Edge Id(LOCAL Reference)だ。** LOCAL Reference(`0088` + ID、Quantifier `000`)なので、コーデックを知らなくても Edge Id を読める。
- 構成要素は、それぞれ自分の Length で境界を見つける。最後の構成要素を読み終えた位置が Edge の終わりとちょうど合わなければならない。
- 構成要素の構成(Payload)は、各 Edge Codec ドキュメントが定める。
- 下位形式のある Codec(WORLD、TIMELINE、SCENE)は、Codec ごとの TAG 1 WORD が下位形式を指定する。
- Edge レコード同士の順序に意味はない(Codec が別に定めた場合を除く。例: [TOULMIN](/ja/grammar/edge/toulmin/) ドキュメント)。
- 他の Edge は Edge Id で指す。このドキュメントの Edge は LOCAL で、他のドキュメントの Edge は指示 Reference(`EXTERNAL-POINTER-*`、`EXTERNAL-ISSUER-*`)で指す。

## 系列

| 上位2ビット | 系列 | 直接コード | 役割 |
|---|---|---|---|
| `00` | 記述 | `0x00`~`0x1F` | 世界と出来事に関する内容を構成する |
| `01` | 根拠 | `0x20`~`0x3F` | レコードとドキュメントがどこから来たか([SOURCE](/ja/grammar/edge/source/)) |
| `10` | 実行 | `0x40`~`0x5F` | 実行できるプログラム構造(AST) |
| `11` | [TOULMIN](/ja/grammar/edge/toulmin/) | `0x60`~`0x7B` | 論証グラフ: 主張・反駁・例外、攻撃関係、実行、判定結果 |

## 記述 Edge

| Codec | 名前 | 構成要素 |
|---|---|---|
| `0x00` | [REFERENCE-NODE](/ja/grammar/edge/reference-node/) | Subject(Reference)が Object を指示するという方向性バインディング |
| `0x01` | [SAME-NODE](/ja/grammar/edge/same-node/) | 二つの Reference が同じ対象を指示する |
| `0x02` | [DIFFERENT-NODE](/ja/grammar/edge/different-node/) | 二つの Reference が異なる対象を指示する |
| `0x03` | [BIND](/ja/grammar/edge/bind/) | Subject に機械用の名前(UTF8-TEXT)を結びつける |
| `0x04` | [LABEL](/ja/grammar/edge/label/) | Subject の言語別の名前(UTF8-LANGUAGE-TEXT) |
| `0x05` | [ALIAS](/ja/grammar/edge/alias/) | Subject の別名。レイアウトは LABEL と同じ |
| `0x06` | [DESCRIPTION](/ja/grammar/edge/description/) | Subject の言語別の説明。レイアウトは LABEL と同じ |
| `0x08`/`0x09` | VERB-SHORT / VERB | 動詞の記述 |
| `0x0A` | [TRIPLE](/ja/grammar/edge/triple/) | 命題一つ(Predicate、Subject、Object)と rank |
| `0x0B` | [QUALIFIER](/ja/grammar/edge/qualifier/) | 他の Edge の命題を限定する条件一つ |
| `0x10`~`0x12` | WORLD / TIMELINE / SCENE | 世界観、出来事の順序、場面構造 |
| `0x18`~`0x1A` | [PUBLICATION](/ja/grammar/edge/publication/) / DEPRECATION / TOMBSTONE | ドキュメントバージョンの公表・非推奨・削除 ([公表アドレスとバージョン一覧](/ja/grammar/publishing/#バージョン一覧)) |
| `0x1B`~`0x1E` | [DECLARE](/ja/grammar/edge/declare/) / [FIELD](/ja/grammar/edge/field/) / [ENUM](/ja/grammar/edge/enum/) / [CODEC](/ja/grammar/edge/codec/) | Codec 規格を書く語彙 ([Codec 規格ドキュメント](/ja/grammar/codec-spec/)) |

- `-SHORT` と通常形は、偶数・奇数のペアに置く(VERB-SHORT `0x08`/VERB `0x09`)。LABEL は言語を Object(UTF8-LANGUAGE-TEXT)内の言語レコードで受けるので `0x04` 一つだけを使う。
- PUBLICATION・DEPRECATION・TOMBSTONE はバージョン一覧ドキュメントが使う。バージョン一覧をコードブックなしで読む必要があるので、デコーダに内蔵する([公表アドレスとバージョン一覧](/ja/grammar/publishing/#層)の 0 層)。
- DECLARE・FIELD・ENUM・CODEC は Codec 規格を書く語彙だ。規格ドキュメントをコードブックなしで読む必要があるので、レイアウトをデコーダに内蔵する(0 層)。その語彙で書いた各 Codec 規格ドキュメントは通常のドキュメントだ。

### TRIPLE

詳細: [TRIPLE](/ja/grammar/edge/triple/)

```
TAG WORD          0001 0LLL L000 1010
[Length 拡張 TAG]
Edge Id           LOCAL Reference
Predicate         Reference (Wikidata プロパティなど)
Subject           Reference
Object            Reference または Value
Rank              1 WORD
```

| Rank | 名前 | 意味 |
|---|---|---|
| `0` | normal | 既定 |
| `1` | preferred | 現在の値、最も権威のある値 |
| `2` | deprecated | 誤りまたは古いと判定されたが、記録として残した値 |

- Rank は Wikidata の statement rank と同じだ。rank を別に付けない出典は `0` を使う。
- **TRIPLE の意味は、その Edge Id を指す QUALIFIER をすべて集めたものだ。** 読む側は TRIPLE を解釈する前に QUALIFIER を集める。

例: Q42 — P31(instance of) — Q5(人間)、normal、Edge Id 2

```
148A  0088 0002  00A8 001F  00A0 002A  00A0 0005  0000
TAG   #2         P31        Q42        Q5         normal
```

### QUALIFIER

詳細: [QUALIFIER](/ja/grammar/edge/qualifier/)

```
TAG WORD          0001 0LLL L000 1011
[Length 拡張 TAG]
Edge Id           LOCAL Reference
Property          Reference
Target            LOCAL Reference (限定する Edge の Edge Id)
Value             Reference または Value
```

- QUALIFIER は命題の一部だ。命題についての別個の主張ではなく、命題が真になる条件(開始・終了時点、適用範囲など)を限定する。
- 命題についての別個の主張(誰が主張したかなど)は TRIPLE で書く。
- Target は同じドキュメントの Edge だ。同じ Target の QUALIFIER の順序は、ドキュメント内の順序だ。

例: Q42 — P69(educated at) — Q691283、開始(P580) 1971

```
150A 0088 0003 00A8 0045 00A0 002A 0120 000A 8C53 0000   TRIPLE    #3 P69 Q42 Q691283 normal
148B 0088 0004 00A8 0244 0088 0003 0924 3139 3731        QUALIFIER #4 P580 #3 EDTF "1971"
```

### LABEL, ALIAS, DESCRIPTION

詳細: [LABEL](/ja/grammar/edge/label/)、[ALIAS](/ja/grammar/edge/alias/)、[DESCRIPTION](/ja/grammar/edge/description/)

```
TAG WORD          0001 0LLL L000 0100   (LABEL)
[Length 拡張 TAG]
Edge Id           LOCAL Reference
Subject           Reference
Object            UTF8-LANGUAGE-TEXT
```

- 名前と言語は Object(UTF8-LANGUAGE-TEXT)一つに収める。
- 同じ Subject・言語の LABEL は多くて一つだ。別の名前は ALIAS で書く。
- 言語のない機械用の名前は BIND で書く。LABEL には言語が必要だ。

### BIND

詳細: [BIND](/ja/grammar/edge/bind/)

- Subject に、機械が突き合わせる名前(UTF8-TEXT)を結びつける。言語はなく、正規化しない。バイトが同じなら同じ名前だ。
- 名前の範囲は、BIND を収めるドキュメントだ。一つのドキュメントで同じ名前を別の Subject に結びつけない。
- 他のレコードは名前ではなく LOCAL ID で指す。名前は外部(ホスト関数、アドレス入力、人)との突き合わせに使う。

### SAME-NODE, DIFFERENT-NODE, REFERENCE-NODE

詳細: [SAME-NODE](/ja/grammar/edge/same-node/)、[DIFFERENT-NODE](/ja/grammar/edge/different-node/)、[REFERENCE-NODE](/ja/grammar/edge/reference-node/)

- SAME-NODE は、二つの Reference が同じ対象を指すという同一性だ。反射的・対称的・推移的だ。
- DIFFERENT-NODE は、二つの Reference が異なる対象だという非同一性だ。
- REFERENCE-NODE は、Subject(Reference)が何であるかを Object で定義する方向性バインディングだ。同一性の主張ではない。例: LOCAL ノードが指す URI を定義する。

## 根拠 Edge

BODY 内の個々のレコード、またはドキュメント全体(HEAD)に根拠を付ける。根拠系列の直接コードは [SOURCE](/ja/grammar/edge/source/)(`0x20`)一つだけだ。

| Codec | 名前 | 構成要素 |
|---|---|---|
| `0x20` | [SOURCE](/ja/grammar/edge/source/) | Target(根拠を付ける BODY Edge の Edge Id、HEAD では `0` = ドキュメント全体)、Origin(原典 Reference、ABSENT または UNKNOWN-VALUE) |
| `0x21`~`0x3F` | Reserved | |

- 原典自体の性質(URL、タイトル、著者、発行日 …)は原典を Subject とする TRIPLE で、引用の性質(参照日、原典内の位置 …)は SOURCE の Edge Id を Target とする QUALIFIER で書く。
- ドキュメント全体の原典は HEAD に Target `0` の SOURCE として書き、それを Target とする QUALIFIER も HEAD に置く。HEAD に来る Edge はこの二つだけで、Edge Id は HEAD と BODY が一つの番号空間を使う([ドキュメント全体の出典](/ja/grammar/edge/source/#ドキュメント全体の出典))。
- 他の根拠(原文範囲、作った主体、信頼度、条文ごとの施行期間、旧レコード)は QUALIFIER で書き、最初に入ったバージョンはバージョン履歴から計算する([SOURCE](/ja/grammar/edge/source/#他の根拠の表現))。
- レコード単位の判定結果は TOULMIN `VERDICT` が担う。

### SOURCE

詳細: [SOURCE](/ja/grammar/edge/source/)

```
TAG WORD          0001 0LLL L010 0000
[Length 拡張 TAG]
Edge Id           LOCAL Reference
Target            LOCAL Reference (根拠を付ける BODY Edge の Edge Id、HEAD では 0 = ドキュメント全体)
Origin            Reference またはプレースホルダ 0x0000 ABSENT・0x0001 UNKNOWN-VALUE
```

例: Q42 P19 TRIPLE `#178` の出典ブリタニカ(Q5375741)、その中の識別子 P1417

```
SOURCE     #1347  #178   Q5375741
QUALIFIER  #1348  P1417  #1347  "biography/Douglas-Adams"
```

## 実行 Edge

特定のプログラミング言語に縛られないプログラム構造だ。構成要素は、このドキュメントの LOCAL ID で指す。

| まとまり | Codec |
|---|---|
| 宣言 | FUNCTION-DECLARE, TYPE-DECLARE |
| 式 | CONST, UNARY, BINARY, CALL, MEMBER, INDEX, CONSTRUCT, CONDITIONAL |
| 文 | BLOCK, ASSIGN, IF, SWITCH, WHILE, FOREACH, JUMP, RETURN |
| エラー | RAISE, TRY |

- 外部言語のコードをそのまま収める形式ではない。外部言語のコードは Issuer 形式で置く。
- 構成要素は、このドキュメントの LOCAL ID(REF)で指す。式の位置には式 Edge またはシンボルを置く。REF `0` は「なし」だ。
- 式は値を出し、文は値を出さない。式は BLOCK の文の位置に置ける(値は捨てる)。
- C 式の `for` は BLOCK(初期化、WHILE)で、`else if` は偽の位置の IF で書く。
- シンボルは LOCAL ID で、名前は BIND で結びつける。他のレコードは名前ではなく LOCAL ID でシンボルを指す。名前が同じでも LOCAL ID が違えば別のシンボルだ。
- シンボルが何か(変数、パラメータ、関数、型)は、そのシンボルを指すレコードが決める。ドキュメント内に定義のないシンボルは外部(ホスト)が提供し、CALL の対象ならホスト関数だ。

未解決の問題: 演算子コード、型表現、各 Codec の Payload レイアウト。

## TOULMIN Edge

詳細: [TOULMIN](/ja/grammar/edge/toulmin/)

トゥールミンの論証モデルで、判定・実行グラフを書く。GEUL が自分の規則を GEUL で記述し、自ら直すための中核系列だ。

| まとまり | Codec |
|---|---|
| 宣言 | CASE-DECLARE(事案)、[PREDICATE-DECLARE](/ja/grammar/edge/toulmin/expr/)(述語)、SPEC-DECLARE(判断基準)、RULE-DECLARE(主張)、COUNTER-DECLARE(反駁)、EXCEPT-DECLARE(例外) — [NODE](/ja/grammar/edge/toulmin/node/) |
| 関係 | ATTACKS(攻撃)、SUPERSEDES(排除) — [LINK](/ja/grammar/edge/toulmin/link/)、SUPERSEDE-CHAIN(優先順位チェーン、レイアウト未定) |
| 実行 | RUN, DO, DO-ONCE, UNDO, CHECKING — [LINK](/ja/grammar/edge/toulmin/link/), ENTRY, TRIGGER — [NODE](/ja/grammar/edge/toulmin/node/) |
| 結果 | VERDICT(判定結果: Pass・Review・Fail)、EVIDENCE(判定の証拠) — レイアウト未定 |

- 原文・区画・補助ノードと関係は、GEUL Issuer の ISSUER 形式(`0xC000`~`0xC029`)だ([SOURCE と区画](/ja/grammar/edge/toulmin/source/))。
- 判定結果は、判定対象とは別のドキュメントに置く。結果ドキュメントが対象ドキュメントを取り込んで指す。そのため判定しても、対象ドキュメントのコンテンツハッシュは変わらない。

## Issuer 形式 Edge

Issuer は自分の Edge 形式を定義して使える(Codec `0x7C`~`0x7F`)。直接コード `0x7C`~`0x7F` は TOULMIN の区間内にあるが共通の ISSUER コードで、系列は形式番号の上位2ビットで決める。

| Issuer | 形式番号 | 名前 | 系列 |
|---|---|---|---|
| `0x0000` GEUL | `0xC000`~`0xC005` | [SOURCE, TEXT, SECTION, CASE-BEGIN, CASE-END, PROSE](/ja/grammar/edge/toulmin/source/) | TOULMIN |
| `0x0000` GEUL | `0xC010`~`0xC014` | [NAMESPACE, FUNC, FIELD, ALIAS, GROUP](/ja/grammar/edge/toulmin/node/) | TOULMIN |
| `0x0000` GEUL | `0xC020`~`0xC029` | [REQUIRES … LABEL](/ja/grammar/edge/toulmin/link/) | TOULMIN |
