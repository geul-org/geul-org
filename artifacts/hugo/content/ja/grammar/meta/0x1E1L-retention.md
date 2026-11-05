---
title: "RETENTION (0x1E1L)"
weight: 481
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "ドキュメントの保存期限を記す。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `RETENTION` (規格ドキュメント BIND `RETENTION`) |
| TAG ID | `0x1E1L` |
| Codec ID | `0x00001E10` |
| 規格ドキュメント | `0x00000000/codecs/0x00001E10/` (DECLARE 対象 `1E10`) |
| セクション | 15 `1111` (Meta)、セクション内オフセット C = 1 |
| Kind | Meta · クラス: ポリシー |
| TAG WORD | `0001 1110 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | 保存期限 |
| Hugo 側 | `meta/policy/retention.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload フィールドの順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `retention` | #2 | レコード | `06A0` GREGORIAN-DATE, `06C0` POSIX-TIMESTAMP-SECONDS, `06E0` EDTF, `06F0` EDTF, `0700` GEDCOM-DATE, `0710` GEDCOM-DATE, `06D0` DURATION-SECONDS |  |

ドキュメントの保存期限を記す。

## レイアウト {#레이아웃}

```
TAG WORD          0001 1110 0001 LLLL      Codec 0x1E1L
[Length 拡張 TAG]
Payload           満了時刻(GREGORIAN-DATE など)または期間(DURATION-SECONDS)
```

- Codec: Meta `0x1E1L`、ポリシークラス
- Payload: 埋め込み Value(TIME 系: [GREGORIAN-DATE](../value/0x06AL-gregorian-date.md) など、または [DURATION-SECONDS](../value/0x06DL-duration-seconds.md))
- 個数: 多くても 1 つ

## 解釈と有効性 {#해석과-유효성}

- 期間であれば [RECORDED-AT](0x1D0L-recorded-at.md) から数える。

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00001E10/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E1000000000
BODY
#1 DECLARE 0x1E10
#2 FIELD #1 record
#3 BIND #1 "RETENTION"
#4 BIND #2 "retention"
#5 CODEC #2 0x06A0
#6 CODEC #2 0x06C0
#7 CODEC #2 0x06E0
#8 CODEC #2 0x06F0
#9 CODEC #2 0x0700
#10 CODEC #2 0x0710
#11 CODEC #2 0x06D0
```
