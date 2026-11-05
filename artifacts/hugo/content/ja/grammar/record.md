---
title: "レコードの構造"
weight: 10
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "record", "TAG"]
summary: "GEUL データはレコードの連なりである。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL データはレコードの連なりである。すべてのレコードは TAG WORD 1 つで始まる。

## レコードレイアウト {#레코드-레이아웃}

```
TAG WORD (16ビット)
┌──────────┬──────────┬──────────┬──────────┐
│  Prefix  │   Kind   │  Class   │  Length  │
│   3bit   │   4bit   │   5bit   │   4bit   │
│   000    │   KKKK   │  CCCCC   │   LLLL   │
└──────────┴──────────┴──────────┴──────────┘
[Length 拡張 TAG]
[Codec 拡張 TAG]
[Codec 別 TAG]
Payload
```

- TAG WORD は `000K KKKC CCCC LLLL` である。上位 4 ビット `KKKK` がセクション `S = w >> 9` であり、1 つのセクションは 32 マスである。`C` はセクション内 5 ビットのオフセット `(w >> 4) & 0x1F` である。
- TAG ID は `0x000L` と書く。前の 3 桁がセクションと `C` を合わせた 9 ビットの Codec 部分(`w >> 4`)であり、`L` は Length 部分である。実際の WORD 値は L の位置に数字を書く(例: TRIPLE は `0x0AAL`、10 WORD の TRIPLE の TAG WORD は `0x0AA9`)。
- 拡張 TAG は上の順序でのみ置く。Length 拡張 TAG は常に TAG WORD の直後である。
- Codec 別 TAG と Payload の構成は、各 Codec 規格が定める。Codec 別 TAG の長さは TAG WORD に書かない。Payload を解釈するにはどのみちコードブックが必要だからである。
- 下位形式のある Codec は、Codec 別 TAG 1 WORD で下位形式を指定する(Edge WORLD など)。

## バイト順 {#바이트-순서}

- 正規のシリアライズはビッグエンディアンである。
- ビットフィールドは最上位ビットから配置する。
- WORD の中では上位バイトを先に、複数の WORD からなる値は上位 WORD を先に書く。
- メモリ内の表現は実装が自由に定める。

## Kind (セクション区間) {#kind-섹션-구간}

| セクション | Kind | TAG ID | 定義 |
|---|---|---|---|
| 0~2 | Reference | `0x000L~0x05FL` | 対象を指す。Codec と対象 ID で対象を識別する |
| 3·4 | Value | `0x060L~0x09FL` | 値そのものを収める。Codec が Payload の解釈を定める |
| 5~13 | Edge | `0x0A0L~0x1BFL` | 他のレコードを構成要素として束ねる。Codec が構成要素の役割と順序を定める |
| 14·15 | Meta | `0x1C0L~0x1FFL` | ドキュメントとレコードについて語る |

- Kind はセクション区間 1 つで判定する: `w < 0x0600` Reference、`w < 0x0A00` Value、`w < 0x1C00` Edge、残りは Meta。例外はない。

- Kind は Codec の不変の属性である。一度割り当てた Codec は Kind を移さない。
- Value と Edge は同じ「Codec + Payload」形式である。Edge だけが他のレコードを構成要素として持つ。
- Reference は、プレースホルダ、ポインタ、5Q 体系、REFERENCE-ISSUER をコード表で分ける。量化は体系コードにある。REFERENCE-ISSUER の量化は Issuer ドキュメントが定める([Reference](reference/_index.md))。

## Length (4 ビット) {#length-4비트}

Length は、レコードが占める**全 WORD 数**である。TAG WORD、拡張 TAG、Payload、最後の WORD のパディングをすべて含む。

| 値 | 意味 |
|---|---|
| `0000`~`1101` | 1~14 WORD (値 + 1) |
| `1110` | 拡張長 1: 次の 1 WORD に全 WORD 数 (15~65,535) |
| `1111` | 拡張長 2: 次の 2 WORD に全 WORD 数 (65,536~2³²−1) |

