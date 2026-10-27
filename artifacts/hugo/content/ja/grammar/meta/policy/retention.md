---
title: "RETENTION"
weight: 84
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "RETENTION は、ドキュメントの保存期限を満了時刻または期間 Value で書くポリシー Meta だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ドキュメントの保存期限を書く。

## レイアウト

```
TAG WORD          0001 1LLL L101 0011      Codec 0x53
[Length 拡張 TAG]
Payload           満了時刻(GREGORIAN-DATE など)または期間(DURATION-SECONDS)
```

- Codec: Meta `0x53`、ポリシークラス(`101`)
- Payload: 組み込み Value(TIME 系列: [GREGORIAN-DATE](/ja/grammar/value/time/gregorian-date/) など、または [DURATION-SECONDS](/ja/grammar/value/time/duration-seconds/))
- 個数: 多くて一つ

## 解釈と有効性

- 期間なら [RECORDED-AT](/ja/grammar/meta/provenance/recorded-at/) から数える。
