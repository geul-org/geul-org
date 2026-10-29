---
title: "GEUL 文法"
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-28T12:00:00+09:00
tags: ["grammar", "specification"]
summary: "GEUL v1 の文法仕様。16ビットワード上のレコード、四つの Kind とすべての Codec、ドキュメント構造、Issuer と公表規則を定義する。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
showContent: true
---

GEUL v1 の文法仕様だ。初めて読むなら、次の順に読む。

1. [概要](/ja/grammar/overview/) — GEUL とは何か、どのような原則で設計したか
2. [レコードと TAG WORD](/ja/grammar/record/) — 16ビットの TAG WORD、Kind、Length、Codec
3. [ドキュメント](/ja/grammar/document/) — HEAD と BODY、コンテンツハッシュ、バージョンと改訂
4. [Reference](/ja/grammar/reference/)、[Value](/ja/grammar/value/)、[Edge](/ja/grammar/edge/)、[Meta](/ja/grammar/meta/) — 四つの Kind
5. [Issuer と公表](/ja/grammar/issuer/) — ドキュメントと形式を発行する主体、1 WORD 割り当て表、公開方式、署名と検証鍵
6. [公表アドレスとバージョン一覧](/ja/grammar/publishing/) — ID 表記、公表アドレス、形式指定、名前索引、バージョン一覧、信頼層
7. [Codec 規格ドキュメント](/ja/grammar/codec-spec/) — Codec レイアウトを GEUL ドキュメントとして書く方法
8. [例: Wikidata 項目](/ja/grammar/example/) — 実際のドキュメント一式

このページはすべての Codec の索引だ。名前を押すと、その Codec の詳細ドキュメントに移る。リンクのない名前には、まだ詳細ドキュメントがない。表にない直接コードは予約だ。

## Kind

TAG WORD は `000K KLLL LCCC CCCC` だ。`KK` は Kind、`LLLL` は Length、`CCC CCCC` は Codec 7ビットである。ただし Reference は Codec 4ビットと Quantifier 3ビットだ。

| 値 | 分類 | 説明 |
|---|---|---|
| `0000 0LLL LCCC CQQQ` | [Reference](/ja/grammar/reference/) | 対象を指すレコード。`QQQ` は Quantifier |
| `0000 1LLL LCCC CCCC` | [Value](/ja/grammar/value/) | 値レコード |
| `0001 0LLL LCCC CCCC` | [Edge](/ja/grammar/edge/) | 構成レコード |
| `0001 1LLL LCCC CCCC` | [Meta](/ja/grammar/meta/) | ドキュメントとレコードに関するレコード |

## Reference

`0000 0LLL LCCC CQQQ` — [Reference](/ja/grammar/reference/)

### Codec (`CCCC`)

| CCCC | 名前 | 分類 | 対象 ID |
|---|---|---|---|
| `0000` | [プレースホルダ](/ja/grammar/reference/slot-marker/) | 予約 | 対象を指さない1 WORD のマーカー群。下位3ビットがマーカー番号だ(下の表) |
| `0001` | [LOCAL](/ja/grammar/reference/local/) | 宣言 | このドキュメントが発行した ID |
| `0010` | [GEUL](/ja/grammar/reference/geul/) | 宣言 | geul.org が CC0 で発行するエンティティ。小さい番号を高頻度エンティティに割り当てる |
| `0011` | [GEUL-SIDX](/ja/grammar/reference/geul-sidx/) | 宣言 | GEUL SIDX(Semantic-aligned Index)。ビットに意味を載せた識別子 |
| `0100` | [WIKIDATA-QID](/ja/grammar/reference/wikidata-qid/) | 宣言 | Wikidata 項目。`Q` の後の整数 |
| `0101` | [WIKIDATA-PID](/ja/grammar/reference/wikidata-pid/) | 宣言 | Wikidata プロパティ。`P` の後の整数 |
| `0110` | [ISSUER-POINTER](/ja/grammar/reference/issuer-pointer/) | 指示宣言 | Issuer 自身。Payload は Issuer(1/2/4/16 WORD)だけで、対象 ID はない |
| `0111` | [DOC-POINTER](/ja/grammar/reference/doc-pointer/) | 指示宣言 | Issuer ドキュメントの一つのバージョン。Issuer + ドキュメント ID 4 WORD + バージョン ID 2 WORD、対象 ID はない |
| `1000` | [EXTERNAL-POINTER-1WORD](/ja/grammar/reference/external-pointer/) | 指示 | `IMPORT-DOC` で取り込んだドキュメントの LOCAL ID。IMPORT ID 1 WORD |
| `1001` | [EXTERNAL-POINTER-2WORD](/ja/grammar/reference/external-pointer/) | 指示 | 上と同じ。IMPORT ID 2 WORD |
| `1010` | [EXTERNAL-POINTER-4WORD](/ja/grammar/reference/external-pointer/) | 指示 | 上と同じ。IMPORT ID 4 WORD |
| `1011` | [EXTERNAL-POINTER-8WORD](/ja/grammar/reference/external-pointer/) | 指示 | 上と同じ。IMPORT ID 8 WORD |
| `1100` | [EXTERNAL-ISSUER-1WORD](/ja/grammar/reference/external-issuer/) | 指示宣言 | 1 WORD Issuer ドキュメントの LOCAL ID |
| `1101` | [EXTERNAL-ISSUER-2WORD](/ja/grammar/reference/external-issuer/) | 指示宣言 | 2 WORD Issuer ドキュメントの LOCAL ID |
| `1110` | [EXTERNAL-ISSUER-4WORD](/ja/grammar/reference/external-issuer/) | 指示宣言 | 4 WORD Issuer ドキュメントの LOCAL ID |
| `1111` | [EXTERNAL-ISSUER-16WORD](/ja/grammar/reference/external-issuer/) | 指示宣言 | 16 WORD Issuer ドキュメントの LOCAL ID |

### プレースホルダ (Codec `0000`)

`0000 0000 0000 0MMM` — [プレースホルダ](/ja/grammar/reference/slot-marker/)。フィールドの CODEC 一覧がその WORD をちょうど許すときだけ、その位置に来る。

| WORD | 名前 | 意味 | Wikidata |
|---|---|---|---|
| `0x0000` | [ABSENT](/ja/grammar/reference/slot-marker/) | 記さない。オプションフィールドを省略した。世界について何も断言しない | snak なし |
| `0x0001` | [UNKNOWN-VALUE](/ja/grammar/reference/slot-marker/) | 不明。値はあるが何かわからない | `somevalue` |
| `0x0002` | [NO-VALUE](/ja/grammar/reference/slot-marker/) | なし。値が存在しない | `novalue` |
| `0x0003`~`0x0007` | Reserved | | |

### Quantifier (`QQQ`)

