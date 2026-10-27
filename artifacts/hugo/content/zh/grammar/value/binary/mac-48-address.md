---
title: "MAC-48-ADDRESS"
weight: 1007
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "MAC-48-ADDRESS 是原样按 octet 顺序承载 48bit IEEE 802 MAC 地址的固定 6 WORD IEEE Issuer 格式。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

MAC-48-ADDRESS 是承载 48-bit IEEE 802 MAC 地址值的固定宽度 Value。Value `ISSUER-1WORD`（`0x7C`），Issuer `0x0040` IEEE，格式编号 `0xC000`，系列为 BINARY。Payload 恰好是 3 WORD（6 octet，48bit）。

## 布局

```
TAG WORD          0x0AFC (0000 1010 1111 1100)  总计 6 WORD
Issuer            1 WORD  0x0040 (IEEE)
格式编号          1 WORD  0xC000
Payload           3 WORD  octet 0 → 1 │ octet 2 → 3 │ octet 4 → 5
```

## 解读与有效性

- 48-bit MAC 地址的六个 octet 原样保持书写字符串和 LAN 传输的 octet 顺序。把 octet 0–1、2–3、4–5 分别按 WORD 的高 octet 到低 octet 的顺序打包。
- 在 IEEE 802 介质上，每个 octet 的 least-significant bit 先传输，但并不因此而翻转 octet 内的 bit。I/G 和 U/L 原样保留在 octet 0 的 least-significant bit 及其后一个 bit 上。
- I/G=0 是 individual 地址，在 destination 上作为 unicast 使用；I/G=1 是 group 地址，作为 multicast 或 broadcast 使用。U/L=0 是 universally administered，U/L=1 是 locally administered 地址。
- 不因 I/G 或 U/L 的值而在结构上排除任何 pattern。universally/locally administered、individual/group 地址都可以表示，locally administered·randomized·spoofed·virtual MAC 地址也可以用 48bit 值表示。
- 这个值只保留观测到或给出的地址的 48bit。不保证是某个设备的永久地址、全球唯一性、设备·用户认证、所有权，或与同一设备的持续绑定。
- 本格式只处理恰好 48bit 的 IEEE 802 MAC 地址。不承载 EUI-64 及其他 64-bit MAC 地址。IEEE RA 把历史术语 `MAC-48` 说明为 obsolete，但并非所有 48-bit MAC 地址都能称为 EUI-48，所以不自动把本格式等同于 EUI-48。
- Payload 不是恰好 3 WORD 则拒绝。

## 标准依据

- IEEE Registration Authority 的 [Standard Group MAC Addresses](https://standards.ieee.org/wp-content/uploads/import/documents/tutorials/macgrp.pdf) 把 48-bit LAN MAC 地址写成按传输顺序的六个 octet，并说明每个 octet 从 least-significant bit 开始传输，I/G 和 U/L 是第一个 octet 的两个 least-significant bit。本格式原样保留 octet 和 bit 位置。
- IEEE Registration Authority 的 [Guidelines for Use of EUI, OUI, and CID](https://standards.ieee.org/wp-content/uploads/import/documents/tutorials/eui.pdf) 把 I/G=0/1 定义为 individual/group，把 U/L=0/1 定义为 universal/local administration，并说明 local 地址不是全球唯一的。它还说明了 `MAC-48` 与 EUI-48 在历史术语上的关系和区别。
- [IEEE SA — MAC Addresses](https://standards.ieee.org/products-programs/regauth/mac/) 说明 EUI-48·EUI-64 可用作 MAC 地址等。这并不意味着把 EUI-64 放入这条 48-bit 记录。
- [RFC 9724 — State of Affairs for Randomized and Changing MAC Addresses](https://www.rfc-editor.org/rfc/rfc9724.html) 和 [RFC 9797 — Randomized and Changing MAC Addresses](https://www.rfc-editor.org/rfc/rfc9797.html) 记录了实际设备可以随机生成并更改 locally administered MAC 地址。因此不能仅凭 MAC 值推断永久的设备 identity。
- GEUL TAG、Issuer 分配、直接 Length、16bit WORD framing 不是 IEEE 802 或上述资料的一部分，而是本格式增加的规则。

## 长度

- 总计是 TAG 1 WORD、Issuer 1 WORD、格式编号 1 WORD、Payload 3 WORD 之和，恰好 6 WORD，使用直接长度 `LLLL=0101`。没有 Length 扩展 TAG、descriptor、padding。
- Payload 不是恰好 3 WORD 则拒绝。

## 示例

locally administered individual（unicast）地址 `02:00:5e:10:00:00`（第一个 octet `0x02` 的 I/G=0，U/L=1）：

```
0afc 0040 c000 0200 5e10 0000
```
