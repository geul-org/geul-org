---
title: "POSIX-TIMESTAMP-SECONDS"
weight: 35
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "POSIX-TIMESTAMP-SECONDS は、Unix epoch からの signed int64 秒数を収める Value だ(Codec 0x22)。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POSIX-TIMESTAMP-SECONDS は、Unix epoch `1970-01-01T00:00:00Z` からの signed 秒数だ。POSIX の seconds-since-the-Epoch のように、すべての日をちょうど 86,400 秒と見て、うるう秒を数えない。

## レイアウト

- コード: Value 直接コード `0x22`。系列 TIME。
- 産業データ交換のために、Arrow `timestamp[s]` と同じ固定幅 signed int64 の物理型を使う。

```
TAG WORD          0x0A22 (0000 1010 0010 0010)  全体 5 WORD
Payload WORD 1st (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Seconds
Payload WORD 3rd (bits 31..16)     Signed Seconds
Payload WORD 4th (bits 15..0)      Signed Seconds low 16bit
```

## 解釈と有効性

- Payload 4 WORD 全体を、big-endian WORD 順の 64ビット2の補数 signed count として読む。
- 有効範囲は `-2^63`~`2^63-1` 秒だ。負数は epoch より前の instant だ。
- 小さな値も、常に 4 WORD を使う。最小 WORD の整数表現に縮めてはならない。
- timezone、元の UTC offset、うるう秒 label、leap-second table は収めない。

## 長さ

- 全体は、TAG 1 WORD と Payload 4 WORD を合わせたちょうど 5 WORD で、直接長さ `LLLL=0100` を使う。Length 拡張 TAG、descriptor、padding はない。
- Payload がちょうど 4 WORD でなければ拒否する。

## 例

- epoch は Payload `0000 0000 0000 0000`、全体 5 WORD、`LLLL=0100` だ。
- epoch の 1秒後は Payload `0000 0000 0000 0001` だ。
- epoch の 1秒前は Payload `ffff ffff ffff ffff` だ。

## 標準の根拠

- [POSIX.1-2024 `timespec`](https://pubs.opengroup.org/onlinepubs/9799919799/functions/V2_chap02.html) は、`time_t tv_sec` と `long tv_nsec` のメンバを定義するだけで、累積秒を signed int64 でシリアライズする wire format は定義しない。`time_t` の具体的な幅と表現は実装環境に従い、GEUL Payload の表現とは同じではない。
- [POSIX.1-2024 Seconds Since the Epoch](https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap04.html) は、epoch 以降の秒の暦への対応と、一日 86,400 秒の規則を定義する。
- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) と authoritative な [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) は、timestamp を固定 epoch からの 64ビット signed integer と定義し、SECOND 単位とうるう秒を数えないことに対応する。GEUL は、この物理型に TAG と big-endian 16ビット WORD framing だけを加える。
