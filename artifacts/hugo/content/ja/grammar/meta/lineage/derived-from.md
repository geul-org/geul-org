---
title: "DERIVED-FROM"
weight: 50
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "DERIVED-FROM は、このドキュメントが派生した他の系譜のドキュメント・資料を書く系譜 Meta だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

このドキュメントが、他の系譜のドキュメント・資料から派生したことを書く。

## レイアウト

```
TAG WORD          0001 1LLL L011 0001      Codec 0x31
[Length 拡張 TAG]
Payload           Reference、または SHA-256-DIGEST(コンテンツハッシュ)、または URI Value
```

- Codec: Meta `0x31`、系譜クラス(`011`)
- Payload: 組み込み Reference または Value
- 個数: 複数可

## 解釈と有効性

- GEUL ドキュメントから派生したなら、そのコンテンツハッシュ([SHA-256-DIGEST](/ja/grammar/value/binary/sha-256-digest/))を、外部資料なら [URI](/ja/grammar/value/text/uri/) を置く。外部資料の版をハッシュで固定するには、HEAD の [SOURCE](/ja/grammar/edge/source/#ドキュメント全体の出典)に原文ハッシュ QUALIFIER(P4092)を付ける。
- レコード単位の原典は根拠 Edge [SOURCE](/ja/grammar/edge/source/) が、移動・分割・統合前の旧レコードは対象 Edge の QUALIFIER P1365(値は旧 Edge Id)が担う。
