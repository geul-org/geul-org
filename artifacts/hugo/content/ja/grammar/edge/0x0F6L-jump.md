---
title: "JUMP (0x0F6L)"
weight: 246
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "JUMP は、実行 Edge の文のまとまりの Codec である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

JUMP は、実行 Edge の文のまとまりの Codec である。意味: 反復制御。

| 項目 | 値 |
|---|---|
| 名前 | `JUMP` (規格ドキュメント BIND `JUMP`) |
| TAG ID | `0x0F6L` |
| Codec ID | `0x00000F60` |
| 規格ドキュメント | `0x00000000/codecs/0x00000F60/` (DECLARE 対象 `0F60`) |
| セクション | 7 `0111` (Edge 実行), セクション内オフセット C = 22 |
| Kind | Edge · 系列: 実行, まとまり: 文 |
| TAG WORD | `0000 1111 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引説明 | 反復制御。種類 1 WORD(break, continue)、対象の反復 |
| Hugo 側 | `edge/_index.md` |

## 構成要素 {#구성요소}

種類 1 WORD(break, continue)、対象の反復。

- 構成要素はこのドキュメントの LOCAL ID(REF)で指す。REF `0` は「なし」である。式の位置には式 Edge またはシンボルを置く([Edge](_index.md#실행-edge))。
- 演算子コード、型表現、Payload レイアウトはまだ定めていない([Edge](_index.md#실행-edge) 未解決の問題)。

## Codec ドキュメント {#코덱-문서}

レイアウトはまだ定めていない。Codec ドキュメントは DECLARE(対象 `0F60`)だけを置く。FIELD はレイアウトが決まってから置く。

## 関連ページ {#관련-페이지}

- [Edge — 実行 Edge](_index.md#실행-edge), [BLOCK](0x0F0L-block.md), [ASSIGN](0x0F1L-assign.md), [IF](0x0F2L-if.md), [SWITCH](0x0F3L-switch.md), [WHILE](0x0F4L-while.md), [FOREACH](0x0F5L-foreach.md), [RETURN](0x0F7L-return.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00000F60/latest.geul` を `geul show` で読んだ姿である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000F6000000000
BODY
#1 DECLARE 0x0F60
#2 BIND #1 "JUMP"
```