- 1~14 WORD は必ず直接の長さで書く。より広い表記は正規形ではない。
- 拡張長の全 WORD 数には、Length 拡張 TAG 自身も含まれる。
- 2³²−1 WORD を超えるレコードはない。
- 1 WORD レコードは、Payload なしの TAG WORD 1 つである。Codec 規格が許すときにのみ使う(例: Meta `BODY`、`END`、空のバイト列、プレースホルダ)。
- コードブックがなくても、`次のレコードの位置 = 現在のレコードの開始 + Length` でレコードを読み飛ばせる。

## Codec (セクションと C、9 ビット) {#codec-섹션과-c-9비트}

| TAG ID | 名前 | 意味 |
|---|---|---|
| 各 Kind 領域の前方 | 直接コード | TAG WORD だけで Codec が定まる |
| `0x05DL`, `0x09DL`, `0x1BDL` | REFERENCE-ISSUER-2WORD, VALUE-ISSUER-2WORD, EDGE-ISSUER-2WORD | Codec 拡張 TAG に Issuer 2 WORD と Codec 番号 2 WORD |
| `0x05EL`, `0x09EL`, `0x1BEL` | REFERENCE-ISSUER-4WORD, VALUE-ISSUER-4WORD, EDGE-ISSUER-4WORD | Codec 拡張 TAG に Issuer 4 WORD と Codec 番号 2 WORD |
| `0x05FL`, `0x09FL`, `0x1BFL` | REFERENCE-ISSUER-16WORD, VALUE-ISSUER-16WORD, EDGE-ISSUER-16WORD | Codec 拡張 TAG に Issuer 16 WORD と Codec 番号 2 WORD |

