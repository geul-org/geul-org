---
title: "プレースホルダ"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference", "ABSENT", "UNKNOWN-VALUE", "NO-VALUE"]
summary: "プレースホルダは、予約 Reference Codec 0000 に置いた 1 WORD レコード群だ。0x0000 ABSENT(記載なし)、0x0001 UNKNOWN-VALUE(不明)、0x0002 NO-VALUE(なし)が、レコードフィールドの位置を埋める。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

プレースホルダ(slot marker)は、レコードフィールドの位置を埋める 1 WORD レコードだ。何も指さない。予約 Reference Codec `0000` に置く。

値の位置に来られる言葉は三つある。値を書かなかった、値はあるが何かは分からない、値がない。三つは別のものだ。プレースホルダは、この三つを隣り合う三つの WORD に分けて書く。

## レイアウト

```
TAG WORD          0000 0000 0000 0MMM
                  Prefix 000, Kind 00(Reference), LLLL 0000(1 WORD), CCCC 0000, MMM = マーカー番号
```

| WORD | 名前 | 意味 | 表記 |
|---|---|---|---|
| `0x0000` | ABSENT | 記載なし | `ABSENT` |
| `0x0001` | UNKNOWN-VALUE | 不明: 値がある。何かは分からない | `UNKNOWN` |
| `0x0002` | NO-VALUE | なし: 値がない | `NONE` |
| `0x0003`~`0x0007` | 予約 | | |
| CCCC `0000`、LLLL ≥ `0001` | 予約 | Payload のあるマーカーは後で定める | |

- 下位3ビット `MMM` は **Quantifier ではなくマーカー番号**だ。他の Reference Codec の `QQQ` と位置が同じなだけで、意味はつながらない([Reference](/ja/grammar/reference/) の Quantifier の例外)。
- Payload はない。対象 ID もない。
- コードブックのないデコーダも、TAG WORD だけを見て Kind が Reference で 1 WORD だと分かり、読み飛ばす。「WORD の値が `0`~`7` ならプレースホルダ」は、ビット検査一つ(`w & 0xFFF8 == 0`)で分かる。
- 表記 `ABSENT`・`UNKNOWN`・`NONE` は、`geul show`・`geul add` のテキスト表記だ。

## 三つの区別

| | 記載なし (ABSENT) | 不明 (UNKNOWN-VALUE) | なし (NO-VALUE) |
|---|---|---|---|
| 何についての言葉か | **ドキュメント**: この位置を埋めなかった | **世界**: 値がある。何かは分からない | **世界**: 値がない |
| 論理 | 何も断言しない | `∃x. P(s, x)`、x は識別されない | `¬∃x. P(s, x)` |
| 世界の仮定 | 開いた世界 (情報なし) | 存在は閉じ、正体は開く | (s, P, 限定条件) について閉じた世界 |
| Wikidata | 該当する snak がない | `somevalue` | `novalue` |
| どこで使うか | CODEC 対象 `0000` を置いたオプションフィールド (SOURCE の Origin など) | CODEC 対象 `0001` を置いたフィールド (TRIPLE Object、QUALIFIER Value、SOURCE Origin) | CODEC 対象 `0002` を置いたフィールド (TRIPLE Object、QUALIFIER Value) |
| 「子(P40)は何人か」 | 分からない | 1 人以上 | 0 人 |
| 「終了時点(P582)があるか」 | 分からない → 今も有効か分からない | 終わった。いつかは分からない | 終わっていない(断言) |

命題単位でも同じ区別が成り立つ。**TRIPLE がドキュメントにない**ことは、記載なしだ。GEUL ドキュメントは開いた世界なので、記述がないからといって事実がないわけではない。「ない」は、NO-VALUE として**書いて**初めて言える。

## 受け入れ規則

