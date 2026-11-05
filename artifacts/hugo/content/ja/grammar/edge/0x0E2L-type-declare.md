---
title: "TYPE-DECLARE (0x0E2L)"
weight: 226
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "TYPE-DECLARE は、実行 Edge の宣言のまとまりの Codec である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TYPE-DECLARE は、実行 Edge の宣言のまとまりの Codec である。意味: 型宣言。

| 項目 | 値 |
|---|---|
| 名前 | `TYPE-DECLARE` (規格ドキュメント BIND `TYPE-DECLARE`) |
| TAG ID | `0x0E2L` |
| Codec ID | `0x00000E20` |
| 規格ドキュメント | `0x00000000/codecs/0x00000E20/` (DECLARE 対象 `0E20`) |
| セクション | 7 `0111` (Edge 実行), セクション内オフセット C = 2 |
| Kind | Edge · 系列: 実行, まとまり: 宣言 |
| TAG WORD | `0000 1110 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引説明 | 型宣言。シンボルと構成(フィールドシンボル一覧、列挙値、別名の対象) |
| Hugo 側 | `edge/_index.md` |

## 構成要素 {#구성요소}

シンボルと構成(フィールドシンボル一覧、列挙値、別名の対象)。

- 構成要素はこのドキュメントの LOCAL ID(REF)で指す。REF `0` は「なし」である。式の位置には式 Edge またはシンボルを置く([Edge](_index.md#실행-edge))。
- 演算子コード、型表現、Payload レイアウトはまだ定めていない([Edge](_index.md#실행-edge) 未解決の問題)。

## Codec ドキュメント {#코덱-문서}

レイアウトはまだ定めていない。Codec ドキュメントは DECLARE(対象 `0E20`)だけを置く。FIELD はレイアウトが決まってから置く。

## 関連ページ {#관련-페이지}

- [Edge — 実行 Edge](_index.md#실행-edge), [FUNCTION-DECLARE](0x0E1L-function-declare.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00000E20/latest.geul` を `geul show` で読んだ姿である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000E2000000000
BODY
#1 DECLARE 0x0E20
#2 BIND #1 "TYPE-DECLARE"
```
