---
title: "SPEC-VERSION (0x1C5L)"
weight: 453
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "ドキュメントが従う GEUL 仕様の版を宣言する。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `SPEC-VERSION` (規格ドキュメント BIND `SPEC-VERSION`) |
| TAG ID | `0x1C5L` |
| Codec ID | `0x00001C50` |
| 規格ドキュメント | `0x00000000/codecs/0x00001C50/` (DECLARE 対象 `1C50`) |
| セクション | 14 `1110` (Meta)、セクション内オフセット C = 5 |
| Kind | Meta · クラス: 定義 |
| TAG WORD | `0001 1100 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | 従う GEUL 仕様の版。Payload がそのまま最も短い幅の unsigned 整数である。v1 は `0x0001` (レコード `0x1C51 0x0001`) |
| Hugo 側 | `meta/declaration/spec-version.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload フィールドの順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `version` | #2 | 残り生値(`0xFFFF`) |  |  |

ドキュメントが従う GEUL 仕様の版を宣言する。残りのレコードをどう読むかはこの値が決める。

## レイアウト {#레이아웃}

```
TAG WORD          0001 1100 0101 LLLL      Codec 0x1C5L
[Length 拡張 TAG]
Payload           仕様の版。v1 = 0x0001
```

- Codec: Meta `0x1C5L`、定義クラス
- Payload: 生値(最も短い幅の unsigned 整数)
- 個数: 多くても 1 つ

## 解釈と有効性 {#해석과-유효성}

- Value コードに依存しない。どの版のデコーダでも読めるよう、埋め込み Value なしで整数のみを置く。
- 知らない版であれば、デコーダは拒否するか警告する。
- なければ、デコーダが知っている版として読む。公表ドキュメントは記す。

## 例 {#예시}

- `0x1C51 0x0001`: GEUL v1

## 未解決の問題 {#열린-문제}

- Codec ブックのドキュメントバージョンとの対応([規格ドキュメント](../codec-spec.md))。

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00001C50/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C5000000000
BODY
#1 DECLARE 0x1C50
#2 FIELD #1 rest
#3 BIND #1 "SPEC-VERSION"
#4 BIND #2 "version"
```
