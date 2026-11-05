---
title: "REPLACES (0x1D7L)"
weight: 471
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "書き直した対象バージョンのコンテンツハッシュを記す(git amend・rebase)。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `REPLACES` (規格ドキュメント BIND `REPLACES`) |
| TAG ID | `0x1D7L` |
| Codec ID | `0x00001D70` |
| 規格ドキュメント | `0x00000000/codecs/0x00001D70/` (DECLARE 対象 `1D70`) |
| セクション | 14 `1110` (Meta)、セクション内オフセット C = 23 |
| Kind | Meta · クラス: 系譜 |
| TAG WORD | `0001 1101 0111 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | 書き直した対象バージョンのコンテンツハッシュ (git amend・rebase)。元のバージョンは削除しない。 |
| Hugo 側 | `meta/lineage/replaces.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload フィールドの順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `digest` | #2 | レコード | `07C0` SHA-256-DIGEST |  |

書き直した対象バージョンのコンテンツハッシュを記す(git amend・rebase)。

## レイアウト {#레이아웃}

```
TAG WORD          0001 1101 0111 LLLL      Codec 0x1D7L
[Length 拡張 TAG]
Payload           SHA-256-DIGEST Value 1 つ (16 WORD)
```

- Codec: Meta `0x1D7L`、系譜クラス
- Payload: 埋め込み Value([SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md))
- 個数: 複数可

## 解釈と有効性 {#해석과-유효성}

- 元のバージョンは削除しない(旧法の保存)。
- ダイジェスト形式を Value として埋め込み、ハッシュアルゴリズムを変える余地を残す。現在のコンテンツハッシュは SHA-256 のみである。

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00001D70/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D7000000000
BODY
#1 DECLARE 0x1D70
#2 FIELD #1 record
#5 CODEC #2 0x07C0
#3 BIND #1 "REPLACES"
#4 BIND #2 "digest"
```
