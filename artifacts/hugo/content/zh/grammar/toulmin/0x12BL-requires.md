---
title: "REQUIRES (0x12BL)"
weight: 299
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "REQUIRES 是用于写入 TOULMIN 图关系的 LINK Codec。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

REQUIRES 是用于写入 TOULMIN 图关系的 LINK Codec。含义：案件 → 字段。

| 项目 | 值 |
|---|---|
| 名称 | `REQUIRES`（规格文档 BIND `REQUIRES`） |
| TAG ID | `0x12BL` |
| Codec ID | `0x000012B0` |
| 规格文档 | `0x00000000/codecs/0x000012B0/`（DECLARE 对象 `12B0`） |
| 章节 | 9 `1001`（Edge TOULMIN 形式），章节内偏移 C = 11 |
| Kind | Edge · 系列：TOULMIN 形式，布局：LINK |
| TAG WORD | `0001 0010 1011 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 案件 → 字段 |
| Hugo 侧 | `edge/toulmin/link.md` |

## 布局 {#레이아웃}

布局为 [LINK](_index.md#link)（ID、src、dst、flags、条件字段、SPAN）。

| 项目 | 值 |
|---|---|
| TANGEUL | `f is required` |
| src → dst | 案件 → 字段 |

- dst 是节点的 REF。
- 不使用 F_FORCE（若已开启则拒绝）。
- 公共字段（ID、REF、SPAN）与数值规则遵循 [TOULMIN](_index.md#공통-필드)。

## Codec 文档 {#코덱-문서}

Codec 文档设有 DECLARE（对象 `12B0`）。LINK 布局的条件字段以及由 SOURCE 决定的 SPAN 宽度无法用 FIELD 声明，因此字段声明是未决问题（[TOULMIN](_index.md#열린-문제)）。

## 相关页面 {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## 规格文档原文 {#규격-문서-원문}

用 `geul show` 读取规格文档 `0x00000000/codecs/0x000012B0/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000012B000000000
BODY
#1 DECLARE 0x12B0
#2 BIND #1 "REQUIRES"
```
