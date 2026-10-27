---
title: "EXPR"
weight: 98
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "EXPR は PREDICATE-DECLARE(Codec 0x61)が使う条件式のレイアウトだ。独自のラベル表と前順序で展開した式レコードで、条件式の木を収める。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXPR は、TANGEUL Rules の条件式を書くレイアウトだ。Codec `0x61` PREDICATE-DECLARE(述語の宣言)が使う。条件式の木を前順序で展開して収め、式の中の文字列はレコード内のラベル表で指す。そのため TEXT レコードなしで単独で完結する。

## レイアウト

```
ID                     LOCAL Reference レコード (Edge Id)
ノード数 1 WORD         式レコードの全個数
ラベル数 1 WORD
ラベル × ラベル数       UTF8-TEXT Value レコード
式レコード × ノード数    前順序
```

- ラベルは、フィールド名、文字列値、パスの段、関数名のような文字列だ。空文字列もラベルになる。式レコードはラベルを 0 から振ったインデックス(1 WORD)で指す。
- 式レコードは、親の次に子を順に置く(前順序)。各レコードの子の数とこの順序で、木が一つに決まる。

## 式レコード

式レコードは、ヘッダ 1 WORD で始まる。

```
ヘッダ 1 WORD      種類の下位2ビット (b15–14) | 種類の上位1ビット (b13) | 子の数 13ビット (b12–0)
```

種類 = `(b13 << 2) | b15–14` だ。

| 種類 | 名前 | 子の数 | ヘッダの後ろ |
|---|---|---|---|
| 0 | COMPARE | 0 | 比較演算子 1 WORD、フィールドラベル 1 WORD、値の位置 |
| 1 | LOGIC | n | 論理演算子 1 WORD |
| 2 | NOT | 1 | なし |
| 3 | EITHER | n | なし |
| 4 | EXISTS | 1 | 量化演算子 1 WORD、対象オペランド、束ねる名前のラベル 1 WORD |
| 5 | CALL | 0 | 別名ラベル 1 WORD、関数名ラベル 1 WORD |
| 6 | COMPARE-X | 0 | 比較演算子 1 WORD、フィールドラベル 1 WORD、左マーカー 1 WORD [+ オペランド]、値の位置 |
| 7 | 予約 | | |

- 子レコードは、ヘッダの後ろのフィールドの次に続く。EXISTS の子は条件一つだ。
- COMPARE は、両側にオペランドのない比較 `<フィールド> <演算子> <値>` だ。オペランドが片側にでもあれば COMPARE-X を使う。
- COMPARE-X の左マーカーが `1` ならオペランドが続き、`0` ならない。左オペランドがあればフィールドラベルは空文字列だ。
- CALL は、述語の位置のホスト関数呼び出しだ。このドキュメントの関数なら、別名ラベルは空文字列だ。

### 値の位置

```
値の種類 1 WORD    0 数, 1 文字列, 2 オペランド
値                0: UNSIGNED-INTEGER Value レコード
                  1: ラベル 1 WORD
                  2: オペランド (COMPARE-X でのみ)
```

- 値の文字列が非負整数の正規10進表記とちょうど同じなら、UNSIGNED-INTEGER Value で書く。それ以外の値はラベルで書く。そのため値の文字列がそのまま復元される。

### オペランド

```
オペランドの種類 1 WORD   0 パス, 1 基準参照, 2 関数呼び出し
パス・基準参照            段の数 1 WORD + ラベル 1 WORD × 段の数
関数呼び出し              別名ラベル 1 WORD + 関数名ラベル 1 WORD
```

- パスは入力データのパス、基準参照は `with` で注入した判断基準(SPEC)のパスだ。

### 演算子コード

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

### 不明な入力の評価

比較演算子は、入力がプレースホルダのとき3値(真、偽、未定 U)で評価する。NO-VALUE は `is empty` が真で、他の比較は偽だ。UNKNOWN-VALUE は `is not empty` が真で、`equals`・`is in`・大小比較は U だ。ABSENT と記述なしは、すべての演算子が U だ。論理演算子は Kleene の強3値に従い、述語が U ならノードの判定は Review だ。この評価は固定された核だ([TOULMIN](/ja/grammar/edge/toulmin/#不明の上での判定))。

## 解釈と有効性

- ノード数は、展開した式レコードの数と同じでなければならない。最後の式レコードを読み終えた位置が、レコードの終わりとちょうど合わなければならない。
- ラベルインデックスがラベル数以上なら拒否する。
- NOT と EXISTS の子の数は 1 でなければならない。
- 未知の種類(7)や未知の値の種類・オペランドの種類は拒否する。
- 子の数は 13 ビット(最大 8191)だ。

## 関連ページ

- [TOULMIN](/ja/grammar/edge/toulmin/)、[NODE](/ja/grammar/edge/toulmin/node/)
- [UTF8-TEXT](/ja/grammar/value/text/utf8-text/)、[UNSIGNED-INTEGER](/ja/grammar/value/numeric/unsigned-integer/)
