---
title: "RECORDED-AT (0x1D0L)"
weight: 464
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "记录写成文档的时刻（git commit date）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `RECORDED-AT`（规格文档 BIND `RECORDED-AT`） |
| TAG ID | `0x1D0L` |
| Codec ID | `0x00001D00` |
| 规格文档 | `0x00000000/codecs/0x00001D00/`（DECLARE 对象 `1D00`） |
| 章节 | 14 `1110`（Meta），章节内偏移 C = 16 |
| Kind | Meta · 类：出处 |
| TAG WORD | `0001 1101 0000 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 记录时刻。TIME Value（git commit date） |
| Hugo 侧 | `meta/provenance/recorded-at.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `time` | #2 | 记录 | `06A0` GREGORIAN-DATE, `06C0` POSIX-TIMESTAMP-SECONDS, `06E0` EDTF, `06F0` EDTF, `0700` GEDCOM-DATE, `0710` GEDCOM-DATE |  |

记录写成文档的时刻（git commit date）。

## 布局 {#레이아웃}

```
TAG WORD          0001 1101 0000 LLLL      Codec 0x1D0L
[Length 扩展 TAG]
Payload           一个 TIME Value (GREGORIAN-DATE, POSIX-TIMESTAMP-SECONDS 等)
```

- Codec：Meta `0x1D0L`，出处类
- Payload：内置 Value（TIME 系列：[GREGORIAN-DATE](../value/0x06AL-gregorian-date.md)、[POSIX-TIMESTAMP-SECONDS](../value/0x06CL-posix-timestamp-seconds.md) 等）
- 数量：至多一个

## 解释与有效性 {#해석과-유효성}

- 格式从 TIME 系列 Value 中选择。需要精度时，使用 Issuer 定义的纳秒格式（例：[POSIX-TIMESTAMP-NANOSECONDS](../value/ieee.geul.org/posix-timestamp-nanoseconds.md)）。
- 版本列表文档（[PUBLICATION](../edge/0x0B8L-publication.md)）将该值用作公布、废弃（deprecate）、删除的时刻。

## 未决问题 {#열린-문제}

- 出处 Meta 会计入内容哈希。是否允许同一内容在不同时刻记录而导致哈希不同。

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00001D00/latest.geul` 的结果（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D0000000000
BODY
#1 DECLARE 0x1D00
#2 FIELD #1 record
#3 BIND #1 "RECORDED-AT"
#4 BIND #2 "time"
#5 CODEC #2 0x06A0
#6 CODEC #2 0x06C0
#7 CODEC #2 0x06E0
#8 CODEC #2 0x06F0
#9 CODEC #2 0x0700
#10 CODEC #2 0x0710
```
