---
title: "LINK"
weight: 105
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "LINK は TOULMIN ノード間の関係(攻撃、排除、実行、判定の接続、定義、名前)を書くレイアウトだ。src・dst REF と flag WORD、任意の確信度ゲート、SPAN からなる。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LINK は、TOULMIN グラフでノード間の関係を書くレイアウトだ。関係の種類は Codec(または GEUL ISSUER 形式番号)が決める。

## Codec

| Codec | 名前 | TANGEUL | src → dst |
|---|---|---|---|
| `0x68` | ATTACKS | `don't X when Y` | 規則 → 規則。判定を漸進的に削る |
| `0x69` | SUPERSEDES | `X supersedes Y` | 規則 → 規則。Active なら対象を集計から除く |
| `0x70` | RUN | `run c when n` | 規則 → 事案 |
| `0x71` | DO | `do fn when n` | 規則 → FuncRef |
| `0x72` | DO-ONCE | `do fn once when n` | 規則 → FuncRef |
| `0x73` | UNDO | `undo fn when n` | 規則 → FuncRef |
| `0x74` | CHECKING | `checking c` | 規則 → 事案。副作用のない判定 |
| ISSUER `0x0000`/`0xC020` | REQUIRES | `f is required` | 事案 → フィールド |
| ISSUER `0x0000`/`0xC021` | MEANS | Definitions `means` | 定義項目 → 値・型 |
| ISSUER `0x0000`/`0xC022` | HAS | Definitions `has` | 定義項目 → フィールド |
| ISSUER `0x0000`/`0xC023` | RUNS | エントリポイント `run c` | エントリポイント → 事案(実行) |
| ISSUER `0x0000`/`0xC024` | EVALUATES | エントリポイント `check c` | エントリポイント → 事案(判定) |
| ISSUER `0x0000`/`0xC025` | TRIGGERS | トリガー `run c` | トリガー → 事案 |
| ISSUER `0x0000`/`0xC026` | UNTIL | `every … until c` | トリガー → 事案 |
| ISSUER `0x0000`/`0xC027` | SAME-AS | | ノード → グローバル識別子 |
| ISSUER `0x0000`/`0xC028` | IMPORTED-FROM | `see a from path` | 別名 → パス(TEXT) |
| ISSUER `0x0000`/`0xC029` | LABEL | バッククォート名 | ノード → TEXT。名前表記 |

## レイアウト

```
ID               LOCAL Reference レコード (Edge Id)
src              REF
dst              REF。DO・DO-ONCE・UNDO は FuncRef
flags 1 WORD     b0 F_ONCE, b1 F_GATE, b2 F_STRIKE, b3 F_ORDERED
[F_GATE]         演算子 1 WORD(上位2ビット) + UNSIGNED-DECIMAL Value(パーセント)
SPAN             SOURCE が定めた幅 × 2
```

| flag | 意味 |
|---|---|
| b0 F_ONCE | 一度だけ行う(UNDO の `once`) |
| b1 F_GATE | 確信度ゲートのフィールドがある |
| b2 F_STRIKE | 取り消し線で消した関係だ |
| b3 F_ORDERED | `1.` の順序付きリストに属する |

| ゲート演算子 | 意味 |
|---|---|
| 0 | at least |
| 1 | above |
| 2 | less than |
| 3 | at most |

## 解釈と有効性

- REF は、このドキュメントのレコードの Edge Id だ([TOULMIN](/ja/grammar/edge/toulmin/#共通フィールド)の共通フィールド)。
- dst の形は Codec が決める。DO・DO-ONCE・UNDO は FuncRef(REF(ALIAS、なければ 0)+ VerbCode 1 WORD、[NODE](/ja/grammar/edge/toulmin/node/#フィールド))、LABEL・IMPORTED-FROM は TEXT レコードの REF、残りはノードの REF だ。
- `do … once` は DO-ONCE Codec が表す。DO-ONCE の flags には F_ONCE を使わない(立っていれば拒否する)。UNDO の `once` は F_ONCE で書く。
- ゲート演算子は演算子 WORD の上位2ビットで、残りの14ビットは 0 だ。パーセントは `E=0` の UNSIGNED-DECIMAL Value で、0~100 だ。
- flags の b4~b15 は予約で、0 でなければならない。そうでなければ拒否する。
- SUPERSEDES のチェーン `A > B > C` は、組ごとに SUPERSEDES を一つずつ書く。

## 関連ページ

- [TOULMIN](/ja/grammar/edge/toulmin/)、[NODE](/ja/grammar/edge/toulmin/node/)、[SOURCE と区画](/ja/grammar/edge/toulmin/source/)
- [UNSIGNED-DECIMAL](/ja/grammar/value/decimal/unsigned-decimal/)
