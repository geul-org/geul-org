---
title: "CHECKING (0x114L)"
weight: 276
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "CHECKING は TOULMIN グラフの関係を書く LINK Codec である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CHECKING は TOULMIN グラフの関係を書く LINK Codec である。意味は副作用なしに判定だけを行う接続。

| 項目 | 値 |
|---|---|
| 名前 | `CHECKING` (規格ドキュメント BIND `CHECKING`) |
| TAG ID | `0x114L` |
| Codec ID | `0x00001140` |
| 規格ドキュメント | `0x00000000/codecs/0x00001140/` (DECLARE 対象 `1140`) |
| セクション | 8 `1000` (Edge TOULMIN)、セクション内オフセット C = 20 |
| Kind | Edge · 系列: TOULMIN、まとまり: 実行、レイアウト: LINK |
| TAG WORD | `0001 0001 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | 副作用なしに判定だけを行う接続 |
| Hugo 側 | `edge/toulmin/link.md` |

## レイアウト {#레이아웃}

レイアウトは [LINK](_index.md#link) である (ID、src、dst、flags、条件付きフィールド、SPAN)。

| 項目 | 値 |
|---|---|
| TANGEUL | `checking c` |
| src → dst | 規則 → 事案。副作用のない判定 |

- dst はノードの REF である。
- F_FORCE は使わない (オンになっていれば拒否する)。
- 共通フィールド (ID、REF、SPAN) と数値規則は [TOULMIN](_index.md#공통-필드) に従う。

## Codec ドキュメント {#코덱-문서}

Codec ドキュメントは DECLARE (対象 `1140`) を置く。LINK レイアウトの条件付きフィールドと、SOURCE が定める SPAN 幅は FIELD で宣言できないため、フィールド宣言は未解決の問題である ([TOULMIN](_index.md#열린-문제))。

## 関連ページ {#관련-페이지}

- [LINK](_index.md#link)、[TOULMIN](_index.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00001140/latest.geul` を `geul show` で読んだ姿である (16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000114000000000
BODY
#1 DECLARE 0x1140
#2 BIND #1 "CHECKING"
```
