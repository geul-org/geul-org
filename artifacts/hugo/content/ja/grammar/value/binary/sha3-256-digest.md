---
title: "SHA3-256-DIGEST"
weight: 1009
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA3-256-DIGEST は、SHA3-256 の結果 256bit 全体を収める固定 20 WORD の NIST Issuer 形式だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA3-256-DIGEST は、SHA3-256 の結果全体を収める固定幅の Value だ。Value `ISSUER-1WORD`(`0x7C`)、Issuer `0x0062` NIST、形式番号 `0xC001`、系列 BINARY だ。Payload はちょうど 16 WORD(256 bit)で、切り詰め(truncation)は許さない。

## レイアウト

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
Length 拡張 TAG   1 WORD  0x0014 (全体 20 WORD)
Issuer            1 WORD  0x0062 (NIST)
形式番号          1 WORD  0xC001
Payload           16 WORD  SHA3-256 Digest
```

## 解釈と有効性

- Payload の 32 octet を SHA3-256 の出力順のまま読む。各 WORD では上位 octet が先に来る。
- digest の bit string に GEUL の endian 変換を別に適用しない。出力 octet sequence を順に二つの octet ずつ束ねて、16bit big-endian WORD として framing するだけだ。
- Payload が 16 WORD でなかったり、結果を勝手に切り取った表現は拒否する。descriptor と padding はない。

## 標準の根拠

- SHA3-256 アルゴリズムと 256bit の結果は、NIST [FIPS 202, SHA-3 Standard](https://csrc.nist.gov/pubs/fips/202/final) に従う。NIST の [Hash Functions プロジェクト](https://csrc.nist.gov/Projects/hash-functions)も SHA-3 標準を案内している。
- GEUL TAG、Length、16bit WORD framing は、この形式が加える規則で、SHA-3 アルゴリズムの一部ではない。

## 長さ

- 全体は、TAG 1 WORD、Length 拡張 TAG 1 WORD、Issuer 1 WORD、形式番号 1 WORD、Payload 16 WORD を合わせたちょうど 20 WORD で、`LLLL=1110` を使う。descriptor と padding はない。
- Payload がちょうど 16 WORD でなければ拒否する。

## 例

- digest octet `d[0]` から `d[31]` までを、16 個の Payload WORD に出力順で二つの octet ずつ置く。全体の Length は常に 20 WORD だ。
