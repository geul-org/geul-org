---
title: "PRIVACY"
weight: 83
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "PRIVACY は、ドキュメントの個人情報の等級を 1 WORD で書くポリシー Meta だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ドキュメントの個人情報の等級を書く。

## レイアウト

```
TAG WORD          0001 1LLL L101 0010      Codec 0x52
[Length 拡張 TAG]
等級              1 WORD
```

- Codec: Meta `0x52`、ポリシークラス(`101`)
- Payload: 生値(等級 1 WORD)
- 個数: 多くて一つ

## 解釈と有効性

- 解釈を変えない。取り扱いだけを定める。

## 未解決の問題

- 等級のコード表(個人情報保護法の分類との対応)。
