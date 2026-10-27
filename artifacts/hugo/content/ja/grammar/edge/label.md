---
title: "LABEL"
weight: 5
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "LABEL は Subject 対象の言語別の名前一つを UTF8-LANGUAGE-TEXT の Object として結びつける記述 Edge だ(Codec 0x04)。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LABEL は、Subject 対象の特定言語の名前(label)一つを Object として結びつける記述 Edge だ。Codec `0x04`。一般的な語彙学の lemma を表す Edge ではない。

名前とその言語は Object 一つ、[UTF8-LANGUAGE-TEXT](/ja/grammar/value/text/utf8-language-text/) に収められる。生値フィールドはない。

## レイアウト

```
TAG WORD          0001 0LLL L000 0100
[Length 拡張 TAG]
Edge Id           LOCAL Reference レコード
Subject           Reference レコード 1個
Object            UTF8-LANGUAGE-TEXT Value または LOCAL Reference レコード 1個
```

## 解釈と有効性

- Subject は、ちょうど一つの完全な Reference レコードだ。Subject 自体の Length で境界を見つけ、Reference でなかったり不完全であれば invalid だ。
- Object は、ちょうど一つの完全な [UTF8-LANGUAGE-TEXT](/ja/grammar/value/text/utf8-language-text/)(`0x4A`・`0x4B`)レコードだ。言語とテキストの規則(二つの言語形式をどちらも許容、同じ言語の比較)は、その形式に従う。
- Object には LOCAL Reference も来られる。このときは同じドキュメントの [REFERENCE-NODE](/ja/grammar/edge/reference-node/) バインディングで UTF8-LANGUAGE-TEXT に解決されなければならない。解決されないか、別の種類の対象に解決されれば invalid だ。
- geul.org 規格ドキュメントは、この制限を [CODEC](/ja/grammar/edge/codec/) で書く(Object = `084A`・`084B`・`0008`)。LOCAL の解決先は CODEC では表さない。
- Object が上の二つの形式のいずれでもなかったり、レコードが不完全であれば invalid だ。言語のないテキスト(UTF8-TEXT)は LABEL になれない。言語のない機械用の名前は [BIND](/ja/grammar/edge/bind/) で書く。複数の言語に共通の名前は、言語 `mul` で書く。
- 同じ Subject・言語の LABEL は多くて一つだ。別の名前は [ALIAS](/ja/grammar/edge/alias/) で書く。

## 長さ

```
全体 = 1 + N_len + N_id + N_subject + N_object WORD
```

- Object の言語レコードとテキストのバイト数は、Edge ではなく Object レコードが担う。最後のレコードを読み終えたカーソルは、Edge の終わりとちょうど合わなければならない。

## 例 (非規範)

`en` の言語コードは、レジストリがまだ封印されていないので、`0783` は確定コードではなく非規範の値だ。

### LANGUAGE-SHORT-CODE

Edge Id `0007`、Subject Q22686(`00A0 589e`)、Object `Donald Trump`(en)。

- Object は言語 `08C8 0783`(SHORT-CODE 2 WORD)+ テキスト 12 byte(偶数、6 WORD)なので `UTF8-LANGUAGE-TEXT-EVEN`(`0x4A`)、全体 9 WORD `0C4A 08C8 0783 446f 6e61 6c64 2054 7275 6d70` だ。
- Edge は TAG 1 + Edge Id 2 + Subject 2 + Object 9 = 14 WORD、`LLLL=1101` だ。TAG は `1684` だ。

```
1684 0088 0007 00A0 589e 0C4A 08C8 0783 446f 6e61 6c64 2054 7275 6d70
```

### LANGUAGE-BCP47-CODE

Edge Id `0008`、Subject Q155(`00A0 009b`)、Object `Brasil`(pt-BR)。

- Object は言語 `09C7 7074 2d42 5200`(BCP47 `pt-BR`、4 WORD)+ テキスト 6 byte(偶数、3 WORD)なので、全体 8 WORD `0BCA 09C7 7074 2d42 5200 4272 6173 696c` だ。
- Edge は TAG 1 + Edge Id 2 + Subject 2 + Object 8 = 13 WORD、`LLLL=1100` だ。TAG は `1604` だ。

```
1604 0088 0008 00A0 009b 0BCA 09C7 7074 2d42 5200 4272 6173 696c
```

## 関連ページ

- [Edge](/ja/grammar/edge/)、[ALIAS](/ja/grammar/edge/alias/)、[DESCRIPTION](/ja/grammar/edge/description/)、[BIND](/ja/grammar/edge/bind/)
- [UTF8-LANGUAGE-TEXT](/ja/grammar/value/text/utf8-language-text/)、[LANGUAGE-SHORT-CODE](/ja/grammar/value/text/language-short-code/)、[LANGUAGE-BCP47-CODE](/ja/grammar/value/text/language-bcp47-code/)
- [LOCAL](/ja/grammar/reference/local/)、[REFERENCE-NODE](/ja/grammar/edge/reference-node/)
