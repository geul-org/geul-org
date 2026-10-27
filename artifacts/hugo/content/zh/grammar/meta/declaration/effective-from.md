---
title: "EFFECTIVE-FROM"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "EFFECTIVE-FROM 是以日期·时间戳 Value 声明本版本施行日的定义 Meta。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

声明本版本的施行日。施行日与公布时刻不同（[修订](/zh/grammar/document/#修订)）。

## 布局

```
TAG WORD          0001 1LLL L001 0011      Codec 0x13
[Length 扩展 TAG]
Payload           一个 TIME Value
```

- Codec：Meta `0x13`，定义类（`001`）
- Payload：内置 Value（[GREGORIAN-DATE](/zh/grammar/value/time/gregorian-date/) 或 [POSIX-TIMESTAMP-SECONDS](/zh/grammar/value/time/posix-timestamp-seconds/)）
- 数量：至多一个

## 解读与有效性

- 没有它则自公布时刻起施行。
- 若有 [EFFECTIVE-UNTIL](/zh/grammar/meta/declaration/effective-until/)，必须早于它。
- 各条文施行日不同时，在该条文 Edge 上以 QUALIFIER P580（开始）·P582（结束）另行记录（[SOURCE](/zh/grammar/edge/source/#其他依据的表示)）。
- 以特定时点为基准解读文档时读取此值。

## 示例

- 自 1970-01-02 施行：`0x1993 0x0920 0x0000 0x0001`
