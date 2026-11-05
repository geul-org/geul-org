---
title: "ISSUER-KEY (0x1E5L)"
weight: 485
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "自己発行(16 WORD)Issuer の公開鍵を宣言する。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `ISSUER-KEY` (規格ドキュメント BIND `ISSUER-KEY`) |
| TAG ID | `0x1E5L` |
| Codec ID | `0x00001E50` |
| 規格ドキュメント | `0x00000000/codecs/0x00001E50/` (DECLARE 対象 `1E50`) |
| セクション | 15 `1111` (Meta)、セクション内オフセット C = 5 |
| Kind | Meta · クラス: 検証 |
| TAG WORD | `0001 1110 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | 自己発行 Issuer の署名アルゴリズム ID と公開鍵の宣言 |
| Hugo 側 | `meta/verification/issuer-key.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload フィールドの順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `algorithm` | #2 | 生値 1 WORD |  | `0x0001` ed25519 |
| 2 | `key` | #3 | 残り生値(`0xFFFF`) |  |  |

自己発行(16 WORD)Issuer の公開鍵を宣言する。Issuer ID = SHA-256("GEUL-ISSUER-v1" ‖ アルゴリズム ID ‖ 公開鍵)である([16 WORD Issuer](../issuer.md#16-word-issuer))。

## レイアウト {#레이아웃}

```
TAG WORD          0001 1110 0101 LLLL      Codec 0x1E5L
[Length 拡張 TAG]
アルゴリズム ID   1 WORD (0x0001 = Ed25519)
公開鍵            アルゴリズムが定める幅 (Ed25519 16 WORD)
```

- Codec: Meta `0x1E5L`、検証クラス
- Payload: 生値(アルゴリズム ID + 公開鍵)
- 個数: 複数可(鍵の交換)

## 解釈と有効性 {#해석과-유효성}

- 検証クラスなのでコンテンツハッシュから除かれる。
- 2・4 WORD の Issuer は geul.org に登録した鍵を使うので不要である。

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00001E50/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E5000000000
BODY
#1 DECLARE 0x1E50
#2 FIELD #1 0x0001
#3 FIELD #1 rest
#4 ENUM #2 0x0001
#5 BIND #1 "ISSUER-KEY"
#6 BIND #2 "algorithm"
#7 BIND #3 "key"
#8 BIND #4 "ed25519"
```