- プレースホルダは、そのフィールドの [CODEC](/ja/grammar/edge/codec/) 一覧に**同じ WORD が厳密な対象としてあるときだけ**有効だ。対象 `0000` は「オプションフィールド」、`0001` は「不明を受け付ける」、`0002` は「なしを受け付ける」という意味だ。
- ワイルドカード(`0780`、`0781`、`0F80` など)はマーカーを受け付けない。Reference のワイルドカードも Codec `0000` とは重ならない。
- CODEC のないレコードフィールド(「任意のレコード」)もマーカーを受け付けない。
- HEAD・BODY のレコード位置、Edge Id の位置のマーカーは invalid だ。
- 生値フィールドにはマーカーを使えない。生値は TAG がなく、1 WORD のマーカーが入る位置がない。
- マーカー対象だけの CODEC 一覧(常にマーカー)は invalid だ。
- マーカーの意味(何があって何がないか)は、そのマーカーを受け取る Edge 規格が決める。量化と否定は Reference ではなく Edge が決めるという原則と同じだ。
- プレースホルダには Codec 規格ドキュメントがない。[0 層](/ja/grammar/publishing/#層)(デコーダ内蔵)だ。DECLARE の Reference 対象は Quantifier の位置を 0 にするので、`0x0001`・`0x0002` の規格ドキュメントは作れず、三つとも Payload がないので内蔵のコストもない。

## 読む側の義務

1. **UNKNOWN-VALUE は値ではなく存在の断言だ。** 他のどの値とも同じではなく、異なってもいない(比較結果は未定)。二つの UNKNOWN-VALUE 同士も同じ値と見なさない。出現ごとに独立した存在量化だ(Wikidata の blank node と同じ)。
   - そのためバイトが同じ TRIPLE 二つ(`P40 Q… UNKNOWN` ×2)は重複ではない。子が二人かもしれないし、一人かもしれない。UNKNOWN-VALUE を収めた TRIPLE は、重複マージしない。
   - 後で正体が判明したら、その TRIPLE を直した新しいバージョンを出す。UNKNOWN-VALUE は指せない。共参照が必要なら LOCAL Variable を使う([Reference](/ja/grammar/reference/) の Variable)。
2. **NO-VALUE は、その命題の限定条件の中で閉じる。** QUALIFIER が付けば、その範囲でのみ閉じる。Q30 P1304 NO-VALUE(P580 1811、P582 1816)は、1811~1816年にだけ中央銀行がなかったという意味で、同じ属性の値 TRIPLE(連邦準備制度、preferred)と矛盾しない。
   - 同じ Subject・Predicate に NO-VALUE と値の TRIPLE が、同じ rank で、限定条件で区別されないまま併存していれば矛盾だ。検査器は警告を出す。拒否はしない。Wikidata にもある状態で、読む側が rank で選ぶ。
3. **rank も同様に適用される。** 代表値(truthy)を選ぶとき、UNKNOWN-VALUE・NO-VALUE TRIPLE も候補に入る。preferred があれば preferred だけが残る。
4. **QUALIFIER の値として使うと、その限定の意味を変える。** `P582 = UNKNOWN` なら終わっていて時点が分からない。今も有効な命題とは読まない。`P582 = NONE` なら終わっていないと断言する。P582 QUALIFIER がそもそもなければ、終わったか分からない。
5. **ABSENT は世界について何も言わない。** UNKNOWN-VALUE や NO-VALUE として読まない。逆に、変換器が移せなかった値(原典にはある値)を UNKNOWN-VALUE として書くことは禁止する。原典では値が分かっているからだ。原典が語っていない位置(例: 原典を記述しない出典の [SOURCE](/ja/grammar/edge/source/) の Origin)も、変換器は ABSENT で書く。UNKNOWN-VALUE は「ある」という断言なので、原典がそう語るときにだけ使う。

## 他の「なし」との違い

- [LOCAL](/ja/grammar/reference/local/) `0` を「なし」として使う Codec 規則([TOULMIN](/ja/grammar/edge/toulmin/) の REF など)は、その Codec 内の約束だ。プレースホルダとは異なる。
- Identified LOCAL を null・sentinel として使わない。不明・不在を書くには、プレースホルダを受け付けるフィールドにマーカーを使う。

## 例

Q30(アメリカ)–Q34266(ロシア帝国)の国境、終了時点が不明。Edge Id は説明用だ。

```
148A 0088 080C 00A8 002F 00A0 001E 00A0 85DA 0000      #2060 TRIPLE P47 Q30 Q34266 normal
138B 0088 0C58 00A8 0246 0088 080C 0001                #3160 QUALIFIER P582 #2060 UNKNOWN
```

Q30 の中央銀行、1811~1816年にはなかった。

```
140A 0088 0C59 00A8 0518 00A0 001E 0002 0000           #3161 TRIPLE P1304 Q30 NONE normal
148B 0088 0C5A 00A8 0244 0088 0C59 0924 3138 3131      #3162 QUALIFIER P580 #3161 EDTF("1811")
148B 0088 0C5B 00A8 0246 0088 0C59 0924 3138 3136      #3163 QUALIFIER P582 #3161 EDTF("1816")
```

- マーカーの位置は 1 WORD だ。TRIPLE は 9 WORD(`140A`)、QUALIFIER は 8 WORD(`138B`)になる。
- 単純な形で「子(P40)なし」は `140A 0088 <Edge Id> 00A8 0028 <Subject> 0002 0000` だ。

## 関連ページ

- [Reference](/ja/grammar/reference/)、[CODEC](/ja/grammar/edge/codec/)、[Codec 規格ドキュメント](/ja/grammar/codec-spec/)
- [TRIPLE](/ja/grammar/edge/triple/)、[QUALIFIER](/ja/grammar/edge/qualifier/)、[TOULMIN](/ja/grammar/edge/toulmin/)
