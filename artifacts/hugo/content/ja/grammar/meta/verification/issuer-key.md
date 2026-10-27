---
title: "ISSUER-KEY"
weight: 65
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "ISSUER-KEY は、自己発行(16 WORD)Issuer の署名アルゴリズム ID と公開鍵を宣言する検証 Meta だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

自己発行(16 WORD)Issuer の公開鍵を宣言する。Issuer ID = SHA-256("GEUL-ISSUER-v1" ‖ アルゴリズム ID ‖ 公開鍵)だ([16 WORD Issuer](/ja/grammar/issuer/#16-word-issuer))。

## レイアウト

```
TAG WORD          0001 1LLL L100 0000      Codec 0x40
[Length 拡張 TAG]
アルゴリズム ID   1 WORD (0x0001 = Ed25519)
公開鍵            アルゴリズムが定めた幅 (Ed25519 16 WORD)
```

- Codec: Meta `0x40`、検証クラス(`100`)
- Payload: 生値(アルゴリズム ID + 公開鍵)
- 個数: 複数可(鍵の交換)

## 解釈と有効性

- 検証クラスなので、コンテンツハッシュから除かれる。
- 1・2・4 WORD Issuer は、geul.org に登録した鍵を使うので不要だ。
