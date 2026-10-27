---
title: "DURATION-NANOSECONDS"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "DURATION-NANOSECONDS は、epoch のない signed int64 nanosecond の経過時間を収める Value だ(GEUL Issuer 形式 0x4000)。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DURATION-NANOSECONDS は、epoch のない signed nanosecond の経過時間だ。instant や、暦の月・年の期間ではない。

## レイアウト

- コード: Value `ISSUER-1WORD`(`0x7C`)、Issuer `0x0000` GEUL、形式番号 `0x4000`。系列 TIME。
- Arrow `Duration(NANOSECOND)` と同じ固定幅 signed int64 の物理型を使う。

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  全体 7 WORD
Issuer            1 WORD  0x0000 (GEUL)
形式番号          1 WORD  0x4000
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## 解釈と有効性

- Payload 4 WORD 全体を、big-endian WORD 順の 64ビット2の補数 signed count として読む。
- 有効範囲は `-2^63`~`2^63-1`ns だ。符号は経過の方向で、特定の epoch の instant を指さない。
- 小さな値も、常に 4 WORD を使う。

## 長さ

- 全体は、TAG 1 WORD、Issuer 1 WORD、形式番号 1 WORD と Payload 4 WORD を合わせたちょうど 7 WORD で、直接長さ `LLLL=0110` を使う。Length 拡張 TAG、descriptor、padding はない。
- Payload がちょうど 4 WORD でなければ拒否する。

## 例

- 0ns は Payload `0000 0000 0000 0000`、全体 7 WORD、`LLLL=0110` だ。
- 1ns は Payload `0000 0000 0000 0001` だ。
- -1ns は Payload `ffff ffff ffff ffff` だ。

## 標準の根拠

- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) は、`Schema.fbs` を Arrow 標準データ型の authoritative source と指定している。
- Arrow の authoritative な [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) で、`Duration` は暦と無関係な絶対経過時間で、NANOSECOND 単位に対応し、常に 8-byte signed integer で表現される。GEUL は、ここに TAG と big-endian 16ビット WORD framing だけを加える。
