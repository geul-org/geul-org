---
title: "DOC-POINTER"
weight: 8
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "DOC-POINTER 是指向 Issuer 公布的文档的某一版本的指示声明 Reference。版本 ID 0 为最新版本。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DOC-POINTER 是指向 Issuer 公布的文档的某一版本的指示声明 Reference。它是文档公布·deprecate·删除、引用版本、关于文档的叙述的对象。

## 布局

```
TAG WORD          0000 0LLL L011 1QQQ      CCCC = 0111
[Length 扩展 TAG]
Issuer            1/2/4/16 WORD
文档 ID           4 WORD
版本 ID           2 WORD
```

## 解读与有效性

- Issuer 宽度是 Payload 减去文档 ID 和版本 ID 的 6 WORD 之后的剩余部分。Codec 不划分宽度。宽度不是 1、2、4、16 WORD，或 Issuer 的值能放入更窄的宽度，则 invalid（Issuer 规范形式）。
- 版本 ID 不能省略。若允许省略，仅凭 Payload 长度就无法确定 Issuer 宽度（Issuer 4 WORD·无版本与 Issuer 2 WORD·有版本都是 8 WORD）。
- 版本 ID `0` 是最新版本。绑定到解读时刻的现行版本。其他值固定到该版本（[PUBLICATION](/zh/grammar/edge/publication/)）。
- 文档 ID `0` 是 Issuer 的术语定义索引文档。Issuer 自身用 [ISSUER-POINTER](/zh/grammar/reference/issuer-pointer/) 指向。
- Quantifier 只使用 `000`（Identified）。其他值 invalid。
- 指向 Issuer 的文档的格式只有 DOC-POINTER 一种。用 `EXTERNAL-ISSUER-*`（Issuer、文档 ID、目标 ID `0`）或 `EXTERNAL-POINTER-*`（IMPORT ID、目标 ID `0`）指向文档则 invalid。
- 使用位置：Meta [DOC-ID](/zh/grammar/meta/declaration/doc-id/)·[IMPORT-DOC](/zh/grammar/meta/import/import-doc/)、版本列表的 PUBLICATION·DEPRECATION·TOMBSTONE 与 BIND Subject、名称索引 `documents.geul` 的 BIND Subject。

## 示例

GEUL Issuer `0x0000` 的文档 `0xffff000000000001`。

| 版本 | WORD sequence |
|---|---|
| 1 | `03B8 0000 ffff 0000 0000 0001 0000 0001` |
| 最新（`0`） | `03B8 0000 ffff 0000 0000 0001 0000 0000` |

- TAG 1 + Issuer 1 + 文档 ID 4 + 版本 ID 2 = 8 WORD，`LLLL=0111`。TAG 是 `0000 0 0111 0111 000` = `03B8`。

## 相关页面

- [Reference](/zh/grammar/reference/)、[ISSUER-POINTER](/zh/grammar/reference/issuer-pointer/)、[EXTERNAL-ISSUER](/zh/grammar/reference/external-issuer/)、[PUBLICATION](/zh/grammar/edge/publication/)
- [Issuer 与公布](/zh/grammar/issuer/)
