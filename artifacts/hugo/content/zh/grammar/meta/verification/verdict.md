---
title: "VERDICT"
weight: 69
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "VERDICT 是以 1 WORD 记录整个文档判定结果（Pass、Review、Fail）的验证 Meta。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

记录整个文档的判定结果。节点·记录级别的判定由 [TOULMIN](/zh/grammar/edge/toulmin/) `VERDICT`（Edge `0x78`）负责。

## 布局

```
TAG WORD          0001 1LLL L100 0100      Codec 0x44
[Length 扩展 TAG]
判定              1 WORD (0 Pass, 1 Review, 2 Fail)
```

- Codec：Meta `0x44`，验证类（`100`）
- Payload：原始值（判定 1 WORD）
- 数量：至多一个

## 解读与有效性

- 属于验证类，所以不参与内容哈希。
- 对其他文档的判定，放在与判定对象不同的文档的 BODY 中。

## 未决问题

- 是否一并记录判定主体与依据。
