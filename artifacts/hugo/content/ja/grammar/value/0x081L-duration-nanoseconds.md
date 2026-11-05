---
title: "DURATION-NANOSECONDS (0x081L)"
weight: 129
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "DURATION-NANOSECONDS は epoch を持たない signed nanosecond の経過時間である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DURATION-NANOSECONDS は epoch を持たない signed nanosecond の経過時間である。instant でも、暦の月·年の期間でもない。

| 項目 | 値 |
|---|---|
| 名前 | `DURATION-NANOSECONDS` (規格ドキュメント BIND `DURATION-NANOSECONDS`) |
| TAG ID | `0x081L` |
| Codec ID | `0x00000810` |
| 規格ドキュメント | `0x00000000/codecs/0x00000810/` (DECLARE の対象 `0810`) |
| セクション | 4 `0100` (Value)、セクション内オフセット C = 1 |
| Kind | Value · 系列: TIME |
| TAG WORD | `0000 1000 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | epoch のない signed nanosecond の経過時間 |
| Hugo 側 | `value/time/duration-nanoseconds.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `nanoseconds` | #2 | 生値 4 WORD |  |  |

## レイアウト {#레이아웃}

- コード: Value 直接コード `0x081L`。系列 TIME。
- Arrow `Duration(NANOSECOND)` と同じ固定幅の signed int64 物理型を使う。

```
TAG WORD          0x0814 (0000 1000 0001 0100)  全体 5 WORD
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## 解釈と有効性 {#해석과-유효성}

- Payload の 4 WORD 全体を、big-endian WORD 順の 64 ビット 2 の補数 signed count として読む。
- 有効範囲は `-2^63`~`2^63-1` ns である。符号は経過の方向であり、特定の epoch の instant を指さない。
- 小さな値でも常に 4 WORD を使う。

## 長さ {#길이}

- 全体は TAG 1 WORD と Payload 4 WORD を合わせたちょうど 5 WORD で、直接長 `LLLL=0100` を使う。Length 拡張 TAG、descriptor、padding はない。
- Payload がちょうど 4 WORD でなければ拒否する。

## 例 {#예시}

- 0ns は Payload `0000 0000 0000 0000`、全体 5 WORD、`LLLL=0100` である。全体は `0814 0000 0000 0000 0000` である。
- 1ns は Payload `0000 0000 0000 0001` である。
- -1ns は Payload `FFFF FFFF FFFF FFFF` である。

## 標準の根拠 {#표준-근거}

- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) は `Schema.fbs` を Arrow 標準データ型の authoritative source と指定している。
- Arrow の authoritative な [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) で、`Duration` は暦と無関係な絶対的経過時間であり、NANOSECOND 単位をサポートし、常に 8-byte の signed integer で表される。GEUL はここに TAG と big-endian 16 ビット WORD framing を加えるだけである。

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00000810/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000081000000000
BODY
#1 DECLARE 0x0810
#2 FIELD #1 0x0004
#3 BIND #1 "DURATION-NANOSECONDS"
#4 BIND #2 "nanoseconds"
```
