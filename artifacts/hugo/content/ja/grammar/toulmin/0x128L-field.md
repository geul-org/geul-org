---
title: "FIELD (0x128L)"
weight: 296
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "FIELD は TOULMIN グラフのノードを書く NODE Codec である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

FIELD は TOULMIN グラフのノードを書く NODE Codec である。意味は `is required`。必須フィールド。

| 項目 | 値 |
|---|---|
| 名前 | `FIELD` (規格ドキュメント BIND `FIELD`) |
| TAG ID | `0x128L` |
| Codec ID | `0x00001280` |
| 規格ドキュメント | `0x00000000/codecs/0x00001280/` (DECLARE 対象 `1280`) |
| セクション | 9 `1001` (Edge TOULMIN 形式)、セクション内オフセット C = 8 |
| Kind | Edge · 系列: TOULMIN 形式、レイアウト: NODE |
| TAG WORD | `0001 0010 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | `is required`。必須フィールド |
| Hugo 側 | `edge/toulmin/node.md` |

## レイアウト {#레이아웃}

レイアウトは [NODE](_index.md#node) である。ヘッダ 1 WORD が role・level・Claim の形と条件付きフィールドを定める。

| 項目 | 値 |
|---|---|
| TANGEUL | `x is required [as Type]` |
| ノード | 必須フィールド |

- role は 0 でなければならない。
- 共通フィールド (ID、REF、SPAN) と数値規則は [TOULMIN](_index.md#공통-필드) に従う。

## Codec ドキュメント {#코덱-문서}

Codec ドキュメントは DECLARE (対象 `1280`) を置く。NODE レイアウトの条件付きフィールドと、SOURCE が定める SPAN 幅は FIELD で宣言できないため、フィールド宣言は未解決の問題である ([TOULMIN](_index.md#열린-문제))。

## 関連ページ {#관련-페이지}

- [NODE](_index.md#node)、[TOULMIN](_index.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00001280/latest.geul` を `geul show` で読んだ姿である (16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000128000000000
BODY
#1 DECLARE 0x1280
#2 BIND #1 "FIELD"
```
