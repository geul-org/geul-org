---
title: "ACCESS"
weight: 82
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "ACCESS は、ドキュメントの公開範囲(公開、内部、社外秘)を 1 WORD の等級で書くポリシー Meta だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ドキュメントの公開範囲を書く。

## レイアウト

```
TAG WORD          0001 1LLL L101 0001      Codec 0x51
[Length 拡張 TAG]
等級              1 WORD (0 公開, 1 内部, 2 社外秘, それ以外は予約)
```

- Codec: Meta `0x51`、ポリシークラス(`101`)
- Payload: 生値(等級 1 WORD)
- 個数: 多くて一つ

## 解釈と有効性

- 社外秘ドキュメントは公表しない([Issuer](/ja/grammar/issuer/))。
- 解釈を変えない。取り扱いだけを定める。

## 未解決の問題

- 等級のコード表。
