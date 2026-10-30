---
title: "TOULMIN"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-31T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "TOULMIN Edge(Codec 0x60~0x7B)は、トゥールミンの論証モデルで判定・実行グラフを書く。このページは TOULMIN ドキュメントの規則、共通フィールド、コード表、数値規則と、自己改訂の固定された核を定める。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TOULMIN 系列の Edge(Codec 上位2ビット `11`、直接コード `0x60`~`0x7B`)は、トゥールミンの論証モデルで判定・実行グラフを書く。主張・反駁・例外の宣言、攻撃・排除の関係、実行の接続、判定結果がすべて Edge だ。TANGEUL ドキュメント(toulmin エンジンの規則言語)一つが GEUL ドキュメント一つになる。ファイル拡張子は他のドキュメントと同じ `.geul` だ。

このページが定めていないことは、[Edge](/ja/grammar/edge/) と[レコードと TAG WORD](/ja/grammar/record/) の共通規則に従う。

## メタ認知と自己改訂

TOULMIN が GEUL の Codec である理由は、GEUL が自分自身をメタ認知するためだ。判定・実行の規則も GEUL で記述されてこそ、TOULMIN がその規則を対象にして自ら直せる。そのため TOULMIN は応用プロファイルではなく GEUL 運用の中核で、Edge 直接コード空間(`0x60`~`0x7B`)に置く。

