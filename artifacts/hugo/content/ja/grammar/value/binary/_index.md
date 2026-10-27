---
title: "Value — バイナリ"
weight: 50
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "BINARY 系列(Codec `0x60`~`0x7B`、形式番号 `0xC000`~`0xFFFF`)の形式: UUID、ダイジェスト、CRC、ネットワークアドレス、不明バイト列、ビットベクトル。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BINARY 系列は、バイト列の形式だ。直接コード `0x60`~`0x7B`、Issuer 形式番号 `0xC000`~`0xFFFF` に置く。

- UUID、SHA-256、SHA-1 は直接コードだ。残りのダイジェスト、CRC32C、IPv4・IPv6・MAC アドレス、不明バイト列、ビットベクトルは Issuer 形式だ。
- 固定サイズの値(UUID、ダイジェスト、アドレス)は、サイズが決まっているので、偶数・奇数のペアを置かない。
- 画像・動画のような公開メディアは、IANA Issuer(`0x0021`)の BINARY 形式で置く。形式番号は偶数・奇数のペアで割り当て、Payload はバイト列だ。Length の上限は 2^32−1 WORD だ。大きな値は、直接入れるより URI と SHA-256 で参照することを勧める。
- バイト列内の著作物は、元のライセンスに従う。出典とライセンスは Meta で記録する。
