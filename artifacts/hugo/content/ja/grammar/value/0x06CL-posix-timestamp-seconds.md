---
title: "POSIX-TIMESTAMP-SECONDS (0x06CL)"
weight: 108
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "POSIX-TIMESTAMP-SECONDS は Unix epoch 1970-01-01T00:00:00Z からの signed の秒数である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `POSIX-TIMESTAMP-SECONDS` (規格ドキュメント BIND `POSIX-TIMESTAMP-SECONDS`) |
| TAG ID | `0x06CL` |
| Codec ID | `0x000006C0` |
| 規格ドキュメント | `0x00000000/codecs/0x000006C0/` (DECLARE 対象 `06C0`) |
| セクション | 3 `0011` (Value)、セクション内オフセット C = 12 |
| Kind | Value · 系列: TIME |
| TAG WORD | `0000 0110 1100 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引説明 | Unix/POSIX epoch からの signed 秒計数 |
| Hugo 側 | `value/time/posix-timestamp-seconds.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `seconds` | #2 | 生値 4 WORD |  |  |

POSIX-TIMESTAMP-SECONDS は Unix epoch `1970-01-01T00:00:00Z` からの signed の秒数である。POSIX の seconds-since-the-Epoch と同様に、すべての日をちょうど 86,400 秒とみなし、閏秒を数えない。

## レイアウト {#레이아웃}

- コード: Value 直接コード `0x06CL`。系列 TIME。
- 産業データ交換のため、Arrow `timestamp[s]` と同じ固定幅 signed int64 の物理型を使う。

```
TAG WORD          0x06C4 (0000 0110 1100 0100)  全体 5 WORD
Payload WORD 1st (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Seconds
Payload WORD 3rd (bits 31..16)     Signed Seconds
Payload WORD 4th (bits 15..0)      Signed Seconds low 16bit
```

## 解釈と有効性 {#해석과-유효성}

- Payload 4 WORD 全体を big-endian WORD 順の 64 ビット 2 の補数 signed count として読む。
- 有効範囲は `-2^63`~`2^63-1` 秒である。負数は epoch より前の instant である。
- 小さな値も常に 4 WORD を使う。最小 WORD の整数表現に縮めてはならない。
- timezone、元の UTC offset、閏秒 label、leap-second table は保持しない。

## 長さ {#길이}

- 全体は TAG 1 WORD と Payload 4 WORD を合わせたちょうど 5 WORD で、直接長 `LLLL=0100` を使う。Length 拡張 TAG、descriptor、padding はない。
- Payload がちょうど 4 WORD でなければ拒否する。

## 例 {#예시}

- epoch は Payload `0000 0000 0000 0000`、全体 5 WORD、`LLLL=0100` である。
- epoch の 1 秒後は Payload `0000 0000 0000 0001` である。
- epoch の 1 秒前は Payload `FFFF FFFF FFFF FFFF` である。

## 標準の根拠 {#표준-근거}

- [POSIX.1-2024 `timespec`](https://pubs.opengroup.org/onlinepubs/9799919799/functions/V2_chap02.html) は `time_t tv_sec` と `long tv_nsec` のメンバを定義するだけで、累積秒を signed int64 として直列化する wire format は定義しない。`time_t` の具体的な幅と表現は実装環境に依存し、GEUL の Payload 表現とは同じではない。
- [POSIX.1-2024 Seconds Since the Epoch](https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap04.html) は、epoch 以後の秒と暦の対応、および一日 86,400 秒の規則を定義する。
- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) と authoritative な [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) は、timestamp を固定 epoch からの 64 ビット signed integer と定義し、SECOND 単位と閏秒を数えない扱いをサポートする。GEUL はこの物理型に TAG と big-endian 16 ビット WORD のフレーミングだけを加える。

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x000006C0/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006C000000000
BODY
#1 DECLARE 0x06C0
#2 FIELD #1 0x0004
#3 BIND #1 "POSIX-TIMESTAMP-SECONDS"
#4 BIND #2 "seconds"
```
