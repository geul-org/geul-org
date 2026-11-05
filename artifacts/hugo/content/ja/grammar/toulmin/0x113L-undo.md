---
title: "UNDO (0x113L)"
weight: 275
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "UNDO は TOULMIN グラフの関係を書く LINK Codec である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UNDO は TOULMIN グラフの関係を書く LINK Codec である。意味は DO の補償動作 (saga)。後の段階が失敗したら逆順に行う。

| 項目 | 値 |
|---|---|
| 名前 | `UNDO` (規格ドキュメント BIND `UNDO`) |
| TAG ID | `0x113L` |
| Codec ID | `0x00001130` |
| 規格ドキュメント | `0x00000000/codecs/0x00001130/` (DECLARE 対象 `1130`) |
| セクション | 8 `1000` (Edge TOULMIN)、セクション内オフセット C = 19 |
| Kind | Edge · 系列: TOULMIN、まとまり: 実行、レイアウト: LINK |
| TAG WORD | `0001 0001 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | DO の補償動作 (saga)。後の段階が失敗したら逆順に行う |
| Hugo 側 | `edge/toulmin/link.md` |

## レイアウト {#레이아웃}

レイアウトは [LINK](_index.md#link) である (ID、src、dst、flags、条件付きフィールド、SPAN)。

| 項目 | 値 |
|---|---|
| TANGEUL | `undo fn when n` |
| src → dst | 規則 → FuncRef |

- dst は FuncRef である。UNDO の `once` は flags の F_ONCE で書く。
- F_FORCE は使わない (オンになっていれば拒否する)。
- 共通フィールド (ID、REF、SPAN) と数値規則は [TOULMIN](_index.md#공통-필드) に従う。

## Codec ドキュメント {#코덱-문서}

Codec ドキュメントは DECLARE (対象 `1130`) を置く。LINK レイアウトの条件付きフィールドと、SOURCE が定める SPAN 幅は FIELD で宣言できないため、フィールド宣言は未解決の問題である ([TOULMIN](_index.md#열린-문제))。

## 関連ページ {#관련-페이지}

- [LINK](_index.md#link)、[TOULMIN](_index.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00001130/latest.geul` を `geul show` で読んだ姿である (16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000113000000000
BODY
#1 DECLARE 0x1130
#2 BIND #1 "UNDO"
```
