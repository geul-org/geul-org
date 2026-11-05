---
title: "プレースホルダ"
weight: 80
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "ABSENT", "UNKNOWN-VALUE", "NO-VALUE"]
summary: "プレースホルダ(slot marker)は、レコードのフィールドの位置を埋める 1 WORD レコードである。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

プレースホルダ(slot marker)は、レコードのフィールドの位置を埋める 1 WORD レコードである。何も指さない。Reference セクション 0 の最初の 3 マス `0x000L~0x002L` に割り当てたコードである。プレースホルダごとにページがある: [ABSENT](reference/0x000L-absent.md)、[UNKNOWN-VALUE](reference/0x001L-unknown-value.md)、[NO-VALUE](reference/0x002L-no-value.md)。

値の位置に来られる言明は 3 つある。値を記載しなかった、値はあるが何かは分からない、値がない。3 つは別のものである。プレースホルダはこの 3 つを、隣り合う 3 つの WORD に分けて書く。

## レイアウト {#레이아웃}

```
TAG WORD          0000 0000 00CC 0000
                  Prefix 000, セクション 0(Reference), Codec 0~2, LLLL 0000(1 WORD)
```

| WORD | 名前 | 意味 | 表記 |
|---|---|---|---|
| `0x0000` | [ABSENT](reference/0x000L-absent.md) | 記載しない | `ABSENT` |
| `0x0010` | [UNKNOWN-VALUE](reference/0x001L-unknown-value.md) | 不明: 値がある。何かは分からない | `UNKNOWN` |
| `0x0020` | [NO-VALUE](reference/0x002L-no-value.md) | なし: 値がない | `NONE` |
| Codec 0~2, LLLL ≥ `0001` | Reserved | この TAG の形(Payload のあるプレースホルダ)は割り当てていない | |

- プレースホルダには **Quantifier がない。** 量化は 5Q 体系(セクション 0 の `5 <= C < 30`、セクション 1 の `C < 30`)でのみ読む。`0x0010` UNKNOWN-VALUE を `C % 5` で読んで Generic と解釈しない([Reference](reference/_index.md) Quantifier)。
- Payload がない。対象 ID もない。
- コードブックのないデコーダも、TAG WORD だけを見て、Kind が Reference で 1 WORD であることを知り、読み飛ばす。「WORD の値が `0x0000`、`0x0010`、`0x0020` ならプレースホルダ」は `w & 0xF == 0 && w <= 0x0020` で分かる。
- 表記 `ABSENT`・`UNKNOWN`・`NONE` は、`geul show`・`geul add` のテキスト表記である。

## 3 つの区別 {#세-가지-구분}

| | 記載しない (ABSENT) | 不明 (UNKNOWN-VALUE) | なし (NO-VALUE) |
|---|---|---|---|
| 何についての言明か | **ドキュメント**: この位置を埋めなかった | **世界**: 値がある。何かは分からない | **世界**: 値がない |
| 論理 | 何も断言しない | `∃x. P(s, x)`、x は識別されない | `¬∃x. P(s, x)` |
| 世界の仮定 | 開いた世界 (情報なし) | 存在は閉じ、正体は開く | (s, P, 限定条件)について閉じた世界 |
| Wikidata | 該当する snak がない | `somevalue` | `novalue` |
| どこに使うか | CODEC 対象 `0000` を置いた任意フィールド (SOURCE Origin など) | CODEC 対象 `0010` を置いたフィールド (TRIPLE Object、QUALIFIER Value、SOURCE Origin) | CODEC 対象 `0020` を置いたフィールド (TRIPLE Object、QUALIFIER Value) |
| 「子(P40)は何人か」 | 不明 | 1 人以上 | 0 人 |
| 「終了時点(P582)はあるか」 | 不明 → 今も有効か不明 | 終わった。いつかは不明 | 終わっていない(断言) |

命題の単位でも同じ区別が成り立つ。**TRIPLE がドキュメントにないこと**は、記載しないことである。GEUL ドキュメントは開いた世界であるため、叙述がないからといって事実がないわけではない。「ない」は、NO-VALUE として**書いてはじめて**言える。

## 受理規則 {#수용-규칙}

