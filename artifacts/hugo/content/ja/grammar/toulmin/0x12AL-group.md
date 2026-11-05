---
title: "GROUP (0x12AL)"
weight: 298
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "GROUP は TOULMIN グラフのノードを書く NODE Codec である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GROUP は TOULMIN グラフのノードを書く NODE Codec である。意味は順序のある実行のまとまり。

| 項目 | 値 |
|---|---|
| 名前 | `GROUP` (規格ドキュメント BIND `GROUP`) |
| TAG ID | `0x12AL` |
| Codec ID | `0x000012A0` |
| 規格ドキュメント | `0x00000000/codecs/0x000012A0/` (DECLARE 対象 `12A0`) |
| セクション | 9 `1001` (Edge TOULMIN 形式)、セクション内オフセット C = 10 |
| Kind | Edge · 系列: TOULMIN 形式、レイアウト: NODE |
| TAG WORD | `0001 0010 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | 順序のある実行のまとまり |
| Hugo 側 | `edge/toulmin/node.md` |

## レイアウト {#레이아웃}

レイアウトは [NODE](_index.md#node) である。ヘッダ 1 WORD が role・level・Claim の形と条件付きフィールドを定める。

| 項目 | 値 |
|---|---|
| TANGEUL | `1.` 順序リスト |
| ノード | 順序のある実行のまとまり |

- role は 0 でなければならない。
- 共通フィールド (ID、REF、SPAN) と数値規則は [TOULMIN](_index.md#공통-필드) に従う。

## Codec ドキュメント {#코덱-문서}

Codec ドキュメントは DECLARE (対象 `12A0`) を置く。NODE レイアウトの条件付きフィールドと、SOURCE が定める SPAN 幅は FIELD で宣言できないため、フィールド宣言は未解決の問題である ([TOULMIN](_index.md#열린-문제))。

## 関連ページ {#관련-페이지}

- [NODE](_index.md#node)、[TOULMIN](_index.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x000012A0/latest.geul` を `geul show` で読んだ姿である (16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000012A000000000
BODY
#1 DECLARE 0x12A0
#2 BIND #1 "GROUP"
```
