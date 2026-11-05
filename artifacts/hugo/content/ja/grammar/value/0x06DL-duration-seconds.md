---
title: "DURATION-SECONDS (0x06DL)"
weight: 109
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "DURATION-SECONDS は epoch を持たない signed の秒単位の経過時間である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `DURATION-SECONDS` (規格ドキュメント BIND `DURATION-SECONDS`) |
| TAG ID | `0x06DL` |
| Codec ID | `0x000006D0` |
| 規格ドキュメント | `0x00000000/codecs/0x000006D0/` (DECLARE 対象 `06D0`) |
| セクション | 3 `0011` (Value)、セクション内オフセット C = 13 |
| Kind | Value · 系列: TIME |
| TAG WORD | `0000 0110 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引説明 | epoch のない signed SI-second の経過時間 |
| Hugo 側 | `value/time/duration-seconds.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `seconds` | #2 | 生値 4 WORD |  |  |

DURATION-SECONDS は epoch を持たない signed の秒単位の経過時間である。instant でも、暦の月・年の期間でもない。

## レイアウト {#레이아웃}

- コード: Value 直接コード `0x06DL`。系列 TIME。
- Arrow `Duration(SECOND)` と同じ固定幅 signed int64 の物理型を使う。

```
TAG WORD          0x06D4 (0000 0110 1101 0100)  全体 5 WORD
Payload WORD 1st (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Seconds
Payload WORD 3rd (bits 31..16)     Signed Seconds
Payload WORD 4th (bits 15..0)      Signed Seconds low 16bit
```

## 解釈と有効性 {#해석과-유효성}

- Payload 4 WORD 全体を big-endian WORD 順の 64 ビット 2 の補数 signed count として読む。
- 有効範囲は `-2^63`~`2^63-1` 秒である。符号は経過の方向であり、特定の epoch の instant を指さない。
- 小さな値も常に 4 WORD を使う。

## 長さ {#길이}

- 全体は TAG 1 WORD と Payload 4 WORD を合わせたちょうど 5 WORD で、直接長 `LLLL=0100` を使う。Length 拡張 TAG、descriptor、padding はない。
- Payload がちょうど 4 WORD でなければ拒否する。

## 例 {#예시}

- 0 秒は Payload `0000 0000 0000 0000`、全体 5 WORD、`LLLL=0100` である。
- 1 秒は Payload `0000 0000 0000 0001` である。
- -1 秒は Payload `FFFF FFFF FFFF FFFF` である。

## 標準の根拠 {#표준-근거}

- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) は `Schema.fbs` を Arrow 標準データ型の authoritative source と指定している。
- Arrow の authoritative な [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) で `Duration` は暦と無関係な絶対的な経過時間であり、SECOND 単位をサポートし、常に 8 バイトの signed integer で表現される。GEUL はここに TAG と big-endian 16 ビット WORD のフレーミングだけを加える。

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x000006D0/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006D000000000
BODY
#1 DECLARE 0x06D0
#2 FIELD #1 0x0004
#3 BIND #1 "DURATION-SECONDS"
#4 BIND #2 "seconds"
```
