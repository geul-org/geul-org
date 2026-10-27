---
title: "OPAQUE-BYTES"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "OPAQUE-BYTES は、意味と形式を自ら定めない任意のバイト列を収める GEUL Issuer 形式だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

OPAQUE-BYTES は、意味と形式をこの形式自体では定めない任意のバイト列だ。Value `ISSUER-1WORD`(`0x7C`)、Issuer `0x0000` GEUL、形式番号 `0xC000`・`0xC001`(偶数・奇数バイト)、系列 BINARY だ。バイト数は、形式番号の最下位ビットと Payload WORD 数で決まる。`2 × Payload WORD 数 − 最下位ビット` で、Byte Count は置かない([Value](/ja/grammar/value/))。

## レイアウト

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length 拡張 TAG] 全体が 15 WORD 以上のとき
Issuer            1 WORD  0x0000 (GEUL)
形式番号          1 WORD  0xC000/0xC001
Payload WORD 1st ... Nth   バイト / 最後に zero padding
```

## 解釈と有効性

- Payload からバイト数だけ byte を順に読む。WORD の中では上位 byte が先に来る。
- Payload WORD 数は `ceil(バイト数/2)` だ。奇数コードなのに最後の WORD の下位 byte が `00` でなければ拒否する。
- 偶数・奇数コード、Payload WORD 数、zero padding が互いに合わなければ拒否する。

## 形式の位置づけ

- 偶奇コードのペア、payload の配置、最後の WORD の zero padding は、外部の産業標準を引用したものではなく、GEUL 固有の framing だ。

## 長さ

- 全体は、TAG 1 WORD、Length 拡張 TAG(あれば)、Issuer 1 WORD、形式番号 1 WORD、Payload を合わせた WORD 数だ。14 WORD 以下は直接長さ、15 WORD 以上は `1110`・`1111` の拡張長さを使い、拡張 TAG も全体の数に入る([レコードと TAG WORD](/ja/grammar/record/))。
- 0 byte は、偶数の形式番号(`0xC000`)に、Payload のない 3 WORD レコード(TAG、Issuer、形式番号)で書く。

## 例

byte `ab cd ef` は 3 byte(奇数)なので形式番号 `0xC001`、Payload `abcd ef00` だ。全体 5 WORD なので `LLLL=0100` だ。

```
0A7C 0000 C001 abcd ef00
```
