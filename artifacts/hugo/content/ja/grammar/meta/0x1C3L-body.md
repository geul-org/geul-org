---
title: "BODY (0x1C3L)"
weight: 451
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "HEAD を終えて BODY を始めるレコードである。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `BODY` (規格ドキュメント BIND `BODY`) |
| TAG ID | `0x1C3L` |
| Codec ID | `0x00001C30` |
| 規格ドキュメント | `0x00000000/codecs/0x00001C30/` (DECLARE 対象 `1C30`) |
| セクション | 14 `1110` (Meta)、セクション内オフセット C = 3 |
| Kind | Meta · クラス: 構造 |
| TAG WORD | `0001 1100 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | 1 WORD。ドキュメントの HEAD を終えて BODY を始める。 |
| Hugo 側 | `meta/structure/body.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

規格ドキュメントに FIELD がない。Payload フィールドを宣言しない。

HEAD を終えて BODY を始めるレコードである。

## レイアウト {#레이아웃}

```
TAG WORD          0001 1100 0011 LLLL      Codec 0x1C3L
[Length 拡張 TAG]
```

- Codec: Meta `0x1C3L`、構造クラス
- Payload: なし(1 WORD)
- 個数: ドキュメントごとに多くても 1 つ

## 解釈と有効性 {#해석과-유효성}

- HEAD が空なら省略する。`BODY` のないドキュメントは全体が BODY である。HEAD に Meta や HEAD Edge(ドキュメント全体の [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처)とその QUALIFIER)があれば置く。
- Payload がない。全体で 1 WORD である。

## 例 {#예시}

- `0x1C30`

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00001C30/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C3000000000
BODY
#1 DECLARE 0x1C30
#2 BIND #1 "BODY"
```
