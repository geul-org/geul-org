---
title: "UNSIGNED-INTEGER"
weight: 3
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "UNSIGNED-INTEGER は、符号なし整数を最小 WORD の big-endian magnitude で収める Value だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UNSIGNED-INTEGER は、符号なし整数の値を表す Value だ。Value 直接コード `0x02`、系列 NUMERIC だ。Payload 全体を big-endian WORD 順の任意精度 unsigned magnitude として読む。Payload は最小 1 WORD で、最小 WORD の正規表現だけを許す。

## レイアウト

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x02
[Length 拡張 TAG] 全体が 15 WORD 以上のとき
Payload WORD 1st  (上位 WORD)   Unsigned Magnitude 1st
...
Payload WORD Nth  (下位 WORD)   Unsigned Magnitude Nth
```

## 解釈

- 最初の Payload WORD が最も高い桁、最後の WORD が最も低い桁だ。
- Payload が N WORD なら、`16N` bit の unsigned magnitude 一つとして読む。
- この幅は宣言された保存幅ではなく、bit width descriptor はない。

## 正規表現

- 0 は、Payload 1 WORD の `0000` だ。
- Payload が 2 WORD 以上のとき、最初の WORD が `0000` なら、消しても値が同じなので非正規だ。
- デコーダは、不要な先頭の zero WORD がある表現を拒否しなければならない。

## 長さ

- 全体は、TAG 1 WORD、Length 拡張 TAG(あれば)、Payload を合わせた WORD 数だ。14 WORD 以下は直接長さ、15 WORD 以上は `1110`・`1111` の拡張長さを使い、拡張 TAG も全体の数に入る([レコードと TAG WORD](/ja/grammar/record/))。
- UINT8・UINT16・UINT32 のような宣言幅は保存せず、数値だけを保存する。

## 例

| 値 | Payload WORD | 判定 |
|---:|---|---|
| 0 | `0000` | 正規 |
| 1 | `0001` | 正規 |
| 65535 | `ffff` | 正規 |
| 65536 | `0001 0000` | 正規 |
| 1 | `0000 0001` | 非正規: 不要な先頭の `0000` |
| 7 WORD Payload | TAG `0b82`(直接長さ `LLLL=0111`、全体 8 WORD)の後ろの 7 WORD | 正規 |
| 7 WORD Payload | 拡張長さ TAG と拡張値 `0009` の後ろの 7 WORD | 非正規: 14 WORD 以下は直接長さで書く |

## 形式の位置づけ

- 任意精度の unsigned magnitude を最小の 16ビット WORD 列に正規化して GEUL TAG と束ねるこの表現は、GEUL 固有の scalar profile だ。
- UINT8/16/32/64 のような固定幅の外部型とやり取りするときは、範囲検査と明示的な幅変換が必要だ。
