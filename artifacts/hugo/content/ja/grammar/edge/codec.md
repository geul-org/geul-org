---
title: "CODEC"
weight: 31
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "CODEC は FIELD 一つが受け取る Kind・Codec 一つを指定する記述 Edge だ(Codec 0x1E)。ワイルドカードとプレースホルダ(0x0000 記載なし、0x0001 不明、0x0002 なし)もこれで宣言する。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CODEC は、[FIELD](/ja/grammar/edge/field/) 一つが受け取る Kind・Codec 一つを指定する記述 Edge だ。Codec `0x1E`。

[ENUM](/ja/grammar/edge/enum/) が生値フィールドのコード値一つに意味を付けるように、CODEC はフィールドの形式一つを付ける。Edge 一つにつき一つなので、複数を指定できる。レイアウトはデコーダに内蔵する([Codec 規格ドキュメント](/ja/grammar/codec-spec/))。

## レイアウト

```
TAG WORD          0001 0LLL L001 1110
[Length 拡張 TAG]
Edge Id           LOCAL Reference レコード
フィールド        FIELD Edge を指す LOCAL Reference レコード
対象              1 WORD。000K KLLL LCCC CCCC (LLLL = 0000 厳密、1111 ワイルドカード)
```

## 対象 WORD

- TAG WORD の Kind(`KK`)と Codec(`CCCCCCC`)の位置をそのまま使う。上位3ビットは 0 だ。`LLLL` は `0000`(厳密)または `1111`(ワイルドカード)で、他の値は invalid だ。
- 厳密な対象(`LLLL = 0000`)は、Codec 規格ドキュメント ID と同じ値だ(例: LOCAL `0x0008`、COORDINATE-EARTH `0x0804`、UTF8-LANGUAGE-TEXT `0x084A`)。そのため対象がそのまま、その Codec 規格ドキュメントを指す。
- 偶数・奇数のコード対(テキスト・バイト列)も厳密なコードで指定する。偶数・奇数の両方を受け取るには両方を置く。対を束ねて解釈する規則は置かない(NUMERIC `0x04`/`0x05` のように対でない隣接コードがある)。

### ワイルドカード (`LLLL = 1111`)

- Kind は同じでなければならず、**0 である Codec ビットのまとまりは何でも一致する**。Reference は `CCCC`(Codec)と `QQQ`(Quantifier)が別々のまとまりで、他の Kind は 7 ビット全体が一つのまとまりだ。

| 対象 | 意味 |
|---|---|
| `0780` | 任意の Reference |
| `07A0` | WIKIDATA-QID、Quantifier 不問 |
| `0781` | 任意の Reference Codec、Quantifier Generic(`001`) |
| `0F80` | 任意の Value |
| `1780`、`1F80` | 任意の Edge、任意の Meta |

- 一致させるものがないワイルドカードは invalid だ。Value・Edge・Meta は Codec が 0 でなければならず、Reference は `CCCC` か `QQQ` のどちらかが 0 でなければならない。Reference `CCCC = 0000`(プレースホルダ)は予約 Codec なので、**どのワイルドカードにも一致しない**(`0780` は ABSENT・UNKNOWN-VALUE・NO-VALUE を受け付けない)。一方、Value `0x00`(BOOL)・Edge `0x00`(REFERENCE-NODE)のように Codec 0 が割り当てられた Kind も、ワイルドカードがそれを含む(BOOL だけを受けるには `LLLL = 0000`)。
- ワイルドカードは規格ドキュメントを指さない。
- 「Identified だけの任意の Reference」のように、0 でないまとまり一つだけを固定して 0 のまとまりを固定する表現はない。そのような一覧は厳密な対象を並べる。
- Reference の Codec 7 ビットには Quantifier(`QQQ`)が入っている。対象は Quantifier まで厳密に指定する。複数の Quantifier を受けるには CODEC を複数置く。

### プレースホルダ (対象 `0000`~`0002`)

[プレースホルダ](/ja/grammar/reference/slot-marker/)は、予約 Reference Codec `0000` の 1 WORD レコード群だ。下位3ビットがマーカー番号だ(Quantifier ではない)。

| 対象 | マーカー | 意味 |
|---|---|---|
| `0000` | ABSENT | 記載なし。そのフィールドはオプションフィールドだ |
| `0001` | UNKNOWN-VALUE | 不明。値があるという断言を受け付ける |
| `0002` | NO-VALUE | なし。値がないという断言を受け付ける |
| `0003`~`0007` | 予約 | |