- プレースホルダは、そのフィールドの [CODEC](edge/0x0BEL-codec.md) 一覧に**同じ WORD が正確な対象として置かれているときにのみ**有効である。対象 `0000` は「任意フィールド」、`0010` は「不明を受け取る」、`0020` は「なしを受け取る」という意味である。
- ワイルドカード(`000F`、`060F` など、`L=1111`)はプレースホルダを受け取らない。任意の Reference(`000F`・`020F`・`040F`)もプレースホルダと重ならない。
- CODEC のないレコードフィールド(「任意のレコード」)もプレースホルダを受け取らない。
- HEAD・BODY のレコード位置と Edge Id の位置のプレースホルダは invalid である。
- 生値フィールドにはプレースホルダを使えない。生値は TAG がなく、1 WORD のプレースホルダが入る位置がない。
- プレースホルダ対象だけの CODEC 一覧(常にプレースホルダ)は invalid である。
- プレースホルダの意味(何があり何がないか)は、そのプレースホルダを受け取る Edge の規格が定める。量化と否定は Reference ではなく Edge が定めるという原則と同じである。
- プレースホルダの意味と受理規則は[層 0](publishing.md#층)(デコーダ内蔵)である。3 つとも Payload がないため、内蔵のコストもない。それでもコードごとにコーデックドキュメントを置く。コーデックドキュメントは DECLARE だけを置き、FIELD はない。

## 読む側の義務 {#읽는-쪽의-의무}

プレースホルダごとにページに書く。要点は次のとおりである。

- [UNKNOWN-VALUE](reference/0x001L-unknown-value.md#읽는-쪽의-의무)は値ではなく存在の断言である。どの値とも等しくも異なりもせず、その TRIPLE は重複をマージしない。
- [NO-VALUE](reference/0x002L-no-value.md#읽는-쪽의-의무)は、その命題の限定条件の中で閉じる。
- 2 つのプレースホルダとも rank が同様に適用され、QUALIFIER の値として使われるとその限定の意味を変える。
- [ABSENT](reference/0x000L-absent.md#읽는-쪽의-의무)は世界について何も語らない。移せなかった値を UNKNOWN-VALUE として使わない。

## 他の「なし」との違い {#다른-없음과의-차이}

- [LOCAL](reference/0x005L-local.md) `0` を「なし」として使う Codec 規則([TOULMIN](toulmin/_index.md) REF など)は、その Codec 内の約束である。プレースホルダとは異なる。
- Identified LOCAL を null・sentinel として使わない。不明・不在を書くには、プレースホルダを受け取るフィールドにプレースホルダを使う。

## 例 {#예시}

Q30(アメリカ合衆国)–Q34266(ロシア帝国)の国境、終了時点は不明。Edge Id は説明用である。

```
0AA9 0051 080C 0191 002F 0141 001E 0141 85DA 0000      #2060 TRIPLE P47 Q30 Q34266 normal
0AB7 0051 0C58 0191 0246 0051 080C 0010                #3160 QUALIFIER P582 #2060 UNKNOWN
```

Q30 の中央銀行、1811~1816 年にはなかった。

```
0AA8 0051 0C59 0191 0518 0141 001E 0020 0000           #3161 TRIPLE P1304 Q30 NONE normal
0AB9 0051 0C5A 0191 0244 0051 0C59 06E2 3138 3131      #3162 QUALIFIER P580 #3161 EDTF("1811")
0AB9 0051 0C5B 0191 0246 0051 0C59 06E2 3138 3136      #3163 QUALIFIER P582 #3161 EDTF("1816")
```

- プレースホルダの位置は 1 WORD である。TRIPLE は 9 WORD(`0AA8`)、QUALIFIER は 8 WORD(`0AB7`)になる。
- 単純な形で「子(P40)なし」は `0AA8 0051 <Edge Id> 0191 0028 <Subject> 0020 0000` である。

## 関連ページ {#관련-페이지}

- [ABSENT](reference/0x000L-absent.md)、[UNKNOWN-VALUE](reference/0x001L-unknown-value.md)、[NO-VALUE](reference/0x002L-no-value.md)
- [Reference](reference/_index.md)、[CODEC](edge/0x0BEL-codec.md)、[Codec 規格ドキュメント](codec-spec.md)
- [TRIPLE](edge/0x0AAL-triple.md)、[QUALIFIER](edge/0x0ABL-qualifier.md)、[TOULMIN](toulmin/_index.md)
