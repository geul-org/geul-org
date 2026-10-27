---
title: "CRC32C"
weight: 1004
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "CRC32C 是承载 Castagnoli CRC-32C 结果 32bit 的固定 5 WORD IETF Issuer 格式。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CRC32C 是承载 CRC-32C 结果的固定宽度 Value。Value `ISSUER-1WORD`（`0x7C`），Issuer `0x0020` IETF，格式编号 `0xC000`，系列为 BINARY。Payload 恰好是 2 WORD（32 bit）。

## 布局

```
TAG WORD          0x0A7C (0000 1010 0111 1100)  总计 5 WORD
Issuer            1 WORD  0x0020 (IETF)
格式编号          1 WORD  0xC000
Payload           2 WORD  CRC32C 高 16bit │ 低 16bit
```

## 解读与有效性

- 以 CRC parameter 写法表示：width 32，Castagnoli polynomial `0x1EDC6F41`，refin/refout true，init `0xffffffff`，xorout `0xffffffff`。
- 把计算结果 unsigned 32bit 整数按 big-endian WORD 顺序存放。这种序列化本身不是 RFC 3309 的 SCTP Checksum field 排列，也不是 RFC 3720 的 iSCSI digest byte mapping。
- Payload 不是 2 WORD 则拒绝。

## 标准依据

- CRC-32C 的计算以及 Castagnoli polynomial·反射规则，遵循 [RFC 3309](https://www.rfc-editor.org/rfc/rfc3309.html) 和 [RFC 3720](https://www.rfc-editor.org/rfc/rfc3720.html) 的 CRC32C 定义。
- GEUL TAG、Length，以及对计算出的 32bit 整数做 16bit big-endian WORD framing，是本格式增加的规则。

## 长度

- 总计是 TAG 1 WORD、Issuer 1 WORD、格式编号 1 WORD、Payload 2 WORD 之和，恰好 5 WORD，使用直接长度 `LLLL=0100`。没有 Length 扩展 TAG、descriptor、padding。
- Payload 不是恰好 2 WORD 则拒绝。

## 示例

ASCII `123456789` 的 CRC-32C check value `0xe3069283`：

```
0A7C 0020 C000 e306 9283
```
