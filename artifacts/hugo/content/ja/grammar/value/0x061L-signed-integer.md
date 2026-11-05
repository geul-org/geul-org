---
title: "SIGNED-INTEGER (0x061L)"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "SIGNED-INTEGER は符号付き整数値を表す Value である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `SIGNED-INTEGER` (規格ドキュメント BIND `SIGNED-INTEGER`) |
| TAG ID | `0x061L` |
| Codec ID | `0x00000610` |
| 規格ドキュメント | `0x00000000/codecs/0x00000610/` (DECLARE 対象 `0610`) |
| セクション | 3 `0011` (Value)、セクション内オフセット C = 1 |
| Kind | Value · 系列: NUMERIC |
| TAG WORD | `0000 0110 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引説明 | 最小 WORD の 2 の補数符号付き整数 |
| Hugo 側 | `value/numeric/signed-integer.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `integer` | #2 | 残りの生値(`0xFFFF`) |  |  |

SIGNED-INTEGER は符号付き整数値を表す Value である。Value 直接コード `0x061L`、系列 NUMERIC である。Payload 全体を big-endian WORD 順の任意精度 2 の補数整数として読む。Payload は最小 1 WORD で、最小 WORD の正規表現のみ許可する。

## レイアウト {#레이아웃}

```
TAG WORD          0000 0110 0001 LLLL      Codec 0x061L
[Length 拡張 TAG] 全体が 15 WORD 以上のとき
Payload WORD 1st  (上位 WORD)   Integer 1st
...
Payload WORD Nth  (下位 WORD)   Integer Nth
```

## 解釈 {#해석}

- 最初の Payload WORD の最上位ビットが整数全体の符号ビットである。
- すべての Payload WORD を 1 本の連続した 2 の補数ビット列として読む。最初の WORD が最上位、最後の WORD が最下位である。
- Payload が N WORD なら解釈幅は `16N` bit である。この幅は宣言された保存幅ではなく、正規表現で決まる値の表現幅である。
- Byte Count や bit width descriptor はない。

## 正規表現 {#정규-표현}

- 0 は Payload 1 WORD `0000` である。
- 値を変えない先頭の符号拡張 WORD は禁止する。
- Payload が 2 WORD 以上のとき、次は非正規である。
  - 最初の WORD が `0000` で、次の WORD の最上位ビットが 0
  - 最初の WORD が `FFFF` で、次の WORD の最上位ビットが 1
- 正数の符号を保つ先頭の `0000` は、次の WORD の最上位ビットが 1 のとき許可する。
- 負数の符号を保つ先頭の `FFFF` は、次の WORD の最上位ビットが 0 のとき許可する。
- デコーダは非正規表現を拒否しなければならない。

## 長さ {#길이}

- 全体は TAG 1 WORD、Length 拡張 TAG(あれば)、Payload を合わせた WORD 数である。14 WORD 以下は直接長、15 WORD 以上は `1110`・`1111` 拡張長を使い、拡張 TAG も全体数に含まれる([レコードと TAG WORD](../record.md))。
- INT8・INT16・INT32 のような宣言幅は保存せず、数値だけを保存する。`-32768`~`32767` は 1 WORD で、範囲を超えれば必要なだけ WORD を追加する。別個の SIGNED-INT8 形式はない。

## 例 {#예시}

| 値 | Payload WORD | 判定 |
|---:|---|---|
| 0 | `0000` | 正規 |
| 1 | `0001` | 正規 |
| 32767 | `7FFF` | 正規 |
| 32768 | `0000 8000` | 正規: 正数の符号保存に `0000` が必要 |
| -1 | `FFFF` | 正規 |
| -32768 | `8000` | 正規 |
| -32769 | `FFFF 7FFF` | 正規: 負数の符号保存に `FFFF` が必要 |
| 1 | `0000 0001` | 非正規: 不要な先頭 `0000` |
| -1 | `FFFF FFFF` | 非正規: 不要な先頭 `FFFF` |

## 形式の位置づけ {#형식-지위}

- 2 の補数は広く使われる慣例だが、任意精度の値を最小 16 ビット WORD 列に正規化して GEUL TAG と組み合わせるこの表現は、GEUL 固有の scalar profile である。
- INT8/16/32/64 のような固定幅の外部型とやり取りするときは、範囲検査と明示的な幅変換が必要である。

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00000610/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000061000000000
BODY
#1 DECLARE 0x0610
#2 FIELD #1 rest
#3 BIND #1 "SIGNED-INTEGER"
#4 BIND #2 "integer"
```
