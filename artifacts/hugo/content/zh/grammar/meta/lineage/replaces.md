---
title: "REPLACES"
weight: 55
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "REPLACES 是记录被改写的目标版本内容哈希的谱系 Meta（git amend·rebase）。不删除原版本。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

记录被改写的目标版本的内容哈希（git amend·rebase）。

## 布局

```
TAG WORD          0001 1LLL L011 0110      Codec 0x36
[Length 扩展 TAG]
Payload           一个 SHA-256-DIGEST Value (16 WORD)
```

- Codec：Meta `0x36`，谱系类（`011`）
- Payload：内置 Value（[SHA-256-DIGEST](/zh/grammar/value/binary/sha-256-digest/)）
- 数量：可有多个

## 解读与有效性

- 不删除原版本（保留旧法）。
- 把摘要格式作为 Value 内置，为将来更换哈希算法留有余地。目前内容哈希只有 SHA-256。
