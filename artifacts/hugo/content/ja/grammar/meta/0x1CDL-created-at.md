---
title: "CREATED-AT (0x1CDL)"
weight: 461
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "ドキュメントを作成した時刻を記す(git author date)。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `CREATED-AT` (規格ドキュメント BIND `CREATED-AT`) |
| TAG ID | `0x1CDL` |
| Codec ID | `0x00001CD0` |
| 規格ドキュメント | `0x00000000/codecs/0x00001CD0/` (DECLARE 対象 `1CD0`) |
| セクション | 14 `1110` (Meta)、セクション内オフセット C = 13 |
| Kind | Meta · クラス: 出典 |
| TAG WORD | `0001 1100 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | 作成時刻。TIME Value (git author date) |
| Hugo 側 | `meta/provenance/created-at.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload フィールドの順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `time` | #2 | レコード | `06A0` GREGORIAN-DATE, `06C0` POSIX-TIMESTAMP-SECONDS, `06E0` EDTF, `06F0` EDTF, `0700` GEDCOM-DATE, `0710` GEDCOM-DATE |  |

ドキュメントを作成した時刻を記す(git author date)。

## レイアウト {#레이아웃}

```
TAG WORD          0001 1100 1101 LLLL      Codec 0x1CDL
[Length 拡張 TAG]
Payload           TIME Value 1 つ (GREGORIAN-DATE, POSIX-TIMESTAMP-SECONDS など)
```

- Codec: Meta `0x1CDL`、出典クラス
- Payload: 埋め込み Value(TIME 系: [GREGORIAN-DATE](../value/0x06AL-gregorian-date.md)、[POSIX-TIMESTAMP-SECONDS](../value/0x06CL-posix-timestamp-seconds.md) など)
- 個数: 多くても 1 つ

## 解釈と有効性 {#해석과-유효성}

- 形式は TIME 系 Value から選ぶ。精度が必要なら Issuer が定義したナノ秒形式(例: [POSIX-TIMESTAMP-NANOSECONDS](../value/ieee.geul.org/posix-timestamp-nanoseconds.md))を使う。

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00001CD0/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001CD000000000
BODY
#1 DECLARE 0x1CD0
#2 FIELD #1 record
#3 BIND #1 "CREATED-AT"
#4 BIND #2 "time"
#5 CODEC #2 0x06A0
#6 CODEC #2 0x06C0
#7 CODEC #2 0x06E0
#8 CODEC #2 0x06F0
#9 CODEC #2 0x0700
#10 CODEC #2 0x0710
```
