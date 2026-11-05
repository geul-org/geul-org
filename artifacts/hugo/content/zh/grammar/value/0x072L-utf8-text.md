---
title: "UTF8-TEXT (0x072L·0x073L)"
weight: 114
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "UTF8-TEXT 是承载无语言标注的 UTF-8 字符串的 Value。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UTF8-TEXT 是承载无语言标注的 UTF-8 字符串的 Value。使用偶数·奇数字节代码对 0x072L/0x073L。

| 项目 | 值 |
|---|---|
| 名称 | `UTF8-TEXT`（奇偶分组。各代码的名称见下方成员表） |
| TAG ID | `0x072L`·`0x073L` |
| 章节 | 3 `0011`（Value），章节内偏移 C = 18~19 |
| Kind | Value · 系列：TEXT |
| 索引说明 | 不暗示规范化的 valid UTF-8 字节序列。偶数·奇数字节 |
| Hugo 路径 | `value/text/utf8-text.md` |

## 成员 {#구성원}

本页同时处理奇偶一对的两个代码。偶数代码的值字节数为偶数，奇数代码的值字节数为奇数（[记录与 TAG WORD](../record.md#가변-길이-바이트열)）。Codec 文档每个代码一份。两份 Codec 文档的字段相同，只有 DECLARE 对象和名称（BIND）不同。

| TAG ID | 名称 | 字节数 | Codec ID | 规格文档 | TAG WORD |
|---|---|---|---|---|---|
| `0x072L` | `UTF8-TEXT-EVEN` | 偶数 | `0x00000720` | `0x00000000/codecs/0x00000720/` | `0000 0111 0010 LLLL` |
| `0x073L` | `UTF8-TEXT-ODD` | 奇数 | `0x00000730` | `0x00000000/codecs/0x00000730/` | `0000 0111 0011 LLLL` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | 剩余原始值（`0xFFFF`） |  |  |

UTF8-TEXT 是承载 RFC 3629 valid UTF-8 字节序列的 Value。用于标识符、代码、文件名等无语言标注的字符串。

## 布局 {#레이아웃}

- 代码：Value 直接码 `0x072L`（偶数字节）·`0x073L`（奇数字节）。系列 TEXT。
- 字节数由 Codec 的最低位和 Payload WORD 数决定。即 `2 × Payload WORD 数 − 最低位`，不设 Byte Count（[Value](_index.md)）。

```
TAG WORD          0000 0111 001P LLLL      Codec 0x072L/0x073L
[Length 扩展 TAG] 总计 15 WORD 以上时
Payload WORD 1st ... Nth          UTF-8 bytes / final zero padding
```

## 解释与有效性 {#해석과-유효성}

- 字节序列必须是符合 RFC 3629 语法的 well-formed shortest-form UTF-8。解码结果只包含 `U+0000..U+10FFFF` 范围内的 Unicode scalar value，不包含代理区 `U+D800..U+DFFF`。
- Payload 开头的 U+FEFF（UTF-8 字节序列 `EF BB BF`）也视为与其他位置的 U+FEFF 相同的字符并予以允许。不做 RFC 3629 所述的开头 U+FEFF signature（BOM）处理。不去除，也不解释为 signature，按原文保存。
- 不强制 Unicode normalization。解码后的原文 scalar sequence 原样保存。
- 将有效的 UTF-8 字节序列不经转换放入 Payload。WORD 内高位 byte 在前。字节数为奇数（奇数代码）时，最后一个 WORD 中未使用的低位 byte 必须为 `00`。
- Payload WORD 数为 `ceil(字节数/2)`。若为奇数代码而最后一个 WORD 的低位 byte 不是 `00`，则拒绝。

## 标准依据 {#표준-근거}

- UTF-8 的 scalar 范围与 well-formed 字节序列遵循 [RFC 3629](https://www.rfc-editor.org/rfc/rfc3629)。
- 奇偶代码对、zero padding、GEUL TAG/Length 与 16 位 WORD 排布是该格式的 canonical framing 规则。

## 长度 {#길이}

- 总长为 TAG 1 WORD、Length 扩展 TAG（如有）与 Payload 的 WORD 数之和。14 WORD 以下用直接长度，15 WORD 以上用 `1110`·`1111` 扩展长度，扩展 TAG 也计入总数（[Length](../record.md)）。
- 0 byte 字符串写成偶数代码的 1 WORD 记录（仅 TAG WORD）（[Value](_index.md)）。

## 示例 {#예시}

- `A`（`41`）为 1 byte（奇数），因此是 `UTF8-TEXT-ODD`（`0x073L`），Payload 为 `4100`，总计 2 WORD，`LLLL=0001`。整体为 `0731 4100`。
- 空字符串是 `0720`（`UTF8-TEXT-EVEN`，仅 TAG WORD）1 WORD。

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00000720/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000072000000000
BODY
#1 DECLARE 0x0720
#2 FIELD #1 rest
#3 BIND #1 "UTF8-TEXT-EVEN"
#4 BIND #2 "bytes"
```

以上是 `UTF8-TEXT-EVEN`（`0x072L`）的 Codec 文档。其他成员（`UTF8-TEXT-ODD`）的 Codec 文档只在 DOC-ID 的 Codec ID、DECLARE 对象、`#1` 绑定的名称（BIND）上不同。
