---
title: "NODE"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "NODE は TOULMIN グラフのノード(事案、規則、定義、エントリポイント、トリガー、関数、フィールド、別名、グループ)を書くレイアウトだ。ヘッダ 1 WORD の flag が、続く条件付きフィールドを決める。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

NODE は、TOULMIN の判定・実行グラフのノードを書くレイアウトだ。ノードの種類は Codec(または GEUL ISSUER 形式番号)が決め、ヘッダ 1 WORD が役割・Level・Claim の形と条件付きフィールドを決める。

## Codec

| Codec | 名前 | TANGEUL | ノード |
|---|---|---|---|
| `0x60` | CASE-DECLARE | `in case of` | 事案 |
| `0x62` | SPEC-DECLARE | Definitions 項目(`means`, `has`) | 判断基準(Backing)。role が定義の種類 |
| `0x63` | RULE-DECLARE | general rule | 主張(Warrant) |
| `0x64` | COUNTER-DECLARE | counter rule | 反駁(Rebuttal) |
| `0x65` | EXCEPT-DECLARE | except rule | 例外(Defeater) |
| `0x75` | ENTRY | `provides x` | 外部エントリポイント |
| `0x76` | TRIGGER | `on`, `every`, `until` | イベント・周期のエントリポイント |
| ISSUER `0x0000`/`0xC010` | NAMESPACE | `this document is` | ドキュメント名前空間 |
| ISSUER `0x0000`/`0xC011` | FUNC | 関数参照 | 外部関数(例: `bank.withdraw`) |
| ISSUER `0x0000`/`0xC012` | FIELD | `x is required [as Type]` | 必須フィールド |
| ISSUER `0x0000`/`0xC013` | ALIAS | `see a from path` | 取り込んだパッケージの別名 |
| ISSUER `0x0000`/`0xC014` | GROUP | `1.` 順序付きリスト | 順序のある実行のまとまり |

ISSUER 形式は、`ISSUER-1WORD`(`0x7C`)の後ろの Codec 拡張 TAG に、Issuer `0x0000` と形式番号を置く([TOULMIN](/ja/grammar/edge/toulmin/))。

## レイアウト

```
ID               LOCAL Reference レコード (Edge Id)
ヘッダ 1 WORD    role 2b | 予約 2b | F_GROUNDS 1b | level 2b | object 種類 2b | flags 7b
[F_FUNC]         FuncRef: REF(ALIAS、なければ 0) + VerbCode 1 WORD
[F_QUAL]         SIGNED-DECIMAL Value。Qualifier
[F_CHECK]        REF(事案)
[F_CLAIM]        Claim: REF(subject) + predicate 1 WORD + object + mode 1 WORD
[F_VERDICT]      SIGNED-DECIMAL Value。判定値の初期値
[F_WITH]         個数(UNSIGNED-INTEGER Value) + REF(TEXT) × 個数
[F_GROUNDS]      個数(UNSIGNED-INTEGER Value) + REF(TEXT) × 個数
SPAN             SOURCE が定めた幅 × 2 (開始バイト、バイト数)
```

### ヘッダ WORD

| ビット | フィールド | 値 |
|---|---|---|
| 15–14 | role | 0 general, 1 counter, 2 except |
| 13–12 | 予約 | 0 |
| 11 | F_GROUNDS | 根拠リストがある |
| 10–9 | level | 0 Unset, 1 Fail, 2 Review (3 予約) |
| 8–7 | object 種類 | Claim の object の形。0 REF, 1 UNSIGNED-INTEGER Value, 2 SPAN |
| 6–0 | flags | 下の表 |

| ビット | flag | 意味 |
|---|---|---|
| b0 | F_FUNC | FuncRef フィールドがある |
| b1 | F_QUAL | Qualifier フィールドがある |
| b2 | F_CHECK | `checking` 対象の事案フィールドがある |
| b3 | F_CLAIM | Claim フィールドがある |
| b4 | F_VERDICT | 判定値の初期値フィールドがある |
| b5 | F_STRIKE | 取り消し線で消した宣言だ。フィールドはない |
| b6 | F_WITH | 基準リストのフィールドがある |

- 条件付きフィールドは、flag の順序(F_FUNC、F_QUAL、F_CHECK、F_CLAIM、F_VERDICT、F_WITH、F_GROUNDS)で置く。flag が立っていないフィールドは位置を占めない。
- flag が立っているのにフィールドがなければ拒否する。フィールドを順に読んだ位置は、SPAN の後ろでレコードの終わりとちょうど合わなければならない。

## フィールド

| フィールド | 説明 |
|---|---|
| FuncRef | 関数の位置。REF はその関数を取り込んだ ALIAS レコードで、このドキュメントの関数なら `0` だ。VerbCode は 1 WORD のコードで、まだ割り当てていない(`0x0000` を許容)。関数の原文表記は TEXT + [LABEL](/ja/grammar/edge/toulmin/link/) で別に書く |
| Qualifier | ノードの確信度(0~1) |
| 事案 | F_CHECK: このノードが判定だけを行う事案(`checking c`) |
| Claim | ノードが収める命題。subject REF、predicate 1 WORD、object、mode 1 WORD。object の形はヘッダの object 種類が決める |
| 判定値 | 判定値の初期値(−1~1) |
| F_WITH | 宣言時点の判定基準(`기준으로 하는`、「基準とする」)。TEXT レコードの REF リスト |
| F_GROUNDS | 評価時点で解釈する外部の事実の名前(`근거로 하는`、「根拠とする」)。TEXT レコードの REF リスト |
| SPAN | この宣言が出てきた原文の範囲 |

- 判定値・Qualifier の表記は、[TOULMIN](/ja/grammar/edge/toulmin/#数値) の数値規則に従う。
- リストの個数は、組み込みの [UNSIGNED-INTEGER](/ja/grammar/value/numeric/unsigned-integer/) Value レコードだ。
- 叙述 Claim の基本形は、subject・predicate が `0` で、object が SPAN(object 種類 2)だ。原文表記に固定する。

## 解釈と有効性

- role は、RULE・COUNTER・EXCEPT-DECLARE では Codec と同じでなければならない(0 general、1 counter、2 except)。SPEC-DECLARE では定義の種類だ。それ以外の Codec では 0 だ。
- level が 0(Unset)なら、エンジンの既定値を使う: COUNTER-DECLARE は Fail、EXCEPT-DECLARE は Review。
- TANGEUL `tangl:규칙`(「規則」)のホスト関数規則(`쓰는 규칙이다`、「使う規則だ」)は、事案の外の RULE-DECLARE NODE で書く。関数は F_FUNC、基準は F_WITH、根拠は F_GROUNDS だ。条件式の規則だけが前に [PREDICATE-DECLARE](/ja/grammar/edge/toulmin/expr/) を置く。
- 予約ビット(13–12)は 0 でなければならない。予約ビットが立っていたり、role が Codec と合わなければ拒否する。

## 関連ページ

- [TOULMIN](/ja/grammar/edge/toulmin/)、[LINK](/ja/grammar/edge/toulmin/link/)、[EXPR](/ja/grammar/edge/toulmin/expr/)、[SOURCE と区画](/ja/grammar/edge/toulmin/source/)
- [LOCAL](/ja/grammar/reference/local/)、[SIGNED-DECIMAL](/ja/grammar/value/decimal/signed-decimal/)
