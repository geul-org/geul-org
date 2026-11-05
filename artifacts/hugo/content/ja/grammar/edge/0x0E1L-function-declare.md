---
title: "FUNCTION-DECLARE (0x0E1L)"
weight: 225
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "FUNCTION-DECLARE は、実行 Edge の宣言のまとまりの Codec である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

FUNCTION-DECLARE は、実行 Edge の宣言のまとまりの Codec である。意味: 関数宣言。

| 項目 | 値 |
|---|---|
| 名前 | `FUNCTION-DECLARE` (規格ドキュメント BIND `FUNCTION-DECLARE`) |
| TAG ID | `0x0E1L` |
| Codec ID | `0x00000E10` |
| 規格ドキュメント | `0x00000000/codecs/0x00000E10/` (DECLARE 対象 `0E10`) |
| セクション | 7 `0111` (Edge 実行), セクション内オフセット C = 1 |
| Kind | Edge · 系列: 実行, まとまり: 宣言 |
| TAG WORD | `0000 1110 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引説明 | 関数宣言。シンボル、パラメータシンボル一覧、戻り値の型、本体(BLOCK) |
| Hugo 側 | `edge/_index.md` |

## 構成要素 {#구성요소}

シンボル、パラメータシンボル一覧、戻り値の型、本体(BLOCK)。

- 構成要素はこのドキュメントの LOCAL ID(REF)で指す。REF `0` は「なし」である。式の位置には式 Edge またはシンボルを置く([Edge](_index.md#실행-edge))。
- 演算子コード、型表現、Payload レイアウトはまだ定めていない([Edge](_index.md#실행-edge) 未解決の問題)。

## Codec ドキュメント {#코덱-문서}

レイアウトはまだ定めていない。Codec ドキュメントは DECLARE(対象 `0E10`)だけを置く。FIELD はレイアウトが決まってから置く。

## 関連ページ {#관련-페이지}

- [Edge — 実行 Edge](_index.md#실행-edge), [TYPE-DECLARE](0x0E2L-type-declare.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00000E10/latest.geul` を `geul show` で読んだ姿である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000E1000000000
BODY
#1 DECLARE 0x0E10
#2 BIND #1 "FUNCTION-DECLARE"
```
