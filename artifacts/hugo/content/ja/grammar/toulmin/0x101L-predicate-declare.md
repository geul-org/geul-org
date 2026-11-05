---
title: "PREDICATE-DECLARE (0x101L)"
weight: 257
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "PREDICATE-DECLARE は述語 (判定式) を宣言する TOULMIN Codec である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

PREDICATE-DECLARE は述語 (判定式) を宣言する TOULMIN Codec である。レイアウトは EXPR である。EXPR は TANGEUL Rules の条件式を書くレイアウトである。条件式の木を先行順 (pre-order) に展開して収め、式の中の文字列はレコード内のラベル表で指す。そのため TEXT レコードなしで単独で完結する。

| 項目 | 値 |
|---|---|
| 名前 | `PREDICATE-DECLARE` (規格ドキュメント BIND `PREDICATE-DECLARE`) |
| TAG ID | `0x101L` |
| Codec ID | `0x00001010` |
| 規格ドキュメント | `0x00000000/codecs/0x00001010/` (DECLARE 対象 `1010`) |
| セクション | 8 `1000` (Edge TOULMIN)、セクション内オフセット C = 1 |
| Kind | Edge · 系列: TOULMIN、まとまり: 宣言、レイアウト: EXPR |
| TAG WORD | `0001 0000 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | 述語宣言。判定関数・式、判断基準 (Spec)、事実契約 (Ground) |
| Hugo 側 | `edge/toulmin/expr.md` |

## レイアウト {#레이아웃}

```
ID                     LOCAL Reference レコード (Edge Id)
ノード数 1 WORD         式レコードの総数
ラベル数 1 WORD
ラベル × ラベル数        UTF8-TEXT Value レコード
式レコード × ノード数    先行順
```

- ラベルはフィールド名、文字列値、パスの段、関数名のような文字列である。空文字列もラベルになる。式レコードはラベルを 0 から振ったインデックス (1 WORD) で指す。
- 式レコードは親の次に子を順に置く (先行順)。各レコードの子の数とこの順序で木が一つに定まる。

## 式レコード {#식-레코드}

式レコードはヘッダ 1 WORD で始まる。

```
ヘッダ 1 WORD      種別 下位 2 ビット (b15–14) | 種別 上位 1 ビット (b13) | 子の数 13 ビット (b12–0)
```

種別 = `(b13 << 2) | b15–14` である。

| 種別 | 名前 | 子の数 | ヘッダの後 |
|---|---|---|---|
| 0 | COMPARE | 0 | 比較演算子 1 WORD、フィールドラベル 1 WORD、値の位置 |
| 1 | LOGIC | n | 論理演算子 1 WORD |
| 2 | NOT | 1 | なし |
| 3 | EITHER | n | なし |
| 4 | EXISTS | 1 | 量化演算子 1 WORD、対象オペランド、束ねる名前のラベル 1 WORD |
| 5 | CALL | 0 | 別名ラベル 1 WORD、関数名ラベル 1 WORD |
| 6 | COMPARE-X | 0 | 比較演算子 1 WORD、フィールドラベル 1 WORD、左マーカー 1 WORD [+ オペランド]、値の位置 |
| 7 | Reserved | | |

- 子レコードはヘッダの後のフィールドの次に続く。EXISTS の子は条件一つである。
- COMPARE は両側にオペランドがない比較 `<フィールド> <演算子> <値>` である。オペランドが片側でもあれば COMPARE-X を使う。
- COMPARE-X の左マーカーが `1` ならオペランドが続き、`0` なら続かない。左オペランドがあるとき、フィールドラベルは空文字列である。
- CALL は述語位置でのホスト関数呼び出しである。このドキュメントの関数なら別名ラベルは空文字列である。

### 値の位置 {#값-자리}

```
値の種別 1 WORD    0 数、1 文字列、2 オペランド
値                0: UNSIGNED-INTEGER Value レコード
                  1: ラベル 1 WORD
                  2: オペランド (COMPARE-X のみ)
```

- 値の文字列が非負整数の正規 10 進表記とまったく同じなら UNSIGNED-INTEGER Value で書く。それ以外の値はラベルで書く。そのため値の文字列がそのまま復元される。

### オペランド {#피연산자}

```
オペランド種別 1 WORD   0 パス、1 基準参照、2 関数呼び出し
パス・基準参照          段数 1 WORD + ラベル 1 WORD × 段数
関数呼び出し            別名ラベル 1 WORD + 関数名ラベル 1 WORD
```

- パスは入力データのパス、基準参照は `with` で注入した判断基準 (SPEC) のパスである。

### 演算子コード {#연산자-코드}

| コード | 比較演算子 |
|---|---|
| `0x0301` | is empty |
| `0x0302` | is not empty |
| `0x0303` | equals |
| `0x0304` | is in |
| `0x0305` | is greater than |
| `0x0306` | is less than |
| `0x0307` | is at most |
| `0x0308` | is at least |

| コード | 論理演算子 |
|---|---|
| `0x0311` | and |
| `0x0312` | or |

| コード | 量化演算子 |
|---|---|
| `0x0321` | any |

### 未知入力の評価 {#미상-입력의-평가}

比較演算子は、入力がプレースホルダのとき 3 値 (真、偽、未定 U) で評価する。NO-VALUE は `is empty` が真で、他の比較は偽である。UNKNOWN-VALUE は `is not empty` が真で、`equals`・`is in`・大小比較は U である。ABSENT と叙述なしは、すべての演算子が U である。論理演算子は Kleene の強 3 値に従い、述語が U ならノード判定は Review である。この評価は固定された中核である ([TOULMIN](_index.md#미상-위에서-판정하기))。

## 解釈と有効性 {#해석과-유효성}

- ノード数は展開した式レコードの数と等しくなければならない。最後の式レコードを読み終えた位置がレコードの終端とぴったり合わなければならない。
- ラベルインデックスがラベル数以上なら拒否する。
- NOT と EXISTS の子の数は 1 でなければならない。
- 未知の種別 (7) や未知の値種別・オペランド種別は拒否する。
- 子の数は 13 ビット (最大 8191) である。

## Codec ドキュメント {#코덱-문서}

Codec ドキュメントは DECLARE (対象 `1010`) を置く。EXPR レイアウトは先頭の生値 (ノード数、ラベル数) が繰り返しの個数を定めるため FIELD で宣言できず、フィールド宣言は未解決の問題である ([DECLARE](../edge/0x0BBL-declare.md#열린-문제) の繰り返し)。

## 関連ページ {#관련-페이지}

- [TOULMIN](_index.md)、[NODE](_index.md#node)
- [UTF8-TEXT](../value/0x072L-utf8-text.md)、[UNSIGNED-INTEGER](../value/0x062L-unsigned-integer.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00001010/latest.geul` を `geul show` で読んだ姿である (16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000101000000000
BODY
#1 DECLARE 0x1010
#2 BIND #1 "PREDICATE-DECLARE"
```
