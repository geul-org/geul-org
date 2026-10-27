---
title: "ENUM"
weight: 30
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "ENUM は生値フィールドのコード値一つに意味を付ける記述 Edge だ(Codec 0x1D)。名前は BIND で結びつける。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ENUM は、生値フィールドのコード値一つに意味を付ける記述 Edge だ。Codec `0x1D`。

[FIELD](/ja/grammar/edge/field/) とともに Codec 規格を書く語彙だ。レイアウトはデコーダに内蔵する([Codec 規格ドキュメント](/ja/grammar/codec-spec/))。

## レイアウト

```
TAG WORD          0001 0LLL L001 1101
[Length 拡張 TAG]
Edge Id           LOCAL Reference レコード
フィールド        FIELD Edge を指す LOCAL Reference レコード
コード値          生値。その FIELD の幅と同じ WORD 数
```

## 解釈と有効性

- フィールドは生値 FIELD(幅 `n ≥ 1`)でなければならない。レコードフィールドには ENUM を付けない。レコードの意味は、そのレコードの Codec が語る。
- コード値は、ちょうどその FIELD の幅だけある。ENUM レコードの Length で境界を確認する。
- 一つのフィールドで同じコード値を二度宣言しない。
- コード値の名前は、ENUM の Edge Id に [BIND](/ja/grammar/edge/bind/) で結びつける。DECLARE・FIELD・ENUM・CODEC に付ける UTF8-TEXT はすべて BIND で行い、LABEL など他の Edge では付けない。
- 宣言されていないコード値はエラーではない。ビューアは生値のまま表示する。許容値を閉じるかは Codec 規格の領分で、今の語彙には閉じる標識がない。

## 長さ

```
全体 = 1 + N_len + N_id + N_field + n WORD
```

## 例 (非規範)

TOMBSTONE 規格ドキュメントの事由カテゴリのフィールド(FIELD #4、生値 1 WORD)に、コード `0x0001` を宣言する。Edge Id 10。名前は BIND で別に結びつける。事由カテゴリのコード表はまだ決まっていないので、コード値は例だ。

- TAG 1 + Edge Id 2 + フィールド 2 + コード値 1 = 6 WORD、`LLLL = 0101`。

```
129D 0088 000A 0088 0004 0001
```

TRIPLE 規格ドキュメントは、Rank フィールド(FIELD #5)に ENUM 三つ(`0`・`1`・`2`)を置き、それぞれ `normal`・`preferred`・`deprecated` に BIND する([TRIPLE](/ja/grammar/edge/triple/))。

## 関連ページ

- [DECLARE](/ja/grammar/edge/declare/)、[FIELD](/ja/grammar/edge/field/)、[CODEC](/ja/grammar/edge/codec/)、[BIND](/ja/grammar/edge/bind/)
- [Codec 規格ドキュメント](/ja/grammar/codec-spec/)
