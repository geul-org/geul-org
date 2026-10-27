---
title: "Reference"
weight: 40
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference", "LOCAL", "quantifier"]
summary: "Reference は対象を指すレコードだ。Codec 4ビットで識別体系(LOCAL、Wikidata、外部ドキュメントなど)を、Quantifier 3ビットで量化(識別された、総称、全称、変数など)を決める。予約 Codec 0000 はプレースホルダ群だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Reference は、対象を指すレコードだ。対象はエンティティ、概念、ドキュメント、他の Edge でありうる。名前ではなく ID で指す。

## レイアウト

```
TAG WORD          0000 0LLL LCCC CQQQ
[Length 拡張 TAG]
[IMPORT ID]       EXTERNAL-POINTER のとき (1/2/4/8 WORD)
[Issuer]          EXTERNAL-ISSUER のとき (1/2/4/16 WORD)
[ドキュメント ID]  EXTERNAL-ISSUER のとき (4 WORD)
対象 ID           残りすべて
```

- `LLLL` は TAG WORD を含む全 WORD 数 − 1 だ([レコードと TAG WORD](/ja/grammar/record/))。
- Codec は `CCCC` 4ビット、Quantifier は `QQQ` 3ビットだ。TAG WORD の下位7ビットは `CCCC << 3 | QQQ` だ。
- 対象 ID は符号なしビッグエンディアン整数で、**最短幅**で書く。幅は Length から前のフィールドを引いた残りだ。
- 対象 ID `0` は `0x0000` 1 WORD で書く。それ以外では、先頭に `0x0000` WORD を付けない。
- 整数値が同じなら同じ ID だ。幅は ID の一部ではない。
- すべての Codec が最短幅を使う。Codec が対象 ID の幅を固定しない。
- [ISSUER-POINTER](/ja/grammar/reference/issuer-pointer/) と [DOC-POINTER](/ja/grammar/reference/doc-pointer/) は、このレイアウトに従わない。対象 ID がなく、Issuer(とドキュメント ID・バージョン ID)だけを置く。

## Codec (`CCCC`)

| CCCC | 名前 | 分類 | 対象 |
|---|---|---|---|
| `0000` | [プレースホルダ](/ja/grammar/reference/slot-marker/) | 予約 | 対象を指さない。下位3ビットがマーカー番号の 1 WORD マーカーだけを使う: `0x0000` ABSENT(記載なし)、`0x0001` UNKNOWN-VALUE(不明)、`0x0002` NO-VALUE(なし) |
| `0001` | [LOCAL](/ja/grammar/reference/local/) | 宣言 | このドキュメントが発行した ID |
| `0010` | [GEUL](/ja/grammar/reference/geul/) | 宣言 | geul.org が発行するエンティティ |
| `0011` | [GEUL-SIDX](/ja/grammar/reference/geul-sidx/) | 宣言 | ビットに意味を載せた意味整列識別子 |
| `0100` | [WIKIDATA-QID](/ja/grammar/reference/wikidata-qid/) | 宣言 | Wikidata 項目。`Q` の後の整数 |
| `0101` | [WIKIDATA-PID](/ja/grammar/reference/wikidata-pid/) | 宣言 | Wikidata プロパティ。`P` の後の整数 |
| `0110` | [ISSUER-POINTER](/ja/grammar/reference/issuer-pointer/) | 指示宣言 | Issuer 自身 |
| `0111` | [DOC-POINTER](/ja/grammar/reference/doc-pointer/) | 指示宣言 | Issuer が公表したドキュメントの一バージョン |
| `1000`~`1011` | [EXTERNAL-POINTER-1/2/4/8WORD](/ja/grammar/reference/external-pointer/) | 指示 | IMPORT で取り込んだドキュメントの LOCAL ID |
| `1100`~`1111` | [EXTERNAL-ISSUER-1/2/4/16WORD](/ja/grammar/reference/external-issuer/) | 指示宣言 | Issuer が公表したドキュメントの LOCAL ID |

