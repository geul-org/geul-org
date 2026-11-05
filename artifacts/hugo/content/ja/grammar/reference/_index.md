---
title: "Reference"
weight: 90
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "LOCAL", "quantifier"]
summary: "Reference は、対象を指すレコードだ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Reference は、対象を指すレコードだ。対象はエンティティ、概念、ドキュメント、別の Edge でありうる。名前ではなく ID で指す。

## レイアウト {#레이아웃}

```
TAG WORD          000K KKKC CCCC LLLL      セクション 0~2 (0x000L~0x05FL)
[Length 拡張 TAG]
[IMPORT ID]       EXTERNAL-POINTER のとき (1/2/4 WORD)
[Issuer]          EXTERNAL-ISSUER のとき (2/4/16 WORD)
[ドキュメント ID] EXTERNAL-ISSUER のとき (4 WORD)
対象 ID           残り全部
```

- `LLLL` は TAG WORD を含む全体の WORD 数 − 1 だ([レコードと TAG WORD](../record.md))。
- Reference はセクション 0~2(`w < 0x0600`)の 96 枠だ。セクション 0 エンティティ `0x000L~0x01FL`、セクション 1 EXTERNAL `0x020L~0x03FL`、セクション 2 その他 `0x040L~0x05FL` だ。
- Codec はコード表で書く(下の表)。5Q 体系は、コード 1 つに識別体系と量化が一緒に入っている。REFERENCE-ISSUER の量化は Issuer ドキュメントが定める。
- 対象 ID は符号なしビッグエンディアン整数で、**最短幅**で書く。幅は Length から前のフィールドを引いた残りだ。
- 対象 ID `0` は `0x0000` 1 WORD で書く。それ以外では先頭に `0x0000` WORD を付けない。
- 整数値が同じなら同じ ID だ。幅は ID の一部ではない。
- すべての Codec が最短幅を使う。Codec が対象 ID の幅を固定しない。
- [ISSUER-POINTER](0x040L-issuer-pointer.md)、[DOC-POINTER](0x041L-doc-pointer.md)、[CODEC-POINTER](0x042L-codec-pointer.md) は、このレイアウトに従わない。対象 ID がなく、Issuer(とドキュメント ID・Codec ID・バージョン ID)だけを置く。
- [REFERENCE-ISSUER](#reference-issuer) もこのレイアウトに従わない。TAG、Issuer、Codec 番号 2 WORD、Payload だ。Payload は Issuer が発行した Codec ドキュメントが定める。

## Codec {#codec}

| TAG ID | 名前 | 分類 | 対象 |
|---|---|---|---|
| `0x000L~0x002L` | [プレースホルダ](../slot-marker.md) | プレースホルダ | 対象を指さない。1 WORD のマーカーだけを使う: `0x0000` ABSENT(記載なし)、`0x0010` UNKNOWN-VALUE(不明)、`0x0020` NO-VALUE(なし) |
| `0x005L~0x009L` | [LOCAL](0x005L-local.md) | 宣言 | このドキュメントが発行した ID |
| `0x00AL~0x00EL` | [GEUL](0x00AL-geul.md) | 宣言 | geul.org が発行するエンティティ |
| `0x00FL~0x013L` | [GEUL-SIDX](0x00FL-geul-sidx.md) | 宣言 | ビットに意味を持たせた意味整列識別子 |
| `0x014L~0x018L` | [WIKIDATA-QID](0x014L-wikidata-qid.md) | 宣言 | Wikidata のアイテム。`Q` の後の整数 |
| `0x019L~0x01DL` | [WIKIDATA-PID](0x019L-wikidata-pid.md) | 宣言 | Wikidata のプロパティ。`P` の後の整数 |
| `0x020L~0x02EL` | [EXTERNAL-POINTER-1/2/4WORD](0x020L-external-pointer-1word.md) | 指示 | IMPORT で取り込んだドキュメントの LOCAL ID |
| `0x02FL~0x03DL` | [EXTERNAL-ISSUER-2/4/16WORD](0x02FL-external-issuer-2word.md) | 指示宣言 | Issuer が公表したドキュメントの LOCAL ID |
| `0x040L` | [ISSUER-POINTER](0x040L-issuer-pointer.md) | 指示宣言 | Issuer 自身 |
| `0x041L` | [DOC-POINTER](0x041L-doc-pointer.md) | 指示宣言 | Issuer が公表したドキュメントの 1 つのバージョン |
| `0x042L` | [CODEC-POINTER](0x042L-codec-pointer.md) | 指示宣言 | Issuer が公表した Codec の 1 つのバージョン |
| `0x05DL~0x05FL` | [REFERENCE-ISSUER-2/4/16WORD](#reference-issuer) | Issuer 形式 | Issuer が定義する。分類と対象 ID の枠は Issuer ドキュメントが定める |

- Reserved は `0x003L~0x004L`、`0x01EL~0x01FL`(セクション 0)、`0x03EL~0x03FL`(セクション 1)、`0x043L~0x05CL`(セクション 2、新しい識別体系の位置)だ。
- 体系番号はセクション内オフセット `C` で読む。セクション 0 で `5 <= C < 30` なら体系 `C / 5`(1~5)、セクション 1 で `C < 30` なら体系 `6 + C / 5`(6~11)だ。

| 体系 | 名前 | Identified | Generic | Free-choice | Universal | Variable |
|---:|---|---|---|---|---|---|
| 1 | LOCAL | `0x005L` | `0x006L` | `0x007L` | `0x008L` | `0x009L` |
| 2 | GEUL | `0x00AL` | `0x00BL` | `0x00CL` | `0x00DL` | `0x00EL` |
| 3 | GEUL-SIDX | `0x00FL` | `0x010L` | `0x011L` | `0x012L` | `0x013L` |
| 4 | WIKIDATA-QID | `0x014L` | `0x015L` | `0x016L` | `0x017L` | `0x018L` |
| 5 | WIKIDATA-PID | `0x019L` | `0x01AL` | `0x01BL` | `0x01CL` | `0x01DL` |
| 6 | EXTERNAL-POINTER-1WORD | `0x020L` | `0x021L` | `0x022L` | `0x023L` | `0x024L` |
| 7 | EXTERNAL-POINTER-2WORD | `0x025L` | `0x026L` | `0x027L` | `0x028L` | `0x029L` |
| 8 | EXTERNAL-POINTER-4WORD | `0x02AL` | `0x02BL` | `0x02CL` | `0x02DL` | `0x02EL` |
| 9 | EXTERNAL-ISSUER-2WORD | `0x02FL` | `0x030L` | `0x031L` | `0x032L` | `0x033L` |
| 10 | EXTERNAL-ISSUER-4WORD | `0x034L` | `0x035L` | `0x036L` | `0x037L` | `0x038L` |
| 11 | EXTERNAL-ISSUER-16WORD | `0x039L` | `0x03AL` | `0x03BL` | `0x03CL` | `0x03DL` |

- **宣言**は、発行主体が定めた ID で対象を直接識別する。
- **指示**は、IMPORT ID で取り込んだドキュメント内の LOCAL を指す。IMPORT ID の幅は体系で決まる: 体系 − 6 が 0、1、2 なら 1、2、4 WORD だ。
- **指示宣言**は、IMPORT なしにレコード 1 つで、別のドキュメントとその中の対象を指す。EXTERNAL-ISSUER の Issuer 幅は、体系 − 9 が 0、1、2 なら 2、4、16 WORD だ。
- `0x020L~0x03DL`(セクション 1、体系 6~11)は、別のドキュメントの LOCAL を指す。それ以外の宣言体系は対象を直接識別する(このドキュメントの LOCAL、発行 ID)。ポインタ(セクション 2、`0x040L~0x042L`)は、Issuer・ドキュメント・Codec そのものを指す。REFERENCE-ISSUER はこの区分の外だ。
- `0x000L~0x002L` はプレースホルダに割り当てたコードで、対象を指す Reference としては使わない。WORD `0x0000`、`0x0010`、`0x0020`(L 0、1 WORD)は[プレースホルダ](../slot-marker.md)だ(`0x0000` ABSENT、`0x0010` UNKNOWN-VALUE、`0x0020` NO-VALUE)。マーカーは、その WORD を CODEC 対象として正確に置いたレコードのフィールド位置でのみ有効だ。ワイルドカードと CODEC のないフィールドは受け取らず、HEAD・BODY のレコード位置と Edge Id 位置では invalid だ。C 0~2 に Payload のある TAG 形(L ≥ 1)は Reserved だ。
- geul.org が提供する直接コードと公表物だけが CC0 だ。CC0 でない識別体系(WordNet など)を直接コードに置かない。Issuer 形式のライセンスは、その Issuer が定める。

### よく使う TAG {#자주-쓰는-tag}

| レコード | WORD |
|---|---|
| LOCAL 1 | `0051 0001` |
| LOCAL 65536 | `0052 0001 0000` |
| Wikidata Q5 (人間) | `0141 0005` |
| Wikidata Q691283 | `0142 000A 8C53` |
| Wikidata P31 (instance of) | `0191 001F` |
| プレースホルダ ABSENT / UNKNOWN-VALUE / NO-VALUE | `0000` / `0010` / `0020` |

## LOCAL {#local}

LOCAL は、このドキュメントが発行した ID だ。

- **一意だ。** 1 つのドキュメントで LOCAL ID 1 つは対象 1 つだけを指す。
- **0 は割り当てない。** 対象 ID は 1 から割り当てる。
- **増やしながら割り当てることを推奨する**(auto increment)。ID の大小に意味はない。
- バージョンをまたいで同じ対象を指す。削除した ID は再利用しない([ドキュメント](../document.md)の改訂)。
- ドキュメントの外から指せるようにするには、ドキュメントに `DOC-ID` がなければならない。
- 異なる LOCAL ID が現実でも異なる対象だという意味ではない。同じなら `SAME-NODE`、異なるなら `DIFFERENT-NODE` Edge で結ぶ。

### Edge Id {#edge-id}

すべての Edge は、Payload の最初の要素として LOCAL Reference を置く。その LOCAL ID が **Edge Id** だ。

- コードブックを知らなくても Edge Id を読める。
- Edge Id 位置の LOCAL は宣言で、Edge のほかの位置の LOCAL は言及だ。
- Edge Id を宣言する LOCAL は Identified(`0x005L`)だけを使う。
- 別の Edge は Edge Id で指す。このドキュメントの Edge は LOCAL で、別のドキュメントの Edge は指示 Reference で指す。

## 別のドキュメントを指す {#다른-문서-가리키기}

| 何を | どのように |
|---|---|
| Issuer 自身 | `ISSUER-POINTER`(Issuer) |
| ドキュメントの 1 つのバージョン | `DOC-POINTER`(Issuer、ドキュメント ID 4 WORD、バージョン ID 2 WORD)。バージョン `0` は最新 |
| Codec の 1 つのバージョン | `CODEC-POINTER`(Issuer、Codec ID 2 WORD、バージョン ID 2 WORD)。バージョン `0` は最新 |
| 公表ドキュメント内の対象 (最新) | `EXTERNAL-ISSUER-*`(Issuer、ドキュメント ID、LOCAL ID) |
| 取り込んだドキュメント内の対象 (版を固定) | Meta `IMPORT-DOC` で IMPORT ID を割り当て、`EXTERNAL-POINTER-*`(IMPORT ID、LOCAL ID) |

- ドキュメント自体は、そのドキュメントの内でも外でも DOC-POINTER 1 つだけで指す。自分自身は自分の `DOC-ID` の DOC-POINTER だ。Codec ドキュメントは例外で、CODEC-POINTER で指す(`DOC-ID` も CODEC-POINTER)。
- EXTERNAL-ISSUER は最新バージョンに従う。版を固定するには IMPORT を使う。
- Issuer は値が収まる最短幅(2/4/16 WORD)で書き、その幅に合う Codec を選ぶ。EXTERNAL-ISSUER と REFERENCE-ISSUER で同じだ。
- 各 Issuer のドキュメント ID `0` は、その Issuer が定義した用語(ツール、役割など)の索引ドキュメントとして予約する。索引ドキュメントはすべての Issuer に推奨するもので、必須ではない([Issuer と公表](../issuer.md#용어-정의-문서))。

例: Issuer `0x00000002` のドキュメント `0x0000000000000002` 内の LOCAL 7

```
02F7 0000 0002 0000 0000 0000 0002 0007
```

## Quantifier {#quantifier}

| `C % 5` | 名前 | 意味 | 例 |
|---|---|---|---|
| `0` | Identified | 識別された個体 | イーロン・マスク、大韓民国 |
| `1` | Generic | 種類全体についての一般的な陳述。例外を許す | 兵士は命令に従う |
| `2` | Free-choice | 条件を満たす任意の対象 | どの兵士でも |
| `3` | Universal | 範囲内のすべての対象 | すべての兵士 |
| `4` | Variable | 談話変数 | その人、この女性 |

- **量化は 5Q 体系(体系 1~11)でのみ読む。** セクション内オフセット `C` で、セクション 0 は `5 <= C < 30`、セクション 1 は `C < 30` のとき量化 `C % 5` だ。1 セクションが 32 枠なので、9 ビットの Codec 位置(`w >> 4`)を 5 で割るとセクション 1 がずれる。マーカー(セクション 0、`C < 3`)とセクション 2(ポインタ、REFERENCE-ISSUER)には量化がない。マーカー `0x0010` UNKNOWN-VALUE は Generic ではない。REFERENCE-ISSUER の量化は、Issuer が発行した Codec ドキュメントが定める。
- Generic は、Universal と違い、すべての個別対象に例外なく適用されるという意味ではない。「兵士とは何か」のような定義的な表現は Generic で書ける。厳密な概念・分類の定義が必要なら、別の関係として具体化する。
- 量化の適用範囲と否定は、Reference ではなくそれを使う Edge が定める。
- **Variable** は、種類は分かっているがまだ識別されていない談話内の対象だ。
  - 名前付きの変数は、LOCAL に Variable を付ける。同じ LOCAL ID なら同じ変数だ。種類は Edge で結ぶ。
  - 匿名の変数は、種類を指す宣言 Codec(GEUL、WIKIDATA-*)に Variable を付ける(例: Wikidata「大統領」+ Variable)。共参照を追跡せず、再び指すことはできない。匿名変数同士は同じ変数と見なさない。
  - 後で対象が確認されたら、変数をその対象と `SAME-NODE` で結ぶ。同じ変数を指すすべての表現がまとめてその対象に解釈される。
  - 異なる変数でも、実際の対象が異なるという意味ではない。同じなら `SAME-NODE`、異なるなら `DIFFERENT-NODE` で結ぶ。
  - 外部指示 Codec(EXTERNAL-POINTER-*、EXTERNAL-ISSUER-*)の Variable は、指す先のドキュメントの LOCAL 変数だ。
  - 例: 「大統領が演説した」で人物が確定していなければ、「大統領」Variable を使う。再び言及するには LOCAL Variable を置き、種類「大統領」を Edge で結ぶ。後でオバマと確認されたら、その変数をオバマ Identified と `SAME-NODE` で結ぶ。同じ変数を指すすべての表現がまとめてオバマに解釈される。
- 例: Wikidata Q5(人間)を Generic で使うと `0151 0005`(「人間は…」)だ。

## REFERENCE-ISSUER {#reference-issuer}

REFERENCE-ISSUER は、Issuer が定義する Reference 形式だ。Reference 区画の末尾 3 つの枠だ。Value・Edge の ISSUER とレイアウトが同じだ([レコードと TAG WORD](../record.md#issuer-형식-레코드))。

### レイアウト {#레이아웃-1}

```
TAG WORD          0000 0101 11WW LLLL      Codec 0x05DL / 0x05EL / 0x05FL (WW = Issuer 幅: 01 2, 10 4, 11 16 WORD)
[Length 拡張 TAG]
Issuer            2/4/16 WORD (Codec が幅を定める)
Codec 番号        2 WORD。Issuer が定義する
Payload           Issuer が発行した Codec ドキュメントが定める
```

| Codec | 名前 | Issuer 幅 |
|---|---|---|
| `0x05DL` | [REFERENCE-ISSUER-2WORD](0x05DL-reference-issuer-2word.md) | 2 WORD |
| `0x05EL` | [REFERENCE-ISSUER-4WORD](0x05EL-reference-issuer-4word.md) | 4 WORD |
| `0x05FL` | [REFERENCE-ISSUER-16WORD](0x05FL-reference-issuer-16word.md) | 16 WORD |

- コードごとにページがある: [REFERENCE-ISSUER-2WORD](0x05DL-reference-issuer-2word.md)、[REFERENCE-ISSUER-4WORD](0x05EL-reference-issuer-4word.md)、[REFERENCE-ISSUER-16WORD](0x05FL-reference-issuer-16word.md)。
- GEUL Issuer の Codec ドキュメントはコードごとに 1 つで、FIELD を 3 つ置く: Issuer(2・4・16 WORD)、Codec 番号(2 WORD)、Payload(Issuer Codec が定める)。

### 解釈と有効性 {#해석과-유효성}

- GEUL は Length で Payload の境界だけを知る。Payload はコードブックなしには解釈しない。
- Codec 番号の意味と量化は Issuer が定める。何を指すかも、Issuer が発行した Codec ドキュメントが定める。
- Reference 共通規則は適用されない: 対象 ID の最短幅、対象 ID `0` の 1 WORD 表記、Quantifier、セクション内オフセットによる量化・体系の読み、宣言・指示の分類、指す対象。
- Codec 番号 2 WORD は Value・Edge の ISSUER と同じだ。番号が足りなければ Issuer をもう 1 つ発行してもらう。
- 形式を知らないデコーダは、Kind、Length、Issuer、Codec 番号までを知り、Length で読み飛ばす。
- Issuer 形式のライセンスは、その Issuer が定める([Issuer と公表](../issuer.md#라이선스))。

### 関連ページ {#관련-페이지}

- [レコードと TAG WORD](../record.md)、[Issuer と公表](../issuer.md)
