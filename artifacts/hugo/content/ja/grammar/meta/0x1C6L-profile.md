---
title: "PROFILE (0x1C6L)"
weight: 454
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "ドキュメントに適用したプロファイルを宣言する。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `PROFILE` (規格ドキュメント BIND `PROFILE`) |
| TAG ID | `0x1C6L` |
| Codec ID | `0x00001C60` |
| 規格ドキュメント | `0x00000000/codecs/0x00001C60/` (DECLARE 対象 `1C60`) |
| セクション | 14 `1110` (Meta)、セクション内オフセット C = 6 |
| Kind | Meta · クラス: 定義 |
| TAG WORD | `0001 1100 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | 適用プロファイル |
| Hugo 側 | `meta/declaration/profile.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload フィールドの順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `profile` | #2 | レコード | `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD |  |

ドキュメントに適用したプロファイルを宣言する。同じレコードを、プロファイルが定める Codec ドキュメントで解釈する(例: `tangeul-1.0` なら [TOULMIN](../toulmin/_index.md))。

## レイアウト {#레이아웃}

```
TAG WORD          0001 1100 0110 LLLL      Codec 0x1C6L
[Length 拡張 TAG]
Payload           UTF8-TEXT Value "<名前>-<major>.<minor>"
```

- Codec: Meta `0x1C6L`、定義クラス
- Payload: 埋め込み Value([UTF8-TEXT](../value/0x072L-utf8-text.md))
- 個数: 多くても 1 つ

## 解釈と有効性 {#해석과-유효성}

- major が異なるプロファイルは拒否する。minor の違いは許容する(追加の変更のみ)。
- プロファイルがなければ、GEUL の基本文法と直接コードの規格のみで読む。

## 例 {#예시}

- `tangeul-1.0`: `0x1C67 0x0736 7461 6E67 6575 6C2D 312E 3000`

## 未解決の問題 {#열린-문제}

- プロファイル名レジストリ(geul.org)と名前の規則。
- プロファイルをドキュメント ID で指す(IMPORT)か、テキストで置くか。

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00001C60/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C6000000000
BODY
#1 DECLARE 0x1C60
#2 FIELD #1 record
#3 BIND #1 "PROFILE"
#4 BIND #2 "profile"
#5 CODEC #2 0x0720
#6 CODEC #2 0x0730
```
