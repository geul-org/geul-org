---
title: "Meta — 検証"
weight: 50
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "Meta 検証クラス(上位3ビット `100`、`0x40`~`0x4F`)は、ドキュメントを信頼できるか判断する材料(公開鍵、署名、信頼度、判定)を書く。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Meta 検証クラス(上位3ビット `100`、Codec `0x40`~`0x4F`)は、ドキュメントを信頼できるかを判断する材料を書く。自己発行 Issuer の公開鍵、署名、寄与の権利の確認、信頼度、ドキュメント全体の判定結果だ。

- 検証クラスはコンテンツハッシュの計算から除かれる。そのため署名をドキュメント内に置いても、署名を複数加えても、コンテンツハッシュは変わらない(git `gpgsig` と同じ方式)。
- クラスは Codec の上位3ビットで分かるので、コードブックなしでハッシュを計算できる。
- ノード・レコード単位の判定は、[TOULMIN](/ja/grammar/edge/toulmin/) Edge `VERDICT`(`0x78`)が担う。
