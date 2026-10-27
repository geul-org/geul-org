---
title: "ALIAS"
weight: 6
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "ALIAS は Subject 対象の別名一つを結びつける記述 Edge だ(Codec 0x05)。レイアウトは LABEL と同じ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ALIAS は、Subject 対象の別名一つを Object として結びつける記述 Edge だ。Codec `0x05`。

[LABEL](/ja/grammar/edge/label/) はその言語の代表名(言語ごとに多くて一つ)で、ALIAS は同じ対象の別の名前だ(言語ごとに複数、Wikidata の "also known as")。主に検索に使う。レイアウトと有効性は LABEL と同じだ。

## レイアウト

```
TAG WORD          0001 0LLL L000 0101
[Length 拡張 TAG]
Edge Id           LOCAL Reference レコード
Subject           Reference レコード 1個
Object            UTF8-LANGUAGE-TEXT Value または LOCAL Reference レコード 1個
```

## 解釈と有効性

- Subject と Object の規則は [LABEL](/ja/grammar/edge/label/) と同じだ(Object は [UTF8-LANGUAGE-TEXT](/ja/grammar/value/text/utf8-language-text/) またはそれに解決される LOCAL)。
- 同じ Subject・言語に ALIAS を複数置ける。順序はドキュメント内の順序だ。
- 同じ Subject・言語の LABEL と同じテキストを ALIAS に置かない(代表名は LABEL 一つで足りる)。この規則は推奨だ。
- geul.org 規格ドキュメントは Object を [CODEC](/ja/grammar/edge/codec/) で制限する(`084A`・`084B`・`0008`、LABEL と同じ)。

## 例 (非規範)

Edge Id `0003`、Subject Q42(`00A0 002a`)、Object `DNA`(en): 言語 `08C6 656e`(BCP47 `en`)+ テキスト 3 byte(奇数)→ `UTF8-LANGUAGE-TEXT-ODD`(`0x4B`)、`0A4B 08C6 656e 444e 4100`。

- TAG 1 + Edge Id 2 + Subject 2 + Object 5 = 10 WORD、`LLLL=1001`。TAG は `1485` だ。

```
1485 0088 0003 00A0 002a 0A4B 08C6 656e 444e 4100
```

## 関連ページ

- [Edge](/ja/grammar/edge/)、[LABEL](/ja/grammar/edge/label/)、[DESCRIPTION](/ja/grammar/edge/description/)、[UTF8-LANGUAGE-TEXT](/ja/grammar/value/text/utf8-language-text/)