- **宣言**は、発行主体が定めた ID で対象を直接識別する。
- **指示**は、IMPORT ID で取り込んだドキュメント内の LOCAL を指す。下位2ビットが IMPORT ID の幅だ(`00`=1、`01`=2、`10`=4、`11`=8 WORD)。
- **指示宣言**は、IMPORT なしでレコード一つで他のドキュメントとその中の対象を指す。
- 最上位ビットが `0` なら対象を直接識別し(このドキュメントの LOCAL、発行 ID、Issuer・ドキュメント自体)、`1` なら他のドキュメントの LOCAL を指す。
- Codec `0000` は予約で、対象を指す Reference としては使わない。例外は一つのまとまりだ: WORD `0x0000`~`0x0007`(Codec `0000`、1 WORD)は[プレースホルダ](/ja/grammar/reference/slot-marker/)だ。今は三つを使う(`0x0000` ABSENT、`0x0001` UNKNOWN-VALUE、`0x0002` NO-VALUE)。マーカーは、その WORD を CODEC 対象として厳密に置いたレコードフィールドの位置でのみ有効だ。ワイルドカードと CODEC のないフィールドは受け付けず、HEAD・BODY のレコード位置と Edge Id の位置では invalid だ。`0x0003`~`0x0007` と、Payload のある Codec `0000` は予約だ。
- CC0 でない識別体系(WordNet など)は、Reference Codec に置かない。Reference には ISSUER コードもないので、Issuer 形式に移す場所もない。

### よく使う TAG

| レコード | WORD |
|---|---|
| LOCAL 1 | `0088 0001` |
| LOCAL 65536 | `0108 0001 0000` |
| Wikidata Q5 (人間) | `00A0 0005` |
| Wikidata Q691283 | `0120 000a 8c53` |
| Wikidata P31 (instance of) | `00A8 001f` |
| プレースホルダ ABSENT / UNKNOWN-VALUE / NO-VALUE | `0000` / `0001` / `0002` |

## LOCAL

LOCAL は、このドキュメントが発行した ID だ。ドキュメント内でのみ意味がある。

- **一意だ。** 一つのドキュメントで、LOCAL ID 一つは対象一つだけを指す。
- **0 は割り当てない。** 対象 ID は 1 から割り当てる。
- **増やしながら割り当てることを推奨する**(auto increment)。ID の大小に意味はない。
- バージョンを越えて同じ対象を指す。削除した ID は再利用しない([ドキュメント](/ja/grammar/document/)の改訂)。
- ドキュメントの外から指せるようにするには、ドキュメントに `DOC-ID` がなければならない。
- 異なる LOCAL ID が、現実で異なる対象だという意味ではない。同じなら `SAME-NODE`、異なるなら `DIFFERENT-NODE` Edge で結ぶ。

### Edge Id

すべての Edge は、Payload の最初の要素として LOCAL Reference を置く。その LOCAL ID が **Edge Id** だ。

- コードブックを知らなくても Edge Id を読める。
- Edge Id の位置の LOCAL は宣言で、Edge の他の位置の LOCAL は言及だ。
- Edge Id を宣言する LOCAL の Quantifier は `000` だけを使う。
- 他の Edge は Edge Id で指す。このドキュメントの Edge は LOCAL で、他のドキュメントの Edge は指示 Reference で指す。

## 他のドキュメントを指す

| 何を | どのように |
|---|---|
| Issuer 自身 | `ISSUER-POINTER`(Issuer) |
| ドキュメントの一バージョン | `DOC-POINTER`(Issuer、ドキュメント ID 4 WORD、バージョン ID 2 WORD)。バージョン `0` は最新 |
| 公表ドキュメント内の対象 (最新) | `EXTERNAL-ISSUER-*`(Issuer、ドキュメント ID、LOCAL ID) |
| 取り込んだドキュメント内の対象 (版を固定) | Meta `IMPORT-DOC` で IMPORT ID を割り当て、`EXTERNAL-POINTER-*`(IMPORT ID、LOCAL ID) |

