---
title: "EFFECTIVE-FROM (0x1C8L)"
weight: 456
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "このバージョンの施行日を宣言する。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `EFFECTIVE-FROM` (規格ドキュメント BIND `EFFECTIVE-FROM`) |
| TAG ID | `0x1C8L` |
| Codec ID | `0x00001C80` |
| 規格ドキュメント | `0x00000000/codecs/0x00001C80/` (DECLARE 対象 `1C80`) |
| セクション | 14 `1110` (Meta)、セクション内オフセット C = 8 |
| Kind | Meta · クラス: 定義 |
| TAG WORD | `0001 1100 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | このバージョンの施行日。GREGORIAN-DATE または POSIX-TIMESTAMP Value。なければ公表時刻 |
| Hugo 側 | `meta/declaration/effective-from.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload フィールドの順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `time` | #2 | レコード | `06A0` GREGORIAN-DATE, `06C0` POSIX-TIMESTAMP-SECONDS |  |

このバージョンの施行日を宣言する。施行日は公表時刻とは異なる([改訂](../document.md#개정))。

## レイアウト {#레이아웃}

```
TAG WORD          0001 1100 1000 LLLL      Codec 0x1C8L
[Length 拡張 TAG]
Payload           TIME Value 1 つ
```

- Codec: Meta `0x1C8L`、定義クラス
- Payload: 埋め込み Value([GREGORIAN-DATE](../value/0x06AL-gregorian-date.md) または [POSIX-TIMESTAMP-SECONDS](../value/0x06CL-posix-timestamp-seconds.md))
- 個数: 多くても 1 つ

## 解釈と有効性 {#해석과-유효성}

- なければ公表時刻から施行する。
- [EFFECTIVE-UNTIL](0x1C9L-effective-until.md) があれば、それより前でなければならない。
- 条文ごとに施行日が異なる場合は、その条文 Edge に QUALIFIER P580(開始)・P582(終了)で別途記す([SOURCE](../edge/0x0C0L-source.md#다른-근거의-표현))。
- ドキュメントを特定の時点を基準に解釈するとき、この値を読む。

## 例 {#예시}

- 1970-01-02 施行: `0x1C83 0x06A2 0x0000 0x0001`

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00001C80/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C8000000000
BODY
#1 DECLARE 0x1C80
#2 FIELD #1 record
#3 BIND #1 "EFFECTIVE-FROM"
#4 BIND #2 "time"
#5 CODEC #2 0x06A0
#6 CODEC #2 0x06C0
```
