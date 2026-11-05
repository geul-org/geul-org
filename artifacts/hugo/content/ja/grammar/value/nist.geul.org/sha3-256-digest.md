---
title: "SHA3-256-DIGEST"
weight: 1040
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA3-256-DIGESTは、SHA3-256 の結果全体を収める固定幅の Value である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA3-256-DIGESTは、SHA3-256 の結果全体を収める固定幅の Value である。Value `VALUE-ISSUER-2WORD`(`0x09DL`)、Issuer `0x00000015` NIST、Codec 番号 `0x0000C001`、系列 BINARY である。Payload は正確に16 WORD(256 bit)であり、切り詰め(truncation)は許さない。

## レイアウト {#레이아웃}

```
TAG WORD          0x09DE (0000 1001 1101 1110)  LLLL=1110
Length 拡張 TAG   1 WORD  0x0016 (全体 22 WORD)
Issuer            2 WORD  0x00000015 (NIST)
Codec 番号        2 WORD  0x0000C001
Payload           16 WORD  SHA3-256 Digest
```

## 解釈と有効性 {#해석과-유효성}

- Payload 32 octet を SHA3-256 の出力順のまま読む。各 WORD では上位 octet が先に来る。
- digest の bit string に GEUL の endian 変換を別途適用しない。出力 octet sequence を順に2 octet ずつ組にして、16bit big-endian WORD として framing するだけである。
- Payload が16 WORD でないもの、または結果を任意に切り詰めた表現は拒否する。descriptor と padding はない。

## 標準上の根拠 {#표준-근거}

- SHA3-256 アルゴリズムと256bit の結果は、NIST の [FIPS 202, SHA-3 Standard](https://csrc.nist.gov/pubs/fips/202/final) に従う。NIST の [Hash Functions プロジェクト](https://csrc.nist.gov/Projects/hash-functions)も SHA-3 標準を案内している。
- GEUL の TAG、Length、16bit WORD framing はこの形式が加える規則であり、SHA-3 アルゴリズムの一部ではない。

## 長さ {#길이}

- 全体は TAG 1 WORD、Length 拡張 TAG 1 WORD、Issuer 2 WORD、Codec 番号 2 WORD、Payload 16 WORD を合わせた正確に22 WORD であり、`LLLL=1110` を用いる。descriptor と padding はない。
- Payload が正確に16 WORD でなければ拒否する。

## 例 {#예시}

- digest octet `d[0]` から `d[31]` までを、16個の Payload WORD に出力順のまま2 octet ずつ置く。全体の Length は常に22 WORD である。
