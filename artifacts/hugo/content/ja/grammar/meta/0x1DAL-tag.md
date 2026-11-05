---
title: "TAG (0x1DAL)"
weight: 474
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "バージョンに付けた不変の名前を記す(git annotated tag)。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `TAG` (規格ドキュメント BIND `TAG`) |
| TAG ID | `0x1DAL` |
| Codec ID | `0x00001DA0` |
| 規格ドキュメント | `0x00000000/codecs/0x00001DA0/` (DECLARE 対象 `1DA0`) |
| セクション | 14 `1110` (Meta)、セクション内オフセット C = 26 |
| Kind | Meta · クラス: 系譜 |
| TAG WORD | `0001 1101 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | バージョンに付けた不変の名前。TEXT Value とコンテンツハッシュ (git annotated tag) |
| Hugo 側 | `meta/lineage/tag.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload フィールドの順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `name` | #2 | レコード | `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD |  |
| 2 | `target` | #7 | レコード | `07C0` SHA-256-DIGEST, `0000` ABSENT(任意フィールド) |  |

バージョンに付けた不変の名前を記す(git annotated tag)。

## レイアウト {#레이아웃}

```
TAG WORD          0001 1101 1010 LLLL      Codec 0x1DAL
[Length 拡張 TAG]
名前              UTF8-TEXT-* Value
対象              SHA-256-DIGEST Value、または省略マーカー 0x0000 (任意フィールド)。省略するとこのバージョン
```

- Codec: Meta `0x1DAL`、系譜クラス
- Payload: 埋め込み Value(テキスト + 任意のコンテンツハッシュ)
- 個数: 複数可

## 解釈と有効性 {#해석과-유효성}

- 名前は [UTF8-TEXT](../value/0x072L-utf8-text.md)、対象は [SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md) である。
- 対象を省略すると(ABSENT `0x0000`、[CODEC](../edge/0x0BEL-codec.md) の任意フィールド)、このドキュメント自身に付けた名前である。自分のコンテンツハッシュは自分の中に書けない。geul.org 規格 `0x1DA0` は name(`0720`・`0730`)と target(`07C0`・`0000`)の 2 つのレコードフィールドである。
- 同じ名前を別のバージョンに再び使わない。

## 例 {#예시}

- 名前 `v1`、このバージョン: `1DA3 0721 7631 0000`

## 未解決の問題 {#열린-문제}

- バージョン ID(連番)があるのに TAG が必要か。

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00001DA0/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DA000000000
BODY
#1 DECLARE 0x1DA0
#2 FIELD #1 record
#3 BIND #1 "TAG"
#4 BIND #2 "name"
#5 CODEC #2 0x0720
#6 CODEC #2 0x0730
#7 FIELD #1 record
#8 BIND #7 "target"
#9 CODEC #7 0x07C0
#10 CODEC #7 0x0000
```
