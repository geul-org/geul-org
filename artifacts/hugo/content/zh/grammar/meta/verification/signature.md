---
title: "SIGNATURE"
weight: 66
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "SIGNATURE 是以算法 ID、签名者、签名记录对文档内容哈希之签名的验证 Meta。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

对文档内容哈希的签名（git 签名提交·标签）。

## 布局

```
TAG WORD          0001 1LLL L100 0001      Codec 0x41
[Length 扩展 TAG]
算法 ID           1 WORD (0x0001 = Ed25519)
签名者            ISSUER-POINTER(Issuer) Reference 记录
签名              其余全部。宽度由算法决定 (Ed25519 32 WORD)
```

- Codec：Meta `0x41`，验证类（`100`）
- Payload：算法 ID（原始值 1 WORD）+ 签名者（内置 Reference）+ 签名（原始值，其余部分）
- 数量：可有多个

## 解读与有效性

- 签名对象是内容哈希。不是只对 BODY 签名（[签名](/zh/grammar/issuer/#签名)）。
- 属于验证类，所以不参与内容哈希。追加签名后哈希不变。
- 验证方式不是"有签名就确认"，而是"必须有指定密钥的签名"。
- 版本列表文档由公布方签名。
- 签名者是指向 Issuer 自身的 [ISSUER-POINTER](/zh/grammar/reference/issuer-pointer/)（Issuer）。它是 Reference 记录，以自身 Length 结束，所以即使签名宽度因算法而异，布局也是唯一确定的（[DECLARE](/zh/grammar/edge/declare/) 其余字段）。
- 签名的 WORD 数与算法规定的宽度不同则无效。

## 未决问题

- 是否连同签名时刻一并签名。
