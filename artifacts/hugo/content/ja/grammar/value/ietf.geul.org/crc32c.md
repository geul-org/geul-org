---
title: "CRC32C"
weight: 1033
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "CRC32Cは、CRC-32C の結果を収める固定幅の Value である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CRC32Cは、CRC-32C の結果を収める固定幅の Value である。Value `VALUE-ISSUER-2WORD`(`0x09DL`)、Issuer `0x00000007` IETF、Codec 番号 `0x0000C000`、系列 BINARY である。Payload は正確に2 WORD(32 bit)である。

## レイアウト {#레이아웃}

```
TAG WORD          0x09D6 (0000 1001 1101 0110)  全体 7 WORD
Issuer            2 WORD  0x00000007 (IETF)
Codec 番号        2 WORD  0x0000C000
Payload           2 WORD  CRC32C 上位 16bit │ 下位 16bit
```

## 解釈と有効性 {#해석과-유효성}

- CRC parameter の表記では、width 32、Castagnoli polynomial `0x1EDC6F41`、refin/refout true、init `0xFFFFFFFF`、xorout `0xFFFFFFFF` である。
- 計算結果である unsigned 32bit 整数を、big-endian WORD 順に格納する。このシリアライズは、RFC 3309 の SCTP Checksum field の配置や、RFC 3720 の iSCSI digest の byte mapping そのものではない。
- Payload が2 WORD でなければ拒否する。

## 標準上の根拠 {#표준-근거}

- CRC-32C の計算と Castagnoli polynomial・反射の規則は、[RFC 3309](https://www.rfc-editor.org/rfc/rfc3309.html) と [RFC 3720](https://www.rfc-editor.org/rfc/rfc3720.html) の CRC32C の定義に従う。
- GEUL の TAG、Length、および計算された32bit 整数の16bit big-endian WORD framing は、この形式が加える規則である。

## 長さ {#길이}

- 全体は TAG 1 WORD、Issuer 2 WORD、Codec 番号 2 WORD、Payload 2 WORD を合わせた正確に7 WORD であり、直接長 `LLLL=0110` を用いる。Length 拡張 TAG、descriptor、padding はない。
- Payload が正確に2 WORD でなければ拒否する。

## 例 {#예시}

ASCII `123456789` の CRC-32C check value `0xE3069283`:

```
09D6 0000 0007 0000 C000 E306 9283
```
