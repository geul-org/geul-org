---
title: "DESCRIPTION"
weight: 7
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DESCRIPTION は Subject 対象の言語別の短い説明一つを結びつける記述 Edge だ(Codec 0x06)。レイアウトは LABEL と同じ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIPTION は、Subject 対象の特定言語の説明一つを Object として結びつける記述 Edge だ。Codec `0x06`。

説明は、対象を区別する短い文句だ(Wikidata の description、例: 「ドイツの首都で最大の都市」)。対象の定義や主張ではない。対象についての命題は [TRIPLE](/ja/grammar/edge/triple/) で書く。レイアウトは [LABEL](/ja/grammar/edge/label/) と同じだ。説明とその言語は Object 一つ、[UTF8-LANGUAGE-TEXT](/ja/grammar/value/text/utf8-language-text/) に収められる。生値フィールドはない。

## レイアウト

```
TAG WORD          0001 0LLL L000 0110
[Length 拡張 TAG]
Edge Id           LOCAL Reference レコード
Subject           Reference レコード 1個
Object            UTF8-LANGUAGE-TEXT Value または LOCAL Reference レコード 1個
```

## 解釈と有効性

- Subject と Object の規則は [LABEL](/ja/grammar/edge/label/) と同じだ。Subject は、ちょうど一つの完全な Reference レコードだ。Object は、ちょうど一つの完全な UTF8-LANGUAGE-TEXT(`0x4A`・`0x4B`)レコードか、同じドキュメントの [REFERENCE-NODE](/ja/grammar/edge/reference-node/) バインディングで UTF8-LANGUAGE-TEXT に解決される LOCAL Reference だ。
- 言語のないテキスト(UTF8-TEXT)は DESCRIPTION になれない。説明は言語ごとに一つなので、言語があってこそその規則が成り立つ。複数の言語に共通の説明は、言語 `mul` で書く。
- 同じ Subject・言語の DESCRIPTION は多くて一つだ。
- 説明は、同じ名前の別の対象と区別するために使う。同じ言語で LABEL と DESCRIPTION の組が二つの対象で重ならないのが望ましいが、規格はこれを検査しない(Wikidata も推奨にすぎず強制しない)。
- geul.org 規格ドキュメントは Object を [CODEC](/ja/grammar/edge/codec/) で制限する(`084A`・`084B`・`0008`、LABEL と同じ)。

## 長さ

```
全体 = 1 + N_len + N_id + N_subject + N_object WORD
```

- Object の言語レコードとテキストのバイト数は Object レコードが担う。最後のレコードを読み終えたカーソルは、Edge の終わりとちょうど合わなければならない。
- 説明はラベルより長く、Object も Edge も 15 WORD を超えやすい。そのときは Length 拡張を使う([レコード](/ja/grammar/record/))。

## 例 (非規範)

Edge Id `0009`、Subject Q64(`00A0 0040`)、Object `capital and largest city of Germany`(en)。言語はレジストリ前なので LANGUAGE-BCP47-CODE だ。

- Object は言語 `08C6 656E`(BCP47 `en`、2 WORD)+ テキスト 35 byte(奇数、18 WORD)なので `0x4B`、TAG 1 + 拡張 TAG 1 + 20 = 22 WORD、`0F4B 0016 …` だ。
- Edge は TAG 1 + 拡張 TAG 1 + Edge Id 2 + Subject 2 + Object 22 = 28 WORD なので `LLLL=1110`、TAG `1706`、拡張 TAG `001C` だ。

```
1706 001C 0088 0009 00A0 0040
0F4B 0016 08C6 656E 6361 7069 7461 6C20 616E 6420 6C61 7267 6573 7420 6369 7479 206F 6620 4765 726D 616E 7900
```

## Wikidata との対応

- 項目の `descriptions`(言語ごとに一つ)→ 言語ごとに DESCRIPTION 一つ。言語コードは LABEL と同じ言語コード対応表で移す。

## 未解決の問題

- 言語のない UTF8-TEXT の説明を許す事例があるか(今は許さない)。

## 関連ページ

- [Edge](/ja/grammar/edge/)、[LABEL](/ja/grammar/edge/label/)、[ALIAS](/ja/grammar/edge/alias/)、[CODEC](/ja/grammar/edge/codec/)
- [UTF8-LANGUAGE-TEXT](/ja/grammar/value/text/utf8-language-text/)、[LOCAL](/ja/grammar/reference/local/)、[REFERENCE-NODE](/ja/grammar/edge/reference-node/)
