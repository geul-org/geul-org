---
title: "EXTERNAL-POINTER-4WORD (0x02AL~0x02EL)"
weight: 42
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "EXTERNAL-POINTER は、HEAD の IMPORT-DOC で取り込んだドキュメントの LOCAL ID を指す指示 Reference だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXTERNAL-POINTER は、HEAD の IMPORT-DOC で取り込んだドキュメントの LOCAL ID を指す指示 Reference だ。

| 項目 | 値 |
|---|---|
| 名前 | `EXTERNAL-POINTER-4WORD` (5Q グループ。コードごとの名前は下のメンバー表) |
| TAG ID | `0x02AL~0x02EL` |
| セクション | 1 `0001` (Reference EXTERNAL)、セクション内オフセット C = 10~14 |
| Kind | Reference · 分類: 指示 |
| Hugo 側 | `reference/external-pointer.md` (そのページは [EXTERNAL-POINTER-1WORD](0x020L-external-pointer-1word.md)、[EXTERNAL-POINTER-2WORD](0x025L-external-pointer-2word.md) もまとめて扱う) |

## メンバー {#구성원}

このページは 5Q 体系の 1 セット、コード 5 つをまとめて扱う。量化はセクション内オフセット `C % 5` だ([Reference](_index.md#quantifier))。Codec ドキュメントはコードごとに 1 つある。5 つの Codec ドキュメントはフィールドが同じで、DECLARE 対象と名前(BIND)だけが異なる。

| TAG ID | 名前 | 量化 | Codec ID | 規格ドキュメント | TAG WORD |
|---|---|---|---|---|---|
| `0x02AL` | `EXTERNAL-POINTER-4WORD-IDENTIFIED` | Identified | `0x000002A0` | `0x00000000/codecs/0x000002A0/` | `0000 0010 1010 LLLL` |
| `0x02BL` | `EXTERNAL-POINTER-4WORD-GENERIC` | Generic | `0x000002B0` | `0x00000000/codecs/0x000002B0/` | `0000 0010 1011 LLLL` |
| `0x02CL` | `EXTERNAL-POINTER-4WORD-FREE-CHOICE` | Free-choice | `0x000002C0` | `0x00000000/codecs/0x000002C0/` | `0000 0010 1100 LLLL` |
| `0x02DL` | `EXTERNAL-POINTER-4WORD-UNIVERSAL` | Universal | `0x000002D0` | `0x00000000/codecs/0x000002D0/` | `0000 0010 1101 LLLL` |
| `0x02EL` | `EXTERNAL-POINTER-4WORD-VARIABLE` | Variable | `0x000002E0` | `0x00000000/codecs/0x000002E0/` | `0000 0010 1110 LLLL` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順だ([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受け取る形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `import-id` | #2 | 生値 4 WORD |  |  |
| 2 | `target-id` | #3 | 残り全部の生値(`0xFFFF`) |  |  |

EXTERNAL-POINTER は、HEAD の [IMPORT-DOC](../meta/0x1E4L-import-doc.md) で取り込んだドキュメントの LOCAL ID を指す指示 Reference だ。

## レイアウト {#레이아웃}

```
TAG WORD          0000 001C CCCC LLLL      Codec 0x020L~0x02EL (セクション 1)
[Length 拡張 TAG]
IMPORT ID         Codec が定める幅 (1/2/4 WORD)
対象 ID           残り全部。取り込んだドキュメントの LOCAL ID、最短幅
```

| Codec (Identified, Generic, Free-choice, Universal, Variable) | 名前 | IMPORT ID 幅 |
|---|---|---|
| `0x020L~0x024L` | EXTERNAL-POINTER-1WORD | 1 WORD |
| `0x025L~0x029L` | EXTERNAL-POINTER-2WORD | 2 WORD |
| `0x02AL~0x02EL` | EXTERNAL-POINTER-4WORD | 4 WORD |

- 幅は体系番号で決まる: 体系 − 6(セクション内オフセット `C` の `C / 5`)が 0、1、2 なら 1、2、4 WORD だ。量化は `C % 5` だ。

- IMPORT ID の値が収まる最も狭い Codec を使う。
- IMPORT ID は、このドキュメントの `IMPORT-DOC` が割り当てた値だ。EXTERNAL-POINTER には Issuer を書かない。Issuer とドキュメント ID はその `IMPORT-DOC` から得る。バージョンもその `IMPORT-DOC` が決める(固定または最新)。
- 取り込んだドキュメントの同じ LOCAL ID なら、そのドキュメント内で LOCAL として書いても、ここで EXTERNAL-POINTER として書いても同じ対象だ。
- Variable なら取り込んだドキュメントの LOCAL 変数だ。

## 有効性 {#유효성}

- このドキュメントにその IMPORT ID を割り当てた `IMPORT-DOC` がなければ invalid だ。
- IMPORT ID がより狭い Codec に収まるのに広い Codec を使えば、non-minimal として拒否する。
- 対象 ID が `0` なら invalid だ。取り込んだドキュメント自身は [DOC-POINTER](0x041L-doc-pointer.md) で指す。
- 対象 ID の先頭の `0x0000` WORD は禁止する。

## 例 {#예시}

| 対象 | WORD sequence |
|---|---|
| IMPORT ID 1 の LOCAL 5 | `0202 0001 0005` |
| IMPORT ID 1 の LOCAL 65536 | `0203 0001 0001 0000` |
| IMPORT ID 70000 の LOCAL 5 | `0253 0001 1170 0005` |

## 関連ページ {#관련-페이지}

- [Reference](_index.md)、[LOCAL](0x005L-local.md)、[EXTERNAL-ISSUER](0x02FL-external-issuer-2word.md)、[DOC-POINTER](0x041L-doc-pointer.md)
- [IMPORT-DOC](../meta/0x1E4L-import-doc.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x000002A0/latest.geul` を `geul show` で読んだ様子だ(16進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000002A000000000
BODY
#1 DECLARE 0x02A0
#2 FIELD #1 0x0004
#3 FIELD #1 rest
#4 BIND #1 "EXTERNAL-POINTER-4WORD-IDENTIFIED"
#5 BIND #2 "import-id"
#6 BIND #3 "target-id"
```

上は `EXTERNAL-POINTER-4WORD-IDENTIFIED`(`0x02AL`)の Codec ドキュメントだ。ほかのメンバー(`EXTERNAL-POINTER-4WORD-GENERIC`、`EXTERNAL-POINTER-4WORD-FREE-CHOICE`、`EXTERNAL-POINTER-4WORD-UNIVERSAL`、`EXTERNAL-POINTER-4WORD-VARIABLE`)の Codec ドキュメントは、DOC-ID の Codec ID、DECLARE 対象、`#1` に結んだ名前(BIND)だけが異なる。
