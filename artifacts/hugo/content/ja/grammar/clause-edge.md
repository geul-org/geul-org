---
title: "節エッジ"
weight: 40
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "clause", "RST", "discourse"]
summary: "述語、イベント、関係間の論理的・談話的関係を表現する4ワード固定Edge。RSTベースの16種の関係タイプで因果、時間、対比、論証関係をエンコードする。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Clause Edge は述語（[動詞エッジ](../verb-edge/)）、イベント（[イベント6エッジ](../event6-edge/)）、関係（[トリプルエッジ](../triple-edge/)）、または他の Clause 間の**論理的/談話的関係**を表現する Edge タイプである。

RST（Rhetorical Structure Theory）の談話関係に基づいて設計された。

## パケット構造（4ワード、64ビット）

```
1st WORD (16ビット):
┌─────────────────────┬────────────┬────────┐
│      Prefix         │  関係タイプ │  予約   │
│       10ビット       │   4ビット  │  2ビット│
└─────────────────────┴────────────┴────────┘
 [1100 000 010]        [RRRR]       [xx]

2nd WORD: Edge TID (16ビット)
3rd WORD: TID 1 (16ビット) - 第一の節
4th WORD: TID 2 (16ビット) - 第二の節
```

| フィールド | ビット | 説明 |
|------|------|------|
| Prefix | 10 | `1100 000 010` |
| 関係タイプ | 4 | 16種の RST 関係 |
| 予約 | 2 | 将来拡張用 |
| Edge TID | 16 | この Edge の一意識別子 |
| TID 1 | 16 | 第一の節の参照 |
| TID 2 | 16 | 第二の節の参照 |

## 関係タイプ（4ビット = 16種）

### 因果関係

| コード | タイプ | 説明 | 例 |
|------|------|------|------|
| 0000 | CAUSE | 原因→結果 | 「雨が降ったので家にいた」 |
| 0001 | RESULT | 結果←原因 | 「家にいた、雨が降ったから」 |
| 0010 | CONDITION | 条件→帰結 | 「雨が降れば行かない」 |
| 0011 | PURPOSE | 目的 | 「生きるために食べる」 |

### 時間/順序関係

| コード | タイプ | 説明 | 例 |
|------|------|------|------|
| 0100 | SEQUENCE | 時間順 | 「ご飯を食べて寝た」 |
| 0101 | PARALLEL | 同時/並行 | 「笑いながら話した」 |

### 対比/譲歩関係

| コード | タイプ | 説明 | 例 |
|------|------|------|------|
| 0110 | CONTRAST | 対比 | 「Aは大きくBは小さい」 |
| 0111 | CONCESSION | 譲歩 | 「難しいけどやった」 |

### 補足/背景関係

| コード | タイプ | 説明 | 例 |
|------|------|------|------|
| 1000 | ELABORATION | 詳述 | 「具体的に言えば」 |
| 1001 | BACKGROUND | 背景情報 | 「ちなみに、当時の状況は」 |

### 論証関係

| コード | タイプ | 説明 | 例 |
|------|------|------|------|
| 1010 | EVIDENCE | 証拠提示 | 「なぜなら...だから」 |
| 1011 | EVALUATION | 評価 | 「これは良い/悪い」 |

### その他の関係

| コード | タイプ | 説明 | 例 |
|------|------|------|------|
| 1100 | SOLUTIONHOOD | 問題→解決 | 「問題はX、解決策はY」 |
| 1101 | ALTERNATIVE | 選択/代替 | 「行くか行かないか」 |
| 1110 | MEANS | 手段 | 「こうして達成した」 |
| 1111 | RESERVED | 予約 | 将来拡張用 |

## TID 順序規則

方向は TID 順序で決定される。

| 関係 | TID 1 | TID 2 |
|------|-------|-------|
| CAUSE | 原因 | 結果 |
| RESULT | 結果 | 原因 |
| CONDITION | 条件 | 帰結 |
| PURPOSE | 行為 | 目的 |
| SEQUENCE | 先行 | 後行 |
| EVIDENCE | 証拠 | 主張 |
| ELABORATION | 核心 | 補足 |

## Multinuclear vs Nucleus-Satellite

RST の区分に従う。

### Nucleus-Satellite（非対称）

| 関係 | TID 1 | TID 2 |
|------|-------|-------|
| CAUSE | 原因 (Satellite) | 結果 (Nucleus) |
| CONDITION | 条件 (Satellite) | 帰結 (Nucleus) |
| EVIDENCE | 証拠 (Satellite) | 主張 (Nucleus) |
| ELABORATION | 核心 (Nucleus) | 補足 (Satellite) |

### Multinuclear（対称）

| 関係 | TID 1 | TID 2 |
|------|-------|-------|
| SEQUENCE | 先行 | 後行 |
| PARALLEL | 第一 | 第二 |
| CONTRAST | 第一 | 第二 |
| ALTERNATIVE | 第一 | 第二 |

対称関係で TID 順序は意味的優先順位を示さない。

## 例

### 単純因果：「雨が降ったので家にいた」

```
Verb Edge E01: rain(雨) | TID=0x0001
Verb Edge E02: stay(私, 家) | TID=0x0002

Clause Edge:
  1st: [1100 000 010] [0000] [00]  - Prefix + CAUSE + 予約
  2nd: [0x0100]                    - Edge TID
  3rd: [0x0001]                    - TID 1 (原因: E01)
  4th: [0x0002]                    - TID 2 (結果: E02)
```

### ネスト Clause：「雨が降って家にいたので、勉強した」

```
Verb Edge E01: rain(雨) | TID=0x0001
Verb Edge E02: stay(私, 家) | TID=0x0002
Verb Edge E03: study(私) | TID=0x0003

Clause Edge C01:
  1st: [1100 000 010] [0000] [00]  - Prefix + CAUSE
  2nd: [0x0100]                    - Edge TID
  3rd: [0x0001]                    - E01
  4th: [0x0002]                    - E02

Clause Edge C02:
  1st: [1100 000 010] [0001] [00]  - Prefix + RESULT
  2nd: [0x0101]                    - Edge TID
  3rd: [0x0100]                    - C01 (Clause TID 参照!)
  4th: [0x0003]                    - E03
```

## 設計根拠

### RST ベースの理由

- 30年以上の研究蓄積
- 多様なコーパスで検証
- 談話パーシングツールの存在
- 言語非依存

### 4ビット（16種）の理由

- RST 核心関係12種以上をカバー
- 拡張の余裕を確保
- 3ビット（8種）では不足

### 4ワード簡素化の理由

- 方向：TID 順序で決定（別途ビット不要）
- 確信度：別途メタデータで処理
- 2ビット予約：今後の拡張用
