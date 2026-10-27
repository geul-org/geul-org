---
title: "BOOL"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "BOOL 是承载逻辑值 false 和 true 的固定 2 WORD Value。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BOOL 是表示逻辑值 false 和 true 的 Value。Value 直接码 `0x00`，系列为 NUMERIC。它与承载数字 0 和 1 的 SIGNED-INTEGER·UNSIGNED-INTEGER 是不同的类型。

## 布局

```
TAG WORD          0x0880 (0000 1000 1000 0000)  总计 2 WORD
Payload           1 WORD  Boolean Code
```

## 解读与有效性

- Payload `0000` 是 false，`0001` 是 true。
- 没有 padding 或 descriptor。
- Payload 恰好是 `0000` 或 `0001`。其他 16 位值 invalid，予以拒绝。
- 其他 Length 表示一律 invalid，予以拒绝。

## 长度

- 总计是 TAG 1 WORD 与 Payload 1 WORD 之和，恰好 2 WORD，使用直接长度 `LLLL=0001`。没有 Length 扩展 TAG、descriptor、padding。
- Payload 不是恰好 1 WORD 则拒绝。

## 示例

| 完整记录（TAG + Payload） | Payload | 判定 |
|---|---|---|
| `0880 0000` | `0000` | false，规范 |
| `0880 0001` | `0001` | true，规范 |
| `0880 0002` | `0002` | invalid |
| `0880 ffff` | `ffff` | invalid |
| Length 不是 `0001` 的 TAG + `0000` 或 `0001` | `0000` 或 `0001` | invalid |

## 格式地位

- 把 `0000`/`0001` 的 16 位 code word 与 GEUL TAG 绑定的这种表示，是 GEUL 专有的 scalar profile。
- 逻辑值本身是通用的，但不主张存在与这种 1 WORD 表示对应的单一工业标准。