- ドキュメント自体は、そのドキュメントの中でも外でも、DOC-POINTER 一つだけで指す。自分自身は、自分の `DOC-ID` の DOC-POINTER だ。
- EXTERNAL-ISSUER は最新バージョンに従う。版を固定するには IMPORT を使う。
- Issuer は、値が収まる最短幅(1/2/4/16 WORD)で書き、その幅に合う Codec を選ぶ。
- 各 Issuer のドキュメント ID `0` は、その Issuer が定義した用語(ツール、役割など)のインデックスドキュメントとして予約する。インデックスドキュメントはすべての Issuer に推奨で、必須ではない([Issuer と公表](/ja/grammar/issuer/#用語定義ドキュメント))。

例: Issuer `0x0001` のドキュメント `0x0000000000000002` 内の LOCAL 7

```
0360 0001 0000 0000 0000 0002 0007
```

## Quantifier (`QQQ`)

| QQQ | 名前 | 意味 | 例 |
|---|---|---|---|
| `000` | Identified | 識別された個体 | イーロン・マスク、日本 |
| `001` | Generic | 種類全体についての一般的な陳述。例外を許す | 兵士は命令に従う |
| `010` | Free-choice | 条件を満たす任意の対象 | どの兵士でも |
| `011` | Universal | 範囲内のすべての対象 | すべての兵士 |
| `100` | Variable | 談話変数 | その人、この女性 |
| `101`~`111` | 予約 | | |

- **例外: Codec `0000`(プレースホルダ)では、下位3ビットは Quantifier ではなくマーカー番号だ。** マーカー番号と Quantifier の意味はつながらない(`0x0001` UNKNOWN-VALUE は Generic ではない)。この表の Quantifier は Codec `0001`~`1111` にだけ適用される。
- Generic は Universal とは異なり、すべての個別対象に例外なく適用されるという意味ではない。`兵士とは何か` のような定義的な表現は Generic で書ける。厳密な概念・分類の定義が必要なら、別の関係で具体化する。
- 量化の適用範囲と否定は、Reference ではなく、それを使う Edge が決める。
- **Variable** は、種類は分かっているがまだ識別されていない談話中の対象だ。
  - 名前のある変数は、LOCAL に Variable を付ける。同じ LOCAL ID なら同じ変数だ。種類は Edge で結ぶ。
  - 匿名変数は、種類を指す宣言 Codec(GEUL、WIKIDATA-*)に Variable を付ける(例: Wikidata「大統領」+ Variable)。共参照を追跡せず、再び指すことはできない。匿名変数同士は同じ変数と見なさない。
  - 後で対象が確認されたら、変数をその対象と `SAME-NODE` で結ぶ。同じ変数を指すすべての表現が、一緒にその対象として解釈される。
  - 異なる変数でも、実際の対象が異なるという意味ではない。同じなら `SAME-NODE`、異なるなら `DIFFERENT-NODE` で結ぶ。
  - 変数はそのドキュメント内でのみ有効で、永続的な識別子として使わない。
  - 外部指示 Codec(EXTERNAL-POINTER-*、EXTERNAL-ISSUER-*)の Variable は、指すドキュメントの LOCAL 変数だ。
  - 例: `大統領が演説した` で人物が確定していなければ、「大統領」Variable を使う。再び言及するには、LOCAL Variable を置いて種類「大統領」を Edge で結ぶ。後でオバマだと確認されたら、その変数をオバマ Identified と `SAME-NODE` で結ぶ。同じ変数を指すすべての表現が、一緒にオバマとして解釈される。
- 例: Wikidata Q5(人間)を Generic で使うと `00A1 0005`(「人間は …」)だ。
