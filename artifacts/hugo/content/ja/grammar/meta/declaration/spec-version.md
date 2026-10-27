---
title: "SPEC-VERSION"
weight: 17
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "SPEC-VERSION は、ドキュメントが従う GEUL 仕様の版を整数一つで宣言する定義 Meta だ。GEUL v1 は 0x0001 だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ドキュメントが従う GEUL 仕様の版を宣言する。残りのレコードをどう読むかは、この値が決める。

## レイアウト

```
TAG WORD          0001 1LLL L001 0000      Codec 0x10
[Length 拡張 TAG]
Payload           仕様の版。v1 = 0x0001
```

- Codec: Meta `0x10`、定義クラス(`001`)
- Payload: 生値(最短幅の unsigned 整数)
- 個数: 多くて一つ

## 解釈と有効性

- Value コードに依拠しない。どの版のデコーダでも読めるよう、組み込み Value なしで整数だけを置く。
- 知らない版なら、デコーダは拒否または警告する。
- なければ、デコーダが知っている版で読む。公表ドキュメントは書く。

## 例

- `0x1890 0x0001`: GEUL v1

## 未解決の問題

- コードブックドキュメントのバージョンとの対応([規格ドキュメント](/ja/grammar/codec-spec/))。
