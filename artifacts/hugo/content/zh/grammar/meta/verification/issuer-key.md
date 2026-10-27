---
title: "ISSUER-KEY"
weight: 65
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "ISSUER-KEY 是声明自行颁发（16 WORD）Issuer 的签名算法 ID 与公钥的验证 Meta。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

声明自行颁发（16 WORD）Issuer 的公钥。Issuer ID = SHA-256("GEUL-ISSUER-v1" ‖ 算法 ID ‖ 公钥)（[16 WORD Issuer](/zh/grammar/issuer/#16-word-issuer)）。

## 布局

```
TAG WORD          0001 1LLL L100 0000      Codec 0x40
[Length 扩展 TAG]
算法 ID           1 WORD (0x0001 = Ed25519)
公钥              宽度由算法决定 (Ed25519 16 WORD)
```

- Codec：Meta `0x40`，验证类（`100`）
- Payload：原始值（算法 ID + 公钥）
- 数量：可有多个（密钥轮换）

## 解读与有效性

- 属于验证类，所以不参与内容哈希。
- 1·2·4 WORD Issuer 使用在 geul.org 注册的密钥，因此不需要它。
