---
title: "GEUL 文法"
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "specification"]
summary: "GEUL v1 の文法仕様。16ビットワード上のレコード、四つの Kind、ドキュメント構造、Issuer と公表規則を定義する。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
showContent: true
---

GEUL(General Encoding Unified Language)は、人と AI が曖昧さなくやり取りするための人工言語であり、バイナリ形式である。

これらのドキュメントは GEUL v1 文法を定義する。現行版は公表前の草案であり、変わることがある。仕様は [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/) で公開する。

## 一目でわかる概要 {#한눈에-보기}

- すべてのデータは **16ビットワード(WORD)**の連続だ。ビッグエンディアンで書く。
- データの単位は**レコード**だ。レコードは TAG WORD 一つで始まり、その TAG WORD がレコードの種類と長さを示す。
- レコードは四種類(**Kind**)ある。

| Kind | 役割 | 例 |
|---|---|---|
| Reference | 対象を指す | Wikidata Q42、このドキュメント内の #7 |
| Value | 値そのものを持つ | 日付、数量、言語付きテキスト |
| Edge | 他のレコードを束ねて叙述する | 「Q42 は人間である」「Q42 の英語名は Douglas Adams である」 |
| Meta | ドキュメントについて述べる | 仕様版、ドキュメント ID、作成者、署名 |

- レコードは**ドキュメント**一つにまとめられる。ドキュメントは HTML のように HEAD(Meta と、ドキュメント全体の出典 SOURCE およびその QUALIFIER)と BODY(Reference・Value・Edge)に分かれる。
- ドキュメントは **Issuer**(発行主体)が出し、バージョンごとにコンテンツハッシュで固定される。公表したバージョンは変更しない。

## 設計原則 {#설계-원칙}

1. **コードブックなしで読み飛ばせる。** レコードの種類と長さは TAG WORD の16ビットにある。解釈方法(コードブック)を知らないデコーダでも、レコードを数え、読み飛ばせる。
2. **事実ではなく叙述を持つ。** ドキュメントは、誰が、いつ、何から出した叙述かを Meta と根拠 Edge で併せて記す。
3. **識別は Reference で行う。** 名前ではなく ID で指す。名前は Edge で付ける。
4. **公表したものは変更しない。** 修正内容は新しいバージョンとして出す。ドキュメント内の ID はバージョンを越えて同じ対象を指す。
5. **空けておく。** ビット空間の大部分を将来に残す。直接コードは回収できないので、頻度が確認されたものだけを割り当てる。

## 下位ドキュメント {#하위-문서}

初めて読むなら、表の上から順に読む。

| ドキュメント | 内容 |
|---|---|
| [レコードの構造](record.md) | TAG WORD レイアウト、Length、Codec、拡張 TAG |
| [Issuer と公表](issuer.md) | Issuer の等級、2 WORD 割り当て表、公開方式、署名、検証鍵 |
| [公表アドレスとバージョン一覧](publishing.md) | ID 表記、公表アドレス、形式指定、Issuer 一覧、バージョン一覧、信頼層 |
| [Codec 規格ドキュメント](codec-spec.md) | DECLARE・FIELD・ENUM・CODEC で書くコードブック |
| [一般ドキュメント](document.md) | DOC・HEAD・BODY・END、ドキュメント ID、コンテンツハッシュ、バージョンと改訂 |
| [コード索引](codec-index.md) | 割り当て227マス全体、Kind・系列別 Codec 表 |
| [セクション配置](layout.md) | 16個のセクションとマス配置、割り当て・Reserved 区間 |
| [プレースホルダ](slot-marker.md) | ABSENT・UNKNOWN-VALUE・NO-VALUE、受け入れ規則 |
| [Reference](reference/_index.md) | 対象識別、LOCAL、外部参照、Quantifier、プレースホルダ |
| [Value](value/_index.md) | 値の系列、直接コード、テキスト・数量・日付 |
| [Meta](meta/_index.md) | 構造・定義・出典・系譜・検証・ポリシー・IMPORT |
| [Edge](edge/_index.md) | 叙述・根拠・実行・TOULMIN 系列、TRIPLE・QUALIFIER・LABEL |
| [TOULMIN](toulmin/_index.md) | 判定・実行グラフ系列、NODE・LINK・SOURCE レイアウト |
| [例: Wikidata 項目](example.md) | ドキュメント一つをワード単位で読む |

## コードブックなしでわかること {#코덱북-없이-알-수-있는-것}

| 情報 | コードブックなしで | 根拠 |
|---|---|---|
| Kind | わかる | TAG WORD のセクション `w >> 9` の区間(Reference 0~2、Value 3・4、Edge 5~13、Meta 14・15) |
| レコード全体の長さ、次のレコードの位置 | わかる | TAG WORD の Length |
| Codec 番号 | わかる | TAG WORD(Issuer 形式なら拡張 TAG の Issuer と Codec 番号) |
| 系列・クラス | 一部わかる | Edge 直接コードの系列だけがビットでわかる。Value 直接コードと Issuer 形式の系列、Meta クラスはビットではわからない。Issuer 形式は Issuer と Codec 番号までわかる。Meta 検証クラスはセクション15の `C >= 5`(`w >= 0x1E50`)でわかる |
| Edge の Edge Id | わかる | Edge(セクション5~13)の最初の構成要素は常に LOCAL Reference |
| プレースホルダ(記載なし・不明・なし) | わかる | WORD 値が `0x0000`、`0x0010`、`0x0020`(Reference、C < 3、L 0)。[プレースホルダ](slot-marker.md) |
| Quantifier | わかる | セクション内オフセット `C` で、セクション0の `5 <= C < 30`、セクション1の `C < 30` なら `C % 5` |
| Codec ごとの TAG 長、Payload 開始位置 | わからない | コードブック |
| Payload の解釈、Edge 構成要素の役割 | わからない | コードブック |

- コードブックのないデコーダは、レコードを読み飛ばしながら Kind と Codec ごとに数えられるが、グラフ構造をたどることはできない。
- すべてのデコーダは Meta の構造・定義・IMPORT クラスを処理しなければならない。これらの Codec は GEUL コアコードブックに属し、デコーダは内蔵の番号表で知る([Meta](meta/_index.md))。

コードブックは GEUL ドキュメントとして公表される([Codec 規格ドキュメント](codec-spec.md))。したがってデコーダは、必要な規格ドキュメントを受け取って読めばよい。

## 領域構造 {#영역-구조}

TAG WORD の上位ビットは領域を分ける。

| Prefix | 領域 | 割合 | 定義 |
|---|---|---|---|
| `1` | 遠い将来 | 50% | Reserved(遠い将来)。使わない |
| `01` | 将来 | 25% | Reserved(近い将来)。使わない |
| `001` | 標準 | 12.5% | 公式に採択されて運用される文法 |
| `000` | 自由・提案 | 12.5% | 現行文法。採択されるとレイアウトはそのままに Prefix だけを `001` に移す |

現行文法はすべて `000` 領域にある。この仕様のすべての TAG WORD は `000` で始まる。

- v1 デコーダは Prefix が `000` でない TAG WORD を拒否する。他の領域は後の版が定める。
- `000` 領域は提案空間だ。現在は登録も保護も適用されない。
