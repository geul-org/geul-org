---
title: "DOC-2WORD (0x1C1L)"
weight: 449
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "DOC-1WORD・DOC-2WORD・DOC-4WORD は、ドキュメント全体の WORD 数を指定してドキュメントを開く構造 Meta である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DOC-1WORD・DOC-2WORD・DOC-4WORD は、ドキュメント全体の WORD 数を指定してドキュメントを開く構造 Meta である。

| 項目 | 値 |
|---|---|
| 名前 | `DOC-2WORD` (規格ドキュメント BIND `DOC-2WORD`) |
| TAG ID | `0x1C1L` |
| Codec ID | `0x00001C10` |
| 規格ドキュメント | `0x00000000/codecs/0x00001C10/` (DECLARE 対象 `1C10`) |
| セクション | 14 `1110` (Meta)、セクション内オフセット C = 1 |
| Kind | Meta · クラス: 構造 |
| TAG WORD | `0001 1100 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | 全体の長さを Payload 2 WORD で指定したドキュメントの開始 |
| Hugo 側 | `meta/structure/doc.md` (そちらは [DOC-1WORD](0x1C0L-doc-1word.md)、[DOC-4WORD](0x1C2L-doc-4word.md) も併せて扱う) |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload フィールドの順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `count` | #2 | 生値 2 WORD |  |  |

ドキュメントを開くレコードである。ドキュメント全体の WORD 数を Payload に指定する。`DOC-1WORD`(`0x1C0L`)、`DOC-2WORD`(`0x1C1L`)、`DOC-4WORD`(`0x1C2L`)をこのページで併せて扱う。

## レイアウト {#레이아웃}

```
TAG WORD          0001 1100 0000 LLLL      Codec 0x1C0L
[Length 拡張 TAG]
Payload           全体の WORD 数。Codec が幅を決める: DOC-1WORD 1、DOC-2WORD 2、DOC-4WORD 4
```

- Codec: Meta `0x1C0L~0x1C2L`、構造クラス
- Payload: 生値(ドキュメント全体の WORD 数、unsigned)
- 個数: ドキュメントごとに 1 つ、先頭

## 解釈と有効性 {#해석과-유효성}

- 長さは、開くレコードの先頭から [END](0x1C4L-end.md) の末尾までである。
- 値が収まる最も狭い幅を使う。より広い幅でエンコードした場合は非正規エンコードとして拒否する。
- 長さが入力全体と一致しなければならない。ドキュメント 1 つが入力 1 つである。
- デコーダはこの長さでドキュメント全体を読み飛ばせる。長さを知らないまま開く Codec はない。
- コンテンツハッシュを計算するときは、検証クラスの Meta を除いた長さとそれに合う幅で書き直す([コンテンツハッシュ](../document.md#내용-해시))。

## 例 {#예시}

- `0x1C01 0x0017`: DOC-1WORD、全体 23 WORD

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00001C10/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C1000000000
BODY
#1 DECLARE 0x1C10
#2 FIELD #1 0x0002
#3 BIND #1 "DOC-2WORD"
#4 BIND #2 "count"
```
