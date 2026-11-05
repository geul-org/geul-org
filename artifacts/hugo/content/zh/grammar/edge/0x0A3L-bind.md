---
title: "BIND (0x0A3L)"
weight: 163
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "BIND 是把机器对接用的名称绑定到 Subject 的陈述 Edge。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `BIND`（规格文档 BIND `BIND`） |
| TAG ID | `0x0A3L` |
| Codec ID | `0x00000A30` |
| 规格文档 | `0x00000000/codecs/0x00000A30/`（DECLARE 目标 `0A30`） |
| 章节 | 5 `0101`（Edge 陈述），章节内偏移 C = 3 |
| Kind | Edge · 系列：陈述，分组：指示与名称 |
| TAG WORD | `0000 1010 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引说明 | 把机器对接用的名称（`UTF8-TEXT-*`）绑定到 Subject。在范围内唯一且必须精确一致，没有语言 |
| Hugo 侧 | `edge/bind.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档内的顺序就是 Payload 字段顺序（[Codec 规格文档](../codec-spec.md)）。Edge 的 Edge Id 不用 FIELD 声明。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接受的格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | 记录 | 任意记录（占位标记除外） |  |
| 2 | `name` | #3 | 记录 | `0720` UTF8-TEXT-EVEN，`0730` UTF8-TEXT-ODD |  |

BIND 是把机器对接用的名称绑定到 Subject 的陈述 Edge。Codec `0x0A3L`。

这是命名。人读的名称（各语言的标题）由 [LABEL](0x0A4L-label.md) 负责。程序符号的名称和 Issuer 列表的域名使用同一种记录。

## 布局 {#레이아웃}

```
TAG WORD          0000 1010 0011 LLLL
[Length 扩展 TAG]
Edge Id           LOCAL Reference 记录
Subject           Reference 记录 1 个，或 Codec TAG WORD 1 WORD
名称              UTF8-TEXT-* Value 1 个
```

## 解释与有效性 {#해석과-유효성}

- Subject 是恰好一条完整的 [Reference](../reference/_index.md) 记录。若是 LOCAL，则是本文档中的对象（符号等），若是指示 Reference，则是其他文档的对象。文档自身是 [DOC-POINTER](../reference/0x041L-doc-pointer.md)，Issuer 自身是 [ISSUER-POINTER](../reference/0x040L-issuer-pointer.md)。
- 或者 Subject 是一个 Codec TAG WORD（仅 Kind·Codec，`LLLL = 0`，无 Payload）。这并不是 Payload 为空的记录，而是指示该直接码本身，即其规格文档（GEUL Issuer 的 Codec `0x0000<TAG>`）（[Codec 规格文档](../codec-spec.md)、[DECLARE](0x0BBL-declare.md)）。例：`0B80` 是 PUBLICATION。Issuer 格式的 Codec 不用这种形式指示。
- 其他记录（Value 等）不能成为 Subject。BIND 规格文档的 FIELD 只把 Subject 声明为宽度 `0`（记录），所以这个限制是 BIND 正文规则。
- 名称是恰好一个 [UTF8-TEXT](../value/0x072L-utf8-text.md) Value。没有语言，不做规范化。字节相同才是同一名称。
- 名称的范围是包含该 BIND 的文档。同一文档中不把同一名称绑定到不同的 Subject。
- 一个 Subject 可以绑定多个名称（别名、旧名称）。文档没有另行规定时，最后一个 BIND 是代表名称。
- 其他记录不通过名称，而是通过 LOCAL ID 指向对象。名称用于与外部（宿主函数、地址输入、人）对接。
- 名称可用的字符由用途决定。Issuer 列表的域名遵循域名规则（小写，IDNA）（[公布地址与版本列表](../publishing.md#issuer-목록)）。
- 版本列表中不放 BIND。没有文档名称地址（[公布地址与版本列表](../publishing.md#문서-이름)）。

## 长度 {#길이}

```
全部 = 1 + N_len + N_id + N_subject + N_name WORD
```

## 示例（非规范） {#예시-비규범}

程序符号：Edge Id `0003`，Subject LOCAL 7，名称 `main`。

- 名称 `main` 为 4 byte（偶数），即 `0722 6D61 696E` 共 3 WORD。
- Edge 为 TAG 1 + Edge Id 2 + Subject 2 + 名称 3 = 8 WORD，TAG 为 `0A37`。

```
0A37 0051 0003 0051 0007 0722 6D61 696E
```

## 相关页面 {#관련-페이지}

- [Edge](_index.md)、[LABEL](0x0A4L-label.md)、[公布地址与版本列表](../publishing.md#issuer-목록)（Issuer 列表的域名）
- [LOCAL](../reference/0x005L-local.md)、[DOC-POINTER](../reference/0x041L-doc-pointer.md)、[ISSUER-POINTER](../reference/0x040L-issuer-pointer.md)

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00000A30/latest.geul` 的结果（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A3000000000
BODY
#1 DECLARE 0x0A30
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "BIND"
#5 BIND #2 "subject"
#6 BIND #3 "name"
#7 CODEC #3 0x0720
#8 CODEC #3 0x0730
```
