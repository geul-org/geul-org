---
title: "PROSE (0x125L)"
weight: 293
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "PROSE は TOULMIN ドキュメントの原文・区画レコードである。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

PROSE は TOULMIN ドキュメントの原文・区画レコードである。意味は叙述の段落。

| 項目 | 値 |
|---|---|
| 名前 | `PROSE` (規格ドキュメント BIND `PROSE`) |
| TAG ID | `0x125L` |
| Codec ID | `0x00001250` |
| 規格ドキュメント | `0x00000000/codecs/0x00001250/` (DECLARE 対象 `1250`) |
| セクション | 9 `1001` (Edge TOULMIN 形式)、セクション内オフセット C = 5 |
| Kind | Edge · 系列: TOULMIN 形式、レイアウト: ID, SPAN |
| TAG WORD | `0001 0010 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | 叙述の段落 |
| Hugo 側 | `edge/toulmin/source.md` |

## レイアウト {#레이아웃}

規則ではない叙述の段落である。原文の範囲 (SPAN) だけを指す。

```
ID
SPAN             SOURCE が定めた幅 × 2 (開始バイト、バイト数)
```

- ID は Edge Id、REF はこのドキュメントのレコードの Edge Id である ([TOULMIN](_index.md#공통-필드) の共通フィールド)。Issuer と Codec 番号の欄なしに TAG の後に Payload が来る。

## Codec ドキュメント {#코덱-문서}

Codec ドキュメントは DECLARE (対象 `1250`) を置く。SPAN 幅を SOURCE が定めるため FIELD で宣言できず、フィールド宣言は未解決の問題である ([TOULMIN](_index.md#열린-문제))。

## 関連ページ {#관련-페이지}

- [SOURCE と区画](_index.md#source와-구획)、[TOULMIN](_index.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00001250/latest.geul` を `geul show` で読んだ姿である (16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000125000000000
BODY
#1 DECLARE 0x1250
#2 BIND #1 "PROSE"
```
