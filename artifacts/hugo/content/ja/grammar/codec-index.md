---
title: "コード索引"
weight: 60
date: 2026-11-05T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar"]
summary: "このページはすべての Codec の索引だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

このページはすべての Codec の索引だ。名前を押すと、その Codec の詳細ドキュメントに移る。表にない直接コードは Reserved だ。

## Kind {#kind}

TAG WORD は `000K KKKC CCCC LLLL` だ。上位4ビット `KKKK` はセクション、`C` はセクション内の5ビットオフセット、`LLLL` は Length である。セクションと `C` を合わせた9ビットが Codec の位置だ。TAG ID は `0x000L` と書く。前の三桁がこの9ビット(`w >> 4`)で、`L` は Length の桁だ([レコードと TAG WORD](record.md))。

| セクション | TAG ID | 分類 | 説明 |
|---|---|---|---|
| 0~2 | `0x000L~0x05FL` | [Reference](reference/_index.md) | 対象を指すレコード |
| 3·4 | `0x060L~0x09FL` | [Value](value/_index.md) | 値のレコード |
| 5~13 | `0x0A0L~0x1BFL` | [Edge](edge/_index.md) | 構成レコード |
| 14·15 | `0x1C0L~0x1FFL` | [Meta](meta/_index.md) | ドキュメントとレコードに関するレコード |

- セクションは `S = w >> 9`(4ビット)で、一つのセクションは32マスだ。
- Kind はセクション区間一つで判定する: `w < 0x0600` は Reference、`w < 0x0A00` は Value、`w < 0x1C00` は Edge、残りは Meta。例外はない。
- Reference、Value、Edge 区域の最後の三マスは ISSUER だ(`..DL` 2 WORD、`..EL` 4 WORD、`..FL` 16 WORD)。Meta には ISSUER がない。

## Reference {#reference}

`0x000L~0x05FL` — [Reference](reference/_index.md)

### Codec {#codec}

| TAG ID | 名前 | 分類 | 対象 ID |
|---|---|---|---|
| `0x000L~0x002L` | [プレースホルダ](slot-marker.md) | プレースホルダ | 対象を指さない1 WORD プレースホルダのまとまり(下の表) |
| `0x005L~0x009L` | [LOCAL](reference/0x005L-local.md) | 宣言 | このドキュメントが発行した ID |
| `0x00AL~0x00EL` | [GEUL](reference/0x00AL-geul.md) | 宣言 | geul.org が CC0 で発行するエンティティ。小さい番号を高頻度のエンティティに割り当てる |
| `0x00FL~0x013L` | [GEUL-SIDX](reference/0x00FL-geul-sidx.md) | 宣言 | GEUL SIDX(Semantic-aligned Index)。ビットに意味を持たせた識別子 |
| `0x014L~0x018L` | [WIKIDATA-QID](reference/0x014L-wikidata-qid.md) | 宣言 | Wikidata の項目。`Q` の後の整数 |
| `0x019L~0x01DL` | [WIKIDATA-PID](reference/0x019L-wikidata-pid.md) | 宣言 | Wikidata のプロパティ。`P` の後の整数 |
| `0x020L~0x024L` | [EXTERNAL-POINTER-1WORD](reference/0x020L-external-pointer-1word.md) | 指示 | `IMPORT-DOC` で取り込んだドキュメントの LOCAL ID。IMPORT ID 1 WORD |
| `0x025L~0x029L` | [EXTERNAL-POINTER-2WORD](reference/0x025L-external-pointer-2word.md) | 指示 | 同上。IMPORT ID 2 WORD |
| `0x02AL~0x02EL` | [EXTERNAL-POINTER-4WORD](reference/0x02AL-external-pointer-4word.md) | 指示 | 同上。IMPORT ID 4 WORD |
| `0x02FL~0x033L` | [EXTERNAL-ISSUER-2WORD](reference/0x02FL-external-issuer-2word.md) | 指示宣言 | 2 WORD Issuer ドキュメントの LOCAL ID |
| `0x034L~0x038L` | [EXTERNAL-ISSUER-4WORD](reference/0x034L-external-issuer-4word.md) | 指示宣言 | 4 WORD Issuer ドキュメントの LOCAL ID |
| `0x039L~0x03DL` | [EXTERNAL-ISSUER-16WORD](reference/0x039L-external-issuer-16word.md) | 指示宣言 | 16 WORD Issuer ドキュメントの LOCAL ID |
| `0x040L` | [ISSUER-POINTER](reference/0x040L-issuer-pointer.md) | 指示宣言 | Issuer 自身。Payload は Issuer(2/4/16 WORD)のみで、対象 ID はない |
| `0x041L` | [DOC-POINTER](reference/0x041L-doc-pointer.md) | 指示宣言 | Issuer ドキュメントの一つのバージョン。Issuer + ドキュメント ID 4 WORD + バージョン ID 2 WORD、対象 ID はない |
| `0x042L` | [CODEC-POINTER](reference/0x042L-codec-pointer.md) | 指示宣言 | Issuer Codec の一つのバージョン。Issuer + Codec ID 2 WORD + バージョン ID 2 WORD、対象 ID はない |
| `0x043L` | [TOKEN-0](reference/0x043L-token.md) | 宣言 | GEUL トークン語彙の項目(トークン ID 0~65,535)。Payload 1 WORD、全体 2 WORD |
| `0x044L` | [TOKEN-1](reference/0x043L-token.md) | 宣言 | 同上。トークン ID 65,536~131,071(65,536 + Payload) |
| `0x05DL` | [REFERENCE-ISSUER-2WORD](reference/0x05DL-reference-issuer-2word.md) | Issuer 形式 | Issuer 2 WORD と Codec 番号 2 WORD。分類と対象は Issuer ドキュメントが定める |
| `0x05EL` | [REFERENCE-ISSUER-4WORD](reference/0x05EL-reference-issuer-4word.md) | Issuer 形式 | Issuer 4 WORD と Codec 番号 2 WORD。同上 |
| `0x05FL` | [REFERENCE-ISSUER-16WORD](reference/0x05FL-reference-issuer-16word.md) | Issuer 形式 | Issuer 16 WORD と Codec 番号 2 WORD。同上 |

- Reference はセクション三つだ。セクション0 エンティティ `0x000L~0x01FL`(プレースホルダ、5Q 体系)、セクション1 EXTERNAL `0x020L~0x03FL`、セクション2 その他 `0x040L~0x05FL`(ポインタ、REFERENCE-ISSUER)。Reserved は `0x003L~0x004L`、`0x01EL~0x01FL`、`0x03EL~0x03FL`、`0x045L~0x05CL` だ。
- 5マスのまとまり(LOCAL から EXTERNAL-ISSUER-16WORD まで)は、下の Quantifier の順に一マスずつだ。例: WIKIDATA-QID Identified `0x014L`、Generic `0x015L`。

### プレースホルダ (`0x000L~0x002L`) {#자리-표지-0x000l0x002l}

`0x0000`、`0x0010`、`0x0020` — [プレースホルダ](slot-marker.md)。フィールドの CODEC 一覧がその WORD をちょうど指定している場合に限って、その位置に来る。

| WORD | 名前 | 意味 | Wikidata |
|---|---|---|---|
| `0x0000` | [ABSENT](reference/0x000L-absent.md) | 記載なし。任意フィールドを省略した。世界について何も断定しない | snak なし |
| `0x0010` | [UNKNOWN-VALUE](reference/0x001L-unknown-value.md) | 不明。値はあるが何かわからない | `somevalue` |
| `0x0020` | [NO-VALUE](reference/0x002L-no-value.md) | なし。値が存在しない | `novalue` |

### Quantifier {#quantifier}

| `C % 5` | 名前 | 意味 | 例 |
|---|---|---|---|
| `0` | Identified | 識別された個体 | イーロン・マスク、大韓民国 |
| `1` | Generic | 種類全体に関する一般的・定義的な陳述。例外を許す。 | 兵士は命令に服従する |
| `2` | Free-choice | 条件を満たす任意の対象 | どの兵士でも |
| `3` | Universal | 与えられた範囲に属するすべての対象 | すべての兵士 |
| `4` | Variable | 談話変数 | その人、この女性 |

- 量化はセクション内オフセット `C` で読む。セクション0で `5 <= C < 30` なら量化は `C % 5`、体系は `C / 5`(1~5)だ。セクション1で `C < 30` なら量化は `C % 5`、体系は `6 + C / 5`(6~11)だ。プレースホルダ(セクション0、`C < 3`)とセクション2(ポインタ、REFERENCE-ISSUER)には使わない。
- ISSUER-POINTER、DOC-POINTER、CODEC-POINTER は量化のない一マスだ。REFERENCE-ISSUER の量化は、Issuer が発行した Codec ドキュメントが定める。

## Issuer {#issuer}

Issuer はドキュメントと形式を定義する主体だ — [Issuer と公表](issuer.md)

| 位置 | 意味 |
|---|---|
| Reference·Value·Edge の ISSUER コード(各区域の最後の三マス) | その Issuer が定義した形式 |
| Meta `DOC-ID` | このドキュメントを出した Issuer |
| Meta `IMPORT-DOC` | 取り込んだドキュメントを出した Issuer |
| Reference `EXTERNAL-ISSUER-*`·`DOC-POINTER`·`CODEC-POINTER` | 指すドキュメント・Codec を出した Issuer(2/4/16 WORD) |
| Reference `ISSUER-POINTER` | 指す Issuer 自身(2/4/16 WORD) |