- **受け入れ規則:** マーカーは、そのフィールドの CODEC 一覧に同じ WORD が厳密な対象としてあるときだけ有効だ。ワイルドカードと、CODEC のないレコードフィールド(「任意のレコード」)は、マーカーを受け付けない。HEAD・BODY のレコード位置、Edge Id の位置のマーカーは invalid だ。
- マーカー対象だけの一覧(常にマーカー)は invalid だ(`0000` だけの一覧の規則の一般化)。ワイルドカードや厳密な対象と一緒に使う(`0780` + `0000` = 任意の Reference または省略)。
- 生値フィールドにはマーカー対象を置けない。生値は TAG がなく幅が決まっていて、1 WORD のマーカーが入る位置がない。
- マーカーの意味は、それを受け取る Codec 規格が決める。

### オプションフィールド (対象 `0000`)

- レコードフィールドの CODEC 一覧に対象 `0000` を置くと、そのフィールドは**オプションフィールド**になる。省略するときは、その位置に WORD `0x0000` を 1 WORD 書く。この 1 WORD レコードがプレースホルダ ABSENT(記載なし)だ。
- `0x0000` は Reference Codec `0000`(予約)、マーカー番号 `000`、`LLLL = 0000`(全体 1 WORD)だ。他のレコードと重ならず、規格を知らないデコーダも 1 WORD レコードとして読み飛ばす。
- オプションフィールドも位置は常に占める。省略するときは必ず `0x0000` を書き、位置を空けない(後ろのフィールドでも同じ)。そのためレコード一つの表記は一つだけで、分解は位置だけで決まる。オプションフィールドの位置と個数、他のフィールドと一覧が重なるかについて制約はない。
- ABSENT はオプションフィールドの位置でのみ有効だ。HEAD・BODY のレコード位置、必須フィールドの位置、Edge Id の位置の `0x0000` は invalid だ。
- 省略は「値がない」ではなく「記載なし」だ。世界について何も断言しない。「値がない」は NO-VALUE(`0002`)で書く。省略が何を意味するか(例: TAG の対象がなければこのバージョン)は、各形式の仕様が決める。

## 解釈と有効性

- フィールドは同じドキュメントの FIELD Edge だ。一つのフィールドに同じ対象を二度置かない。
- **レコードフィールド(幅 0)**: CODEC がなければ、プレースホルダを除く任意のレコードを受け付ける。一つ以上あれば閉じた一覧だ。そのフィールドのレコードは Kind・Codec(Reference は Quantifier を含む)が一覧のいずれかでなければならず、そうでなければそのレコードは規格に従わない。ENUM が開いた一覧であるのとは異なる。
- **生値フィールド(幅 n ≥ 1、または残り `0xFFFF`)**: CODEC は厳密な対象を一つだけ置く(ワイルドカード不可)。その生値は、TAG を除いたその Value の Payload だ。Kind・Codec は CODEC が、Length は FIELD の幅が与える。偶数・奇数コードは、指定したコードがバイト数の偶奇を決める。生値がその Value の規則(長さを含む)に従わなければ、そのレコードは規格に従わない。
- プレースホルダは、一覧の厳密な対象とだけ照合する。オプションフィールド(対象 `0000`)の位置に `0x0000` が来たら省略だ。それ以外のレコードは、マーカー対象を除いた一覧で照合する。
- 生値フィールドに CODEC と ENUM を併用できる。CODEC は形式、ENUM はコード値の名前だ(例: rank を UNSIGNED-INTEGER にして 0・1・2 を ENUM に)。
- CODEC の Edge Id に BIND で名前を付けられるが、必須ではない。
- 「Reference または Value」フィールドは CODEC 2個(`0780`、`0F80`)で書く。

## 長さ

```
全体 = 1 + N_len + N_id + N_field + 1 WORD   (Edge Id・フィールドが LOCAL 1 WORD ID なら 6 WORD)
```

## 例

LABEL 規格ドキュメント `geul.org/label` で、Object フィールド(FIELD #3)が UTF8-LANGUAGE-TEXT(偶数・奇数)と LOCAL を受け取る。Edge Id 7~9。

```
129E 0088 0007 0088 0003 084A
129E 0088 0008 0088 0003 084B
129E 0088 0009 0088 0003 0008
```

- TAG `129E`(Edge、Codec `0x1E`、`LLLL = 0101`、6 WORD)、Edge Id `0088 0007`、フィールド `0088 0003`、対象 `084A`。

## 関連ページ

- [FIELD](/ja/grammar/edge/field/)、[ENUM](/ja/grammar/edge/enum/)、[DECLARE](/ja/grammar/edge/declare/)、[BIND](/ja/grammar/edge/bind/)
- [Codec 規格ドキュメント](/ja/grammar/codec-spec/)、[LABEL](/ja/grammar/edge/label/)
