---
title: "CRC32C"
weight: 1004
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "CRC32C は、Castagnoli CRC-32C の結果 32bit を収める、固定 5 WORD の IETF Issuer 形式だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CRC32C は、CRC-32C の結果を収める固定幅の Value だ。Value `ISSUER-1WORD`(`0x7C`)、Issuer `0x0020` IETF、形式番号 `0xC000`、系列 BINARY だ。Payload はちょうど 2 WORD(32 bit)だ。

## レイアウト

```
TAG WORD          0x0A7C (0000 1010 0111 1100)  全体 5 WORD
Issuer            1 WORD  0x0020 (IETF)
形式番号          1 WORD  0xC000
Payload           2 WORD  CRC32C 上位 16bit │ 下位 16bit
```

## 解釈と有効性

- CRC parameter の表記で、width 32、Castagnoli polynomial `0x1EDC6F41`、refin/refout true、init `0xffffffff`、xorout `0xffffffff` だ。
- 計算結果である unsigned 32bit 整数を、big-endian WORD 順で保存する。このシリアライズは、RFC 3309 の SCTP Checksum field の配置や、RFC 3720 の iSCSI digest byte mapping そのものではない。
- Payload が 2 WORD でなければ拒否する。

## 標準の根拠

- CRC-32C の計算と Castagnoli polynomial・反射規則は、[RFC 3309](https://www.rfc-editor.org/rfc/rfc3309.html) と [RFC 3720](https://www.rfc-editor.org/rfc/rfc3720.html) の CRC32C 定義に従う。
- GEUL TAG、Length、計算された 32bit 整数の 16bit big-endian WORD framing は、この形式が加える規則だ。

## 長さ

- 全体は、TAG 1 WORD、Issuer 1 WORD、形式番号 1 WORD、Payload 2 WORD を合わせたちょうど 5 WORD で、直接長さ `LLLL=0100` を使う。Length 拡張 TAG、descriptor、padding はない。
- Payload がちょうど 2 WORD でなければ拒否する。

## 例

ASCII `123456789` の CRC-32C check value `0xe3069283`:

```
0A7C 0020 C000 e306 9283
```
