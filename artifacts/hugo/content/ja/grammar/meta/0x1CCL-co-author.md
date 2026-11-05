---
title: "CO-AUTHOR (0x1CCL)"
weight: 460
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "ドキュメントを共に書いた主体を記す(git Co-authored-by)。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `CO-AUTHOR` (規格ドキュメント BIND `CO-AUTHOR`) |
| TAG ID | `0x1CCL` |
| Codec ID | `0x00001CC0` |
| 規格ドキュメント | `0x00000000/codecs/0x00001CC0/` (DECLARE 対象 `1CC0`) |
| セクション | 14 `1110` (Meta)、セクション内オフセット C = 12 |
| Kind | Meta · クラス: 出典 |
| TAG WORD | `0001 1100 1100 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | 共同作成者。Reference (git `Co-authored-by`) |
| Hugo 側 | `meta/provenance/co-author.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload フィールドの順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `actor` | #2 | レコード | 任意のレコード(プレースホルダを除く) |  |

ドキュメントを共に書いた主体を記す(git `Co-authored-by`)。

## レイアウト {#레이아웃}

```
TAG WORD          0001 1100 1100 LLLL      Codec 0x1CCL
[Length 拡張 TAG]
Payload           Reference レコード 1 つ (EXTERNAL-ISSUER-*, GEUL, WIKIDATA-QID, LOCAL など)
```

- Codec: Meta `0x1CCL`、出典クラス
- Payload: 埋め込み Reference
- 個数: 複数可

## 解釈と有効性 {#해석과-유효성}

- Reference は Codec を問わない。人・組織・モデル・ルールエンジンのいずれにもなれる([EXTERNAL-ISSUER](../reference/0x02FL-external-issuer-2word.md)、[GEUL](../reference/0x00AL-geul.md)、[WIKIDATA-QID](../reference/0x014L-wikidata-qid.md)、[LOCAL](../reference/0x005L-local.md) など)。
- geul.org 公表ドキュメントには自然人を指す Reference を置かない([Issuer と公表](../issuer.md#geulorg-공표))。組織・Issuer を指す。例外として [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md) で自然人を指すことは許容する。
- LOCAL であれば、BODY でその対象を叙述する。

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00001CC0/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001CC000000000
BODY
#1 DECLARE 0x1CC0
#2 FIELD #1 record
#3 BIND #1 "CO-AUTHOR"
#4 BIND #2 "actor"
```
