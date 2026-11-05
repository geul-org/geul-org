---
title: "RULE-DECLARE (0x103L)"
weight: 259
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "RULE-DECLARE は TOULMIN グラフのノードを書く NODE Codec である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

RULE-DECLARE は TOULMIN グラフのノードを書く NODE Codec である。意味は主張宣言 (Warrant)。攻撃を受けうる。

| 項目 | 値 |
|---|---|
| 名前 | `RULE-DECLARE` (規格ドキュメント BIND `RULE-DECLARE`) |
| TAG ID | `0x103L` |
| Codec ID | `0x00001030` |
| 規格ドキュメント | `0x00000000/codecs/0x00001030/` (DECLARE 対象 `1030`) |
| セクション | 8 `1000` (Edge TOULMIN)、セクション内オフセット C = 3 |
| Kind | Edge · 系列: TOULMIN、まとまり: 宣言、レイアウト: NODE |
| TAG WORD | `0001 0000 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | 主張宣言 (Warrant)。攻撃を受けうる |
| Hugo 側 | `edge/toulmin/node.md` |

## レイアウト {#레이아웃}

レイアウトは [NODE](_index.md#node) である。ヘッダ 1 WORD が role・level・Claim の形と条件付きフィールドを定める。

| 項目 | 値 |
|---|---|
| TANGEUL | general rule、Rules の規則名 |
| ノード | 主張 (Warrant) |

- role は 0 (general) でなければならない。
- 共通フィールド (ID、REF、SPAN) と数値規則は [TOULMIN](_index.md#공통-필드) に従う。

## Codec ドキュメント {#코덱-문서}

Codec ドキュメントは DECLARE (対象 `1030`) を置く。NODE レイアウトの条件付きフィールドと、SOURCE が定める SPAN 幅は FIELD で宣言できないため、フィールド宣言は未解決の問題である ([TOULMIN](_index.md#열린-문제))。

## 関連ページ {#관련-페이지}

- [NODE](_index.md#node)、[TOULMIN](_index.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00001030/latest.geul` を `geul show` で読んだ姿である (16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000103000000000
BODY
#1 DECLARE 0x1030
#2 BIND #1 "RULE-DECLARE"
```
