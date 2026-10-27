---
title: "SIGNED-OFF"
weight: 67
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "SIGNED-OFF 是以 Reference 记录贡献权利确认的验证 Meta（git Signed-off-by，DCO）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

贡献权利确认（git `Signed-off-by`，DCO）。

## 布局

```
TAG WORD          0001 1LLL L100 0010      Codec 0x42
[Length 扩展 TAG]
Payload           一个 Reference
```

- Codec：Meta `0x42`，验证类（`100`）
- Payload：内置 Reference
- 数量：可有多个

## 解读与有效性

- geul.org 公布的文档中不放置指向自然人的 Reference（[Issuer 与公布](/zh/grammar/issuer/#geulorg-公布)）。指向组织·Issuer。例外是允许用 [WIKIDATA-QID](/zh/grammar/reference/wikidata-qid/) 指向自然人。
