---
title: "PARENT (0x1D1L)"
weight: 465
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "直前のバージョンのコンテンツハッシュを記す(git parent)。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `PARENT` (規格ドキュメント BIND `PARENT`) |
| TAG ID | `0x1D1L` |
| Codec ID | `0x00001D10` |
| 規格ドキュメント | `0x00000000/codecs/0x00001D10/` (DECLARE 対象 `1D10`) |
| セクション | 14 `1110` (Meta)、セクション内オフセット C = 17 |
| Kind | Meta · クラス: 系譜 |
| TAG WORD | `0001 1101 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | 直前のバージョンのコンテンツハッシュ (git parent)。なければ最初のバージョンであり、複数あればマージである(git merge commit)。 |
| Hugo 側 | `meta/lineage/parent.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload フィールドの順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `digest` | #2 | レコード | `07C0` SHA-256-DIGEST |  |

直前のバージョンのコンテンツハッシュを記す(git parent)。

## レイアウト {#레이아웃}

```
TAG WORD          0001 1101 0001 LLLL      Codec 0x1D1L
[Length 拡張 TAG]
Payload           SHA-256-DIGEST Value 1 つ (16 WORD)
```

- Codec: Meta `0x1D1L`、系譜クラス
- Payload: 埋め込み Value([SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md))
- 個数: 複数可(マージ)

## 解釈と有効性 {#해석과-유효성}

- なければ最初のバージョンであり、複数あればマージである(git merge commit)。
- [コンテンツハッシュ](../document.md#내용-해시)に入るので、履歴全体がハッシュチェーンになる。
- バージョン一覧ドキュメントは直前の一覧ドキュメントを指す([PUBLICATION](../edge/0x0B8L-publication.md))。
- ダイジェスト形式を Value として埋め込み、ハッシュアルゴリズムを変える余地を残す。現在のコンテンツハッシュは SHA-256 のみである。

## 例 {#예시}

- `0x1D1E 0x0014 0x07CE 0x0012 <16 WORD>` (Meta 20 WORD = TAG + Length 拡張 + 埋め込み Value 18 WORD)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00001D10/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D1000000000
BODY
#1 DECLARE 0x1D10
#2 FIELD #1 record
#5 CODEC #2 0x07C0
#3 BIND #1 "PARENT"
#4 BIND #2 "digest"
```
