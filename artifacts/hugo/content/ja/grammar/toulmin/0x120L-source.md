---
title: "SOURCE (0x120L)"
weight: 288
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "SOURCE は TOULMIN ドキュメントの原文・区画レコードである。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SOURCE は TOULMIN ドキュメントの原文・区画レコードである。意味は著作原文。

| 項目 | 値 |
|---|---|
| 名前 | `SOURCE` (規格ドキュメント BIND `SOURCE`) |
| TAG ID | `0x120L` |
| Codec ID | `0x00001200` |
| 規格ドキュメント | `0x00000000/codecs/0x00001200/` (DECLARE 対象 `1200`) |
| セクション | 9 `1001` (Edge TOULMIN 形式)、セクション内オフセット C = 0 |
| Kind | Edge · 系列: TOULMIN 形式、レイアウト: ID, SPAN 幅 WORD, UTF8 Value |
| TAG WORD | `0001 0010 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | 著作原文 |
| Hugo 側 | `edge/toulmin/source.md` |

## レイアウト {#레이아웃}

著作原文の全体である。すべての SPAN はこの原文の中のバイト範囲である。

```
ID
SPAN 幅 WORD     上位 2 ビット = 幅 (00=1, 01=2, 10=4, 11=8 WORD)、残り 14 ビット = 0
原文             UTF8-TEXT Value レコード
```

- SOURCE は BODY の最初のレコードである。ドキュメントに一つ。
- SPAN は開始バイトとバイト数の二つのフィールドである。各フィールドは SPAN 幅 WORD が定める幅 (1/2/4/8 WORD) の unsigned 整数である。
- 根拠 Edge の [SOURCE](../edge/0x0C0L-source.md) (`0x0C0L`) とは別の Codec である。

- ID は Edge Id、REF はこのドキュメントのレコードの Edge Id である ([TOULMIN](_index.md#공통-필드) の共通フィールド)。Issuer と Codec 番号の欄なしに TAG の後に Payload が来る。

## Codec ドキュメント {#코덱-문서}

Codec ドキュメントは DECLARE (対象 `1200`) を置く。フィールド宣言は TOULMIN Codec の規格ドキュメントと併せて定める ([TOULMIN](_index.md#열린-문제))。

## 関連ページ {#관련-페이지}

- [SOURCE と区画](_index.md#source와-구획)、[TOULMIN](_index.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00001200/latest.geul` を `geul show` で読んだ姿である (16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000120000000000
BODY
#1 DECLARE 0x1200
#2 BIND #1 "SOURCE"
```
