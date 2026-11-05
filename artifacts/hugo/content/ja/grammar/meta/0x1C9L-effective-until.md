---
title: "EFFECTIVE-UNTIL (0x1C9L)"
weight: 457
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "このバージョンの有効期間の終わりを宣言する(限時法)。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `EFFECTIVE-UNTIL` (規格ドキュメント BIND `EFFECTIVE-UNTIL`) |
| TAG ID | `0x1C9L` |
| Codec ID | `0x00001C90` |
| 規格ドキュメント | `0x00000000/codecs/0x00001C90/` (DECLARE 対象 `1C90`) |
| セクション | 14 `1110` (Meta)、セクション内オフセット C = 9 |
| Kind | Meta · クラス: 定義 |
| TAG WORD | `0001 1100 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | このバージョンの有効期間の終わり(限時法)。なければ次のバージョンが施行されるまで |
| Hugo 側 | `meta/declaration/effective-until.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload フィールドの順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `time` | #2 | レコード | `06A0` GREGORIAN-DATE, `06C0` POSIX-TIMESTAMP-SECONDS |  |

このバージョンの有効期間の終わりを宣言する(限時法)。その時刻以降、このバージョンは施行中ではない。

## レイアウト {#레이아웃}

```
TAG WORD          0001 1100 1001 LLLL      Codec 0x1C9L
[Length 拡張 TAG]
Payload           TIME Value 1 つ
```

- Codec: Meta `0x1C9L`、定義クラス
- Payload: 埋め込み Value([GREGORIAN-DATE](../value/0x06AL-gregorian-date.md) または [POSIX-TIMESTAMP-SECONDS](../value/0x06CL-posix-timestamp-seconds.md))
- 個数: 多くても 1 つ

## 解釈と有効性 {#해석과-유효성}

- なければ次のバージョンが施行されるまで有効である。
- 有効期間が過ぎると、施行中の版はなくなる。古い版が復活することはない。

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00001C90/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C9000000000
BODY
#1 DECLARE 0x1C90
#2 FIELD #1 record
#3 BIND #1 "EFFECTIVE-UNTIL"
#4 BIND #2 "time"
#5 CODEC #2 0x06A0
#6 CODEC #2 0x06C0
```
