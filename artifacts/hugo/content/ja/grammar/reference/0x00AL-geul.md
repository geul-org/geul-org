---
title: "GEUL (0x00AL~0x00EL)"
weight: 10
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "GEUL は、geul.org が CC0 で発行するエンティティを指す宣言 Reference だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `GEUL` (5Q グループ。コードごとの名前は下のメンバー表) |
| TAG ID | `0x00AL~0x00EL` |
| セクション | 0 `0000` (Reference エンティティ)、セクション内オフセット C = 10~14 |
| Kind | Reference · 分類: 宣言 |
| Hugo 側 | `reference/geul.md` |

## メンバー {#구성원}

このページは 5Q 体系の 1 セット、コード 5 つをまとめて扱う。量化はセクション内オフセット `C % 5` だ([Reference](_index.md#quantifier))。Codec ドキュメントはコードごとに 1 つある。5 つの Codec ドキュメントはフィールドが同じで、DECLARE 対象と名前(BIND)だけが異なる。

| TAG ID | 名前 | 量化 | Codec ID | 規格ドキュメント | TAG WORD |
|---|---|---|---|---|---|
| `0x00AL` | `GEUL-IDENTIFIED` | Identified | `0x000000A0` | `0x00000000/codecs/0x000000A0/` | `0000 0000 1010 LLLL` |
| `0x00BL` | `GEUL-GENERIC` | Generic | `0x000000B0` | `0x00000000/codecs/0x000000B0/` | `0000 0000 1011 LLLL` |
| `0x00CL` | `GEUL-FREE-CHOICE` | Free-choice | `0x000000C0` | `0x00000000/codecs/0x000000C0/` | `0000 0000 1100 LLLL` |
| `0x00DL` | `GEUL-UNIVERSAL` | Universal | `0x000000D0` | `0x00000000/codecs/0x000000D0/` | `0000 0000 1101 LLLL` |
| `0x00EL` | `GEUL-VARIABLE` | Variable | `0x000000E0` | `0x00000000/codecs/0x000000E0/` | `0000 0000 1110 LLLL` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順だ([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受け取る形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `geul-id` | #2 | 残り全部の生値(`0xFFFF`) |  |  |

GEUL は、geul.org が CC0 で発行するエンティティを指す宣言 Reference だ。番号に意味を持たせない連番 ID だ。ビットに意味を持たせる識別子は、別の Codec [GEUL-SIDX](0x00FL-geul-sidx.md)(`0x00FL~0x013L`)が担う。

## レイアウト {#레이아웃}

```
TAG WORD          0000 0000 1010 LLLL      Codec 0x00AL~0x00EL (Identified 0x00AL)
[Length 拡張 TAG]
GEUL ID           最短幅の unsigned big-endian
```

- 小さい番号を高頻度のエンティティに割り当てる。1 WORD に収まる ID は全体で 2 WORD だ。
- ID の割り当てとレジストリは geul.org が管理する。レジストリには CC0 の原典から出たものだけを入れる。
- Variable ならその種類の匿名変数だ([Reference](_index.md) Variable)。

## 例 {#예시}

| GEUL ID | WORD sequence |
|---|---|
| 1, Identified | `00A1 0001` |
| 1, Variable | `00E1 0001` |
| 70000, Generic | `00B2 0001 1170` |

## 未解決の問題 {#열린-문제}

- GEUL ID の割り当て規則とレジストリの公開形式。

## 関連ページ {#관련-페이지}

- [Reference](_index.md)、[GEUL-SIDX](0x00FL-geul-sidx.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x000000A0/latest.geul` を `geul show` で読んだ様子だ(16進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000000A000000000
BODY
#1 DECLARE 0x00A0
#2 FIELD #1 rest
#3 BIND #1 "GEUL-IDENTIFIED"
#4 BIND #2 "geul-id"
```

上は `GEUL-IDENTIFIED`(`0x00AL`)の Codec ドキュメントだ。ほかのメンバー(`GEUL-GENERIC`、`GEUL-FREE-CHOICE`、`GEUL-UNIVERSAL`、`GEUL-VARIABLE`)の Codec ドキュメントは、DOC-ID の Codec ID、DECLARE 対象、`#1` に結んだ名前(BIND)だけが異なる。
