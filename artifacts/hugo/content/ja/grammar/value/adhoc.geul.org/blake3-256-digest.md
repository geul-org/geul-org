---
title: "BLAKE3-256-DIGEST"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "BLAKE3-256-DIGESTは、BLAKE3 default hash mode の出力の先頭32 octet(256 bit)を収める固定幅の Value である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BLAKE3-256-DIGESTは、BLAKE3 default hash mode の出力の先頭32 octet(256 bit)を収める固定幅の Value である。Value `VALUE-ISSUER-2WORD`(`0x09DL`)、Issuer `0x00000002` ADHOC、Codec 番号 `0x0000C000`、系列 BINARY である。Payload は正確に16 WORD であり、keyed hash mode、key derivation mode、他の長さの XOF 出力は収めない。

## レイアウト {#레이아웃}

```
TAG WORD          0x09DE (0000 1001 1101 1110)  LLLL=1110
Length 拡張 TAG   1 WORD  0x0016 (全体 22 WORD)
Issuer            2 WORD  0x00000002 (ADHOC)
Codec 番号        2 WORD  0x0000C000
Payload           16 WORD  BLAKE3-256 Digest
```

## 解釈と有効性 {#해석과-유효성}

- Payload は BLAKE3 default hash mode の output stream の先頭32 octet である。出力の順序を保存し、各 WORD では上位 octet が先に来る。
- 出力に GEUL の endian 変換を別途適用しない。出力 octet sequence を順に2 octet ずつ組にして、16bit big-endian WORD として framing する。
- Payload が16 WORD でないもの、または keyed_hash、derive_key、他の長さの XOF 結果を収めた表現は拒否する。descriptor と padding はない。

## 標準上の根拠 {#표준-근거}

- アルゴリズムと mode・output の定義は、BLAKE3 チームの[公式実装リポジトリ](https://github.com/BLAKE3-team/BLAKE3)と [BLAKE3 specification](https://github.com/BLAKE3-team/BLAKE3-specs/blob/master/blake3.pdf) に従う。
- GEUL の TAG、Length、16bit WORD framing はこの形式が加える規則であり、BLAKE3 アルゴリズムの一部ではない。

## 長さ {#길이}

- 全体は TAG 1 WORD、Length 拡張 TAG 1 WORD、Issuer 2 WORD、Codec 番号 2 WORD、Payload 16 WORD を合わせた正確に22 WORD であり、`LLLL=1110` を用いる。descriptor と padding はない。
- Payload が正確に16 WORD でなければ拒否する。

## 例 {#예시}

- output octet `d[0]` から `d[31]` までを、16個の Payload WORD に出力順のまま2 octet ずつ置く。全体の Length は常に22 WORD である。
