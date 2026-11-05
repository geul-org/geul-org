---
title: "UTF8-LANGUAGE-TEXT (0x078L·0x079L)"
weight: 120
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "UTF8-LANGUAGE-TEXT は言語 Value レコード一つと UTF-8 テキストを一つの Value に収める、言語付きテキストである(Codec 0x078L/0x079L)。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UTF8-LANGUAGE-TEXT は言語 Value レコード一つと UTF-8 テキストを一つの Value に収める、言語付きテキストである(Codec 0x078L/0x079L)。

| 項目 | 値 |
|---|---|
| 名前 | `UTF8-LANGUAGE-TEXT` (偶奇の組。コードごとの名前は下の構成員の表) |
| TAG ID | `0x078L`·`0x079L` |
| セクション | 3 `0011` (Value)、セクション内オフセット C = 24~25 |
| Kind | Value · 系列: TEXT |
| 索引の説明 | 言語付きテキスト。言語 Value レコード(LANGUAGE-SHORT-CODE または LANGUAGE-BCP47-CODE)と UTF-8 バイト。テキストバイトの偶数·奇数 |
| Hugo 側 | `value/text/utf8-language-text.md` |

## 構成員 {#구성원}

このページは偶奇の組をなす二つのコードをまとめて扱う。偶数コードはバイト数が偶数、奇数コードは奇数の値である([レコードと TAG WORD](../record.md#가변-길이-바이트열))。Codec ドキュメントはコードごとに一つである。二つの Codec ドキュメントのフィールドは同じで、DECLARE の対象と名前(BIND)だけが異なる。

| TAG ID | 名前 | バイト数 | Codec ID | 規格ドキュメント | TAG WORD |
|---|---|---|---|---|---|
| `0x078L` | `UTF8-LANGUAGE-TEXT-EVEN` | 偶数 | `0x00000780` | `0x00000000/codecs/0x00000780/` | `0000 0111 1000 LLLL` |
| `0x079L` | `UTF8-LANGUAGE-TEXT-ODD` | 奇数 | `0x00000790` | `0x00000000/codecs/0x00000790/` | `0000 0111 1001 LLLL` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `language` | #2 | レコード | `07A0` LANGUAGE-SHORT-CODE, `0760` LANGUAGE-BCP47-CODE-EVEN, `0770` LANGUAGE-BCP47-CODE-ODD |  |
| 2 | `bytes` | #3 | 残り生値(`0xFFFF`) |  |  |

UTF8-LANGUAGE-TEXT は言語付きテキストである。言語 Value レコード一つと UTF-8 バイト列を一つの Value に収める。

[UTF8-TEXT](0x072L-utf8-text.md) は言語を持たない文字列(識別子、コード、ファイル名、原文バイト)で、この形式は言語を持つテキスト(名前、題名、標語、文)である。両者はバイトが同じでも異なる値である。"Paris"(文字列)と "Paris"(フランス語)は等しくない。RDF が `xsd:string` と `rdf:langString` を分けるのと同じである。

## レイアウト {#레이아웃}

- コード: Value 直接コード `0x078L`(テキスト偶数バイト)·`0x079L`(テキスト奇数バイト)。系列 TEXT。

```
TAG WORD          0000 0111 100P LLLL      Codec 0x078L/0x079L (P = テキストが奇数バイト)
[Length 拡張 TAG] 全体が 15 WORD 以上のとき
Language          LANGUAGE-SHORT-CODE または LANGUAGE-BCP47-CODE Value レコード 1 個 (TAG を含む)
Text WORD 1st ... Nth             UTF-8 bytes / 奇数なら最後に 0x00
```

## 解釈と有効性 {#해석과-유효성}

- Payload は言語レコードで始まる。Payload の最初の WORD を TAG として読み、その Length 分が言語レコードで、残りがテキストバイトである。言語レコードは必須である。言語がなければ、この形式ではなく UTF8-TEXT を使う。
- 言語レコードは、完全な [LANGUAGE-SHORT-CODE](0x07AL-language-short-code.md)(`0x07AL`)または [LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md)(`0x076L`·`0x077L`)レコードがちょうど一つである。他の Codec であったり不完全であったりすれば invalid である。言語レコードの有効性はその形式の規則に従う。
- 二つの言語形式のどちらも使える。同じ言語かどうかを比較する規則は [LABEL](../edge/0x0A4L-label.md) と同じである。SHORT-CODE と、レジストリがその番号に結び付けた BCP 47 tag は同じ言語である。
- `zxx`(言語的内容なし)は使わない。そのような文字列は UTF8-TEXT である。`und`(言語未定)と `mul`(複数言語)は言語を持つテキストなので使える。
- テキストバイトは UTF8-TEXT と同じ規則に従う。well-formed な UTF-8 でなければならず、先頭の U+FEFF も文字として許し、正規化を強制せず原文のまま保存する。比較·索引する側が NFC に揃えて比較する。
- テキストのバイト数は `2 × (Payload WORD 数 − 言語レコード WORD 数) − P` である。P(Codec の最下位ビット)はテキストバイトの偶奇だけを表す。奇数なら最後の WORD の下位 byte は `00` でなければならない。
- 空のテキスト(0 byte)は、偶数コードに言語レコードだけを置く。

## 使う場所 {#쓰는-곳}

- Wikidata の monolingualtext 値: `{"text":"Bundesrepublik Deutschland","language":"de"}` はこの形式一つになる。[TRIPLE](../edge/0x0AAL-triple.md) の Object、[QUALIFIER](../edge/0x0ABL-qualifier.md) の Value にそのまま入る。プロパティ·rank·qualifier は TRIPLE が受け持つ。
- [LABEL](../edge/0x0A4L-label.md)·[ALIAS](../edge/0x0A5L-alias.md) の Object。名前と言語をこの値一つが収める。
- 法令·論文の題名のように言語が定まっているテキスト。

## 言語コードの対応 (Wikidata) {#언어-코드-대응-위키데이터}

- Wikidata·Wikimedia の言語コードがすべて BCP 47 というわけではない(例: `simple`, `map-bms`)。対応表で BCP 47 tag に移す。移せないコードは用途に応じて扱いが異なる。
  - 値(monolingualtext): datavalue の原文を UTF8-TEXT で保存する。値は命題の一部なので、捨てると命題が変わる。
  - ラベル·説明·別名: 飛ばして報告書に残す。これらの Edge は言語があって成り立ち(言語のないテキストは invalid)、原文は原データに残る。
- 移した tag が GEUL Language Registry に番号を持てば LANGUAGE-SHORT-CODE で、持たなければ LANGUAGE-BCP47-CODE で書く。

## 長さ {#길이}

- 全体は TAG 1 WORD、Length 拡張 TAG(あれば)、言語レコード、テキスト WORD を合わせた数である。14 WORD 以下は直接長、15 WORD 以上は拡張長を使う([Length](../record.md))。
- 言語レコードは SHORT-CODE なら 2 WORD、BCP 47 なら `ceil(tag バイト/2) + 1` WORD である(`de` は 2 WORD、`zh-Hant` は 5 WORD)。

## 例 {#예시}

言語はすべて LANGUAGE-BCP47-CODE 形式の例である。`fr`·`ko`·`de` はレジストリ番号があるので SHORT-CODE(2 WORD)でも書ける。

| 値 | テキストバイト | 全体 WORD |
|---|---|---|
| "Paris" (fr) | 5 (奇数) | `0795 0761 6672 5061 7269 7300` |
| "" (ko) | 0 | `0782 0761 6B6F` |
| "Bundesrepublik Deutschland" (de) | 26 (偶数) | `078E 0011 0761 6465 4275 6E64 6573 7265 7075 626C 696B 2044 6575 7473 6368 6C61 6E64` |

- "Paris": TAG `0795`(Codec `0x079L`、`LLLL=0101`、全体 6 WORD)、言語 `0761 6672`(BCP 47 `fr`)、テキスト `5061 7269 7300`(5 byte、最後は `00`)。
- 三つ目は全体 17 WORD なので Length 拡張を使う(`078E` の `LLLL=1110`、拡張 TAG `0011`)。

## 標準の根拠 {#표준-근거}

- 言語 tag: [RFC 5646 (BCP 47)](https://www.rfc-editor.org/rfc/rfc5646)。`zxx`·`und`·`mul` は IANA Language Subtag Registry の special コードである。
- テキスト: [RFC 3629](https://www.rfc-editor.org/rfc/rfc3629)。
- 文字列と言語付きテキストの区別: [RDF 1.1 Concepts — language-tagged string](https://www.w3.org/TR/rdf11-concepts/#dfn-language-tagged-string)。

## 未解決の問題 {#열린-문제}

- schema の BCP 47 tag 文法検査。今は ASCII で空でないことだけを見る。

## 関連ページ {#관련-페이지}

- [Value](_index.md), [UTF8-TEXT](0x072L-utf8-text.md), [LANGUAGE-SHORT-CODE](0x07AL-language-short-code.md), [LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md), [LABEL](../edge/0x0A4L-label.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00000780/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000078000000000
BODY
#1 DECLARE 0x0780
#2 FIELD #1 record
#3 FIELD #1 rest
#4 BIND #1 "UTF8-LANGUAGE-TEXT-EVEN"
#5 BIND #2 "language"
#6 BIND #3 "bytes"
#7 CODEC #2 0x07A0
#8 CODEC #2 0x0760
#9 CODEC #2 0x0770
```

上は `UTF8-LANGUAGE-TEXT-EVEN`(`0x078L`)の Codec ドキュメントである。他の構成員(`UTF8-LANGUAGE-TEXT-ODD`)の Codec ドキュメントは、DOC-ID の Codec ID、DECLARE の対象、`#1` に結び付けた名前(BIND)だけが異なる。
