---
title: "END (0x1C4L)"
weight: 452
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "ドキュメントを閉じるレコードである。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `END` (規格ドキュメント BIND `END`) |
| TAG ID | `0x1C4L` |
| Codec ID | `0x00001C40` |
| 規格ドキュメント | `0x00000000/codecs/0x00001C40/` (DECLARE 対象 `1C40`) |
| セクション | 14 `1110` (Meta)、セクション内オフセット C = 4 |
| Kind | Meta · クラス: 構造 |
| TAG WORD | `0001 1100 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | 1 WORD。ドキュメントを閉じる。 |
| Hugo 側 | `meta/structure/end.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

規格ドキュメントに FIELD がない。Payload フィールドを宣言しない。

ドキュメントを閉じるレコードである。

## レイアウト {#레이아웃}

```
TAG WORD          0001 1100 0100 LLLL      Codec 0x1C4L
[Length 拡張 TAG]
```

- Codec: Meta `0x1C4L`、構造クラス
- Payload: なし(1 WORD)
- 個数: ドキュメントごとに 1 つ、末尾

## 解釈と有効性 {#해석과-유효성}

- 必須である。位置は [DOC](0x1C0L-doc-1word.md)(`DOC-*`)の長さで確認する。
- END なしで入力が終わった場合は、途中で切れたドキュメントである。途中で切れたドキュメントの内容を有効とみなすかどうかはデコーダのポリシーである。
- この後には何も来ない。

## 例 {#예시}

- `0x1C40`

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00001C40/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C4000000000
BODY
#1 DECLARE 0x1C40
#2 BIND #1 "END"
```
