---
title: "IMPORT-DOC (0x1E4L)"
weight: 484
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "import"]
summary: "外部ドキュメントを IMPORT ID で取り込む。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `IMPORT-DOC` (規格ドキュメント BIND `IMPORT-DOC`) |
| TAG ID | `0x1E4L` |
| Codec ID | `0x00001E40` |
| 規格ドキュメント | `0x00000000/codecs/0x00001E40/` (DECLARE 対象 `1E40`) |
| セクション | 15 `1111` (Meta)、セクション内オフセット C = 4 |
| Kind | Meta · クラス: IMPORT |
| TAG WORD | `0001 1110 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | 外部ドキュメントを IMPORT ID で取り込む。埋め込み Reference `DOC-POINTER`(Codec ドキュメントは `CODEC-POINTER`)+ IMPORT ID |
| Hugo 側 | `meta/import/import-doc.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload フィールドの順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `doc` | #4 | レコード | `0410` DOC-POINTER, `0420` CODEC-POINTER |  |
| 2 | `import-id` | #2 | 残り生値(`0xFFFF`) |  |  |

外部ドキュメントを IMPORT ID で取り込む。取り込むドキュメントは [DOC-POINTER](../reference/0x041L-doc-pointer.md) が指し、Issuer の幅も DOC-POINTER が持つ。

## レイアウト {#레이아웃}

```
TAG WORD          0001 1110 0100 LLLL      Codec 0x1E4L
[Length 拡張 TAG]
ドキュメント      DOC-POINTER Reference レコード (Issuer、ドキュメント ID、バージョン ID。バージョン 0 なら最新)。Codec ドキュメントは CODEC-POINTER
IMPORT ID         残りすべて。最も短い幅の unsigned
```

- Codec: Meta `0x1E4L`、IMPORT クラス
- Payload: 埋め込み Reference `DOC-POINTER`(Issuer、ドキュメント ID、バージョン ID)+ IMPORT ID の生値
- 個数: 複数可(IMPORT ID ごとに 1 つ)

## 解釈と有効性 {#해석과-유효성}

- ドキュメントは、ちょうど 1 つの DOC-POINTER レコードである。Codec ドキュメントを取り込むときは [CODEC-POINTER](../reference/0x042L-codec-pointer.md)(Issuer、Codec ID、バージョン ID)レコードである。自身の Length で終わり、残りが IMPORT ID である。
- IMPORT ID は 1 WORD 以上、最も短い幅である。IMPORT ID の幅は、ここではレコードの長さで、[EXTERNAL-POINTER-*](../reference/0x020L-external-pointer-1word.md) では Codec で決まる。
- 1 つのドキュメントで同じ IMPORT ID を 2 回割り当てない。
- バージョン ID を記せばその版に、`0` なら解釈時点の最新の(または指定した時点で施行中の)版にバインドされる([改訂](../document.md#개정))。
- BODY の [EXTERNAL-POINTER-*](../reference/0x020L-external-pointer-1word.md) が、IMPORT ID で取り込んだドキュメントの LOCAL を指す。取り込んだドキュメント自身は DOC-POINTER で指す。
- 取り込んだドキュメントの HEAD は取り込まない。そのドキュメントの対象は、そのドキュメントの宣言どおりに解釈する。
- IMPORT ID ではドキュメントをまたいで検索できない。複数のドキュメントを取り込むストアは、IMPORT ID を完全なパス(Issuer、ドキュメント ID、バージョン ID、LOCAL ID)に展開して保存する。

## 例 {#예시}

- IMPORT ID 1、Issuer `0x00000002`、ドキュメント `0x…0002`、最新: `1E4A 0418 0000 0002 0000 0000 0000 0002 0000 0000 0001` (Meta TAG 1 + DOC-POINTER 9 + IMPORT ID 1 = 11 WORD)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00001E40/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E4000000000
BODY
#1 DECLARE 0x1E40
#4 FIELD #1 record
#10 CODEC #4 0x0410
#2 FIELD #1 rest
#6 BIND #1 "IMPORT-DOC"
#7 BIND #2 "import-id"
#9 BIND #4 "doc"
#11 CODEC #4 0x0420
```
