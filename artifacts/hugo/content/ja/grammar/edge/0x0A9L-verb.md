---
title: "VERB (0x0A9L)"
weight: 169
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "VERB は動詞の叙述 Edge である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

VERB は動詞の叙述 Edge である。短縮形は [VERB-SHORT](0x0A8L-verb-short.md)(`0x0A8L`)である([Edge](_index.md#서술-edge))。

| 項目 | 値 |
|---|---|
| 名前 | `VERB` (規格ドキュメント BIND `VERB`) |
| TAG ID | `0x0A9L` |
| Codec ID | `0x00000A90` |
| 規格ドキュメント | `0x00000000/codecs/0x00000A90/` (DECLARE 対象 `0A90`) |
| セクション | 5 `0101` (Edge 叙述)、セクション内オフセット C = 9 |
| Kind | Edge · 系列: 叙述、まとまり: 命題 |
| TAG WORD | `0000 1010 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | 動詞の叙述 |
| Hugo 側 | `edge/_index.md` |

## レイアウト {#레이아웃}

レイアウトはまだ定めていない。Edge 共通のレイアウト(TAG、[Length 拡張 TAG]、Edge Id、構成要素)に従う([Edge](_index.md#레이아웃))。

## Codec ドキュメント {#코덱-문서}

レイアウトをまだ定めていない。Codec ドキュメントは DECLARE(対象 `0A90`)のみを置く。FIELD はレイアウトが定まったら置く。

## 関連ページ {#관련-페이지}

- [VERB-SHORT](0x0A8L-verb-short.md), [Edge](_index.md), [TRIPLE](0x0AAL-triple.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00000A90/latest.geul` を `geul show` で読んだ姿である(16進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A9000000000
BODY
#1 DECLARE 0x0A90
#2 BIND #1 "VERB"
```
