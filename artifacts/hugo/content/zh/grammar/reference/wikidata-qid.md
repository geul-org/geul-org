---
title: "WIKIDATA-QID"
weight: 5
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "WIKIDATA-QID 是用 Q 标识符的数字指向 Wikidata 条目（Item）的声明 Reference。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

WIKIDATA-QID 是指向 Wikidata 条目（Item）的声明 Reference。把 Q 标识符去掉 `Q` 之后的数字部分，作为无符号整数书写。

## 布局

```
TAG WORD          0000 0LLL L010 0QQQ      CCCC = 0100
[Length 扩展 TAG]
QID               最短宽度的 unsigned big-endian
```

- QID 用最短宽度书写。`Q1`~`Q65535` 总共 2 WORD，更大的是 3 WORD。
- Wikidata 数据是 CC0。
- 如果是 Variable，则是该条目所指种类的匿名变量（[Reference](/zh/grammar/reference/) Variable）。

## 示例

| 条目 | WORD sequence |
|---|---|
| `Q5` (human) | `00A0 0005` |
| `Q76` (Barack Obama) | `00A0 004C` |
| `Q884` (South Korea) | `00A0 0374` |
| `Q317521` (Elon Musk) | `0120 0004 D851` |
| `Q30461` (president)，Variable | `00A4 76FD` |

## 相关页面

- [Reference](/zh/grammar/reference/)、[WIKIDATA-PID](/zh/grammar/reference/wikidata-pid/)、[TRIPLE](/zh/grammar/edge/triple/)
