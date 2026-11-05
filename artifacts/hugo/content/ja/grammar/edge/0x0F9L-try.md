---
title: "TRY (0x0F9L)"
weight: 249
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "TRY は、実行 Edge のエラーのまとまりの Codec である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TRY は、実行 Edge のエラーのまとまりの Codec である。意味: エラー処理。

| 項目 | 値 |
|---|---|
| 名前 | `TRY` (規格ドキュメント BIND `TRY`) |
| TAG ID | `0x0F9L` |
| Codec ID | `0x00000F90` |
| 規格ドキュメント | `0x00000000/codecs/0x00000F90/` (DECLARE 対象 `0F90`) |
| セクション | 7 `0111` (Edge 実行), セクション内オフセット C = 25 |
| Kind | Edge · 系列: 実行, まとまり: エラー |
| TAG WORD | `0000 1111 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引説明 | エラー処理。本体 BLOCK、エラーシンボル、処理 BLOCK、終了処理 BLOCK(なければ 0) |
| Hugo 側 | `edge/_index.md` |

## 構成要素 {#구성요소}

本体 BLOCK、エラーシンボル、処理 BLOCK、終了処理 BLOCK(なければ 0)。

- 構成要素はこのドキュメントの LOCAL ID(REF)で指す。REF `0` は「なし」である。式の位置には式 Edge またはシンボルを置く([Edge](_index.md#실행-edge))。
- 演算子コード、型表現、Payload レイアウトはまだ定めていない([Edge](_index.md#실행-edge) 未解決の問題)。

## Codec ドキュメント {#코덱-문서}

レイアウトはまだ定めていない。Codec ドキュメントは DECLARE(対象 `0F90`)だけを置く。FIELD はレイアウトが決まってから置く。

## 関連ページ {#관련-페이지}

- [Edge — 実行 Edge](_index.md#실행-edge), [RAISE](0x0F8L-raise.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00000F90/latest.geul` を `geul show` で読んだ姿である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000F9000000000
BODY
#1 DECLARE 0x0F90
#2 BIND #1 "TRY"
```
