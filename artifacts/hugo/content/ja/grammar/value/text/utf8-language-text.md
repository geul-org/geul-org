---
title: "UTF8-LANGUAGE-TEXT"
weight: 75
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T23:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "UTF8-LANGUAGE-TEXT は、言語 Value レコード一つと UTF-8 テキストを一つの Value に収める、言語付きテキストだ(Codec 0x4A/0x4B)。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UTF8-LANGUAGE-TEXT は、言語付きのテキストだ。言語 Value レコード一つと UTF-8 バイト列を、一つの Value に収める。

[UTF8-TEXT](/ja/grammar/value/text/utf8-text/) は言語のない文字列(識別子、コード、ファイル名、原文バイト)で、この形式は言語のあるテキスト(名前、タイトル、キャッチコピー、文)だ。二つは、バイトが同じでも異なる値だ。"Paris"(文字列)と "Paris"(フランス語)は同じではない。RDF が `xsd:string` と `rdf:langString` を分けるのと同じだ。

## レイアウト

- コード: Value 直接コード `0x4A`(テキスト偶数バイト)・`0x4B`(テキスト奇数バイト)。系列 TEXT。

```
TAG WORD          0000 1LLL L100 101P      Codec 0x4A/0x4B (P = テキストが奇数バイト)
[Length 拡張 TAG] 全体が 15 WORD 以上のとき
Language          LANGUAGE-SHORT-CODE または LANGUAGE-BCP47-CODE Value レコード 1個 (TAG を含む)
Text WORD 1st ... Nth             UTF-8 bytes / 奇数なら最後に 0x00
```

## 解釈と有効性

- Payload は言語レコードで始まる。Payload の最初の WORD を TAG として読み、その Length だけが言語レコードで、残りがテキストバイトだ。言語レコードは必須だ。言語がなければ、この形式ではなく UTF8-TEXT を使う。
- 言語レコードは、完全な [LANGUAGE-SHORT-CODE](/ja/grammar/value/text/language-short-code/)(`0x48`)または [LANGUAGE-BCP47-CODE](/ja/grammar/value/text/language-bcp47-code/)(`0x46`・`0x47`)レコードがちょうど一つだ。他の Codec だったり不完全であれば invalid だ。言語レコードの有効性は、その形式の規則に従う。
- 二つの言語形式のどちらも使える。同じ言語かを比較する規則は [LABEL](/ja/grammar/edge/label/) と同じだ。SHORT-CODE と、レジストリがその番号に結んだ BCP 47 tag は、同じ言語だ。
- `zxx`(言語内容なし)は使わない。そのような文字列は UTF8-TEXT だ。`und`(言語未定)と `mul`(複数言語)は言語のあるテキストなので、使える。
- テキストバイトは UTF8-TEXT と同じ規則に従う。well-formed な UTF-8 でなければならず、先頭の BOM は禁止し、正規化を強制せずに原文のまま保存する。比較・インデックスする側が NFC に揃えて比較する。
- テキストのバイト数は `2 × (Payload WORD 数 − 言語レコードの WORD 数) − P` だ。P(Codec の最下位ビット)は、テキストバイトの偶奇だけを表す。奇数なら、最後の WORD の下位 byte は `00` でなければならない。
- 空のテキスト(0 byte)は、偶数コードに言語レコードだけを置く。

## 使う場所

- Wikidata の monolingualtext 値: `{"text":"Bundesrepublik Deutschland","language":"de"}` は、この形式一つになる。[TRIPLE](/ja/grammar/edge/triple/) の Object、[QUALIFIER](/ja/grammar/edge/qualifier/) の Value にそのまま入る。プロパティ・rank・qualifier は TRIPLE が担う。
- [LABEL](/ja/grammar/edge/label/)・[ALIAS](/ja/grammar/edge/alias/) の Object。名前と言語を、この値一つが収める。
- 法令・論文のタイトルのように、言語が決まったテキスト。

## 言語コードの対応 (Wikidata)

- Wikidata・Wikimedia の言語コードがすべて BCP 47 なわけではない(例: `simple`、`map-bms`)。対応表で BCP 47 tag に移す。移せないコードは、用途によって異なる扱いをする。
  - 値(monolingualtext): datavalue の原文を UTF8-TEXT で保存する。値は命題の一部なので、捨てると命題が変わる。
  - ラベル・説明・別名: 読み飛ばして、レポートに残す。これらの Edge は言語があって成り立ち(言語のないテキストは invalid)、原文は原典データに残る。
- 対応させた tag が GEUL Language Registry に番号を持てば LANGUAGE-SHORT-CODE で、持たなければ LANGUAGE-BCP47-CODE で書く。

## 長さ

- 全体は、TAG 1 WORD、Length 拡張 TAG(あれば)、言語レコード、テキスト WORD を合わせた数だ。14 WORD 以下は直接長さ、15 WORD 以上は拡張長さを使う([Length](/ja/grammar/record/))。
- 言語レコードは、SHORT-CODE なら 2 WORD、BCP 47 なら `ceil(tag バイト/2) + 1` WORD だ(`de` 2 WORD、`zh-Hant` 5 WORD)。

## 例

言語はすべて LANGUAGE-BCP47-CODE 形式の例だ。`fr`・`ko`・`de` はレジストリ番号があるので SHORT-CODE(2 WORD)でも書ける。

| 値 | テキストバイト | 全体 WORD |
|---|---|---|
| "Paris" (fr) | 5 (奇数) | `0ACB 08C6 6672 5061 7269 7300` |
| "" (ko) | 0 | `094A 08C6 6B6F` |
| "Bundesrepublik Deutschland" (de) | 26 (偶数) | `0F4A 0011 08C6 6465 4275 6E64 6573 7265 7075 626C 696B 2044 6575 7473 6368 6C61 6E64` |

- "Paris": TAG `0ACB`(Codec `0x4B`、`LLLL=0101`、全体 6 WORD)、言語 `08C6 6672`(BCP 47 `fr`)、テキスト `5061 7269 7300`(5 byte、最後は `00`)。
- 三つ目は全体 17 WORD なので Length 拡張を使う(`0F4A` の `LLLL=1110`、拡張 TAG `0011`)。

## 標準の根拠

- 言語 tag: [RFC 5646 (BCP 47)](https://www.rfc-editor.org/rfc/rfc5646)。`zxx`・`und`・`mul` は IANA Language Subtag Registry の special コードだ。
- テキスト: [RFC 3629](https://www.rfc-editor.org/rfc/rfc3629)。
- 文字列と言語付きテキストの区別: [RDF 1.1 Concepts — language-tagged string](https://www.w3.org/TR/rdf11-concepts/#dfn-language-tagged-string)。

## 未解決の問題

- schema の BCP 47 tag 文法の検査。今は ASCII で空でないことだけを見る。

## 関連ページ

- [Value](/ja/grammar/value/)、[UTF8-TEXT](/ja/grammar/value/text/utf8-text/)、[LANGUAGE-SHORT-CODE](/ja/grammar/value/text/language-short-code/)、[LANGUAGE-BCP47-CODE](/ja/grammar/value/text/language-bcp47-code/)、[LABEL](/ja/grammar/edge/label/)
