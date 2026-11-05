---
title: "ALIAS (0x0A5L)"
weight: 165
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "ALIAS は、Subject の対象の別名一つを Object として結びつける叙述 Edge である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `ALIAS` (規格ドキュメント BIND `ALIAS`) |
| TAG ID | `0x0A5L` |
| Codec ID | `0x00000A50` |
| 規格ドキュメント | `0x00000000/codecs/0x00000A50/` (DECLARE 対象 `0A50`) |
| セクション | 5 `0101` (Edge 叙述)、セクション内オフセット C = 5 |
| Kind | Edge · 系列: 叙述、まとまり: 指示と名前 |
| TAG WORD | `0000 1010 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | Subject の別名(エイリアス)の連結。レイアウトは LABEL と同じ |
| Hugo 側 | `edge/alias.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順序である([Codec 規格ドキュメント](../codec-spec.md))。Edge の Edge Id は FIELD で宣言しない。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受け取る形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | レコード | 任意のレコード(プレースホルダを除く) |  |
| 2 | `object` | #3 | レコード | `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT, `0050` LOCAL |  |

ALIAS は、Subject の対象の別名(エイリアス)一つを Object として結びつける叙述 Edge である。Codec `0x0A5L`。

[LABEL](0x0A4L-label.md) はその言語の代表的な名前(言語ごとに多くても一つ)で、ALIAS は同じ対象の別の名前である(言語ごとに複数、ウィキデータの "also known as")。主に検索に使う。レイアウトと有効性は LABEL と同じである。

## レイアウト {#레이아웃}

```
TAG WORD          0000 1010 0101 LLLL
[Length 拡張 TAG]
Edge Id           LOCAL Reference レコード
Subject           Reference レコード 1個
Object            UTF8-LANGUAGE-TEXT Value または LOCAL Reference レコード 1個
```

## 解釈と有効性 {#해석과-유효성}

- Subject と Object の規則は [LABEL](0x0A4L-label.md) と同じである(Object は [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md)、またはそれに解決される LOCAL)。
- 同じ Subject・言語に ALIAS を複数置ける。順序はドキュメント内の順序である。
- 同じ Subject・言語の LABEL と同じテキストを ALIAS に置かない(代表的な名前は LABEL 一つで足りる)。この規則は推奨である。
- geul.org の規格ドキュメントは Object を [CODEC](0x0BEL-codec.md) で制限する(`0780`・`0790`・`0050`、LABEL と同じ)。

## 例 (非規範) {#예시-비규범}

Edge Id `0003`、Subject Q42(`0141 002A`)、Object `DNA`(en): 言語 `0761 656E`(BCP47 `en`) + テキスト 3 byte(奇数) → `UTF8-LANGUAGE-TEXT-ODD`(`0x079L`)、`0794 0761 656E 444E 4100`。

- TAG 1 + Edge Id 2 + Subject 2 + Object 5 = 10 WORD、`LLLL=1001`。TAG は `0A59` である。

```
0A59 0051 0003 0141 002A 0794 0761 656E 444E 4100
```

## 関連ページ {#관련-페이지}

- [Edge](_index.md), [LABEL](0x0A4L-label.md), [DESCRIPTION](0x0A6L-description.md), [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00000A50/latest.geul` を `geul show` で読んだ姿である(16進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A5000000000
BODY
#1 DECLARE 0x0A50
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "ALIAS"
#5 BIND #2 "subject"
#6 BIND #3 "object"
#7 CODEC #3 0x0780
#8 CODEC #3 0x0790
#9 CODEC #3 0x0050
```
