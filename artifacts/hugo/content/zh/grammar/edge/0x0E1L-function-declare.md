---
title: "FUNCTION-DECLARE (0x0E1L)"
weight: 225
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "FUNCTION-DECLARE 是执行 Edge 中“声明”分组的 Codec。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

FUNCTION-DECLARE 是执行 Edge 中“声明”分组的 Codec。含义：函数声明。

| 项目 | 值 |
|---|---|
| 名称 | `FUNCTION-DECLARE`（规格文档 BIND `FUNCTION-DECLARE`） |
| TAG ID | `0x0E1L` |
| Codec ID | `0x00000E10` |
| 规格文档 | `0x00000000/codecs/0x00000E10/`（DECLARE 目标 `0E10`） |
| 章节 | 7 `0111`（Edge 执行），章节内偏移 C = 1 |
| Kind | Edge · 系列：执行，分组：声明 |
| TAG WORD | `0000 1110 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引说明 | 函数声明。符号、形参符号列表、返回类型、函数体（BLOCK） |
| Hugo 侧 | `edge/_index.md` |

## 组成部分 {#구성요소}

符号、形参符号列表、返回类型、函数体（BLOCK）。

- 组成部分用本文档的 LOCAL ID（REF）指向。REF `0` 表示无。表达式位置放表达式 Edge 或符号（[Edge](_index.md#실행-edge)）。
- 运算符代码、类型表示、Payload 布局尚未确定（[Edge](_index.md#실행-edge) 未决问题）。

## Codec 文档 {#코덱-문서}

尚未确定布局。Codec 文档只放 DECLARE（目标 `0E10`）。FIELD 在布局确定后再放。

## 相关页面 {#관련-페이지}

- [Edge — 执行 Edge](_index.md#실행-edge), [TYPE-DECLARE](0x0E2L-type-declare.md)

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00000E10/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000E1000000000
BODY
#1 DECLARE 0x0E10
#2 BIND #1 "FUNCTION-DECLARE"
```
