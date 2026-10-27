---
title: "PRIVACY"
weight: 83
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "PRIVACY 是以 1 WORD 记录文档个人信息等级的策略 Meta。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

记录文档的个人信息等级。

## 布局

```
TAG WORD          0001 1LLL L101 0010      Codec 0x52
[Length 扩展 TAG]
等级              1 WORD
```

- Codec：Meta `0x52`，策略类（`101`）
- Payload：原始值（等级 1 WORD）
- 数量：至多一个

## 解读与有效性

- 不改变解读，只规定处理方式。

## 未决问题

- 等级码表（与个人信息保护法分类的对应）。
