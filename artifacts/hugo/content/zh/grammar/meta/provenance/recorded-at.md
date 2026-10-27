---
title: "RECORDED-AT"
weight: 38
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "RECORDED-AT 是以 TIME Value 记录文档被记录时刻的出处 Meta（git commit date）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

记录文档被记录的时刻（git commit date）。

## 布局

```
TAG WORD          0001 1LLL L010 0101      Codec 0x25
[Length 扩展 TAG]
Payload           一个 TIME Value (GREGORIAN-DATE, POSIX-TIMESTAMP-SECONDS 等)
```

- Codec：Meta `0x25`，出处类（`010`）
- Payload：内置 Value（TIME 系列：[GREGORIAN-DATE](/zh/grammar/value/time/gregorian-date/)、[POSIX-TIMESTAMP-SECONDS](/zh/grammar/value/time/posix-timestamp-seconds/) 等）
- 数量：至多一个

## 解读与有效性

- 格式从 TIME 系列 Value 中选择。需要精度时，使用 Issuer 定义的纳秒格式（例：[POSIX-TIMESTAMP-NANOSECONDS](/zh/grammar/value/time/posix-timestamp-nanoseconds/)）。
- 版本列表文档（[PUBLICATION](/zh/grammar/edge/publication/)）把此值用作公布·废弃（deprecate）·删除的时刻。

## 未决问题

- 出处 Meta 会计入内容哈希。是否允许同样的内容因在不同时刻记录而哈希不同。
