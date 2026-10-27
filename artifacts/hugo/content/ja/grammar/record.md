---
title: "レコードと TAG WORD"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "record", "TAG"]
summary: "すべてのレコードは TAG WORD 16ビットで始まる。Prefix 3ビット、Kind 2ビット、Length 4ビット、Codec 7ビットで、レコードの種類と長さを決める。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL のデータはレコードの連続だ。すべてのレコードは TAG WORD 一つで始まる。

## レコードレイアウト

```
TAG WORD (16ビット)
┌──────────┬─────────┬──────────┬─────────────────────┐
│  Prefix  │  Kind   │  Length  │        Codec        │
│   3bit   │  2bit   │   4bit   │        7bit         │
│   000    │   KK    │   LLLL   │       CCCCCCC       │
└──────────┴─────────┴──────────┴─────────────────────┘
[Length 拡張 TAG]
[Codec 拡張 TAG]
[Codec ごとの TAG]
Payload
```

- TAG WORD は `000K KLLL LCCC CCCC` だ。
- 拡張 TAG は上の順序でのみ置く。Length 拡張 TAG は常に TAG WORD の直後だ。
- Codec ごとの TAG と Payload の構成は、各 Codec 規格が定める。Codec ごとの TAG の長さは TAG WORD に書かない。Payload を解釈するにはどのみちコードブックが必要だからだ。
- 下位形式のある Codec は、Codec ごとの TAG 1 WORD で下位形式を指定する(Edge WORLD など)。

## バイト順

- 正規シリアライズはビッグエンディアンだ。
- ビットフィールドは最上位ビットから配置する。
- WORD の中では上位バイトを先に、複数の WORD からなる値は上位 WORD を先に書く。
- メモリ内の表現は、実装が自由に決める。

## Kind (2ビット)

| 値 | Kind | TAG WORD | 定義 |
|---|---|---|---|
| `00` | Reference | `0000 0LLL LCCC CQQQ` | 対象を指す。Codec と対象 ID で対象を識別する |
| `01` | Value | `0000 1LLL LCCC CCCC` | 値そのものを持つ。Codec が Payload の解釈を定める |
| `10` | Edge | `0001 0LLL LCCC CCCC` | 他のレコードを構成要素として束ねる。Codec が構成要素の役割と順序を定める |
| `11` | Meta | `0001 1LLL LCCC CCCC` | ドキュメントとレコードについて述べる |

- Kind は Codec の不変の属性だ。一度割り当てた Codec は Kind を移さない。
- Value と Edge は同じ「Codec + Payload」形式だ。Edge だけが他のレコードを構成要素に持つ。
- Reference は Codec 7ビットを、Codec 4ビットと Quantifier 3ビットに分けて使う([Reference](/ja/grammar/reference/))。

## Length (4ビット)

Length はレコードが占める**全体の WORD 数**だ。TAG WORD、拡張 TAG、Payload、最後の WORD のパディングをすべて含む。

| 値 | 意味 |
|---|---|
| `0000`~`1101` | 1~14 WORD (値 + 1) |
| `1110` | 拡張長 1: 次の1 WORD に全体の WORD 数 (15~65,535) |
| `1111` | 拡張長 2: 次の2 WORD に全体の WORD 数 (65,536~2³²−1) |

- 1~14 WORD は必ず直接長で書く。より広い表記は正規形ではない。
- 拡張長の全体 WORD 数には、Length 拡張 TAG 自身も含まれる。
- 2³²−1 WORD を超えるレコードはない。
- 1 WORD のレコードは Payload なしで TAG WORD 一つだ。Codec 規格が許すときだけ使う(例: Meta `BODY`, `END`、空のバイト列、プレースホルダ)。
- コードブックがなくても、`次のレコードの位置 = 現在のレコードの開始 + Length` でレコードを読み飛ばせる。

## Codec (7ビット)

| 値 | 名前 | 意味 |
|---|---|---|
| `0x00`~`0x7B` | 直接コード | TAG WORD だけで Codec が決まる |
| `0x7C` | ISSUER-1WORD | Codec 拡張 TAG に Issuer 1 WORD と形式番号 1 WORD |
| `0x7D` | ISSUER-2WORD | Codec 拡張 TAG に Issuer 2 WORD と形式番号 1 WORD |
| `0x7E` | ISSUER-4WORD | Codec 拡張 TAG に Issuer 4 WORD と形式番号 1 WORD |
| `0x7F` | ISSUER-16WORD | Codec 拡張 TAG に Issuer 16 WORD と形式番号 1 WORD |

- Codec 番号空間は Kind ごとに別々にある。同じ番号でも Kind が違えば別の Codec だ。
- 直接コードでない Codec は `(Issuer, 形式番号)` の組だ。形式番号はその Issuer が定義する([Issuer と公表](/ja/grammar/issuer/))。拡張形式は、その形式を制定した団体の Issuer の下に置く。
- 直接コードのある Codec は、Issuer 形式として別途登録しない。
- Issuer 形式は Value と Edge にだけある。Reference は Codec 4ビットを使い、Meta は GEUL だけが定義する共通規格だ。
- Codec と形式番号の上位ビットは、ファミリー(Value・Edge)またはクラス(Meta)を表す。コードブックがなくてもファミリーがわかる。
- 直接コードは回収できない。頻度が確認された形式だけを直接コードに置く。

