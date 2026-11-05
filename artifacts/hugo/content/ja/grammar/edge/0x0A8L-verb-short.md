---
title: "VERB-SHORT (0x0A8L)"
weight: 168
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "VERB-SHORT は、動詞の叙述 Edge VERB の短縮形である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

VERB-SHORT は、動詞の叙述 Edge [VERB](0x0A9L-verb.md) の短縮形である。`-SHORT` と一般形は偶数・奇数のペアに置く([Edge](_index.md#서술-edge))。

| 項目 | 値 |
|---|---|
| 名前 | `VERB-SHORT` (規格ドキュメント BIND `VERB-SHORT`) |
| TAG ID | `0x0A8L` |
| Codec ID | `0x00000A80` |
| 規格ドキュメント | `0x00000000/codecs/0x00000A80/` (DECLARE 対象 `0A80`) |
| セクション | 5 `0101` (Edge 叙述)、セクション内オフセット C = 8 |
| Kind | Edge · 系列: 叙述、まとまり: 命題 |
| TAG WORD | `0000 1010 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | 動詞の叙述の短縮 |
| Hugo 側 | `edge/_index.md` |

## レイアウト {#레이아웃}

レイアウトはまだ定めていない。Edge 共通のレイアウト(TAG、[Length 拡張 TAG]、Edge Id、構成要素)に従う([Edge](_index.md#레이아웃))。

## Codec ドキュメント {#코덱-문서}

レイアウトをまだ定めていない。Codec ドキュメントは DECLARE(対象 `0A80`)のみを置く。FIELD はレイアウトが定まったら置く。

## 関連ページ {#관련-페이지}

- [VERB](0x0A9L-verb.md), [Edge](_index.md), [TRIPLE](0x0AAL-triple.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00000A80/latest.geul` を `geul show` で読んだ姿である(16進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A8000000000
BODY
#1 DECLARE 0x0A80
#2 BIND #1 "VERB-SHORT"
```
