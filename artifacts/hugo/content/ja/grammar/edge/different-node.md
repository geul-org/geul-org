---
title: "DIFFERENT-NODE"
weight: 3
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DIFFERENT-NODE は、二つの Reference が互いに異なる対象を指示するという非同一性の記述 Edge だ(Codec 0x02)。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DIFFERENT-NODE は、二つの Reference が互いに異なる referent を指示するという非同一性の記述 Edge だ。Codec `0x02`。

二つの Reference レコードの byte エンコード、Codec、ID が異なるという意味ではない。[REFERENCE-NODE](/ja/grammar/edge/reference-node/) の方向性バインディング、[SAME-NODE](/ja/grammar/edge/same-node/) の同一性と区別する。

## レイアウト

```
TAG WORD          0001 0LLL L000 0010
[Length 拡張 TAG]
Edge Id           LOCAL Reference レコード
Subject           Reference レコード 1個
Object            Reference レコード 1個
```

## 解釈と有効性

- Subject と Object は、それぞれちょうど一つの完全な [Reference](/ja/grammar/reference/) レコードでなければならない。各レコードの Length で境界を見つけ、Value や Edge であったり不完全であれば invalid だ。
- Subject と Object は互いに異なる referent を指示する。Reference レコードの byte 列、Codec、ID の違いだけで referent が異なると推論しない。
- 特に、異なる [LOCAL](/ja/grammar/reference/local/) ID は異なる Reference にすぎず、現実の referent まで異なるという意味ではない。LOCAL ID の違いだけから DIFFERENT を導かない。
- 非同一性は対称的で、非反射的で、推移的ではない。`DIFFERENT(A, B)` は `DIFFERENT(B, A)` と同じ関係だ。しかし `DIFFERENT(A, B)` と `DIFFERENT(B, C)` から `DIFFERENT(A, C)` を推論しない。
- wire の Subject/Object の順序は framing のためのシリアライズ順序にすぎず、意味の方向を作らない。実装は双方向に探索できなければならない。
- 二つの構成要素を読み終えたカーソルは、Edge の終わりとちょうど合わなければならない。

関係自体は非反射的だが、構造的に valid な `DIFFERENT(A, A)` の主張や、SAME と DIFFERENT が衝突する主張を、wire 文法のエラーとして消してはならない。このような主張は、文脈と系譜を保存し、判定層で矛盾として扱う。DIFFERENT を解釈したり導いたりするときは、その Edge を収めるドキュメントの出典、時点、world、policy scope を保存し、これらを無視した全域的な結論に広げない。

## 長さ

```
全体 = 1 + N_len + N_id + N_subject + N_object WORD
```

## 例 (非規範)

Edge Id `000a`、Subject は LOCAL 1、Object は LOCAL 2 だ。

- Edge は TAG 1 + Edge Id 2 + Subject 2 + Object 2 = 7 WORD、`LLLL=0110` だ。TAG は `0001 0 0110 0000010` = `1302` だ。

```
1302 0088 000a 0088 0001 0088 0002
```

この例の LOCAL ID の違いは、エンコードを示すためのものにすぎない。ID 1 と ID 2 が互いに異なる referent を指示するという主張が別にあるときにだけ、この sequence を DIFFERENT-NODE にする。

## 関連ページ

- [Edge](/ja/grammar/edge/)、[REFERENCE-NODE](/ja/grammar/edge/reference-node/)、[SAME-NODE](/ja/grammar/edge/same-node/)
- [Reference](/ja/grammar/reference/)、[LOCAL](/ja/grammar/reference/local/)
