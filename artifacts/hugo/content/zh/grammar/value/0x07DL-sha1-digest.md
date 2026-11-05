---
title: "SHA1-DIGEST (0x07DL)"
weight: 125
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA1-DIGEST 是承载 SHA-1 完整结果的定宽 Value。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `SHA1-DIGEST`（规格文档 BIND `SHA1-DIGEST`） |
| TAG ID | `0x07DL` |
| Codec ID | `0x000007D0` |
| 规格文档 | `0x00000000/codecs/0x000007D0/`（DECLARE 对象 `07D0`） |
| 章节 | 3 `0011`（Value），章节内偏移 C = 29 |
| Kind | Value · 系列：BINARY |
| TAG WORD | `0000 0111 1101 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 固定 Payload 10 WORD 的 SHA-1 结果。仅用于 git 对象 ID 之类的标识用途 |
| Hugo 路径 | `value/binary/sha1-digest.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `digest` | #2 | 原始值 10 WORD |  |  |

SHA1-DIGEST 是承载 SHA-1 完整结果的定宽 Value。Value 直接码 `0x07DL`，系列 BINARY。Payload 恰好为 10 WORD（160 bit），不允许截断（truncation）。

**仅用于标识。** SHA-1 的抗碰撞性已被攻破（2017 SHAttered）。作为完整性·签名的依据，应使用 [SHA-256-DIGEST](0x07CL-sha-256-digest.md)。设置本格式是为了原样承载已经以 SHA-1 确定的标识符，典型的是 SHA-1 git 仓库的对象 ID（提交 ID）。例如，[TRANSFORMED-BY](../meta/0x1D4L-transformed-by.md) 的 Version（提交 ID）不用 hex 文本（22 WORD），而用 11 WORD 承载。

## 布局 {#레이아웃}

```
TAG WORD          0x07DA (0000 0111 1101 1010)  LLLL=1010
Payload           10 WORD  SHA-1 Digest
```

## 解释与有效性 {#해석과-유효성}

- 将 Payload 20 octet 按 SHA-1 输出顺序原样读取。每个 WORD 中高位 octet 在前（与 SHA-256-DIGEST 的 framing 相同）。
- Payload 不是 10 WORD，或任意截断了结果的表示（git 缩写 ID 等），一律拒绝。没有 descriptor 和 padding。
- git 对象 ID 就是 git 所计算的值。git 的 SHA-1 是加入碰撞检测的变体（SHA-1DC），但对非碰撞攻击的输入，结果与 SHA-1 相同。

## 标准依据 {#표준-근거}

- SHA-1 算法与 160bit 结果遵循 NIST [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final)。
- GEUL TAG 与 16bit WORD framing 是本格式增加的规则。

## 长度 {#길이}

- 总长为 TAG 1 WORD 与 Payload 10 WORD 之和，恰好 11 WORD，使用 `LLLL=1010`。没有 Length 扩展。

## 示例 {#예시}

git 提交 `ddc0719974a32aaa7b422ee84221a9721085ce4c`：

```
07DA DDC0 7199 74A3 2AAA 7B42 2EE8 4221 A972 1085 CE4C
```

## 相关页面 {#관련-페이지}

- [Value](_index.md)、[SHA-256-DIGEST](0x07CL-sha-256-digest.md)、[TRANSFORMED-BY](../meta/0x1D4L-transformed-by.md)

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x000007D0/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007D000000000
BODY
#1 DECLARE 0x07D0
#2 FIELD #1 0x000A
#3 BIND #1 "SHA1-DIGEST"
#4 BIND #2 "digest"
```
