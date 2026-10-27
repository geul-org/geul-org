---
title: "BLAKE3-256-DIGEST"
weight: 1003
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "BLAKE3-256-DIGEST は、BLAKE3 の既定 hash mode 出力の最初の 32 octet を収める、固定 20 WORD の Issuer 形式だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BLAKE3-256-DIGEST は、BLAKE3 default hash mode 出力の最初の 32 octet(256 bit)を収める固定幅の Value だ。Value `ISSUER-1WORD`(`0x7C`)、Issuer `0x0001` ADHOC、形式番号 `0xC000`、系列 BINARY だ。Payload はちょうど 16 WORD で、keyed hash mode、key derivation mode、他の長さの XOF 出力は収めない。

## レイアウト

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
Length 拡張 TAG   1 WORD  0x0014 (全体 20 WORD)
Issuer            1 WORD  0x0001 (ADHOC)
形式番号          1 WORD  0xC000
Payload           16 WORD  BLAKE3-256 Digest
```

## 解釈と有効性

- Payload は、BLAKE3 default hash mode の output stream の最初の 32 octet だ。出力の順序を保存し、各 WORD では上位 octet が先に来る。
- 出力に GEUL の endian 変換を別に適用しない。出力 octet sequence を順に二つの octet ずつ束ねて、16bit big-endian WORD として framing する。
- Payload が 16 WORD でなかったり、keyed_hash、derive_key、他の長さの XOF 結果を収めた表現は拒否する。descriptor と padding はない。

## 標準の根拠

- アルゴリズムと mode・output の定義は、BLAKE3 チームの[公式実装リポジトリ](https://github.com/BLAKE3-team/BLAKE3)と [BLAKE3 specification](https://github.com/BLAKE3-team/BLAKE3-specs/blob/master/blake3.pdf) に従う。
- GEUL TAG、Length、16bit WORD framing は、この形式が加える規則で、BLAKE3 アルゴリズムの一部ではない。

## 長さ

- 全体は、TAG 1 WORD、Length 拡張 TAG 1 WORD、Issuer 1 WORD、形式番号 1 WORD、Payload 16 WORD を合わせたちょうど 20 WORD で、`LLLL=1110` を使う。descriptor と padding はない。
- Payload がちょうど 16 WORD でなければ拒否する。

## 例

- output octet `d[0]` から `d[31]` までを、16 個の Payload WORD に出力順で二つの octet ずつ置く。全体の Length は常に 20 WORD だ。
