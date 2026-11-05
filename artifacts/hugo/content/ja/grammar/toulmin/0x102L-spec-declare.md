---
title: "SPEC-DECLARE (0x102L)"
weight: 258
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "SPEC-DECLARE は TOULMIN グラフのノードを書く NODE Codec である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SPEC-DECLARE は TOULMIN グラフのノードを書く NODE Codec である。意味は判断基準宣言 (Backing)。role ビットが定義の種類。

| 項目 | 値 |
|---|---|
| 名前 | `SPEC-DECLARE` (規格ドキュメント BIND `SPEC-DECLARE`) |
| TAG ID | `0x102L` |
| Codec ID | `0x00001020` |
| 規格ドキュメント | `0x00000000/codecs/0x00001020/` (DECLARE 対象 `1020`) |
| セクション | 8 `1000` (Edge TOULMIN)、セクション内オフセット C = 2 |
| Kind | Edge · 系列: TOULMIN、まとまり: 宣言、レイアウト: NODE |
| TAG WORD | `0001 0000 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | 判断基準宣言 (Backing)。role ビットが定義の種類 |
| Hugo 側 | `edge/toulmin/node.md` |

## レイアウト {#레이아웃}

レイアウトは [NODE](_index.md#node) である。ヘッダ 1 WORD が role・level・Claim の形と条件付きフィールドを定める。

| 項目 | 値 |
|---|---|
| TANGEUL | Definitions の項目 (`means`, `has`) |
| ノード | 判断基準 (Backing)。role が定義の種類 |

- role は定義の種類である。
- 共通フィールド (ID、REF、SPAN) と数値規則は [TOULMIN](_index.md#공통-필드) に従う。

## Codec ドキュメント {#코덱-문서}

Codec ドキュメントは DECLARE (対象 `1020`) を置く。NODE レイアウトの条件付きフィールドと、SOURCE が定める SPAN 幅は FIELD で宣言できないため、フィールド宣言は未解決の問題である ([TOULMIN](_index.md#열린-문제))。

## 関連ページ {#관련-페이지}

- [NODE](_index.md#node)、[TOULMIN](_index.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00001020/latest.geul` を `geul show` で読んだ姿である (16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000102000000000
BODY
#1 DECLARE 0x1020
#2 BIND #1 "SPEC-DECLARE"
```
