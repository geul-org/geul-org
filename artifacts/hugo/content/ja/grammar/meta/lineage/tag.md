---
title: "TAG"
weight: 58
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "TAG は、バージョンに付けた不変の名前を書く系譜 Meta だ(git annotated tag)。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

バージョンに付けた不変の名前を書く(git annotated tag)。

## レイアウト

```
TAG WORD          0001 1LLL L011 1001      Codec 0x39
[Length 拡張 TAG]
名前              UTF8-TEXT-* Value
対象              SHA-256-DIGEST Value、または省略マーカー 0x0000 (オプションフィールド)。省略するとこのバージョン
```

- Codec: Meta `0x39`、系譜クラス(`011`)
- Payload: 組み込み Value(テキスト + 任意のコンテンツハッシュ)
- 個数: 複数可

## 解釈と有効性

- 名前は [UTF8-TEXT](/ja/grammar/value/text/utf8-text/)、対象は [SHA-256-DIGEST](/ja/grammar/value/binary/sha-256-digest/) だ。
- 対象を省略すると(ABSENT `0x0000`、[CODEC](/ja/grammar/edge/codec/) のオプションフィールド)、このドキュメント自身に付けた名前だ。自分のコンテンツハッシュは、自分の中に書けない。geul.org 規格 `0x1839` は、name(`0840`・`0841`)と target(`0861`・`0000`)の二つのレコードフィールドだ。
- 同じ名前を別のバージョンに再利用しない。

## 例

- 名前 `v1`、このバージョン: `19B9 08C0 7631 0000`

## 未解決の問題

- バージョン ID(通し番号)があるのに TAG が必要か、ドキュメント名(`BIND`)との役割の区別。
