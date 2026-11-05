---
title: "LABEL (0x134L)"
weight: 308
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "LABEL は TOULMIN グラフの関係を書く LINK Codec である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LABEL は TOULMIN グラフの関係を書く LINK Codec である。意味はノード → TEXT、名前の表記。

| 項目 | 値 |
|---|---|
| 名前 | `LABEL` (規格ドキュメント BIND `LABEL`) |
| TAG ID | `0x134L` |
| Codec ID | `0x00001340` |
| 規格ドキュメント | `0x00000000/codecs/0x00001340/` (DECLARE 対象 `1340`) |
| セクション | 9 `1001` (Edge TOULMIN 形式)、セクション内オフセット C = 20 |
| Kind | Edge · 系列: TOULMIN 形式、レイアウト: LINK |
| TAG WORD | `0001 0011 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | ノード → TEXT、名前の表記 |
| Hugo 側 | `edge/toulmin/link.md` |

## レイアウト {#레이아웃}

レイアウトは [LINK](_index.md#link) である (ID、src、dst、flags、条件付きフィールド、SPAN)。

| 項目 | 値 |
|---|---|
| TANGEUL | バッククォート名 |
| src → dst | ノード → TEXT。名前の表記 |

- dst は TEXT レコードの REF である。バッククォート名を叙述 [LABEL](../edge/0x0A4L-label.md)・[BIND](../edge/0x0A3L-bind.md) として置くかどうかは未解決の問題である ([TOULMIN](_index.md#열린-문제))。
- F_FORCE は使わない (オンになっていれば拒否する)。
- 共通フィールド (ID、REF、SPAN) と数値規則は [TOULMIN](_index.md#공통-필드) に従う。

## Codec ドキュメント {#코덱-문서}

Codec ドキュメントは DECLARE (対象 `1340`) を置く。LINK レイアウトの条件付きフィールドと、SOURCE が定める SPAN 幅は FIELD で宣言できないため、フィールド宣言は未解決の問題である ([TOULMIN](_index.md#열린-문제))。

## 関連ページ {#관련-페이지}

- [LINK](_index.md#link)、[TOULMIN](_index.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00001340/latest.geul` を `geul show` で読んだ姿である (16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000134000000000
BODY
#1 DECLARE 0x1340
#2 BIND #1 "LABEL"
```
