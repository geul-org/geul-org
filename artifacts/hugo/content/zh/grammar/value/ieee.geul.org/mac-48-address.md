---
title: "MAC-48-ADDRESS"
weight: 1031
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "MAC-48-ADDRESS 是承载 48-bit IEEE 802 MAC 地址值的定宽 Value。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

MAC-48-ADDRESS 是承载 48-bit IEEE 802 MAC 地址值的定宽 Value。Value `VALUE-ISSUER-2WORD`（`0x09DL`），Issuer `0x0000000D` IEEE，Codec 编号 `0x0000C000`，系列 BINARY。Payload 恰好是 3 WORD（6 octet，48bit）。

## 布局 {#레이아웃}

```
TAG WORD          0x09D7 (0000 1001 1101 0111)  总计 8 WORD
Issuer            2 WORD  0x0000000D (IEEE)
Codec 编号        2 WORD  0x0000C000
Payload           3 WORD  octet 0 → 1 │ octet 2 → 3 │ octet 4 → 5
```

## 解释与有效性 {#해석과-유효성}

- 48-bit MAC 地址的六个 octet 保持其书写字符串与 LAN 传输中的 octet 顺序。将 octet 0–1、2–3、4–5 分别按从 WORD 高位 octet 到低位 octet 的顺序组合。
- 在 IEEE 802 介质上，每个 octet 的 least-significant bit 先传输，但不因此而翻转 octet 内的 bit。I/G 与 U/L 原样保留在 octet 0 的 least-significant bit 及其下一个 bit。
- I/G=0 是 individual 地址，在 destination 上作为 unicast；I/G=1 是 group 地址，作为 multicast 或 broadcast。U/L=0 是 universally administered 地址，U/L=1 是 locally administered 地址。
- 不因 I/G 或 U/L 的值而在结构上排除任何 pattern。universally/locally administered、individual/group 地址均可表示，locally administered、randomized、spoofed、virtual MAC 地址也都能表示为 48bit 值。
- 此值只保留所观测到或所给出地址的 48bit。不保证是特定设备的永久地址、全球唯一性、设备·用户认证、所有权，或与同一设备的持续绑定。
- 此格式只处理恰好 48bit 的 IEEE 802 MAC 地址。不承载 EUI-64 及其他 64-bit MAC 地址。IEEE RA 将历史术语 `MAC-48` 说明为 obsolete，但并非所有 48-bit MAC 地址都可称为 EUI-48，所以不自动将此格式等同于 EUI-48。
- Payload 不是恰好 3 WORD 则拒绝。

## 标准依据 {#표준-근거}

- IEEE Registration Authority 的 [Standard Group MAC Addresses](https://standards.ieee.org/wp-content/uploads/import/documents/tutorials/macgrp.pdf) 说明：48-bit LAN MAC 地址以传输顺序的六个 octet 书写，每个 octet 从 least-significant bit 起传输，I/G 与 U/L 是第一个 octet 的两个 least-significant bit。此格式原样保留 octet 与 bit 位置。
- IEEE Registration Authority 的 [Guidelines for Use of EUI, OUI, and CID](https://standards.ieee.org/wp-content/uploads/import/documents/tutorials/eui.pdf) 将 I/G=0/1 定义为 individual/group，将 U/L=0/1 定义为 universal/local administration，并说明 local 地址不是全局唯一的。它还说明了 `MAC-48` 与 EUI-48 在历史术语上的关系与差异。
- [IEEE SA — MAC Addresses](https://standards.ieee.org/products-programs/regauth/mac/) 说明 EUI-48·EUI-64 可用作 MAC 地址等。这并不意味着把 EUI-64 放入这个 48-bit 记录。
- [RFC 9724 — State of Affairs for Randomized and Changing MAC Addresses](https://www.rfc-editor.org/rfc/rfc9724.html) 与 [RFC 9797 — Randomized and Changing MAC Addresses](https://www.rfc-editor.org/rfc/rfc9797.html) 记录了实际设备可以随机生成并更换 locally administered MAC 地址。因此不能仅凭 MAC 值推断永久的设备 identity。
- GEUL TAG、Issuer 分配、直接 Length、16bit WORD framing 不属于 IEEE 802 或上述资料，而是此格式新增的规则。

## 长度 {#길이}

- 总计是 TAG 1 WORD、Issuer 2 WORD、Codec 编号 2 WORD、Payload 3 WORD 之和，恰好 8 WORD，使用直接长度 `LLLL=0111`。没有 Length 扩展 TAG、descriptor、padding。
- Payload 不是恰好 3 WORD 则拒绝。

## 示例 {#예시}

locally administered individual（unicast）地址 `02:00:5e:10:00:00`（第一个 octet `0x02` 的 I/G=0，U/L=1）：

```
09D7 0000 000D 0000 C000 0200 5E10 0000
```
