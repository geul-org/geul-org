---
title: "BIND"
weight: 4
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "BIND 是给 Subject 绑定机器匹配用名称（没有语言的 UTF8-TEXT）的叙述 Edge（Codec 0x03）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BIND 是给 Subject 绑定机器匹配用名称的叙述 Edge。Codec `0x03`。

这是命名。人可读的名称（各语言标题）由 [LABEL](/zh/grammar/edge/label/) 负责。程序符号的名称和文档的寻址名称用同一种记录来写。

## 布局

```
TAG WORD          0001 0LLL L000 0011
[Length 扩展 TAG]
Edge Id           LOCAL Reference 记录
Subject           Reference 记录 1 个，或 codec TAG WORD 1 WORD
名称              UTF8-TEXT-* Value 1 个
```

## 解读与有效性

- Subject 恰好是一个完整的 [Reference](/zh/grammar/reference/) 记录。如果是 LOCAL，则是本文档的目标（符号等），如果是指示 Reference，则是其他文档的目标。文档自身是 [DOC-POINTER](/zh/grammar/reference/doc-pointer/)，Issuer 自身是 [ISSUER-POINTER](/zh/grammar/reference/issuer-pointer/)。
- 或者 Subject 是一个 codec TAG WORD（只有 Kind·Codec，`LLLL = 0`，没有 Payload）。这不是 Payload 为空的记录，而是指向该直接码本身，即其规格文档（GEUL Issuer 文档 `0x000000000000<TAG>`）（[Codec 规格文档](/zh/grammar/codec-spec/)、[DECLARE](/zh/grammar/edge/declare/)）。例：`1018` 是 PUBLICATION。名称索引中使用 DOC-POINTER Subject。不使用 Issuer 格式的 codec。
- 其他记录（Value 等）不能成为 Subject。BIND 规格文档的 FIELD 只把 Subject 声明为宽度 `0`（记录），所以此约束是 BIND 正文规则。
- 名称恰好是一个 [UTF8-TEXT](/zh/grammar/value/text/utf8-text/) Value。没有语言，不做规范化。字节相同才是同一个名称。
- 名称的范围是包含该 BIND 的文档。同一文档中不把相同名称绑定到不同的 Subject。
- 一个 Subject 可以绑定多个名称（别名、旧名称）。文档没有另行规定时，最后一个 BIND 为代表名称。
- 其他记录不用名称而用 LOCAL ID 来指向目标。名称用来与外部（宿主函数、地址输入、人）对应。
- 名称可使用的字符由用途决定。文档寻址名称遵循文档名称规则（小写 ASCII slug）（[公布地址与版本列表](/zh/grammar/publishing/#文档名称)）。

## 长度

```
总计 = 1 + N_len + N_id + N_subject + N_name WORD
```

## 示例（非规范）

程序符号：Edge Id `0003`，Subject LOCAL 7，名称 `main`。

- 名称 `main` 是 4 byte（偶数），所以是 `0940 6d61 696e` 3 WORD。
- Edge 为 TAG 1 + Edge Id 2 + Subject 2 + 名称 3 = 8 WORD，TAG 是 `1383`。

```
1383 0088 0003 0088 0007 0940 6d61 696e
```

文档名称（在该文档的版本列表文档 `0x0000/0xffff000000000002/versions.geul` 内）：Edge Id `0005`，Subject `DOC-POINTER`（Issuer `0x0000`，文档 `0xffff000000000002`，版本 `0` = 文档自身），名称 `this-is-sample-doc`。

- Subject 是 TAG `03B8` + Issuer 1 + 文档 ID 4 + 版本 ID 2 = 8 WORD。
- 名称是 18 byte（偶数），所以是 TAG `0CC0` + 9 WORD = 10 WORD。
- Edge 是 TAG 1 + Length 扩展 1 + Edge Id 2 + Subject 8 + 名称 10 = 22 WORD，所以 `LLLL=1110`，TAG `1703`，扩展 `0016`。

```
1703 0016 0088 0005 03B8 0000 ffff 0000 0000 0002 0000 0000 0CC0 7468 6973 2d69 732d 7361 6d70 6c65 2d64 6f63
```

## 相关页面

- [Edge](/zh/grammar/edge/)、[LABEL](/zh/grammar/edge/label/)、[PUBLICATION](/zh/grammar/edge/publication/)（版本列表文档的文档名称）
- [LOCAL](/zh/grammar/reference/local/)、[DOC-POINTER](/zh/grammar/reference/doc-pointer/)、[ISSUER-POINTER](/zh/grammar/reference/issuer-pointer/)
