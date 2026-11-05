---
title: "CASE-BEGIN (0x123L)"
weight: 291
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "CASE-BEGIN は TOULMIN ドキュメントの原文・区画レコードである。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CASE-BEGIN は TOULMIN ドキュメントの原文・区画レコードである。意味は事案範囲の開始。

| 項目 | 値 |
|---|---|
| 名前 | `CASE-BEGIN` (規格ドキュメント BIND `CASE-BEGIN`) |
| TAG ID | `0x123L` |
| Codec ID | `0x00001230` |
| 規格ドキュメント | `0x00000000/codecs/0x00001230/` (DECLARE 対象 `1230`) |
| セクション | 9 `1001` (Edge TOULMIN 形式)、セクション内オフセット C = 3 |
| Kind | Edge · 系列: TOULMIN 形式、レイアウト: ID, REF (事案) |
| TAG WORD | `0001 0010 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | 事案範囲の開始 |
| Hugo 側 | `edge/toulmin/source.md` |

## レイアウト {#레이아웃}

事案範囲の開始である。

```
ID
事案             REF (CASE-DECLARE NODE)
```

- 事案の範囲は、同じ事案 ([CASE-DECLARE](0x100L-case-declare.md) NODE) を指す CASE-BEGIN と [CASE-END](0x124L-case-end.md) の間である。

- ID は Edge Id、REF はこのドキュメントのレコードの Edge Id である ([TOULMIN](_index.md#공통-필드) の共通フィールド)。Issuer と Codec 番号の欄なしに TAG の後に Payload が来る。

## Codec ドキュメント {#코덱-문서}

Codec ドキュメントは DECLARE (対象 `1230`) を置く。フィールド宣言は TOULMIN Codec の規格ドキュメントと併せて定める ([TOULMIN](_index.md#열린-문제))。

## 関連ページ {#관련-페이지}

- [SOURCE と区画](_index.md#source와-구획)、[TOULMIN](_index.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00001230/latest.geul` を `geul show` で読んだ姿である (16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000123000000000
BODY
#1 DECLARE 0x1230
#2 BIND #1 "CASE-BEGIN"
```
