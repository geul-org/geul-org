---
title: "CONSENT"
weight: 85
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "CONSENT は、同意の範囲と根拠を Reference またはテキストで書くポリシー Meta だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

同意の範囲と根拠を書く。

## レイアウト

```
TAG WORD          0001 1LLL L101 0100      Codec 0x54
[Length 拡張 TAG]
Payload           同意の根拠を指す Reference またはテキスト
```

- Codec: Meta `0x54`、ポリシークラス(`101`)
- Payload: 組み込み Reference または Value
- 個数: 複数可

## 未解決の問題

- 範囲の表現(目的・期間・第三者提供)の構造。
