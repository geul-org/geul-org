---
title: "VERDICT (0x118L)"
weight: 280
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "VERDICT は TOULMIN Edge Codec である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

VERDICT は TOULMIN Edge Codec である。意味はノード・レコードの判定結果。結果 (Pass, Review, Fail)、判定値、Activated、Excluded、Level。

| 項目 | 値 |
|---|---|
| 名前 | `VERDICT` (規格ドキュメント BIND `VERDICT`) |
| TAG ID | `0x118L` |
| Codec ID | `0x00001180` |
| 規格ドキュメント | `0x00000000/codecs/0x00001180/` (DECLARE 対象 `1180`) |
| セクション | 8 `1000` (Edge TOULMIN)、セクション内オフセット C = 24 |
| Kind | Edge · 系列: TOULMIN、まとまり: 結果 |
| TAG WORD | `0001 0001 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | ノード・レコードの判定結果。結果 (Pass, Review, Fail)、判定値、Activated、Excluded、Level。レイアウト未定 |
| Hugo 側 | `edge/toulmin/_index.md` |

## レイアウト {#레이아웃}

コードだけを割り当て、レイアウトはまだない ([TOULMIN](_index.md#열린-문제))。

- ドキュメント全体の判定は Meta [VERDICT](../meta/0x1E9L-verdict.md) (`0x1E9L`) が担う。両者は Kind が異なる別個の Codec である。
- 判定結果は判定対象とは別のドキュメントに置く ([TOULMIN](_index.md#판정-결과))。

## Codec ドキュメント {#코덱-문서}

レイアウトが定まっていない。Codec ドキュメントは DECLARE (対象 `1180`) だけを置く。FIELD はレイアウトが定まってから置く。

## 関連ページ {#관련-페이지}

- [TOULMIN](_index.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00001180/latest.geul` を `geul show` で読んだ姿である (16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000118000000000
BODY
#1 DECLARE 0x1180
#2 BIND #1 "VERDICT"
```
