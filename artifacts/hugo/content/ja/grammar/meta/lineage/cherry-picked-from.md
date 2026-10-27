---
title: "CHERRY-PICKED-FROM"
weight: 53
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "CHERRY-PICKED-FROM は、他の系譜から変更を取り込んだ元のバージョンのコンテンツハッシュを書く系譜 Meta だ(git cherry-pick -x)。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

他の系譜の変更を取り込んだ元のバージョンのコンテンツハッシュを書く(git cherry-pick `-x`)。

## レイアウト

```
TAG WORD          0001 1LLL L011 0100      Codec 0x34
[Length 拡張 TAG]
Payload           SHA-256-DIGEST Value 一つ (16 WORD)
```

- Codec: Meta `0x34`、系譜クラス(`011`)
- Payload: 組み込み Value([SHA-256-DIGEST](/ja/grammar/value/binary/sha-256-digest/))
- 個数: 複数可

## 解釈と有効性

- ダイジェスト形式を Value として組み込み、ハッシュアルゴリズムを変える余地を残す。今のコンテンツハッシュは SHA-256 だけだ。
