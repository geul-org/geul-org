---
title: "EFFECTIVE-UNTIL"
weight: 21
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "EFFECTIVE-UNTIL 是以日期·时间戳 Value 声明本版本有效期终点（有期限法规）的定义 Meta。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

声明本版本有效期的终点（有期限法规）。自该时刻起本版本不再施行。

## 布局

```
TAG WORD          0001 1LLL L001 0100      Codec 0x14
[Length 扩展 TAG]
Payload           一个 TIME Value
```

- Codec：Meta `0x14`，定义类（`001`）
- Payload：内置 Value（[GREGORIAN-DATE](/zh/grammar/value/time/gregorian-date/) 或 [POSIX-TIMESTAMP-SECONDS](/zh/grammar/value/time/posix-timestamp-seconds/)）
- 数量：至多一个

## 解读与有效性

- 没有它则在下一个版本施行之前一直有效。
- 有效期届满后，没有施行中的版本。旧版本不会复活。
