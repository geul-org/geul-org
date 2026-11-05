---
title: "LABEL (0x134L)"
weight: 308
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "LABEL 是用于写入 TOULMIN 图关系的 LINK Codec。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LABEL 是用于写入 TOULMIN 图关系的 LINK Codec。含义：节点 → TEXT，名称标记。

| 项目 | 值 |
|---|---|
| 名称 | `LABEL`（规格文档 BIND `LABEL`） |
| TAG ID | `0x134L` |
| Codec ID | `0x00001340` |
| 规格文档 | `0x00000000/codecs/0x00001340/`（DECLARE 对象 `1340`） |
| 章节 | 9 `1001`（Edge TOULMIN 形式），章节内偏移 C = 20 |
| Kind | Edge · 系列：TOULMIN 形式，布局：LINK |
| TAG WORD | `0001 0011 0100 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 节点 → TEXT，名称标记 |
| Hugo 侧 | `edge/toulmin/link.md` |

## 布局 {#레이아웃}

布局为 [LINK](_index.md#link)（ID、src、dst、flags、条件字段、SPAN）。

| 项目 | 值 |
|---|---|
| TANGEUL | 反引号名称 |
| src → dst | 节点 → TEXT。名称标记 |

- dst 是 TEXT 记录的 REF。是否把反引号名称作为陈述 [LABEL](../edge/0x0A4L-label.md)·[BIND](../edge/0x0A3L-bind.md) 是未决问题（[TOULMIN](_index.md#열린-문제)）。
- 不使用 F_FORCE（若已开启则拒绝）。
- 公共字段（ID、REF、SPAN）与数值规则遵循 [TOULMIN](_index.md#공통-필드)。

## Codec 文档 {#코덱-문서}

Codec 文档设有 DECLARE（对象 `1340`）。LINK 布局的条件字段以及由 SOURCE 决定的 SPAN 宽度无法用 FIELD 声明，因此字段声明是未决问题（[TOULMIN](_index.md#열린-문제)）。

## 相关页面 {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## 规格文档原文 {#규격-문서-원문}

用 `geul show` 读取规格文档 `0x00000000/codecs/0x00001340/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000134000000000
BODY
#1 DECLARE 0x1340
#2 BIND #1 "LABEL"
```
