---
title: "CREATED-AT"
weight: 35
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "CREATED-AT 是以 TIME Value 记录文档创作时刻的出处 Meta（git author date）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

记录文档的创作时刻（git author date）。

## 布局

```
TAG WORD          0001 1LLL L010 0010      Codec 0x22
[Length 扩展 TAG]
Payload           一个 TIME Value (GREGORIAN-DATE, POSIX-TIMESTAMP-SECONDS 等)
```

- Codec：Meta `0x22`，出处类（`010`）
- Payload：内置 Value（TIME 系列：[GREGORIAN-DATE](/zh/grammar/value/time/gregorian-date/)、[POSIX-TIMESTAMP-SECONDS](/zh/grammar/value/time/posix-timestamp-seconds/) 等）
- 数量：至多一个

## 解读与有效性

- 格式从 TIME 系列 Value 中选择。需要精度时，使用 Issuer 定义的纳秒格式（例：[POSIX-TIMESTAMP-NANOSECONDS](/zh/grammar/value/time/posix-timestamp-nanoseconds/)）。
