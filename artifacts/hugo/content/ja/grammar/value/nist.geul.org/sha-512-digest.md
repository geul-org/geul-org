---
title: "SHA-512-DIGEST"
weight: 1039
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA-512-DIGESTは、SHA-2 系列の SHA-512 の結果全体を収める固定幅の Value である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA-512-DIGESTは、SHA-2 系列の SHA-512 の結果全体を収める固定幅の Value である。Value `VALUE-ISSUER-2WORD`(`0x09DL`)、Issuer `0x00000015` NIST、Codec 番号 `0x0000C000`、系列 BINARY である。Payload は正確に32 WORD(512 bit)であり、切り詰め(truncation)は許さない。

## レイアウト {#레이아웃}

```
TAG WORD          0x09DE (0000 1001 1101 1110)  LLLL=1110
Length 拡張 TAG   1 WORD  0x0026 (全体 38 WORD)
Issuer            2 WORD  0x00000015 (NIST)
Codec 番号        2 WORD  0x0000C000
Payload           32 WORD  SHA-512 Digest
```

## 解釈と有効性 {#해석과-유효성}

- Payload 64 octet を SHA-512 の出力順のまま読む。各 WORD では上位 octet が先に来る。
- digest の bit string に GEUL の endian 変換を別途適用しない。出力 octet sequence を順に2 octet ずつ組にして、16bit big-endian WORD として framing するだけである。
- Payload が32 WORD でないもの、または結果を任意に切り詰めた表現は拒否する。descriptor と padding はない。

## 標準上の根拠 {#표준-근거}

- SHA-512 アルゴリズムと512bit の結果は、NIST の [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final) に従う。
- GEUL の TAG、Length、16bit WORD framing はこの形式が加える規則であり、SHA-2 アルゴリズムの一部ではない。

## 長さ {#길이}

- 全体は TAG 1 WORD、Length 拡張 TAG 1 WORD、Issuer 2 WORD、Codec 番号 2 WORD、Payload 32 WORD を合わせた正確に38 WORD であり、`LLLL=1110` を用いる。descriptor と padding はない。
- Payload が正確に32 WORD でなければ拒否する。

## 例 {#예시}

- digest octet `d[0]` から `d[63]` までは、Payload WORD の `(d[0]<<8)|d[1]` から `(d[62]<<8)|d[63]` まで順に置く。全体の Length は常に38 WORD である。
