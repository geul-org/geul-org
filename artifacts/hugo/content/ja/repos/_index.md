---
title: "リポジトリ"
date: 2026-02-28T12:00:00+09:00
lastmod: 2026-10-29T12:00:00+09:00
summary: "GEULの公開GitHubリポジトリ一覧。Goライブラリとgeul CLI、ウィキデータの取り込みと変換、探索エンジンSILK、v1以前のコードブック、ウェブサイト。"
image: "/images/og-default.webp"
---

GEULの公開リポジトリは[geul-org](https://github.com/geul-org) GitHub組織にある。文法仕様はこのサイトの[GEUL文法](/ja/grammar/)が正本である。

GEUL文書は16ビットWORDの連続である。データの単位はTAG WORD一つで始まるレコードで、レコードは一つの文書に収められる。文書はIssuerが発行し、バージョンごとに内容ハッシュで固定される。以下のリポジトリは、この文書を書き、読み、変換し、探すための道具である。

---

## ライブラリ

### gogeul

GEUL GoライブラリとCLIツール`geul`。

GEUL文書（`.geul`）を書き、読み、検査し、公表する。形式検査、Codec規格文書によるレコードの解釈、バージョン差分、IMPORT依存の解決、TOULMIN Codecをパッケージとして提供する。`geul` CLIは文書編集（`new`、`add`）、公表（`publish`）、閲覧（`ls`、`log`、`show`）、ブラウザビューア（`serve`、`build`）、packアーカイブ（`pack build`、`pack unpack`）を扱う。packアーカイブはレコードをzstdで圧縮して保存できる。

| | |
|---|---|
| GitHub | [geul-org/gogeul](https://github.com/geul-org/gogeul) |
| 言語 | Go |
| ライセンス | CC0 |

---

## ウィキデータ

### wikigeul

ウィキデータ → GEUL変換（旧名gogeulwiki）。

wikipgがPostgreSQLに取り込んだウィキデータのダンプを読み、項目・プロパティごとにGEUL文書を一つ公表する。ラベル、説明、別名、修飾子と出典付きの記述、サイトリンクをすべての言語で収める。すべての文書はIssuer `wikidata.geul.org`（`0x00010000`）の下で公表される。

| | |
|---|---|
| GitHub | [geul-org/wikigeul](https://github.com/geul-org/wikigeul) |
| 言語 | Go |
| ライセンス | CC0 |

### wikipg

ウィキデータJSONダンプ → PostgreSQLへの無損失取り込み。

エンティティ、ラベル、説明、別名、記述、修飾子、出典、サイトリンク、Lexemeをダンプの順序どおりに保存し、ダンプのすべての行を原文のまま保存する。ダンプ自体（ファイル、URL、サイズ、チェックサム、取り込みツールのコミット）も記録する。wikipgはGEULに依存しない。

| | |
|---|---|
| GitHub | [geul-org/wikipg](https://github.com/geul-org/wikipg) |
| 言語 | Go |
| ライセンス | CC0 |

---

## 探索

### silk

[SILK](/ja/projects/silk/) — GEUL専用の索引・探索エンジン。

GEUL packアーカイブのレコードからパーティション・ソート済みの索引を作り、文書をすべてデコードせずに「職業（P106）が物理学者（Q169470）だと記述した文書は？」のような問い合わせに答える。コードブックなしでTAG WORDだけからレコードとフィールドを切り分ける。初期開発段階で、探索アルゴリズムを検証しており、最初のリリースまでに形式が変わる可能性がある。

| | |
|---|---|
| GitHub | [geul-org/silk](https://github.com/geul-org/silk) |
| 言語 | Go |
| ライセンス | CC0 |

---

## コードブック（v1以前）

以下の二つのリポジトリは現行のv1文法以前に設計した資料である。現行文法と合わない部分がある。

### sidx

SIDX（Semantic-aligned Index）割り当ての研究。

意味の近いエンティティに近い番号を与える意味アドレスSIDXを、ウィキデータの利用統計から割り当てるための研究資料である。旧Entity 48ビット属性スキーマ、エンコーダスクリプト、コードブックを含み、SIDXの割り当て結果はまだない。SIDXの規範的定義は文法の[GEUL-SIDX](/ja/grammar/reference/geul-sidx/)である。

| | |
|---|---|
| GitHub | [geul-org/sidx](https://github.com/geul-org/sidx) |
| 言語 | Python |
| ライセンス | CC0 |

### wordnet-verb

WordNet 3.0に基づく動詞16ビットコードブックの暫定版。

WordNet 3.0の動詞synset 13,767個に16ビットコードを一つずつ与え、意味の近い動詞に近いコードを与える。WordNetを使わないコードブックに置き換える予定の暫定版で、コードをGEULレコードにどう収めるかは決まっていない。

WordNetから派生した資料を含むため、**CC0の成果物ではない。** WordNet派生部分はWordNet 3.0 Licenseに従い、コードや分類などGEULプロジェクト固有の部分だけがCC0である。

| | |
|---|---|
| GitHub | [geul-org/wordnet-verb](https://github.com/geul-org/wordnet-verb) |
| 言語 | Python |
| ライセンス | WordNet 3.0 License（派生部分）· CC0（固有部分） |

---

## ウェブサイト

### geul-org

このウェブサイトgeul.orgのソース。

12言語に対応したHugo静的サイトで、S3 + CloudFrontで配信する。

| | |
|---|---|
| GitHub | [geul-org/geul-org](https://github.com/geul-org/geul-org) |
| 言語 | Hugo |
| ライセンス | CC0 |

---

## 関連リポジトリ

geul-org組織の外にあるリポジトリ。

### toulmin

トゥールミン論証モデルに基づくルールエンジン（TypeScript、Python、Go、C）。

ルールは関数であり、例外はグラフ上の攻撃関係である。GEUL文法の[TOULMIN](/ja/grammar/edge/toulmin/) Edge（直接コード`0x60`〜`0x7B`）が、この判定・実行グラフをGEUL文書として書く。

| | |
|---|---|
| GitHub | [park-jun-woo/toulmin](https://github.com/park-jun-woo/toulmin) |
| ライセンス | MIT |
