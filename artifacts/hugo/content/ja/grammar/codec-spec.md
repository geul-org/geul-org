---
title: "Codec 規格ドキュメント"
weight: 90
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-28T12:00:00+09:00
tags: ["grammar", "codebook", "declare", "field"]
summary: "コードブックも GEUL ドキュメントだ。DECLARE・FIELD・ENUM・CODEC の四つの Edge で Codec 一つの Payload 構成を宣言し、そのドキュメント一つで検証・分解・表示をまとめて行う。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Codec が Payload をどう構成するかは、コードブックが定める。GEUL のコードブックは別個の形式ではなく、**GEUL ドキュメント**だ。Codec 一つにつき規格ドキュメント一つだ。

## 規格ドキュメントの位置

直接コードの規格ドキュメントは、GEUL Issuer(`0x0000`)が公表する。ドキュメント ID は、その Codec の TAG WORD(Kind・Codec の位置だけ、Length は 0)を 4 WORD に伸ばした値だ。

```
/.well-known/geul/0x0000/0x000000000000<TAG>.geul
```

| Codec | TAG | 規格ドキュメント |
|---|---|---|
| Reference LOCAL | `0008` | `0x0000/0x0000000000000008` |
| Value QUANTITY | `0806` | `0x0000/0x0000000000000806` |
| Edge TRIPLE | `100A` | `0x0000/0x000000000000100A` |
| Edge PUBLICATION | `1018` | `0x0000/0x0000000000001018` |

デコーダは TAG WORD だけを見て、規格ドキュメントのアドレスを作る。未知の Codec に出会ったら、そのドキュメントを受け取って読めばよい。

