---
title: "BIT-VECTOR (0x080L)"
weight: 128
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "BIT-VECTOR は長さを明示した raw bit sequence である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BIT-VECTOR は長さを明示した raw bit sequence である。Value 直接コード `0x080L`、系列 BINARY である。最初の 2 Payload WORD は unsigned 32bit の bit count `N` で、その後に `ceil(N/16)` WORD が続く。

| 項目 | 値 |
|---|---|
| 名前 | `BIT-VECTOR` (規格ドキュメント BIND `BIT-VECTOR`) |
| TAG ID | `0x080L` |
| Codec ID | `0x00000800` |
| 規格ドキュメント | `0x00000000/codecs/0x00000800/` (DECLARE の対象 `0800`) |
| セクション | 4 `0100` (Value)、セクション内オフセット C = 0 |
| Kind | Value · 系列: BINARY |
| TAG WORD | `0000 1000 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | bit-count の後に MSB-first で保存した N bit |
| Hugo 側 | `value/binary/bit-vector.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bit-count` | #2 | 生値 2 WORD |  |  |
| 2 | `bits` | #3 | 残り生値(`0xFFFF`) |  |  |

## レイアウト {#레이아웃}

```
TAG WORD          0000 1000 0000 LLLL      Codec 0x080L
[Length 拡張 TAG] 全体が 15 WORD 以上のとき
Payload WORD 1st–2nd       Bit Count N (上位 16bit │ 下位 16bit)
Payload WORD 3rd ... Nth   Payload bits, MSB-first
```

## 解釈と有効性 {#해석과-유효성}

- `N` は最初の 2 Payload WORD を big-endian unsigned 32bit 整数として読んだ値である。
- payload bit は各 WORD の最上位ビットから順に埋める。
- payload WORD 数はちょうど `ceil(N/16)` で、最後の WORD の使わない下位 bit はすべて 0 でなければならない。
- `N=0` なら payload WORD はない。二つの count WORD がすでに Payload をなすので、Payload は最小 1 WORD という規則と衝突しない。

## 形式の位置づけ {#형식-지위}

- unsigned 32bit の bit count、MSB-first の配置、最後の WORD の zero padding は、外部の産業標準を引用したものではなく GEUL 固有の framing である。
- GEUL の TAG、Length、16bit WORD の規則を含め、このページが表現を定義する。

## 長さ {#길이}

- 全体は TAG 1 WORD、Length 拡張 TAG(あれば)と Payload を合わせた WORD 数である。14 WORD 以下は直接長、15 WORD 以上は `1110`·`1111` の拡張長を使い、拡張 TAG も全体の数に入る([レコードと TAG WORD](../record.md))。

## 例 {#예시}

- 空の bit vector は count `0000 0000`、payload なし、全体 3 WORD、`LLLL=0010` である。全体は `0802 0000 0000` である。
- bit sequence `101` は count `0000 0003`、payload `A000`、全体 4 WORD、`LLLL=0011` である。全体は `0803 0000 0003 A000` である。

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00000800/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000080000000000
BODY
#1 DECLARE 0x0800
#2 FIELD #1 0x0002
#3 FIELD #1 rest
#4 BIND #1 "BIT-VECTOR"
#5 BIND #2 "bit-count"
#6 BIND #3 "bits"
```
