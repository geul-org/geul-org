---
title: "LICENSE (0x1DEL)"
weight: 478
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "记录本文档及字节序列内作品的许可证。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `LICENSE`（规格文档 BIND `LICENSE`） |
| TAG ID | `0x1DEL` |
| Codec ID | `0x00001DE0` |
| 规格文档 | `0x00000000/codecs/0x00001DE0/`（DECLARE 对象 `1DE0`） |
| 章节 | 14 `1110`（Meta），章节内偏移 C = 30 |
| Kind | Meta · 类：策略 |
| TAG WORD | `0001 1101 1110 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 许可证。Reference |
| Hugo 侧 | `meta/policy/license.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `license` | #2 | 记录 | `000F` 章节 0 全部（通配符，Reference）, `020F` 章节 1 全部（通配符，Reference）, `040F` 章节 2 全部（通配符，Reference）, `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD, `0740` URI-EVEN, `0750` URI-ODD |  |

记录本文档及字节序列内作品的许可证。

## 布局 {#레이아웃}

```
TAG WORD          0001 1101 1110 LLLL      Codec 0x1DEL
[Length 扩展 TAG]
Payload           指向许可证的 Reference，或 SPDX 标识符 UTF8-TEXT，或 URI Value
```

- Codec：Meta `0x1DEL`，策略类
- Payload：内置 Reference 或 Value（[UTF8-TEXT](../value/0x072L-utf8-text.md)、[URI](../value/0x074L-uri.md)）
- 数量：至多一个

## 解释与有效性 {#해석과-유효성}

- geul.org 公布的文档为 CC0。私有公布由 Issuer 决定（[Issuer](../issuer.md)）。
- 记录来源作品原本的许可证。

## 未决问题 {#열린-문제}

- SPDX 标识符是以文本放置，还是以 GEUL 实体 Reference 放置。

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00001DE0/latest.geul` 的结果（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DE000000000
BODY
#1 DECLARE 0x1DE0
#2 FIELD #1 record
#3 BIND #1 "LICENSE"
#4 BIND #2 "license"
#5 CODEC #2 0x000F
#10 CODEC #2 0x020F
#11 CODEC #2 0x040F
#6 CODEC #2 0x0720
#7 CODEC #2 0x0730
#8 CODEC #2 0x0740
#9 CODEC #2 0x0750
```
