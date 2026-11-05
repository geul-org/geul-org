---
title: "CRC32C"
weight: 1033
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "CRC32C 是承载 CRC-32C 结果的定宽 Value。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CRC32C 是承载 CRC-32C 结果的定宽 Value。Value `VALUE-ISSUER-2WORD`（`0x09DL`），Issuer `0x00000007` IETF，Codec 编号 `0x0000C000`，系列 BINARY。Payload 恰好是 2 WORD（32 bit）。

## 布局 {#레이아웃}

```
TAG WORD          0x09D6 (0000 1001 1101 0110)  总计 7 WORD
Issuer            2 WORD  0x00000007 (IETF)
Codec 编号        2 WORD  0x0000C000
Payload           2 WORD  CRC32C 高 16bit │ 低 16bit
```

## 解释与有效性 {#해석과-유효성}

- 以 CRC parameter 表示：width 32，Castagnoli polynomial `0x1EDC6F41`，refin/refout true，init `0xFFFFFFFF`，xorout `0xFFFFFFFF`。
- 将计算结果 unsigned 32bit 整数按 big-endian WORD 顺序存储。此序列化本身不是 RFC 3309 的 SCTP Checksum field 排布，也不是 RFC 3720 的 iSCSI digest byte mapping。
- Payload 不是 2 WORD 则拒绝。

## 标准依据 {#표준-근거}

- CRC-32C 的计算及 Castagnoli polynomial·反射规则遵循 [RFC 3309](https://www.rfc-editor.org/rfc/rfc3309.html) 与 [RFC 3720](https://www.rfc-editor.org/rfc/rfc3720.html) 的 CRC32C 定义。
- GEUL TAG、Length，以及将计算所得 32bit 整数按 16bit big-endian WORD 进行 framing，是此格式新增的规则。

## 长度 {#길이}

- 总计是 TAG 1 WORD、Issuer 2 WORD、Codec 编号 2 WORD、Payload 2 WORD 之和，恰好 7 WORD，使用直接长度 `LLLL=0110`。没有 Length 扩展 TAG、descriptor、padding。
- Payload 不是恰好 2 WORD 则拒绝。

## 示例 {#예시}

ASCII `123456789` 的 CRC-32C check value `0xE3069283`：

```
09D6 0000 0007 0000 C000 E306 9283
```
