---
title: "TOULMIN"
weight: 130
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "トゥールミン論証モデルで判定・実行グラフを書く。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

トゥールミン論証モデルで判定・実行グラフを書く。GEUL が自らの規則を GEUL で記述し、自らを修正するための中核の系列である。

| まとまり | Codec |
|---|---|
| 宣言 | [CASE-DECLARE](0x100L-case-declare.md) (事案)、[PREDICATE-DECLARE](0x101L-predicate-declare.md) (述語)、[SPEC-DECLARE](0x102L-spec-declare.md) (判断基準)、[RULE-DECLARE](0x103L-rule-declare.md) (主張)、[COUNTER-DECLARE](0x104L-counter-declare.md) (反駁)、[EXCEPT-DECLARE](0x105L-except-declare.md) (例外) — [NODE](#node) |
| 関係 | [ATTACKS](0x108L-attacks.md) (攻撃)、[SUPERSEDES](0x109L-supersedes.md) (除外) — [LINK](#link)、[SUPERSEDE-CHAIN](0x10AL-supersede-chain.md) (優先順位の連鎖、レイアウト未定) |
| 実行 | [RUN](0x110L-run.md)、[DO](0x111L-do.md)、[DO-ONCE](0x112L-do-once.md)、[UNDO](0x113L-undo.md)、[CHECKING](0x114L-checking.md) — [LINK](#link)、[ENTRY](0x115L-entry.md)、[TRIGGER](0x116L-trigger.md) — [NODE](#node) |
| 結果 | [VERDICT](0x118L-verdict.md) (判定結果: Pass・Review・Fail)、[EVIDENCE](0x119L-evidence.md) (判定の証拠) — レイアウト未定 |

- 原文・区画・補助ノードと関係は、TOULMIN 形式系列の直接コード `0x120L~0x134L` である ([SOURCE と区画](#source와-구획)、[TOULMIN](#toulmin-형식))。
- 判定結果は判定対象とは別のドキュメントに置く。結果ドキュメントが対象ドキュメントを取り込んで指す。そのため判定しても対象ドキュメントのコンテンツハッシュは変わらない。

TOULMIN 系列の Edge (直接コード `0x100L~0x11BL`、補助レコードは TOULMIN 形式系列 `0x120L~0x134L`) は、トゥールミン論証モデルで判定・実行グラフを書く。主張・反駁・例外の宣言、攻撃・除外の関係、実行の接続、判定結果がすべて Edge である。TANGEUL ドキュメント (toulmin エンジンの規則言語) 一つが GEUL ドキュメント一つになる。ファイル拡張子は他のドキュメントと同じ `.geul` である。

このドキュメントが定めていないことは、[Edge](../edge/_index.md) の共通規則と[レコードと TAG WORD](../record.md) に従う。

## メタ認知と自己改訂 {#메타-인지와-자기-개정}

TOULMIN が GEUL Codec である理由は、GEUL が自分自身をメタ認知するためである。判定・実行の規則も GEUL で記述されてこそ、TOULMIN がその規則を対象として自らを修正できる。したがって TOULMIN はアプリケーションプロファイルではなく GEUL 運用の中核であり、Edge の直接コード空間 (`0x100L~0x11BL`) に置く。

- 自己記述は自己改善を可能にするが、循環誤りの危険を負う。規則が自己改訂を自ら判定すると、判定基準を緩める改訂も通りうる (通過率は上がり、実際の精度は下がる)。
- 循環は危険として受け入れつつ、構造で断ち切る。
  - **固定された中核**: 判定の意味 (Pass・Review・Fail、攻撃・除外・優先順位、下の[未知の入力に基づく判定](#미상-위에서-판정하기)の 3 値評価と U → Review) はこの仕様に固定する。TOULMIN ドキュメントで変えることはできない。デコーダに内蔵する規則 ([公表アドレスとバージョン一覧](../publishing.md#층)の 0 層) と同じ位置である。
  - **版の分離**: 規則ドキュメント v(n) の改訂は、v(n−1) の規則と外部検査で判定する。規則は自分自身を判定しない。判定結果は対象とは別のドキュメントに置く (対象のコンテンツハッシュが変わらない)。
  - **不変の履歴**: 改訂は新しいバージョンとして積まれる (`PARENT`、コンテンツハッシュ、署名)。古いバージョンが残るため、循環誤りを事後に見つけて戻せる。自己改訂の安全網は GEUL の版モデルである ([ドキュメント](../document.md#개정))。
  - **外側の基準**: 改訂の経路が触れられない試験事例のまとまりを別に置く。改訂の採用は、このまとまりの結果で確認する。
- 反証試験: わざと誤った規則を一つ仕込む。システムがそれを直し、外側の基準の点数が上がれば自己改善が働いている。通過率だけが上がり外側の基準の点数が下がれば循環誤りである。

## コード {#코드}

TOULMIN レコードは三つのレイアウトのうち一つを使う。レイアウトは Codec が定める。

| レイアウト | 用途 | ページ |
|---|---|---|
| NODE | 事案・規則・定義・エントリポイントのようなグラフノード | [NODE](#node) |
| LINK | ノード間の関係 (攻撃、除外、実行、定義) | [LINK](#link) |
| EXPR | 条件式 (述語) | [EXPR](0x101L-predicate-declare.md) |

原文と区画のレコード (SOURCE、TEXT、SECTION、CASE-BEGIN・CASE-END、PROSE) は [SOURCE と区画](#source와-구획)が定める。

### 直接コード {#직접-코드}

| Codec | 名前 | レイアウト | TANGEUL | 意味 |
|---|---|---|---|---|
| `0x100L` | [CASE-DECLARE](0x100L-case-declare.md) | NODE | `in case of` | 事案宣言。ノードと関係を収める判定グラフ |
| `0x101L` | [PREDICATE-DECLARE](0x101L-predicate-declare.md) | EXPR | Rules の条件式 | 述語宣言。判定式 |
| `0x102L` | [SPEC-DECLARE](0x102L-spec-declare.md) | NODE | Definitions の項目 | 判断基準宣言 (Backing)。role ビットが定義の種類 |
| `0x103L` | [RULE-DECLARE](0x103L-rule-declare.md) | NODE | general rule、Rules の規則名 | 主張宣言 (Warrant)。攻撃を受けうる |
| `0x104L` | [COUNTER-DECLARE](0x104L-counter-declare.md) | NODE | counter rule | 反駁宣言。自らの結論を持って攻撃する。既定の Level は Fail |
| `0x105L` | [EXCEPT-DECLARE](0x105L-except-declare.md) | NODE | except rule | 例外宣言。自らの結論を持たずに攻撃する。既定の Level は Review |
| `0x108L` | [ATTACKS](0x108L-attacks.md) | LINK | `don't X when Y` | 攻撃関係。攻撃者の判定が対象の判定を、攻撃の強さ (0~1、既定 1) の分だけ漸進的に削る |
| `0x109L` | [SUPERSEDES](0x109L-supersedes.md) | LINK | `X supersedes Y` | 除外関係。攻撃者が Active なら、対象を集計から決定的に除く。連鎖 (`A > B > C`) は組ごとに一つずつ書く |
| `0x10AL` | [SUPERSEDE-CHAIN](0x10AL-supersede-chain.md) | — | | 優先順位の連鎖 `A > B > C`。組ごとの SUPERSEDES の省略形。コードだけを割り当て、レイアウトはまだない |
| `0x110L` | [RUN](0x110L-run.md) | LINK | `run c when n` | 実行合成。ノードが Active なら下位の事案を実行する (DAG) |
| `0x111L` | [DO](0x111L-do.md) | LINK | `do fn when n` | ノードが Active なら行う動作 |
| `0x112L` | [DO-ONCE](0x112L-do-once.md) | LINK | `do fn once when n` | 再試行しても一度だけ行う動作 |
| `0x113L` | [UNDO](0x113L-undo.md) | LINK | `undo fn when n` | DO の補償動作 (saga)。後の段階が失敗したら逆順に行う |
| `0x114L` | [CHECKING](0x114L-checking.md) | LINK | `checking c` | 副作用なしに判定だけを行う接続 |
| `0x115L` | [ENTRY](0x115L-entry.md) | NODE | `provides x` | 外部エントリポイント。事案を実行または判定する |
| `0x116L` | [TRIGGER](0x116L-trigger.md) | NODE | `on`, `every`, `until` | 外部呼び出しのないイベント・周期のエントリポイント |
| `0x118L` | [VERDICT](0x118L-verdict.md) | — | | ノード・レコードの判定結果。結果 (Pass, Review, Fail)、判定値、Activated、Excluded、Level。コードだけを割り当て、レイアウトはまだない |
| `0x119L` | [EVIDENCE](0x119L-evidence.md) | — | | 判定の証拠。位置、期待値、実際の値 (Fact)。コードだけを割り当て、レイアウトはまだない |
| `0x11CL~0x11FL` | Reserved | | | |

- 表にない直接コード (`0x106L`・`0x107L`、`0x10BL`~`0x10FL`、`0x117L`、`0x11AL`・`0x11BL`) は Reserved である。
- まとまりは `0x100L~0x107L` が宣言、`0x108L~0x10FL` が関係、`0x110L~0x117L` が実行、`0x118L~0x11FL` が結果である (`0x11CL~0x11FL` は Reserved)。
- ドキュメント全体の判定は Meta の [VERDICT](../meta/0x1E9L-verdict.md) (`0x1E9L`) が、ノード・レコードの判定は TOULMIN の `VERDICT` (Edge `0x118L`) が担う。両者は Kind が異なる別個の Codec である。

### TOULMIN 形式 {#toulmin-형식}

原文・区画・補助ノードと関係は、Edge TOULMIN 形式系列の直接コード `0x120L~0x134L` に置く。Issuer と Codec 番号の欄がなく、TAG の直後に Payload が来る。

```
TAG WORD          0001 0010 0000 LLLL      Edge, Codec 0x120L (SOURCE). 他のコードも同じ位置
[Length 拡張 TAG]
Edge Id           LOCAL Reference レコード
構成要素          形式が定めるレイアウト
```

| Codec | 名前 | レイアウト | 意味 |
|---|---|---|---|
| `0x120L` | [SOURCE](0x120L-source.md) | ID, SPAN 幅 WORD, UTF8 Value | 著作原文 |
| `0x121L` | [TEXT](0x121L-text.md) | ID, UTF8 Value | 名前・文字列 |
| `0x122L` | [SECTION](0x122L-section.md) | ID, セクションコード 1 WORD | セクションの開始 |
| `0x123L` | [CASE-BEGIN](0x123L-case-begin.md) | ID, REF (事案) | 事案範囲の開始 |
| `0x124L` | [CASE-END](0x124L-case-end.md) | ID, REF (事案) | 事案範囲の終了 |
| `0x125L` | [PROSE](0x125L-prose.md) | ID, SPAN | 叙述の段落 |
| `0x126L` | [NAMESPACE](0x126L-namespace.md) | NODE | `this document is` |
| `0x127L` | [FUNC](0x127L-func.md) | NODE | 関数参照 |
| `0x128L` | [FIELD](0x128L-field.md) | NODE | `is required` |
| `0x129L` | [ALIAS](0x129L-alias.md) | NODE | `see … from` |
| `0x12AL` | [GROUP](0x12AL-group.md) | NODE | 順序のある実行のまとまり |
| `0x12BL` | [REQUIRES](0x12BL-requires.md) | LINK | 事案 → フィールド |
| `0x12CL` | [MEANS](0x12CL-means.md) | LINK | 定義項目 → 値・型 |
| `0x12DL` | [HAS](0x12DL-has.md) | LINK | 定義項目 → フィールド |
| `0x12EL` | [RUNS](0x12EL-runs.md) | LINK | エントリポイント → 事案、実行 |
| `0x12FL` | [EVALUATES](0x12FL-evaluates.md) | LINK | エントリポイント → 事案、判定 |
| `0x130L` | [TRIGGERS](0x130L-triggers.md) | LINK | トリガ → 事案 |
| `0x131L` | [UNTIL](0x131L-until.md) | LINK | トリガ → 事案 (`every … until`) |
| `0x132L` | [SAME-AS](0x132L-same-as.md) | LINK | ノード → グローバル識別子 |
| `0x133L` | [IMPORTED-FROM](0x133L-imported-from.md) | LINK | 別名 → パス (TEXT) |
| `0x134L` | [LABEL](0x134L-label.md) | LINK | ノード → TEXT、名前の表記 |

## ドキュメント {#문서}

`.geul` ファイル一つは DOC 一つである。DOC の外に他のバイトを置かない。

```
DOC-1WORD/2WORD/4WORD     全体の長さ
  SPEC-VERSION            0x0001 (v1, 内蔵 Value のない整数)
  PROFILE                 UTF8 Value "tangeul-<major>.<minor>". 現在 "tangeul-1.0"
  [DEFAULT-LANGUAGE]      LANGUAGE-BCP47-CODE Value. 作成ロケール ("en", "ko")
BODY
  SOURCE                  著作原文. BODY の最初のレコード
  文レコード …             ドキュメントの宣言順
END
```

- HEAD: [SPEC-VERSION](../meta/0x1C5L-spec-version.md)、[PROFILE](../meta/0x1C6L-profile.md)、任意で [DEFAULT-LANGUAGE](../meta/0x1CAL-default-language.md)。
- デコーダは、SPEC-VERSION が異なるか PROFILE の major が異なれば拒否する。minor が異なっても読む。
- BODY の最初のレコードは SOURCE である。すべての SPAN はこの原文の中の範囲である。
- 文レコードの順序はドキュメントの宣言順と同じである。実行順序 (`do`・`run` の発火、`undo` の逆順補償) がこの順序に依拠する。TOULMIN ドキュメントは Edge の順序に意味がある ([Edge レイアウト](../edge/_index.md#레이아웃)の順序規則の例外)。
- BODY のすべてのレコードは Edge である。独立した Value レコードは置かない。値は Edge の Payload に内蔵する。
- 事案の同一性と取り込みには、Meta の [DOC-ID](../meta/0x1C7L-doc-id.md)・[IMPORT-DOC](../meta/0x1E4L-import-doc.md) を使う (TANGEUL の Subject・See)。

## 共通フィールド {#공통-필드}

| フィールド | 幅 | 説明 |
|---|---|---|
| ID | LOCAL Reference レコード | レコードの Edge Id。すべてのレコードの Payload の最初の要素 |
| REF | LOCAL Reference レコード | このドキュメントの他のレコードを指す Edge Id。`0` はなし |
| SPAN | SOURCE が定めた幅 × 2 | 著作原文の中の範囲。開始バイト、バイト数 |

- ID と REF は内蔵の [LOCAL](../reference/0x005L-local.md) Reference レコード (`0000 0000 0101 LLLL` + 最短幅の ID) である。幅はそのレコードの Length が定め、ドキュメント単位では宣言しない。
- REF `0` (LOCAL `0`) は「なし」である。LOCAL `0` をなしとして使う Codec 規則である ([LOCAL](../reference/0x005L-local.md))。
- Edge Id は 1 から割り当て、ドキュメント内で重複させない。`0` は REF の「なし」なので Edge Id としては使わない。
- ノードは他のレコードが前方参照するため、ドキュメントの宣言順で先に番号を受け取る。それ以外のレコード (SOURCE、TEXT、LINK、FUNC、区画レコード) は、ノードの次の番号からエンコーダが割り当てる。
- デコーダは、Edge Id が 0 でなく重複がないことだけを確認する。割り当て順序は解釈に使わない。
- ノードと関係は Edge Id で指す。
- 内蔵 Value は、TAG WORD を含む Value レコードそのままである。長さはその TAG が定める。

## 数値 {#수치}

- 判定値 (−1~1)、Qualifier (0~1)、攻撃の強さ (0~1) は [SIGNED-DECIMAL](../value/0x068L-signed-decimal.md) Value である。固定小数形式は別に置かない。
- エンコーダは係数の末尾の 0 を消す。0.8 は `C=8, E=−1` である。デコーダは小数 4 桁まで受け付ける。
- 確信度ゲート (例: `at least 75%`) は、比較演算子 1 WORD とパーセントの [UNSIGNED-DECIMAL](../value/0x069L-unsigned-decimal.md) Value (`E=0`) で書く ([LINK](#link) の F_GATE)。
- 攻撃の強さは ATTACKS の F_FORCE フィールドである ([LINK](#공격-세기))。範囲を外れれば拒否する。

## ノード宣言の軸 {#노드-선언의-축}

- ノード宣言 (RULE・COUNTER・EXCEPT-DECLARE) は、役割 (主張・反駁・例外)、Qualifier (0~1)、Level (Unset, Fail, Review) を持つ。役割は Codec と NODE ヘッダの role が、Qualifier は F_QUAL が、Level はヘッダの level が担う ([NODE](#node))。
- 強度 (Strict, Defeasible, Defeater) は役割とは別の軸である。強度の配置はまだ定めていない。
- 攻撃の強さ (Force) はノードではなく ATTACKS エッジの値である ([LINK](#공격-세기) の F_FORCE)。強度とは別の軸である。

## 未知の入力に基づく判定 {#미상-위에서-판정하기}

判定グラフが GEUL の事実を入力として受け取るとき、[プレースホルダ](../slot-marker.md)の三つの概念 (記載なし、不明、なし) は異なる評価をする。[EXPR](0x101L-predicate-declare.md) の比較演算子の評価は次のとおりである。

| 入力 | `is empty` | `is not empty` | `equals` / `is in` / 大小比較 |
|---|---|---|---|
| 値 v | 偽 | 真 | v で評価 |
| NO-VALUE (なし) | **真** | 偽 | 偽 |
| UNKNOWN-VALUE (不明) | 偽 | **真** | **未定 (U)** |
| ABSENT (記載なし) / 叙述なし | U (開世界) | U | U |

- 論理は Kleene の強 3 値を使う。`NOT U = U`、`偽 AND U = 偽`、`真 OR U = 真`。その他の組み合わせの U は U である。
- `EXISTS any` は要素のうち一つでも真なら真である。真がなく U があれば U、すべて偽なら偽である。
- **述語が U なら、そのノードの判定は Pass・Fail ではなく Review である。** わからなければ人 (または次の段階) に渡す。
- ABSENT を U ではなく empty とみなすには、入力側が閉世界を**宣言**しなければならない (判断基準 SPEC として注入、例: 「この事案の入力は完全である」)。宣言がなければ U である。
- この表と U → Review の対応は判定の意味なので**固定された中核**である。TOULMIN ドキュメントで変えることはできない。
- 例: 「現在も有効な国境だけを数える」(`P582 is empty`) 規則は、P582 = UNKNOWN-VALUE なら偽なので除外し、P582 = NO-VALUE なら真なので含め、P582 がなければ U なので Review に回す。

## 判定結果 {#판정-결과}

- 判定結果 (`VERDICT`, `EVIDENCE`) は判定対象とは別のドキュメントに置く。結果ドキュメントが対象ドキュメントを [IMPORT-DOC](../meta/0x1E4L-import-doc.md) で取り込み、[EXTERNAL-POINTER-*](../reference/0x020L-external-pointer-1word.md) で指す。そのため判定しても対象ドキュメントのコンテンツハッシュは変わらない。
- ドキュメント全体の判定は Meta の `VERDICT`、ノード・レコードの判定は TOULMIN の `VERDICT` である。
- 改訂の適用版を選ぶ規則 (経過規定、行為時法と新法の選択) と、解釈例・判例も判定規則として使う ([ドキュメント](../document.md#개정))。

## 未解決の問題 {#열린-문제}

- SUPERSEDE-CHAIN (`0x10AL`)、VERDICT (`0x118L`)、EVIDENCE (`0x119L`) のレイアウト。SUPERSEDES を組ごとに書く現在の方式で連鎖として十分かどうか。
- ノード強度 (Strict, Defeasible, Defeater) の配置。
- 攻撃の強さ 1 を書いた ATTACKS と書かない ATTACKS は判定が同じだがバイトが異なる。判定が同じかどうかは、バイトではなく解釈した値で比較しなければならない。
- EXPR の中のノード数、ラベル数、ラベルインデックスは 1 WORD で、子の数は 13 ビットである。上限が固定されている。
- PROVENANCE (規則の出典・前提) のレイアウト。
- バッククォート名を TEXT + LABEL (`0x134L`) の代わりに、叙述 [LABEL](../edge/0x0A4L-label.md)・[BIND](../edge/0x0A3L-bind.md) として置くかどうか。
- Claim の predicate・mode のコード値と、FuncRef の VerbCode のコード値表。
- 閉世界宣言 (ABSENT を empty として読む) を判断基準 (SPEC) とするか、事案単位とするか。
- TOULMIN Codec の [Codec 規格ドキュメント](../codec-spec.md)。NODE・LINK の条件付きフィールドと、SOURCE が定める SPAN 幅は、FIELD で宣言できないレイアウトである。

## 関連ページ {#관련-페이지}

- [NODE](#node)、[LINK](#link)、[EXPR](0x101L-predicate-declare.md)、[SOURCE と区画](#source와-구획)
- [ドキュメント](../document.md)、[PROFILE](../meta/0x1C6L-profile.md)

## NODE {#node}

NODE は TOULMIN の判定・実行グラフのノードを書くレイアウトである。ノードの種類は Codec が定め、ヘッダ 1 WORD が役割・Level・Claim の形と条件付きフィールドを定める。

### Codec {#codec}

| Codec | 名前 | TANGEUL | ノード |
|---|---|---|---|
| `0x100L` | [CASE-DECLARE](0x100L-case-declare.md) | `in case of` | 事案 |
| `0x102L` | [SPEC-DECLARE](0x102L-spec-declare.md) | Definitions の項目 (`means`, `has`) | 判断基準 (Backing)。role が定義の種類 |
| `0x103L` | [RULE-DECLARE](0x103L-rule-declare.md) | general rule | 主張 (Warrant) |
| `0x104L` | [COUNTER-DECLARE](0x104L-counter-declare.md) | counter rule | 反駁 (Rebuttal) |
| `0x105L` | [EXCEPT-DECLARE](0x105L-except-declare.md) | except rule | 例外 (Defeater) |
| `0x115L` | [ENTRY](0x115L-entry.md) | `provides x` | 外部エントリポイント |
| `0x116L` | [TRIGGER](0x116L-trigger.md) | `on`, `every`, `until` | イベント・周期のエントリポイント |
| `0x126L` | [NAMESPACE](0x126L-namespace.md) | `this document is` | ドキュメントの名前空間 |
| `0x127L` | [FUNC](0x127L-func.md) | 関数参照 | 外部関数 (例: `bank.withdraw`) |
| `0x128L` | [FIELD](0x128L-field.md) | `x is required [as Type]` | 必須フィールド |
| `0x129L` | [ALIAS](0x129L-alias.md) | `see a from path` | 取り込んだパッケージの別名 |
| `0x12AL` | [GROUP](0x12AL-group.md) | `1.` 順序リスト | 順序のある実行のまとまり |

`0x126L~0x12AL` は Edge TOULMIN 形式系列の直接コードである ([TOULMIN](#toulmin-형식))。

### レイアウト {#레이아웃}

```
ID               LOCAL Reference レコード (Edge Id)
ヘッダ 1 WORD    role 2b | Reserved 2b | F_GROUNDS 1b | level 2b | object 種別 2b | flags 7b
[F_FUNC]         FuncRef: REF (ALIAS、なければ 0) + VerbCode 1 WORD
[F_QUAL]         SIGNED-DECIMAL Value. Qualifier
[F_CHECK]        REF (事案)
[F_CLAIM]        Claim: REF (subject) + predicate 1 WORD + object + mode 1 WORD
[F_VERDICT]      SIGNED-DECIMAL Value. 判定値の初期値
[F_WITH]         個数 (UNSIGNED-INTEGER Value) + REF (TEXT) × 個数
[F_GROUNDS]      個数 (UNSIGNED-INTEGER Value) + REF (TEXT) × 個数
SPAN             SOURCE が定めた幅 × 2 (開始バイト、バイト数)
```

#### ヘッダ WORD {#헤더-word}

| ビット | フィールド | 値 |
|---|---|---|
| 15–14 | role | 0 general, 1 counter, 2 except |
| 13–12 | Reserved | 0 |
| 11 | F_GROUNDS | 根拠の一覧がある |
| 10–9 | level | 0 Unset, 1 Fail, 2 Review (3 Reserved) |
| 8–7 | object 種別 | Claim の object の形。0 REF, 1 UNSIGNED-INTEGER Value, 2 SPAN |
| 6–0 | flags | 下の表 |

| ビット | flag | 意味 |
|---|---|---|
| b0 | F_FUNC | FuncRef フィールドがある |
| b1 | F_QUAL | Qualifier フィールドがある |
| b2 | F_CHECK | `checking` の対象事案フィールドがある |
| b3 | F_CLAIM | Claim フィールドがある |
| b4 | F_VERDICT | 判定値の初期値フィールドがある |
| b5 | F_STRIKE | 取り消し線で消した宣言である。フィールドはない |
| b6 | F_WITH | 基準の一覧フィールドがある |

- 条件付きフィールドは flag の順序 (F_FUNC, F_QUAL, F_CHECK, F_CLAIM, F_VERDICT, F_WITH, F_GROUNDS) で置く。flag がオフのフィールドは場所を占めない。
- flag がオンなのにフィールドがなければ拒否する。フィールドを順に読んだ位置は、SPAN の後でレコードの終端とぴったり合わなければならない。

### フィールド {#필드}

| フィールド | 説明 |
|---|---|
| FuncRef | 関数の位置。REF はその関数を取り込んだ ALIAS レコードで、このドキュメントの関数なら `0` である。VerbCode は 1 WORD のコードでまだ割り当てていない (`0x0000` を許容)。関数の原文表記は TEXT + [LABEL](#link) で別に書く |
| Qualifier | ノードの確信度 (0~1) |
| 事案 | F_CHECK: このノードが判定だけを行う事案 (`checking c`) |
| Claim | ノードが担う命題。subject REF、predicate 1 WORD、object、mode 1 WORD。object の形はヘッダの object 種別が定める |
| 判定値 | 判定値の初期値 (−1~1) |
| F_WITH | 宣言時点の判断基準 (`기준으로 하는`、「〜を基準とする」の意)。TEXT レコードの REF の一覧 |
| F_GROUNDS | 評価時点で解釈する外部事実の名前 (`근거로 하는`、「〜を根拠とする」の意)。TEXT レコードの REF の一覧 |
| SPAN | この宣言が現れた原文の範囲 |

- 判定値・Qualifier の表記は [TOULMIN](#수치) の数値規則に従う。
- 一覧の個数は内蔵の [UNSIGNED-INTEGER](../value/0x062L-unsigned-integer.md) Value レコードである。
- 叙述 Claim の基本形は、subject・predicate が `0` で、object が SPAN (object 種別 2) である。原文表記に固定する。

### 解釈と有効性 {#해석과-유효성}

- role は RULE・COUNTER・EXCEPT-DECLARE では Codec と同じでなければならない (0 general, 1 counter, 2 except)。SPEC-DECLARE では定義の種類である。それ以外の Codec では 0 である。
- level が 0 (Unset) ならエンジンの既定値を使う。COUNTER-DECLARE は Fail、EXCEPT-DECLARE は Review。
- TANGEUL `tangl:규칙` のホスト関数規則 (`쓰는 규칙이다`、「〜を使う規則である」の意) は、事案の外の RULE-DECLARE NODE で書く。関数は F_FUNC、基準は F_WITH、根拠は F_GROUNDS である。条件式の規則だけが前に [PREDICATE-DECLARE](0x101L-predicate-declare.md) を置く。
- Reserved ビット (13–12) は 0 でなければならない。Reserved ビットがオンか、role が Codec と合わなければ拒否する。

### 関連ページ {#관련-페이지-1}

- [TOULMIN](_index.md)、[LINK](#link)、[EXPR](0x101L-predicate-declare.md)、[SOURCE と区画](#source와-구획)
- [LOCAL](../reference/0x005L-local.md)、[SIGNED-DECIMAL](../value/0x068L-signed-decimal.md)

## LINK {#link}

LINK は TOULMIN グラフでノード間の関係を書くレイアウトである。関係の種類は Codec が定める。

### Codec {#codec-1}

| Codec | 名前 | TANGEUL | src → dst |
|---|---|---|---|
| `0x108L` | [ATTACKS](0x108L-attacks.md) | `don't X when Y` | 規則 → 規則。判定を攻撃の強さの分だけ漸進的に削る |
| `0x109L` | [SUPERSEDES](0x109L-supersedes.md) | `X supersedes Y` | 規則 → 規則。Active なら対象を集計から除く |
| `0x110L` | [RUN](0x110L-run.md) | `run c when n` | 規則 → 事案 |
| `0x111L` | [DO](0x111L-do.md) | `do fn when n` | 規則 → FuncRef |
| `0x112L` | [DO-ONCE](0x112L-do-once.md) | `do fn once when n` | 規則 → FuncRef |
| `0x113L` | [UNDO](0x113L-undo.md) | `undo fn when n` | 規則 → FuncRef |
| `0x114L` | [CHECKING](0x114L-checking.md) | `checking c` | 規則 → 事案。副作用のない判定 |
| `0x12BL` | [REQUIRES](0x12BL-requires.md) | `f is required` | 事案 → フィールド |
| `0x12CL` | [MEANS](0x12CL-means.md) | Definitions `means` | 定義項目 → 値・型 |
| `0x12DL` | [HAS](0x12DL-has.md) | Definitions `has` | 定義項目 → フィールド |
| `0x12EL` | [RUNS](0x12EL-runs.md) | エントリポイント `run c` | エントリポイント → 事案 (実行) |
| `0x12FL` | [EVALUATES](0x12FL-evaluates.md) | エントリポイント `check c` | エントリポイント → 事案 (判定) |
| `0x130L` | [TRIGGERS](0x130L-triggers.md) | トリガ `run c` | トリガ → 事案 |
| `0x131L` | [UNTIL](0x131L-until.md) | `every … until c` | トリガ → 事案 |
| `0x132L` | [SAME-AS](0x132L-same-as.md) | | ノード → グローバル識別子 |
| `0x133L` | [IMPORTED-FROM](0x133L-imported-from.md) | `see a from path` | 別名 → パス (TEXT) |
| `0x134L` | [LABEL](0x134L-label.md) | バッククォート名 | ノード → TEXT。名前の表記 |

### レイアウト {#레이아웃-1}

```
ID               LOCAL Reference レコード (Edge Id)
src              REF
dst              REF. DO·DO-ONCE·UNDO は FuncRef
flags 1 WORD     b0 F_ONCE, b1 F_GATE, b2 F_STRIKE, b3 F_ORDERED, b4 F_FORCE
[F_GATE]         演算子 1 WORD (上位 2 ビット) + UNSIGNED-DECIMAL Value (パーセント)
[F_FORCE]        SIGNED-DECIMAL Value. 攻撃の強さ (0~1). ATTACKS のみ
SPAN             SOURCE が定めた幅 × 2
```

| flag | 意味 |
|---|---|
| b0 F_ONCE | 一度だけ行う (UNDO の `once`) |
| b1 F_GATE | 確信度ゲートのフィールドがある |
| b2 F_STRIKE | 取り消し線で消した関係である |
| b3 F_ORDERED | `1.` 順序リストに属する |
| b4 F_FORCE | 攻撃の強さのフィールドがある。ATTACKS のみ |

| ゲート演算子 | 意味 |
|---|---|
| 0 | at least |
| 1 | above |
| 2 | less than |
| 3 | at most |

- 条件付きフィールドは flag の順序 (F_GATE, F_FORCE) で置く。flag がオフのフィールドは場所を占めない。

### 攻撃の強さ {#공격-세기}

攻撃の強さ (F_FORCE) は [ATTACKS](0x108L-attacks.md#공격-세기) だけが使う。判定式、表記、例はそちらにある。

### 解釈と有効性 {#해석과-유효성-1}

- REF はこのドキュメントのレコードの Edge Id である ([TOULMIN](#공통-필드) の共通フィールド)。
- dst の形は Codec が定める。DO・DO-ONCE・UNDO は FuncRef (REF (ALIAS、なければ 0) + VerbCode 1 WORD、[NODE](#필드))、LABEL・IMPORTED-FROM は TEXT レコードの REF、残りはノードの REF である。
- `do … once` は DO-ONCE Codec が表す。DO-ONCE の flags に F_ONCE は使わない (オンになっていれば拒否する)。UNDO の `once` は F_ONCE で書く。
- ゲート演算子は演算子 WORD の上位 2 ビットで、残りの 14 ビットは 0 である。パーセントは `E=0` の UNSIGNED-DECIMAL Value で、0~100 である。
- flags の b5~b15 は Reserved で 0 でなければならない。そうでなければ拒否する。
- F_FORCE は ATTACKS だけで使う。他の Codec (SUPERSEDES、実行・判定の接続、TOULMIN 形式の関係) でオンになっていれば拒否する。
- 攻撃の強さが SIGNED-DECIMAL Value でないか、0~1 の外か、小数 4 桁で正確に表せなければ拒否する。
- SUPERSEDES の連鎖 `A > B > C` は、組ごとに SUPERSEDES を一つずつ書く。

### 関連ページ {#관련-페이지-2}

- [TOULMIN](_index.md)、[NODE](#node)、[SOURCE と区画](#source와-구획)
- [UNSIGNED-DECIMAL](../value/0x069L-unsigned-decimal.md)、[SIGNED-DECIMAL](../value/0x068L-signed-decimal.md)

## SOURCE と区画 {#source와-구획}

TOULMIN ドキュメントの原文と区画を書くレコードである。すべて Edge TOULMIN 形式系列の直接コード `0x120L~0x125L` である ([TOULMIN](#toulmin-형식))。Issuer と Codec 番号の欄がなく、TAG の直後に Payload が来る。

### 形式 {#형식}

| Codec | 名前 | レイアウト |
|---|---|---|
| `0x120L` | [SOURCE](0x120L-source.md) | ID, SPAN 幅 WORD, UTF8 Value |
| `0x121L` | [TEXT](0x121L-text.md) | ID, UTF8 Value |
| `0x122L` | [SECTION](0x122L-section.md) | ID, セクションコード 1 WORD |
| `0x123L` | [CASE-BEGIN](0x123L-case-begin.md) | ID, REF (事案) |
| `0x124L` | [CASE-END](0x124L-case-end.md) | ID, REF (事案) |
| `0x125L` | [PROSE](0x125L-prose.md) | ID, SPAN |

- ID は Edge Id、REF はこのドキュメントのレコードの Edge Id である ([TOULMIN](#공통-필드) の共通フィールド)。
- UTF8 Value は [UTF8-TEXT](../value/0x072L-utf8-text.md) Value レコードである。バイトをそのまま収める。

### 形式別のページ {#형식별-쪽}

レイアウト、セクションコード表、解釈は、形式ごとに別のページがある。

- [SOURCE](0x120L-source.md): 著作原文。BODY の最初のレコードで、SPAN 幅を定める
- [TEXT](0x121L-text.md): 名前・文字列
- [SECTION](0x122L-section.md): セクションの開始とセクションコード
- [CASE-BEGIN](0x123L-case-begin.md)、[CASE-END](0x124L-case-end.md): 事案の範囲
- [PROSE](0x125L-prose.md): 叙述の段落

### 関連ページ {#관련-페이지-3}

- [TOULMIN](_index.md)、[NODE](#node)、[LINK](#link)
