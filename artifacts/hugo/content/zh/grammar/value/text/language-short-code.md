---
title: "LANGUAGE-SHORT-CODE"
weight: 73
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-SHORT-CODE 是只把 primary language subtag 压缩为 1 WORD 承载的 GEUL 语言码 Value（Codec 0x48）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LANGUAGE-SHORT-CODE 不是完整的 BCP 47 tag，而是只承载 primary language subtag 的 GEUL 压缩语言码。Payload 恰好是 1 WORD。

## 布局

- 码：Value 直接码 `0x48`。系列 TEXT。
- Payload 恰好是 1 WORD 的 unsigned 16 位码。

```
TAG WORD          0x08C8 (0000 1000 1100 1000)  总计 2 WORD
Payload WORD 1st (16位)             GEUL language code (uint16)
```

## 解读与有效性

- 把 Payload 1 WORD 读作 unsigned 16 位整数。
- 这个值是 primary language subtag 的压缩码。不承载 script、region、variant、extension、private-use。需要这些信息时，使用 [LANGUAGE-BCP47-CODE](/zh/grammar/value/text/language-bcp47-code/)（`0x46`·`0x47`）。
- `0x0000..0xfffe` 是 GEUL Language Registry 的分配范围。即使在此范围内，在相应 registry version 中实际没有分配的值也是 invalid。
- 初始分配对象是特定 IANA Language Subtag Registry snapshot 中 `Type: language` 去掉 `Scope: private-use` 之后的公开记录。collections、macrolanguage、special 不剔除。
- 初始分配把这些公开记录按 ASCII subtag 顺序排序后编号。IANA 文件的物理顺序不是 ID 规则。
- 之后新的 `Type: language` subtag 不改变既有编号，而是追加在末尾（append-only）。
- deprecated language subtag 的 ID 不删除也不重用。Preferred-Value 关系和 deprecated 状态作为 registry metadata 保留。
- `0xffff` 保留为扩展 escape。在另行定义扩展格式之前，它在独立的 LANGUAGE-SHORT-CODE Value 中是 invalid。不得用作 `null`、`unknown`、`und` 之类的含义。
- 将来其他 Codec 规格可以定义 `0xffff` 之后的解读规则。但这并不意味着该规则会增加本格式 Payload 的长度，或允许其后跟随 Payload。
- Codec 规格可以把同一个 1 WORD 码放进不带 TAG 的原始值字段（原始值字段的 [CODEC](/zh/grammar/codec-spec/#codec)）。这是该 Codec 规格的规则，独立 Value 的 wire form 始终是 TAG 1 WORD + Payload 1 WORD。
- 要判定值的含义，必须同时保留所用的 GEUL Language Registry version，以及该 version 所固定的 IANA registry snapshot 日期。

## 标准依据

- primary language subtag 的来源 registry 以及 deprecated/Preferred-Value metadata，遵循 [IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry)。
- BCP 47 language subtag 体系的基本含义，遵循 [RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646)。
- 按 ASCII 排序 append-only 赋予 ID、`0xffff` 保留，以及与不带 TAG 的原始值字段嵌入的区分，是 GEUL 规则。

## 长度

- 总计是 TAG 1 WORD 与 Payload 1 WORD 之和，恰好 2 WORD，使用直接长度 `LLLL=0001`。没有 Length 扩展 TAG、descriptor、padding。
- Payload 不是恰好 1 WORD 则拒绝。

## 示例

- registry snapshot 和实际码表尚未确定，所以不列出特定语言的数字 ID 示例。

## 未决问题

- 初始 IANA snapshot 日期、GEUL Language Registry version 名称、完整映射表。在确定之前，不确定具体的数字示例或码表。
