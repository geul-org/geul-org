---
title: "参加者役割"
weight: 10
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "participant", "semantic-role"]
summary: "イベント内部の意味的役割を定義する16個のParticipant。4ビットエンコードでAgent、Theme、Recipientなどの核心役割からCause、Purposeなどの付加役割まで表現する。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**参加者（Participant）**は述語内でイベントに関与する個体の**意味的役割**を明示する Edge である。

```
Event Node (動詞)
    ├─ PARTICIPANT Edge (role=Agent) ──→ Entity Node
    ├─ PARTICIPANT Edge (role=Theme) ──→ Entity Node
    └─ PARTICIPANT Edge (role=Instrument) ──→ Entity Node
```

## 設計原則

### 分離原則

| 区分 | 所属 | 例 |
|------|------|------|
| **参加者** | Event レベル | Agent, Theme, Recipient |
| **語用情報** | Context/Claim レベル | Speaker, Listener, Evidentiality |

Speaker（話者）、Listener（聴者）、Source（情報源）は参加者ではなく **[意味限定子](../qualifier/)** または Context/Claim で処理する。

### エンコード

- **4ビット**（0x0~0xF）、最大16種の意味役割
- SIMD ビット演算でパターンマッチング可能

## 意味役割リスト（16種）

### 核心参加者（Core Participants）

| ID | コード | 役割 | 定義 | 例 |
|----|------|------|------|------|
| 0x0 | **AGT** | Agent（動作主） | 意図的に行動を遂行する主体 | 「**太郎が**ボールを蹴った」 |
| 0x1 | **EXP** | Experiencer（経験者） | 感情/認知/知覚を経験する主体 | 「**花子が**悲しかった」 |
| 0x2 | **THM** | Theme（対象） | 移動または状態が記述される対象 | 「太郎が**ボールを**蹴った」 |
| 0x3 | **PAT** | Patient（被影響者） | 行動により状態が変わる対象 | 「**窓ガラスが**割れた」 |
| 0x4 | **RCP** | Recipient（受領者） | 何かを受け取る対象 | 「**花子に**本を渡した」 |
| 0x5 | **BNF** | Beneficiary（受益者） | 行動の利益を得る対象 | 「**子供のために**作った」 |

### 道具/手段（Instruments & Means）

| ID | コード | 役割 | 定義 | 例 |
|----|------|------|------|------|
| 0x6 | **INS** | Instrument（道具） | 行動遂行に使用される道具 | 「**ハンマーで**釘を打った」 |
| 0x7 | **MNR** | Manner（様態） | 行動が遂行される方式 | 「**速く**走った」 |

### 空間/移動（Spatial）

| ID | コード | 役割 | 定義 | 例 |
|----|------|------|------|------|
| 0x8 | **LOC** | Location（場所） | イベントが発生する位置 | 「**東京で**暮らした」 |
| 0x9 | **SRC** | Source（出発点） | 移動の起点 | 「**家から**出発した」 |
| 0xA | **DST** | Destination（目的地） | 移動の到着点 | 「**学校へ**行った」 |
| 0xB | **PTH** | Path（経路） | 移動の経由地 | 「**公園を通って**行った」 |

### 原因/目的（Causal）

| ID | コード | 役割 | 定義 | 例 |
|----|------|------|------|------|
| 0xC | **CAU** | Cause（原因） | イベントの原因 | 「**雨のせいで**中止になった」 |
| 0xD | **PRP** | Purpose（目的） | 行動の目的 | 「**運動しに**行った」 |

### その他（Others）

| ID | コード | 役割 | 定義 | 例 |
|----|------|------|------|------|
| 0xE | **COM** | Comitative（同伴） | 一緒に参加する対象 | 「**友達と**行った」 |
| 0xF | **ATR** | Attribute（属性） | 状態/属性の叙述 | 「空が**青い**」 |

## Participant Edge 構造

```
PARTICIPANT Edge {
    source:     Event SIDX       // 動詞ノード
    target:     Entity SIDX      // 個体ノード
    role:       4-bit            // 意味役割 (0x0~0xF)
    gram_role:  2-bit (optional) // 文法的役割 (主語/目的語/補語)
    focus:      4-bit (optional) // 強調度 (0~15 → 0.0~1.0)
    quant_ref:  TID (optional)   // 限定子参照
}
```

| フィールド | ビット | 説明 |
|------|------|------|
| role | 4 | 意味役割（必須） |
| gram_role | 2 | 0=未指定, 1=主語, 2=目的語, 3=補語 |
| focus | 4 | 情報的重要度（0=背景, 15=核心強調） |
| quant_ref | 16 | 「すべて」「大部分」などの限定子 TID |

## Theme vs Patient

| 役割 | 状態変化 | 例 |
|------|----------|------|
| Theme | なし（移動/記述） | 「ボールを**投げた**」（ボールはそのまま） |
| Patient | あり（影響を受ける） | 「ガラスを**割った**」（ガラスの状態変化） |

実用的には Theme に統合し、必要に応じて動詞の意味で区分できる。

## 例

### 単純文：「太郎が花子に本を渡した」

```
Event: give.v.01
├─ PARTICIPANT (AGT) → 太郎
├─ PARTICIPANT (THM) → 本
└─ PARTICIPANT (RCP) → 花子
```

### 複合文：「雨のせいで友達と一緒に家から学校まで速く走った」

```
Event: run.v.01
├─ PARTICIPANT (AGT) → [話者]
├─ PARTICIPANT (CAU) → 雨
├─ PARTICIPANT (COM) → 友達
├─ PARTICIPANT (SRC) → 家
├─ PARTICIPANT (DST) → 学校
└─ PARTICIPANT (MNR) → 速く
```

### 状態叙述：「空がとても青い」

```
Event: be.v.01
├─ PARTICIPANT (THM) → 空
└─ PARTICIPANT (ATR) → 青い (focus=15)
```

## 能動/受動の正規化

| 表面形 | Agent | Theme |
|--------|-------|-------|
| 「AppleがTeslaを買収した」 | Apple | Tesla |
| 「TeslaがAppleに買収された」 | Apple | Tesla |

パース段階で正規化し、同一パターンで処理する。
