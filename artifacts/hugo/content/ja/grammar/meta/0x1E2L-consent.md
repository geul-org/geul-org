---
title: "CONSENT (0x1E2L)"
weight: 482
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "同意の範囲と根拠を記す。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `CONSENT` (規格ドキュメント BIND `CONSENT`) |
| TAG ID | `0x1E2L` |
| Codec ID | `0x00001E20` |
| 規格ドキュメント | `0x00000000/codecs/0x00001E20/` (DECLARE 対象 `1E20`) |
| セクション | 15 `1111` (Meta)、セクション内オフセット C = 2 |
| Kind | Meta · クラス: ポリシー |
| TAG WORD | `0001 1110 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | 同意の範囲と根拠 |
| Hugo 側 | `meta/policy/consent.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload フィールドの順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `consent` | #2 | レコード | `000F` セクション 0 全体(ワイルドカード、Reference), `020F` セクション 1 全体(ワイルドカード、Reference), `040F` セクション 2 全体(ワイルドカード、Reference), `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD, `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT |  |

同意の範囲と根拠を記す。

## レイアウト {#레이아웃}

```
TAG WORD          0001 1110 0010 LLLL      Codec 0x1E2L
[Length 拡張 TAG]
Payload           同意の根拠を指す Reference またはテキスト
```

- Codec: Meta `0x1E2L`、ポリシークラス
- Payload: 埋め込み Reference または Value
- 個数: 複数可

## 未解決の問題 {#열린-문제}

- 範囲の表現(目的・期間・第三者提供)の構造。

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00001E20/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E2000000000
BODY
#1 DECLARE 0x1E20
#2 FIELD #1 record
#3 BIND #1 "CONSENT"
#4 BIND #2 "consent"
#5 CODEC #2 0x000F
#10 CODEC #2 0x020F
#11 CODEC #2 0x040F
#6 CODEC #2 0x0720
#7 CODEC #2 0x0730
#8 CODEC #2 0x0780
#9 CODEC #2 0x0790
```
