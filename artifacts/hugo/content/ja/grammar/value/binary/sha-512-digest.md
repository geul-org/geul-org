---
title: "SHA-512-DIGEST"
weight: 1008
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA-512-DIGEST は、SHA-512 の結果 512bit 全体を収める固定 36 WORD の NIST Issuer 形式だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA-512-DIGEST は、SHA-2 系列の SHA-512 の結果全体を収める固定幅の Value だ。Value `ISSUER-1WORD`(`0x7C`)、Issuer `0x0062` NIST、形式番号 `0xC000`、系列 BINARY だ。Payload はちょうど 32 WORD(512 bit)で、切り詰め(truncation)は許さない。

## レイアウト

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
Length 拡張 TAG   1 WORD  0x0024 (全体 36 WORD)
Issuer            1 WORD  0x0062 (NIST)
形式番号          1 WORD  0xC000
Payload           32 WORD  SHA-512 Digest
```

## 解釈と有効性

- Payload の 64 octet を SHA-512 の出力順のまま読む。各 WORD では上位 octet が先に来る。
- digest の bit string に GEUL の endian 変換を別に適用しない。出力 octet sequence を順に二つの octet ずつ束ねて、16bit big-endian WORD として framing するだけだ。
- Payload が 32 WORD でなかったり、結果を勝手に切り取った表現は拒否する。descriptor と padding はない。

## 標準の根拠

- SHA-512 アルゴリズムと 512bit の結果は、NIST [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final) に従う。
- GEUL TAG、Length、16bit WORD framing は、この形式が加える規則で、SHA-2 アルゴリズムの一部ではない。

## 長さ

- 全体は、TAG 1 WORD、Length 拡張 TAG 1 WORD、Issuer 1 WORD、形式番号 1 WORD、Payload 32 WORD を合わせたちょうど 36 WORD で、`LLLL=1110` を使う。descriptor と padding はない。
- Payload がちょうど 32 WORD でなければ拒否する。

## 例

- digest octet `d[0]` から `d[63]` までは、Payload WORD `(d[0]<<8)|d[1]` から `(d[62]<<8)|d[63]` まで順に置く。全体の Length は常に 36 WORD だ。
