---
title: "UNARY (0x0E9L)"
weight: 233
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "UNARY は、実行 Edge の式のまとまりの Codec である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UNARY は、実行 Edge の式のまとまりの Codec である。意味: 単項式。

| 項目 | 値 |
|---|---|
| 名前 | `UNARY` (規格ドキュメント BIND `UNARY`) |
| TAG ID | `0x0E9L` |
| Codec ID | `0x00000E90` |
| 規格ドキュメント | `0x00000000/codecs/0x00000E90/` (DECLARE 対象 `0E90`) |
| セクション | 7 `0111` (Edge 実行), セクション内オフセット C = 9 |
| Kind | Edge · 系列: 実行, まとまり: 式 |
| TAG WORD | `0000 1110 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引説明 | 単項式。演算子 1 WORD、オペランド |
| Hugo 側 | `edge/_index.md` |

## 構成要素 {#구성요소}

演算子 1 WORD、オペランド。

- 構成要素はこのドキュメントの LOCAL ID(REF)で指す。REF `0` は「なし」である。式の位置には式 Edge またはシンボルを置く([Edge](_index.md#실행-edge))。
- 演算子コード、型表現、Payload レイアウトはまだ定めていない([Edge](_index.md#실행-edge) 未解決の問題)。

## Codec ドキュメント {#코덱-문서}

レイアウトはまだ定めていない。Codec ドキュメントは DECLARE(対象 `0E90`)だけを置く。FIELD はレイアウトが決まってから置く。

## 関連ページ {#관련-페이지}

- [Edge — 実行 Edge](_index.md#실행-edge), [CONST](0x0E8L-const.md), [BINARY](0x0EAL-binary.md), [CALL](0x0EBL-call.md), [MEMBER](0x0ECL-member.md), [INDEX](0x0EDL-index.md), [CONSTRUCT](0x0EEL-construct.md), [CONDITIONAL](0x0EFL-conditional.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00000E90/latest.geul` を `geul show` で読んだ姿である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000E9000000000
BODY
#1 DECLARE 0x0E90
#2 BIND #1 "UNARY"
```
