---
title: "IPV6-ADDRESS"
weight: 1006
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "IPV6-ADDRESS 是原样按顺序承载 IPv6 地址 128bit 的固定 11 WORD IETF Issuer 格式。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IPV6-ADDRESS 是承载 IPv6 地址 128bit 值的固定宽度 Value。Value `ISSUER-1WORD`（`0x7C`），Issuer `0x0020` IETF，格式编号 `0xC002`，系列为 BINARY。Payload 恰好是 8 WORD（128bit）。

## 布局

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  总计 11 WORD
Issuer            1 WORD  0x0020 (IETF)
格式编号          1 WORD  0xC002
Payload           8 WORD (128位)  IPv6 address, high-order bit → low-order bit
```

## 解读与有效性

- 把八个 Payload WORD 从高位 WORD 起连接，按顺序原样读取 IPv6 地址 field 的 128bit。每个 WORD 中先出现的 octet 是高 8bit。
- Payload 只承载一个地址的 128bit。不承载 CIDR prefix length、port、transport protocol。
- zone identifier 不包含在地址的 128bit 中，所以不放入 Payload。需要 zone 的 scoped address，通过 interface 或 Edge·Reference·Profile 之类的外部上下文给出。
- 可以表示所有 128bit pattern。unspecified·loopback·multicast·特殊·保留 pattern 的运行含义和可用性，由外部上下文判断，不限制结构有效性。
- IPV4-ADDRESS 和 IPV6-ADDRESS 是不同的格式。IPv4-mapped IPv6 地址也作为 128bit IPv6 值保留，不会自动与 IPV4-ADDRESS 等同，也不会相互规范化。
- 可以把此 Value 用作 Reference 的标识符构成要素，但 scope 和引用策略并不包含在地址 bit pattern 中。

## 标准依据

- [RFC 4291 — IP Version 6 Addressing Architecture](https://www.rfc-editor.org/rfc/rfc4291.html) 把 IPv6 地址定义为 128bit identifier，并规定了包括 unicast·anycast·multicast、IPv4-mapped IPv6 在内的地址 bit format。本格式不重新解读这 128bit，而是原样保留。
- [RFC 8200 — Internet Protocol, Version 6 (IPv6) Specification](https://www.rfc-editor.org/rfc/rfc8200.html) 把 IPv6 packet 的 Source Address 和 Destination Address 各定义为 128bit field。Payload WORD 保留该地址 field 从 high-order bit 到 low-order bit 的顺序。
- [RFC 4007 — IPv6 Scoped Address Architecture](https://www.rfc-editor.org/rfc/rfc4007.html) 指出 non-global address 的 zone 不是编码在地址本身中，而是由 context 决定。因此 zone identifier 放在 Payload 之外。
- RFC 4291 的字符串写法只能用于说明和输入输出。[RFC 5952 — A Recommendation for IPv6 Address Text Representation](https://www.rfc-editor.org/rfc/rfc5952.html) 没有规定内部存储格式，所以不把它的字符串 canonicalization 用作这条 binary 记录的 canonicalization。
- GEUL TAG、Issuer 分配、直接 Length、16bit WORD framing 不是这些 RFC 的一部分，而是本格式增加的规则。

## 长度

- 总计是 TAG 1 WORD、Issuer 1 WORD、格式编号 1 WORD、Payload 8 WORD 之和，恰好 11 WORD，使用直接长度 `LLLL=1010`。没有 Length 扩展 TAG、descriptor、padding。
- Payload 不是恰好 8 WORD 则拒绝。

## 示例

IPv6 地址 `2001:db8::1`：

```
0d7c 0020 c002 2001 0db8 0000 0000 0000 0000 0000 0001
```

- 字符串的缩写写法不影响 Payload。
