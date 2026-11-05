---
title: "LABEL (0x0A4L)"
weight: 164
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "LABEL は、Subject の対象の特定言語の名前(label)一つを Object として結びつける叙述 Edge である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `LABEL` (規格ドキュメント BIND `LABEL`) |
| TAG ID | `0x0A4L` |
| Codec ID | `0x00000A40` |
| 規格ドキュメント | `0x00000000/codecs/0x00000A40/` (DECLARE 対象 `0A40`) |
| セクション | 5 `0101` (Edge 叙述)、セクション内オフセット C = 4 |
| Kind | Edge · 系列: 叙述、まとまり: 指示と名前 |
| TAG WORD | `0000 1010 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | Subject の言語名(label)の連結。Object は UTF8-LANGUAGE-TEXT |
| Hugo 側 | `edge/label.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順序である([Codec 規格ドキュメント](../codec-spec.md))。Edge の Edge Id は FIELD で宣言しない。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受け取る形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | レコード | 任意のレコード(プレースホルダを除く) |  |
| 2 | `object` | #3 | レコード | `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT, `0050` LOCAL |  |

LABEL は、Subject の対象の特定言語の名前(label)一つを Object として結びつける叙述 Edge である。Codec `0x0A4L`。一般の語彙学における lemma を表す Edge ではない。

名前とその言語は Object 一つ、[UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md) に収められる。生値フィールドはない。

## レイアウト {#레이아웃}

```
TAG WORD          0000 1010 0100 LLLL
[Length 拡張 TAG]
Edge Id           LOCAL Reference レコード
Subject           Reference レコード 1個
Object            UTF8-LANGUAGE-TEXT Value または LOCAL Reference レコード 1個
```

## 解釈と有効性 {#해석과-유효성}

- Subject は、ちょうど一つの完全な Reference レコードである。Subject 自体の Length で境界を見つけ、Reference でない、または不完全であれば invalid である。
- Object は、ちょうど一つの完全な [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md)(`0x078L`・`0x079L`)レコードである。言語とテキストの規則(二つの言語形式をどちらも許容、同じ言語の比較)はその形式に従う。
- Object には LOCAL Reference も来られる。この場合は同じドキュメントの [REFERENCE-NODE](0x0A0L-reference-node.md) バインディングで UTF8-LANGUAGE-TEXT に解決されなければならない。解決されない、または別の種類の対象に解決されれば invalid である。
- geul.org の規格ドキュメントはこの制限を [CODEC](0x0BEL-codec.md) で記す(Object = `0780`・`0790`・`0050`)。LOCAL の解決先は CODEC では表さない。
- Object が上の二つの形式のいずれでもない、またはレコードが不完全であれば invalid である。言語のないテキスト(UTF8-TEXT)は LABEL になれない。言語のない機械用の名前は [BIND](0x0A3L-bind.md) で書く。複数の言語に共通する名前は言語 `mul` で書く。
- 同じ Subject・言語の LABEL は多くても一つである。別の名前は [ALIAS](0x0A5L-alias.md) で書く。

## 長さ {#길이}

```
全体 = 1 + N_len + N_id + N_subject + N_object WORD
```

- Object の言語レコードとテキストのバイト数は Edge ではなく Object レコードが担う。最後のレコードを読み終えたカーソルは、Edge の終端とちょうど一致しなければならない。

## 例 (非規範) {#예시-비규범}

`en` の言語コード `0784` は GEUL Language Registry v2(規格ドキュメント `0x00000000/codecs/0x000007A0` バージョン 2)の番号である。

### LANGUAGE-SHORT-CODE {#language-short-code}

Edge Id `0007`、Subject Q22686(`0141 589E`)、Object `Donald Trump`(en)。

- Object は言語 `07A1 0784`(SHORT-CODE 2 WORD) + テキスト 12 byte(偶数、6 WORD)なので `UTF8-LANGUAGE-TEXT-EVEN`(`0x078L`)、全体 9 WORD の `0788 07A1 0784 446F 6E61 6C64 2054 7275 6D70` である。
- Edge は TAG 1 + Edge Id 2 + Subject 2 + Object 9 = 14 WORD、`LLLL=1101` である。TAG は `0A4D` である。

```
0A4D 0051 0007 0141 589E 0788 07A1 0784 446F 6E61 6C64 2054 7275 6D70
```

### LANGUAGE-BCP47-CODE {#language-bcp47-code}

Edge Id `0008`、Subject Q155(`0141 009B`)、Object `Brasil`(pt-BR)。

- Object は言語 `0773 7074 2D42 5200`(BCP47 `pt-BR`、4 WORD) + テキスト 6 byte(偶数、3 WORD)なので、全体 8 WORD の `0787 0773 7074 2D42 5200 4272 6173 696C` である。
- Edge は TAG 1 + Edge Id 2 + Subject 2 + Object 8 = 13 WORD、`LLLL=1100` である。TAG は `0A4C` である。

```
0A4C 0051 0008 0141 009B 0787 0773 7074 2D42 5200 4272 6173 696C
```

## 関連ページ {#관련-페이지}

- [Edge](_index.md), [ALIAS](0x0A5L-alias.md), [DESCRIPTION](0x0A6L-description.md), [BIND](0x0A3L-bind.md)
- [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md), [LANGUAGE-SHORT-CODE](../value/0x07AL-language-short-code.md), [LANGUAGE-BCP47-CODE](../value/0x076L-language-bcp47-code.md)
- [LOCAL](../reference/0x005L-local.md), [REFERENCE-NODE](0x0A0L-reference-node.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00000A40/latest.geul` を `geul show` で読んだ姿である(16進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A4000000000
BODY
#1 DECLARE 0x0A40
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "LABEL"
#5 BIND #2 "subject"
#6 BIND #3 "object"
#7 CODEC #3 0x0780
#8 CODEC #3 0x0790
#9 CODEC #3 0x0050
```
