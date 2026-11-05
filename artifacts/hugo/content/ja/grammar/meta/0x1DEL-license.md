---
title: "LICENSE (0x1DEL)"
weight: 478
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "このドキュメントとバイト列内の著作物のライセンスを記す。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `LICENSE` (規格ドキュメント BIND `LICENSE`) |
| TAG ID | `0x1DEL` |
| Codec ID | `0x00001DE0` |
| 規格ドキュメント | `0x00000000/codecs/0x00001DE0/` (DECLARE 対象 `1DE0`) |
| セクション | 14 `1110` (Meta)、セクション内オフセット C = 30 |
| Kind | Meta · クラス: ポリシー |
| TAG WORD | `0001 1101 1110 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | ライセンス。Reference |
| Hugo 側 | `meta/policy/license.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload フィールドの順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `license` | #2 | レコード | `000F` セクション 0 全体(ワイルドカード、Reference), `020F` セクション 1 全体(ワイルドカード、Reference), `040F` セクション 2 全体(ワイルドカード、Reference), `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD, `0740` URI-EVEN, `0750` URI-ODD |  |

このドキュメントとバイト列内の著作物のライセンスを記す。

## レイアウト {#레이아웃}

```
TAG WORD          0001 1101 1110 LLLL      Codec 0x1DEL
[Length 拡張 TAG]
Payload           ライセンスを指す Reference、または SPDX 識別子の UTF8-TEXT、または URI Value
```

- Codec: Meta `0x1DEL`、ポリシークラス
- Payload: 埋め込み Reference または Value([UTF8-TEXT](../value/0x072L-utf8-text.md)、[URI](../value/0x074L-uri.md))
- 個数: 多くても 1 つ

## 解釈と有効性 {#해석과-유효성}

- geul.org 公表ドキュメントは CC0 である。私設の公表は Issuer が定める([Issuer](../issuer.md))。
- 原典の著作物の元のライセンスを記録する。

## 未解決の問題 {#열린-문제}

- SPDX 識別子をテキストで置くか、GEUL エンティティの Reference で置くか。

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00001DE0/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DE000000000
BODY
#1 DECLARE 0x1DE0
#2 FIELD #1 record
#3 BIND #1 "LICENSE"
#4 BIND #2 "license"
#5 CODEC #2 0x000F
#10 CODEC #2 0x020F
#11 CODEC #2 0x040F
#6 CODEC #2 0x0720
#7 CODEC #2 0x0730
#8 CODEC #2 0x0740
#9 CODEC #2 0x0750
```
