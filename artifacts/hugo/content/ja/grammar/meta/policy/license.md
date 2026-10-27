---
title: "LICENSE"
weight: 81
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "LICENSE は、このドキュメントとバイト列内の著作物のライセンスを書くポリシー Meta だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

このドキュメントとバイト列内の著作物のライセンスを書く。

## レイアウト

```
TAG WORD          0001 1LLL L101 0000      Codec 0x50
[Length 拡張 TAG]
Payload           ライセンスを指す Reference、または SPDX 識別子 UTF8-TEXT、または URI Value
```

- Codec: Meta `0x50`、ポリシークラス(`101`)
- Payload: 組み込み Reference または Value([UTF8-TEXT](/ja/grammar/value/text/utf8-text/)、[URI](/ja/grammar/value/text/uri/))
- 個数: 多くて一つ

## 解釈と有効性

- geul.org の公表ドキュメントは CC0 だ。非公開の公表は Issuer が定める([Issuer](/ja/grammar/issuer/))。
- 原典の著作物の元のライセンスを記録する。

## 未解決の問題

- SPDX 識別子をテキストで置くか、GEUL エンティティの Reference で置くか。
