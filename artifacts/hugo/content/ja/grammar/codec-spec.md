---
title: "Codec 規格ドキュメント"
weight: 40
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "codebook", "declare", "field"]
summary: "Codec が Payload をどう構成するかは、コードブックが定める。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Codec が Payload をどう構成するかは、コードブックが定める。GEUL のコードブックは別形式ではなく **GEUL ドキュメント**である。Codec 1 つにつき規格ドキュメント 1 つを置く。

## 規格ドキュメントの位置 {#규격-문서의-위치}

直接コードの規格ドキュメントは GEUL Issuer(`0x00000000`)が公表する。規格ドキュメントはコーデックのドキュメントであり、ドキュメント ID を持たない。Codec ID は、その Codec の TAG WORD(セクションと `C` の Codec 部分のみ、Length は 0)を 32 ビットで表した値である。

```
/.well-known/geul/0x00000000/codecs/0x0000<TAG>/<バージョン ID>.geul
```

| Codec | TAG | 規格ドキュメント |
|---|---|---|
| Reference LOCAL | `0050` | `0x00000000/codecs/0x00000050` |
| Value QUANTITY | `0660` | `0x00000000/codecs/0x00000660` |
| Edge TRIPLE | `0AA0` | `0x00000000/codecs/0x00000AA0` |
| Edge PUBLICATION | `0B80` | `0x00000000/codecs/0x00000B80` |

デコーダは TAG WORD だけを見て規格ドキュメントのアドレスを組み立てる。未知の Codec に出会ったら、そのドキュメントを取得して読めばよい。

