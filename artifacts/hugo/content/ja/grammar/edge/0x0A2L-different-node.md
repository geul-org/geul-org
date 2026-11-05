---
title: "DIFFERENT-NODE (0x0A2L)"
weight: 162
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DIFFERENT-NODE は、二つの Reference が互いに異なる referent を指すという非同一性の叙述 Edge である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `DIFFERENT-NODE` (規格ドキュメント BIND `DIFFERENT-NODE`) |
| TAG ID | `0x0A2L` |
| Codec ID | `0x00000A20` |
| 規格ドキュメント | `0x00000000/codecs/0x00000A20/` (DECLARE 対象 `0A20`) |
| セクション | 5 `0101` (Edge 叙述)、セクション内オフセット C = 2 |
| Kind | Edge · 系列: 叙述、まとまり: 指示と名前 |
| TAG WORD | `0000 1010 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | 二つの Reference が互いに異なる対象を指す非同一性 |
| Hugo 側 | `edge/different-node.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順序である([Codec 規格ドキュメント](../codec-spec.md))。Edge の Edge Id は FIELD で宣言しない。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受け取る形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | レコード | 任意のレコード(プレースホルダを除く) |  |
| 2 | `object` | #3 | レコード | 任意のレコード(プレースホルダを除く) |  |

DIFFERENT-NODE は、二つの Reference が互いに異なる referent を指すという非同一性の叙述 Edge である。Codec `0x0A2L`。

二つの Reference レコードの byte エンコーディング、Codec、ID が異なるという意味ではない。[REFERENCE-NODE](0x0A0L-reference-node.md) の方向性バインディング、[SAME-NODE](0x0A1L-same-node.md) の同一性と区別する。

## レイアウト {#레이아웃}

```
TAG WORD          0000 1010 0010 LLLL
[Length 拡張 TAG]
Edge Id           LOCAL Reference レコード
Subject           Reference レコード 1個
Object            Reference レコード 1個
```

## 解釈と有効性 {#해석과-유효성}

- Subject と Object はそれぞれちょうど一つの完全な [Reference](../reference/_index.md) レコードでなければならない。各レコードの Length で境界を見つけ、Value や Edge である、または不完全であれば invalid である。
- Subject と Object は互いに異なる referent を指す。Reference レコードの byte 列、Codec、ID の違いだけで referent が異なると推論しない。
- 特に異なる [LOCAL](../reference/0x005L-local.md) ID は異なる Reference であるにすぎず、現実の referent まで異なるという意味ではない。LOCAL ID の違いだけで DIFFERENT を導かない。
- 非同一性は対称的で非反射的であり、推移的ではない。`DIFFERENT(A, B)` は `DIFFERENT(B, A)` と同じ関係である。ただし `DIFFERENT(A, B)` と `DIFFERENT(B, C)` から `DIFFERENT(A, C)` を推論しない。
- wire 上の Subject/Object の順序は framing のためのシリアライズ順序にすぎず、意味の方向を作らない。実装は双方向にたどれなければならない。
- 二つの構成要素を読み終えたカーソルは、Edge の終端とちょうど一致しなければならない。

関係自体は非反射的だが、構造的に valid な `DIFFERENT(A, A)` の主張や、SAME と DIFFERENT が衝突する主張を、wire の文法エラーとして消してはならない。このような主張は文脈と系譜を保存し、判定層で矛盾として扱う。DIFFERENT を解釈したり導いたりするときは、その Edge を収めたドキュメントの出典、時点、world、policy scope を保存し、これを無視したグローバルな結論へ広げない。

## 長さ {#길이}

```
全体 = 1 + N_len + N_id + N_subject + N_object WORD
```

## 例 (非規範) {#예시-비규범}

Edge Id は `000A`、Subject は LOCAL 1、Object は LOCAL 2 である。

- Edge は TAG 1 + Edge Id 2 + Subject 2 + Object 2 = 7 WORD、`LLLL=0110` である。TAG は `0000 1010 0010 0110` = `0A26` である。

```
0A26 0051 000A 0051 0001 0051 0002
```

この例の LOCAL ID の違いは、エンコーディングを示すためのものにすぎない。ID 1 と ID 2 が互いに異なる referent を指すという主張が別にあるときにのみ、この sequence を DIFFERENT-NODE にする。

## 関連ページ {#관련-페이지}

- [Edge](_index.md), [REFERENCE-NODE](0x0A0L-reference-node.md), [SAME-NODE](0x0A1L-same-node.md)
- [Reference](../reference/_index.md), [LOCAL](../reference/0x005L-local.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00000A20/latest.geul` を `geul show` で読んだ姿である(16進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A2000000000
BODY
#1 DECLARE 0x0A20
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "DIFFERENT-NODE"
#5 BIND #2 "subject"
#6 BIND #3 "object"
```