| QQQ | 名前 | 意味 | 例 |
|---|---|---|---|
| `000` | Identified | 識別された個体 | イーロン・マスク、日本 |
| `001` | Generic | 種類全体についての一般的・定義的な陳述。例外を許す | 兵士は命令に従う |
| `010` | Free-choice | 条件を満たす任意の対象 | どの兵士でも |
| `011` | Universal | 与えられた範囲に属するすべての対象 | すべての兵士 |
| `100` | Variable | 談話変数 | その人、この女性 |
| `101`~`111` | Reserved |  |  |

- Codec `0000`(プレースホルダ)では、下位3ビットは Quantifier ではなくマーカー番号だ。

## Issuer

Issuer はドキュメントと形式を定義する主体だ — [Issuer と公表](/ja/grammar/issuer/)

| 位置 | 意味 |
|---|---|
| Value・Edge ISSUER コード(`0x7C`~`0x7F`) | その Issuer が定義した形式 |
| Meta `DOC-ID` | このドキュメントを発行した Issuer |
| Meta `IMPORT-DOC` | 取り込んだドキュメントを発行した Issuer |
| Reference `EXTERNAL-ISSUER-*`・`DOC-POINTER` | 指すドキュメントを発行した Issuer(1/2/4/16 WORD) |
| Reference `ISSUER-POINTER` | 指す Issuer 自身(1/2/4/16 WORD) |

