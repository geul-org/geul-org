---
title: "RAISE (0x0F8L)"
weight: 248
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "RAISE は、実行 Edge のエラーのまとまりの Codec である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

RAISE は、実行 Edge のエラーのまとまりの Codec である。意味: エラー発生。

| 項目 | 値 |
|---|---|
| 名前 | `RAISE` (規格ドキュメント BIND `RAISE`) |
| TAG ID | `0x0F8L` |
| Codec ID | `0x00000F80` |
| 規格ドキュメント | `0x00000000/codecs/0x00000F80/` (DECLARE 対象 `0F80`) |
| セクション | 7 `0111` (Edge 実行), セクション内オフセット C = 24 |
| Kind | Edge · 系列: 実行, まとまり: エラー |
| TAG WORD | `0000 1111 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引説明 | エラー発生。エラー値 |
| Hugo 側 | `edge/_index.md` |

## 構成要素 {#구성요소}

エラー値。

- 構成要素はこのドキュメントの LOCAL ID(REF)で指す。REF `0` は「なし」である。式の位置には式 Edge またはシンボルを置く([Edge](_index.md#실행-edge))。
- 演算子コード、型表現、Payload レイアウトはまだ定めていない([Edge](_index.md#실행-edge) 未解決の問題)。

## Codec ドキュメント {#코덱-문서}

レイアウトはまだ定めていない。Codec ドキュメントは DECLARE(対象 `0F80`)だけを置く。FIELD はレイアウトが決まってから置く。

## 関連ページ {#관련-페이지}

- [Edge — 実行 Edge](_index.md#실행-edge), [TRY](0x0F9L-try.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00000F80/latest.geul` を `geul show` で読んだ姿である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000F8000000000
BODY
#1 DECLARE 0x0F80
#2 BIND #1 "RAISE"
```
