---
title: "CONFIDENCE"
weight: 68
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "CONFIDENCE は、ドキュメント全体の信頼度を 0 以上 1 以下の小数 Value で書く検証 Meta だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ドキュメント全体の信頼度を書く。レコード単位の信頼度は、対象 Edge に付く QUALIFIER で書く(プロパティは未定、[SOURCE](/ja/grammar/edge/source/#他の根拠の表現))。

## レイアウト

```
TAG WORD          0001 1LLL L100 0011      Codec 0x43
[Length 拡張 TAG]
Payload           UNSIGNED-DECIMAL Value、0 以上 1 以下
```

- Codec: Meta `0x43`、検証クラス(`100`)
- Payload: 組み込み Value([UNSIGNED-DECIMAL](/ja/grammar/value/decimal/unsigned-decimal/))
- 個数: 多くて一つ

## 解釈と有効性

- 誰が付けた値かは、[GENERATED-BY](/ja/grammar/meta/lineage/generated-by/) などで併せて書く。

## 未解決の問題

- 尺度(0~1)と TOULMIN 判定との関係。
