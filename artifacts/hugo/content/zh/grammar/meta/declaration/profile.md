---
title: "PROFILE"
weight: 18
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "PROFILE 是以名称和版本文本声明文档所适用 Profile 的定义 Meta。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

声明文档所适用的 Profile。同样的记录按 Profile 规定的 Codec 文档解读（例：`tangeul-1.0` 则按 [TOULMIN](/zh/grammar/edge/toulmin/)）。

## 布局

```
TAG WORD          0001 1LLL L001 0001      Codec 0x11
[Length 扩展 TAG]
Payload           UTF8-TEXT Value "<名称>-<major>.<minor>"
```

- Codec：Meta `0x11`，定义类（`001`）
- Payload：内置 Value（[UTF8-TEXT](/zh/grammar/value/text/utf8-text/)）
- 数量：至多一个

## 解读与有效性

- major 不同的 Profile 予以拒绝。允许 minor 不同（仅限增量变更）。
- 没有 Profile 时，仅凭 GEUL 基本语法和直接码规范来读取。

## 示例

- `tangeul-1.0`：`0x1B91 0x0B41 7461 6e67 6575 6c2d 312e 3000`

## 未决问题

- Profile 名称注册表（geul.org）与命名规则。
- Profile 是用文档 ID 指向（IMPORT），还是以文本放置。
