---
title: "END"
weight: 16
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "END は、ドキュメントを閉じる 1 WORD の構造 Meta だ。すべてのドキュメントに必須だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ドキュメントを閉じるレコードだ。

## レイアウト

```
TAG WORD          0001 1LLL L000 1111      Codec 0x0F
[Length 拡張 TAG]
```

- Codec: Meta `0x0F`、構造クラス(`000`)
- Payload: なし(1 WORD)
- 個数: ドキュメントごとに一つ、末尾

## 解釈と有効性

- 必須だ。位置は [DOC](/ja/grammar/meta/structure/doc/)(`DOC-*`)の長さで確認する。
- END なしで入力が終わったら、切れたドキュメントだ。切れたドキュメントの内容を有効と見なすかは、デコーダのポリシーだ。
- 後ろには何も来ない。

## 例

- `0x180F`
