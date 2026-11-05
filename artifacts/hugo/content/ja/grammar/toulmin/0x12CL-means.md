---
title: "MEANS (0x12CL)"
weight: 300
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "MEANS は TOULMIN グラフの関係を書く LINK Codec である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

MEANS は TOULMIN グラフの関係を書く LINK Codec である。意味は定義項目 → 値・型。

| 項目 | 値 |
|---|---|
| 名前 | `MEANS` (規格ドキュメント BIND `MEANS`) |
| TAG ID | `0x12CL` |
| Codec ID | `0x000012C0` |
| 規格ドキュメント | `0x00000000/codecs/0x000012C0/` (DECLARE 対象 `12C0`) |
| セクション | 9 `1001` (Edge TOULMIN 形式)、セクション内オフセット C = 12 |
| Kind | Edge · 系列: TOULMIN 形式、レイアウト: LINK |
| TAG WORD | `0001 0010 1100 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | 定義項目 → 値・型 |
| Hugo 側 | `edge/toulmin/link.md` |

## レイアウト {#레이아웃}

レイアウトは [LINK](_index.md#link) である (ID、src、dst、flags、条件付きフィールド、SPAN)。

| 項目 | 値 |
|---|---|
| TANGEUL | Definitions `means` |
| src → dst | 定義項目 → 値・型 |

- dst はノードの REF である。
- F_FORCE は使わない (オンになっていれば拒否する)。
- 共通フィールド (ID、REF、SPAN) と数値規則は [TOULMIN](_index.md#공통-필드) に従う。

## Codec ドキュメント {#코덱-문서}

Codec ドキュメントは DECLARE (対象 `12C0`) を置く。LINK レイアウトの条件付きフィールドと、SOURCE が定める SPAN 幅は FIELD で宣言できないため、フィールド宣言は未解決の問題である ([TOULMIN](_index.md#열린-문제))。

## 関連ページ {#관련-페이지}

- [LINK](_index.md#link)、[TOULMIN](_index.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x000012C0/latest.geul` を `geul show` で読んだ姿である (16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000012C000000000
BODY
#1 DECLARE 0x12C0
#2 BIND #1 "MEANS"
```
