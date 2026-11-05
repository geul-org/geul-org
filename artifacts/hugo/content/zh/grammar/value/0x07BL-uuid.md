---
title: "UUID (0x07BL)"
weight: 123
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "UUID 是承载 RFC 9562 UUID 128bit 值的定宽 Value。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `UUID`（规格文档 BIND `UUID`） |
| TAG ID | `0x07BL` |
| Codec ID | `0x000007B0` |
| 规格文档 | `0x00000000/codecs/0x000007B0/`（DECLARE 对象 `07B0`） |
| 章节 | 3 `0011`（Value），章节内偏移 C = 27 |
| Kind | Value · 系列：BINARY |
| TAG WORD | `0000 0111 1011 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 固定 Payload 8 WORD 的 RFC 9562 UUID 128bit |
| Hugo 路径 | `value/binary/uuid.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `uuid` | #2 | 原始值 8 WORD |  |  |

UUID 是承载 RFC 9562 UUID 128bit 值的定宽 Value。Value 直接码 `0x07BL`，系列 BINARY。Payload 恰好为 8 WORD（16 octet，128bit）。

## 布局 {#레이아웃}

```
TAG WORD          0x07B8 (0000 0111 1011 1000)  总计 9 WORD
Payload           8 WORD (128位)  UUID octet 0 → octet 15
```

## 解释与有效性 {#해석과-유효성}

- 将 RFC 9562 canonical UUID 的 octet 0 到 octet 15 依次两个 octet 一组。先出现的 octet 是 WORD 的高 8bit。不对 UUID 的 field、version bit、variant bit 重新排列或重新 encode。
- `8-4-4-4-12` hex-and-dash 字符串只是输入输出表示。大小写和 dash 不进入 Payload，只存储解析结果的 16 octet。
- 该 UUID Value 无损保存 128bit pattern。在 RFC 9562 variant `10xx` 下，version 1、3、4、5、6、7 是标准 layout，version 8 是 custom UUID format。version 2 保留给 DCE Security，RFC 未规定其 layout，version 0 为 unused，version 9–15 保留给未来定义。其他 variant 也保留用于兼容或未来定义。
- Nil UUID 是 128bit 全零，Max UUID 是 128bit 全一的特殊值。包含保留·unused version/variant 的 128bit pattern 在结构上也不排除，该 pattern 的含义和互操作性由适用标准和外部语境判断。
- UUID 的同一性以 Payload 的 128bit 值是否相同来判断。值相同这一事实并不保证对象的认证、所有权、当前存在、可解析性和访问权限。
- 存储 Microsoft COM GUID 时，不原样复制 mixed-endian 的内存·序列化表示。先转换为 RFC 9562 canonical field/octet 顺序的 16 octet。
- Payload 不是恰好 8 WORD 时拒绝。

## 标准依据 {#표준-근거}

- [RFC 9562 — Universally Unique IDentifiers (UUIDs)](https://www.rfc-editor.org/rfc/rfc9562.html) 将 UUID 定义为 16 octet（128bit），要求 field 以 most-significant-byte-first 方式 encode，在 binary format 中按 big-endian field 顺序连接。variant 位于 octet 8 的高位 bit，version 位于 octet 6 的高 4bit，本格式原样保存这些位置。
- RFC 9562 Sections 4.1–5.10 区分了 variant 与 version 1–8、Nil、Max、保留范围。RFC 9562 取代 RFC 4122，因此本格式现行的规范依据是 RFC 9562。
- RFC 9562 的 hex-and-dash ABNF 是 text 表示，COM GUID little-endian 的注意事项也另行说明。GEUL 只把 RFC UUID 的 canonical 16 octet 放入 Payload。
- GEUL TAG、直接 Length、16bit WORD framing 不是 RFC 9562 的一部分，而是本格式增加的规则。

## 长度 {#길이}

- 总长为 TAG 1 WORD 与 Payload 8 WORD 之和，恰好 9 WORD，使用直接长度 `LLLL=1000`。没有 Length 扩展 TAG、descriptor、padding。
- Payload 不是恰好 8 WORD 时拒绝。

## 示例 {#예시}

RFC 9562 Appendix A.6 的 UUIDv7 test vector `017f22e2-79b0-7cc3-98c4-dc0c0c07398f`：

```
07B8 017F 22E2 79B0 7CC3 98C4 DC0C 0C07 398F
```

- TAG `07B8`，Payload `017F 22E2 79B0 7CC3 98C4 DC0C 0C07 398F`。

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x000007B0/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007B000000000
BODY
#1 DECLARE 0x07B0
#2 FIELD #1 0x0008
#3 BIND #1 "UUID"
#4 BIND #2 "uuid"
```
