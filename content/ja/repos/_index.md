---
title: "リポジトリ"
date: 2026-02-28T12:00:00+09:00
summary: "GEULプロジェクトを構成するGitHubリポジトリ一覧。言語設計、エンコーディングパイプライン、検索エンジン、ウェブサイト。"
image: "/images/og-default.webp"
---

GEULプロジェクトは4つのリポジトリで構成されている。

言語を設計し（geul）、世界のエンティティを64ビットにエンコードし（geul-sidx）、そのインデックス上で検索し（silk）、なぜこのすべてが必要なのかを説明する（geul-org）。

---

## geul

AI のための意味整列型人工言語およびバイナリストリームフォーマット。

人間とAIの間の曖昧さのないコミュニケーションのために設計された2バイト（65,536種）ベースの言語体系。すべての記述にソース、タイムスタンプ、確信度が付与される。すべてのエンティティに一意の識別子がある。ストリームフォーマットは16ビット単位で動作し、10ビットプレフィックス体系の下で10種のパケットタイプ（Verb Edge、Entity Node、Triple Edgeなど）を定義する。

| | |
|---|---|
| GitHub | [park-jun-woo/geul](https://github.com/park-jun-woo/geul) |
| 言語 | Go, Python |
| ライセンス | MIT |

---

## geul-sidx

SIDX（Semantic-aligned Index）コードブックビルダー＆エンコーディングパイプライン。

1億880万のWikidataエンティティを64ビット構造化識別子にエンコードする。63のエンティティタイプを定義し、タイプごとに48ビットの属性スキーマを設計し、コードブックを構築し、エンコーディング結果を検証（VALID）する。SILKが消費するインデックスとコードブックの生産者。

| | |
|---|---|
| GitHub | [park-jun-woo/geul-sidx](https://github.com/park-jun-woo/geul-sidx) |
| 言語 | Python |
| ライセンス | MIT |

---

## silk

SILK（Symbolic Index for LLM Knowledge）——ニューロシンボリック検索アーキテクチャ。

64ビット整数で検索する。ベクトルDB、ANNグラフ、エンベディングモデルは不要。NumPyのビットAND一行で1億件を検索し、Pythonだけで最適化されたC++/Rustベクトル検索を上回るというのが核心的主張である。コードブックルックアップとLLM補助を組み合わせたハイブリッドクエリパイプラインを提供する。

| | |
|---|---|
| GitHub | [park-jun-woo/silk](https://github.com/park-jun-woo/silk) |
| 言語 | Python |
| ライセンス | MIT |

---

## geul-org

このウェブサイトのソースコード。

12言語をサポートするHugo静的サイトジェネレーター。S3 + CloudFrontでデプロイし、CloudFront Functionで言語検出とクリーンURLを処理する。

| | |
|---|---|
| GitHub | [park-jun-woo/geul-org](https://github.com/park-jun-woo/geul-org) |
| 言語 | Hugo (Go Templates), CSS |
| ライセンス | MIT |
