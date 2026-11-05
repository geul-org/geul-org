---
title: "MESSAGE (0x1D9L)"
weight: 473
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "変更の理由を記す(git commit message)。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `MESSAGE` (規格ドキュメント BIND `MESSAGE`) |
| TAG ID | `0x1D9L` |
| Codec ID | `0x00001D90` |
| 規格ドキュメント | `0x00000000/codecs/0x00001D90/` (DECLARE 対象 `1D90`) |
| セクション | 14 `1110` (Meta)、セクション内オフセット C = 25 |
| Kind | Meta · クラス: 系譜 |
| TAG WORD | `0001 1101 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | 変更理由。UTF8-LANGUAGE-TEXT Value、言語ごとに 1 つ (git commit message) |
| Hugo 側 | `meta/lineage/message.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload フィールドの順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `message` | #2 | レコード | `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT |  |

変更の理由を記す(git commit message)。

## レイアウト {#레이아웃}

```
TAG WORD          0001 1101 1001 LLLL      Codec 0x1D9L
[Length 拡張 TAG]
メッセージ        UTF8-LANGUAGE-TEXT Value 1 つ
```

- Codec: Meta `0x1D9L`、系譜クラス
- Payload: 埋め込み Value([UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md))
- 個数: 言語ごとに多くても 1 つ

## 解釈と有効性 {#해석과-유효성}

- メッセージと言語は UTF8-LANGUAGE-TEXT 1 つに収める。同じ言語の MESSAGE は 1 つである。
- geul.org 規格ドキュメントは [CODEC](../edge/0x0BEL-codec.md) `0780`・`0790` で記す。

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00001D90/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D9000000000
BODY
#1 DECLARE 0x1D90
#2 FIELD #1 record
#3 BIND #1 "MESSAGE"
#4 BIND #2 "message"
#5 CODEC #2 0x0780
#6 CODEC #2 0x0790
```
