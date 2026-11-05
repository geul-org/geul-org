---
title: "SAME-NODE (0x0A1L)"
weight: 161
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "SAME-NODE は、二つの Reference が同じ referent を指すと宣言する、方向のない同一性の叙述 Edge である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `SAME-NODE` (規格ドキュメント BIND `SAME-NODE`) |
| TAG ID | `0x0A1L` |
| Codec ID | `0x00000A10` |
| 規格ドキュメント | `0x00000000/codecs/0x00000A10/` (DECLARE 対象 `0A10`) |
| セクション | 5 `0101` (Edge 叙述)、セクション内オフセット C = 1 |
| Kind | Edge · 系列: 叙述、まとまり: 指示と名前 |
| TAG WORD | `0000 1010 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | 二つの Reference が同一の対象を指す同一性 |
| Hugo 側 | `edge/same-node.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順序である([Codec 規格ドキュメント](../codec-spec.md))。Edge の Edge Id は FIELD で宣言しない。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受け取る形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | レコード | 任意のレコード(プレースホルダを除く) |  |
| 2 | `object` | #3 | レコード | 任意のレコード(プレースホルダを除く) |  |

SAME-NODE は、二つの Reference が同じ referent を指すと宣言する、方向のない同一性の叙述 Edge である。Codec `0x0A1L`。

二つの Reference レコードの byte エンコーディング、Codec、ID が同じという意味ではない。[REFERENCE-NODE](0x0A0L-reference-node.md) が `Reference → レコード` の方向性バインディングであるのに対し、SAME-NODE は二つの Reference 間の同一性(referential identity)を表す。

## レイアウト {#레이아웃}

```
TAG WORD          0000 1010 0001 LLLL
[Length 拡張 TAG]
Edge Id           LOCAL Reference レコード
Subject           Reference レコード 1個
Object            Reference レコード 1個
```

## 解釈と有効性 {#해석과-유효성}

- Subject と Object はこの順序でシリアライズし、それぞれちょうど一つの完全な [Reference](../reference/_index.md) レコードでなければならない。各レコードの Length で境界を見つける。
- Subject や Object が Value、Edge、不完全なレコードであれば invalid である。
- SAME-NODE の関係は反射的・対称的・推移的である。wire 上の Subject/Object の順序は framing のためのものであり、意味の方向を作らない。実装はこの関係を双方向にたどれなければならない。
- 異なる [LOCAL](../reference/0x005L-local.md) ID は異なる Reference であるにすぎず、referent が同じまたは異なることの証拠ではない。二つの Reference が同じ referent を指すことは SAME-NODE で明らかにする。
- 解釈と推論は、その Edge を収めたドキュメントと判定グラフの出典、時点、world、policy scope を保存しなければならない。SAME-NODE を、文脈と無関係なグローバルなマージの根拠に使わない。
- SAME-NODE があっても、元の Reference レコードや系譜を消したり上書きしたりしない。
- 同じ対に SAME-NODE と [DIFFERENT-NODE](0x0A2L-different-node.md) が共存しても、wire が invalid になるわけではない。各主張の文脈を保存して衝突として評価する。
- Variable Reference を Identified Reference と SAME-NODE でつないで変数を解決する([Reference](../reference/_index.md) Variable)。

## 長さ {#길이}

```
全体 = 1 + N_len + N_id + N_subject + N_object WORD
```

## 例 (非規範) {#예시-비규범}

Edge Id は `0009`、Subject は LOCAL 1、Object は LOCAL 2 である。

- Edge は TAG 1 + Edge Id 2 + Subject 2 + Object 2 = 7 WORD、`LLLL=0110` である。TAG は `0000 1010 0001 0110` = `0A16` である。

```
0A16 0051 0009 0051 0001 0051 0002
```

## 関連ページ {#관련-페이지}

- [Edge](_index.md), [REFERENCE-NODE](0x0A0L-reference-node.md), [DIFFERENT-NODE](0x0A2L-different-node.md)
- [Reference](../reference/_index.md), [LOCAL](../reference/0x005L-local.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00000A10/latest.geul` を `geul show` で読んだ姿である(16進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A1000000000
BODY
#1 DECLARE 0x0A10
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "SAME-NODE"
#5 BIND #2 "subject"
#6 BIND #3 "object"
```
