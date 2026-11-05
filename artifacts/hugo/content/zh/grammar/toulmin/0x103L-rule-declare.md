---
title: "RULE-DECLARE (0x103L)"
weight: 259
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "RULE-DECLARE 是用于写入 TOULMIN 图节点的 NODE Codec。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

RULE-DECLARE 是用于写入 TOULMIN 图节点的 NODE Codec。含义：主张声明（Warrant）。可被攻击。

| 项目 | 值 |
|---|---|
| 名称 | `RULE-DECLARE`（规格文档 BIND `RULE-DECLARE`） |
| TAG ID | `0x103L` |
| Codec ID | `0x00001030` |
| 规格文档 | `0x00000000/codecs/0x00001030/`（DECLARE 对象 `1030`） |
| 章节 | 8 `1000`（Edge TOULMIN），章节内偏移 C = 3 |
| Kind | Edge · 系列：TOULMIN，分组：声明，布局：NODE |
| TAG WORD | `0001 0000 0011 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 主张声明（Warrant）。可被攻击 |
| Hugo 侧 | `edge/toulmin/node.md` |

## 布局 {#레이아웃}

布局为 [NODE](_index.md#node)。头部 1 WORD 决定 role、level、Claim 形态和条件字段。

| 项目 | 值 |
|---|---|
| TANGEUL | general rule，Rules 的规则名 |
| 节点 | 主张（Warrant） |

- role 必须为 0（general）。
- 公共字段（ID、REF、SPAN）与数值规则遵循 [TOULMIN](_index.md#공통-필드)。

## Codec 文档 {#코덱-문서}

Codec 文档设有 DECLARE（对象 `1030`）。NODE 布局的条件字段以及由 SOURCE 决定的 SPAN 宽度无法用 FIELD 声明，因此字段声明是未决问题（[TOULMIN](_index.md#열린-문제)）。

## 相关页面 {#관련-페이지}

- [NODE](_index.md#node), [TOULMIN](_index.md)

## 规格文档原文 {#규격-문서-원문}

用 `geul show` 读取规格文档 `0x00000000/codecs/0x00001030/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000103000000000
BODY
#1 DECLARE 0x1030
#2 BIND #1 "RULE-DECLARE"
```
