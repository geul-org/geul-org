---
title: "CONFIDENCE (0x1E8L)"
weight: 488
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "ドキュメント全体の信頼度を記す。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `CONFIDENCE` (規格ドキュメント BIND `CONFIDENCE`) |
| TAG ID | `0x1E8L` |
| Codec ID | `0x00001E80` |
| 規格ドキュメント | `0x00000000/codecs/0x00001E80/` (DECLARE 対象 `1E80`) |
| セクション | 15 `1111` (Meta)、セクション内オフセット C = 8 |
| Kind | Meta · クラス: 検証 |
| TAG WORD | `0001 1110 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | 信頼度 |
| Hugo 側 | `meta/verification/confidence.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload フィールドの順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `confidence` | #2 | レコード | `0690` UNSIGNED-DECIMAL |  |

ドキュメント全体の信頼度を記す。レコード単位の信頼度は、対象 Edge に付く QUALIFIER で書く(属性は未定、[SOURCE](../edge/0x0C0L-source.md#다른-근거의-표현))。

## レイアウト {#레이아웃}

```
TAG WORD          0001 1110 1000 LLLL      Codec 0x1E8L
[Length 拡張 TAG]
Payload           UNSIGNED-DECIMAL Value、0 以上 1 以下
```

- Codec: Meta `0x1E8L`、検証クラス
- Payload: 埋め込み Value([UNSIGNED-DECIMAL](../value/0x069L-unsigned-decimal.md))
- 個数: 多くても 1 つ

## 解釈と有効性 {#해석과-유효성}

- 誰が付けた値かは、[GENERATED-BY](0x1D3L-generated-by.md) などで併せて記す。

## 未解決の問題 {#열린-문제}

- 尺度(0~1)と TOULMIN の判定との関係。

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00001E80/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E8000000000
BODY
#1 DECLARE 0x1E80
#2 FIELD #1 record
#5 CODEC #2 0x0690
#3 BIND #1 "CONFIDENCE"
#4 BIND #2 "confidence"
```