| Issuer 幅 | 発行 |
|---|---|
| 2 WORD | geul.org 登録。ドメイン所有証明(例: company.com)を経た Issuer。geul.org が標準策定団体と主要機関に割り当てた番号もこの幅だ([2 WORD 割り当て表](issuer.md#2-word-배정표))。 |
| 4 WORD | geul.org 登録。所有証明なしで登録した Issuer |
| 16 WORD | 自己発行。登録なしで公開鍵から計算する。下の生成規則に従う。 |

### 16 WORD Issuer 署名アルゴリズム {#16-word-issuer-서명-알고리즘}

| 署名アルゴリズム ID | アルゴリズム |
|---|---|
| `0x0001` | Ed25519 |
| それ以外 | Reserved |

## Edge {#edge}

`0x0A0L~0x1BFL` — [Edge](edge/_index.md)

直接コードの系列は `(コード − 0xA0) >> 5` だ(コードは TAG ID の前の三桁)。系列は32マスずつで、セクション `w >> 9` から5を引いた値と同じだ。割り当て済みの直接コードは下の五つの系列だ。`0x135L~0x1BCL` は Reserved だ(セクション10~12はセクション全体が Reserved)。Issuer 形式には系列の規則がない。

| セクション | 系列 | 直接コード |
|---|---|---|
| 5 | 叙述 | `0x0A0L~0x0BFL` |
| 6 | 根拠 | `0x0C0L~0x0DFL` |
| 7 | 実行 | `0x0E0L~0x0FFL` |
| 8 | [TOULMIN](toulmin/_index.md) | `0x100L~0x11BL` |
| 9 | [TOULMIN](toulmin/_index.md) 形式 | `0x120L~0x134L` |

- `0x11CL~0x11FL` は Reserved だ。
- `0x1BDL~0x1BFL`(セクション13の最後の三マス)は EDGE-ISSUER だ(下の Edge ISSUER 形式)。

### 叙述 (`0x0A0L~0x0BFL`) {#서술-0x0a0l0x0bfl}

| Codec | 名前 | 下位形式 | 説明 |
|---|---|---|---|
| `0x0A0L` | [REFERENCE-NODE](edge/0x0A0L-reference-node.md) |  | Reference である Subject が Object を指示する方向性バインディング |
| `0x0A1L` | [SAME-NODE](edge/0x0A1L-same-node.md) |  | 二つの Reference が同一の対象を指示する同一性 |
| `0x0A2L` | [DIFFERENT-NODE](edge/0x0A2L-different-node.md) |  | 二つの Reference が互いに異なる対象を指示する非同一性 |
| `0x0A3L` | [BIND](edge/0x0A3L-bind.md) |  | Subject に機械が照合する名前(`UTF8-TEXT-*`)を結びつける。範囲内で一意で、正確に一致しなければならず、言語はない |
| `0x0A4L` | [LABEL](edge/0x0A4L-label.md) |  | Subject の言語別名前(label)の連結。Object は UTF8-LANGUAGE-TEXT |
| `0x0A5L` | [ALIAS](edge/0x0A5L-alias.md) |  | Subject の別名(エイリアス)の連結。レイアウトは LABEL と同じ |
| `0x0A6L` | [DESCRIPTION](edge/0x0A6L-description.md) |  | Subject の言語別説明(description)の連結。レイアウトは LABEL と同じ |
| `0x0A7L` | Reserved |  |  |
| `0x0A8L` | [VERB-SHORT](edge/0x0A8L-verb-short.md) |  | 動詞叙述の短縮形 |
| `0x0A9L` | [VERB](edge/0x0A9L-verb.md) |  | 動詞叙述 |
| `0x0AAL` | [TRIPLE](edge/0x0AAL-triple.md) |  | Predicate、Subject、Object の順の命題と rank。Object は値または UNKNOWN-VALUE·NO-VALUE プレースホルダ。意味は、その Edge Id を指す QUALIFIER をすべて集めたものだ |
| `0x0ABL` | [QUALIFIER](edge/0x0ABL-qualifier.md) |  | 他の Edge の命題を限定する条件一つ。Property、Target(Edge Id)、Value(値または UNKNOWN-VALUE·NO-VALUE プレースホルダ)。命題の一部だ |
| `0x0ACL~0x0AFL` | Reserved |  |  |
| `0x0B0L` | [WORLD](edge/0x0B0L-world.md) | あり | 世界観を表現するための構造 |
| `0x0B1L` | [TIMELINE](edge/0x0B1L-timeline.md) | あり | 世界と出来事の順序を表現する構造 |
| `0x0B2L` | [SCENE](edge/0x0B2L-scene.md) | あり | シナリオ特性の叙述のための場面構造 |
| `0x0B3L~0x0B7L` | Reserved |  |  |
| `0x0B8L` | [PUBLICATION](edge/0x0B8L-publication.md) |  | ドキュメントの公表。DOC-POINTER、コンテンツハッシュ |
| `0x0B9L` | [DEPRECATION](edge/0x0B9L-deprecation.md) |  | 公表したバージョンの deprecate。DOC-POINTER |
| `0x0BAL` | [TOMBSTONE](edge/0x0BAL-tombstone.md) |  | 公表したバージョンの削除(墓標)。DOC-POINTER、事由の範疇 |
| `0x0BBL` | [DECLARE](edge/0x0BBL-declare.md) |  | Codec 一つの Payload 構成の宣言。対象 Kind·Codec |
| `0x0BCL` | [FIELD](edge/0x0BCL-field.md) |  | Payload フィールド一つ。所属する DECLARE、幅: レコード(TAG の Length)または生値 n WORD |
| `0x0BDL` | [ENUM](edge/0x0BDL-enum.md) |  | 生値フィールドのコード値一つ。フィールド、コード値 |
| `0x0BEL` | [CODEC](edge/0x0BEL-codec.md) |  | フィールドが受け取る Kind·Codec 一つ。フィールド、対象 WORD(`000K KKKC CCCC LLLL`、LLLL は 0000 が正確・1111 がワイルドカード(そのセクション32マス全体)、プレースホルダは正確な対象 `0000`·`0010`·`0020` のみ)。レコードフィールドは複数(閉じた一覧)、生値フィールドは一つ(TAG のないその Value) |
| `0x0BFL` | Reserved |  |  |

| TAG ID | まとまり |
|---|---|
| `0x0A0L~0x0A7L` | 指示と名前 |
| `0x0A8L~0x0AFL` | 命題 |
| `0x0B0L~0x0B7L` | 構造 |
| `0x0B8L~0x0BFL` | その他 |

### 根拠 (`0x0C0L~0x0DFL`) {#근거-0x0c0l0x0dfl}

| Codec | 名前 | 下位形式 | 説明 |
|---|---|---|---|
| `0x0C0L` | [SOURCE](edge/0x0C0L-source.md) |  | レコード一つまたはドキュメント全体をその原典に結ぶ。Target(BODY Edge Id、HEAD では `0` = ドキュメント全体)、Origin(Reference、ABSENT または UNKNOWN-VALUE)。原典の性質は原典を Subject とする TRIPLE、引用の性質(参照日、位置、原文ハッシュ)は SOURCE に付く QUALIFIER。ドキュメント全体の SOURCE とその QUALIFIER は HEAD に置く |
| `0x0C1L~0x0DFL` | Reserved |  |  |

- 原文の範囲、作成主体、信頼度、条文別の施行期間、旧レコードは QUALIFIER で書き、最初に入ったバージョンはバージョン履歴から計算する([SOURCE](edge/0x0C0L-source.md#다른-근거의-표현))。

### 実行 (`0x0E0L~0x0FFL`) {#실행-0x0e0l0x0ffl}

| Codec | 名前 | 説明 |
|---|---|---|
| `0x0E0L` | Reserved |  |
| `0x0E1L` | [FUNCTION-DECLARE](edge/0x0E1L-function-declare.md) | 関数宣言。シンボル、パラメータシンボル一覧、戻り値の型、本体(BLOCK) |
| `0x0E2L` | [TYPE-DECLARE](edge/0x0E2L-type-declare.md) | 型宣言。シンボルと構成(フィールドシンボル一覧、列挙値、エイリアス対象) |
| `0x0E3L~0x0E7L` | Reserved |  |
| `0x0E8L` | [CONST](edge/0x0E8L-const.md) | 定数式。組み込み Value 一つ |
| `0x0E9L` | [UNARY](edge/0x0E9L-unary.md) | 単項式。演算子 1 WORD、オペランド |
| `0x0EAL` | [BINARY](edge/0x0EAL-binary.md) | 二項式。演算子 1 WORD、左、右 |
| `0x0EBL` | [CALL](edge/0x0EBL-call.md) | 呼び出し。対象関数、引数の数、引数 × 引数の数 |
| `0x0ECL` | [MEMBER](edge/0x0ECL-member.md) | メンバーアクセス。対象、フィールドシンボル |
| `0x0EDL` | [INDEX](edge/0x0EDL-index.md) | 添字アクセス。対象、添字 |
| `0x0EEL` | [CONSTRUCT](edge/0x0EEL-construct.md) | 複合値の生成(リスト、レコード)。型、要素数、要素 × 要素数 |
| `0x0EFL` | [CONDITIONAL](edge/0x0EFL-conditional.md) | 条件式。条件、真のときの値、偽のときの値 |
| `0x0F0L` | [BLOCK](edge/0x0F0L-block.md) | 順序のある文のまとまり。文の数、文 × 文の数 |
| `0x0F1L` | [ASSIGN](edge/0x0F1L-assign.md) | 代入。対象(シンボル、MEMBER、INDEX)、値 |
| `0x0F2L` | [IF](edge/0x0F2L-if.md) | 条件分岐。条件、真の BLOCK、偽(BLOCK·IF、なければ 0) |
| `0x0F3L` | [SWITCH](edge/0x0F3L-switch.md) | 多分岐。対象、分岐の数、(値, BLOCK) × 分岐の数、デフォルト BLOCK(なければ 0) |
| `0x0F4L` | [WHILE](edge/0x0F4L-while.md) | 条件反復。条件、本体 BLOCK |
| `0x0F5L` | [FOREACH](edge/0x0F5L-foreach.md) | 巡回反復。要素シンボル、対象、本体 BLOCK |
| `0x0F6L` | [JUMP](edge/0x0F6L-jump.md) | 反復制御。種類 1 WORD(break, continue)、対象の反復 |
| `0x0F7L` | [RETURN](edge/0x0F7L-return.md) | 戻り。値(なければ 0) |
| `0x0F8L` | [RAISE](edge/0x0F8L-raise.md) | エラー発生。エラー値 |
| `0x0F9L` | [TRY](edge/0x0F9L-try.md) | エラー処理。本体 BLOCK、エラーシンボル、処理 BLOCK、終了処理 BLOCK(なければ 0) |
| `0x0FAL~0x0FFL` | Reserved |  |

| TAG ID | まとまり |
|---|---|
| `0x0E0L~0x0E7L` | 宣言 |
| `0x0E8L~0x0EFL` | 式 |
| `0x0F0L~0x0F7L` | 文 |
| `0x0F8L~0x0FFL` | エラー |

### TOULMIN (`0x100L~0x11BL`) {#toulmin-0x100l0x11bl}

詳細: [TOULMIN](toulmin/_index.md)

| Codec | 名前 | 説明 |
|---|---|---|
| `0x100L` | [CASE-DECLARE](toulmin/0x100L-case-declare.md) | 事案宣言。ノードと関係を持つ判定グラフ |
| `0x101L` | [PREDICATE-DECLARE](toulmin/0x101L-predicate-declare.md) | 述語宣言。判定関数·式、判断基準(Spec)、事実契約(Ground) |
| `0x102L` | [SPEC-DECLARE](toulmin/0x102L-spec-declare.md) | 判断基準宣言。定数·リスト (Backing) |
| `0x103L` | [RULE-DECLARE](toulmin/0x103L-rule-declare.md) | 主張宣言。事案の中で述語を一般規則(Warrant)として置く。攻撃されうる。 |
| `0x104L` | [COUNTER-DECLARE](toulmin/0x104L-counter-declare.md) | 反駁宣言。自らの結論を持って攻撃する。既定の Level は Fail |
| `0x105L` | [EXCEPT-DECLARE](toulmin/0x105L-except-declare.md) | 例外宣言。自らの結論を持たずに攻撃する。既定の Level は Review |
| `0x106L~0x107L` | Reserved |  |
| `0x108L` | [ATTACKS](toulmin/0x108L-attacks.md) | 攻撃関係。攻撃者の判定が対象の判定を漸進的に削る。 |
| `0x109L` | [SUPERSEDES](toulmin/0x109L-supersedes.md) | 除外関係。攻撃者が Active なら対象を集計から決定的に除く。 |
| `0x10AL` | [SUPERSEDE-CHAIN](toulmin/0x10AL-supersede-chain.md) | 優先順位の連鎖 `A > B > C`。対ごとの SUPERSEDES の短縮形。レイアウト未定 |
| `0x10BL~0x10FL` | Reserved |  |
| `0x110L` | [RUN](toulmin/0x110L-run.md) | 実行合成。ノードが Active なら下位事案を実行する(DAG)。 |
| `0x111L` | [DO](toulmin/0x111L-do.md) | ノードが Active のとき行う動作 |
| `0x112L` | [DO-ONCE](toulmin/0x112L-do-once.md) | 再試行しても一度だけ行う動作 |
| `0x113L` | [UNDO](toulmin/0x113L-undo.md) | DO の補償動作(saga)。後続の段階が失敗すると逆順に行う。 |
| `0x114L` | [CHECKING](toulmin/0x114L-checking.md) | 副作用なしに判定だけを行う接続 |
| `0x115L` | [ENTRY](toulmin/0x115L-entry.md) | 外部エントリポイント。事案を実行または判定する |
| `0x116L` | [TRIGGER](toulmin/0x116L-trigger.md) | 外部呼び出しのないイベント·周期のエントリポイント |
| `0x117L` | Reserved |  |
| `0x118L` | [VERDICT](toulmin/0x118L-verdict.md) | ノード·レコードの判定結果。結果(Pass, Review, Fail)、判定値、Activated、Excluded、Level。レイアウト未定。ドキュメント全体の判定は Meta [VERDICT](meta/0x1E9L-verdict.md)(`0x1E9L`) |
| `0x119L` | [EVIDENCE](toulmin/0x119L-evidence.md) | 判定の証拠。位置、期待値、実際の値 (Fact)。レイアウト未定 |
| `0x11AL~0x11BL` | Reserved |  |
| `0x11CL~0x11FL` | Reserved |  |

| TAG ID | まとまり |
|---|---|
| `0x100L~0x107L` | 宣言 |
| `0x108L~0x10FL` | 関係 |
| `0x110L~0x117L` | 実行 |
| `0x118L~0x11FL` | 結果 (`0x11CL~0x11FL` は Reserved) |

### TOULMIN 形式 (`0x120L~0x134L`) {#toulmin-형식-0x120l0x134l}

[TOULMIN](toulmin/_index.md) ドキュメントの原文·区画·補助ノードと関係だ。

| Codec | 名前 | 説明 |
|---|---|---|
| `0x120L` | [SOURCE](toulmin/0x120L-source.md) | 著作原文。SPAN 幅と UTF8 Value |
| `0x121L` | [TEXT](toulmin/0x121L-text.md) | 名前·文字列 |
| `0x122L` | [SECTION](toulmin/0x122L-section.md) | セクション開始。セクションコード |
| `0x123L` | [CASE-BEGIN](toulmin/0x123L-case-begin.md) | 事案範囲の開始 |
| `0x124L` | [CASE-END](toulmin/0x124L-case-end.md) | 事案範囲の終了 |
| `0x125L` | [PROSE](toulmin/0x125L-prose.md) | 叙述段落(SPAN) |
| `0x126L` | [NAMESPACE](toulmin/0x126L-namespace.md) | NODE。`this document is` |
| `0x127L` | [FUNC](toulmin/0x127L-func.md) | NODE。関数参照 |
| `0x128L` | [FIELD](toulmin/0x128L-field.md) | NODE。`is required` |
| `0x129L` | [ALIAS](toulmin/0x129L-alias.md) | NODE。`see … from` |
| `0x12AL` | [GROUP](toulmin/0x12AL-group.md) | NODE。順序のある実行のまとまり |
| `0x12BL` | [REQUIRES](toulmin/0x12BL-requires.md) | LINK。事案 → フィールド |
| `0x12CL` | [MEANS](toulmin/0x12CL-means.md) | LINK。定義項目 → 値·型 |
| `0x12DL` | [HAS](toulmin/0x12DL-has.md) | LINK。定義項目 → フィールド |
| `0x12EL` | [RUNS](toulmin/0x12EL-runs.md) | LINK。エントリポイント → 事案、実行 |
| `0x12FL` | [EVALUATES](toulmin/0x12FL-evaluates.md) | LINK。エントリポイント → 事案、判定 |
| `0x130L` | [TRIGGERS](toulmin/0x130L-triggers.md) | LINK。トリガー → 事案 |
| `0x131L` | [UNTIL](toulmin/0x131L-until.md) | LINK。トリガー → 事案(`every … until`) |
| `0x132L` | [SAME-AS](toulmin/0x132L-same-as.md) | LINK。ノード → グローバル識別子 |
| `0x133L` | [IMPORTED-FROM](toulmin/0x133L-imported-from.md) | LINK。エイリアス → パス(TEXT) |
| `0x134L` | [LABEL](toulmin/0x134L-label.md) | LINK。ノード → TEXT、名前表記 |

- `0x135L~0x1BCL` は Reserved だ。

### Edge ISSUER 形式 {#edge-issuer-형식}

`0x1BDL`~`0x1BFL`([EDGE-ISSUER-2WORD](edge/0x1BDL-edge-issuer-2word.md)、[-4WORD](edge/0x1BEL-edge-issuer-4word.md)、[-16WORD](edge/0x1BFL-edge-issuer-16word.md))の後ろの Codec 拡張 TAG に、Issuer と Codec 番号 2 WORD を置く。現在登録済みの Edge ISSUER 形式はない。

## Value {#value}

`0x060L~0x09FL` — [Value](value/_index.md)

Value 番号は系列を意味しない。直接コードは `0x060L~0x081L` に Reserved なしで置く。`0x082L~0x09CL` は Reserved で、`0x09DL~0x09FL` は VALUE-ISSUER だ。系列名(NUMERIC, DECIMAL, TIME, TEXT, BINARY)は主題のまとまりだ。偶数·奇数の対は偶数コードから始まる。

| 系列 | 直接コード |
|---|---|
| [NUMERIC](value/_index.md#numeric) | `0x060L~0x067L` |
| [DECIMAL](value/_index.md#decimal) | `0x068L~0x069L` |
| [TIME](value/_index.md#time) | `0x06AL~0x071L`, `0x081L` |
| [TEXT](value/_index.md#text) | `0x072L~0x07AL` |
| [BINARY](value/_index.md#binary) | `0x07BL~0x080L` |

### 直接コード {#직접-코드}

| Codec | 名前 | 系列 | 説明 |
|---|---|---|---|
| `0x060L` | [BOOL](value/0x060L-bool.md) | NUMERIC | 固定1 WORD の false または true |
| `0x061L` | [SIGNED-INTEGER](value/0x061L-signed-integer.md) | NUMERIC | 最小 WORD の2の補数による符号付き整数 |
| `0x062L` | [UNSIGNED-INTEGER](value/0x062L-unsigned-integer.md) | NUMERIC | 最小 WORD の big-endian unsigned magnitude 整数 |
| `0x063L` | [BINARY-FLOAT](value/0x063L-binary-float.md) | NUMERIC | Payload 1/2/4/8 WORD の IEEE 754 binary16/32/64/128 scalar |
| `0x064L` | [COORDINATE-EARTH](value/0x064L-coordinate-earth.md) | NUMERIC | 地球(WGS 84)の緯度·経度 binary64、不確かさ binary32 とその単位 Reference(ABSENT = 不明) |
| `0x065L` | [COORDINATE-GEO](value/0x065L-coordinate-geo.md) | NUMERIC | 天体 Reference と緯度·経度 binary64、不確かさ binary32 とその単位 Reference |
| `0x066L` | [QUANTITY](value/0x066L-quantity.md) | NUMERIC | 数値 Value amount(整数·BINARY-FLOAT·10進数·分数)、単位 Reference、下限·上限。単位·境界は省略可(ABSENT `0x0000`) |
| `0x067L` | [FRACTION](value/0x067L-fraction.md) | NUMERIC | 原文の表記を保存する分数: 整数·10進数の分子、符号なし整数·10進数の分母。約分しない |
| `0x068L` | [SIGNED-DECIMAL](value/0x068L-signed-decimal.md) | DECIMAL | signed exponent `E` と最小 WORD の2の補数 coefficient `C` による `C×10^E` |
| `0x069L` | [UNSIGNED-DECIMAL](value/0x069L-unsigned-decimal.md) | DECIMAL | signed exponent `E` と最小 WORD の unsigned coefficient `C` による `C×10^E` |
| `0x06AL` | [GREGORIAN-DATE](value/0x06AL-gregorian-date.md) | TIME | proleptic Gregorian `1970-01-01` 基準の signed 日数 |
| `0x06BL` | [CIVIL-TIME-NANOSECONDS](value/0x06BL-civil-time-nanoseconds.md) | TIME | 民事日の真夜中からの unsigned nanosecond 計数 |
| `0x06CL` | [POSIX-TIMESTAMP-SECONDS](value/0x06CL-posix-timestamp-seconds.md) | TIME | Unix/POSIX epoch からの signed 秒計数 |
| `0x06DL` | [DURATION-SECONDS](value/0x06DL-duration-seconds.md) | TIME | epoch のない signed SI-second の経過時間 |
| `0x06EL`/`0x06FL` | [EDTF](value/0x06EL-edtf.md) | TIME | EDTF(ISO 8601-2)日付文字列。偶数·奇数バイト。GREGORIAN-DATE で書ける日付には使わない |
| `0x070L`/`0x071L` | [GEDCOM-DATE](value/0x070L-gedcom-date.md) | TIME | GEDCOM 7 日付値の文字列。他の暦(ユリウス暦など)の原表記を保存する。偶数·奇数バイト |
| `0x072L` | [UTF8-TEXT-EVEN](value/0x072L-utf8-text.md) | TEXT | 正規化を暗示しない valid UTF-8 バイト列。偶数バイト |
| `0x073L` | [UTF8-TEXT-ODD](value/0x072L-utf8-text.md) | TEXT | 同上。奇数バイト |
| `0x074L` | [URI-EVEN](value/0x074L-uri.md) | TEXT | RFC 3986 `URI` production の ASCII バイト列。偶数バイト |
| `0x075L` | [URI-ODD](value/0x074L-uri.md) | TEXT | 同上。奇数バイト |
| `0x076L` | [LANGUAGE-BCP47-CODE-EVEN](value/0x076L-language-bcp47-code.md) | TEXT | canonical casing の完全な BCP 47 language tag の ASCII バイト列。偶数バイト |
| `0x077L` | [LANGUAGE-BCP47-CODE-ODD](value/0x076L-language-bcp47-code.md) | TEXT | 同上。奇数バイト |
| `0x078L`/`0x079L` | [UTF8-LANGUAGE-TEXT](value/0x078L-utf8-language-text.md) | TEXT | 言語付きテキスト。言語 Value レコード(LANGUAGE-SHORT-CODE または LANGUAGE-BCP47-CODE)と UTF-8 バイト。テキストバイトの偶数·奇数 |
| `0x07AL` | [LANGUAGE-SHORT-CODE](value/0x07AL-language-short-code.md) | TEXT | GEUL Language Registry 番号で書いた BCP 47 tag(Payload 1 WORD) |
| `0x07BL` | [UUID](value/0x07BL-uuid.md) | BINARY | 固定 Payload 8 WORD の RFC 9562 UUID 128bit |
| `0x07CL` | [SHA-256-DIGEST](value/0x07CL-sha-256-digest.md) | BINARY | 固定 Payload 16 WORD の SHA-256 結果 |
| `0x07DL` | [SHA1-DIGEST](value/0x07DL-sha1-digest.md) | BINARY | 固定 Payload 10 WORD の SHA-1 結果。git オブジェクト ID のような識別用途のみ |
| `0x07EL` | [OPAQUE-BYTES-EVEN](value/0x07EL-opaque-bytes.md) | BINARY | 意味·形式が不明のバイト列。偶数バイト |
| `0x07FL` | [OPAQUE-BYTES-ODD](value/0x07EL-opaque-bytes.md) | BINARY | 同上。奇数バイト |
| `0x080L` | [BIT-VECTOR](value/0x080L-bit-vector.md) | BINARY | bit-count の後に MSB-first で保存した N bit |
| `0x081L` | [DURATION-NANOSECONDS](value/0x081L-duration-nanoseconds.md) | TIME | epoch のない signed nanosecond の経過時間 |
| `0x09DL`~`0x09FL` | [VALUE-ISSUER-2WORD](value/0x09DL-value-issuer-2word.md), [-4WORD](value/0x09EL-value-issuer-4word.md), [-16WORD](value/0x09FL-value-issuer-16word.md) |  | Issuer が定義した形式。下の Value ISSUER 形式を参照 |

### Value ISSUER 形式 {#value-issuer-형식}

`0x09DL`~`0x09FL`([VALUE-ISSUER-2WORD](value/0x09DL-value-issuer-2word.md)、[-4WORD](value/0x09EL-value-issuer-4word.md)、[-16WORD](value/0x09FL-value-issuer-16word.md))の後ろの Codec 拡張 TAG に、Issuer と Codec 番号 2 WORD を置く。Codec ドキュメントはその Issuer の `codecs/` の下に、レコードの Codec 番号で置く。例: IETF CRC32C は `0x00000007/codecs/0x0000C000/`([公表アドレスとバージョン一覧](publishing.md))。

| Issuer | Codec 番号 | 名前 | 説明 |
|---|---|---|---|
| `0x00000002` ADHOC | `0x00000000` | BFLOAT16 | 固定 Payload 1 WORD の BF16 interchange bits |
| `0x00000002` ADHOC | `0x00000500` | [DENSE-I16-VECTOR](value/adhoc.geul.org/dense-i16-vector.md) | 連続する big-endian int16 vector |
| `0x00000002` ADHOC | `0x00000501` | [DENSE-U16-VECTOR](value/adhoc.geul.org/dense-u16-vector.md) | 連続する big-endian uint16 vector |
| `0x00000002` ADHOC | `0x00000502` | [DENSE-I32-VECTOR](value/adhoc.geul.org/dense-i32-vector.md) | 連続する big-endian int32 vector |
| `0x00000002` ADHOC | `0x00000503` | [DENSE-U32-VECTOR](value/adhoc.geul.org/dense-u32-vector.md) | 連続する big-endian uint32 vector |
| `0x00000002` ADHOC | `0x00000504` | [DENSE-I64-VECTOR](value/adhoc.geul.org/dense-i64-vector.md) | 連続する big-endian int64 vector |
| `0x00000002` ADHOC | `0x00000505` | [DENSE-U64-VECTOR](value/adhoc.geul.org/dense-u64-vector.md) | 連続する big-endian uint64 vector |
| `0x00000002` ADHOC | `0x00000506` | [DENSE-BINARY16-VECTOR](value/adhoc.geul.org/dense-binary16-vector.md) | 連続する IEEE 754 binary16 vector |
| `0x00000002` ADHOC | `0x00000507` | [DENSE-BFLOAT16-VECTOR](value/adhoc.geul.org/dense-bfloat16-vector.md) | 連続する BF16 vector |
| `0x00000002` ADHOC | `0x00000508` | [DENSE-BINARY32-VECTOR](value/adhoc.geul.org/dense-binary32-vector.md) | 連続する IEEE 754 binary32 vector |
| `0x00000002` ADHOC | `0x00000509` | [DENSE-BINARY64-VECTOR](value/adhoc.geul.org/dense-binary64-vector.md) | 連続する IEEE 754 binary64 vector |
| `0x00000002` ADHOC | `0x0000050A` | [POINT2-BINARY64](value/adhoc.geul.org/point2-binary64.md) | `(x,y)` の順の IEEE binary64 2次元 vector |
| `0x00000002` ADHOC | `0x0000050B` | [POINT3-BINARY64](value/adhoc.geul.org/point3-binary64.md) | `(x,y,z)` の順の IEEE binary64 3次元 vector |
| `0x00000002` ADHOC | `0x0000050C` | [BBOX2-BINARY64](value/adhoc.geul.org/bbox2-binary64.md) | `(minX,minY,maxX,maxY)` の順の IEEE binary64 vector |
| `0x00000002` ADHOC | `0x00000600` | [DESCRIBED-DENSE-TENSOR](value/adhoc.geul.org/described-dense-tensor.md) | element-format·rank·shape と C-contiguous dense payload |
| `0x00000002` ADHOC | `0x00000601` | [DESCRIBED-PACKED-TENSOR](value/adhoc.geul.org/described-packed-tensor.md) | packed-format·rank·shape と octet 内 low-bit-first packed payload |
| `0x00000002` ADHOC | `0x00000700` | [COMPLEX64](value/adhoc.geul.org/complex64.md) | `(real, imag)` の順の binary32 二つ |
| `0x00000002` ADHOC | `0x00000701` | [COMPLEX128](value/adhoc.geul.org/complex128.md) | `(real, imag)` の順の binary64 二つ |
| `0x00000002` ADHOC | `0x00000702` | [RATIONAL-I64](value/adhoc.geul.org/rational-i64.md) | 正規化した int64 numerator と正の int64 denominator |
| `0x00000002` ADHOC | `0x00000703` | [CLOSED-INTERVAL-BINARY64](value/adhoc.geul.org/closed-interval-binary64.md) | `lower ≤ upper` の binary64 閉区間 |
| `0x00000002` ADHOC | `0x00000704` | [QUATERNION-BINARY32](value/adhoc.geul.org/quaternion-binary32.md) | `(x,y,z,w)` の順の binary32 四つ |
| `0x00000002` ADHOC | `0x0000C000` | [BLAKE3-256-DIGEST](value/adhoc.geul.org/blake3-256-digest.md) | 固定 Payload 16 WORD の既定 BLAKE3 結果 |
| `0x00000007` IETF | `0x00008000` | [URI-RELATIVE-REF-EVEN](value/ietf.geul.org/uri-relative-ref.md) | RFC 3986 relative-ref の ASCII バイト列。偶数バイト |
| `0x00000007` IETF | `0x00008001` | [URI-RELATIVE-REF-ODD](value/ietf.geul.org/uri-relative-ref.md) | 同上。奇数バイト |
| `0x00000007` IETF | `0x0000C000` | [CRC32C](value/ietf.geul.org/crc32c.md) | 固定 Payload 2 WORD の Castagnoli CRC-32C 結果 |
| `0x00000007` IETF | `0x0000C001` | [IPV4-ADDRESS](value/ietf.geul.org/ipv4-address.md) | 固定 Payload 2 WORD の IPv4 アドレス 32bit |
| `0x00000007` IETF | `0x0000C002` | [IPV6-ADDRESS](value/ietf.geul.org/ipv6-address.md) | 固定 Payload 8 WORD の IPv6 アドレス 128bit |
| `0x0000000D` IEEE | `0x00002000` | [IEEE-DECIMAL32-DPD](value/ieee.geul.org/ieee-decimal32-dpd.md) | 固定 Payload 2 WORD の IEEE 754 decimal32 DPD |
| `0x0000000D` IEEE | `0x00002001` | [IEEE-DECIMAL64-DPD](value/ieee.geul.org/ieee-decimal64-dpd.md) | 固定 Payload 4 WORD の IEEE 754 decimal64 DPD |
| `0x0000000D` IEEE | `0x00002002` | [IEEE-DECIMAL128-DPD](value/ieee.geul.org/ieee-decimal128-dpd.md) | 固定 Payload 8 WORD の IEEE 754 decimal128 DPD |
| `0x0000000D` IEEE | `0x00002003` | [IEEE-DECIMAL32-BID](value/ieee.geul.org/ieee-decimal32-bid.md) | 固定 Payload 2 WORD の IEEE 754 decimal32 BID |
| `0x0000000D` IEEE | `0x00002004` | [IEEE-DECIMAL64-BID](value/ieee.geul.org/ieee-decimal64-bid.md) | 固定 Payload 4 WORD の IEEE 754 decimal64 BID |
| `0x0000000D` IEEE | `0x00002005` | [IEEE-DECIMAL128-BID](value/ieee.geul.org/ieee-decimal128-bid.md) | 固定 Payload 8 WORD の IEEE 754 decimal128 BID |
| `0x0000000D` IEEE | `0x00004000` | [POSIX-TIMESTAMP-NANOSECONDS](value/ieee.geul.org/posix-timestamp-nanoseconds.md) | Unix/POSIX epoch からの signed nanosecond 計数 |
| `0x0000000D` IEEE | `0x0000C000` | [MAC-48-ADDRESS](value/ieee.geul.org/mac-48-address.md) | 固定 Payload 3 WORD の IEEE 802 MAC アドレス 48bit |
| `0x0000000E` KHRONOS | `0x00000000` | [RGBA8-UNORM](value/khronos.geul.org/rgba8-unorm.md) | R, G, B, A の順の固定 4×UNORM8 packed vector |
| `0x0000000E` KHRONOS | `0x00000001` | [BGRA8-UNORM](value/khronos.geul.org/bgra8-unorm.md) | B, G, R, A の順の固定 4×UNORM8 packed vector |
| `0x00000010` ONNX | `0x00000000` | FP8-E4M3FN | Payload 上位 octet の ONNX E4M3FN scalar |
| `0x00000010` ONNX | `0x00000001` | FP8-E4M3FNUZ | Payload 上位 octet の ONNX E4M3FNUZ scalar |
| `0x00000010` ONNX | `0x00000002` | FP8-E5M2 | Payload 上位 octet の ONNX E5M2 scalar |
| `0x00000010` ONNX | `0x00000003` | FP8-E5M2FNUZ | Payload 上位 octet の ONNX E5M2FNUZ scalar |
| `0x00000011` OCP | `0x00000000` | FP8-E8M0FNU | Payload 上位 octet の unsigned exponent-only E8M0FNU scalar |
| `0x00000011` OCP | `0x00000001` | FP4-E2M1FN | Payload 上位 nibble の ONNX/DLPack E2M1FN scalar |
| `0x00000013` BIPM | `0x00004000` | [TAI-TIMESTAMP-SECONDS](value/bipm.geul.org/tai-timestamp-seconds.md) | `1970-01-01T00:00:00 TAI` からの signed SI-second 計数 |
| `0x00000013` BIPM | `0x00004001` | [TAI-TIMESTAMP-NANOSECONDS](value/bipm.geul.org/tai-timestamp-nanoseconds.md) | 同じ TAI epoch からの signed nanosecond 計数 |
| `0x00000015` NIST | `0x0000C000` | [SHA-512-DIGEST](value/nist.geul.org/sha-512-digest.md) | 固定 Payload 32 WORD の SHA-512 結果 |
| `0x00000015` NIST | `0x0000C001` | [SHA3-256-DIGEST](value/nist.geul.org/sha3-256-digest.md) | 固定 Payload 16 WORD の SHA3-256 結果 |
| `0x00000016` GPS | `0x00004000` | [GPS-TIMESTAMP-SECONDS](value/gps.geul.org/gps-timestamp-seconds.md) | GPS epoch からの signed second 計数 |
| `0x00000016` GPS | `0x00004001` | [GPS-TIMESTAMP-NANOSECONDS](value/gps.geul.org/gps-timestamp-nanoseconds.md) | GPS epoch からの signed nanosecond 計数 |

## Meta {#meta}

`0x1C0L~0x1FFL` — [Meta](meta/_index.md)

Meta 番号はビットでクラスを表さない。クラスは下の区間表でわかる。検証クラスはセクション15で `C >= 5`、すなわち `w >= 0x1E50` のレコードで、コードブックなしでわかる。Meta には ISSUER コードがない。

| クラス | 直接コード | 扱うもの |
|---|---|---|
| [構造](meta/_index.md#구조) | `0x1C0L~0x1C4L` | ドキュメントの境界と長さ |
| [定義](meta/_index.md#정의) | `0x1C5L~0x1CAL` | 解釈の宣言 |
| [出典](meta/_index.md#출처) | `0x1CBL~0x1D0L` | 誰が、いつ、どこで |
| [系譜](meta/_index.md#계보) | `0x1D1L~0x1DDL` | 何からどのように出たか |
| [ポリシー](meta/_index.md#정책) | `0x1DEL~0x1E3L` | どう扱うか |
| [IMPORT](meta/_index.md#import) | `0x1E4L` | 外部ドキュメントを IMPORT ID で取り込む (`IMPORT-DOC`) |
| [検証](meta/_index.md#검증) | `0x1E5L~0x1E9L` | 信頼できるか |
| Reserved(検証専用) | `0x1EAL~0x1FFL` |  |

- 番号は `0x1C0L` から Reserved なしで続く。検証以外の新しい Meta は検証の前に入れられない。後ろの Reserved `0x1EAL~0x1FFL` は検証専用だ。検証以外の Meta をここに置くと、コンテンツハッシュから外れる。

### 構造 (`0x1C0L~0x1C4L`) {#구조-0x1c0l0x1c4l}

| Codec | 名前 | 説明 |
|---|---|---|
| `0x1C0L` | [DOC-1WORD](meta/0x1C0L-doc-1word.md) | 全体の長さを Payload 1 WORD で指定したドキュメント開始 |
| `0x1C1L` | [DOC-2WORD](meta/0x1C1L-doc-2word.md) | 全体の長さを Payload 2 WORD で指定したドキュメント開始 |
| `0x1C2L` | [DOC-4WORD](meta/0x1C2L-doc-4word.md) | 全体の長さを Payload 4 WORD で指定したドキュメント開始 |
| `0x1C3L` | [BODY](meta/0x1C3L-body.md) | 1 WORD。ドキュメントの HEAD を終えて BODY を始める。 |
| `0x1C4L` | [END](meta/0x1C4L-end.md) | 1 WORD。ドキュメントを閉じる。 |

### 定義 (`0x1C5L~0x1CAL`) {#정의-0x1c5l0x1cal}

| Codec | 名前 | 説明 |
|---|---|---|
| `0x1C5L` | [SPEC-VERSION](meta/0x1C5L-spec-version.md) | 従う GEUL 仕様版。Payload がそのまま最も短い幅の unsigned 整数だ。v1 は `0x0001` (レコード `0x1C51 0x0001`) |
| `0x1C6L` | [PROFILE](meta/0x1C6L-profile.md) | 適用プロファイル |
| `0x1C7L` | [DOC-ID](meta/0x1C7L-doc-id.md) | このドキュメントの識別子。組み込み Reference `DOC-POINTER`(Issuer、ドキュメント ID、バージョン 0)。Codec ドキュメントは `CODEC-POINTER`(Issuer、Codec ID、バージョン 0) |
| `0x1C8L` | [EFFECTIVE-FROM](meta/0x1C8L-effective-from.md) | このバージョンの施行日。GREGORIAN-DATE または POSIX-TIMESTAMP Value。なければ公表時刻 |
| `0x1C9L` | [EFFECTIVE-UNTIL](meta/0x1C9L-effective-until.md) | このバージョンの有効期間の終わり(限時法)。なければ次のバージョンが施行されるまで |
| `0x1CAL` | [DEFAULT-LANGUAGE](meta/0x1CAL-default-language.md) | 既定の言語 |

### 出典 (`0x1CBL~0x1D0L`) {#출처-0x1cbl0x1d0l}

| Codec | 名前 | 説明 |
|---|---|---|
| `0x1CBL` | [AUTHOR](meta/0x1CBL-author.md) | 作成者。Reference (git author) |
| `0x1CCL` | [CO-AUTHOR](meta/0x1CCL-co-author.md) | 共同作成者。Reference (git `Co-authored-by`) |
| `0x1CDL` | [CREATED-AT](meta/0x1CDL-created-at.md) | 作成時刻。TIME Value (git author date) |
| `0x1CEL` | [MODIFIED-AT](meta/0x1CEL-modified-at.md) | 修正時刻。TIME Value |
| `0x1CFL` | [RECORDED-BY](meta/0x1CFL-recorded-by.md) | 記録した主体。Reference (git committer) |
| `0x1D0L` | [RECORDED-AT](meta/0x1D0L-recorded-at.md) | 記録した時刻。TIME Value (git commit date) |

- 原資料とその範囲·取得時刻·ハッシュは、Meta ではなく HEAD の根拠 Edge [SOURCE](edge/0x0C0L-source.md#문서-전체의-출처)(Target `0`)とその QUALIFIER で書く。

### 系譜 (`0x1D1L~0x1DDL`) {#계보-0x1d1l0x1ddl}

| Codec | 名前 | 説明 |
|---|---|---|
| `0x1D1L` | [PARENT](meta/0x1D1L-parent.md) | 直前バージョンのコンテンツハッシュ (git parent)。なければ最初のバージョンで、複数ならマージだ(git merge commit)。 |
| `0x1D2L` | [DERIVED-FROM](meta/0x1D2L-derived-from.md) | 他の系譜のレコード·資料から派生。外部資料の特定バージョンに固定するときは、HEAD の [SOURCE](edge/0x0C0L-source.md#문서-전체의-출처)に原文ハッシュ QUALIFIER(P4092)を付ける(git submodule)。 |
| `0x1D3L` | [GENERATED-BY](meta/0x1D3L-generated-by.md) | 生成主体。人、モデル、ルールエンジン |
| `0x1D4L` | [TRANSFORMED-BY](meta/0x1D4L-transformed-by.md) | 変換方法。ツール·ルール·バージョン |
| `0x1D5L` | [CHERRY-PICKED-FROM](meta/0x1D5L-cherry-picked-from.md) | 他の系譜の変更を取り込んだ元バージョンのコンテンツハッシュ (git cherry-pick `-x`) |
| `0x1D6L` | [REVERTS](meta/0x1D6L-reverts.md) | 変更を取り消した対象バージョンのコンテンツハッシュ (git revert) |
| `0x1D7L` | [REPLACES](meta/0x1D7L-replaces.md) | 書き直した対象バージョンのコンテンツハッシュ (git amend·rebase)。元のバージョンは消さない。 |
| `0x1D8L` | [SQUASHED-FROM](meta/0x1D8L-squashed-from.md) | 一つにまとめた元バージョンたちのコンテンツハッシュ (git squash) |
| `0x1D9L` | [MESSAGE](meta/0x1D9L-message.md) | 変更の理由。UTF8-LANGUAGE-TEXT Value、言語ごとに一つ (git commit message) |
| `0x1DAL` | [TAG](meta/0x1DAL-tag.md) | バージョンに付けた不変の名前。TEXT Value とコンテンツハッシュ (git annotated tag) |
| `0x1DBL` | [DELTA-BASE](meta/0x1DBL-delta-base.md) | このバージョンのファイルは、同じドキュメントの基準バージョン(2 WORD バージョン ID)に対する diff だ (git packfile delta) |
| `0x1DCL` | [DELTA-REMOVE](meta/0x1DCL-delta-remove.md) | diff で基準 BODY から除く LOCAL ID(Edge Id)の一覧 |
| `0x1DDL` | [NEXT-LOCAL-ID](meta/0x1DDL-next-local-id.md) | 次に割り当てる LOCAL ID (auto increment)。バージョン一覧 `versions.geul` の HEAD に置く |

### ポリシー (`0x1DEL~0x1E3L`) {#정책-0x1del0x1e3l}

| Codec | 名前 | 説明 |
|---|---|---|
| `0x1DEL` | [LICENSE](meta/0x1DEL-license.md) | ライセンス。Reference |
| `0x1DFL` | [ACCESS](meta/0x1DFL-access.md) | 公開範囲 |
| `0x1E0L` | [PRIVACY](meta/0x1E0L-privacy.md) | 個人情報の等級 |
| `0x1E1L` | [RETENTION](meta/0x1E1L-retention.md) | 保存期限 |
| `0x1E2L` | [CONSENT](meta/0x1E2L-consent.md) | 同意の範囲と根拠 |
| `0x1E3L` | [USAGE](meta/0x1E3L-usage.md) | 使用制限 |

### IMPORT (`0x1E4L`) {#import-0x1e4l}

| Codec | 名前 | 説明 |
|---|---|---|
| `0x1E4L` | [IMPORT-DOC](meta/0x1E4L-import-doc.md) | 外部ドキュメントを IMPORT ID で取り込む。組み込み Reference `DOC-POINTER`(Codec ドキュメントは `CODEC-POINTER`) + IMPORT ID |

### 検証 (`0x1E5L~0x1E9L`) {#검증-0x1e5l0x1e9l}

| Codec | 名前 | 説明 |
|---|---|---|
| `0x1E5L` | [ISSUER-KEY](meta/0x1E5L-issuer-key.md) | 自己発行 Issuer の署名アルゴリズム ID と公開鍵の宣言 |
| `0x1E6L` | [SIGNATURE](meta/0x1E6L-signature.md) | 対象に対する署名。ドキュメントに対する署名はコンテンツハッシュに署名する (git 署名コミット·タグ) |
| `0x1E7L` | [SIGNED-OFF](meta/0x1E7L-signed-off.md) | 貢献権利の確認。Reference (git `Signed-off-by`, DCO) |
| `0x1E8L` | [CONFIDENCE](meta/0x1E8L-confidence.md) | 信頼度 |
| `0x1E9L` | [VERDICT](meta/0x1E9L-verdict.md) | ドキュメント全体の判定結果。Pass, Review, Fail。ノード·レコード単位は [TOULMIN](toulmin/_index.md) `VERDICT`(Edge `0x118L`) |

## 全体割り当て表 {#전체-배정표}

割り当て227マス、md 176個。5Q 体系と偶奇の対は構成要素ごとに一行で、md はまとまりの先頭 md だ。

| TAG ID | Codec ID | 名前 | Kind | セクション | md | まとまり |
|---|---|---|---|---|---|---|
| `0x000L` | `0x00000000` | ABSENT | Reference | 0 | [0x000L-absent.md](reference/0x000L-absent.md) |  |
| `0x001L` | `0x00000010` | UNKNOWN-VALUE | Reference | 0 | [0x001L-unknown-value.md](reference/0x001L-unknown-value.md) |  |
| `0x002L` | `0x00000020` | NO-VALUE | Reference | 0 | [0x002L-no-value.md](reference/0x002L-no-value.md) |  |
| `0x005L` | `0x00000050` | LOCAL-IDENTIFIED | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x006L` | `0x00000060` | LOCAL-GENERIC | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x007L` | `0x00000070` | LOCAL-FREE-CHOICE | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x008L` | `0x00000080` | LOCAL-UNIVERSAL | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x009L` | `0x00000090` | LOCAL-VARIABLE | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x00AL` | `0x000000A0` | GEUL-IDENTIFIED | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00BL` | `0x000000B0` | GEUL-GENERIC | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00CL` | `0x000000C0` | GEUL-FREE-CHOICE | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00DL` | `0x000000D0` | GEUL-UNIVERSAL | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00EL` | `0x000000E0` | GEUL-VARIABLE | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00FL` | `0x000000F0` | GEUL-SIDX-IDENTIFIED | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x010L` | `0x00000100` | GEUL-SIDX-GENERIC | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x011L` | `0x00000110` | GEUL-SIDX-FREE-CHOICE | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x012L` | `0x00000120` | GEUL-SIDX-UNIVERSAL | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x013L` | `0x00000130` | GEUL-SIDX-VARIABLE | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x014L` | `0x00000140` | WIKIDATA-QID-IDENTIFIED | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x015L` | `0x00000150` | WIKIDATA-QID-GENERIC | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x016L` | `0x00000160` | WIKIDATA-QID-FREE-CHOICE | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x017L` | `0x00000170` | WIKIDATA-QID-UNIVERSAL | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x018L` | `0x00000180` | WIKIDATA-QID-VARIABLE | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x019L` | `0x00000190` | WIKIDATA-PID-IDENTIFIED | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x01AL` | `0x000001A0` | WIKIDATA-PID-GENERIC | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x01BL` | `0x000001B0` | WIKIDATA-PID-FREE-CHOICE | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x01CL` | `0x000001C0` | WIKIDATA-PID-UNIVERSAL | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x01DL` | `0x000001D0` | WIKIDATA-PID-VARIABLE | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x020L` | `0x00000200` | EXTERNAL-POINTER-1WORD-IDENTIFIED | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x021L` | `0x00000210` | EXTERNAL-POINTER-1WORD-GENERIC | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x022L` | `0x00000220` | EXTERNAL-POINTER-1WORD-FREE-CHOICE | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x023L` | `0x00000230` | EXTERNAL-POINTER-1WORD-UNIVERSAL | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x024L` | `0x00000240` | EXTERNAL-POINTER-1WORD-VARIABLE | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x025L` | `0x00000250` | EXTERNAL-POINTER-2WORD-IDENTIFIED | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x026L` | `0x00000260` | EXTERNAL-POINTER-2WORD-GENERIC | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x027L` | `0x00000270` | EXTERNAL-POINTER-2WORD-FREE-CHOICE | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x028L` | `0x00000280` | EXTERNAL-POINTER-2WORD-UNIVERSAL | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x029L` | `0x00000290` | EXTERNAL-POINTER-2WORD-VARIABLE | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x02AL` | `0x000002A0` | EXTERNAL-POINTER-4WORD-IDENTIFIED | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02BL` | `0x000002B0` | EXTERNAL-POINTER-4WORD-GENERIC | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02CL` | `0x000002C0` | EXTERNAL-POINTER-4WORD-FREE-CHOICE | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02DL` | `0x000002D0` | EXTERNAL-POINTER-4WORD-UNIVERSAL | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02EL` | `0x000002E0` | EXTERNAL-POINTER-4WORD-VARIABLE | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02FL` | `0x000002F0` | EXTERNAL-ISSUER-2WORD-IDENTIFIED | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x030L` | `0x00000300` | EXTERNAL-ISSUER-2WORD-GENERIC | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x031L` | `0x00000310` | EXTERNAL-ISSUER-2WORD-FREE-CHOICE | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x032L` | `0x00000320` | EXTERNAL-ISSUER-2WORD-UNIVERSAL | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x033L` | `0x00000330` | EXTERNAL-ISSUER-2WORD-VARIABLE | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x034L` | `0x00000340` | EXTERNAL-ISSUER-4WORD-IDENTIFIED | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x035L` | `0x00000350` | EXTERNAL-ISSUER-4WORD-GENERIC | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x036L` | `0x00000360` | EXTERNAL-ISSUER-4WORD-FREE-CHOICE | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x037L` | `0x00000370` | EXTERNAL-ISSUER-4WORD-UNIVERSAL | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x038L` | `0x00000380` | EXTERNAL-ISSUER-4WORD-VARIABLE | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x039L` | `0x00000390` | EXTERNAL-ISSUER-16WORD-IDENTIFIED | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x03AL` | `0x000003A0` | EXTERNAL-ISSUER-16WORD-GENERIC | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x03BL` | `0x000003B0` | EXTERNAL-ISSUER-16WORD-FREE-CHOICE | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x03CL` | `0x000003C0` | EXTERNAL-ISSUER-16WORD-UNIVERSAL | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x03DL` | `0x000003D0` | EXTERNAL-ISSUER-16WORD-VARIABLE | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x040L` | `0x00000400` | ISSUER-POINTER | Reference | 2 | [0x040L-issuer-pointer.md](reference/0x040L-issuer-pointer.md) |  |
| `0x041L` | `0x00000410` | DOC-POINTER | Reference | 2 | [0x041L-doc-pointer.md](reference/0x041L-doc-pointer.md) |  |
| `0x042L` | `0x00000420` | CODEC-POINTER | Reference | 2 | [0x042L-codec-pointer.md](reference/0x042L-codec-pointer.md) |  |
| `0x043L` | `0x00000430` | TOKEN-0 | Reference | 2 | [0x043L-token.md](reference/0x043L-token.md) | ペア `TOKEN-0`·`TOKEN-1` |
| `0x044L` | `0x00000440` | TOKEN-1 | Reference | 2 | [0x043L-token.md](reference/0x043L-token.md) | ペア `TOKEN-0`·`TOKEN-1` |
| `0x05DL` | `0x000005D0` | REFERENCE-ISSUER-2WORD | Reference | 2 | [0x05DL-reference-issuer-2word.md](reference/0x05DL-reference-issuer-2word.md) |  |
| `0x05EL` | `0x000005E0` | REFERENCE-ISSUER-4WORD | Reference | 2 | [0x05EL-reference-issuer-4word.md](reference/0x05EL-reference-issuer-4word.md) |  |
| `0x05FL` | `0x000005F0` | REFERENCE-ISSUER-16WORD | Reference | 2 | [0x05FL-reference-issuer-16word.md](reference/0x05FL-reference-issuer-16word.md) |  |
| `0x060L` | `0x00000600` | BOOL | Value | 3 | [0x060L-bool.md](value/0x060L-bool.md) |  |
| `0x061L` | `0x00000610` | SIGNED-INTEGER | Value | 3 | [0x061L-signed-integer.md](value/0x061L-signed-integer.md) |  |
| `0x062L` | `0x00000620` | UNSIGNED-INTEGER | Value | 3 | [0x062L-unsigned-integer.md](value/0x062L-unsigned-integer.md) |  |
| `0x063L` | `0x00000630` | BINARY-FLOAT | Value | 3 | [0x063L-binary-float.md](value/0x063L-binary-float.md) |  |
| `0x064L` | `0x00000640` | COORDINATE-EARTH | Value | 3 | [0x064L-coordinate-earth.md](value/0x064L-coordinate-earth.md) |  |
| `0x065L` | `0x00000650` | COORDINATE-GEO | Value | 3 | [0x065L-coordinate-geo.md](value/0x065L-coordinate-geo.md) |  |
| `0x066L` | `0x00000660` | QUANTITY | Value | 3 | [0x066L-quantity.md](value/0x066L-quantity.md) |  |
| `0x067L` | `0x00000670` | FRACTION | Value | 3 | [0x067L-fraction.md](value/0x067L-fraction.md) |  |
| `0x068L` | `0x00000680` | SIGNED-DECIMAL | Value | 3 | [0x068L-signed-decimal.md](value/0x068L-signed-decimal.md) |  |
| `0x069L` | `0x00000690` | UNSIGNED-DECIMAL | Value | 3 | [0x069L-unsigned-decimal.md](value/0x069L-unsigned-decimal.md) |  |
| `0x06AL` | `0x000006A0` | GREGORIAN-DATE | Value | 3 | [0x06AL-gregorian-date.md](value/0x06AL-gregorian-date.md) |  |
| `0x06BL` | `0x000006B0` | CIVIL-TIME-NANOSECONDS | Value | 3 | [0x06BL-civil-time-nanoseconds.md](value/0x06BL-civil-time-nanoseconds.md) |  |
| `0x06CL` | `0x000006C0` | POSIX-TIMESTAMP-SECONDS | Value | 3 | [0x06CL-posix-timestamp-seconds.md](value/0x06CL-posix-timestamp-seconds.md) |  |
| `0x06DL` | `0x000006D0` | DURATION-SECONDS | Value | 3 | [0x06DL-duration-seconds.md](value/0x06DL-duration-seconds.md) |  |
| `0x06EL` | `0x000006E0` | EDTF-EVEN | Value | 3 | [0x06EL-edtf.md](value/0x06EL-edtf.md) | 偶奇 `EDTF` |
| `0x06FL` | `0x000006F0` | EDTF-ODD | Value | 3 | [0x06EL-edtf.md](value/0x06EL-edtf.md) | 偶奇 `EDTF` |
| `0x070L` | `0x00000700` | GEDCOM-DATE-EVEN | Value | 3 | [0x070L-gedcom-date.md](value/0x070L-gedcom-date.md) | 偶奇 `GEDCOM-DATE` |
| `0x071L` | `0x00000710` | GEDCOM-DATE-ODD | Value | 3 | [0x070L-gedcom-date.md](value/0x070L-gedcom-date.md) | 偶奇 `GEDCOM-DATE` |
| `0x072L` | `0x00000720` | UTF8-TEXT-EVEN | Value | 3 | [0x072L-utf8-text.md](value/0x072L-utf8-text.md) | 偶奇 `UTF8-TEXT` |
| `0x073L` | `0x00000730` | UTF8-TEXT-ODD | Value | 3 | [0x072L-utf8-text.md](value/0x072L-utf8-text.md) | 偶奇 `UTF8-TEXT` |
| `0x074L` | `0x00000740` | URI-EVEN | Value | 3 | [0x074L-uri.md](value/0x074L-uri.md) | 偶奇 `URI` |
| `0x075L` | `0x00000750` | URI-ODD | Value | 3 | [0x074L-uri.md](value/0x074L-uri.md) | 偶奇 `URI` |
| `0x076L` | `0x00000760` | LANGUAGE-BCP47-CODE-EVEN | Value | 3 | [0x076L-language-bcp47-code.md](value/0x076L-language-bcp47-code.md) | 偶奇 `LANGUAGE-BCP47-CODE` |
| `0x077L` | `0x00000770` | LANGUAGE-BCP47-CODE-ODD | Value | 3 | [0x076L-language-bcp47-code.md](value/0x076L-language-bcp47-code.md) | 偶奇 `LANGUAGE-BCP47-CODE` |
| `0x078L` | `0x00000780` | UTF8-LANGUAGE-TEXT-EVEN | Value | 3 | [0x078L-utf8-language-text.md](value/0x078L-utf8-language-text.md) | 偶奇 `UTF8-LANGUAGE-TEXT` |
| `0x079L` | `0x00000790` | UTF8-LANGUAGE-TEXT-ODD | Value | 3 | [0x078L-utf8-language-text.md](value/0x078L-utf8-language-text.md) | 偶奇 `UTF8-LANGUAGE-TEXT` |
| `0x07AL` | `0x000007A0` | LANGUAGE-SHORT-CODE | Value | 3 | [0x07AL-language-short-code.md](value/0x07AL-language-short-code.md) |  |
| `0x07BL` | `0x000007B0` | UUID | Value | 3 | [0x07BL-uuid.md](value/0x07BL-uuid.md) |  |
| `0x07CL` | `0x000007C0` | SHA-256-DIGEST | Value | 3 | [0x07CL-sha-256-digest.md](value/0x07CL-sha-256-digest.md) |  |
| `0x07DL` | `0x000007D0` | SHA1-DIGEST | Value | 3 | [0x07DL-sha1-digest.md](value/0x07DL-sha1-digest.md) |  |
| `0x07EL` | `0x000007E0` | OPAQUE-BYTES-EVEN | Value | 3 | [0x07EL-opaque-bytes.md](value/0x07EL-opaque-bytes.md) | 偶奇 `OPAQUE-BYTES` |
| `0x07FL` | `0x000007F0` | OPAQUE-BYTES-ODD | Value | 3 | [0x07EL-opaque-bytes.md](value/0x07EL-opaque-bytes.md) | 偶奇 `OPAQUE-BYTES` |
| `0x080L` | `0x00000800` | BIT-VECTOR | Value | 4 | [0x080L-bit-vector.md](value/0x080L-bit-vector.md) |  |
| `0x081L` | `0x00000810` | DURATION-NANOSECONDS | Value | 4 | [0x081L-duration-nanoseconds.md](value/0x081L-duration-nanoseconds.md) |  |
| `0x09DL` | `0x000009D0` | VALUE-ISSUER-2WORD | Value | 4 | [0x09DL-value-issuer-2word.md](value/0x09DL-value-issuer-2word.md) |  |
| `0x09EL` | `0x000009E0` | VALUE-ISSUER-4WORD | Value | 4 | [0x09EL-value-issuer-4word.md](value/0x09EL-value-issuer-4word.md) |  |
| `0x09FL` | `0x000009F0` | VALUE-ISSUER-16WORD | Value | 4 | [0x09FL-value-issuer-16word.md](value/0x09FL-value-issuer-16word.md) |  |
| `0x0A0L` | `0x00000A00` | REFERENCE-NODE | Edge | 5 | [0x0A0L-reference-node.md](edge/0x0A0L-reference-node.md) |  |
| `0x0A1L` | `0x00000A10` | SAME-NODE | Edge | 5 | [0x0A1L-same-node.md](edge/0x0A1L-same-node.md) |  |
| `0x0A2L` | `0x00000A20` | DIFFERENT-NODE | Edge | 5 | [0x0A2L-different-node.md](edge/0x0A2L-different-node.md) |  |
| `0x0A3L` | `0x00000A30` | BIND | Edge | 5 | [0x0A3L-bind.md](edge/0x0A3L-bind.md) |  |
| `0x0A4L` | `0x00000A40` | LABEL | Edge | 5 | [0x0A4L-label.md](edge/0x0A4L-label.md) |  |
| `0x0A5L` | `0x00000A50` | ALIAS | Edge | 5 | [0x0A5L-alias.md](edge/0x0A5L-alias.md) |  |
| `0x0A6L` | `0x00000A60` | DESCRIPTION | Edge | 5 | [0x0A6L-description.md](edge/0x0A6L-description.md) |  |
| `0x0A8L` | `0x00000A80` | VERB-SHORT | Edge | 5 | [0x0A8L-verb-short.md](edge/0x0A8L-verb-short.md) |  |
| `0x0A9L` | `0x00000A90` | VERB | Edge | 5 | [0x0A9L-verb.md](edge/0x0A9L-verb.md) |  |
| `0x0AAL` | `0x00000AA0` | TRIPLE | Edge | 5 | [0x0AAL-triple.md](edge/0x0AAL-triple.md) |  |
| `0x0ABL` | `0x00000AB0` | QUALIFIER | Edge | 5 | [0x0ABL-qualifier.md](edge/0x0ABL-qualifier.md) |  |
| `0x0B0L` | `0x00000B00` | WORLD | Edge | 5 | [0x0B0L-world.md](edge/0x0B0L-world.md) |  |
| `0x0B1L` | `0x00000B10` | TIMELINE | Edge | 5 | [0x0B1L-timeline.md](edge/0x0B1L-timeline.md) |  |
| `0x0B2L` | `0x00000B20` | SCENE | Edge | 5 | [0x0B2L-scene.md](edge/0x0B2L-scene.md) |  |
| `0x0B8L` | `0x00000B80` | PUBLICATION | Edge | 5 | [0x0B8L-publication.md](edge/0x0B8L-publication.md) |  |
| `0x0B9L` | `0x00000B90` | DEPRECATION | Edge | 5 | [0x0B9L-deprecation.md](edge/0x0B9L-deprecation.md) |  |
| `0x0BAL` | `0x00000BA0` | TOMBSTONE | Edge | 5 | [0x0BAL-tombstone.md](edge/0x0BAL-tombstone.md) |  |
| `0x0BBL` | `0x00000BB0` | DECLARE | Edge | 5 | [0x0BBL-declare.md](edge/0x0BBL-declare.md) |  |
| `0x0BCL` | `0x00000BC0` | FIELD | Edge | 5 | [0x0BCL-field.md](edge/0x0BCL-field.md) |  |
| `0x0BDL` | `0x00000BD0` | ENUM | Edge | 5 | [0x0BDL-enum.md](edge/0x0BDL-enum.md) |  |
| `0x0BEL` | `0x00000BE0` | CODEC | Edge | 5 | [0x0BEL-codec.md](edge/0x0BEL-codec.md) |  |
| `0x0C0L` | `0x00000C00` | SOURCE | Edge | 6 | [0x0C0L-source.md](edge/0x0C0L-source.md) |  |
| `0x0E1L` | `0x00000E10` | FUNCTION-DECLARE | Edge | 7 | [0x0E1L-function-declare.md](edge/0x0E1L-function-declare.md) |  |
| `0x0E2L` | `0x00000E20` | TYPE-DECLARE | Edge | 7 | [0x0E2L-type-declare.md](edge/0x0E2L-type-declare.md) |  |
| `0x0E8L` | `0x00000E80` | CONST | Edge | 7 | [0x0E8L-const.md](edge/0x0E8L-const.md) |  |
| `0x0E9L` | `0x00000E90` | UNARY | Edge | 7 | [0x0E9L-unary.md](edge/0x0E9L-unary.md) |  |
| `0x0EAL` | `0x00000EA0` | BINARY | Edge | 7 | [0x0EAL-binary.md](edge/0x0EAL-binary.md) |  |
| `0x0EBL` | `0x00000EB0` | CALL | Edge | 7 | [0x0EBL-call.md](edge/0x0EBL-call.md) |  |
| `0x0ECL` | `0x00000EC0` | MEMBER | Edge | 7 | [0x0ECL-member.md](edge/0x0ECL-member.md) |  |
| `0x0EDL` | `0x00000ED0` | INDEX | Edge | 7 | [0x0EDL-index.md](edge/0x0EDL-index.md) |  |
| `0x0EEL` | `0x00000EE0` | CONSTRUCT | Edge | 7 | [0x0EEL-construct.md](edge/0x0EEL-construct.md) |  |
| `0x0EFL` | `0x00000EF0` | CONDITIONAL | Edge | 7 | [0x0EFL-conditional.md](edge/0x0EFL-conditional.md) |  |
| `0x0F0L` | `0x00000F00` | BLOCK | Edge | 7 | [0x0F0L-block.md](edge/0x0F0L-block.md) |  |
| `0x0F1L` | `0x00000F10` | ASSIGN | Edge | 7 | [0x0F1L-assign.md](edge/0x0F1L-assign.md) |  |
| `0x0F2L` | `0x00000F20` | IF | Edge | 7 | [0x0F2L-if.md](edge/0x0F2L-if.md) |  |
| `0x0F3L` | `0x00000F30` | SWITCH | Edge | 7 | [0x0F3L-switch.md](edge/0x0F3L-switch.md) |  |
| `0x0F4L` | `0x00000F40` | WHILE | Edge | 7 | [0x0F4L-while.md](edge/0x0F4L-while.md) |  |
| `0x0F5L` | `0x00000F50` | FOREACH | Edge | 7 | [0x0F5L-foreach.md](edge/0x0F5L-foreach.md) |  |
| `0x0F6L` | `0x00000F60` | JUMP | Edge | 7 | [0x0F6L-jump.md](edge/0x0F6L-jump.md) |  |
| `0x0F7L` | `0x00000F70` | RETURN | Edge | 7 | [0x0F7L-return.md](edge/0x0F7L-return.md) |  |
| `0x0F8L` | `0x00000F80` | RAISE | Edge | 7 | [0x0F8L-raise.md](edge/0x0F8L-raise.md) |  |
| `0x0F9L` | `0x00000F90` | TRY | Edge | 7 | [0x0F9L-try.md](edge/0x0F9L-try.md) |  |
| `0x100L` | `0x00001000` | CASE-DECLARE | Edge | 8 | [0x100L-case-declare.md](toulmin/0x100L-case-declare.md) |  |
| `0x101L` | `0x00001010` | PREDICATE-DECLARE | Edge | 8 | [0x101L-predicate-declare.md](toulmin/0x101L-predicate-declare.md) |  |
| `0x102L` | `0x00001020` | SPEC-DECLARE | Edge | 8 | [0x102L-spec-declare.md](toulmin/0x102L-spec-declare.md) |  |
| `0x103L` | `0x00001030` | RULE-DECLARE | Edge | 8 | [0x103L-rule-declare.md](toulmin/0x103L-rule-declare.md) |  |
| `0x104L` | `0x00001040` | COUNTER-DECLARE | Edge | 8 | [0x104L-counter-declare.md](toulmin/0x104L-counter-declare.md) |  |
| `0x105L` | `0x00001050` | EXCEPT-DECLARE | Edge | 8 | [0x105L-except-declare.md](toulmin/0x105L-except-declare.md) |  |
| `0x108L` | `0x00001080` | ATTACKS | Edge | 8 | [0x108L-attacks.md](toulmin/0x108L-attacks.md) |  |
| `0x109L` | `0x00001090` | SUPERSEDES | Edge | 8 | [0x109L-supersedes.md](toulmin/0x109L-supersedes.md) |  |
| `0x10AL` | `0x000010A0` | SUPERSEDE-CHAIN | Edge | 8 | [0x10AL-supersede-chain.md](toulmin/0x10AL-supersede-chain.md) |  |
| `0x110L` | `0x00001100` | RUN | Edge | 8 | [0x110L-run.md](toulmin/0x110L-run.md) |  |
| `0x111L` | `0x00001110` | DO | Edge | 8 | [0x111L-do.md](toulmin/0x111L-do.md) |  |
| `0x112L` | `0x00001120` | DO-ONCE | Edge | 8 | [0x112L-do-once.md](toulmin/0x112L-do-once.md) |  |
| `0x113L` | `0x00001130` | UNDO | Edge | 8 | [0x113L-undo.md](toulmin/0x113L-undo.md) |  |
| `0x114L` | `0x00001140` | CHECKING | Edge | 8 | [0x114L-checking.md](toulmin/0x114L-checking.md) |  |
| `0x115L` | `0x00001150` | ENTRY | Edge | 8 | [0x115L-entry.md](toulmin/0x115L-entry.md) |  |
| `0x116L` | `0x00001160` | TRIGGER | Edge | 8 | [0x116L-trigger.md](toulmin/0x116L-trigger.md) |  |
| `0x118L` | `0x00001180` | VERDICT | Edge | 8 | [0x118L-verdict.md](toulmin/0x118L-verdict.md) |  |
| `0x119L` | `0x00001190` | EVIDENCE | Edge | 8 | [0x119L-evidence.md](toulmin/0x119L-evidence.md) |  |
| `0x120L` | `0x00001200` | SOURCE | Edge | 9 | [0x120L-source.md](toulmin/0x120L-source.md) |  |
| `0x121L` | `0x00001210` | TEXT | Edge | 9 | [0x121L-text.md](toulmin/0x121L-text.md) |  |
| `0x122L` | `0x00001220` | SECTION | Edge | 9 | [0x122L-section.md](toulmin/0x122L-section.md) |  |
| `0x123L` | `0x00001230` | CASE-BEGIN | Edge | 9 | [0x123L-case-begin.md](toulmin/0x123L-case-begin.md) |  |
| `0x124L` | `0x00001240` | CASE-END | Edge | 9 | [0x124L-case-end.md](toulmin/0x124L-case-end.md) |  |
| `0x125L` | `0x00001250` | PROSE | Edge | 9 | [0x125L-prose.md](toulmin/0x125L-prose.md) |  |
| `0x126L` | `0x00001260` | NAMESPACE | Edge | 9 | [0x126L-namespace.md](toulmin/0x126L-namespace.md) |  |
| `0x127L` | `0x00001270` | FUNC | Edge | 9 | [0x127L-func.md](toulmin/0x127L-func.md) |  |
| `0x128L` | `0x00001280` | FIELD | Edge | 9 | [0x128L-field.md](toulmin/0x128L-field.md) |  |
| `0x129L` | `0x00001290` | ALIAS | Edge | 9 | [0x129L-alias.md](toulmin/0x129L-alias.md) |  |
| `0x12AL` | `0x000012A0` | GROUP | Edge | 9 | [0x12AL-group.md](toulmin/0x12AL-group.md) |  |
| `0x12BL` | `0x000012B0` | REQUIRES | Edge | 9 | [0x12BL-requires.md](toulmin/0x12BL-requires.md) |  |
| `0x12CL` | `0x000012C0` | MEANS | Edge | 9 | [0x12CL-means.md](toulmin/0x12CL-means.md) |  |
| `0x12DL` | `0x000012D0` | HAS | Edge | 9 | [0x12DL-has.md](toulmin/0x12DL-has.md) |  |
| `0x12EL` | `0x000012E0` | RUNS | Edge | 9 | [0x12EL-runs.md](toulmin/0x12EL-runs.md) |  |
| `0x12FL` | `0x000012F0` | EVALUATES | Edge | 9 | [0x12FL-evaluates.md](toulmin/0x12FL-evaluates.md) |  |
| `0x130L` | `0x00001300` | TRIGGERS | Edge | 9 | [0x130L-triggers.md](toulmin/0x130L-triggers.md) |  |
| `0x131L` | `0x00001310` | UNTIL | Edge | 9 | [0x131L-until.md](toulmin/0x131L-until.md) |  |
| `0x132L` | `0x00001320` | SAME-AS | Edge | 9 | [0x132L-same-as.md](toulmin/0x132L-same-as.md) |  |
| `0x133L` | `0x00001330` | IMPORTED-FROM | Edge | 9 | [0x133L-imported-from.md](toulmin/0x133L-imported-from.md) |  |
| `0x134L` | `0x00001340` | LABEL | Edge | 9 | [0x134L-label.md](toulmin/0x134L-label.md) |  |
| `0x1BDL` | `0x00001BD0` | EDGE-ISSUER-2WORD | Edge | 13 | [0x1BDL-edge-issuer-2word.md](edge/0x1BDL-edge-issuer-2word.md) |  |
| `0x1BEL` | `0x00001BE0` | EDGE-ISSUER-4WORD | Edge | 13 | [0x1BEL-edge-issuer-4word.md](edge/0x1BEL-edge-issuer-4word.md) |  |
| `0x1BFL` | `0x00001BF0` | EDGE-ISSUER-16WORD | Edge | 13 | [0x1BFL-edge-issuer-16word.md](edge/0x1BFL-edge-issuer-16word.md) |  |
| `0x1C0L` | `0x00001C00` | DOC-1WORD | Meta | 14 | [0x1C0L-doc-1word.md](meta/0x1C0L-doc-1word.md) |  |
| `0x1C1L` | `0x00001C10` | DOC-2WORD | Meta | 14 | [0x1C1L-doc-2word.md](meta/0x1C1L-doc-2word.md) |  |
| `0x1C2L` | `0x00001C20` | DOC-4WORD | Meta | 14 | [0x1C2L-doc-4word.md](meta/0x1C2L-doc-4word.md) |  |
| `0x1C3L` | `0x00001C30` | BODY | Meta | 14 | [0x1C3L-body.md](meta/0x1C3L-body.md) |  |
| `0x1C4L` | `0x00001C40` | END | Meta | 14 | [0x1C4L-end.md](meta/0x1C4L-end.md) |  |
| `0x1C5L` | `0x00001C50` | SPEC-VERSION | Meta | 14 | [0x1C5L-spec-version.md](meta/0x1C5L-spec-version.md) |  |
| `0x1C6L` | `0x00001C60` | PROFILE | Meta | 14 | [0x1C6L-profile.md](meta/0x1C6L-profile.md) |  |
| `0x1C7L` | `0x00001C70` | DOC-ID | Meta | 14 | [0x1C7L-doc-id.md](meta/0x1C7L-doc-id.md) |  |
| `0x1C8L` | `0x00001C80` | EFFECTIVE-FROM | Meta | 14 | [0x1C8L-effective-from.md](meta/0x1C8L-effective-from.md) |  |
| `0x1C9L` | `0x00001C90` | EFFECTIVE-UNTIL | Meta | 14 | [0x1C9L-effective-until.md](meta/0x1C9L-effective-until.md) |  |
| `0x1CAL` | `0x00001CA0` | DEFAULT-LANGUAGE | Meta | 14 | [0x1CAL-default-language.md](meta/0x1CAL-default-language.md) |  |
| `0x1CBL` | `0x00001CB0` | AUTHOR | Meta | 14 | [0x1CBL-author.md](meta/0x1CBL-author.md) |  |
| `0x1CCL` | `0x00001CC0` | CO-AUTHOR | Meta | 14 | [0x1CCL-co-author.md](meta/0x1CCL-co-author.md) |  |
| `0x1CDL` | `0x00001CD0` | CREATED-AT | Meta | 14 | [0x1CDL-created-at.md](meta/0x1CDL-created-at.md) |  |
| `0x1CEL` | `0x00001CE0` | MODIFIED-AT | Meta | 14 | [0x1CEL-modified-at.md](meta/0x1CEL-modified-at.md) |  |
| `0x1CFL` | `0x00001CF0` | RECORDED-BY | Meta | 14 | [0x1CFL-recorded-by.md](meta/0x1CFL-recorded-by.md) |  |
| `0x1D0L` | `0x00001D00` | RECORDED-AT | Meta | 14 | [0x1D0L-recorded-at.md](meta/0x1D0L-recorded-at.md) |  |
| `0x1D1L` | `0x00001D10` | PARENT | Meta | 14 | [0x1D1L-parent.md](meta/0x1D1L-parent.md) |  |
| `0x1D2L` | `0x00001D20` | DERIVED-FROM | Meta | 14 | [0x1D2L-derived-from.md](meta/0x1D2L-derived-from.md) |  |
| `0x1D3L` | `0x00001D30` | GENERATED-BY | Meta | 14 | [0x1D3L-generated-by.md](meta/0x1D3L-generated-by.md) |  |
| `0x1D4L` | `0x00001D40` | TRANSFORMED-BY | Meta | 14 | [0x1D4L-transformed-by.md](meta/0x1D4L-transformed-by.md) |  |
| `0x1D5L` | `0x00001D50` | CHERRY-PICKED-FROM | Meta | 14 | [0x1D5L-cherry-picked-from.md](meta/0x1D5L-cherry-picked-from.md) |  |
| `0x1D6L` | `0x00001D60` | REVERTS | Meta | 14 | [0x1D6L-reverts.md](meta/0x1D6L-reverts.md) |  |
| `0x1D7L` | `0x00001D70` | REPLACES | Meta | 14 | [0x1D7L-replaces.md](meta/0x1D7L-replaces.md) |  |
| `0x1D8L` | `0x00001D80` | SQUASHED-FROM | Meta | 14 | [0x1D8L-squashed-from.md](meta/0x1D8L-squashed-from.md) |  |
| `0x1D9L` | `0x00001D90` | MESSAGE | Meta | 14 | [0x1D9L-message.md](meta/0x1D9L-message.md) |  |
| `0x1DAL` | `0x00001DA0` | TAG | Meta | 14 | [0x1DAL-tag.md](meta/0x1DAL-tag.md) |  |
| `0x1DBL` | `0x00001DB0` | DELTA-BASE | Meta | 14 | [0x1DBL-delta-base.md](meta/0x1DBL-delta-base.md) |  |
| `0x1DCL` | `0x00001DC0` | DELTA-REMOVE | Meta | 14 | [0x1DCL-delta-remove.md](meta/0x1DCL-delta-remove.md) |  |
| `0x1DDL` | `0x00001DD0` | NEXT-LOCAL-ID | Meta | 14 | [0x1DDL-next-local-id.md](meta/0x1DDL-next-local-id.md) |  |
| `0x1DEL` | `0x00001DE0` | LICENSE | Meta | 14 | [0x1DEL-license.md](meta/0x1DEL-license.md) |  |
| `0x1DFL` | `0x00001DF0` | ACCESS | Meta | 14 | [0x1DFL-access.md](meta/0x1DFL-access.md) |  |
| `0x1E0L` | `0x00001E00` | PRIVACY | Meta | 15 | [0x1E0L-privacy.md](meta/0x1E0L-privacy.md) |  |
| `0x1E1L` | `0x00001E10` | RETENTION | Meta | 15 | [0x1E1L-retention.md](meta/0x1E1L-retention.md) |  |
| `0x1E2L` | `0x00001E20` | CONSENT | Meta | 15 | [0x1E2L-consent.md](meta/0x1E2L-consent.md) |  |
| `0x1E3L` | `0x00001E30` | USAGE | Meta | 15 | [0x1E3L-usage.md](meta/0x1E3L-usage.md) |  |
| `0x1E4L` | `0x00001E40` | IMPORT-DOC | Meta | 15 | [0x1E4L-import-doc.md](meta/0x1E4L-import-doc.md) |  |
| `0x1E5L` | `0x00001E50` | ISSUER-KEY | Meta | 15 | [0x1E5L-issuer-key.md](meta/0x1E5L-issuer-key.md) |  |
| `0x1E6L` | `0x00001E60` | SIGNATURE | Meta | 15 | [0x1E6L-signature.md](meta/0x1E6L-signature.md) |  |
| `0x1E7L` | `0x00001E70` | SIGNED-OFF | Meta | 15 | [0x1E7L-signed-off.md](meta/0x1E7L-signed-off.md) |  |
| `0x1E8L` | `0x00001E80` | CONFIDENCE | Meta | 15 | [0x1E8L-confidence.md](meta/0x1E8L-confidence.md) |  |
| `0x1E9L` | `0x00001E90` | VERDICT | Meta | 15 | [0x1E9L-verdict.md](meta/0x1E9L-verdict.md) |  |
