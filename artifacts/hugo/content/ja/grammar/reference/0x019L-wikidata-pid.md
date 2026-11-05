---
title: "WIKIDATA-PID (0x019L~0x01DL)"
weight: 25
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "WIKIDATA-PID は、Wikidata のプロパティ(Property)を指す宣言 Reference だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `WIKIDATA-PID` (5Q グループ。コードごとの名前は下のメンバー表) |
| TAG ID | `0x019L~0x01DL` |
| セクション | 0 `0000` (Reference エンティティ)、セクション内オフセット C = 25~29 |
| Kind | Reference · 分類: 宣言 |
| Hugo 側 | `reference/wikidata-pid.md` |

## メンバー {#구성원}

このページは 5Q 体系の 1 セット、コード 5 つをまとめて扱う。量化はセクション内オフセット `C % 5` だ([Reference](_index.md#quantifier))。Codec ドキュメントはコードごとに 1 つある。5 つの Codec ドキュメントはフィールドが同じで、DECLARE 対象と名前(BIND)だけが異なる。

| TAG ID | 名前 | 量化 | Codec ID | 規格ドキュメント | TAG WORD |
|---|---|---|---|---|---|
| `0x019L` | `WIKIDATA-PID-IDENTIFIED` | Identified | `0x00000190` | `0x00000000/codecs/0x00000190/` | `0000 0001 1001 LLLL` |
| `0x01AL` | `WIKIDATA-PID-GENERIC` | Generic | `0x000001A0` | `0x00000000/codecs/0x000001A0/` | `0000 0001 1010 LLLL` |
| `0x01BL` | `WIKIDATA-PID-FREE-CHOICE` | Free-choice | `0x000001B0` | `0x00000000/codecs/0x000001B0/` | `0000 0001 1011 LLLL` |
| `0x01CL` | `WIKIDATA-PID-UNIVERSAL` | Universal | `0x000001C0` | `0x00000000/codecs/0x000001C0/` | `0000 0001 1100 LLLL` |
| `0x01DL` | `WIKIDATA-PID-VARIABLE` | Variable | `0x000001D0` | `0x00000000/codecs/0x000001D0/` | `0000 0001 1101 LLLL` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順だ([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受け取る形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `pid` | #2 | 残り全部の生値(`0xFFFF`) |  |  |

WIKIDATA-PID は、Wikidata のプロパティ(Property)を指す宣言 Reference だ。P ID から `P` を除いた数字部分を符号なし整数で書く。

## レイアウト {#레이아웃}

```
TAG WORD          0000 0001 1001 LLLL      Codec 0x019L~0x01DL (Identified 0x019L)
[Length 拡張 TAG]
PID               最短幅の unsigned big-endian
```

- PID は最短幅で書く。現在のプロパティ番号は 1 WORD に収まり全体で 2 WORD であり、65535 を超えれば 3 WORD へ自然に伸びる。
- [TRIPLE](../edge/0x0AAL-triple.md) の Predicate、[QUALIFIER](../edge/0x0ABL-qualifier.md) の Property 位置に主に使う。

## 例 {#예시}

| プロパティ | WORD sequence |
|---|---|
| `P31` (instance of) | `0191 001F` |
| `P279` (subclass of) | `0191 0117` |
| `P569` (date of birth) | `0191 0239` |

## 関連ページ {#관련-페이지}

- [Reference](_index.md)、[WIKIDATA-QID](0x014L-wikidata-qid.md)、[TRIPLE](../edge/0x0AAL-triple.md)、[QUALIFIER](../edge/0x0ABL-qualifier.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00000190/latest.geul` を `geul show` で読んだ様子だ(16進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000019000000000
BODY
#1 DECLARE 0x0190
#2 FIELD #1 rest
#3 BIND #1 "WIKIDATA-PID-IDENTIFIED"
#4 BIND #2 "pid"
```

上は `WIKIDATA-PID-IDENTIFIED`(`0x019L`)の Codec ドキュメントだ。ほかのメンバー(`WIKIDATA-PID-GENERIC`、`WIKIDATA-PID-FREE-CHOICE`、`WIKIDATA-PID-UNIVERSAL`、`WIKIDATA-PID-VARIABLE`)の Codec ドキュメントは、DOC-ID の Codec ID、DECLARE 対象、`#1` に結んだ名前(BIND)だけが異なる。
