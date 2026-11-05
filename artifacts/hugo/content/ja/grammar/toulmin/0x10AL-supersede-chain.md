---
title: "SUPERSEDE-CHAIN (0x10AL)"
weight: 266
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "SUPERSEDE-CHAIN は TOULMIN Edge Codec である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SUPERSEDE-CHAIN は TOULMIN Edge Codec である。意味は優先順位の連鎖 `A > B > C`。組ごとの SUPERSEDES の省略形。

| 項目 | 値 |
|---|---|
| 名前 | `SUPERSEDE-CHAIN` (規格ドキュメント BIND `SUPERSEDE-CHAIN`) |
| TAG ID | `0x10AL` |
| Codec ID | `0x000010A0` |
| 規格ドキュメント | `0x00000000/codecs/0x000010A0/` (DECLARE 対象 `10A0`) |
| セクション | 8 `1000` (Edge TOULMIN)、セクション内オフセット C = 10 |
| Kind | Edge · 系列: TOULMIN、まとまり: 関係 |
| TAG WORD | `0001 0000 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | 優先順位の連鎖 `A > B > C`。組ごとの SUPERSEDES の省略形。レイアウト未定 |
| Hugo 側 | `edge/toulmin/_index.md` |

## レイアウト {#레이아웃}

コードだけを割り当て、レイアウトはまだない ([TOULMIN](_index.md#열린-문제))。

- 今は [SUPERSEDES](0x109L-supersedes.md) を組ごとに一つずつ書く。それで連鎖として十分かどうかは未解決の問題である。

## Codec ドキュメント {#코덱-문서}

レイアウトが定まっていない。Codec ドキュメントは DECLARE (対象 `10A0`) だけを置く。FIELD はレイアウトが定まってから置く。

## 関連ページ {#관련-페이지}

- [TOULMIN](_index.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x000010A0/latest.geul` を `geul show` で読んだ姿である (16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000010A000000000
BODY
#1 DECLARE 0x10A0
#2 BIND #1 "SUPERSEDE-CHAIN"
```
