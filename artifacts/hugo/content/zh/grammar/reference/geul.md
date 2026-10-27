---
title: "GEUL"
weight: 3
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "GEUL 是用 geul.org 以 CC0 签发的实体 ID 指向目标的声明 Reference。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL 是指向 geul.org 以 CC0 签发的实体的声明 Reference。是编号中不承载语义的流水号 ID。在比特中承载语义的标识符由另一个 Codec [GEUL-SIDX](/zh/grammar/reference/geul-sidx/)（`0011`）负责。

## 布局

```
TAG WORD          0000 0LLL L001 0QQQ      CCCC = 0010
[Length 扩展 TAG]
GEUL ID           最短宽度的 unsigned big-endian
```

- 小编号分配给高频实体。能放入 1 WORD 的 ID 总共是 2 WORD。
- ID 分配和注册表由 geul.org 管理。注册表中只放来自 CC0 来源的内容。
- 如果是 Variable，则是该种类的匿名变量（[Reference](/zh/grammar/reference/) Variable）。

## 示例

| GEUL ID | WORD sequence |
|---|---|
| 1，Identified | `0090 0001` |
| 1，Variable | `0094 0001` |
| 70000，Generic | `0111 0001 1170` |

## 未决问题

- GEUL ID 分配规则与注册表公开格式。

## 相关页面

- [Reference](/zh/grammar/reference/)、[GEUL-SIDX](/zh/grammar/reference/geul-sidx/)
