---
title: "EXTERNAL-ISSUER-16WORD (0x039L~0x03DL)"
weight: 57
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "EXTERNAL-ISSUER は、Issuer が公表したドキュメントの LOCAL ID を、IMPORT なしにレコード 1 つで引用する指示宣言 Reference だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXTERNAL-ISSUER は、Issuer が公表したドキュメントの LOCAL ID を、IMPORT なしにレコード 1 つで引用する指示宣言 Reference だ。

| 項目 | 値 |
|---|---|
| 名前 | `EXTERNAL-ISSUER-16WORD` (5Q グループ。コードごとの名前は下のメンバー表) |
| TAG ID | `0x039L~0x03DL` |
| セクション | 1 `0001` (Reference EXTERNAL)、セクション内オフセット C = 25~29 |
| Kind | Reference · 分類: 指示宣言 |
| Hugo 側 | `reference/external-issuer.md` (そのページは [EXTERNAL-ISSUER-2WORD](0x02FL-external-issuer-2word.md)、[EXTERNAL-ISSUER-4WORD](0x034L-external-issuer-4word.md) もまとめて扱う) |

## メンバー {#구성원}

このページは 5Q 体系の 1 セット、コード 5 つをまとめて扱う。量化はセクション内オフセット `C % 5` だ([Reference](_index.md#quantifier))。Codec ドキュメントはコードごとに 1 つある。5 つの Codec ドキュメントはフィールドが同じで、DECLARE 対象と名前(BIND)だけが異なる。

| TAG ID | 名前 | 量化 | Codec ID | 規格ドキュメント | TAG WORD |
|---|---|---|---|---|---|
| `0x039L` | `EXTERNAL-ISSUER-16WORD-IDENTIFIED` | Identified | `0x00000390` | `0x00000000/codecs/0x00000390/` | `0000 0011 1001 LLLL` |
| `0x03AL` | `EXTERNAL-ISSUER-16WORD-GENERIC` | Generic | `0x000003A0` | `0x00000000/codecs/0x000003A0/` | `0000 0011 1010 LLLL` |
| `0x03BL` | `EXTERNAL-ISSUER-16WORD-FREE-CHOICE` | Free-choice | `0x000003B0` | `0x00000000/codecs/0x000003B0/` | `0000 0011 1011 LLLL` |
| `0x03CL` | `EXTERNAL-ISSUER-16WORD-UNIVERSAL` | Universal | `0x000003C0` | `0x00000000/codecs/0x000003C0/` | `0000 0011 1100 LLLL` |
| `0x03DL` | `EXTERNAL-ISSUER-16WORD-VARIABLE` | Variable | `0x000003D0` | `0x00000000/codecs/0x000003D0/` | `0000 0011 1101 LLLL` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順だ([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受け取る形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | 生値 16 WORD |  |  |
| 2 | `doc` | #3 | 生値 4 WORD |  |  |
| 3 | `target-id` | #4 | 残り全部の生値(`0xFFFF`) |  |  |

EXTERNAL-ISSUER は、Issuer が公表したドキュメントの LOCAL ID を IMPORT なしに引用する指示宣言 Reference だ。レコード 1 つで意味が完結し、最新バージョンに従う。

## レイアウト {#레이아웃}

```
TAG WORD          0000 001C CCCC LLLL      Codec 0x02FL~0x03DL (セクション 1)
[Length 拡張 TAG]
Issuer            Codec が定める幅 (2/4/16 WORD)
ドキュメント ID   4 WORD
対象 ID           残り全部。そのドキュメントの LOCAL ID、最短幅
```

| Codec (Identified, Generic, Free-choice, Universal, Variable) | 名前 | Issuer 幅 |
|---|---|---|
| `0x02FL~0x033L` | EXTERNAL-ISSUER-2WORD | 2 WORD (geul.org 登録、ドメイン証明) |
| `0x034L~0x038L` | EXTERNAL-ISSUER-4WORD | 4 WORD (geul.org 登録、証明なし) |
| `0x039L~0x03DL` | EXTERNAL-ISSUER-16WORD | 16 WORD (公開鍵から計算) |

- 幅は体系番号で決まる: 体系 − 9(セクション内オフセット `C` の `C / 5 − 3`)が 0、1、2 なら 2、4、16 WORD だ。量化は `C % 5` だ。
- Issuer ID は整数値だ。値が同じなら同じ Issuer だ。Issuer は値が収まる最短幅で書き、その幅の Codec を選ぶ(`2^32` 以上のときだけ 4 WORD、`2^64` 以上のときだけ 16 WORD)。より広い幅の表記は invalid だ([Issuer](../issuer.md))。
- Issuer の登録と管理は geul.org が担う。
- バージョンは書かず、最新バージョンに従う。バージョンを固定するには [IMPORT-DOC](../meta/0x1E4L-import-doc.md) と [EXTERNAL-POINTER](0x020L-external-pointer-1word.md) を使う。
- 場所は公表アドレスの規則で見つける([公表アドレスとバージョン一覧](../publishing.md))。
- そのドキュメントの同じ LOCAL ID なら、そのドキュメント内で LOCAL として書いても、別のドキュメントで EXTERNAL-ISSUER として書いても(または IMPORT の後に EXTERNAL-POINTER として書いても)同じ対象だ。
- ドキュメントの LOCAL だけを指す。ドキュメント自身は [DOC-POINTER](0x041L-doc-pointer.md)、Issuer 自身は [ISSUER-POINTER](0x040L-issuer-pointer.md) で指す。したがって対象 ID は `0` ではない。ドキュメント ID `0` は Issuer の用語定義索引ドキュメントだ。

## 有効性 {#유효성}

- Issuer 幅が Codec と合わない、または値がより狭い幅に収まるなら invalid だ。
- 対象 ID が `0` なら invalid だ。対象 ID `0`(ドキュメント自身)は DOC-POINTER が担う。
- 対象 ID の先頭の `0x0000` WORD は禁止する。

## 例 {#예시}

| 対象 | WORD sequence |
|---|---|
| Issuer `0x00000002`、ドキュメント `0x…0002`、LOCAL 7 | `02F7 0000 0002 0000 0000 0000 0002 0007` |
| Issuer `0x00012345`、ドキュメント `0x…0002`、LOCAL 7 | `02F7 0001 2345 0000 0000 0000 0002 0007` |

## 関連ページ {#관련-페이지}

- [Reference](_index.md)、[DOC-POINTER](0x041L-doc-pointer.md)、[ISSUER-POINTER](0x040L-issuer-pointer.md)、[EXTERNAL-POINTER](0x020L-external-pointer-1word.md)
- [Issuer と公表](../issuer.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00000390/latest.geul` を `geul show` で読んだ様子だ(16進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000039000000000
BODY
#1 DECLARE 0x0390
#2 FIELD #1 0x0010
#3 FIELD #1 0x0004
#4 FIELD #1 rest
#5 BIND #1 "EXTERNAL-ISSUER-16WORD-IDENTIFIED"
#6 BIND #2 "issuer"
#7 BIND #3 "doc"
#8 BIND #4 "target-id"
```

上は `EXTERNAL-ISSUER-16WORD-IDENTIFIED`(`0x039L`)の Codec ドキュメントだ。ほかのメンバー(`EXTERNAL-ISSUER-16WORD-GENERIC`、`EXTERNAL-ISSUER-16WORD-FREE-CHOICE`、`EXTERNAL-ISSUER-16WORD-UNIVERSAL`、`EXTERNAL-ISSUER-16WORD-VARIABLE`)の Codec ドキュメントは、DOC-ID の Codec ID、DECLARE 対象、`#1` に結んだ名前(BIND)だけが異なる。
