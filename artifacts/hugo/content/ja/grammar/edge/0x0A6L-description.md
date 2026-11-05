---
title: "DESCRIPTION (0x0A6L)"
weight: 166
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DESCRIPTION は、Subject の対象の特定言語の説明一つを Object として結びつける叙述 Edge である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `DESCRIPTION` (規格ドキュメント BIND `DESCRIPTION`) |
| TAG ID | `0x0A6L` |
| Codec ID | `0x00000A60` |
| 規格ドキュメント | `0x00000000/codecs/0x00000A60/` (DECLARE 対象 `0A60`) |
| セクション | 5 `0101` (Edge 叙述)、セクション内オフセット C = 6 |
| Kind | Edge · 系列: 叙述、まとまり: 指示と名前 |
| TAG WORD | `0000 1010 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | Subject の言語別の説明(description)の連結。レイアウトは LABEL と同じ |
| Hugo 側 | `edge/description.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順序である([Codec 規格ドキュメント](../codec-spec.md))。Edge の Edge Id は FIELD で宣言しない。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受け取る形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | レコード | 任意のレコード(プレースホルダを除く) |  |
| 2 | `object` | #3 | レコード | `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT, `0050` LOCAL |  |

DESCRIPTION は、Subject の対象の特定言語の説明一つを Object として結びつける叙述 Edge である。Codec `0x0A6L`。

説明は対象を区別する短い語句である(ウィキデータの description、例: 「ドイツの首都であり最大の都市」)。対象の定義や主張ではない。対象についての命題は [TRIPLE](0x0AAL-triple.md) で書く。レイアウトは [LABEL](0x0A4L-label.md) と同じである。説明とその言語は Object 一つ、[UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md) に収められる。生値フィールドはない。

## レイアウト {#레이아웃}

```
TAG WORD          0000 1010 0110 LLLL
[Length 拡張 TAG]
Edge Id           LOCAL Reference レコード
Subject           Reference レコード 1個
Object            UTF8-LANGUAGE-TEXT Value または LOCAL Reference レコード 1個
```

## 解釈と有効性 {#해석과-유효성}

- Subject と Object の規則は [LABEL](0x0A4L-label.md) と同じである。Subject は、ちょうど一つの完全な Reference レコードである。Object は、ちょうど一つの完全な UTF8-LANGUAGE-TEXT(`0x078L`・`0x079L`)レコードであるか、同じドキュメントの [REFERENCE-NODE](0x0A0L-reference-node.md) バインディングで UTF8-LANGUAGE-TEXT に解決される LOCAL Reference である。
- 言語のないテキスト(UTF8-TEXT)は DESCRIPTION になれない。説明は言語ごとに一つなので、言語があってこそその規則が成り立つ。複数の言語に共通する説明は言語 `mul` で書く。
- 同じ Subject・言語の DESCRIPTION は多くても一つである。
- 説明は、同じ名前の別の対象と区別するために使う。同じ言語で LABEL と DESCRIPTION の組が二つの対象で重ならないことが望ましいが、規格はこれを検査しない(ウィキデータも推奨にすぎず強制しない)。
- geul.org の規格ドキュメントは Object を [CODEC](0x0BEL-codec.md) で制限する(`0780`・`0790`・`0050`、LABEL と同じ)。

## 長さ {#길이}

```
全体 = 1 + N_len + N_id + N_subject + N_object WORD
```

- Object の言語レコードとテキストのバイト数は Object レコードが担う。最後のレコードを読み終えたカーソルは、Edge の終端とちょうど一致しなければならない。
- 説明はラベルより長く、Object と Edge のどちらも 15 WORD を超えやすい。そのときは Length 拡張を使う([レコード](../record.md))。

## 例 (非規範) {#예시-비규범}

Edge Id `0009`、Subject Q64(`0141 0040`)、Object `capital and largest city of Germany`(en)。言語は LANGUAGE-BCP47-CODE 形式の例である(`en` はレジストリ番号 `0x0784` があるので SHORT-CODE でも使える)。

- Object は言語 `0761 656E`(BCP47 `en`、2 WORD) + テキスト 35 byte(奇数、18 WORD)なので `0x079L`、TAG 1 + 拡張 TAG 1 + 20 = 22 WORD、`079E 0016 …` である。
- Edge は TAG 1 + 拡張 TAG 1 + Edge Id 2 + Subject 2 + Object 22 = 28 WORD なので `LLLL=1110`、TAG `0A6E`、拡張 TAG `001C` である。

```
0A6E 001C 0051 0009 0141 0040
079E 0016 0761 656E 6361 7069 7461 6C20 616E 6420 6C61 7267 6573 7420 6369 7479 206F 6620 4765 726D 616E 7900
```

## ウィキデータとの対応 {#위키데이터-대응}

- 項目の `descriptions`(言語ごとに一つ) → 言語ごとに DESCRIPTION 一つ。言語コードは LABEL と同じ言語コード対応表で移す。

## 未解決の問題 {#열린-문제}

- 言語のない UTF8-TEXT の説明を許容すべき事例があるか(現在は許容しない)。

## 関連ページ {#관련-페이지}

- [Edge](_index.md), [LABEL](0x0A4L-label.md), [ALIAS](0x0A5L-alias.md), [CODEC](0x0BEL-codec.md)
- [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md), [LOCAL](../reference/0x005L-local.md), [REFERENCE-NODE](0x0A0L-reference-node.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00000A60/latest.geul` を `geul show` で読んだ姿である(16進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A6000000000
BODY
#1 DECLARE 0x0A60
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "DESCRIPTION"
#5 BIND #2 "subject"
#6 BIND #3 "object"
#7 CODEC #3 0x0780
#8 CODEC #3 0x0790
#9 CODEC #3 0x0050
```
