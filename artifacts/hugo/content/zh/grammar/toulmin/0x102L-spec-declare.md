---
title: "SPEC-DECLARE (0x102L)"
weight: 258
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "SPEC-DECLARE 是用于写入 TOULMIN 图节点的 NODE Codec。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SPEC-DECLARE 是用于写入 TOULMIN 图节点的 NODE Codec。含义：判断标准声明（Backing）。role 位表示定义种类。

| 项目 | 值 |
|---|---|
| 名称 | `SPEC-DECLARE`（规格文档 BIND `SPEC-DECLARE`） |
| TAG ID | `0x102L` |
| Codec ID | `0x00001020` |
| 规格文档 | `0x00000000/codecs/0x00001020/`（DECLARE 对象 `1020`） |
| 章节 | 8 `1000`（Edge TOULMIN），章节内偏移 C = 2 |
| Kind | Edge · 系列：TOULMIN，分组：声明，布局：NODE |
| TAG WORD | `0001 0000 0010 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 判断标准声明（Backing）。role 位表示定义种类 |
| Hugo 侧 | `edge/toulmin/node.md` |

## 布局 {#레이아웃}

布局为 [NODE](_index.md#node)。头部 1 WORD 决定 role、level、Claim 形态和条件字段。

| 项目 | 值 |
|---|---|
| TANGEUL | Definitions 条目（`means`、`has`） |
| 节点 | 判断标准（Backing）。role 表示定义种类 |

- role 表示定义种类。
- 公共字段（ID、REF、SPAN）与数值规则遵循 [TOULMIN](_index.md#공통-필드)。

## Codec 文档 {#코덱-문서}

Codec 文档设有 DECLARE（对象 `1020`）。NODE 布局的条件字段以及由 SOURCE 决定的 SPAN 宽度无法用 FIELD 声明，因此字段声明是未决问题（[TOULMIN](_index.md#열린-문제)）。

## 相关页面 {#관련-페이지}

- [NODE](_index.md#node), [TOULMIN](_index.md)

## 规格文档原文 {#규격-문서-원문}

用 `geul show` 读取规格文档 `0x00000000/codecs/0x00001020/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000102000000000
BODY
#1 DECLARE 0x1020
#2 BIND #1 "SPEC-DECLARE"
```
