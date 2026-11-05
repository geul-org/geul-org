---
title: "SHA-256-DIGEST (0x07CL)"
weight: 124
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA-256-DIGEST 是承载 SHA-2 系列 SHA-256 完整结果的定宽 Value。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `SHA-256-DIGEST`（规格文档 BIND `SHA-256-DIGEST`） |
| TAG ID | `0x07CL` |
| Codec ID | `0x000007C0` |
| 规格文档 | `0x00000000/codecs/0x000007C0/`（DECLARE 对象 `07C0`） |
| 章节 | 3 `0011`（Value），章节内偏移 C = 28 |
| Kind | Value · 系列：BINARY |
| TAG WORD | `0000 0111 1100 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 固定 Payload 16 WORD 的 SHA-256 结果 |
| Hugo 路径 | `value/binary/sha-256-digest.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `digest` | #2 | 原始值 16 WORD |  |  |

SHA-256-DIGEST 是承载 SHA-2 系列 SHA-256 完整结果的定宽 Value。Value 直接码 `0x07CL`，系列 BINARY。Payload 恰好为 16 WORD（256 bit），不允许截断（truncation）。

## 布局 {#레이아웃}

```
TAG WORD          0x07CE (0000 0111 1100 1110)  LLLL=1110
Length 扩展 TAG   1 WORD  0x0012 (总计 18 WORD)
Payload           16 WORD  SHA-256 Digest
```

## 解释与有效性 {#해석과-유효성}

- 将 Payload 32 octet 按 SHA-256 输出顺序原样读取。每个 WORD 中高位 octet 在前。
- 不对 digest bit string 另外施加 GEUL endian 转换。只是把输出 octet sequence 依次两个 octet 一组，framing 为 16bit big-endian WORD。
- Payload 不是 16 WORD，或任意截断了结果的表示，一律拒绝。没有 descriptor 和 padding。

## 标准依据 {#표준-근거}

- SHA-256 算法与 256bit 结果遵循 NIST [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final)。
- GEUL TAG、Length、16bit WORD framing 是本格式增加的规则，不属于 SHA-2 算法。

## 长度 {#길이}

- 总长为 TAG 1 WORD、Length 扩展 TAG 1 WORD 与 Payload 16 WORD 之和，恰好 18 WORD，使用 `LLLL=1110`。没有 descriptor 和 padding。
- Payload 不是恰好 16 WORD 时拒绝。

## 示例 {#예시}

- digest octet `d[0]` 到 `d[31]` 依次放为 Payload WORD `(d[0]<<8)|d[1]` 到 `(d[30]<<8)|d[31]`。总 Length 始终为 18 WORD。

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x000007C0/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007C000000000
BODY
#1 DECLARE 0x07C0
#2 FIELD #1 0x0010
#3 BIND #1 "SHA-256-DIGEST"
#4 BIND #2 "digest"
```
