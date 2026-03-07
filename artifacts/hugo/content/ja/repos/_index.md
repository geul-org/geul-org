---
title: "リポジトリ"
date: 2026-02-28T12:00:00+09:00
summary: "GEULプロジェクトを構成するGitHubリポジトリ一覧。言語仕様、文法コードブック、検索、DSL、ウェブサイト。"
image: "/images/og-default.webp"
---

すべてのリポジトリは[geul-org](https://github.com/geul-org) GitHub組織にある。

---

## 言語

### geul

AIのための意味整列型人工言語およびバイナリストリームフォーマット。

人間とAIの間の曖昧さのないコミュニケーションのために設計された2バイト（65,536種）ベースの言語体系。すべての記述にソース、タイムスタンプ、確信度が付与される。すべてのエンティティに一意の識別子がある。ストリームフォーマットは16ビット単位で動作し、10ビットプレフィックス体系の下で10種のパケットタイプ（Verb Edge、Entity Node、Triple Edgeなど）を定義する。

| | |
|---|---|
| GitHub | [geul-org/geul](https://github.com/geul-org/geul) |
| 言語 | Go, Python |
| ライセンス | MIT |

---

## 文法

### geul-verb

動詞SIDX 16ビットコードブック（WordNetベース）。

WordNetの動詞シンセットを16ビットコードにマッピングし、GEUL Verb Edgeパケットで使用する。ストリームフォーマットが消費する動詞語彙を提供する。

| | |
|---|---|
| GitHub | [geul-org/geul-verb](https://github.com/geul-org/geul-verb) |
| 言語 | Python |
| ライセンス | MIT |

### geul-entity

エンティティSIDX 48ビットコードブック（Wikidataベース）。

Wikidataエンティティを48ビット構造化識別子にエンコードする。エンティティタイプを定義し、タイプごとの属性スキーマを設計し、SILKが消費するコードブックを構築する。

| | |
|---|---|
| GitHub | [geul-org/geul-entity](https://github.com/geul-org/geul-entity) |
| 言語 | Python |
| ライセンス | MIT |

### geul-quantities

数量ノードコードブック。

GEUL Quantity Nodeパケットで使用される数量値——単位付き数値、範囲、精度——のエンコーディングスキーマを定義する。

| | |
|---|---|
| GitHub | [geul-org/geul-quantities](https://github.com/geul-org/geul-quantities) |
| 言語 | Python |
| ライセンス | MIT |

### geul-ast

ASTエッジコードブック。

抽象構文木エッジのエンコーディングスキーマを定義し、GEULストリームフォーマット内での構造化コード表現を可能にする。

| | |
|---|---|
| GitHub | [geul-org/geul-ast](https://github.com/geul-org/geul-ast) |
| 言語 | Python |
| ライセンス | MIT |

---

## 検索

### silk

SILK（Symbolic Index for LLM Knowledge）——ニューロシンボリック検索アーキテクチャ。

64ビット整数で検索する。ベクトルDB、ANNグラフ、エンベディングモデルは不要。NumPyのビットAND一行で1億件を検索し、Pythonだけで最適化されたC++/Rustベクトル検索を上回るというのが核心的主張である。コードブックルックアップとLLM補助を組み合わせたハイブリッドクエリパイプラインを提供する。

| | |
|---|---|
| GitHub | [geul-org/silk](https://github.com/geul-org/silk) |
| 言語 | Python |
| ライセンス | MIT |

---

## DSL

### ssac

Service Sequences as Code——Goコメントから宣言的サービスロジックをパースし、CLI経由でGo実装コードを生成する。

Goソースファイル内の構造化コメントとしてサービスフローを定義する。CLIがこれらの宣言を読み取り、対応する実装コードを生成し、ロジックの可読性とバージョン管理を維持しながらボイラープレートを排除する。

| | |
|---|---|
| GitHub | [geul-org/ssac](https://github.com/geul-org/ssac) |
| 言語 | Go |
| ライセンス | MIT |

---

## ウェブサイト

### geul-org

このウェブサイトのソースコード。

12言語をサポートするHugo静的サイトジェネレーター。S3 + CloudFrontでデプロイし、CloudFront Functionで言語検出とクリーンURLを処理する。

| | |
|---|---|
| GitHub | [geul-org/geul-org](https://github.com/geul-org/geul-org) |
| 言語 | Hugo (Go Templates), CSS |
| ライセンス | MIT |
