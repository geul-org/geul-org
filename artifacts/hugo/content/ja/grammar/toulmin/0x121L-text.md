---
title: "TEXT (0x121L)"
weight: 289
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "TEXT は TOULMIN ドキュメントの原文・区画レコードである。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TEXT は TOULMIN ドキュメントの原文・区画レコードである。意味は名前・文字列。

| 項目 | 値 |
|---|---|
| 名前 | `TEXT` (規格ドキュメント BIND `TEXT`) |
| TAG ID | `0x121L` |
| Codec ID | `0x00001210` |
| 規格ドキュメント | `0x00000000/codecs/0x00001210/` (DECLARE 対象 `1210`) |
| セクション | 9 `1001` (Edge TOULMIN 形式)、セクション内オフセット C = 1 |
| Kind | Edge · 系列: TOULMIN 形式、レイアウト: ID, UTF8 Value |
| TAG WORD | `0001 0010 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | 名前・文字列 |
| Hugo 側 | `edge/toulmin/source.md` |

## レイアウト {#레이아웃}

名前・文字列一つである。NODE の F_WITH・F_GROUNDS の一覧と、LINK の [LABEL](0x134L-label.md)・[IMPORTED-FROM](0x133L-imported-from.md) が REF で指す。

```
ID
文字列           UTF8-TEXT Value レコード
```

- ID は Edge Id、REF はこのドキュメントのレコードの Edge Id である ([TOULMIN](_index.md#공통-필드) の共通フィールド)。Issuer と Codec 番号の欄なしに TAG の後に Payload が来る。

## Codec ドキュメント {#코덱-문서}

Codec ドキュメントは DECLARE (対象 `1210`) を置く。フィールド宣言は TOULMIN Codec の規格ドキュメントと併せて定める ([TOULMIN](_index.md#열린-문제))。

## 関連ページ {#관련-페이지}

- [SOURCE と区画](_index.md#source와-구획)、[TOULMIN](_index.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00001210/latest.geul` を `geul show` で読んだ姿である (16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000121000000000
BODY
#1 DECLARE 0x1210
#2 BIND #1 "TEXT"
```