- **各 Kind 領域の末尾 3 マスが ISSUER である。** Issuer の幅は C の下位 2 ビットである(`01` 2 WORD、`10` 4 WORD、`11` 16 WORD)。Meta には Issuer 形式がない。
- 直接コードの `C` はセクションごとに別にある。同じ `C` の値でもセクションが異なれば別の Codec である。直接コードの Codec ID は TAG WORD 全体(L=0)であるため、Kind が含まれている。
- Issuer の Codec 番号は、Kind に関係なく Issuer ごとに 1 つの空間である。Issuer が自分の `codecs/` の中で重複しないように割り当てる([公表アドレスとバージョン一覧](publishing.md#id-표기))。
- 直接コードでない Codec は `(Issuer, Codec 番号)` の組である。Codec 番号はその Issuer が定義する([Issuer と公表](issuer.md))。拡張形式は、その形式を制定した団体の Issuer の下に置く。
- 直接コードのある Codec は、Issuer 形式として別途登載しない。
- Issuer 形式は Reference、Value、Edge にある。Meta は GEUL だけが定義する共通の規格である。
- Edge の直接コードのセクション(`w >> 9`)が系列である。Value の直接コードと Meta は、ビットで系列・クラスを表さない。Codec 番号の意味は Issuer が定める。
- 直接コードは回収できない。頻度が確認された形式だけを直接コードに置く。

## Issuer 形式のレコード {#issuer-형식-레코드}

```
TAG WORD          ISSUER コード (各 Kind 領域の末尾 3 マス)
[Length 拡張 TAG]
Issuer            2/4/16 WORD (Codec が幅を定める)
Codec 番号        2 WORD. Issuer が定義する
Payload           Issuer が発行した Codec ドキュメントが定める
```

- 3 つの Kind のレイアウトは同じである。番号が足りなければ Issuer をもう 1 つ発行してもらう。
- Edge(EDGE-ISSUER)の Payload は、他の Edge と同様に Edge Id で始まる。そのため順序は TAG、Issuer、Codec 番号、Edge Id、残りの Payload である。
- 形式を知らないデコーダは、Issuer と Codec 番号までを把握し、Length で読み飛ばす。

## 可変長バイト列 {#가변-길이-바이트열}

テキスト、URI、言語タグ、不明なバイト列のように、長さがバイト単位の値は、Codec(または Codec 番号)を**偶数・奇数のペア**で割り当てる。

- Codec の最下位ビット(直接コードは C の最下位ビット)が `0` ならバイト数が偶数、`1` なら奇数である。
- バイト数 = `2 × Payload WORD 数 − 最下位ビット`。Byte Count フィールドはない。
- 奇数なら、最後の WORD の下位バイトは `0x00` のパディングである。`0x00` でなければ拒否する。
- 空のバイト列は、偶数の Codec の 1 WORD レコード(TAG WORD のみ)である。
- UUID・ダイジェスト・アドレスのようにサイズが決まった値には、ペアを置かない。

## 例: TAG WORD を読む {#예-tag-word-읽기}

`0AA9` を読んでみよう。

```
0x0AA9 = 0000 1010 1010 1001
         000 | 0101 | 01010 | 1001
Prefix 000, セクション 0101(5, Edge), C 01010, Codec 0x0AAL(TRIPLE), Length 1001(10 WORD)
```

このレコードは 10 WORD の Edge であり、Codec は TRIPLE である。コードブックがなくても、次のレコードが 10 WORD 後ろにあることが分かる。

## プレースホルダ {#자리-표지}

TAG WORD `0x0000`、`0x0010`、`0x0020` は、Reference プレースホルダの 1 WORD レコードである。対象を指さず、レコードのフィールドの位置を埋める([プレースホルダ](slot-marker.md))。

```
0x0000, 0x0010, 0x0020 = 0000 0000 00CC 0000
                         Prefix 000, セクション 0(Reference), C 0~2, LLLL 0000(1 WORD)
```

| WORD | 名前 | 意味 | 何についての言明か | 論理 | 世界の仮定 | Wikidata |
|---|---|---|---|---|---|---|
| `0x0000` | ABSENT | 記載しない | ドキュメント: この位置を埋めなかった | 断言なし | 開いた世界 | snak なし |
| `0x0010` | UNKNOWN-VALUE | 不明 | 世界: 値がある。何かは分からない | `∃x. P(s, x)` | 存在は閉じ、正体は開く | `somevalue` |
| `0x0020` | NO-VALUE | なし | 世界: 値がない | `¬∃x. P(s, x)` | (s, P, 限定条件)について閉じる | `novalue` |

- 例: 子(P40)が ABSENT なら何人か分からない、UNKNOWN-VALUE なら 1 人以上、NO-VALUE なら 0 人である。終了時点(P582)が ABSENT なら今も有効か分からない、UNKNOWN-VALUE なら終わったがいつか分からない、NO-VALUE なら終わっていない。
- プレースホルダは、フィールドの CODEC 一覧がその WORD を正確に置いているときにのみ有効である。ワイルドカード、CODEC のないフィールド、HEAD・BODY のレコード位置、Edge Id の位置では invalid である([CODEC](edge/0x0BEL-codec.md))。
- 読む側の義務:
  1. UNKNOWN-VALUE は値ではなく存在の断言である。どの値とも等しくも異なりもせず、2 つの UNKNOWN-VALUE 同士も同じ値とみなさない。UNKNOWN-VALUE を含む TRIPLE は重複をマージしない。
  2. NO-VALUE は、その命題の限定条件の中で閉じる。同じ Subject・Predicate・rank に、限定条件が区別されない値 TRIPLE と一緒にあれば矛盾であり、検査器は警告する(拒否はしない)。
  3. rank は同様に適用される。代表値(truthy)を選ぶとき、2 つのプレースホルダの TRIPLE も候補である。
  4. QUALIFIER の値として使われると、その限定の意味を変える(`P582 = UNKNOWN`: 終わった、時点は不明。`P582 = NONE`: 終わっていない)。
  5. ABSENT は世界について何も語らない。移せなかった値を UNKNOWN-VALUE として使わない。

## 正規形 {#정규형}

同じ内容は同じバイト列にならなければならない。そうでなければ、コンテンツハッシュと署名が 1 つに定まらない。

- 長さは最も短い表記を使う(1~14 WORD は直接の長さ)。
- 整数は最も短い幅で書く。各 Codec 規格が定める正規形に従う。
- 正規形でないレコードは拒否する。
- 例外: [CODEC](edge/0x0BEL-codec.md) の対象 WORD の `L=1111` は、`C` の値に関係なくセクション `KKKK` だけを見る。セクションの最初のマス(`C = 0`)を推奨し、同じセクションの他の `C` であっても拒否しない。
