---
title: "PRIVACY (0x1E0L)"
weight: 480
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "ドキュメントの個人情報等級を記す。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `PRIVACY` (規格ドキュメント BIND `PRIVACY`) |
| TAG ID | `0x1E0L` |
| Codec ID | `0x00001E00` |
| 規格ドキュメント | `0x00000000/codecs/0x00001E00/` (DECLARE 対象 `1E00`) |
| セクション | 15 `1111` (Meta)、セクション内オフセット C = 0 |
| Kind | Meta · クラス: ポリシー |
| TAG WORD | `0001 1110 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | 個人情報等級 |
| Hugo 側 | `meta/policy/privacy.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload フィールドの順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `level` | #2 | 生値 1 WORD |  |  |

ドキュメントの個人情報等級を記す。

## レイアウト {#레이아웃}

```
TAG WORD          0001 1110 0000 LLLL      Codec 0x1E0L
[Length 拡張 TAG]
等級              1 WORD
```

- Codec: Meta `0x1E0L`、ポリシークラス
- Payload: 生値(等級 1 WORD)
- 個数: 多くても 1 つ

## 解釈と有効性 {#해석과-유효성}

- 解釈を変えない。取り扱いだけを定める。

## 未解決の問題 {#열린-문제}

- 等級コード表(個人情報保護法の分類との対応)。

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00001E00/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E0000000000
BODY
#1 DECLARE 0x1E00
#2 FIELD #1 0x0001
#3 BIND #1 "PRIVACY"
#4 BIND #2 "level"
```
