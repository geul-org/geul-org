---
title: "DEFAULT-LANGUAGE (0x1CAL)"
weight: 458
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "ドキュメントのテキストの既定言語を宣言する。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `DEFAULT-LANGUAGE` (規格ドキュメント BIND `DEFAULT-LANGUAGE`) |
| TAG ID | `0x1CAL` |
| Codec ID | `0x00001CA0` |
| 規格ドキュメント | `0x00000000/codecs/0x00001CA0/` (DECLARE 対象 `1CA0`) |
| セクション | 14 `1110` (Meta)、セクション内オフセット C = 10 |
| Kind | Meta · クラス: 定義 |
| TAG WORD | `0001 1100 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | 既定言語 |
| Hugo 側 | `meta/declaration/default-language.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload フィールドの順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `language` | #2 | レコード | `07A0` LANGUAGE-SHORT-CODE, `0760` LANGUAGE-BCP47-CODE-EVEN, `0770` LANGUAGE-BCP47-CODE-ODD |  |

ドキュメントのテキストの既定言語を宣言する。言語を別に記していないテキストはこの言語である。

## レイアウト {#레이아웃}

```
TAG WORD          0001 1100 1010 LLLL      Codec 0x1CAL
[Length 拡張 TAG]
Payload           言語 Value 1 つ
```

- Codec: Meta `0x1CAL`、定義クラス
- Payload: 埋め込み Value([LANGUAGE-BCP47-CODE](../value/0x076L-language-bcp47-code.md) または [LANGUAGE-SHORT-CODE](../value/0x07AL-language-short-code.md))
- 個数: 多くても 1 つ

## 解釈と有効性 {#해석과-유효성}

- TANGEUL ドキュメントは作成時のロケールを記す(例: `en`、`ko`)。

## 例 {#예시}

- `en`: `0x1CA2 0x0761 0x656E`

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00001CA0/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001CA000000000
BODY
#1 DECLARE 0x1CA0
#2 FIELD #1 record
#3 BIND #1 "DEFAULT-LANGUAGE"
#4 BIND #2 "language"
#5 CODEC #2 0x07A0
#6 CODEC #2 0x0760
#7 CODEC #2 0x0770
```
