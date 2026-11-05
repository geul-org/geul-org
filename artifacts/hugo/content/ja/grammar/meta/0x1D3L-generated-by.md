---
title: "GENERATED-BY (0x1D3L)"
weight: 467
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "ドキュメントを作った主体を記す。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `GENERATED-BY` (規格ドキュメント BIND `GENERATED-BY`) |
| TAG ID | `0x1D3L` |
| Codec ID | `0x00001D30` |
| 規格ドキュメント | `0x00000000/codecs/0x00001D30/` (DECLARE 対象 `1D30`) |
| セクション | 14 `1110` (Meta)、セクション内オフセット C = 19 |
| Kind | Meta · クラス: 系譜 |
| TAG WORD | `0001 1101 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | 生成主体。人、モデル、ルールエンジン |
| Hugo 側 | `meta/lineage/generated-by.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload フィールドの順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `agent` | #2 | レコード | 任意のレコード(プレースホルダを除く) |  |
| 2 | `version` | #5 | レコード | `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD, `0000` ABSENT(任意フィールド) |  |

ドキュメントを作った主体を記す。人、モデル、ルールエンジンのいずれにもなれる。

## レイアウト {#레이아웃}

```
TAG WORD          0001 1101 0011 LLLL      Codec 0x1D3L
[Length 拡張 TAG]
生成主体          Reference (人、モデル、ルールエンジン)
バージョン        UTF8-TEXT Value、または省略マーカー 0x0000 (任意フィールド)
```

- Codec: Meta `0x1D3L`、系譜クラス
- Payload: 埋め込み Reference + バージョンテキスト(任意)
- 個数: 複数可

## 解釈と有効性 {#해석과-유효성}

- モデルであれば、モデルのバージョンも併せて記す。
- バージョンが不明、または置かない場合は、その位置を省略して ABSENT(`0x0000`)を使う([CODEC](../edge/0x0BEL-codec.md)の任意フィールド)。geul.org 規格 `0x1D30` は agent(CODEC なし)と version(`0720`・`0730`・`0000`)の 2 つのレコードフィールドである。
- プログラムのソースバージョン(コミット)は、[TRANSFORMED-BY](0x1D4L-transformed-by.md) の形式(ダイジェスト、必須)のほうが正確である。GENERATED-BY のバージョンには、モデル名・バージョンのようにコミット ID ではないものをテキストで記す。
- geul.org 公表ドキュメントには自然人を指す Reference を置かない([Issuer と公表](../issuer.md#geulorg-공표))。組織・Issuer を指す。例外として [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md) で自然人を指すことは許容する。

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00001D30/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D3000000000
BODY
#1 DECLARE 0x1D30
#2 FIELD #1 record
#3 BIND #1 "GENERATED-BY"
#4 BIND #2 "agent"
#5 FIELD #1 record
#6 BIND #5 "version"
#7 CODEC #5 0x0720
#8 CODEC #5 0x0730
#9 CODEC #5 0x0000
```
