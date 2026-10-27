---
title: "USAGE"
weight: 86
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "USAGE は、学習禁止、商用利用禁止のような使用制限を書くポリシー Meta だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

使用制限を書く(例: 学習禁止、商用利用禁止)。

## レイアウト

```
TAG WORD          0001 1LLL L101 0101      Codec 0x55
[Length 拡張 TAG]
Payload           使用制限を表すテキストまたは Reference
```

- Codec: Meta `0x55`、ポリシークラス(`101`)
- Payload: 組み込み Value または Reference
- 個数: 複数可

## 未解決の問題

- 制限の種類のコード表。
