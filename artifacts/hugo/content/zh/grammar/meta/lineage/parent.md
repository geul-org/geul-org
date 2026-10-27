---
title: "PARENT"
weight: 49
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "PARENT 是记录上一版本内容哈希的谱系 Meta（git parent）。有多个则为合并。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

记录上一版本的内容哈希（git parent）。

## 布局

```
TAG WORD          0001 1LLL L011 0000      Codec 0x30
[Length 扩展 TAG]
Payload           一个 SHA-256-DIGEST Value (16 WORD)
```

- Codec：Meta `0x30`，谱系类（`011`）
- Payload：内置 Value（[SHA-256-DIGEST](/zh/grammar/value/binary/sha-256-digest/)）
- 数量：可有多个（合并）

## 解读与有效性

- 没有它则为最初版本，有多个则为合并（git merge commit）。
- 它计入[内容哈希](/zh/grammar/document/#内容哈希)，所以全部历史成为一条哈希链。
- 版本列表文档指向上一个列表文档（[PUBLICATION](/zh/grammar/edge/publication/)）。
- 把摘要格式作为 Value 内置，为将来更换哈希算法留有余地。目前内容哈希只有 SHA-256。

## 示例

- `0x1F30 0x0014 0x0F61 0x0012 <16 WORD>`（Meta 20 WORD = TAG + Length 扩展 + 内置 Value 18 WORD）
