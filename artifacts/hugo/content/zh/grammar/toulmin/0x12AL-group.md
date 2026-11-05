---
title: "GROUP (0x12AL)"
weight: 298
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "GROUP 是用于写入 TOULMIN 图节点的 NODE Codec。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GROUP 是用于写入 TOULMIN 图节点的 NODE Codec。含义：有序执行分组。

| 项目 | 值 |
|---|---|
| 名称 | `GROUP`（规格文档 BIND `GROUP`） |
| TAG ID | `0x12AL` |
| Codec ID | `0x000012A0` |
| 规格文档 | `0x00000000/codecs/0x000012A0/`（DECLARE 对象 `12A0`） |
| 章节 | 9 `1001`（Edge TOULMIN 形式），章节内偏移 C = 10 |
| Kind | Edge · 系列：TOULMIN 形式，布局：NODE |
| TAG WORD | `0001 0010 1010 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 有序执行分组 |
| Hugo 侧 | `edge/toulmin/node.md` |

## 布局 {#레이아웃}

布局为 [NODE](_index.md#node)。头部 1 WORD 决定 role、level、Claim 形态和条件字段。

| 项目 | 值 |
|---|---|
| TANGEUL | `1.` 有序列表 |
| 节点 | 有序执行分组 |

- role 必须为 0。
- 公共字段（ID、REF、SPAN）与数值规则遵循 [TOULMIN](_index.md#공통-필드)。

## Codec 文档 {#코덱-문서}

Codec 文档设有 DECLARE（对象 `12A0`）。NODE 布局的条件字段以及由 SOURCE 决定的 SPAN 宽度无法用 FIELD 声明，因此字段声明是未决问题（[TOULMIN](_index.md#열린-문제)）。

## 相关页面 {#관련-페이지}

- [NODE](_index.md#node), [TOULMIN](_index.md)

## 规格文档原文 {#규격-문서-원문}

用 `geul show` 读取规格文档 `0x00000000/codecs/0x000012A0/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000012A000000000
BODY
#1 DECLARE 0x12A0
#2 BIND #1 "GROUP"
```
