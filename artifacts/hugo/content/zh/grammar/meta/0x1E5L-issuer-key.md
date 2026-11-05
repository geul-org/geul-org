---
title: "ISSUER-KEY (0x1E5L)"
weight: 485
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "声明自行签发（16 WORD）Issuer 的公钥。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `ISSUER-KEY`（规格文档 BIND `ISSUER-KEY`） |
| TAG ID | `0x1E5L` |
| Codec ID | `0x00001E50` |
| 规格文档 | `0x00000000/codecs/0x00001E50/`（DECLARE 对象 `1E50`） |
| 章节 | 15 `1111`（Meta），章节内偏移 C = 5 |
| Kind | Meta · 类：验证 |
| TAG WORD | `0001 1110 0101 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 自行签发 Issuer 的签名算法 ID 与公钥的声明 |
| Hugo 侧 | `meta/verification/issuer-key.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `algorithm` | #2 | 原始值 1 WORD |  | `0x0001` ed25519 |
| 2 | `key` | #3 | 剩余原始值（`0xFFFF`） |  |  |

声明自行签发（16 WORD）Issuer 的公钥。Issuer ID = SHA-256("GEUL-ISSUER-v1" ‖ 算法 ID ‖ 公钥)（[16 WORD Issuer](../issuer.md#16-word-issuer)）。

## 布局 {#레이아웃}

```
TAG WORD          0001 1110 0101 LLLL      Codec 0x1E5L
[Length 扩展 TAG]
算法 ID           1 WORD (0x0001 = Ed25519)
公钥              由算法决定的宽度 (Ed25519 16 WORD)
```

- Codec：Meta `0x1E5L`，验证类
- Payload：原始值（算法 ID + 公钥）
- 数量：可有多个（密钥更换）

## 解释与有效性 {#해석과-유효성}

- 属于验证类，因此不计入内容哈希。
- 2、4 WORD Issuer 使用在 geul.org 登记的密钥，因此不需要。

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00001E50/latest.geul` 的结果（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E5000000000
BODY
#1 DECLARE 0x1E50
#2 FIELD #1 0x0001
#3 FIELD #1 rest
#4 ENUM #2 0x0001
#5 BIND #1 "ISSUER-KEY"
#6 BIND #2 "algorithm"
#7 BIND #3 "key"
#8 BIND #4 "ed25519"
```
