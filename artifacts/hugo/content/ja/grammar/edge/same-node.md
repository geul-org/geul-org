---
title: "SAME-NODE"
weight: 2
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "SAME-NODE は、二つの Reference が同じ対象を指示すると宣言する、方向のない同一性の記述 Edge だ(Codec 0x01)。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SAME-NODE は、二つの Reference が同じ referent を指示すると宣言する、方向のない同一性の記述 Edge だ。Codec `0x01`。

二つの Reference レコードの byte エンコード、Codec、ID が同じという意味ではない。[REFERENCE-NODE](/ja/grammar/edge/reference-node/) が `Reference → レコード` の方向性バインディングであるのとは異なり、SAME-NODE は二つの Reference 間の同一性(referential identity)を表す。

## レイアウト

```
TAG WORD          0001 0LLL L000 0001
[Length 拡張 TAG]
Edge Id           LOCAL Reference レコード
Subject           Reference レコード 1個
Object            Reference レコード 1個
```

## 解釈と有効性

- Subject と Object はこの順序でシリアライズし、それぞれちょうど一つの完全な [Reference](/ja/grammar/reference/) レコードでなければならない。各レコードの Length で境界を見つける。
- Subject や Object が Value、Edge、不完全なレコードなら invalid だ。
- SAME-NODE の関係は反射的・対称的・推移的だ。wire の Subject/Object の順序は framing のためのもので、意味の方向を作らない。実装はこの関係を双方向に探索できなければならない。
- 異なる [LOCAL](/ja/grammar/reference/local/) ID は異なる Reference にすぎず、referent が同じか異なるかの証拠ではない。二つの Reference が同じ referent を指示することは、SAME-NODE で明らかにする。
- 解釈と推論は、その Edge を収めるドキュメントと判定グラフの出典、時点、world、policy scope を保存しなければならない。SAME-NODE を、文脈と無関係な全域マージの根拠として使わない。
- SAME-NODE があっても、元の Reference レコードや系譜を消したり上書きしたりしない。
- 同じ組に SAME-NODE と [DIFFERENT-NODE](/ja/grammar/edge/different-node/) が併存しても、wire が invalid になるわけではない。各主張の文脈を保存して、衝突として評価する。
- Variable Reference を Identified Reference と SAME-NODE で結んで、変数を解決する([Reference](/ja/grammar/reference/) の Variable)。

## 長さ

```
全体 = 1 + N_len + N_id + N_subject + N_object WORD
```

## 例 (非規範)

Edge Id `0009`、Subject は LOCAL 1、Object は LOCAL 2 だ。

- Edge は TAG 1 + Edge Id 2 + Subject 2 + Object 2 = 7 WORD、`LLLL=0110` だ。TAG は `0001 0 0110 0000001` = `1301` だ。

```
1301 0088 0009 0088 0001 0088 0002
```

## 関連ページ

- [Edge](/ja/grammar/edge/)、[REFERENCE-NODE](/ja/grammar/edge/reference-node/)、[DIFFERENT-NODE](/ja/grammar/edge/different-node/)
- [Reference](/ja/grammar/reference/)、[LOCAL](/ja/grammar/reference/local/)
