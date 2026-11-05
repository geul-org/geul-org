---
title: "WORLD (0x0B0L)"
weight: 176
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "WORLD は世界観を書く叙述 Edge である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

WORLD は世界観を書く叙述 Edge である。意味: 世界観を表現するための構造。

| 項目 | 値 |
|---|---|
| 名前 | `WORLD` (規格ドキュメント BIND `WORLD`) |
| TAG ID | `0x0B0L` |
| Codec ID | `0x00000B00` |
| 規格ドキュメント | `0x00000000/codecs/0x00000B00/` (DECLARE 対象 `0B00`) |
| セクション | 5 `0101` (Edge 叙述)、セクション内オフセット C = 16 |
| Kind | Edge · 系列: 叙述、まとまり: 構造 |
| TAG WORD | `0000 1011 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | 世界観を表現するための構造 |
| Hugo 側 | `edge/_index.md` |

## レイアウト {#레이아웃}

```
TAG WORD          0000 1011 0000 LLLL      Codec 0x0B0L
[Length 拡張 TAG]
Codec ごとの TAG  1 WORD。下位形式
Edge Id           LOCAL Reference レコード
構成要素          下位形式が定める
```

- 下位形式をもつ Codec である。Codec ごとの TAG 1 WORD が下位形式を指定する([レコードと TAG WORD](../record.md#레코드-레이아웃))。
- 下位形式と構成要素はまだ定めていない。

## Codec ドキュメント {#코덱-문서}

レイアウトをまだ定めていない。Codec ドキュメントは DECLARE(対象 `0B00`)のみを置く。FIELD はレイアウトが定まったら置く。

## 関連ページ {#관련-페이지}

- [TIMELINE](0x0B1L-timeline.md), [SCENE](0x0B2L-scene.md), [Edge](_index.md)
- [DECLARE](0x0BBL-declare.md#열린-문제)(下位形式をもつ Codec の宣言方法)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00000B00/latest.geul` を `geul show` で読んだ姿である(16進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000B0000000000
BODY
#1 DECLARE 0x0B00
#2 BIND #1 "WORLD"
```
