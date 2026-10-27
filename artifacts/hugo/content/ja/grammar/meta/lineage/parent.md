---
title: "PARENT"
weight: 49
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "PARENT は、直前バージョンのコンテンツハッシュを書く系譜 Meta だ(git parent)。複数ならマージだ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

直前バージョンのコンテンツハッシュを書く(git parent)。

## レイアウト

```
TAG WORD          0001 1LLL L011 0000      Codec 0x30
[Length 拡張 TAG]
Payload           SHA-256-DIGEST Value 一つ (16 WORD)
```

- Codec: Meta `0x30`、系譜クラス(`011`)
- Payload: 組み込み Value([SHA-256-DIGEST](/ja/grammar/value/binary/sha-256-digest/))
- 個数: 複数可(マージ)

## 解釈と有効性

- なければ最初のバージョンで、複数ならマージだ(git merge commit)。
- [コンテンツハッシュ](/ja/grammar/document/#コンテンツハッシュ)に入るので、履歴全体がハッシュチェーンになる。
- バージョン一覧ドキュメントは、直前の一覧ドキュメントを指す([PUBLICATION](/ja/grammar/edge/publication/))。
- ダイジェスト形式を Value として組み込み、ハッシュアルゴリズムを変える余地を残す。今のコンテンツハッシュは SHA-256 だけだ。

## 例

- `0x1F30 0x0014 0x0F61 0x0012 <16 WORD>` (Meta 20 WORD = TAG + Length 拡張 + 組み込み Value 18 WORD)
