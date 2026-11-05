---
title: "ALIAS (0x129L)"
weight: 297
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "ALIAS 是用于写入 TOULMIN 图节点的 NODE Codec。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ALIAS 是用于写入 TOULMIN 图节点的 NODE Codec。含义：`see … from`。导入的包别名。

| 项目 | 值 |
|---|---|
| 名称 | `ALIAS`（规格文档 BIND `ALIAS`） |
| TAG ID | `0x129L` |
| Codec ID | `0x00001290` |
| 规格文档 | `0x00000000/codecs/0x00001290/`（DECLARE 对象 `1290`） |
| 章节 | 9 `1001`（Edge TOULMIN 形式），章节内偏移 C = 9 |
| Kind | Edge · 系列：TOULMIN 形式，布局：NODE |
| TAG WORD | `0001 0010 1001 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | `see … from`。导入的包别名 |
| Hugo 侧 | `edge/toulmin/node.md` |

## 布局 {#레이아웃}

布局为 [NODE](_index.md#node)。头部 1 WORD 决定 role、level、Claim 形态和条件字段。

| 项目 | 值 |
|---|---|
| TANGEUL | `see a from path` |
| 节点 | 导入的包别名 |

- role 必须为 0。
- 公共字段（ID、REF、SPAN）与数值规则遵循 [TOULMIN](_index.md#공통-필드)。

## Codec 文档 {#코덱-문서}

Codec 文档设有 DECLARE（对象 `1290`）。NODE 布局的条件字段以及由 SOURCE 决定的 SPAN 宽度无法用 FIELD 声明，因此字段声明是未决问题（[TOULMIN](_index.md#열린-문제)）。

## 相关页面 {#관련-페이지}

- [NODE](_index.md#node), [TOULMIN](_index.md)

## 规格文档原文 {#규격-문서-원문}

用 `geul show` 读取规格文档 `0x00000000/codecs/0x00001290/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000129000000000
BODY
#1 DECLARE 0x1290
#2 BIND #1 "ALIAS"
```
