---
title: "VERDICT"
weight: 69
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "VERDICT は、ドキュメント全体の判定結果(Pass、Review、Fail)を 1 WORD で書く検証 Meta だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ドキュメント全体の判定結果を書く。ノード・レコード単位の判定は [TOULMIN](/ja/grammar/edge/toulmin/) `VERDICT`(Edge `0x78`)が担う。

## レイアウト

```
TAG WORD          0001 1LLL L100 0100      Codec 0x44
[Length 拡張 TAG]
判定              1 WORD (0 Pass, 1 Review, 2 Fail)
```

- Codec: Meta `0x44`、検証クラス(`100`)
- Payload: 生値(判定 1 WORD)
- 個数: 多くて一つ

## 解釈と有効性

- 検証クラスなので、コンテンツハッシュから除かれる。
- 他のドキュメントに対する判定は、判定対象とは別のドキュメントの BODY に置く。

## 未解決の問題

- 判定の主体と根拠も併せて書くか。
