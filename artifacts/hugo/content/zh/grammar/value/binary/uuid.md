---
title: "UUID"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "UUID 是原样按 canonical 16 octet 承载 RFC 9562 UUID 128bit 值的固定 9 WORD Value。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UUID 是承载 RFC 9562 UUID 128bit 值的固定宽度 Value。Value 直接码 `0x60`，系列为 BINARY。Payload 恰好是 8 WORD（16 octet，128bit）。

## 布局

```
TAG WORD          0x0C60 (0000 1100 0110 0000)  总计 9 WORD
Payload           8 WORD (128位)  UUID octet 0 → octet 15
```

## 解读与有效性

- 把 RFC 9562 canonical UUID 的 octet 0 到 octet 15 按顺序每两个 octet 一组。先出现的 octet 是 WORD 的高 8bit。不重新排列或重新编码 UUID 的 field、version bit、variant bit。
- `8-4-4-4-12` hex-and-dash 字符串只是输入输出表示。大小写或 dash 不放入 Payload，只存放解析结果的 16 octet。
- 这个 UUID Value 无损保留 128bit pattern。在 RFC 9562 variant `10xx` 中，version 1、3、4、5、6、7 是标准 layout，version 8 是 custom UUID format。version 2 为 DCE Security 保留，RFC 没有规定 layout，version 0 是 unused，version 9–15 为 future definition 保留。其他 variant 也为兼容或未来定义而保留。
- Nil UUID 是 128bit 全 0，Max UUID 是 128bit 全 1 的特殊值。包括保留·unused version/variant 在内的 128bit pattern 也不在结构上排除，该 pattern 的含义和互操作性，由适用标准和外部上下文判断。
- UUID 的同一性以 Payload 的 128bit 值是否相同来判断。值相同这一事实，并不保证对象的认证、所有权、当前存在、可解析性、访问权限。
- 存放 Microsoft COM GUID 时，不原样复制 mixed-endian 的内存·序列化表示。先转换为 RFC 9562 canonical field/octet 顺序的 16 octet。
- Payload 不是恰好 8 WORD 则拒绝。

## 标准依据

- [RFC 9562 — Universally Unique IDentifiers (UUIDs)](https://www.rfc-editor.org/rfc/rfc9562.html) 把 UUID 定义为 16 octet（128bit），并规定 field 以 most-significant-byte-first 编码，在 binary format 中按 big-endian field 顺序相连。variant 在 octet 8 的高位 bit，version 在 octet 6 的高 4bit，本格式原样保留这些位置。
- RFC 9562 Sections 4.1–5.10 区分 variant 与 version 1–8、Nil、Max、保留范围。RFC 9562 取代 RFC 4122，所以本格式现行的规范依据是 RFC 9562。
- RFC 9562 的 hex-and-dash ABNF 是 text 表示，COM GUID little-endian caveat 也另有说明。GEUL 只把 RFC UUID 的 canonical 16 octet 放入 Payload。
- GEUL TAG、直接 Length、16bit WORD framing 不是 RFC 9562 的一部分，而是本格式增加的规则。

## 长度

- 总计是 TAG 1 WORD 与 Payload 8 WORD 之和，恰好 9 WORD，使用直接长度 `LLLL=1000`。没有 Length 扩展 TAG、descriptor、padding。
- Payload 不是恰好 8 WORD 则拒绝。

## 示例

RFC 9562 Appendix A.6 的 UUIDv7 test vector `017f22e2-79b0-7cc3-98c4-dc0c0c07398f`：

```
0c60 017f 22e2 79b0 7cc3 98c4 dc0c 0c07 398f
```

- TAG `0c60`，Payload `017f 22e2 79b0 7cc3 98c4 dc0c 0c07 398f`。
