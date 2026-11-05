---
title: "IPV4-ADDRESS"
weight: 1034
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "IPV4-ADDRESS 是承载 IPv4 地址 32bit 值的定宽 Value。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IPV4-ADDRESS 是承载 IPv4 地址 32bit 值的定宽 Value。Value `VALUE-ISSUER-2WORD`（`0x09DL`），Issuer `0x00000007` IETF，Codec 编号 `0x0000C001`，系列 BINARY。Payload 恰好是 2 WORD（32bit）。

## 布局 {#레이아웃}

```
TAG WORD          0x09D6 (0000 1001 1101 0110)  总计 7 WORD
Issuer            2 WORD  0x00000007 (IETF)
Codec 编号        2 WORD  0x0000C001
Payload           2 WORD  address octet 1–2 │ address octet 3–4
```

## 解释与有效性 {#해석과-유효성}

- 地址 octet 保持 network byte order。每个 WORD 中先出现的 octet 是高 8bit，其后的 octet 是低 8bit。
- Payload 只承载一个地址的 32bit。不承载 CIDR prefix length、port、transport protocol。
- 所有 32bit pattern 均可表示。unspecified·特殊·保留·multicast 等 pattern 的运行含义与可用性，在外部上下文中判断，不限制结构上的有效性。
- IPV4-ADDRESS 与 IPV6-ADDRESS 是不同的格式。不会自动将 IPv4-mapped IPv6 地址转换为此格式，也不会规范化为同一个值。
- 此 Value 可用作 Reference 的标识符构成要素，但其引用策略与生命周期并不包含在地址 bit pattern 中。
- Payload 不是恰好 2 WORD 则拒绝。

## 标准依据 {#표준-근거}

- [RFC 791 — Internet Protocol](https://www.rfc-editor.org/rfc/rfc791.html) 将 IPv4 地址定义为 4 octet（32bit）定长，并将 Source Address 与 Destination Address 各自定义为 32bit field。Payload 保留了 Appendix B 的 octet 传输顺序以及每个 octet 的 most-significant-bit-first 规则。
- GEUL TAG、Issuer 分配、16bit WORD 组合、Length 不属于 RFC 791，而是此格式新增的 framing 规则。

## 长度 {#길이}

- 总计是 TAG 1 WORD、Issuer 2 WORD、Codec 编号 2 WORD、Payload 2 WORD 之和，恰好 7 WORD，使用直接长度 `LLLL=0110`。没有 Length 扩展 TAG、descriptor、padding。
- Payload 不是恰好 2 WORD 则拒绝。

## 示例 {#예시}

IPv4 地址 `1.2.3.4`：

```
09D6 0000 0007 0000 C001 0102 0304
```