- `<TAG>` は、対象 TAG WORD の hex 4桁だ。Length の位置は `0000` で、Reference は Quantifier ビットを `000` にする(LOCAL は `0008`)。
- Reference Codec `0000` は予約なので、対象 TAG WORD が `0x0000` の規格ドキュメントはない。そのため規格ドキュメントは、GEUL Issuer の用語定義インデックスドキュメント(ドキュメント ID `0`、[Issuer と公表](/ja/grammar/issuer/#用語定義ドキュメント))と重ならない。Codec `0000` の[プレースホルダ](/ja/grammar/reference/slot-marker/)(`0x0000`~`0x0002`)にも規格ドキュメントはない。デコーダに内蔵する([0 層](/ja/grammar/publishing/#層))。
- 規格ドキュメントは、`DOC-ID` として DOC-POINTER(`0x0000`、`0x000000000000<TAG>`、`0`)を置く。バージョン一覧レコードもこの DOC-POINTER を使う。
- 規格ドキュメントも他のドキュメントと同様に、GEUL Issuer の名前索引 `0x0000/documents.geul` に小文字スラッグの名前を結びつける。例: `publication` → `geul.org/publication/` = `0x0000/0x0000000000001018/`([公表アドレスとバージョン一覧](/ja/grammar/publishing/#ドキュメント名))。
- バージョン・正本アドレス・署名の規則は、通常の公表ドキュメントと同じだ。

### GEUL Issuer のドキュメント ID

| ドキュメント ID | 用途 |
|---|---|
| `0x0000000000000000` | 用語定義インデックスドキュメント |
| `0x00000000 0000xxxx` | Codec 規格ドキュメント。`xxxx` は対象 TAG WORD |
| `0x0001xxxx xxxxxxxx` | geul.org の用語定義ドキュメント。用語一つにドキュメント一つ([Issuer と公表](/ja/grammar/issuer/#用語定義ドキュメント)) |

- `0x00000000 0000xxxx` は Codec 規格ドキュメントに予約する。GEUL Issuer の他のドキュメント(直接コードが足りないときに置く GEUL 固有 ISSUER 形式のドキュメントなど)は、この区間を使わない。

### コードブックと仕様の版

- コードブックドキュメントは、`IMPORT-DOC` で取り込まない。ドキュメント HEAD の [SPEC-VERSION](/ja/grammar/meta/declaration/spec-version/) が、どのコードブックに従うかを決める。
- すべてのデコーダは、中核コードブックを内蔵するか、このアドレスから受け取る。
- 提案(Prefix `000`)が標準として採択されると、レイアウトはそのままで Prefix だけが `001` に変わる([概要](/ja/grammar/overview/#領域構造))。対象 TAG WORD が変わるので、採択版は別のドキュメント ID の新しい規格ドキュメントになり、提案ドキュメントは不変のまま残る。

## 四つの語彙

| Edge | Codec | 役割 |
|---|---|---|
| DECLARE | `0x1B` | Codec 一つの Payload 構成を宣言する。対象 TAG WORD 1 WORD |
| FIELD | `0x1C` | Payload のフィールド一つ。属する DECLARE と幅 |
| ENUM | `0x1D` | 生値フィールドのコード値一つに意味を付ける |
| CODEC | `0x1E` | フィールドが受け取る Kind・Codec 一つを指定する |

- 四つの Edge のレイアウトはデコーダに内蔵する([0 層](/ja/grammar/publishing/#層))。規格ドキュメントをコードブックなしで読む必要があるからだ。規格ドキュメントを読むのに、他の規格ドキュメントは要らない。
- 名前(Codec 名、フィールド名、コード値の名前)は、すべて BIND で結びつける。

### FIELD

```
Edge Id           LOCAL
DECLARE           LOCAL (このフィールドが属する DECLARE)
幅                1 WORD: 0 = レコード、n = 生値 n WORD、0xFFFF = 残り生値
```

- 同じ DECLARE を指す FIELD 群の**ドキュメント内の順序**が、Payload のフィールド順序だ。
- レコードフィールドは TAG WORD で始まり、その Length だけ読む。
- 生値フィールドは、定められた WORD 数だけ読む符号なし整数だ。符号・小数・日付のように解釈が必要な値は、生値ではなく Value レコードで置く。
- 残り生値(`0xFFFF`)は一つだけ置け、その後ろには固定幅の生値だけが来る。
- Edge の Edge Id は FIELD として宣言しない。すべての Edge の最初の要素なので暗黙だ。
- フィールドを順に読んだ位置は、レコードの終わりとちょうど合わなければならない。

### CODEC

フィールドが受け取る形式を指定する。対象 WORD は TAG WORD の Kind・Codec の位置をそのまま使う。

| Length の位置 | 意味 | 例 |
|---|---|---|
| `0000` | 厳密な Codec | `0810` SIGNED-DECIMAL、`0008` LOCAL |
| `1111` | ワイルドカード: 0 の Codec ビットは何でも一致する | `0780` 任意の Reference、`0F80` 任意の Value、`07A0` Wikidata QID(量化不問) |

- レコードフィールドに CODEC がなければ、任意のレコードを受け付ける(プレースホルダを除く)。一つ以上あれば、そのいずれかでなければならない(閉じた一覧)。
- 生値フィールドに CODEC を一つ置くと、その生値を TAG のないその Value として解釈する。

### オプションフィールドとプレースホルダ

[プレースホルダ](/ja/grammar/reference/slot-marker/)は、予約 Reference Codec `0000` の 1 WORD レコード群だ。フィールドの CODEC 一覧がその WORD を厳密な対象として置くときだけ、その位置に来られる。

| CODEC 対象 | マーカー | そのフィールドは |
|---|---|---|
| `0000` | ABSENT、記載なし | **オプションフィールド**だ。省略できる |
| `0001` | UNKNOWN-VALUE、不明 | 値があるが何かは分からないという断言を受け付ける |
| `0002` | NO-VALUE、なし | 値がないという断言を受け付ける |

- **受け入れ規則:** マーカーは、そのフィールドの CODEC 一覧に同じ WORD が厳密な対象としてあるときだけ有効だ。ワイルドカード(`0780`、`0781`、`0F80` …)と、CODEC のないフィールド(「任意のレコード」)は、マーカーを受け付けない。HEAD・BODY のレコード位置、Edge Id の位置では invalid だ。
- オプションフィールドを省略するときは、その位置に WORD `0x0000` 一つ(ABSENT)を書く。オプションフィールドも位置は常に占める。そのためレコード一つの表記は一つで、分解は位置だけで決まる。
- マーカーは予約 Reference Codec なので他のレコードと重ならず、規格を知らないデコーダも 1 WORD レコードとして読み飛ばす。
- 三つのマーカーは異なる言葉だ。ABSENT はドキュメントについての言葉(この位置を埋めなかった)なので、世界について何も断言しない。UNKNOWN-VALUE は値があるという断言(`∃x`)、NO-VALUE は値がないという断言(`¬∃x`、限定条件の中で)だ。省略は「値がない」ではなく「記載なし」だ。
- マーカーが何を意味するかは、そのマーカーを受け取る Codec 規格が決める([TRIPLE](/ja/grammar/edge/triple/)、[QUALIFIER](/ja/grammar/edge/qualifier/))。

## 例: TRIPLE 規格ドキュメント

`0x0000/0x000000000000100A` の BODY だ。

| Edge | 内容 | 名前(BIND) |
|---|---|---|
| #1 DECLARE | 対象 `100A` | `TRIPLE` |
| #2 FIELD | #1 のフィールド、レコード | `predicate` |
| #3 FIELD | #1 のフィールド、レコード | `subject` |
| #4 FIELD | #1 のフィールド、レコード | `object` |
| #5 FIELD | #1 のフィールド、生値 1 WORD | `rank` |
| #6~#8 ENUM | #5 のコード値 0、1、2 | `normal`, `preferred`, `deprecated` |
| #17 CODEC | #5 は UNSIGNED-INTEGER(`0802`)として解釈 | |
| #18, #19 CODEC | #4 は任意の Reference(`0780`)または任意の Value(`0F80`) | |
| #20, #21 CODEC | #4 は UNKNOWN-VALUE(`0001`)、NO-VALUE(`0002`)も受け付ける | |

このドキュメント一つで、デコーダは TRIPLE レコードをフィールドに分け、フィールド名を付けて表示し、形式が合っているかを検査する。

## 例: QUANTITY 規格ドキュメント

Value QUANTITY(`0806`)は、フィールド四つがすべてレコードだ。

| フィールド | CODEC |
|---|---|
| `amount` | `0801` SIGNED-INTEGER、`0802` UNSIGNED-INTEGER、`0803` BINARY-FLOAT(有限の値のみ)、`0807` FRACTION、`0810` SIGNED-DECIMAL、`0811` UNSIGNED-DECIMAL |
| `unit` | `0780` 任意の Reference、`0000` オプション |
| `lower` | `0801`·`0802`·`0803`·`0807`·`0810`·`0811`(amount と同じ)、`0000` オプション |
| `upper` | `0801`·`0802`·`0803`·`0807`·`0810`·`0811`(amount と同じ)、`0000` オプション |

## 規則

- 規格ドキュメント一つに DECLARE は一つだ。DECLARE の対象は、ドキュメント ID の TAG WORD と同じだ。
- 一つのドキュメントで同じ対象を二度宣言しない。
- フィールド構成が異なる変種を分岐として使わない。Codec ごとに別々に宣言する。
- 可変の生値が二つ以上ある、または生値の幅が他の値に応じて変わるレイアウトは宣言できない。そのような部分はレコードで包む。
- 規格ドキュメントは、他のドキュメントと同様にバージョンとして公表される。ただし Codec のバイナリレイアウトは改訂しない。変えるには新しい Codec を割り当てる。

## 未解決の問題

- `SPEC-VERSION` の値(v1 は `0x0001`)から、コードブックドキュメントのバージョンへの対応。採択版と提案版をつなぐ系譜 Meta。
