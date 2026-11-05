---
title: "SECTION (0x122L)"
weight: 290
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "SECTION は TOULMIN ドキュメントの原文・区画レコードである。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SECTION は TOULMIN ドキュメントの原文・区画レコードである。意味はセクションの開始。

| 項目 | 値 |
|---|---|
| 名前 | `SECTION` (規格ドキュメント BIND `SECTION`) |
| TAG ID | `0x122L` |
| Codec ID | `0x00001220` |
| 規格ドキュメント | `0x00000000/codecs/0x00001220/` (DECLARE 対象 `1220`) |
| セクション | 9 `1001` (Edge TOULMIN 形式)、セクション内オフセット C = 2 |
| Kind | Edge · 系列: TOULMIN 形式、レイアウト: ID, セクションコード 1 WORD |
| TAG WORD | `0001 0010 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | セクションの開始 |
| Hugo 側 | `edge/toulmin/source.md` |

## レイアウト {#레이아웃}

セクションの開始である。セクションコードは 1 WORD である。

```
ID
セクションコード  1 WORD
```

| コード | セクション | TANGEUL |
|---|---|---|
| 1 | Subject | `this document is x` |
| 2 | See | `see a from path` |
| 3 | Definitions | `means`, `has` |
| 4 | Rules | 条件式の規則 |
| 5 | Cases | `in case of x` |
| 6 | Provides | `provides x` |
| 7 | Internal | `on`, `every` |

- `0` は使わない。セクションはこのコードの順に宣言される。
- セクションの見出しは SECTION の直後の [PROSE](0x125L-prose.md) である。

- ID は Edge Id、REF はこのドキュメントのレコードの Edge Id である ([TOULMIN](_index.md#공통-필드) の共通フィールド)。Issuer と Codec 番号の欄なしに TAG の後に Payload が来る。

## Codec ドキュメント {#코덱-문서}

Codec ドキュメントは DECLARE (対象 `1220`) を置く。フィールド宣言は TOULMIN Codec の規格ドキュメントと併せて定める ([TOULMIN](_index.md#열린-문제))。

## 関連ページ {#관련-페이지}

- [SOURCE と区画](_index.md#source와-구획)、[TOULMIN](_index.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00001220/latest.geul` を `geul show` で読んだ姿である (16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000122000000000
BODY
#1 DECLARE 0x1220
#2 BIND #1 "SECTION"
```
