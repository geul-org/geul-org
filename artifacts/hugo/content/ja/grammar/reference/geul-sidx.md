---
title: "GEUL-SIDX"
weight: 4
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "GEUL-SIDX は、ビット自体に意味を載せた GEUL SIDX(Semantic-aligned Index)で対象を指す宣言 Reference だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL-SIDX は、GEUL SIDX(Semantic-aligned Index)で対象を指す宣言 Reference だ。SIDX は、ビット自体に意味(種類、属性)を載せた識別子だ。

## レイアウト

```
TAG WORD          0000 0LLL L001 1QQQ      CCCC = 0011
[Length 拡張 TAG]
SIDX              残りすべて
```

- Quantifier は他の宣言 Codec と同じだ。Variable ならその種類の匿名変数だ([Reference](/ja/grammar/reference/) の Variable)。量化は `QQQ` でのみ行う。SIDX の値には量化を入れない。
- 規格ドキュメントは、SIDX を残り幅の生値フィールド一つとして宣言する。幅の規則が決まったら変える。

## 例

| SIDX | WORD sequence |
|---|---|
| (非規範) 64ビット `0x1234 5678 9abc def0`、Identified | `0218 1234 5678 9abc def0` |

## 割り当て方針

- [GEUL](/ja/grammar/reference/geul/) とは役割が異なる。GEUL はおおむね順番に(auto increment)割り当てる同一性 ID で、GEUL-SIDX は意味が近い対象に近い値を与える意味アドレスだ。
- 近さの度合いは、使用データを蓄積して統計で決める。統計が集まる前は GEUL ID を使い、SIDX を割り当てた後で、同じ対象の GEUL と GEUL-SIDX を [SAME-NODE](/ja/grammar/edge/same-node/) で結ぶ。

## 未解決の問題

- **幅。** 統計を見て決める。4 WORD(64ビット)と 16 WORD などを検討している。SIDX は上位ビットに意味があるので、他の宣言 Codec の「最短幅」規則(先頭の `0x0000` 禁止)をそのままは使えない。そのため固定幅(または下位形式ごとの固定幅)になるだろう。決まるまで、規格ドキュメントは SIDX を残り幅の生値として宣言する。
- **割り当ての安定性。** Reference は整数値が同じなら同じ対象で、割り当てた ID を再利用しない。統計が変わっても、すでに割り当てた SIDX を動かさないためには、append-only の割り当て(意味が近い場所を空けておく疎な割り当て)が必要だ。動かす必要が多いなら、SIDX を永続的な識別子ではなく、レジストリの版に結びついたインデックスとして定義するかを決める。
- **一意性。** SIDX がビットの意味で生成されて衝突しうるなら、「整数値が同じなら同じ対象」という前提と合わない。割り当てるときに衝突を解消して一意性を保証する。
- コードブックとレジストリの公開形式。

## 関連ページ

- [Reference](/ja/grammar/reference/)、[GEUL](/ja/grammar/reference/geul/)
