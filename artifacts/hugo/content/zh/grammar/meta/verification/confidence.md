---
title: "CONFIDENCE"
weight: 68
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "CONFIDENCE 是以 0 到 1 之间的小数 Value 记录整个文档可信度的验证 Meta。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

记录整个文档的可信度。记录级别的可信度，用附在目标 Edge 上的 QUALIFIER 来写（属性未定，[SOURCE](/zh/grammar/edge/source/#其他依据的表示)）。

## 布局

```
TAG WORD          0001 1LLL L100 0011      Codec 0x43
[Length 扩展 TAG]
Payload           UNSIGNED-DECIMAL Value，0 以上 1 以下
```

- Codec：Meta `0x43`，验证类（`100`）
- Payload：内置 Value（[UNSIGNED-DECIMAL](/zh/grammar/value/decimal/unsigned-decimal/)）
- 数量：至多一个

## 解读与有效性

- 该值由谁给出，用 [GENERATED-BY](/zh/grammar/meta/lineage/generated-by/) 等一并记录。

## 未决问题

- 刻度（0~1）及其与 TOULMIN 判定的关系。
