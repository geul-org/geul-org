---
title: "SIGNED-OFF (0x1E7L)"
weight: 487
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "貢献の権利の確認である(git Signed-off-by、DCO)。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `SIGNED-OFF` (規格ドキュメント BIND `SIGNED-OFF`) |
| TAG ID | `0x1E7L` |
| Codec ID | `0x00001E70` |
| 規格ドキュメント | `0x00000000/codecs/0x00001E70/` (DECLARE 対象 `1E70`) |
| セクション | 15 `1111` (Meta)、セクション内オフセット C = 7 |
| Kind | Meta · クラス: 検証 |
| TAG WORD | `0001 1110 0111 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | 貢献の権利の確認。Reference (git `Signed-off-by`、DCO) |
| Hugo 側 | `meta/verification/signed-off.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload フィールドの順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `signer` | #2 | レコード | 任意のレコード(プレースホルダを除く) |  |

貢献の権利の確認である(git `Signed-off-by`、DCO)。

## レイアウト {#레이아웃}

```
TAG WORD          0001 1110 0111 LLLL      Codec 0x1E7L
[Length 拡張 TAG]
Payload           Reference 1 つ
```

- Codec: Meta `0x1E7L`、検証クラス
- Payload: 埋め込み Reference
- 個数: 複数可

## 解釈と有効性 {#해석과-유효성}

- geul.org 公表ドキュメントには自然人を指す Reference を置かない([Issuer と公表](../issuer.md#geulorg-공표))。組織・Issuer を指す。例外として [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md) で自然人を指すことは許容する。

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00001E70/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E7000000000
BODY
#1 DECLARE 0x1E70
#2 FIELD #1 record
#3 BIND #1 "SIGNED-OFF"
#4 BIND #2 "signer"
```
