---
title: "IPV4-ADDRESS"
weight: 1005
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "IPV4-ADDRESS 是原样按 network byte order 承载 IPv4 地址 32bit 的固定 5 WORD IETF Issuer 格式。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IPV4-ADDRESS 是承载 IPv4 地址 32bit 值的固定宽度 Value。Value `ISSUER-1WORD`（`0x7C`），Issuer `0x0020` IETF，格式编号 `0xC001`，系列为 BINARY。Payload 恰好是 2 WORD（32bit）。

## 布局

```
TAG WORD          0x0A7C (0000 1010 0111 1100)  总计 5 WORD
Issuer            1 WORD  0x0020 (IETF)
格式编号          1 WORD  0xC001
Payload           2 WORD  address octet 1–2 │ address octet 3–4
```

## 解读与有效性

- 地址 octet 原样保持 network byte order。每个 WORD 中先出现的 octet 是高 8bit，其后的 octet 是低 8bit。
- Payload 只承载一个地址的 32bit。不承载 CIDR prefix length、port、transport protocol。
- 可以表示所有 32bit pattern。unspecified·特殊·保留·多播之类 pattern 的运行含义和可用性，由外部上下文判断，不限制结构有效性。
- IPV4-ADDRESS 和 IPV6-ADDRESS 是不同的格式。不会把 IPv4-mapped IPv6 地址自动转换为本格式，也不会规范化为同一个值。
- 可以把此 Value 用作 Reference 的标识符构成要素，但其引用策略和寿命并不包含在地址 bit pattern 中。
- Payload 不是恰好 2 WORD 则拒绝。

## 标准依据

- [RFC 791 — Internet Protocol](https://www.rfc-editor.org/rfc/rfc791.html) 把 IPv4 地址定义为 4 octet（32bit）固定长度，并把 Source Address 和 Destination Address 各定义为 32bit field。Appendix B 的 octet 传输顺序以及各 octet 的 most-significant-bit-first 规则保留在 Payload 中。
- GEUL TAG、Issuer 分配、16bit WORD 打包、Length 不是 RFC 791 的一部分，而是本格式增加的 framing 规则。

## 长度

- 总计是 TAG 1 WORD、Issuer 1 WORD、格式编号 1 WORD、Payload 2 WORD 之和，恰好 5 WORD，使用直接长度 `LLLL=0100`。没有 Length 扩展 TAG、descriptor、padding。
- Payload 不是恰好 2 WORD 则拒绝。

## 示例

IPv4 地址 `1.2.3.4`：

```
0a7c 0020 c001 0102 0304
```