## Issuer 形式レコード

```
TAG WORD          Codec = 0x7C~0x7F
[Length 拡張 TAG]
Issuer            1/2/4/16 WORD (Codec が幅を決める)
形式番号          1 WORD。上位ビットがファミリー
Payload           形式が定める値
```

- 形式を知らないデコーダーは、形式番号のファミリーだけを知り、Payload を読み飛ばす。

## 可変長バイト列

テキスト、URI、言語タグ、不明なバイト列のように、長さがバイト単位の値は、Codec(または形式番号)を**偶数・奇数の組**で割り当てる。

- Codec の最下位ビットが `0` ならバイト数は偶数、`1` なら奇数だ。
- バイト数 = `2 × Payload WORD 数 − 最下位ビット`。Byte Count フィールドはない。
- 奇数なら、最後の WORD の下位バイトは `0x00` パディングだ。`0x00` でなければ拒否する。
- 空のバイト列は、偶数 Codec の1 WORD レコード(TAG WORD のみ)だ。
- UUID・ダイジェスト・アドレスのようにサイズが決まっている値には、組を置かない。

## 例: TAG WORD を読む

`148A` を読んでみよう。

```
0x148A = 0001 0100 1000 1010
         000 | 10 | 1001 | 0001010
Prefix 000, Kind 10(Edge), Length 1001(10 WORD), Codec 0x0A(TRIPLE)
```

このレコードは10 WORD の Edge で、Codec は TRIPLE だ。コードブックがなくても、次のレコードが10 WORD 後ろにあることがわかる。

## プレースホルダ

TAG WORD `0x0000`~`0x0007` は、予約された Reference Codec `0000` の1 WORD レコードだ。対象を指さず、レコードフィールドの位置を埋める([プレースホルダ](/ja/grammar/reference/slot-marker/))。

```
0x0000~0x0007 = 0000 0000 0000 0MMM
                Prefix 000, Kind 00(Reference), LLLL 0000(1 WORD), CCCC 0000, MMM = マーカー番号
```

| WORD | 名前 | 意味 | 何についての言明か | 論理 | 世界の仮定 | Wikidata |
|---|---|---|---|---|---|---|
| `0x0000` | ABSENT | 記さない | ドキュメント: この位置を埋めていない | 断言なし | 開かれた世界 | snak なし |
| `0x0001` | UNKNOWN-VALUE | 不明 | 世界: 値はある。何かはわからない | `∃x. P(s, x)` | 存在は閉じ、正体は開く | `somevalue` |
| `0x0002` | NO-VALUE | なし | 世界: 値がない | `¬∃x. P(s, x)` | (s, P, 限定条件)について閉じる | `novalue` |
| `0x0003`~`0x0007` | 予約 | | | | | |

- 例: 子(P40)が ABSENT なら何人かわからず、UNKNOWN-VALUE なら1人以上、NO-VALUE なら0人だ。終了時点(P582)が ABSENT なら今も有効かどうかわからず、UNKNOWN-VALUE なら終わったがいつかわからず、NO-VALUE なら終わっていない。
- 下位3ビット `MMM` は Quantifier ではなくマーカー番号だ([Reference](/ja/grammar/reference/) Quantifier の例外)。
- マーカーは、フィールドの CODEC 一覧がその WORD をちょうど許すときだけ有効だ。ワイルドカード、CODEC のないフィールド、HEAD・BODY のレコード位置、Edge Id の位置では invalid だ([CODEC](/ja/grammar/edge/codec/))。
- 読む側の義務:
  1. UNKNOWN-VALUE は値ではなく存在の断言だ。どの値とも等しくも異なりもせず、二つの UNKNOWN-VALUE 同士も同じ値とは見なさない。UNKNOWN-VALUE を持つ TRIPLE は重複としてマージしない。
  2. NO-VALUE は、その命題の限定条件の中で閉じる。同じ Subject・Predicate・rank に、限定条件で区別されない値の TRIPLE が一緒にあると矛盾で、検査器は警告する(拒否はしない)。
  3. rank は同じように適用される。代表値(truthy)を選ぶとき、二つのマーカーの TRIPLE も候補だ。
  4. QUALIFIER の値として使われると、その限定の意味を変える(`P582 = UNKNOWN`: 終わった、時点は不明。`P582 = NONE`: 終わっていない)。
  5. ABSENT は世界について何も述べない。移せなかった値を UNKNOWN-VALUE として使わない。

## 正規形

同じ内容は同じバイトにならなければならない。そうしてこそ、コンテンツハッシュと署名が一つに定まる。

- 長さは最も短い表記を使う(1~14 WORD は直接長)。
- 整数は最も短い幅で書く。各 Codec 規格が定める正規形に従う。
- 正規形でないレコードは拒否する。
