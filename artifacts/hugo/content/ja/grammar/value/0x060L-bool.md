---
title: "BOOL (0x060L)"
weight: 96
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "BOOL は論理値 false と true を表す Value である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `BOOL` (規格ドキュメント BIND `BOOL`) |
| TAG ID | `0x060L` |
| Codec ID | `0x00000600` |
| 規格ドキュメント | `0x00000000/codecs/0x00000600/` (DECLARE 対象 `0600`) |
| セクション | 3 `0011` (Value)、セクション内オフセット C = 0 |
| Kind | Value · 系列: NUMERIC |
| TAG WORD | `0000 0110 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引説明 | 固定 1 WORD の false または true |
| Hugo 側 | `value/numeric/bool.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `code` | #2 | 生値 1 WORD |  | `0x0000` false, `0x0001` true |

BOOL は論理値 false と true を表す Value である。Value 直接コード `0x060L`、系列 NUMERIC である。数値 0 と 1 を保持する SIGNED-INTEGER・UNSIGNED-INTEGER とは別の型である。

## レイアウト {#레이아웃}

```
TAG WORD          0x0601 (0000 0110 0000 0001)  全体 2 WORD
Payload           1 WORD  Boolean Code
```

## 解釈と有効性 {#해석과-유효성}

- Payload `0000` は false、`0001` は true である。
- padding や descriptor はない。
- Payload は正確に `0000` または `0001` である。それ以外の 16 ビット値は invalid として拒否する。
- 他の Length 表現はすべて invalid として拒否する。

## 長さ {#길이}

- 全体は TAG 1 WORD と Payload 1 WORD を合わせた正確に 2 WORD で、直接長 `LLLL=0001` を使う。Length 拡張 TAG、descriptor、padding はない。
- Payload が正確に 1 WORD でなければ拒否する。

## 例 {#예시}

| 全体レコード (TAG + Payload) | Payload | 判定 |
|---|---|---|
| `0601 0000` | `0000` | false、正規 |
| `0601 0001` | `0001` | true、正規 |
| `0601 0002` | `0002` | invalid |
| `0601 FFFF` | `FFFF` | invalid |
| Length が `0001` でない TAG + `0000` または `0001` | `0000` または `0001` | invalid |

## 形式の位置づけ {#형식-지위}

- `0000`/`0001` の 16 ビット code word と GEUL TAG を組み合わせたこの表現は、GEUL 固有の scalar profile である。
- 論理値自体は普遍的だが、この 1 WORD 表現に対応する単一の産業標準は主張しない。

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00000600/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000060000000000
BODY
#1 DECLARE 0x0600
#2 FIELD #1 0x0001
#3 ENUM #2 0x0000
#4 ENUM #2 0x0001
#5 BIND #1 "BOOL"
#6 BIND #2 "code"
#7 BIND #3 "false"
#8 BIND #4 "true"
```
