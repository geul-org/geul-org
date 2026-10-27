---
title: "BINARY-FLOAT"
weight: 4
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "BINARY-FLOAT 是原样承载 IEEE 754 binary16/32/64/128 interchange 位串的 Value。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BINARY-FLOAT 是表示 IEEE 754 binary interchange scalar 的 Value。Value 直接码 `0x03`，系列为 NUMERIC。Payload 为 1/2/4/8 WORD 时，分别是 binary16/32/64/128。原样保留 interchange 位串，不允许其他 Payload 大小。

## 布局

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x03
[Length 扩展 TAG] 总计 15 WORD 以上时
Payload WORD 1st  (高位 WORD)   IEEE Binary Interchange 1st
...
Payload WORD Nth  (低位 WORD)   IEEE Binary Interchange Nth
```

## 解读

- 把 Payload WORD 按 big-endian 顺序连接，读作相应宽度的 IEEE 754 binary interchange 位串。
- 保留包括 NaN payload 和 signed zero 在内的 interchange 位模式。
- 解码器不得把 NaN 随意替换为某个规范 NaN，也不得抹去 signed zero 的符号。
- 舍入方式和算术行为不由这种序列化格式规定。

## 长度

总计是 TAG 1 WORD、Length 扩展 TAG（如有）、Payload 之和的 WORD 数（[记录与 TAG WORD](/zh/grammar/record/)）。

| 格式 | Payload | Length 码 | Length 扩展 TAG | 总 Length |
|---|---:|---|---|---:|
| binary16 | 1 WORD | `0001` | 无 | 2 WORD |
| binary32 | 2 WORD | `0010` | 无 | 3 WORD |
| binary64 | 4 WORD | `0100` | 无 | 5 WORD |
| binary128 | 8 WORD | `1000` | 无 | 9 WORD |

binary128 也在 1~14 WORD 的直接范围内，所以不使用 Length 扩展 TAG。

## 有效性

- Payload 恰好是 1、2、4、8 WORD 之一。
- 每种 Payload 大小必须与上表的 Length 表示恰好吻合。
- 不允许改变宽度的重新编码，也不允许 Payload 前后带 padding WORD。

## 示例

| 格式 | TAG | Length 扩展 TAG | Payload 示例 | 判定 |
|---|---|---|---|---|
| binary16 | `0883` | 无 | `0000` | 规范 |
| binary32 | `0903` | 无 | `0000 0000` | 规范 |
| binary64 | `0A03` | 无 | `0000 0000 0000 0000` | 规范 |
| binary128 | `0C03` | 无 | 8 WORD 位串 | 规范 |
| 任意 | 与 Length 所示大小不符 | 任意 | 任意 | invalid |

## 标准依据

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/)：采用 binary16、binary32、binary64、binary128 interchange encoding。GEUL 只在该位串上增加 TAG 和 16 位 WORD big-endian 分帧。
