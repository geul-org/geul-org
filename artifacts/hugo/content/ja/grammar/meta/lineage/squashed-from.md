---
title: "SQUASHED-FROM"
weight: 56
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "SQUASHED-FROM は、一つにまとめた元のバージョン群のコンテンツハッシュを書く系譜 Meta だ(git squash)。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

一つにまとめた元のバージョン群のコンテンツハッシュを書く(git squash)。

## レイアウト

```
TAG WORD          0001 1LLL L011 0111      Codec 0x37
[Length 拡張 TAG]
Payload           SHA-256-DIGEST Value 一つ (16 WORD)
```

- Codec: Meta `0x37`、系譜クラス(`011`)
- Payload: 組み込み Value([SHA-256-DIGEST](/ja/grammar/value/binary/sha-256-digest/))
- 個数: 複数可(元のバージョンごとに一つ)

## 解釈と有効性

- ダイジェスト形式を Value として組み込み、ハッシュアルゴリズムを変える余地を残す。今のコンテンツハッシュは SHA-256 だけだ。
