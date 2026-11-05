---
title: "BINARY-FLOAT (0x063L)"
weight: 99
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "BINARY-FLOAT は IEEE 754 binary interchange scalar を表す Value である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `BINARY-FLOAT` (規格ドキュメント BIND `BINARY-FLOAT`) |
| TAG ID | `0x063L` |
| Codec ID | `0x00000630` |
| 規格ドキュメント | `0x00000000/codecs/0x00000630/` (DECLARE 対象 `0630`) |
| セクション | 3 `0011` (Value)、セクション内オフセット C = 3 |
| Kind | Value · 系列: NUMERIC |
| TAG WORD | `0000 0110 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引説明 | Payload 1/2/4/8 WORD の IEEE 754 binary16/32/64/128 scalar |
| Hugo 側 | `value/numeric/binary-float.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `ieee-binary` | #2 | 残りの生値(`0xFFFF`) |  |  |

BINARY-FLOAT は IEEE 754 binary interchange scalar を表す Value である。Value 直接コード `0x063L`、系列 NUMERIC である。Payload が 1/2/4/8 WORD なら、それぞれ binary16/32/64/128 である。interchange ビット列をそのまま保存し、他の Payload サイズは許可しない。

## レイアウト {#레이아웃}

```
TAG WORD          0000 0110 0011 LLLL      Codec 0x063L
[Length 拡張 TAG] 全体が 15 WORD 以上のとき
Payload WORD 1st  (上位 WORD)   IEEE Binary Interchange 1st
...
Payload WORD Nth  (下位 WORD)   IEEE Binary Interchange Nth
```

## 解釈 {#해석}

- Payload WORD を big-endian 順に連結し、その幅の IEEE 754 binary interchange ビット列として読む。
- NaN payload と signed zero を含む interchange ビットパターンを保存する。
- デコーダは NaN を任意の正規 NaN 1 つに置き換えたり、signed zero の符号を消したりしてはならない。
- 丸め方式と算術動作はこの直列化形式では定めない。

## 長さ {#길이}

全体は TAG 1 WORD、Length 拡張 TAG(あれば)、Payload を合わせた WORD 数である([レコードと TAG WORD](../record.md))。

| 形式 | Payload | Length コード | Length 拡張 TAG | 全体 Length |
|---|---:|---|---|---:|
| binary16 | 1 WORD | `0001` | なし | 2 WORD |
| binary32 | 2 WORD | `0010` | なし | 3 WORD |
| binary64 | 4 WORD | `0100` | なし | 5 WORD |
| binary128 | 8 WORD | `1000` | なし | 9 WORD |

binary128 も 1~14 WORD の直接範囲にあるため、Length 拡張 TAG は使わない。

## 有効性 {#유효성}

- Payload は正確に 1、2、4、8 WORD のいずれかである。
- 各 Payload サイズは上の表の Length 表現と正確に一致しなければならない。
- 幅を変える再エンコードや、Payload の前後の padding WORD は許可しない。

## 例 {#예시}

| 形式 | TAG | Length 拡張 TAG | Payload 例 | 判定 |
|---|---|---|---|---|
| binary16 | `0631` | なし | `0000` | 正規 |
| binary32 | `0632` | なし | `0000 0000` | 正規 |
| binary64 | `0634` | なし | `0000 0000 0000 0000` | 正規 |
| binary128 | `0638` | なし | 8 WORD ビット列 | 正規 |
| 任意 | Length が示すサイズと不一致 | 任意 | 任意 | invalid |

## 標準の根拠 {#표준-근거}

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): binary16、binary32、binary64、binary128 の interchange encoding を適用する。GEUL はそのビット列に TAG と 16 ビット WORD big-endian のフレーミングだけを加える。

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00000630/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000063000000000
BODY
#1 DECLARE 0x0630
#2 FIELD #1 rest
#3 BIND #1 "BINARY-FLOAT"
#4 BIND #2 "ieee-binary"
```
