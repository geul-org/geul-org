---
title: "SOURCE と区画"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "TOULMIN ドキュメントの著作原文(SOURCE)、文字列(TEXT)、セクション・事案の区画(SECTION、CASE-BEGIN、CASE-END)、叙述の段落(PROSE)を書く GEUL ISSUER 形式 0xC000~0xC005 だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TOULMIN ドキュメントの原文と区画を書くレコードだ。すべて `ISSUER-1WORD`(`0x7C`)、Issuer `0x0000`(GEUL)の下の形式番号を使う Edge だ([TOULMIN](/ja/grammar/edge/toulmin/#issuer-形式))。

## 形式

| 形式番号 | 名前 | レイアウト |
|---|---|---|
| `0xC000` | SOURCE | ID, SPAN 幅 WORD, UTF8 Value |
| `0xC001` | TEXT | ID, UTF8 Value |
| `0xC002` | SECTION | ID, セクションコード 1 WORD |
| `0xC003` | CASE-BEGIN | ID, REF(事案) |
| `0xC004` | CASE-END | ID, REF(事案) |
| `0xC005` | PROSE | ID, SPAN |

- ID は Edge Id、REF はこのドキュメントのレコードの Edge Id だ([TOULMIN](/ja/grammar/edge/toulmin/#共通フィールド)の共通フィールド)。
- UTF8 Value は [UTF8-TEXT](/ja/grammar/value/text/utf8-text/) Value レコードだ。バイトをそのまま収める。

## SOURCE

著作原文全体だ。すべての SPAN は、この原文内のバイト範囲だ。

```
ID
SPAN 幅 WORD     上位2ビット = 幅(00=1, 01=2, 10=4, 11=8 WORD)、残りの14ビット = 0
原文             UTF8-TEXT Value レコード
```

- SOURCE は BODY の最初のレコードだ。ドキュメントに一つだけある。
- SPAN は開始バイトとバイト数の二つのフィールドだ。各フィールドは、SPAN 幅 WORD が定めた幅(1/2/4/8 WORD)の unsigned 整数だ。

## TEXT

名前・文字列一つだ。NODE の F_WITH・F_GROUNDS リスト、LINK の LABEL・IMPORTED-FROM が REF で指す。

## SECTION

セクションの開始だ。セクションコードは 1 WORD だ。

| コード | セクション | TANGEUL |
|---|---|---|
| 1 | Subject | `this document is x` |
| 2 | See | `see a from path` |
| 3 | Definitions | `means`, `has` |
| 4 | Rules | 条件式の規則 |
| 5 | Cases | `in case of x` |
| 6 | Provides | `provides x` |
| 7 | Internal | `on`, `every` |

- `0` は使わない。セクションはこのコードの順序で宣言される。
- セクションのタイトルは、SECTION の直後の PROSE だ。

## CASE-BEGIN, CASE-END

- 事案の範囲は、同じ事案(CASE-DECLARE NODE)を指す CASE-BEGIN と CASE-END の間だ。

## PROSE

規則ではない叙述の段落だ。原文の範囲(SPAN)だけを指す。

## 関連ページ

- [TOULMIN](/ja/grammar/edge/toulmin/)、[NODE](/ja/grammar/edge/toulmin/node/)、[LINK](/ja/grammar/edge/toulmin/link/)