- 自己記述は自己改善を可能にするが、循環エラーの危険を負う。規則が自己改訂を自ら判定すると、判定基準を緩める改訂も通過しうる(通過率は上がり、実際の正確度は下がる)。
- 循環は危険として受け入れつつ、構造で断ち切る。
  - **固定された核**: 判定の意味(Pass・Review・Fail、攻撃・排除・優先順位、下の[不明の上での判定](#不明の上での判定)の3値評価と U → Review)は、この仕様に固定する。TOULMIN ドキュメントで変えられない。デコーダに内蔵する規則([公表アドレスとバージョン一覧](/ja/grammar/publishing/#層)の 0 層)と同じ位置づけだ。
  - **版の分離**: 規則ドキュメント v(n) の改訂は、v(n−1) の規則と外部検査で判定する。規則は自分自身を判定しない。判定結果は対象と別のドキュメントに置く(対象のコンテンツハッシュが変わらない)。
  - **不変の履歴**: 改訂は新しいバージョンとして積まれる(`PARENT`、コンテンツハッシュ、署名)。古いバージョンが残るので、循環エラーを事後に見つけて戻せる。自己改訂の安全網は GEUL の版モデルだ([ドキュメント](/ja/grammar/document/#改訂))。
  - **外側の基準**: 改訂経路が手を触れられない試験事例の組を別に置く。改訂の採用は、この組の結果で確認する。
- 反証試験: わざと誤った規則を一つ仕込む。システムがそれを直し、外側の基準のスコアが上がれば、自己改善が機能している。通過率だけが上がり外側の基準のスコアが下がれば、循環エラーだ。

## コード

TOULMIN レコードは三つのレイアウトのいずれかを使う。レイアウトは Codec(または形式番号)が決める。

| レイアウト | 用途 | ページ |
|---|---|---|
| NODE | 事案・規則・定義・エントリポイントのようなグラフノード | [NODE](/ja/grammar/edge/toulmin/node/) |
| LINK | ノード間の関係(攻撃、排除、実行、定義) | [LINK](/ja/grammar/edge/toulmin/link/) |
| EXPR | 条件式(述語) | [EXPR](/ja/grammar/edge/toulmin/expr/) |

原文と区画レコード(SOURCE、TEXT、SECTION、CASE-BEGIN・CASE-END、PROSE)は、[SOURCE と区画](/ja/grammar/edge/toulmin/source/)が定める。

### 直接コード

| Codec | 名前 | レイアウト | TANGEUL | 意味 |
|---|---|---|---|---|
| `0x60` | [CASE-DECLARE](/ja/grammar/edge/toulmin/node/) | NODE | `in case of` | 事案の宣言。ノードと関係を収める判定グラフ |
| `0x61` | [PREDICATE-DECLARE](/ja/grammar/edge/toulmin/expr/) | EXPR | Rules の条件式 | 述語の宣言。判定式 |
| `0x62` | [SPEC-DECLARE](/ja/grammar/edge/toulmin/node/) | NODE | Definitions の項目 | 判断基準の宣言(Backing)。role ビットが定義の種類 |
| `0x63` | [RULE-DECLARE](/ja/grammar/edge/toulmin/node/) | NODE | general rule、Rules の規則名 | 主張の宣言(Warrant)。攻撃されうる |
| `0x64` | [COUNTER-DECLARE](/ja/grammar/edge/toulmin/node/) | NODE | counter rule | 反駁の宣言。自分の結論を持って攻撃する。既定の Level は Fail |
| `0x65` | [EXCEPT-DECLARE](/ja/grammar/edge/toulmin/node/) | NODE | except rule | 例外の宣言。自分の結論なしで攻撃する。既定の Level は Review |
| `0x68` | [ATTACKS](/ja/grammar/edge/toulmin/link/) | LINK | `don't X when Y` | 攻撃関係。攻撃者の判定が対象の判定を攻撃力(0~1、既定 1)に応じて漸進的に削る |
| `0x69` | [SUPERSEDES](/ja/grammar/edge/toulmin/link/) | LINK | `X supersedes Y` | 排除関係。攻撃者が Active なら対象を集計から決定的に除く。チェーン(`A > B > C`)は組ごとに一つずつ書く |
| `0x6A` | SUPERSEDE-CHAIN | — | | 優先順位チェーン `A > B > C`。組ごとの SUPERSEDES の短縮形。コードだけを割り当て、レイアウトはまだない |
| `0x70` | [RUN](/ja/grammar/edge/toulmin/link/) | LINK | `run c when n` | 実行の合成。ノードが Active なら下位の事案を実行する(DAG) |
| `0x71` | [DO](/ja/grammar/edge/toulmin/link/) | LINK | `do fn when n` | ノードが Active なら行う動作 |
| `0x72` | [DO-ONCE](/ja/grammar/edge/toulmin/link/) | LINK | `do fn once when n` | 再試行しても一度だけ行う動作 |
| `0x73` | [UNDO](/ja/grammar/edge/toulmin/link/) | LINK | `undo fn when n` | DO の補償動作(saga)。後続の段階が失敗したら逆順に行う |
| `0x74` | [CHECKING](/ja/grammar/edge/toulmin/link/) | LINK | `checking c` | 副作用なしで判定だけを行う接続 |
| `0x75` | [ENTRY](/ja/grammar/edge/toulmin/node/) | NODE | `provides x` | 外部エントリポイント。事案を実行または判定する |
| `0x76` | [TRIGGER](/ja/grammar/edge/toulmin/node/) | NODE | `on`, `every`, `until` | 外部呼び出しのないイベント・周期のエントリポイント |
| `0x78` | VERDICT | — | | ノード・レコードの判定結果。結果(Pass、Review、Fail)、判定値、Activated、Excluded、Level。コードだけを割り当て、レイアウトはまだない |
| `0x79` | EVIDENCE | — | | 判定の証拠。位置、期待値、実際の値(Fact)。コードだけを割り当て、レイアウトはまだない |
| `0x7C`~`0x7F` | ISSUER-* | | | Issuer が定義した形式。下の ISSUER 形式 |

- 表にない直接コード(`0x66`・`0x67`、`0x6B`~`0x6F`、`0x77`、`0x7A`・`0x7B`)は予約だ。
- Codec 下位5ビットの上位2ビットがまとまりだ: `00` 宣言、`01` 関係、`10` 実行、`11` 結果(`0x7C`~`0x7F` は ISSUER)。
- ドキュメント全体の判定は Meta [VERDICT](/ja/grammar/meta/verification/verdict/)(`0x44`)が、ノード・レコードの判定は TOULMIN `VERDICT`(Edge `0x78`)が担う。二つは Kind が異なる別個の Codec だ。

### ISSUER 形式

直接コードが足りない TOULMIN レコードは、`ISSUER-1WORD`(`0x7C`)、Issuer `0x0000`(GEUL)の下の形式番号で置く。形式番号は TOULMIN 系列(`0xC000`~`0xFFFF`、上位2ビット `11`)だ。

```
TAG WORD          0001 0LLL L111 1100      Edge, Codec 0x7C
[Length 拡張 TAG]
Issuer            0x0000
形式番号          0xC000~0xC029
Edge Id           LOCAL Reference レコード
構成要素          形式が定めたレイアウト
```

| 形式番号 | 名前 | レイアウト | 意味 |
|---|---|---|---|
| `0xC000` | [SOURCE](/ja/grammar/edge/toulmin/source/) | ID, SPAN 幅 WORD, UTF8 Value | 著作原文 |
| `0xC001` | [TEXT](/ja/grammar/edge/toulmin/source/) | ID, UTF8 Value | 名前・文字列 |
| `0xC002` | [SECTION](/ja/grammar/edge/toulmin/source/) | ID, セクションコード 1 WORD | セクションの開始 |
| `0xC003` | [CASE-BEGIN](/ja/grammar/edge/toulmin/source/) | ID, REF(事案) | 事案範囲の開始 |
| `0xC004` | [CASE-END](/ja/grammar/edge/toulmin/source/) | ID, REF(事案) | 事案範囲の終わり |
| `0xC005` | [PROSE](/ja/grammar/edge/toulmin/source/) | ID, SPAN | 叙述の段落 |
| `0xC010` | [NAMESPACE](/ja/grammar/edge/toulmin/node/) | NODE | `this document is` |
| `0xC011` | [FUNC](/ja/grammar/edge/toulmin/node/) | NODE | 関数参照 |
| `0xC012` | [FIELD](/ja/grammar/edge/toulmin/node/) | NODE | `is required` |
| `0xC013` | [ALIAS](/ja/grammar/edge/toulmin/node/) | NODE | `see … from` |
| `0xC014` | [GROUP](/ja/grammar/edge/toulmin/node/) | NODE | 順序のある実行のまとまり |
| `0xC020` | [REQUIRES](/ja/grammar/edge/toulmin/link/) | LINK | 事案 → フィールド |
| `0xC021` | [MEANS](/ja/grammar/edge/toulmin/link/) | LINK | 定義項目 → 値・型 |
| `0xC022` | [HAS](/ja/grammar/edge/toulmin/link/) | LINK | 定義項目 → フィールド |
| `0xC023` | [RUNS](/ja/grammar/edge/toulmin/link/) | LINK | エントリポイント → 事案、実行 |
| `0xC024` | [EVALUATES](/ja/grammar/edge/toulmin/link/) | LINK | エントリポイント → 事案、判定 |
| `0xC025` | [TRIGGERS](/ja/grammar/edge/toulmin/link/) | LINK | トリガー → 事案 |
| `0xC026` | [UNTIL](/ja/grammar/edge/toulmin/link/) | LINK | トリガー → 事案(`every … until`) |
| `0xC027` | [SAME-AS](/ja/grammar/edge/toulmin/link/) | LINK | ノード → グローバル識別子 |
| `0xC028` | [IMPORTED-FROM](/ja/grammar/edge/toulmin/link/) | LINK | 別名 → パス(TEXT) |
| `0xC029` | [LABEL](/ja/grammar/edge/toulmin/link/) | LINK | ノード → TEXT、名前表記 |

- 形式番号の空間は Kind ごとに別々だ。Value の GEUL 形式 `0xC000`(OPAQUE-BYTES-EVEN)と Edge の `0xC000`(SOURCE)は別の形式だ。
- 形式番号は追加だけを行う。割り当てた番号は他の形式に再利用しない。

## ドキュメント

`.geul` ファイル一つは DOC 一つだ。DOC の外に他のバイトを置かない。

```
DOC-1WORD/2WORD/4WORD     全体の長さ
  SPEC-VERSION            0x0001 (v1、組み込み Value なしの整数)
  PROFILE                 UTF8 Value "tangeul-<major>.<minor>"。現在は "tangeul-1.0"
  [DEFAULT-LANGUAGE]      LANGUAGE-BCP47-CODE Value。作成ロケール("en", "ko")
BODY
  SOURCE                  著作原文。BODY の最初のレコード
  文のレコード …           ドキュメント宣言順
END
```

- HEAD: [SPEC-VERSION](/ja/grammar/meta/declaration/spec-version/)、[PROFILE](/ja/grammar/meta/declaration/profile/)、任意の [DEFAULT-LANGUAGE](/ja/grammar/meta/declaration/default-language/)。
- デコーダは、SPEC-VERSION が異なるか PROFILE の major が異なれば拒否する。minor が異なっても読む。
- BODY の最初のレコードは SOURCE だ。すべての SPAN は、この原文内の範囲だ。
- 文のレコードの順序は、ドキュメントの宣言順と同じだ。実行順序(`do`・`run` の発火、`undo` の逆順補償)がこの順序に依拠する。TOULMIN ドキュメントは Edge の順序に意味がある([Edge](/ja/grammar/edge/) の順序規則の例外)。
- BODY のすべてのレコードは Edge だ。独立した Value レコードを置かない。値は Edge Payload に組み込む。
- 事案の同一性と取り込みには、Meta [DOC-ID](/ja/grammar/meta/declaration/doc-id/)・[IMPORT-DOC](/ja/grammar/meta/import/import-doc/) を使う(TANGEUL の Subject・See)。

## 共通フィールド

| フィールド | 幅 | 説明 |
|---|---|---|
| ID | LOCAL Reference レコード | レコードの Edge Id。すべてのレコードの Payload の最初の要素 |
| REF | LOCAL Reference レコード | このドキュメントの他のレコードを指す Edge Id。`0` はなし |
| SPAN | SOURCE が定めた幅 × 2 | 著作原文内の範囲。開始バイト、バイト数 |

- ID と REF は組み込みの [LOCAL](/ja/grammar/reference/local/) Reference レコード(`0000 0LLL L000 1000` + 最短幅の ID)だ。幅はそのレコードの Length が決め、ドキュメント単位では宣言しない。
- REF `0`(LOCAL `0`)は「なし」だ。LOCAL `0` をなしとして使う Codec 規則だ([LOCAL](/ja/grammar/reference/local/))。
- Edge Id は 1 から割り当て、ドキュメント内で重複させない。`0` は REF の「なし」なので Edge Id には使わない。
- ノードは他のレコードが前方参照するので、ドキュメントの宣言順で先に番号を受け取る。それ以外のレコード(SOURCE、TEXT、LINK、FUNC、区画レコード)は、ノードの次の番号からエンコーダが割り当てる。
- デコーダは、Edge Id が 0 でなく重複がないことだけを確認する。割り当て順序は解釈に使わない。
- ノードと関係は Edge Id で指す。
- 組み込み Value は、TAG WORD を含む Value レコードそのままだ。長さはその TAG が決める。

## 数値

- 判定値(−1~1)、Qualifier(0~1)、攻撃力(0~1)は [SIGNED-DECIMAL](/ja/grammar/value/decimal/signed-decimal/) Value だ。固定小数形式を別に置かない。
- エンコーダは係数の末尾の 0 を消す。0.8 は `C=8, E=−1` だ。デコーダは小数4桁まで受け付ける。
- 確信度ゲート(例: `at least 75%`)は、比較演算子 1 WORD とパーセントの [UNSIGNED-DECIMAL](/ja/grammar/value/decimal/unsigned-decimal/) Value(`E=0`)で書く([LINK](/ja/grammar/edge/toulmin/link/) の F_GATE)。
- 攻撃力は ATTACKS の F_FORCE フィールドだ([LINK](/ja/grammar/edge/toulmin/link/#攻撃力))。範囲を外れれば拒否する。

## ノード宣言の軸

- ノード宣言(RULE・COUNTER・EXCEPT-DECLARE)は、役割(主張・反駁・例外)、Qualifier(0~1)、Level(Unset、Fail、Review)を持つ。役割は Codec と NODE ヘッダの role が、Qualifier は F_QUAL が、Level はヘッダの level が収める([NODE](/ja/grammar/edge/toulmin/node/))。
- 強度(Strict、Defeasible、Defeater)は、役割とは別の軸だ。強度の配置はまだ決めていない。
- 攻撃力(Force)はノードではなく ATTACKS 辺の値だ([LINK](/ja/grammar/edge/toulmin/link/#攻撃力) の F_FORCE)。強度とは別の軸だ。

## 不明の上での判定

判定グラフが GEUL の事実を入力として受け取るとき、[プレースホルダ](/ja/grammar/reference/slot-marker/)の三つの概念(記載なし、不明、なし)は異なって評価する。[EXPR](/ja/grammar/edge/toulmin/expr/) の比較演算子の評価は次のとおりだ。

| 入力 | `is empty` | `is not empty` | `equals` / `is in` / 大小比較 |
|---|---|---|---|
| 値 v | 偽 | 真 | v で評価 |
| NO-VALUE (なし) | **真** | 偽 | 偽 |
| UNKNOWN-VALUE (不明) | 偽 | **真** | **未定(U)** |
| ABSENT (記載なし) / 記述なし | U (開いた世界) | U | U |

- 論理は Kleene の強3値を使う。`NOT U = U`、`偽 AND U = 偽`、`真 OR U = 真`。残りの組み合わせの U は U だ。
- `EXISTS any` は、要素のうち一つでも真なら真だ。真がなく U があれば U、すべて偽なら偽だ。
- **述語が U なら、そのノードの判定は Pass・Fail ではなく Review だ。** 分からなければ人(または次の段階)に渡す。
- ABSENT を U ではなく empty と見るには、入力側が閉じた世界を**宣言**しなければならない(判断基準 SPEC で注入、例: 「この事案の入力は完全だ」)。宣言がなければ U だ。
- この表と U → Review の対応は判定の意味なので**固定された核**だ。TOULMIN ドキュメントで変えられない。
- 例: 「今も有効な国境だけを数える」(`P582 is empty`)規則は、P582 = UNKNOWN-VALUE なら偽なので除外し、P582 = NO-VALUE なら真なので含め、P582 がなければ U なので Review に送る。

## 判定結果

- 判定結果(`VERDICT`、`EVIDENCE`)は、判定対象とは別のドキュメントに置く。結果ドキュメントが対象ドキュメントを [IMPORT-DOC](/ja/grammar/meta/import/import-doc/) で取り込み、[EXTERNAL-POINTER-*](/ja/grammar/reference/external-pointer/) で指す。そのため判定しても、対象ドキュメントのコンテンツハッシュは変わらない。
- ドキュメント全体の判定は Meta `VERDICT`、ノード・レコードの判定は TOULMIN `VERDICT` だ。
- 改訂の適用版を選ぶ規則(経過規定、行為時法と新法の選択)と、解釈例・判例も、判定規則として書く([ドキュメント](/ja/grammar/document/#改訂))。

## 未解決の問題

- SUPERSEDE-CHAIN(`0x6A`)、VERDICT(`0x78`)、EVIDENCE(`0x79`)のレイアウト。SUPERSEDES を組ごとに書く今の方式でチェーンが十分か。
- ノード強度(Strict、Defeasible、Defeater)の配置。
- 攻撃力 1 を書いた ATTACKS と書かない ATTACKS は判定が同じだがバイトが違う。判定が同じかどうかはバイトではなく解釈した値で比べなければならない。
- EXPR 内のノード数、ラベル数、ラベルインデックスは 1 WORD で、子の数は 13 ビットだ。上限が固定されている。
- PROVENANCE(規則の出典・前提)のレイアウト。
- バッククォート名を TEXT + LABEL(`0xC029`)の代わりに、記述 [LABEL](/ja/grammar/edge/label/)・[BIND](/ja/grammar/edge/bind/) で置くか。
- Claim の predicate・mode のコード値と、FuncRef の VerbCode のコード値表。
- 閉じた世界の宣言(ABSENT を empty と読む)を、判断基準(SPEC)にするか事案単位にするか。
- TOULMIN Codec の [Codec 規格ドキュメント](/ja/grammar/codec-spec/)。NODE・LINK の条件付きフィールドと、SOURCE が定める SPAN 幅は、FIELD では宣言できないレイアウトだ。

## 関連ページ

- [NODE](/ja/grammar/edge/toulmin/node/)、[LINK](/ja/grammar/edge/toulmin/link/)、[EXPR](/ja/grammar/edge/toulmin/expr/)、[SOURCE と区画](/ja/grammar/edge/toulmin/source/)
- [Edge](/ja/grammar/edge/)、[ドキュメント](/ja/grammar/document/)、[PROFILE](/ja/grammar/meta/declaration/profile/)
