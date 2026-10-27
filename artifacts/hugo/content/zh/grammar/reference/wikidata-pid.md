---
title: "WIKIDATA-PID"
weight: 6
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "WIKIDATA-PID 是用 P 标识符的数字指向 Wikidata 属性（Property）的声明 Reference。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

WIKIDATA-PID 是指向 Wikidata 属性（Property）的声明 Reference。把 P 标识符去掉 `P` 之后的数字部分，作为无符号整数书写。

## 布局

```
TAG WORD          0000 0LLL L010 1QQQ      CCCC = 0101
[Length 扩展 TAG]
PID               最短宽度的 unsigned big-endian
```

- PID 用最短宽度书写。目前的属性编号能放入 1 WORD，总共 2 WORD，超过 65535 后自然扩展为 3 WORD。
- 主要用在 [TRIPLE](/zh/grammar/edge/triple/) 的 Predicate、[QUALIFIER](/zh/grammar/edge/qualifier/) 的 Property 位置。

## 示例

| 属性 | WORD sequence |
|---|---|
| `P31` (instance of) | `00A8 001F` |
| `P279` (subclass of) | `00A8 0117` |
| `P569` (date of birth) | `00A8 0239` |

## 相关页面

- [Reference](/zh/grammar/reference/)、[WIKIDATA-QID](/zh/grammar/reference/wikidata-qid/)、[TRIPLE](/zh/grammar/edge/triple/)、[QUALIFIER](/zh/grammar/edge/qualifier/)
