---
title: "RETENTION"
weight: 84
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "RETENTION 是以到期时刻或期间 Value 记录文档保存期限的策略 Meta。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

记录文档的保存期限。

## 布局

```
TAG WORD          0001 1LLL L101 0011      Codec 0x53
[Length 扩展 TAG]
Payload           到期时刻（GREGORIAN-DATE 等）或期间（DURATION-SECONDS）
```

- Codec：Meta `0x53`，策略类（`101`）
- Payload：内置 Value（TIME 系列：[GREGORIAN-DATE](/zh/grammar/value/time/gregorian-date/) 等，或 [DURATION-SECONDS](/zh/grammar/value/time/duration-seconds/)）
- 数量：至多一个

## 解读与有效性

- 若为期间，则从 [RECORDED-AT](/zh/grammar/meta/provenance/recorded-at/) 起算。
