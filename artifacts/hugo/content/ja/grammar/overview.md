---
title: "概要"
weight: 10
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "overview"]
summary: "GEUL v1 は16ビットワードからなるレコードの連続だ。レコードは Reference、Value、Edge、Meta の四種類で、レコードは一つのドキュメントに収められる。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL(General Encoding Unified Language)は、人と AI があいまいさなくやり取りするための人工言語であり、バイナリ形式だ。このドキュメントは GEUL v1 の文法を定義する。

## 一目でわかる全体像

- すべてのデータは**16ビットワード(WORD)**の連続だ。ビッグエンディアンで書く。
- データの単位は**レコード**だ。レコードは TAG WORD 一つで始まり、その TAG WORD がレコードの種類と長さを示す。
- レコードは四種類(**Kind**)ある。

| Kind | 役割 | 例 |
|---|---|---|
| Reference | 対象を指す | Wikidata Q42、このドキュメント内の #7 |
| Value | 値そのものを持つ | 日付、数量、言語付きテキスト |
| Edge | 他のレコードを束ねて記述する | 「Q42 は人間である」、「Q42 の英語名は Douglas Adams である」 |
| Meta | ドキュメントについて述べる | 仕様の版、ドキュメント ID、作成者、署名 |

- レコードは**ドキュメント**一つに収められる。ドキュメントは HTML のように HEAD(Meta、そしてドキュメント全体の出典である SOURCE とその QUALIFIER)と BODY(Reference・Value・Edge)に分かれる。
- ドキュメントは **Issuer**(発行主体)が発行し、バージョンごとにコンテンツハッシュで固定される。公表したバージョンは変更しない。

## 設計原則

1. **コードブックなしで読み飛ばせる。** レコードの種類と長さは TAG WORD の16ビットにある。解釈方法(コードブック)を知らないデコーダーでも、レコードを数えて読み飛ばせる。
2. **事実ではなく記述を持つ。** ドキュメントは、誰が、いつ、何から述べた記述なのかを、Meta と根拠 Edge で併記する。
3. **識別は Reference で行う。** 名前ではなく ID で指す。名前は Edge で付ける。
4. **公表したものは変更しない。** 修正した内容は新しいバージョンとして出す。ドキュメント内の ID は、バージョンをまたいで同じ対象を指す。
5. **空けておく。** ビット空間の大部分を将来に残す。直接コードは回収できないので、頻度が確認されたものだけを割り当てる。

## 領域構造

TAG WORD の上位ビットが領域を分ける。

| Prefix | 領域 | 割合 | 定義 |
|---|---|---|---|
| `1` | 遠い将来 | 50% | 遠い将来のための予約。使わない |
| `01` | 将来 | 25% | 近い将来のための予約。使わない |
| `001` | 標準 | 12.5% | 公式に採択されて運用される文法 |
| `000` | 自由・提案 | 12.5% | 現在の文法。採択されたらレイアウトはそのままにして Prefix だけを `001` に移す |

現在の文法はすべて `000` 領域にある。この仕様のすべての TAG WORD は `000` で始まる。

- v1 デコーダーは、Prefix が `000` でない TAG WORD を拒否する。他の領域は後の版が定める。
- `000` 領域は提案の空間だ。今は登録も保護も適用されない。ただし Issuer 形式のレイアウトは、公式標準の発足後の登録体系を前提に予約する。

## コードブックなしでわかること

| 情報 | コードブックなし | 根拠 |
|---|---|---|
| Kind | わかる | TAG WORD |
| レコード全体の長さ、次のレコードの位置 | わかる | TAG WORD の Length |
| Codec 番号 | わかる | TAG WORD (Issuer 形式なら拡張 TAG の Issuer と形式番号) |
| ファミリー・クラス | わかる | Codec 番号または形式番号の上位ビット |
| Edge の Edge Id | わかる | Edge の最初の構成要素は常に LOCAL Reference |
| プレースホルダ(記さない・不明・なし) | わかる | WORD 値が `0`~`7`(Reference Codec `0000`、1 WORD)。[プレースホルダ](/ja/grammar/reference/slot-marker/) |
| Codec ごとの TAG の長さ、Payload の開始位置 | わからない | コードブック |
| Payload の解釈、Edge の構成要素の役割 | わからない | コードブック |

- コードブックのないデコーダーは、レコードを読み飛ばしながら Kind と Codec ごとに数えられるが、グラフ構造をたどることはできない。
- すべてのデコーダーは、Meta の構造・定義・IMPORT クラスを処理しなければならない。これらの Codec は GEUL コアのコードブックに属する([Meta](/ja/grammar/meta/))。

コードブックは GEUL ドキュメントとして公表される([Codec 規格ドキュメント](/ja/grammar/codec-spec/))。そのためデコーダーは、必要な規格ドキュメントを取得して読めばよい。

## 下位ドキュメント

| ドキュメント | 内容 |
|---|---|
| [レコードと TAG WORD](/ja/grammar/record/) | TAG WORD レイアウト、Length、Codec、拡張 TAG |
| [ドキュメント](/ja/grammar/document/) | DOC・HEAD・BODY・END、ドキュメント ID、コンテンツハッシュ、バージョンと改訂 |
| [Reference](/ja/grammar/reference/) | 対象の識別、LOCAL、外部参照、Quantifier、プレースホルダ |
| [Value](/ja/grammar/value/) | 値のファミリー、直接コード、テキスト・数量・日付 |
| [Edge](/ja/grammar/edge/) | 記述・根拠・実行・TOULMIN ファミリー、TRIPLE・QUALIFIER・LABEL |
| [Meta](/ja/grammar/meta/) | 構造・定義・出典・系譜・検証・ポリシー・IMPORT |
| [Issuer と公表](/ja/grammar/issuer/) | Issuer 等級、1 WORD 割り当て表、公開方式、署名、検証鍵 |
| [公表アドレスとバージョン一覧](/ja/grammar/publishing/) | ID 表記、公表アドレス、形式指定、名前索引、バージョン一覧、信頼層 |
| [Codec 規格ドキュメント](/ja/grammar/codec-spec/) | DECLARE・FIELD・ENUM・CODEC で書くコードブック |
| [例: Wikidata 項目](/ja/grammar/example/) | ドキュメント一つをワード単位で読む |

## 未解決の問題

- 境界事例の Kind。陳述についての陳述のように、Reference・Value・Edge・Meta のどれに置くか分かれる場合。
