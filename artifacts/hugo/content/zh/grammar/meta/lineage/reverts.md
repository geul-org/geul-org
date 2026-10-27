---
title: "REVERTS"
weight: 54
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "REVERTS 是记录被撤销变更的目标版本内容哈希的谱系 Meta（git revert）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

记录被撤销变更的目标版本的内容哈希（git revert）。

## 布局

```
TAG WORD          0001 1LLL L011 0101      Codec 0x35
[Length 扩展 TAG]
Payload           一个 SHA-256-DIGEST Value (16 WORD)
```

- Codec：Meta `0x35`，谱系类（`011`）
- Payload：内置 Value（[SHA-256-DIGEST](/zh/grammar/value/binary/sha-256-digest/)）
- 数量：可有多个

## 解读与有效性

- 把摘要格式作为 Value 内置，为将来更换哈希算法留有余地。目前内容哈希只有 SHA-256。
