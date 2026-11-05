---
title: "SIGNATURE (0x1E6L)"
weight: 486
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "对文档内容哈希的签名（git 签名提交、标签）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `SIGNATURE`（规格文档 BIND `SIGNATURE`） |
| TAG ID | `0x1E6L` |
| Codec ID | `0x00001E60` |
| 规格文档 | `0x00000000/codecs/0x00001E60/`（DECLARE 对象 `1E60`） |
| 章节 | 15 `1111`（Meta），章节内偏移 C = 6 |
| Kind | Meta · 类：验证 |
| TAG WORD | `0001 1110 0110 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 对对象的签名。对文档的签名是对内容哈希签名（git 签名提交、标签） |
| Hugo 侧 | `meta/verification/signature.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `algorithm` | #2 | 原始值 1 WORD |  | `0x0001` ed25519 |
| 2 | `signer` | #3 | 记录 | `0400` ISSUER-POINTER |  |
| 3 | `signature` | #4 | 剩余原始值（`0xFFFF`） |  |  |

这是对文档内容哈希的签名（git 签名提交、标签）。

## 布局 {#레이아웃}

```
TAG WORD          0001 1110 0110 LLLL      Codec 0x1E6L
[Length 扩展 TAG]
算法 ID           1 WORD (0x0001 = Ed25519)
签名者            ISSUER-POINTER(Issuer) Reference 记录
签名              其余全部。宽度由算法决定 (Ed25519 32 WORD)
```

- Codec：Meta `0x1E6L`，验证类
- Payload：算法 ID（原始值 1 WORD）+ 签名者（内置 Reference）+ 签名（原始值，其余部分）
- 数量：可有多个

## 解释与有效性 {#해석과-유효성}

- 签名对象是内容哈希。不是只对 BODY 签名（[签名](../issuer.md#서명)）。
- 属于验证类，因此不计入内容哈希。添加签名后哈希不变。
- 验证的不是“有签名就确认”，而是“必须有指定密钥的签名”。
- 版本列表文档由公布方签名。
- 签名者是指向 Issuer 自身的 [ISSUER-POINTER](../reference/0x040L-issuer-pointer.md)（Issuer）。它是 Reference 记录，以自身的 Length 结束，因此即使签名宽度因算法而异，布局也只有一种（[DECLARE](../edge/0x0BBL-declare.md) 剩余字段）。
- 签名的 WORD 数与算法规定的宽度不同则为 invalid。

## 未决问题 {#열린-문제}

- 是否一并对签名时刻签名。

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00001E60/latest.geul` 的结果（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E6000000000
BODY
#1 DECLARE 0x1E60
#2 FIELD #1 0x0001
#3 FIELD #1 record
#11 CODEC #3 0x0400
#4 FIELD #1 rest
#5 ENUM #2 0x0001
#6 BIND #1 "SIGNATURE"
#7 BIND #2 "algorithm"
#8 BIND #3 "signer"
#9 BIND #4 "signature"
#10 BIND #5 "ed25519"
```
