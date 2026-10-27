---
title: "WIKIDATA-PID"
weight: 6
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "WIKIDATA-PID は、Wikidata プロパティ(Property)を P ID の数字で指す宣言 Reference だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

WIKIDATA-PID は、Wikidata プロパティ(Property)を指す宣言 Reference だ。P ID から `P` を除いた数字部分を、符号なし整数で書く。

## レイアウト

```
TAG WORD          0000 0LLL L010 1QQQ      CCCC = 0101
[Length 拡張 TAG]
PID               最短幅の unsigned big-endian
```

- PID は最短幅で書く。今のプロパティ番号は 1 WORD に収まって全体で 2 WORD で、65535 を超えれば自然に 3 WORD に増える。
- [TRIPLE](/ja/grammar/edge/triple/) の Predicate、[QUALIFIER](/ja/grammar/edge/qualifier/) の Property の位置に主に使う。

## 例

| プロパティ | WORD sequence |
|---|---|
| `P31` (instance of) | `00A8 001F` |
| `P279` (subclass of) | `00A8 0117` |
| `P569` (date of birth) | `00A8 0239` |

## 関連ページ

- [Reference](/ja/grammar/reference/)、[WIKIDATA-QID](/ja/grammar/reference/wikidata-qid/)、[TRIPLE](/ja/grammar/edge/triple/)、[QUALIFIER](/ja/grammar/edge/qualifier/)
