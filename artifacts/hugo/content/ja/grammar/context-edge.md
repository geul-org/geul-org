---
title: "コンテキストエッジ"
weight: 60
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "context", "worldview", "modal-logic"]
summary: "「どの世界観/文脈でこの主張が真か」を表現する3ワード軽量Edge。出典、世界観、虚構、視点など64タイプで真理の条件をエンコードする。"
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Context Edge は**「どの世界観/文脈でこの Claim が真か」**を表現する。

Modal Logic の可能世界に対応する概念で、同じ Subject に対して世界観ごとに異なる事実が存在しうる。

```
Context "現実":        (地球, 年齢, 46億年)
Context "若い地球論":   (地球, 年齢, 6000年)
Context "ハリー・ポッター":  (魔法, exists, true)
```

## パケット構造（3ワード、48ビット）

```
1st WORD (16ビット):
┌─────────────────────┬─────────────────┐
│       Prefix        │  Context Type   │
│       10ビット      │     6ビット     │
└─────────────────────┴─────────────────┘
 [1100 000 100]        [TTTTTT]

2nd WORD: Context TID (16ビット)
3rd WORD: Target TID (16ビット)
```

| フィールド | ビット | 説明 |
|------|------|------|
| Prefix | 10 | `1100 000 100` |
| Context Type | 6 | 0=未指定, 1~62=タイプ, 63=拡張（予約） |
| Context TID | 16 | この Context の一意識別子 |
| Target TID | 16 | 対象 Claim（[トリプル](../triple-edge/)/[動詞](../verb-edge/)/[イベント6](../event6-edge/)/[節](../clause-edge/) TID） |

## Context Type（6ビット = 64種）

### 出典（Source）— Code 1~20

| Code | タイプ | 説明 | 例 |
|------|------|------|------|
| 1 | SYSTEM | システム自動生成 | ウィキデータ同期 |
| 2 | USER | ユーザー直接入力 | 手動作成 |
| 3 | DOCUMENT | 一般文書 | PDF, Word |
| 4 | NEWS | ニュース記事 | ロイター, AP |
| 5 | ACADEMIC | 学術論文 | arXiv, Nature |
| 6 | GOVERNMENT | 政府/公共機関 | SEC, 統計庁 |
| 7 | WIKI | ウィキペディア/ウィキデータ | Q42, P31 |
| 8 | API | 外部 API | 金融, 天気 |
| 9 | ORG | 機関/組織発表 | 企業 IR |
| 10 | BOOK | 書籍 | ISBN ベース |
| 11 | INTERVIEW | インタビュー/証言 | 直接引用 |
| 12 | DATASET | データセット | Kaggle |
| 13 | SOCIAL | ソーシャルメディア | Twitter |
| 14 | LEGAL | 法律/判例 | 裁判所判決 |
| 15 | ARCHIVE | アーカイブ | archive.org |
| 16 | MULTIMEDIA | 映像/音声 | YouTube |
| 17 | DATABASE | データベース | IMDB, Freebase |
| 18 | ENCYCLOPEDIA | 百科事典 | ブリタニカ |
| 19 | MANUAL | マニュアル/ガイド | 技術文書 |
| 20 | STANDARD | 標準文書 | ISO, RFC |

### 派生/推論（Derived）— Code 21~30

| Code | タイプ | 説明 | 例 |
|------|------|------|------|
| 21 | MODEL | AI モデル生成 | GPT, Claude |
| 22 | INFERENCE | 論理的推論 | ルールベース |
| 23 | AGGREGATION | 集計/統合 | 複数ソース統合 |
| 24 | CALCULATION | 計算結果 | 公式適用 |
| 25 | TRANSLATION | 翻訳 | 原文→翻訳 |
| 26 | EXTRACTION | 抽出 | NER, RE |
| 27 | CORRECTION | 修正/訂正 | 誤り修正 |
| 28 | HEARSAY | 伝聞/噂 | 未確認 |
| 29 | ESTIMATION | 推定 | 近似値 |
| 30 | PREDICTION | 予測 | 将来展望 |

### 世界観/信念（Worldview）— Code 31~45

