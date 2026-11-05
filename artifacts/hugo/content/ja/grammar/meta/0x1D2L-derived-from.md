---
title: "DERIVED-FROM (0x1D2L)"
weight: 466
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "このドキュメントが別の系譜のドキュメント・資料から派生したことを記す。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `DERIVED-FROM` (規格ドキュメント BIND `DERIVED-FROM`) |
| TAG ID | `0x1D2L` |
| Codec ID | `0x00001D20` |
| 規格ドキュメント | `0x00000000/codecs/0x00001D20/` (DECLARE 対象 `1D20`) |
| セクション | 14 `1110` (Meta)、セクション内オフセット C = 18 |
| Kind | Meta · クラス: 系譜 |
| TAG WORD | `0001 1101 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | 別の系譜のレコード・資料から派生。外部資料の特定のバージョンに固定するときは、HEAD の [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처)に原文ハッシュ QUALIFIER(P4092)を付ける(git submodule)。 |
| Hugo 側 | `meta/lineage/derived-from.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload フィールドの順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `source` | #2 | レコード | `000F` セクション 0 全体(ワイルドカード、Reference), `020F` セクション 1 全体(ワイルドカード、Reference), `040F` セクション 2 全体(ワイルドカード、Reference), `07C0` SHA-256-DIGEST, `0740` URI-EVEN, `0750` URI-ODD |  |

このドキュメントが別の系譜のドキュメント・資料から派生したことを記す。

## レイアウト {#레이아웃}

```
TAG WORD          0001 1101 0010 LLLL      Codec 0x1D2L
[Length 拡張 TAG]
Payload           Reference、または SHA-256-DIGEST(コンテンツハッシュ)、または URI Value
```

- Codec: Meta `0x1D2L`、系譜クラス
- Payload: 埋め込み Reference または Value
- 個数: 複数可

## 解釈と有効性 {#해석과-유효성}

- GEUL ドキュメントから派生した場合はそのコンテンツハッシュ([SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md))を、外部資料なら [URI](../value/0x074L-uri.md) を置く。外部資料の版をハッシュで固定するには、HEAD の [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처)に原文ハッシュ QUALIFIER(P4092)を付ける。
- レコード単位の原典は根拠 Edge [SOURCE](../edge/0x0C0L-source.md)が、移動・分割・統合前の古いレコードは対象 Edge の QUALIFIER P1365(値は古い Edge Id)が担う。

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00001D20/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D2000000000
BODY
#1 DECLARE 0x1D20
#2 FIELD #1 record
#3 BIND #1 "DERIVED-FROM"
#4 BIND #2 "source"
#5 CODEC #2 0x000F
#9 CODEC #2 0x020F
#10 CODEC #2 0x040F
#6 CODEC #2 0x07C0
#7 CODEC #2 0x0740
#8 CODEC #2 0x0750
```
