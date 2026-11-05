---
title: "GEUL-SIDX (0x00FL~0x013L)"
weight: 15
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "GEUL-SIDX は、GEUL SIDX(Semantic-aligned Index)で対象を指す宣言 Reference だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `GEUL-SIDX` (5Q グループ。コードごとの名前は下のメンバー表) |
| TAG ID | `0x00FL~0x013L` |
| セクション | 0 `0000` (Reference エンティティ)、セクション内オフセット C = 15~19 |
| Kind | Reference · 分類: 宣言 |
| Hugo 側 | `reference/geul-sidx.md` |

## メンバー {#구성원}

このページは 5Q 体系の 1 セット、コード 5 つをまとめて扱う。量化はセクション内オフセット `C % 5` だ([Reference](_index.md#quantifier))。Codec ドキュメントはコードごとに 1 つある。5 つの Codec ドキュメントはフィールドが同じで、DECLARE 対象と名前(BIND)だけが異なる。

| TAG ID | 名前 | 量化 | Codec ID | 規格ドキュメント | TAG WORD |
|---|---|---|---|---|---|
| `0x00FL` | `GEUL-SIDX-IDENTIFIED` | Identified | `0x000000F0` | `0x00000000/codecs/0x000000F0/` | `0000 0000 1111 LLLL` |
| `0x010L` | `GEUL-SIDX-GENERIC` | Generic | `0x00000100` | `0x00000000/codecs/0x00000100/` | `0000 0001 0000 LLLL` |
| `0x011L` | `GEUL-SIDX-FREE-CHOICE` | Free-choice | `0x00000110` | `0x00000000/codecs/0x00000110/` | `0000 0001 0001 LLLL` |
| `0x012L` | `GEUL-SIDX-UNIVERSAL` | Universal | `0x00000120` | `0x00000000/codecs/0x00000120/` | `0000 0001 0010 LLLL` |
| `0x013L` | `GEUL-SIDX-VARIABLE` | Variable | `0x00000130` | `0x00000000/codecs/0x00000130/` | `0000 0001 0011 LLLL` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順だ([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受け取る形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `sidx` | #2 | 残り全部の生値(`0xFFFF`) |  |  |

GEUL-SIDX は、GEUL SIDX(Semantic-aligned Index)で対象を指す宣言 Reference だ。SIDX は、ビットそのものに意味(種類、属性)を持たせた識別子だ。

## レイアウト {#레이아웃}

```
TAG WORD          0000 0000 1111 LLLL      Codec 0x00FL~0x013L (Identified 0x00FL)
[Length 拡張 TAG]
SIDX              残り全部
```

- Quantifier はほかの宣言 Codec と同じだ。Variable ならその種類の匿名変数だ([Reference](_index.md) Variable)。量化は 5Q コード(`0x00FL~0x013L`、`C % 5`)だけで行う。SIDX の値には量化を入れない。
- 規格ドキュメントは SIDX を、残り幅の生値フィールド 1 つとして宣言する。幅の規則が決まれば変更する。

## 例 {#예시}

| SIDX | WORD sequence |
|---|---|
| (非規範) 64 ビット `0x1234 5678 9ABC DEF0`、Identified | `00F4 1234 5678 9ABC DEF0` |

## 割り当て方針 {#배정-방침}

- [GEUL](0x00AL-geul.md) とは役割が異なる。GEUL はおおむね順番に(auto increment)割り当てるアイデンティティ ID で、GEUL-SIDX は意味の近い対象に近い値を与える意味アドレスだ。
- 近さの度合いは、利用データを蓄積して統計で決める。統計がたまる前は GEUL ID を使い、SIDX を割り当てた後に、同じ対象の GEUL と GEUL-SIDX を [SAME-NODE](../edge/0x0A1L-same-node.md) で結ぶ。

## 未解決の問題 {#열린-문제}

- **幅。** 統計を見て決める。4 WORD(64 ビット)と 16 WORD などを検討している。SIDX は上位ビットに意味があるため、ほかの宣言 Codec の「最短幅」規則(先頭の `0x0000` 禁止)をそのまま使えない。したがって固定幅(またはサブフォーマットごとの固定幅)になるだろう。決まるまで、規格ドキュメントは SIDX を残り幅の生値として宣言する。
- **割り当ての安定性。** Reference は整数値が同じなら同じ対象であり、割り当てた ID は再利用しない。統計が変わっても、すでに割り当てた SIDX を動かさないためには、append-only の割り当て(意味の近い位置を空けておく疎な割り当て)が必要だ。動かす必要が頻繁に生じるなら、SIDX を恒久的な識別子ではなく、レジストリ版に結びついた索引として定義するかどうかを決める。
- **一意性。** SIDX がビットの意味から生成されて衝突しうるなら、「整数値が同じなら同じ対象」という前提と合わない。割り当て時に衝突を解消して一意性を保証する。
- コードブックとレジストリの公開形式。

## 関連ページ {#관련-페이지}

- [Reference](_index.md)、[GEUL](0x00AL-geul.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x000000F0/latest.geul` を `geul show` で読んだ様子だ(16進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000000F000000000
BODY
#1 DECLARE 0x00F0
#2 FIELD #1 rest
#3 BIND #1 "GEUL-SIDX-IDENTIFIED"
#4 BIND #2 "sidx"
```

上は `GEUL-SIDX-IDENTIFIED`(`0x00FL`)の Codec ドキュメントだ。ほかのメンバー(`GEUL-SIDX-GENERIC`、`GEUL-SIDX-FREE-CHOICE`、`GEUL-SIDX-UNIVERSAL`、`GEUL-SIDX-VARIABLE`)の Codec ドキュメントは、DOC-ID の Codec ID、DECLARE 対象、`#1` に結んだ名前(BIND)だけが異なる。