| Issuer 幅 | 発行 |
|---|---|
| 1 WORD | geul.org が標準制定団体と主要機関に割り当てる([1 WORD 割り当て表](/ja/grammar/issuer/#1-word-割り当て表))。 |
| 2 WORD | geul.org 登録。ドメイン所有の証明(例: company.com)を経た Issuer |
| 4 WORD | geul.org 登録。所有の証明なしで登録した Issuer |
| 16 WORD | 自己発行。登録なしで公開鍵から計算する。下の生成規則に従う。 |

### 16 WORD Issuer 署名アルゴリズム

| 署名アルゴリズム ID | アルゴリズム |
|---|---|
| `0x0001` | Ed25519 |
| それ以外 | 予約 |

## Edge

`0001 0LLL LCCC CCCC` — [Edge](/ja/grammar/edge/)

Codec の上位2ビットがファミリーだ。直接コード(7ビット)も ISSUER 形式番号(16ビット)も同じ規則に従う。

| 上位2ビット | ファミリー | 直接コード | 形式番号 |
|---|---|---|---|
| `00` | 記述 | `0x00`~`0x1F` | `0x0000`~`0x3FFF` |
| `01` | 根拠 | `0x20`~`0x3F` | `0x4000`~`0x7FFF` |
| `10` | 実行 | `0x40`~`0x5F` | `0x8000`~`0xBFFF` |
| `11` | [TOULMIN](/ja/grammar/edge/toulmin/) | `0x60`~`0x7B` | `0xC000`~`0xFFFF` |

### 記述 (`00`)

| CCCCC | Codec | 名前 | 下位形式 | 説明 |
|---|---|---|---|---|
| `00000` | `0x00` | [REFERENCE-NODE](/ja/grammar/edge/reference-node/) |  | Reference である Subject が Object を指す方向性バインディング |
| `00001` | `0x01` | [SAME-NODE](/ja/grammar/edge/same-node/) |  | 二つの Reference が同じ対象を指す同一性 |
| `00010` | `0x02` | [DIFFERENT-NODE](/ja/grammar/edge/different-node/) |  | 二つの Reference が異なる対象を指す非同一性 |
| `00011` | `0x03` | [BIND](/ja/grammar/edge/bind/) |  | Subject に機械が照合する名前(`UTF8-TEXT-*`)を結びつける。範囲内で一意で、正確に一致しなければならず、言語はない |
| `00100` | `0x04` | [LABEL](/ja/grammar/edge/label/) |  | Subject の言語名(label)の接続。Object は UTF8-LANGUAGE-TEXT |
| `00101` | `0x05` | [ALIAS](/ja/grammar/edge/alias/) |  | Subject の別名(エイリアス)の接続。レイアウトは LABEL と同じ |
| `00110` | `0x06` | [DESCRIPTION](/ja/grammar/edge/description/) |  | Subject の言語説明(description)の接続。レイアウトは LABEL と同じ |
| `00111` | `0x07` | Reserved |  |  |
| `01000` | `0x08` | VERB-SHORT |  | 動詞記述の短縮形 |
| `01001` | `0x09` | VERB |  | 動詞記述 |
| `01010` | `0x0A` | [TRIPLE](/ja/grammar/edge/triple/) |  | Predicate、Subject、Object の順の命題と rank。Object は値または UNKNOWN-VALUE・NO-VALUE マーカー。意味は、その Edge Id を指す QUALIFIER をすべて集めたものだ |
| `01011` | `0x0B` | [QUALIFIER](/ja/grammar/edge/qualifier/) |  | 他の Edge の命題を限定する条件一つ。Property、Target(Edge Id)、Value(値または UNKNOWN-VALUE・NO-VALUE マーカー)。命題の一部だ |
| `01100`~`01111` | `0x0C`~`0x0F` | Reserved |  |  |
| `10000` | `0x10` | WORLD | あり | 世界観を表現するための構造 |
| `10001` | `0x11` | TIMELINE | あり | 世界と出来事の順序を表現する構造 |
| `10010` | `0x12` | SCENE | あり | シナリオ特性の記述のための場面構造 |
| `10011`~`10111` | `0x13`~`0x17` | Reserved |  |  |
| `11000` | `0x18` | [PUBLICATION](/ja/grammar/edge/publication/) |  | ドキュメントの公表。DOC-POINTER、コンテンツハッシュ |
| `11001` | `0x19` | DEPRECATION |  | 公表したバージョンの deprecate。DOC-POINTER |
| `11010` | `0x1A` | TOMBSTONE |  | 公表したバージョンの削除(墓標)。DOC-POINTER、理由カテゴリ |
| `11011` | `0x1B` | [DECLARE](/ja/grammar/edge/declare/) |  | Codec 一つの Payload 構成の宣言。対象 Kind・Codec |
| `11100` | `0x1C` | [FIELD](/ja/grammar/edge/field/) |  | Payload フィールド一つ。属する DECLARE、幅: レコード(TAG の Length)または生値 n WORD |
| `11101` | `0x1D` | [ENUM](/ja/grammar/edge/enum/) |  | 生値フィールドのコード値一つ。フィールド、コード値 |
| `11110` | `0x1E` | [CODEC](/ja/grammar/edge/codec/) |  | フィールドが受け取る Kind・Codec 一つ。フィールド、対象 WORD(`000K KLLL LCCC CCCC`、LLLL は 0000 が正確・1111 がワイルドカード、プレースホルダは正確な対象 `0000`~`0002` のみ)。レコードフィールドは複数(閉じた一覧)、生値フィールドは一つ(TAG のないその Value) |
| `11111` | `0x1F` | Reserved |  |  |

| CCCCC 上位2ビット | グループ |
|---|---|
| `00` | 指示と名前 |
| `01` | 命題 |
| `10` | 構造 |
| `11` | その他 |

### 根拠 (`01`)

| Codec | 名前 | 下位形式 | 説明 |
|---|---|---|---|
| `0x20` | [SOURCE](/ja/grammar/edge/source/) |  | レコード一つまたはドキュメント全体をその原典に結びつける。Target(BODY の Edge Id、HEAD では `0` = ドキュメント全体)、Origin(Reference、ABSENT または UNKNOWN-VALUE)。原典の性質は原典を Subject とする TRIPLE、引用の性質(参照日、位置、原文ハッシュ)は SOURCE に付く QUALIFIER。ドキュメント全体の SOURCE とその QUALIFIER は HEAD に置く |
| `0x21`~`0x3F` | Reserved |  |  |

- 原文の範囲、作成した主体、信頼度、条文ごとの施行期間、旧レコードは QUALIFIER で書き、最初に入ったバージョンはバージョン履歴から計算する([SOURCE](/ja/grammar/edge/source/#他の根拠の表現))。

### 実行 (`10`)

| CCCCC | Codec | 名前 | 説明 |
|---|---|---|---|
| `00000` | `0x40` | Reserved |  |
| `00001` | `0x41` | FUNCTION-DECLARE | 関数宣言。記号、パラメータ記号の一覧、戻り値の型、本体(BLOCK) |
| `00010` | `0x42` | TYPE-DECLARE | 型宣言。記号と構成(フィールド記号の一覧、列挙値、別名の対象) |
| `00011`~`00111` | `0x43`~`0x47` | Reserved |  |
| `01000` | `0x48` | CONST | 定数式。組み込み Value 一つ |
| `01001` | `0x49` | UNARY | 単項式。演算子 1 WORD、オペランド |
| `01010` | `0x4A` | BINARY | 二項式。演算子 1 WORD、左、右 |
| `01011` | `0x4B` | CALL | 呼び出し。対象関数、引数の数、引数 × 引数の数 |
| `01100` | `0x4C` | MEMBER | メンバーアクセス。対象、フィールド記号 |
| `01101` | `0x4D` | INDEX | 添字アクセス。対象、添字 |
| `01110` | `0x4E` | CONSTRUCT | 複合値の生成(リスト、レコード)。型、要素数、要素 × 要素数 |
| `01111` | `0x4F` | CONDITIONAL | 条件式。条件、真のときの値、偽のときの値 |
| `10000` | `0x50` | BLOCK | 順序のある文の束。文の数、文 × 文の数 |
| `10001` | `0x51` | ASSIGN | 代入。対象(記号、MEMBER、INDEX)、値 |
| `10010` | `0x52` | IF | 条件分岐。条件、真の BLOCK、偽(BLOCK・IF、なければ 0) |
| `10011` | `0x53` | SWITCH | 多分岐。対象、分岐の数、(値, BLOCK) × 分岐の数、デフォルト BLOCK(なければ 0) |
| `10100` | `0x54` | WHILE | 条件反復。条件、本体 BLOCK |
| `10101` | `0x55` | FOREACH | 巡回反復。要素記号、対象、本体 BLOCK |
| `10110` | `0x56` | JUMP | 反復制御。種類 1 WORD(break, continue)、対象の反復 |
| `10111` | `0x57` | RETURN | 戻り。値(なければ 0) |
| `11000` | `0x58` | RAISE | エラー発生。エラー値 |
| `11001` | `0x59` | TRY | エラー処理。本体 BLOCK、エラー記号、処理 BLOCK、後始末 BLOCK(なければ 0) |
| `11010`~`11111` | `0x5A`~`0x5F` | Reserved |  |

| CCCCC 上位2ビット | グループ |
|---|---|
| `00` | 宣言 |
| `01` | 式 |
| `10` | 文 |
| `11` | エラー |

### TOULMIN (`11`)

詳細: [TOULMIN](/ja/grammar/edge/toulmin/)

| CCCCC | Codec | 名前 | 説明 |
|---|---|---|---|
| `00000` | `0x60` | [CASE-DECLARE](/ja/grammar/edge/toulmin/node/) | 事案宣言。ノードと関係を含む判定グラフ |
| `00001` | `0x61` | [PREDICATE-DECLARE](/ja/grammar/edge/toulmin/expr/) | 述語宣言。判定関数・式、判断基準(Spec)、事実契約(Ground) |
| `00010` | `0x62` | [SPEC-DECLARE](/ja/grammar/edge/toulmin/node/) | 判断基準宣言。定数・リスト (Backing) |
| `00011` | `0x63` | [RULE-DECLARE](/ja/grammar/edge/toulmin/node/) | 主張宣言。事案の中で述語を一般規則(Warrant)として置く。攻撃されうる。 |
| `00100` | `0x64` | [COUNTER-DECLARE](/ja/grammar/edge/toulmin/node/) | 反駁宣言。自分の結論を持って攻撃する。デフォルトの Level は Fail |
| `00101` | `0x65` | [EXCEPT-DECLARE](/ja/grammar/edge/toulmin/node/) | 例外宣言。自分の結論なしで攻撃する。デフォルトの Level は Review |
| `00110`~`00111` | `0x66`~`0x67` | Reserved |  |
| `01000` | `0x68` | [ATTACKS](/ja/grammar/edge/toulmin/link/) | 攻撃関係。攻撃者の判定が対象の判定を漸進的に削る。 |
| `01001` | `0x69` | [SUPERSEDES](/ja/grammar/edge/toulmin/link/) | 排除関係。攻撃者が Active なら、対象を集計から決定的に除く。 |
| `01010` | `0x6A` | SUPERSEDE-CHAIN | 優先順位の鎖 `A > B > C`。対ごとの SUPERSEDES の短縮形。レイアウト未定 |
| `01011`~`01111` | `0x6B`~`0x6F` | Reserved |  |
| `10000` | `0x70` | [RUN](/ja/grammar/edge/toulmin/link/) | 実行合成。ノードが Active なら下位の事案を実行する(DAG)。 |
| `10001` | `0x71` | [DO](/ja/grammar/edge/toulmin/link/) | ノードが Active のとき実行する動作 |
| `10010` | `0x72` | [DO-ONCE](/ja/grammar/edge/toulmin/link/) | 再試行しても一度だけ実行する動作 |
| `10011` | `0x73` | [UNDO](/ja/grammar/edge/toulmin/link/) | DO の補償動作(saga)。後続の段階が失敗すると逆順に実行する。 |
| `10100` | `0x74` | [CHECKING](/ja/grammar/edge/toulmin/link/) | 副作用なしで判定だけを行う接続 |
| `10101` | `0x75` | [ENTRY](/ja/grammar/edge/toulmin/node/) | 外部の入口。事案を実行または判定する |
| `10110` | `0x76` | [TRIGGER](/ja/grammar/edge/toulmin/node/) | 外部呼び出しのないイベント・周期の入口 |
| `10111` | `0x77` | Reserved |  |
| `11000` | `0x78` | VERDICT | ノード・レコードの判定結果。結果(Pass, Review, Fail)、判定値、Activated、Excluded、Level。レイアウト未定。ドキュメント全体の判定は Meta [VERDICT](/ja/grammar/meta/verification/verdict/)(`0x44`) |
| `11001` | `0x79` | EVIDENCE | 判定の証拠。位置、期待値、実際の値 (Fact)。レイアウト未定 |
| `11010`~`11011` | `0x7A`~`0x7B` | Reserved |  |
| `111xx` | `0x7C`~`0x7F` | ISSUER-* | Issuer が定義した形式 |

| CCCCC 上位2ビット | グループ |
|---|---|
| `00` | 宣言 |
| `01` | 関係 |
| `10` | 実行 |
| `11` | 結果 (`0x7C`~`0x7F` は ISSUER) |

### Edge ISSUER 形式

`0x7C`~`0x7F`(ISSUER-1/2/4/16WORD)の後の Codec 拡張 TAG に Issuer と形式番号を置く。形式番号の上位2ビットがファミリーだ。形式番号の空間は Value とは別だ。

| Issuer | 形式番号 | 名前 | ファミリー | 説明 |
|---|---|---|---|---|
| `0x0000` GEUL | `0xC000` | [SOURCE](/ja/grammar/edge/toulmin/source/) | TOULMIN | 著作原文。SPAN 幅と UTF8 Value |
| `0x0000` GEUL | `0xC001` | [TEXT](/ja/grammar/edge/toulmin/source/) | TOULMIN | 名前・文字列 |
| `0x0000` GEUL | `0xC002` | [SECTION](/ja/grammar/edge/toulmin/source/) | TOULMIN | セクション開始。セクションコード |
| `0x0000` GEUL | `0xC003` | [CASE-BEGIN](/ja/grammar/edge/toulmin/source/) | TOULMIN | 事案範囲の開始 |
| `0x0000` GEUL | `0xC004` | [CASE-END](/ja/grammar/edge/toulmin/source/) | TOULMIN | 事案範囲の終わり |
| `0x0000` GEUL | `0xC005` | [PROSE](/ja/grammar/edge/toulmin/source/) | TOULMIN | 記述の段落(SPAN) |
| `0x0000` GEUL | `0xC010` | [NAMESPACE](/ja/grammar/edge/toulmin/node/) | TOULMIN | NODE。`this document is` |
| `0x0000` GEUL | `0xC011` | [FUNC](/ja/grammar/edge/toulmin/node/) | TOULMIN | NODE。関数参照 |
| `0x0000` GEUL | `0xC012` | [FIELD](/ja/grammar/edge/toulmin/node/) | TOULMIN | NODE。`is required` |
| `0x0000` GEUL | `0xC013` | [ALIAS](/ja/grammar/edge/toulmin/node/) | TOULMIN | NODE。`see … from` |
| `0x0000` GEUL | `0xC014` | [GROUP](/ja/grammar/edge/toulmin/node/) | TOULMIN | NODE。順序のある実行の束 |
| `0x0000` GEUL | `0xC020` | [REQUIRES](/ja/grammar/edge/toulmin/link/) | TOULMIN | LINK。事案 → フィールド |
| `0x0000` GEUL | `0xC021` | [MEANS](/ja/grammar/edge/toulmin/link/) | TOULMIN | LINK。定義項目 → 値・型 |
| `0x0000` GEUL | `0xC022` | [HAS](/ja/grammar/edge/toulmin/link/) | TOULMIN | LINK。定義項目 → フィールド |
| `0x0000` GEUL | `0xC023` | [RUNS](/ja/grammar/edge/toulmin/link/) | TOULMIN | LINK。入口 → 事案、実行 |
| `0x0000` GEUL | `0xC024` | [EVALUATES](/ja/grammar/edge/toulmin/link/) | TOULMIN | LINK。入口 → 事案、判定 |
| `0x0000` GEUL | `0xC025` | [TRIGGERS](/ja/grammar/edge/toulmin/link/) | TOULMIN | LINK。トリガー → 事案 |
| `0x0000` GEUL | `0xC026` | [UNTIL](/ja/grammar/edge/toulmin/link/) | TOULMIN | LINK。トリガー → 事案(`every … until`) |
| `0x0000` GEUL | `0xC027` | [SAME-AS](/ja/grammar/edge/toulmin/link/) | TOULMIN | LINK。ノード → グローバル識別子 |
| `0x0000` GEUL | `0xC028` | [IMPORTED-FROM](/ja/grammar/edge/toulmin/link/) | TOULMIN | LINK。別名 → パス(TEXT) |
| `0x0000` GEUL | `0xC029` | [LABEL](/ja/grammar/edge/toulmin/link/) | TOULMIN | LINK。ノード → TEXT、名前の表記 |

## Value

`0000 1LLL LCCC CCCC` — [Value](/ja/grammar/value/)

Codec の上位2ビットがファミリーだ。NUMERIC/DECIMAL は上位3ビット目でさらに分ける(`000` NUMERIC、`001` DECIMAL)。

| 上位2ビット | ファミリー | 直接コード | 形式番号 |
|---|---|---|---|
| `00` | [NUMERIC](/ja/grammar/value/numeric/)/[DECIMAL](/ja/grammar/value/decimal/) | `0x00`~`0x1F` | `0x0000`~`0x3FFF` |
| `01` | [TIME](/ja/grammar/value/time/) | `0x20`~`0x3F` | `0x4000`~`0x7FFF` |
| `10` | [TEXT](/ja/grammar/value/text/) | `0x40`~`0x5F` | `0x8000`~`0xBFFF` |
| `11` | [BINARY](/ja/grammar/value/binary/) | `0x60`~`0x7B` | `0xC000`~`0xFFFF` |

### 直接コード

| Codec | 名前 | ファミリー | 説明 |
|---|---|---|---|
| `0x00` | [BOOL](/ja/grammar/value/numeric/bool/) | NUMERIC | 固定1 WORD の false または true |
| `0x01` | [SIGNED-INTEGER](/ja/grammar/value/numeric/signed-integer/) | NUMERIC | 最小 WORD の2の補数による符号付き整数 |
| `0x02` | [UNSIGNED-INTEGER](/ja/grammar/value/numeric/unsigned-integer/) | NUMERIC | 最小 WORD の big-endian unsigned magnitude 整数 |
| `0x03` | [BINARY-FLOAT](/ja/grammar/value/numeric/binary-float/) | NUMERIC | Payload 1/2/4/8 WORD の IEEE 754 binary16/32/64/128 scalar |
| `0x04` | [COORDINATE-EARTH](/ja/grammar/value/numeric/coordinate-earth/) | NUMERIC | 地球(WGS 84)の緯度・経度 binary64、不確かさ binary32 とその単位 Reference(ABSENT = 不明) |
| `0x05` | [COORDINATE-GEO](/ja/grammar/value/numeric/coordinate-geo/) | NUMERIC | 天体 Reference と緯度・経度 binary64、不確かさ binary32 とその単位 Reference |
| `0x06` | [QUANTITY](/ja/grammar/value/numeric/quantity/) | NUMERIC | 数値 Value amount(整数・BINARY-FLOAT・10進数・分数)、単位 Reference、下限・上限。単位・境界は省略可(ABSENT `0x0000`) |
| `0x07` | [FRACTION](/ja/grammar/value/numeric/fraction/) | NUMERIC | 原文の表記を保存する分数: 整数・10進数の分子、符号なし整数・10進数の分母。約分しない |
| `0x08`~`0x0F` | Reserved | NUMERIC |  |
| `0x10` | [SIGNED-DECIMAL](/ja/grammar/value/decimal/signed-decimal/) | DECIMAL | signed exponent `E` と最小 WORD の2の補数 coefficient `C` による `C×10^E` |
| `0x11` | [UNSIGNED-DECIMAL](/ja/grammar/value/decimal/unsigned-decimal/) | DECIMAL | signed exponent `E` と最小 WORD の unsigned coefficient `C` による `C×10^E` |
| `0x12`~`0x1F` | Reserved | DECIMAL |  |
| `0x20` | [GREGORIAN-DATE](/ja/grammar/value/time/gregorian-date/) | TIME | proleptic Gregorian `1970-01-01` 基準の signed 日数 |
| `0x21` | [CIVIL-TIME-NANOSECONDS](/ja/grammar/value/time/civil-time-nanoseconds/) | TIME | 民事日の午前0時以降の unsigned nanosecond 計数 |
| `0x22` | [POSIX-TIMESTAMP-SECONDS](/ja/grammar/value/time/posix-timestamp-seconds/) | TIME | Unix/POSIX epoch からの signed 秒計数 |
| `0x23` | [DURATION-SECONDS](/ja/grammar/value/time/duration-seconds/) | TIME | epoch のない signed SI-second 経過時間 |
| `0x24`/`0x25` | [EDTF](/ja/grammar/value/time/edtf/) | TIME | EDTF(ISO 8601-2)日付文字列。偶数・奇数バイト。GREGORIAN-DATE で書ける日付には使わない |
| `0x26`/`0x27` | [GEDCOM-DATE](/ja/grammar/value/time/gedcom-date/) | TIME | GEDCOM 7 日付値の文字列。他の暦(ユリウス暦など)の原表記を保存。偶数・奇数バイト |
| `0x28`~`0x3F` | Reserved | TIME |  |
| `0x40` | [UTF8-TEXT-EVEN](/ja/grammar/value/text/utf8-text/) | TEXT | 正規化を暗示しない valid UTF-8 バイト列。偶数バイト |
| `0x41` | [UTF8-TEXT-ODD](/ja/grammar/value/text/utf8-text/) | TEXT | 上と同じ。奇数バイト |
| `0x42`/`0x43` | Reserved | TEXT |  |
| `0x44` | [URI-EVEN](/ja/grammar/value/text/uri/) | TEXT | RFC 3986 `URI` production の ASCII バイト列。偶数バイト |
| `0x45` | [URI-ODD](/ja/grammar/value/text/uri/) | TEXT | 上と同じ。奇数バイト |
| `0x46` | [LANGUAGE-BCP47-CODE-EVEN](/ja/grammar/value/text/language-bcp47-code/) | TEXT | canonical casing の完全な BCP 47 language tag の ASCII バイト列。偶数バイト |
| `0x47` | [LANGUAGE-BCP47-CODE-ODD](/ja/grammar/value/text/language-bcp47-code/) | TEXT | 上と同じ。奇数バイト |
| `0x48` | [LANGUAGE-SHORT-CODE](/ja/grammar/value/text/language-short-code/) | TEXT | GEUL Language Registry の番号で書いた BCP 47 tag(Payload 1 WORD) |
| `0x49` | Reserved | TEXT |  |
| `0x4A`/`0x4B` | [UTF8-LANGUAGE-TEXT](/ja/grammar/value/text/utf8-language-text/) | TEXT | 言語付きテキスト。言語 Value レコード(LANGUAGE-SHORT-CODE または LANGUAGE-BCP47-CODE)と UTF-8 バイト。テキストバイトの偶数・奇数 |
| `0x4C`~`0x5F` | Reserved | TEXT |  |
| `0x60` | [UUID](/ja/grammar/value/binary/uuid/) | BINARY | 固定 Payload 8 WORD の RFC 9562 UUID 128bit |
| `0x61` | [SHA-256-DIGEST](/ja/grammar/value/binary/sha-256-digest/) | BINARY | 固定 Payload 16 WORD の SHA-256 結果 |
| `0x62` | [SHA1-DIGEST](/ja/grammar/value/binary/sha1-digest/) | BINARY | 固定 Payload 10 WORD の SHA-1 結果。git オブジェクト ID のような識別用途のみ |
| `0x63`~`0x7B` | Reserved | BINARY |  |
| `0x7C`~`0x7F` | ISSUER-* |  | Issuer が定義した形式。下の Value ISSUER 形式を参照 |

### Value ISSUER 形式

`0x7C`~`0x7F`(ISSUER-1/2/4/16WORD)の後の Codec 拡張 TAG に Issuer と形式番号を置く。形式番号の上位2ビットがファミリーだ。

| Issuer | 形式番号 | 名前 | ファミリー | 説明 |
|---|---|---|---|---|
| `0x0000` GEUL | `0x4000` | [DURATION-NANOSECONDS](/ja/grammar/value/time/duration-nanoseconds/) | TIME | epoch のない signed nanosecond 経過時間 |
| `0x0000` GEUL | `0xC000` | [OPAQUE-BYTES-EVEN](/ja/grammar/value/binary/opaque-bytes/) | BINARY | 意味・形式が不明なバイト列。偶数バイト |
| `0x0000` GEUL | `0xC001` | [OPAQUE-BYTES-ODD](/ja/grammar/value/binary/opaque-bytes/) | BINARY | 上と同じ。奇数バイト |
| `0x0000` GEUL | `0xC002` | [BIT-VECTOR](/ja/grammar/value/binary/bit-vector/) | BINARY | bit-count の後に MSB-first で格納した N bit |
| `0x0001` ADHOC | `0x0000` | BFLOAT16 | NUMERIC | 固定 Payload 1 WORD の BF16 interchange bits |
| `0x0001` ADHOC | `0x0500` | [DENSE-I16-VECTOR](/ja/grammar/value/vector/dense-i16-vector/) | NUMERIC | 連続 big-endian int16 vector |
| `0x0001` ADHOC | `0x0501` | [DENSE-U16-VECTOR](/ja/grammar/value/vector/dense-u16-vector/) | NUMERIC | 連続 big-endian uint16 vector |
| `0x0001` ADHOC | `0x0502` | [DENSE-I32-VECTOR](/ja/grammar/value/vector/dense-i32-vector/) | NUMERIC | 連続 big-endian int32 vector |
| `0x0001` ADHOC | `0x0503` | [DENSE-U32-VECTOR](/ja/grammar/value/vector/dense-u32-vector/) | NUMERIC | 連続 big-endian uint32 vector |
| `0x0001` ADHOC | `0x0504` | [DENSE-I64-VECTOR](/ja/grammar/value/vector/dense-i64-vector/) | NUMERIC | 連続 big-endian int64 vector |
| `0x0001` ADHOC | `0x0505` | [DENSE-U64-VECTOR](/ja/grammar/value/vector/dense-u64-vector/) | NUMERIC | 連続 big-endian uint64 vector |
| `0x0001` ADHOC | `0x0506` | [DENSE-BINARY16-VECTOR](/ja/grammar/value/vector/dense-binary16-vector/) | NUMERIC | 連続 IEEE 754 binary16 vector |
| `0x0001` ADHOC | `0x0507` | [DENSE-BFLOAT16-VECTOR](/ja/grammar/value/vector/dense-bfloat16-vector/) | NUMERIC | 連続 BF16 vector |
| `0x0001` ADHOC | `0x0508` | [DENSE-BINARY32-VECTOR](/ja/grammar/value/vector/dense-binary32-vector/) | NUMERIC | 連続 IEEE 754 binary32 vector |
| `0x0001` ADHOC | `0x0509` | [DENSE-BINARY64-VECTOR](/ja/grammar/value/vector/dense-binary64-vector/) | NUMERIC | 連続 IEEE 754 binary64 vector |
| `0x0001` ADHOC | `0x050A` | [POINT2-BINARY64](/ja/grammar/value/vector/point2-binary64/) | NUMERIC | `(x,y)` 順の IEEE binary64 2次元 vector |
| `0x0001` ADHOC | `0x050B` | [POINT3-BINARY64](/ja/grammar/value/vector/point3-binary64/) | NUMERIC | `(x,y,z)` 順の IEEE binary64 3次元 vector |
| `0x0001` ADHOC | `0x050C` | [BBOX2-BINARY64](/ja/grammar/value/vector/bbox2-binary64/) | NUMERIC | `(minX,minY,maxX,maxY)` 順の IEEE binary64 vector |
| `0x0001` ADHOC | `0x0600` | [DESCRIBED-DENSE-TENSOR](/ja/grammar/value/tensor/described-dense-tensor/) | NUMERIC | element-format・rank・shape と C-contiguous dense payload |
| `0x0001` ADHOC | `0x0601` | [DESCRIBED-PACKED-TENSOR](/ja/grammar/value/tensor/described-packed-tensor/) | NUMERIC | packed-format・rank・shape と octet 内 low-bit-first packed payload |
| `0x0001` ADHOC | `0x0700` | [COMPLEX64](/ja/grammar/value/etc/complex64/) | NUMERIC | `(real, imag)` 順の binary32 二つ |
| `0x0001` ADHOC | `0x0701` | [COMPLEX128](/ja/grammar/value/etc/complex128/) | NUMERIC | `(real, imag)` 順の binary64 二つ |
| `0x0001` ADHOC | `0x0702` | [RATIONAL-I64](/ja/grammar/value/etc/rational-i64/) | NUMERIC | 正規化した int64 numerator と正の int64 denominator |
| `0x0001` ADHOC | `0x0703` | [CLOSED-INTERVAL-BINARY64](/ja/grammar/value/etc/closed-interval-binary64/) | NUMERIC | `lower ≤ upper` の binary64 閉区間 |
| `0x0001` ADHOC | `0x0704` | [QUATERNION-BINARY32](/ja/grammar/value/etc/quaternion-binary32/) | NUMERIC | `(x,y,z,w)` 順の binary32 四つ |
| `0x0001` ADHOC | `0xC000` | [BLAKE3-256-DIGEST](/ja/grammar/value/binary/blake3-256-digest/) | BINARY | 固定 Payload 16 WORD のデフォルト BLAKE3 結果 |
| `0x0020` IETF | `0x8000` | [URI-RELATIVE-REF-EVEN](/ja/grammar/value/text/uri-relative-ref/) | TEXT | RFC 3986 relative-ref の ASCII バイト列。偶数バイト |
| `0x0020` IETF | `0x8001` | [URI-RELATIVE-REF-ODD](/ja/grammar/value/text/uri-relative-ref/) | TEXT | 上と同じ。奇数バイト |
| `0x0020` IETF | `0xC000` | [CRC32C](/ja/grammar/value/binary/crc32c/) | BINARY | 固定 Payload 2 WORD の Castagnoli CRC-32C 結果 |
| `0x0020` IETF | `0xC001` | [IPV4-ADDRESS](/ja/grammar/value/binary/ipv4-address/) | BINARY | 固定 Payload 2 WORD の IPv4 アドレス 32bit |
| `0x0020` IETF | `0xC002` | [IPV6-ADDRESS](/ja/grammar/value/binary/ipv6-address/) | BINARY | 固定 Payload 8 WORD の IPv6 アドレス 128bit |
| `0x0040` IEEE | `0x2000` | [IEEE-DECIMAL32-DPD](/ja/grammar/value/decimal/ieee-decimal32-dpd/) | DECIMAL | 固定 Payload 2 WORD の IEEE 754 decimal32 DPD |
| `0x0040` IEEE | `0x2001` | [IEEE-DECIMAL64-DPD](/ja/grammar/value/decimal/ieee-decimal64-dpd/) | DECIMAL | 固定 Payload 4 WORD の IEEE 754 decimal64 DPD |
| `0x0040` IEEE | `0x2002` | [IEEE-DECIMAL128-DPD](/ja/grammar/value/decimal/ieee-decimal128-dpd/) | DECIMAL | 固定 Payload 8 WORD の IEEE 754 decimal128 DPD |
| `0x0040` IEEE | `0x2003` | [IEEE-DECIMAL32-BID](/ja/grammar/value/decimal/ieee-decimal32-bid/) | DECIMAL | 固定 Payload 2 WORD の IEEE 754 decimal32 BID |
| `0x0040` IEEE | `0x2004` | [IEEE-DECIMAL64-BID](/ja/grammar/value/decimal/ieee-decimal64-bid/) | DECIMAL | 固定 Payload 4 WORD の IEEE 754 decimal64 BID |
| `0x0040` IEEE | `0x2005` | [IEEE-DECIMAL128-BID](/ja/grammar/value/decimal/ieee-decimal128-bid/) | DECIMAL | 固定 Payload 8 WORD の IEEE 754 decimal128 BID |
| `0x0040` IEEE | `0x4000` | [POSIX-TIMESTAMP-NANOSECONDS](/ja/grammar/value/time/posix-timestamp-nanoseconds/) | TIME | Unix/POSIX epoch からの signed nanosecond 計数 |
| `0x0040` IEEE | `0xC000` | [MAC-48-ADDRESS](/ja/grammar/value/binary/mac-48-address/) | BINARY | 固定 Payload 3 WORD の IEEE 802 MAC アドレス 48bit |
| `0x0041` KHRONOS | `0x0000` | [RGBA8-UNORM](/ja/grammar/value/vector/rgba8-unorm/) | NUMERIC | R, G, B, A 順の固定 4×UNORM8 packed vector |
| `0x0041` KHRONOS | `0x0001` | [BGRA8-UNORM](/ja/grammar/value/vector/bgra8-unorm/) | NUMERIC | B, G, R, A 順の固定 4×UNORM8 packed vector |
| `0x0043` ONNX | `0x0000` | FP8-E4M3FN | NUMERIC | Payload 上位 octet の ONNX E4M3FN scalar |
| `0x0043` ONNX | `0x0001` | FP8-E4M3FNUZ | NUMERIC | Payload 上位 octet の ONNX E4M3FNUZ scalar |
| `0x0043` ONNX | `0x0002` | FP8-E5M2 | NUMERIC | Payload 上位 octet の ONNX E5M2 scalar |
| `0x0043` ONNX | `0x0003` | FP8-E5M2FNUZ | NUMERIC | Payload 上位 octet の ONNX E5M2FNUZ scalar |
| `0x0044` OCP | `0x0000` | FP8-E8M0FNU | NUMERIC | Payload 上位 octet の unsigned exponent-only E8M0FNU scalar |
| `0x0044` OCP | `0x0001` | FP4-E2M1FN | NUMERIC | Payload 上位 nibble の ONNX/DLPack E2M1FN scalar |
| `0x0060` BIPM | `0x4000` | [TAI-TIMESTAMP-SECONDS](/ja/grammar/value/time/tai-timestamp-seconds/) | TIME | `1970-01-01T00:00:00 TAI` からの signed SI-second 計数 |
| `0x0060` BIPM | `0x4001` | [TAI-TIMESTAMP-NANOSECONDS](/ja/grammar/value/time/tai-timestamp-nanoseconds/) | TIME | 同じ TAI epoch からの signed nanosecond 計数 |
| `0x0062` NIST | `0xC000` | [SHA-512-DIGEST](/ja/grammar/value/binary/sha-512-digest/) | BINARY | 固定 Payload 32 WORD の SHA-512 結果 |
| `0x0062` NIST | `0xC001` | [SHA3-256-DIGEST](/ja/grammar/value/binary/sha3-256-digest/) | BINARY | 固定 Payload 16 WORD の SHA3-256 結果 |
| `0x0063` GPS | `0x4000` | [GPS-TIMESTAMP-SECONDS](/ja/grammar/value/time/gps-timestamp-seconds/) | TIME | GPS epoch からの signed second 計数 |
| `0x0063` GPS | `0x4001` | [GPS-TIMESTAMP-NANOSECONDS](/ja/grammar/value/time/gps-timestamp-nanoseconds/) | TIME | GPS epoch からの signed nanosecond 計数 |

## Meta

`0001 1LLL LCCC CCCC` — [Meta](/ja/grammar/meta/)

Codec の上位3ビットがクラスだ。Meta には ISSUER コードがない。

| 上位3ビット | クラス | 直接コード | 扱うもの |
|---|---|---|---|
| `000` | [構造](/ja/grammar/meta/structure/) | `0x00`~`0x0F` | ドキュメントの境界と長さ |
| `001` | [定義](/ja/grammar/meta/declaration/) | `0x10`~`0x1F` | 解釈の宣言 |
| `010` | [出典](/ja/grammar/meta/provenance/) | `0x20`~`0x2F` | 誰が、いつ、どこで |
| `011` | [系譜](/ja/grammar/meta/lineage/) | `0x30`~`0x3F` | 何からどのように生まれたか |
| `100` | [検証](/ja/grammar/meta/verification/) | `0x40`~`0x4F` | 信頼できるか |
| `101` | [ポリシー](/ja/grammar/meta/policy/) | `0x50`~`0x5F` | どう扱うか |
| `110` | [IMPORT](/ja/grammar/meta/import/) | `0x60`~`0x6F` | 外部ドキュメントを IMPORT ID で取り込む (`IMPORT-DOC`) |
| `111` | Reserved | `0x70`~`0x7F` |  |

### 構造 (`000`)

| Codec | 名前 | 説明 |
|---|---|---|
| `0x00` | [DOC-1WORD](/ja/grammar/meta/structure/doc/) | 全体の長さを Payload 1 WORD で指定したドキュメント開始 |
| `0x01` | [DOC-2WORD](/ja/grammar/meta/structure/doc/) | 全体の長さを Payload 2 WORD で指定したドキュメント開始 |
| `0x02` | [DOC-4WORD](/ja/grammar/meta/structure/doc/) | 全体の長さを Payload 4 WORD で指定したドキュメント開始 |
| `0x03`~`0x0D` | Reserved |  |
| `0x0E` | [BODY](/ja/grammar/meta/structure/body/) | 1 WORD。ドキュメントの HEAD を終え、BODY を始める。 |
| `0x0F` | [END](/ja/grammar/meta/structure/end/) | 1 WORD。ドキュメントを閉じる。 |

### 定義 (`001`)

| Codec | 名前 | 説明 |
|---|---|---|
| `0x10` | [SPEC-VERSION](/ja/grammar/meta/declaration/spec-version/) | 従う GEUL 仕様の版。Payload がそのまま最短幅の unsigned 整数だ。v1 は `0x0001` (レコード `0x1890 0x0001`) |
| `0x11` | [PROFILE](/ja/grammar/meta/declaration/profile/) | 適用プロファイル |
| `0x12` | [DOC-ID](/ja/grammar/meta/declaration/doc-id/) | このドキュメントの識別子。組み込み Reference `DOC-POINTER`(Issuer、ドキュメント ID、バージョン 0) |
| `0x13` | [EFFECTIVE-FROM](/ja/grammar/meta/declaration/effective-from/) | このバージョンの施行日。GREGORIAN-DATE または POSIX-TIMESTAMP Value。なければ公表時刻 |
| `0x14` | [EFFECTIVE-UNTIL](/ja/grammar/meta/declaration/effective-until/) | このバージョンの有効期間の終わり(限時法)。なければ次のバージョンが施行されるまで |
| `0x15` | Reserved |  |
| `0x16` | [DEFAULT-LANGUAGE](/ja/grammar/meta/declaration/default-language/) | デフォルト言語 |
| `0x17`~`0x1F` | Reserved |  |

### 出典 (`010`)

| Codec | 名前 | 説明 |
|---|---|---|
| `0x20` | [AUTHOR](/ja/grammar/meta/provenance/author/) | 作成者。Reference (git author) |
| `0x21` | [CO-AUTHOR](/ja/grammar/meta/provenance/co-author/) | 共同作成者。Reference (git `Co-authored-by`) |
| `0x22` | [CREATED-AT](/ja/grammar/meta/provenance/created-at/) | 作成時刻。TIME Value (git author date) |
| `0x23` | [MODIFIED-AT](/ja/grammar/meta/provenance/modified-at/) | 修正時刻。TIME Value |
| `0x24` | [RECORDED-BY](/ja/grammar/meta/provenance/recorded-by/) | 記録した主体。Reference (git committer) |
| `0x25` | [RECORDED-AT](/ja/grammar/meta/provenance/recorded-at/) | 記録した時刻。TIME Value (git commit date) |
| `0x26`~`0x2F` | Reserved |  |

- 原典資料とその範囲・入手時刻・ハッシュは Meta ではなく、HEAD の根拠 Edge [SOURCE](/ja/grammar/edge/source/#ドキュメント全体の出典)(Target `0`)とその QUALIFIER で書く。

### 系譜 (`011`)

| Codec | 名前 | 説明 |
|---|---|---|
| `0x30` | [PARENT](/ja/grammar/meta/lineage/parent/) | 直前バージョンのコンテンツハッシュ (git parent)。なければ最初のバージョンで、複数ならマージだ(git merge commit)。 |
| `0x31` | [DERIVED-FROM](/ja/grammar/meta/lineage/derived-from/) | 他の系譜のレコード・資料から派生。外部資料の特定バージョンに固定するときは、HEAD の [SOURCE](/ja/grammar/edge/source/#ドキュメント全体の出典)に原文ハッシュ QUALIFIER(P4092)を付ける(git submodule)。 |
| `0x32` | [GENERATED-BY](/ja/grammar/meta/lineage/generated-by/) | 生成した主体。人、モデル、ルールエンジン |
| `0x33` | [TRANSFORMED-BY](/ja/grammar/meta/lineage/transformed-by/) | 変換方法。ツール・規則・バージョン |
| `0x34` | [CHERRY-PICKED-FROM](/ja/grammar/meta/lineage/cherry-picked-from/) | 他の系譜の変更を取り込んだ元バージョンのコンテンツハッシュ (git cherry-pick `-x`) |
| `0x35` | [REVERTS](/ja/grammar/meta/lineage/reverts/) | 変更を取り消した対象バージョンのコンテンツハッシュ (git revert) |
| `0x36` | [REPLACES](/ja/grammar/meta/lineage/replaces/) | 書き直した対象バージョンのコンテンツハッシュ (git amend・rebase)。元のバージョンは消さない。 |
| `0x37` | [SQUASHED-FROM](/ja/grammar/meta/lineage/squashed-from/) | 一つにまとめた元バージョンたちのコンテンツハッシュ (git squash) |
| `0x38` | [MESSAGE](/ja/grammar/meta/lineage/message/) | 変更理由。UTF8-LANGUAGE-TEXT Value、言語ごとに一つ (git commit message) |
| `0x39` | [TAG](/ja/grammar/meta/lineage/tag/) | バージョンに付けた不変の名前。TEXT Value とコンテンツハッシュ (git annotated tag) |
| `0x3A` | [DELTA-BASE](/ja/grammar/meta/lineage/delta-base/) | このバージョンのファイルは、同じドキュメントの基準バージョン(2 WORD バージョン ID)に対する diff だ (git packfile delta) |
| `0x3B` | [DELTA-REMOVE](/ja/grammar/meta/lineage/delta-remove/) | diff で基準 BODY から除く LOCAL ID(Edge Id)の一覧 |
| `0x3C` | [NEXT-LOCAL-ID](/ja/grammar/meta/lineage/next-local-id/) | 次に割り当てる LOCAL ID (auto increment)。バージョン一覧 `versions.geul` の HEAD に置く |
| `0x3D`~`0x3F` | Reserved |  |

### 検証 (`100`)

| Codec | 名前 | 説明 |
|---|---|---|
| `0x40` | [ISSUER-KEY](/ja/grammar/meta/verification/issuer-key/) | 自己発行 Issuer の署名アルゴリズム ID と公開鍵の宣言 |
| `0x41` | [SIGNATURE](/ja/grammar/meta/verification/signature/) | 対象に対する署名。ドキュメントに対する署名はコンテンツハッシュに署名する (git 署名コミット・タグ) |
| `0x42` | [SIGNED-OFF](/ja/grammar/meta/verification/signed-off/) | 貢献の権利の確認。Reference (git `Signed-off-by`, DCO) |
| `0x43` | [CONFIDENCE](/ja/grammar/meta/verification/confidence/) | 信頼度 |
| `0x44` | [VERDICT](/ja/grammar/meta/verification/verdict/) | ドキュメント全体の判定結果。Pass, Review, Fail。ノード・レコード単位は [TOULMIN](/ja/grammar/edge/toulmin/) `VERDICT`(Edge `0x78`) |
| `0x45`~`0x4F` | Reserved |  |

### ポリシー (`101`)

| Codec | 名前 | 説明 |
|---|---|---|
| `0x50` | [LICENSE](/ja/grammar/meta/policy/license/) | ライセンス。Reference |
| `0x51` | [ACCESS](/ja/grammar/meta/policy/access/) | 公開範囲 |
| `0x52` | [PRIVACY](/ja/grammar/meta/policy/privacy/) | 個人情報の等級 |
| `0x53` | [RETENTION](/ja/grammar/meta/policy/retention/) | 保存期限 |
| `0x54` | [CONSENT](/ja/grammar/meta/policy/consent/) | 同意の範囲と根拠 |
| `0x55` | [USAGE](/ja/grammar/meta/policy/usage/) | 使用制限 |
| `0x56`~`0x5F` | Reserved |  |

### IMPORT (`110`)

| Codec | 名前 | 説明 |
|---|---|---|
| `0x60` | [IMPORT-DOC](/ja/grammar/meta/import/import-doc/) | 外部ドキュメントを IMPORT ID で取り込む。組み込み Reference `DOC-POINTER` + IMPORT ID |
| `0x61`~`0x6F` | Reserved |  |
