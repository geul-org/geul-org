---
title: "WIKIDATA-QID"
weight: 5
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "WIKIDATA-QID は、Wikidata 項目(Item)を Q ID の数字で指す宣言 Reference だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

WIKIDATA-QID は、Wikidata 項目(Item)を指す宣言 Reference だ。Q ID から `Q` を除いた数字部分を、符号なし整数で書く。

## レイアウト

```
TAG WORD          0000 0LLL L010 0QQQ      CCCC = 0100
[Length 拡張 TAG]
QID               最短幅の unsigned big-endian
```

- QID は最短幅で書く。`Q1`~`Q65535` は全体で 2 WORD、それより上は 3 WORD だ。
- Wikidata のデータは CC0 だ。
- Variable ならその項目が指す種類の匿名変数だ([Reference](/ja/grammar/reference/) の Variable)。

## 例

| 項目 | WORD sequence |
|---|---|
| `Q5` (human) | `00A0 0005` |
| `Q76` (Barack Obama) | `00A0 004C` |
| `Q884` (South Korea) | `00A0 0374` |
| `Q317521` (Elon Musk) | `0120 0004 D851` |
| `Q30461` (president)、Variable | `00A4 76FD` |

## 関連ページ

- [Reference](/ja/grammar/reference/)、[WIKIDATA-PID](/ja/grammar/reference/wikidata-pid/)、[TRIPLE](/ja/grammar/edge/triple/)
