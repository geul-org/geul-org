---
title: "OPAQUE-BYTES (0x07EL·0x07FL)"
weight: 126
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "OPAQUE-BYTES は意味と形式をこの形式自体では定めない任意のバイト列である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

OPAQUE-BYTES は意味と形式をこの形式自体では定めない任意のバイト列である。Value 直接コード `0x07EL`(偶数バイト)·`0x07FL`(奇数バイト)、系列 BINARY である。バイト数は Codec の最下位ビットと Payload WORD 数で決まる。`2 × Payload WORD 数 − 最下位ビット`であり、Byte Count は置かない([Value](_index.md))。

| 項目 | 値 |
|---|---|
| 名前 | `OPAQUE-BYTES` (偶奇の組。コードごとの名前は下の構成員の表) |
| TAG ID | `0x07EL`·`0x07FL` |
| セクション | 3 `0011` (Value)、セクション内オフセット C = 30~31 |
| Kind | Value · 系列: BINARY |
| 索引の説明 | 意味·形式が不明のバイト列。偶数·奇数バイト |
| Hugo 側 | `value/binary/opaque-bytes.md` |

## 構成員 {#구성원}

このページは偶奇の組をなす二つのコードをまとめて扱う。偶数コードはバイト数が偶数、奇数コードは奇数の値である([レコードと TAG WORD](../record.md#가변-길이-바이트열))。Codec ドキュメントはコードごとに一つである。二つの Codec ドキュメントのフィールドは同じで、DECLARE の対象と名前(BIND)だけが異なる。

| TAG ID | 名前 | バイト数 | Codec ID | 規格ドキュメント | TAG WORD |
|---|---|---|---|---|---|
| `0x07EL` | `OPAQUE-BYTES-EVEN` | 偶数 | `0x000007E0` | `0x00000000/codecs/0x000007E0/` | `0000 0111 1110 LLLL` |
| `0x07FL` | `OPAQUE-BYTES-ODD` | 奇数 | `0x000007F0` | `0x00000000/codecs/0x000007F0/` | `0000 0111 1111 LLLL` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | 残り生値(`0xFFFF`) |  |  |

## レイアウト {#레이아웃}

```
TAG WORD          0000 0111 111P LLLL      Codec 0x07EL/0x07FL
[Length 拡張 TAG] 全体が 15 WORD 以上のとき
Payload WORD 1st ... Nth   バイト / 最後に zero padding
```

## 解釈と有効性 {#해석과-유효성}

- Payload からバイト数の分だけ byte を順に読む。WORD の中では上位 byte が先に来る。
- Payload WORD 数は `ceil(バイト数/2)` である。奇数コードなのに最後の WORD の下位 byte が `00` でなければ拒否する。
- 偶数·奇数コード、Payload WORD 数、zero padding が互いに合わなければ拒否する。

## 形式の位置づけ {#형식-지위}

- 偶奇のコードの組(`0x07EL` 偶数、`0x07FL` 奇数)、payload の配置、最後の WORD の zero padding は、外部の産業標準を引用したものではなく GEUL 固有の framing である。

## 長さ {#길이}

- 全体は TAG 1 WORD、Length 拡張 TAG(あれば)と Payload を合わせた WORD 数である。14 WORD 以下は直接長、15 WORD 以上は `1110`·`1111` の拡張長を使い、拡張 TAG も全体の数に入る([レコードと TAG WORD](../record.md))。
- 0 byte は偶数コード(`0x07EL`)の 1 WORD レコード(TAG WORD のみ)で書く([Value](_index.md))。

## 例 {#예시}

byte `AB CD EF` は 3 byte(奇数)なので `OPAQUE-BYTES-ODD`(`0x07FL`)、Payload は `ABCD EF00` である。全体 3 WORD なので `LLLL=0010` である。

```
07F2 ABCD EF00
```

空のバイト列は `07E0`(`OPAQUE-BYTES-EVEN`、TAG WORD のみ)の 1 WORD である。

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x000007E0/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007E000000000
BODY
#1 DECLARE 0x07E0
#2 FIELD #1 rest
#3 BIND #1 "OPAQUE-BYTES-EVEN"
#4 BIND #2 "bytes"
```

上は `OPAQUE-BYTES-EVEN`(`0x07EL`)の Codec ドキュメントである。他の構成員(`OPAQUE-BYTES-ODD`)の Codec ドキュメントは、DOC-ID の Codec ID、DECLARE の対象、`#1` に結び付けた名前(BIND)だけが異なる。
