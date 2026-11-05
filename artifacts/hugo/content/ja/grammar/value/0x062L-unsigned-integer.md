---
title: "UNSIGNED-INTEGER (0x062L)"
weight: 98
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "UNSIGNED-INTEGER は符号なし整数値を表す Value である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `UNSIGNED-INTEGER` (規格ドキュメント BIND `UNSIGNED-INTEGER`) |
| TAG ID | `0x062L` |
| Codec ID | `0x00000620` |
| 規格ドキュメント | `0x00000000/codecs/0x00000620/` (DECLARE 対象 `0620`) |
| セクション | 3 `0011` (Value)、セクション内オフセット C = 2 |
| Kind | Value · 系列: NUMERIC |
| TAG WORD | `0000 0110 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引説明 | 最小 WORD big-endian unsigned magnitude 整数 |
| Hugo 側 | `value/numeric/unsigned-integer.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `magnitude` | #2 | 残りの生値(`0xFFFF`) |  |  |

UNSIGNED-INTEGER は符号なし整数値を表す Value である。Value 直接コード `0x062L`、系列 NUMERIC である。Payload 全体を big-endian WORD 順の任意精度 unsigned magnitude として読む。Payload は最小 1 WORD で、最小 WORD の正規表現のみ許可する。

## レイアウト {#레이아웃}

```
TAG WORD          0000 0110 0010 LLLL      Codec 0x062L
[Length 拡張 TAG] 全体が 15 WORD 以上のとき
Payload WORD 1st  (上位 WORD)   Unsigned Magnitude 1st
...
Payload WORD Nth  (下位 WORD)   Unsigned Magnitude Nth
```

## 解釈 {#해석}

- 最初の Payload WORD が最上位、最後の WORD が最下位である。
- Payload が N WORD なら `16N` bit の unsigned magnitude 1 つとして読む。
- この幅は宣言された保存幅ではなく、bit width descriptor はない。

## 正規表現 {#정규-표현}

- 0 は Payload 1 WORD `0000` である。
- Payload が 2 WORD 以上のとき、最初の WORD が `0000` なら削っても値が同じなので非正規である。
- デコーダは不要な先頭 zero WORD のある表現を拒否しなければならない。

## 長さ {#길이}

- 全体は TAG 1 WORD、Length 拡張 TAG(あれば)、Payload を合わせた WORD 数である。14 WORD 以下は直接長、15 WORD 以上は `1110`・`1111` 拡張長を使い、拡張 TAG も全体数に含まれる([レコードと TAG WORD](../record.md))。
- UINT8・UINT16・UINT32 のような宣言幅は保存せず、数値だけを保存する。

## 例 {#예시}

| 値 | Payload WORD | 判定 |
|---:|---|---|
| 0 | `0000` | 正規 |
| 1 | `0001` | 正規 |
| 65535 | `FFFF` | 正規 |
| 65536 | `0001 0000` | 正規 |
| 1 | `0000 0001` | 非正規: 不要な先頭 `0000` |
| 7 WORD Payload | TAG `0627`(直接長 `LLLL=0111`、全体 8 WORD)に続く 7 WORD | 正規 |
| 7 WORD Payload | 拡張長 TAG と拡張値 `0009` に続く 7 WORD | 非正規: 14 WORD 以下は直接長で書く |

## 形式の位置づけ {#형식-지위}

- 任意精度の unsigned magnitude を最小 16 ビット WORD 列に正規化して GEUL TAG と組み合わせるこの表現は、GEUL 固有の scalar profile である。
- UINT8/16/32/64 のような固定幅の外部型とやり取りするときは、範囲検査と明示的な幅変換が必要である。

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00000620/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000062000000000
BODY
#1 DECLARE 0x0620
#2 FIELD #1 rest
#3 BIND #1 "UNSIGNED-INTEGER"
#4 BIND #2 "magnitude"
```
