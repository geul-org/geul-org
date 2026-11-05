---
title: "IPV6-ADDRESS"
weight: 1035
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "IPV6-ADDRESS 是承载 IPv6 地址 128bit 值的定宽 Value。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IPV6-ADDRESS 是承载 IPv6 地址 128bit 值的定宽 Value。Value `VALUE-ISSUER-2WORD`（`0x09DL`），Issuer `0x00000007` IETF，Codec 编号 `0x0000C002`，系列 BINARY。Payload 恰好是 8 WORD（128bit）。

## 布局 {#레이아웃}

```
TAG WORD          0x09DC (0000 1001 1101 1100)  总计 13 WORD
Issuer            2 WORD  0x00000007 (IETF)
Codec 编号        2 WORD  0x0000C002
Payload           8 WORD (128位)  IPv6 address, high-order bit → low-order bit
```

## 解释与有效性 {#해석과-유효성}

- 将八个 Payload WORD 从高位 WORD 起连接，按原顺序读取 IPv6 地址 field 的 128bit。每个 WORD 中先出现的 octet 是高 8bit。
- Payload 只承载一个地址的 128bit。不承载 CIDR prefix length、port、transport protocol。
- zone identifier 不包含在地址的 128bit 中，所以不放入 Payload。需要 zone 的 scoped address，通过 interface 或 Edge·Reference·Profile 等外部上下文给出。
- 所有 128bit pattern 均可表示。unspecified·loopback·multicast·特殊·保留 pattern 的运行含义与可用性，在外部上下文中判断，不限制结构上的有效性。
- IPV4-ADDRESS 与 IPV6-ADDRESS 是不同的格式。IPv4-mapped IPv6 地址也作为 128bit IPv6 值保留，不自动等同于 IPV4-ADDRESS，也不相互规范化。
- 此 Value 可用作 Reference 的标识符构成要素，但 scope 与引用策略并不包含在地址 bit pattern 中。

## 标准依据 {#표준-근거}

- [RFC 4291 — IP Version 6 Addressing Architecture](https://www.rfc-editor.org/rfc/rfc4291.html) 将 IPv6 地址定义为 128bit identifier，并规定了包括 unicast·anycast·multicast、IPv4-mapped IPv6 在内的地址 bit format。此格式不重新解释这 128bit，而是原样保留。
- [RFC 8200 — Internet Protocol, Version 6 (IPv6) Specification](https://www.rfc-editor.org/rfc/rfc8200.html) 将 IPv6 packet 的 Source Address 与 Destination Address 各自定义为 128bit field。Payload WORD 保留了该地址 field 从 high-order bit 到 low-order bit 的顺序。
- [RFC 4007 — IPv6 Scoped Address Architecture](https://www.rfc-editor.org/rfc/rfc4007.html) 指出 non-global address 的 zone 并不编码在地址本身中，而是由 context 决定。因此 zone identifier 置于 Payload 之外。
- RFC 4291 的字符串表示只可用于说明和输入输出。[RFC 5952 — A Recommendation for IPv6 Address Text Representation](https://www.rfc-editor.org/rfc/rfc5952.html) 没有规定内部存储格式，所以不把其字符串 canonicalization 用作此 binary 记录的 canonicalization。
- GEUL TAG、Issuer 分配、直接 Length、16bit WORD framing 不属于这些 RFC，而是此格式新增的规则。

## 长度 {#길이}

- 总计是 TAG 1 WORD、Issuer 2 WORD、Codec 编号 2 WORD、Payload 8 WORD 之和，恰好 13 WORD，使用直接长度 `LLLL=1100`。没有 Length 扩展 TAG、descriptor、padding。
- Payload 不是恰好 8 WORD 则拒绝。

## 示例 {#예시}

IPv6 地址 `2001:db8::1`：

```
09DC 0000 0007 0000 C002 2001 0DB8 0000 0000 0000 0000 0000 0001
```

- 字符串的缩写表示不影响 Payload。
