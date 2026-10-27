---
title: "SIGNED-OFF"
weight: 67
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "SIGNED-OFF は、寄与の権利の確認を Reference で書く検証 Meta だ(git Signed-off-by、DCO)。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

寄与の権利の確認だ(git `Signed-off-by`、DCO)。

## レイアウト

```
TAG WORD          0001 1LLL L100 0010      Codec 0x42
[Length 拡張 TAG]
Payload           Reference 一つ
```

- Codec: Meta `0x42`、検証クラス(`100`)
- Payload: 組み込み Reference
- 個数: 複数可

## 解釈と有効性

- geul.org の公表ドキュメントには、自然人を指す Reference を置かない([Issuer と公表](/ja/grammar/issuer/#geulorg-公表))。組織・Issuer を指す。例外として [WIKIDATA-QID](/ja/grammar/reference/wikidata-qid/) で自然人を指すことは許容する。
