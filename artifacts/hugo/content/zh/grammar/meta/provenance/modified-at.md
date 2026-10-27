---
title: "MODIFIED-AT"
weight: 36
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "MODIFIED-AT 是以 TIME Value 记录文档修改时刻的出处 Meta。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

记录文档的修改时刻。

## 布局

```
TAG WORD          0001 1LLL L010 0011      Codec 0x23
[Length 扩展 TAG]
Payload           一个 TIME Value (GREGORIAN-DATE, POSIX-TIMESTAMP-SECONDS 等)
```

- Codec：Meta `0x23`，出处类（`010`）
- Payload：内置 Value（TIME 系列：[GREGORIAN-DATE](/zh/grammar/value/time/gregorian-date/)、[POSIX-TIMESTAMP-SECONDS](/zh/grammar/value/time/posix-timestamp-seconds/) 等）
- 数量：至多一个

## 解读与有效性

- 格式从 TIME 系列 Value 中选择。需要精度时，使用 Issuer 定义的纳秒格式（例：[POSIX-TIMESTAMP-NANOSECONDS](/zh/grammar/value/time/posix-timestamp-nanoseconds/)）。