| Code | タイプ | 説明 | 例 |
|------|------|------|------|
| 31 | RELIGION | 宗教的世界観 | キリスト教, 仏教 |
| 32 | PHILOSOPHY | 哲学的観点 | 実存主義 |
| 33 | SCIENCE | 科学的合意 | 現代物理学 |
| 34 | POLITICS | 政治的観点 | 保守, 革新 |
| 35 | CULTURE | 文化的観点 | 東洋, 西洋 |
| 36 | MYTHOLOGY | 神話体系 | ギリシャ神話 |
| 37 | FOLKLORE | 民話/伝承 | 地域説話 |
| 38 | IDEOLOGY | イデオロギー | 資本主義 |
| 39 | THEORY | 理論 | 相対性理論 |
| 40 | HYPOTHESIS | 仮説 | 検証前 |
| 41 | TRADITION | 伝統/慣習 | 儒教の伝統 |
| 42 | CONSENSUS | 合意/通説 | 学界の定説 |
| 43 | MAINSTREAM | 主流の見解 | 多数意見 |
| 44 | ALTERNATIVE | 代替的見解 | 少数意見 |
| 45 | FRINGE | 非主流/異端 | 疑似科学 |

### 虚構/創作（Fiction）— Code 46~55

| Code | タイプ | 説明 | 例 |
|------|------|------|------|
| 46 | NOVEL | 小説の世界観 | 指輪物語 |
| 47 | FILM | 映画の世界観 | MCU |
| 48 | GAME | ゲームの世界観 | ゼルダ |
| 49 | COMICS | 漫画の世界観 | DC ユニバース |
| 50 | ANIMATION | アニメの世界観 | ジブリ |
| 51 | DRAMA | ドラマの世界観 | ゲーム・オブ・スローンズ |
| 52 | THEATER | 演劇の世界観 | ハムレット |
| 53 | FANFIC | 二次創作 | ファンフィクション |
| 54 | LEGEND | 伝説 | アーサー王 |
| 55 | FAIRYTALE | 童話 | シンデレラ |

### 視点/話者（Perspective）— Code 56~62

| Code | タイプ | 説明 | 例 |
|------|------|------|------|
| 56 | NARRATOR | 語り手の視点 | 全知の語り手 |
| 57 | PROTAGONIST | 主人公の視点 | ヒーローの観点 |
| 58 | ANTAGONIST | 敵対者の視点 | ヴィランの観点 |
| 59 | AUTHOR | 著者の意図 | 作家の解説 |
| 60 | EXPERT | 専門家の見解 | 学者の意見 |
| 61 | LAYMAN | 一般人の認識 | 大衆の認識 |
| 62 | SATIRICAL | 風刺/アイロニー | 反語的表現 |

Code 0 は UNSPECIFIED（未指定）、Code 63 は EXTENDED（拡張、予約）。

## メタデータ拡張

Context 自体に対する付加情報（出典、信頼度、世界観名）は[トリプルエッジ](../triple-edge/)で表現する。

```
(Context TID, P:source_entity, Reuters_Entity)  - 出典機関
(Context TID, P:confidence, 0.95)               - 信頼度
(Context TID, P:universe_name, "ハリー・ポッター")  - 世界観名
(Context TID, P:perspective_holder, ヴィラン_Entity) - 視点主体
```

## 例

### 出典：「ロイター報道」

```
Context Edge:
  1st: [1100 000 100] + [000100]  - NEWS (4)
  2nd: [0x0300]                   - Context TID
  3rd: [0x0001]                   - Target: Triple "Apple acquired Tesla"

追加 Triple:
  (0x0300, P:source_entity, Reuters)
  (0x0300, P:date, 2026-01-29)
```

### 虚構：「ハリー・ポッターの世界観」

```
Context Edge:
  1st: [1100 000 100] + [101110]  - NOVEL (46)
  2nd: [0x0302]                   - Context TID
  3rd: [0x0003]                   - Target: Triple "ホグワーツ is_a 学校"

追加 Triple:
  (0x0302, P:universe_name, "ハリー・ポッター")
  (0x0302, P:author, J.K.ローリング)
```

### AI 推論：「Claudeが推論」

```
Context Edge:
  1st: [1100 000 100] + [010101]  - MODEL (21)
  2nd: [0x0304]                   - Context TID
  3rd: [0x0005]                   - Target: Triple "X causes Y"

追加 Triple:
  (0x0304, P:model, Claude_Entity)
  (0x0304, P:confidence, 0.75)
```

## 設計根拠

- **Context Edge 独立タイプ**：世界観は Triple/Clause と異なるメタレイヤーである。RDF Quad の G（Graph）に対応する。
- **6ビット Context Type**：別途 Triple なしに即座に分類可能。62タイプで大部分をカバーする。
- **3ワード軽量構造**：Context 接続は大量発生するため、最小サイズで格納効率を確保する。