- `<TAG>` は対象 TAG WORD の hex 4 桁(大文字)である。Length 部分は `0000` である。コーデックのドキュメントはコードごとに 1 つである。Reference の 5Q 体系も量化コードごとに別に置く(LOCAL Identified `0050`、LOCAL Generic `0060`)。直接コードと Issuer のコーデックは同じアドレス規則 `<Issuer>/codecs/<Codec ID>/` を使う([公表アドレスとバージョン一覧](publishing.md#공표-주소))。
- [プレースホルダ](slot-marker.md)(`0x0000`、`0x0010`、`0x0020`)にも規格ドキュメントを置く。Payload がないため DECLARE だけを置き、FIELD はない。プレースホルダの意味と受理規則はデコーダに内蔵する([層 0](publishing.md#층))。レイアウトをまだ定めていない Codec も、DECLARE だけを置いた規格ドキュメントから始める。
- 規格ドキュメントは `DOC-ID` として [CODEC-POINTER](reference/0x042L-codec-pointer.md)(`0x00000000`、`0x0000<TAG>`、`0`)を置く。バージョン一覧レコードもこの CODEC-POINTER を使う。
- バージョン・正本アドレス・署名の規則は一般の公表ドキュメントと同じである。

### コードブックと仕様版 {#코덱북과-명세-판}

- コーデックのドキュメントも [IMPORT-DOC](meta/0x1E4L-import-doc.md) で取り込める。その際、ドキュメントの位置には DOC-POINTER の代わりに [CODEC-POINTER](reference/0x042L-codec-pointer.md) を使う。ドキュメント HEAD の [SPEC-VERSION](meta/0x1C5L-spec-version.md) が、どのコードブックに従うかを定める。
- すべてのデコーダはコアのコードブックを内蔵するか、このアドレスから取得する。
- 提案(Prefix `000`)が標準として採択されると、レイアウトはそのままで Prefix だけが `001` に変わる([概要](_index.md#영역-구조))。対象 TAG WORD が変わるため、採択版は別の Codec ID を持つ新しい規格ドキュメントとなり、提案ドキュメントは不変のまま残る。

## 4 つの語彙 {#네-어휘}

| Edge | Codec | 役割 |
|---|---|---|
| DECLARE | `0x0BBL` | Codec 1 つの Payload 構成を宣言する。対象 TAG WORD 1 WORD |
| FIELD | `0x0BCL` | Payload のフィールド 1 つ。属する DECLARE と幅 |
| ENUM | `0x0BDL` | 生値フィールドのコード値 1 つに意味を付ける |
| CODEC | `0x0BEL` | フィールドが受け取る Kind・Codec を 1 つ指定する |

- 4 つの Edge のレイアウトはデコーダに内蔵する([層 0](publishing.md#층))。規格ドキュメントをコードブックなしで読めなければならないからである。規格ドキュメントを読むのに他の規格ドキュメントは要らない。
- 名前(Codec 名、フィールド名、コード値名)はすべて BIND で結ぶ。

### FIELD {#field}

```
Edge Id           LOCAL
DECLARE           LOCAL (このフィールドが属する DECLARE)
幅                1 WORD: 0 = レコード, n = 生値 n WORD, 0xFFFF = 残りの生値
```

- 同じ DECLARE を指す FIELD の**ドキュメント内の順序**が Payload のフィールド順である。
- レコードフィールドは TAG WORD で始まり、その Length だけ読む。
- 生値フィールドは、定められた WORD 数だけ読む符号なし整数である。符号・小数・日付のように解釈が必要な値は、生値ではなく Value レコードにする。
- 残りの生値(`0xFFFF`)は 1 つだけ置け、その後ろには固定幅の生値だけが来る。
- Edge の Edge Id は FIELD として宣言しない。すべての Edge の最初の要素であり、暗黙だからである。EDGE-ISSUER は Issuer・Codec 番号の後ろの最初の要素である([EDGE-ISSUER-2WORD](edge/0x1BDL-edge-issuer-2word.md))。
- フィールドを順に読み進めた位置は、レコードの末尾とちょうど一致しなければならない。

### CODEC {#codec}

フィールドが受け取る形式を指定する。対象 WORD は TAG WORD の Codec 部分(セクション `KKKK` と `C`)をそのまま使う。

| Length 部分 | 意味 | 例 |
|---|---|---|
| `0000` | 正確な Codec | `0680` SIGNED-DECIMAL、`0050` LOCAL |
| `1111` | ワイルドカード: `C` の値に関係なく、そのセクション `KKKK`(32 マス)全体である。セクションの最初のマス(`C = 0`)を推奨する | `000F` セクション 0 全体、`060F` セクション 3 全体 |

- Kind が複数のセクションにまたがる場合は、セクションごとに CODEC を列挙する。任意の Reference は `000F`・`020F`・`040F`、任意の Value は `060F`・`080F` である。
- 量化を問わない、またはまとまりは、正確な Codec を列挙する。Wikidata QID(量化を問わない)は `0140`、`0150`、`0160`、`0170`、`0180` の 5 つである。

- レコードフィールドに CODEC がなければ、任意のレコードを受け取る(プレースホルダを除く)。1 つ以上あれば、そのうちの 1 つでなければならない(閉じた一覧)。
- 生値フィールドに CODEC を 1 つ置くと、その生値を TAG なしのその Value として解釈する。

### 任意フィールドとプレースホルダ {#선택-필드와-자리-표지}

[プレースホルダ](slot-marker.md)は、Reference セクション 0 の最初の 3 マス `0x000L~0x002L` に割り当てた 1 WORD レコードのまとまりである。フィールドの CODEC 一覧がその WORD を正確な対象として置いているときに限り、その位置に来ることができる。

| CODEC 対象 | プレースホルダ | そのフィールドは |
|---|---|---|
| `0000` | ABSENT、記載しない | **任意フィールド**である。省略できる |
| `0010` | UNKNOWN-VALUE、不明 | 値はあるが何かは分からないという断言を受け取る |
| `0020` | NO-VALUE、なし | 値がないという断言を受け取る |

- **受理規則:** プレースホルダは、そのフィールドの CODEC 一覧に同じ WORD が正確な対象として置かれているときに限り有効である。ワイルドカード(`000F`、`060F` …)と、CODEC のないフィールド(「任意のレコード」)はプレースホルダを受け取らない。HEAD・BODY のレコード位置と Edge Id の位置では invalid である。
- 任意フィールドを省略するときは、その位置に WORD `0x0000` を 1 つ(ABSENT)書く。任意フィールドも位置は常に占める。そのためレコード 1 つの表記は 1 通りであり、分解は位置だけで定まる。
- プレースホルダは自身の Reference コードを持つため他のレコードと重ならず、規格を知らないデコーダも 1 WORD レコードとして読み飛ばす。
- 3 つのプレースホルダは別の意味である。ABSENT はドキュメントについての言明(この位置を埋めなかった)であり、世界については何も断言しない。UNKNOWN-VALUE は値があるという断言(`∃x`)、NO-VALUE は値がないという断言(`¬∃x`、限定条件の中で)である。省略は「値がない」ではなく「記載しない」である。
- プレースホルダが何を意味するかは、そのプレースホルダを受け取る Codec の規格が定める([TRIPLE](edge/0x0AAL-triple.md)、[QUALIFIER](edge/0x0ABL-qualifier.md))。

## 例: TRIPLE 規格ドキュメント {#예-triple-규격-문서}

`0x00000000/codecs/0x00000AA0` の BODY である。

| Edge | 内容 | 名前(BIND) |
|---|---|---|
| #1 DECLARE | 対象 `0AA0` | `TRIPLE` |
| #2 FIELD | #1 のフィールド、レコード | `predicate` |
| #3 FIELD | #1 のフィールド、レコード | `subject` |
| #4 FIELD | #1 のフィールド、レコード | `object` |
| #5 FIELD | #1 のフィールド、生値 1 WORD | `rank` |
| #6~#8 ENUM | #5 のコード値 0、1、2 | `normal`, `preferred`, `deprecated` |
| #17 CODEC | #5 は UNSIGNED-INTEGER(`0620`)として解釈 | |
| #18, #22, #23, #19, #24 CODEC | #4 は任意の Reference(`000F`・`020F`・`040F`)または任意の Value(`060F`・`080F`) | |
| #20, #21 CODEC | #4 は UNKNOWN-VALUE(`0010`)、NO-VALUE(`0020`)も受け取る | |
| #25~#27 CODEC | #2 は任意の Reference(`000F`・`020F`・`040F`) | |
| #28~#30 CODEC | #3 は任意の Reference(`000F`・`020F`・`040F`) | |

このドキュメント 1 つで、デコーダは TRIPLE レコードをフィールドに分け、フィールド名を付けて表示し、形式が正しいかを検査できる。

## 例: QUANTITY 規格ドキュメント {#예-quantity-규격-문서}

Value QUANTITY(`0660`)は 4 つのフィールドがすべてレコードである。

| フィールド | CODEC |
|---|---|
| `amount` | `0610` SIGNED-INTEGER、`0620` UNSIGNED-INTEGER、`0630` BINARY-FLOAT(有限な値のみ)、`0670` FRACTION、`0680` SIGNED-DECIMAL、`0690` UNSIGNED-DECIMAL |
| `unit` | `000F`・`020F`・`040F` 任意の Reference、`0000` 任意 |
| `lower` | `0610`・`0620`・`0630`・`0670`・`0680`・`0690`(amount と同じ)、`0000` 任意 |
| `upper` | `0610`・`0620`・`0630`・`0670`・`0680`・`0690`(amount と同じ)、`0000` 任意 |

## 規則 {#규칙}

- 規格ドキュメント 1 つにつき DECLARE は 1 つである。DECLARE の対象は Codec ID の TAG WORD と同じである。
- 1 つのドキュメントで同じ対象を 2 度宣言しない。
- フィールド構成が異なる変形は分岐として扱わない。Codec ごとに別々に宣言する。
- 可変の生値が 2 つ以上ある、または生値の幅が他の値によって変わるレイアウトは宣言できない。そのような部分はレコードで包む。
- 規格ドキュメントは他のドキュメントと同様にバージョンで公表される。ただし Codec のバイナリレイアウトは改訂しない。変更するには新しい Codec を割り当てる。

## 未解決の問題 {#열린-문제}

- `SPEC-VERSION` の値(v1 は `0x0001`)からコードブックのドキュメントバージョンへの対応。採択版と提案版をつなぐ系譜 Meta。
