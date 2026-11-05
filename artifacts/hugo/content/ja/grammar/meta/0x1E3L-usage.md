---
title: "USAGE (0x1E3L)"
weight: 483
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "使用制限を記す(例: 学習禁止、商用利用禁止)。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `USAGE` (規格ドキュメント BIND `USAGE`) |
| TAG ID | `0x1E3L` |
| Codec ID | `0x00001E30` |
| 規格ドキュメント | `0x00000000/codecs/0x00001E30/` (DECLARE 対象 `1E30`) |
| セクション | 15 `1111` (Meta)、セクション内オフセット C = 3 |
| Kind | Meta · クラス: ポリシー |
| TAG WORD | `0001 1110 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | 使用制限 |
| Hugo 側 | `meta/policy/usage.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload フィールドの順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `usage` | #2 | レコード | `000F` セクション 0 全体(ワイルドカード、Reference), `020F` セクション 1 全体(ワイルドカード、Reference), `040F` セクション 2 全体(ワイルドカード、Reference), `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD, `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT |  |

使用制限を記す(例: 学習禁止、商用利用禁止)。

## レイアウト {#레이아웃}

```
TAG WORD          0001 1110 0011 LLLL      Codec 0x1E3L
[Length 拡張 TAG]
Payload           使用制限を表すテキストまたは Reference
```

- Codec: Meta `0x1E3L`、ポリシークラス
- Payload: 埋め込み Value または Reference
- 個数: 複数可

## 未解決の問題 {#열린-문제}

- 制限の種類のコード表。

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00001E30/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E3000000000
BODY
#1 DECLARE 0x1E30
#2 FIELD #1 record
#3 BIND #1 "USAGE"
#4 BIND #2 "usage"
#5 CODEC #2 0x000F
#10 CODEC #2 0x020F
#11 CODEC #2 0x040F
#6 CODEC #2 0x0720
#7 CODEC #2 0x0730
#8 CODEC #2 0x0780
#9 CODEC #2 0x0790
```
