---
title: "WIKIDATA-QID (0x014L~0x018L)"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "WIKIDATA-QID は、Wikidata のアイテム(Item)を指す宣言 Reference だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `WIKIDATA-QID` (5Q グループ。コードごとの名前は下のメンバー表) |
| TAG ID | `0x014L~0x018L` |
| セクション | 0 `0000` (Reference エンティティ)、セクション内オフセット C = 20~24 |
| Kind | Reference · 分類: 宣言 |
| Hugo 側 | `reference/wikidata-qid.md` |

## メンバー {#구성원}

このページは 5Q 体系の 1 セット、コード 5 つをまとめて扱う。量化はセクション内オフセット `C % 5` だ([Reference](_index.md#quantifier))。Codec ドキュメントはコードごとに 1 つある。5 つの Codec ドキュメントはフィールドが同じで、DECLARE 対象と名前(BIND)だけが異なる。

| TAG ID | 名前 | 量化 | Codec ID | 規格ドキュメント | TAG WORD |
|---|---|---|---|---|---|
| `0x014L` | `WIKIDATA-QID-IDENTIFIED` | Identified | `0x00000140` | `0x00000000/codecs/0x00000140/` | `0000 0001 0100 LLLL` |
| `0x015L` | `WIKIDATA-QID-GENERIC` | Generic | `0x00000150` | `0x00000000/codecs/0x00000150/` | `0000 0001 0101 LLLL` |
| `0x016L` | `WIKIDATA-QID-FREE-CHOICE` | Free-choice | `0x00000160` | `0x00000000/codecs/0x00000160/` | `0000 0001 0110 LLLL` |
| `0x017L` | `WIKIDATA-QID-UNIVERSAL` | Universal | `0x00000170` | `0x00000000/codecs/0x00000170/` | `0000 0001 0111 LLLL` |
| `0x018L` | `WIKIDATA-QID-VARIABLE` | Variable | `0x00000180` | `0x00000000/codecs/0x00000180/` | `0000 0001 1000 LLLL` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順だ([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受け取る形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `qid` | #2 | 残り全部の生値(`0xFFFF`) |  |  |

WIKIDATA-QID は、Wikidata のアイテム(Item)を指す宣言 Reference だ。Q ID から `Q` を除いた数字部分を符号なし整数で書く。

## レイアウト {#레이아웃}

```
TAG WORD          0000 0001 0100 LLLL      Codec 0x014L~0x018L (Identified 0x014L)
[Length 拡張 TAG]
QID               最短幅の unsigned big-endian
```

- QID は最短幅で書く。`Q1`~`Q65535` は全体で 2 WORD、それより上は 3 WORD だ。
- Wikidata のデータは CC0 だ。
- Variable ならそのアイテムが指す種類の匿名変数だ([Reference](_index.md) Variable)。

## 例 {#예시}

| 項目 | WORD sequence |
|---|---|
| `Q5` (human) | `0141 0005` |
| `Q76` (Barack Obama) | `0141 004C` |
| `Q884` (South Korea) | `0141 0374` |
| `Q317521` (Elon Musk) | `0142 0004 D851` |
| `Q30461` (president), Variable | `0181 76FD` |

## 関連ページ {#관련-페이지}

- [Reference](_index.md)、[WIKIDATA-PID](0x019L-wikidata-pid.md)、[TRIPLE](../edge/0x0AAL-triple.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00000140/latest.geul` を `geul show` で読んだ様子だ(16進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000014000000000
BODY
#1 DECLARE 0x0140
#2 FIELD #1 rest
#3 BIND #1 "WIKIDATA-QID-IDENTIFIED"
#4 BIND #2 "qid"
```

上は `WIKIDATA-QID-IDENTIFIED`(`0x014L`)の Codec ドキュメントだ。ほかのメンバー(`WIKIDATA-QID-GENERIC`、`WIKIDATA-QID-FREE-CHOICE`、`WIKIDATA-QID-UNIVERSAL`、`WIKIDATA-QID-VARIABLE`)の Codec ドキュメントは、DOC-ID の Codec ID、DECLARE 対象、`#1` に結んだ名前(BIND)だけが異なる。
