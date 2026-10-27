---
title: "BINARY-FLOAT"
weight: 4
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "BINARY-FLOAT は、IEEE 754 binary16/32/64/128 の interchange ビット列をそのまま収める Value だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BINARY-FLOAT は、IEEE 754 binary interchange scalar を表す Value だ。Value 直接コード `0x03`、系列 NUMERIC だ。Payload が 1/2/4/8 WORD なら、それぞれ binary16/32/64/128 だ。interchange ビット列をそのまま保存し、他の Payload サイズは許さない。

## レイアウト

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x03
[Length 拡張 TAG] 全体が 15 WORD 以上のとき
Payload WORD 1st  (上位 WORD)   IEEE Binary Interchange 1st
...
Payload WORD Nth  (下位 WORD)   IEEE Binary Interchange Nth
```

## 解釈

- Payload WORD を big-endian 順に連ねて、該当する幅の IEEE 754 binary interchange ビット列として読む。
- NaN payload と signed zero を含む interchange ビットパターンを保存する。
- デコーダは、NaN を任意の正規 NaN 一つに置き換えたり、signed zero の符号を消したりしてはならない。
- 丸め方式と算術動作は、このシリアライズ形式が定めない。

## 長さ

全体は、TAG 1 WORD、Length 拡張 TAG(あれば)、Payload を合わせた WORD 数だ([レコードと TAG WORD](/ja/grammar/record/))。

| 形式 | Payload | Length コード | Length 拡張 TAG | 全体 Length |
|---|---:|---|---|---:|
| binary16 | 1 WORD | `0001` | なし | 2 WORD |
| binary32 | 2 WORD | `0010` | なし | 3 WORD |
| binary64 | 4 WORD | `0100` | なし | 5 WORD |
| binary128 | 8 WORD | `1000` | なし | 9 WORD |

binary128 も 1~14 WORD の直接範囲にあるので、Length 拡張 TAG を使わない。

## 有効性

- Payload は、ちょうど 1、2、4、8 WORD のいずれかだ。
- 各 Payload サイズは、上の表の Length 表現とちょうど合わなければならない。
- 幅を変える再エンコードや、Payload の前後の padding WORD は許さない。

## 例

| 形式 | TAG | Length 拡張 TAG | Payload の例 | 判定 |
|---|---|---|---|---|
| binary16 | `0883` | なし | `0000` | 正規 |
| binary32 | `0903` | なし | `0000 0000` | 正規 |
| binary64 | `0A03` | なし | `0000 0000 0000 0000` | 正規 |
| binary128 | `0C03` | なし | 8 WORD ビット列 | 正規 |
| 任意 | Length が示すサイズと不一致 | 任意 | 任意 | invalid |

## 標準の根拠

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): binary16、binary32、binary64、binary128 の interchange encoding を適用する。GEUL は、そのビット列に TAG と 16ビット WORD big-endian framing だけを加える。
