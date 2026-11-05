---
title: "LANGUAGE-BCP47-CODE (0x076L·0x077L)"
weight: 118
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-BCP47-CODE 是以 ASCII 字节序列承载完整 BCP 47 language tag 的 Value。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LANGUAGE-BCP47-CODE 是以 ASCII 字节序列承载完整 BCP 47 language tag 的 Value。使用偶数·奇数字节代码对 0x076L/0x077L。

| 项目 | 值 |
|---|---|
| 名称 | `LANGUAGE-BCP47-CODE`（奇偶分组。各代码的名称见下方成员表） |
| TAG ID | `0x076L`·`0x077L` |
| 章节 | 3 `0011`（Value），章节内偏移 C = 22~23 |
| Kind | Value · 系列：TEXT |
| 索引说明 | canonical casing 的完整 BCP 47 language tag ASCII 字节序列。偶数·奇数字节 |
| Hugo 路径 | `value/text/language-bcp47-code.md` |

## 成员 {#구성원}

本页同时处理奇偶一对的两个代码。偶数代码的值字节数为偶数，奇数代码的值字节数为奇数（[记录与 TAG WORD](../record.md#가변-길이-바이트열)）。Codec 文档每个代码一份。两份 Codec 文档的字段相同，只有 DECLARE 对象和名称（BIND）不同。

| TAG ID | 名称 | 字节数 | Codec ID | 规格文档 | TAG WORD |
|---|---|---|---|---|---|
| `0x076L` | `LANGUAGE-BCP47-CODE-EVEN` | 偶数 | `0x00000760` | `0x00000000/codecs/0x00000760/` | `0000 0111 0110 LLLL` |
| `0x077L` | `LANGUAGE-BCP47-CODE-ODD` | 奇数 | `0x00000770` | `0x00000000/codecs/0x00000770/` | `0000 0111 0111 LLLL` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | 剩余原始值（`0xFFFF`） |  |  |

LANGUAGE-BCP47-CODE 是承载完整 BCP 47 language tag 的 Value。需要连 script、region、variant 都精确标明语言时使用。

## 布局 {#레이아웃}

- 代码：Value 直接码 `0x076L`（偶数字节）·`0x077L`（奇数字节）。系列 TEXT。
- 字节数由 Codec 的最低位和 Payload WORD 数决定。即 `2 × Payload WORD 数 − 最低位`，不设 Byte Count（[Value](_index.md)）。
- Payload 不是 UTF-8 文本，而是 BCP 47 tag 的 ASCII 字节序列。

```
TAG WORD          0000 0111 011P LLLL      Codec 0x076L/0x077L
[Length 扩展 TAG] 总计 15 WORD 以上时
Payload WORD 1st ... Nth          BCP 47 tag bytes / final zero padding
```

## 解释与有效性 {#해석과-유효성}

- 字节序列必须是 RFC 5646 的 well-formed BCP 47 language tag。不允许空字符串。
- Payload 只使用 ASCII 字母、数字和连字符 `-`。分隔符必须是 ASCII `-`，不允许 `_`、空格和非 ASCII 字符。
- BCP 47 tag 的比较不区分大小写。GEUL canonical profile 的分隔符一律用 `-`，language/extlang/variant/extension/private-use subtag 序列化为小写，script 为 Titlecase，region 为大写。
- 仅 well-formed 并不足够。registered subtag 与 grandfathered tag 的有效性以特定的 IANA Language Subtag Registry snapshot 为准判定，并须同时保存该 snapshot 的日期或 registry version。
- private-use tag 与 private-use subtag 只要符合 RFC 5646 语法即 well-formed，便予允许。但其含义取决于当事方约定，IANA registry 并未定义，因此不保证公共互操作性。
- 在同一 snapshot 中，若 deprecated subtag 或 grandfathered tag 有 Preferred-Value，则 canonical GEUL form 以 canonical casing 写出该替换值。保持 deprecated 写法的 tag 虽然可作为输入解释，但不是 canonical 存储形式。
- BCP 47 是 ASCII profile，因此不适用 UTF-8 NFC 之类的 Unicode normalization 要求。
- WORD 内高位 byte 在前。字节数为奇数（奇数代码）时，最后一个 WORD 中未使用的低位 byte 必须为 `00`。
- Payload WORD 数为 `ceil(字节数/2)`。若为奇数代码而最后一个 WORD 的低位 byte 不是 `00`，则拒绝。

## 标准依据 {#표준-근거}

- language tag 语法、不区分大小写的解释、deprecated/Preferred-Value 概念遵循 [RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646)。
- 判定 tag 有效性的 registry 是 [IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry)。
- 奇偶代码对、zero padding、canonical casing 存储策略与 Length 计算是 GEUL framing 规则。

## 长度 {#길이}

- 总长为 TAG 1 WORD、Length 扩展 TAG（如有）与 Payload 的 WORD 数之和。14 WORD 以下用直接长度，15 WORD 以上用 `1110`·`1111` 扩展长度，扩展 TAG 也计入总数（[Length](../record.md)）。

## 与 LANGUAGE-SHORT-CODE 的关系 {#language-short-code와의-관계}

- 在 GEUL Language Registry 中有编号的 tag 可以用 [LANGUAGE-SHORT-CODE](0x07AL-language-short-code.md) 1 WORD 书写。
- 注册表中没有编号的 tag（包括含 extension·private-use 的 tag）用 LANGUAGE-BCP47-CODE 书写。需要保存 full tag 原文时也用 LANGUAGE-BCP47-CODE。
- SHORT-CODE `n` 与注册表绑定到 `n` 的 tag 的 LANGUAGE-BCP47-CODE（忽略大小写）是同一种语言。

## 示例 {#예시}

- `ko-KR` 为 ASCII 5 byte（奇数），因此是 `LANGUAGE-BCP47-CODE-ODD`（`0x077L`），Payload 为 `6B6F 2D4B 5200`。
- TAG 1 WORD、Payload 3 WORD，总计 4 WORD，`LLLL=0011`。整体为 `0773 6B6F 2D4B 5200`。

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00000760/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000076000000000
BODY
#1 DECLARE 0x0760
#2 FIELD #1 rest
#3 BIND #1 "LANGUAGE-BCP47-CODE-EVEN"
#4 BIND #2 "bytes"
```

以上是 `LANGUAGE-BCP47-CODE-EVEN`（`0x076L`）的 Codec 文档。其他成员（`LANGUAGE-BCP47-CODE-ODD`）的 Codec 文档只在 DOC-ID 的 Codec ID、DECLARE 对象、`#1` 绑定的名称（BIND）上不同。
