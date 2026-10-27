---
title: "MESSAGE"
weight: 57
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "MESSAGE は、変更の理由を言語付きテキストで書く系譜 Meta だ(git commit message)。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

変更の理由を書く(git commit message)。

## レイアウト

```
TAG WORD          0001 1LLL L011 1000      Codec 0x38
[Length 拡張 TAG]
メッセージ        UTF8-LANGUAGE-TEXT Value 1個
```

- Codec: Meta `0x38`、系譜クラス(`011`)
- Payload: 組み込み Value([UTF8-LANGUAGE-TEXT](/ja/grammar/value/text/utf8-language-text/))
- 個数: 言語ごとに多くて一つ

## 解釈と有効性

- メッセージと言語は、UTF8-LANGUAGE-TEXT 一つに収める。同じ言語の MESSAGE は一つだ。
- geul.org 規格ドキュメントは [CODEC](/ja/grammar/edge/codec/) `084A`・`084B` で書く。
