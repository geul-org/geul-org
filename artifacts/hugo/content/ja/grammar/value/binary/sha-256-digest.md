---
title: "SHA-256-DIGEST"
weight: 98
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA-256-DIGEST は、SHA-256 の結果 256bit 全体を収める固定 18 WORD の Value だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA-256-DIGEST は、SHA-2 系列の SHA-256 の結果全体を収める固定幅の Value だ。Value 直接コード `0x61`、系列 BINARY だ。Payload はちょうど 16 WORD(256 bit)で、切り詰め(truncation)は許さない。

## レイアウト

```
TAG WORD          0x0F61 (0000 1111 0110 0001)  LLLL=1110
Length 拡張 TAG   1 WORD  0x0012 (全体 18 WORD)
Payload           16 WORD  SHA-256 Digest
```

## 解釈と有効性

- Payload の 32 octet を SHA-256 の出力順のまま読む。各 WORD では上位 octet が先に来る。
- digest の bit string に GEUL の endian 変換を別に適用しない。出力 octet sequence を順に二つの octet ずつ束ねて、16bit big-endian WORD として framing するだけだ。
- Payload が 16 WORD でなかったり、結果を勝手に切り取った表現は拒否する。descriptor と padding はない。

## 標準の根拠

- SHA-256 アルゴリズムと 256bit の結果は、NIST [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final) に従う。
- GEUL TAG、Length、16bit WORD framing は、この形式が加える規則で、SHA-2 アルゴリズムの一部ではない。

## 長さ

- 全体は、TAG 1 WORD、Length 拡張 TAG 1 WORD、Payload 16 WORD を合わせたちょうど 18 WORD で、`LLLL=1110` を使う。descriptor と padding はない。
- Payload がちょうど 16 WORD でなければ拒否する。

## 例

- digest octet `d[0]` から `d[31]` までは、Payload WORD `(d[0]<<8)|d[1]` から `(d[30]<<8)|d[31]` まで順に置く。全体の Length は常に 18 WORD だ。
