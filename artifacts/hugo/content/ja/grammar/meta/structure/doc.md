---
title: "DOC"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "DOC-1WORD・DOC-2WORD・DOC-4WORD は、ドキュメント全体の WORD 数を指定してドキュメントを開く構造 Meta だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ドキュメントを開くレコードだ。ドキュメント全体の WORD 数を Payload で指定する。`DOC-1WORD`(`0x00`)、`DOC-2WORD`(`0x01`)、`DOC-4WORD`(`0x02`)をこのページでまとめて扱う。

## レイアウト

```
TAG WORD          0001 1LLL L000 0000      Codec 0x00
[Length 拡張 TAG]
Payload           全体の WORD 数。Codec が幅を決める: DOC-1WORD 1、DOC-2WORD 2、DOC-4WORD 4
```

- Codec: Meta `0x00`~`0x02`、構造クラス(`000`)
- Payload: 生値(ドキュメント全体の WORD 数、unsigned)
- 個数: ドキュメントごとに一つ、先頭

## 解釈と有効性

- 長さは、開くレコードの先頭から [END](/ja/grammar/meta/structure/end/) の末尾までだ。
- 値が収まる最も狭い幅を使う。広い幅でエンコードすれば、非正規エンコードとして拒否する。
- 長さが入力全体と同じでなければならない。ドキュメント一つが入力一つだ。
- デコーダは、この長さでドキュメント全体を読み飛ばせる。長さを知らないまま開く Codec はない。
- コンテンツハッシュを計算するときは、検証クラスの Meta を除いた長さと、それに合う幅で書き直す([コンテンツハッシュ](/ja/grammar/document/#コンテンツハッシュ))。

## 例

- `0x1880 0x0017`: DOC-1WORD、全体 23 WORD
