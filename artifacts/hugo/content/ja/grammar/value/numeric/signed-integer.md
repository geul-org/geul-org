---
title: "SIGNED-INTEGER"
weight: 2
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "SIGNED-INTEGER は、符号付き整数を最小 WORD の2の補数で収める Value だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SIGNED-INTEGER は、符号付き整数の値を表す Value だ。Value 直接コード `0x01`、系列 NUMERIC だ。Payload 全体を big-endian WORD 順の任意精度2の補数整数として読む。Payload は最小 1 WORD で、最小 WORD の正規表現だけを許す。

## レイアウト

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x01
[Length 拡張 TAG] 全体が 15 WORD 以上のとき
Payload WORD 1st  (上位 WORD)   Integer 1st
...
Payload WORD Nth  (下位 WORD)   Integer Nth
```

## 解釈

- 最初の Payload WORD の最上位ビットが、整数全体の符号ビットだ。
- すべての Payload WORD を、一続きの2の補数ビット列として読む。最初の WORD が最も高い桁、最後の WORD が最も低い桁だ。
- Payload が N WORD なら、解釈幅は `16N` bit だ。この幅は宣言された保存幅ではなく、正規表現で決まる値の表現幅だ。
- Byte Count や bit width descriptor はない。

## 正規表現

- 0 は、Payload 1 WORD の `0000` だ。
- 値を変えない先頭の符号拡張 WORD は禁止する。
- Payload が 2 WORD 以上のとき、次は非正規だ。
  - 最初の WORD が `0000` で、次の WORD の最上位ビットが 0
  - 最初の WORD が `ffff` で、次の WORD の最上位ビットが 1
- 正の数の符号を守る先頭の `0000` は、次の WORD の最上位ビットが 1 のときに許す。
- 負の数の符号を守る先頭の `ffff` は、次の WORD の最上位ビットが 0 のときに許す。
- デコーダは、非正規表現を拒否しなければならない。

## 長さ

- 全体は、TAG 1 WORD、Length 拡張 TAG(あれば)、Payload を合わせた WORD 数だ。14 WORD 以下は直接長さ、15 WORD 以上は `1110`・`1111` の拡張長さを使い、拡張 TAG も全体の数に入る([レコードと TAG WORD](/ja/grammar/record/))。
- INT8・INT16・INT32 のような宣言幅は保存せず、数値だけを保存する。`-32768`~`32767` は 1 WORD で、範囲を超えれば必要なだけ WORD を足す。別個の SIGNED-INT8 形式はない。

## 例

| 値 | Payload WORD | 判定 |
|---:|---|---|
| 0 | `0000` | 正規 |
| 1 | `0001` | 正規 |
| 32767 | `7fff` | 正規 |
| 32768 | `0000 8000` | 正規: 正の符号の保存に `0000` が必要 |
| -1 | `ffff` | 正規 |
| -32768 | `8000` | 正規 |
| -32769 | `ffff 7fff` | 正規: 負の符号の保存に `ffff` が必要 |
| 1 | `0000 0001` | 非正規: 不要な先頭の `0000` |
| -1 | `ffff ffff` | 非正規: 不要な先頭の `ffff` |

## 形式の位置づけ

- 2の補数は広く使われる慣例だが、任意精度の値を最小の 16ビット WORD 列に正規化して GEUL TAG と束ねるこの表現は、GEUL 固有の scalar profile だ。
- INT8/16/32/64 のような固定幅の外部型とやり取りするときは、範囲検査と明示的な幅変換が必要だ。
