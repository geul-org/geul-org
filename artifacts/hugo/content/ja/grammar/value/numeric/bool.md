---
title: "BOOL"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "BOOL は、論理値 false と true を収める固定 2 WORD の Value だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BOOL は、論理値 false と true を表す Value だ。Value 直接コード `0x00`、系列 NUMERIC だ。数字 0 と 1 を収める SIGNED-INTEGER・UNSIGNED-INTEGER とは異なる型だ。

## レイアウト

```
TAG WORD          0x0880 (0000 1000 1000 0000)  全体 2 WORD
Payload           1 WORD  Boolean Code
```

## 解釈と有効性

- Payload `0000` は false、`0001` は true だ。
- padding や descriptor はない。
- Payload は、ちょうど `0000` または `0001` だ。それ以外の 16ビット値は invalid として拒否する。
- 他の Length 表現はすべて invalid として拒否する。

## 長さ

- 全体は、TAG 1 WORD と Payload 1 WORD を合わせたちょうど 2 WORD で、直接長さ `LLLL=0001` を使う。Length 拡張 TAG、descriptor、padding はない。
- Payload がちょうど 1 WORD でなければ拒否する。

## 例

| 全体のレコード (TAG + Payload) | Payload | 判定 |
|---|---|---|
| `0880 0000` | `0000` | false、正規 |
| `0880 0001` | `0001` | true、正規 |
| `0880 0002` | `0002` | invalid |
| `0880 ffff` | `ffff` | invalid |
| Length が `0001` でない TAG + `0000` または `0001` | `0000` または `0001` | invalid |

## 形式の位置づけ

- `0000`/`0001` の 16ビットの code word と GEUL TAG を束ねたこの表現は、GEUL 固有の scalar profile だ。
- 論理値自体は普遍的だが、この 1 WORD 表現に対応する単一の産業標準を主張しない。
