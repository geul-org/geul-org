---
title: "エンティティノード"
weight: 20
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "entity", "SIDX", "quantification"]
summary: "人物・場所・事物・組織などの個体を識別する固定長4ワード（64ビット）Node。3ビットModeで量化/数を表現し、6ビットEntityTypeで64種の上位タイプを分類し、48ビットAttributesでタイプ別意味属性をエンコードする。"
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Entity Node** は GEUL ストリームで個体（人物、場所、事物、組織、概念など）を識別する**固定長4ワード（64ビット）パケット**である。

## SIDX の本質

| 特性 | 説明 |
|------|------|
| **Non-unique** | 同じ SIDX に複数の個体が対応可能 |
| **Multi-SIDX** | 一つの個体が複数の SIDX を持てる（時点/役割別） |
| **ビット = 意味** | ビット位置そのものが属性を表す |
| **抽象/具体の連続** | Mode と Attributes の充填度で区分 |

**例：**
- トランプ（不動産事業家）→ SIDX_A
- トランプ（大統領）→ SIDX_B（異なる SIDX）
- "Human + Male + Korea" → 抽象的な「韓国人男性」
- "Human + Male + Korea + 1946 + Business + ..." → ほぼ特定の人物

## 設計原則

**Q識別子の内蔵を放棄：**
- 全ビットを純粋な意味整列に投資
- WMS SIMD フィルタリング性能の最大化
- Q識別子は[トリプル](../triple-edge/)で別途接続：`(Entity_SIDX, P-外部ID, "Q12345")`

**Serial ビット不要：**
- WMS クエリは2段階：SIMD で範囲を絞る → 範囲内でディテール確認
- Serial は意味のない数字なので SIMD に貢献しない
- そのビットを意味整列に投資すれば第1段階でさらに絞れる

## ビットレイアウト（4ワード = 64ビット）

```
1st WORD (16ビット)
┌─────────┬──────┬────────────┐
│ Prefix  │ Mode │ EntityType │
│  7bit   │ 3bit │   6bit     │
└─────────┴──────┴────────────┘

2nd WORD (16ビット)
┌─────────────────────────────┐
│     Attributes 上位16ビット   │
└─────────────────────────────┘

3rd WORD (16ビット)
┌─────────────────────────────┐
│     Attributes 中位16ビット   │
└─────────────────────────────┘

4th WORD (16ビット)
┌─────────────────────────────┐
│     Attributes 下位16ビット   │
└─────────────────────────────┘
```

| フィールド | ビット | サイズ | 説明 |
|------|------|------|------|
| Prefix | 1-7 | 7 | `0001001` (Entity Node) |
| Mode | 8-10 | 3 | 8種の量化/数モード |
| EntityType | 11-16 | 6 | 64種の上位タイプ |
| Attributes | 17-64 | **48** | タイプ別可変スキーマ |

## Mode（3ビット）

Mode は個体の**量化（Quantification）と数（Number）**を3ビットで統合表現する。

| コード | 二進 | 意味 | 例 |
|------|------|------|------|
| 0 | 000 | **登録個体** | 織田信長、トヨタ、BTS |
| 1 | 001 | 特定単数 | 「あの人」 |
| 2 | 010 | 特定少数 | 「その数人」 |
| 3 | 011 | 特定多数 | 「あの人たち」 |
| 4 | 100 | 全称 | 「すべての~」 |
| 5 | 101 | 存在 | 「ある~」 |
| 6 | 110 | 不特定 | 「誰でも~」 |
| 7 | 111 | 総称 | 「~一般」 |

### 登録個体（Mode=0）

- ウィキデータ Q識別子、WordNet Synset など外部 ID とマッピングされた個体
- Q識別子自体はトリプルで接続：`(Entity_SIDX, P-外部ID, "Q12345")`
- **数（Number）概念とは無関係**：トヨタは「一つ」だが単数と言うには微妙、BTS はグループだが一つの個体

### 代名詞/抽象（Mode=1~7）

- EntityType + Attributes で意味範囲を指定
- ビットが埋まるほど具体的
- 例：Human(Type) + Male(Attr) + Japan(Attr) = 「日本人男性」

## EntityType（6ビット = 64種）

ウィキデータ P31（instance of）頻度統計に基づき64種の上位タイプを配定する。詳細分類は Attributes 内のサブカテゴリビットで処理する。

| 範囲 | カテゴリ | タイプ数 | 代表タイプ |
|------|----------|---------|-----------|
| 0x00-0x07 | 生物/人物 | 8 | Human, Taxon, Gene, Protein |
| 0x08-0x0B | 化学/物質 | 4 | Chemical, Compound, Mineral, Drug |
| 0x0C-0x13 | 天体 | 8 | Star, Galaxy, Asteroid, Planet |
| 0x14-0x1B | 地形/自然 | 8 | Mountain, River, Lake, Island |
| 0x1C-0x23 | 場所/行政 | 8 | Settlement, Village, Street, Park |
| 0x24-0x2B | 建築物 | 8 | Building, Church, School, Bridge |
| 0x2C-0x2F | 組織 | 4 | Organization, Business, PoliticalParty |
| 0x30-0x3B | 創作物 | 12 | Painting, Document, Film, Album |
| 0x3C-0x3F | イベント/その他 | 4 | SportsSeason, Event, Election, Other |

### コードテーブル（全64種）

| コード | タイプ | Q-ID | 個体数 |
|------|------|------|--------|
| 0x00 | Human | Q5 | 12.5M |
| 0x01 | Taxon | Q16521 | 3.8M |
| 0x02 | Gene | Q7187 | 1.2M |
| 0x03 | Protein | Q8054 | 1.0M |
| 0x04 | CellLine | Q21014462 | 154K |
| 0x05 | FamilyName | Q101352 | 662K |
| 0x06 | GivenName | Q202444 | 128K |
| 0x07 | FictionalCharacter | Q15632617 | 98K |
| 0x08 | Chemical | Q113145171 | 1.3M |
| 0x09 | Compound | Q11173 | 1.1M |
| 0x0A | Mineral | Q7946 | 62K |
| 0x0B | Drug | Q12140 | 45K |
| 0x0C | Star | Q523 | 3.6M |
| 0x0D | Galaxy | Q318 | 2.1M |
| 0x0E | Asteroid | Q3863 | 249K |
| 0x0F | Quasar | Q83373 | 178K |
| 0x10 | Planet | Q634 | 15K |
| 0x11 | Nebula | Q12057 | 8K |
| 0x12 | StarCluster | Q168845 | 5K |
| 0x13 | Moon | Q2537 | 3K |
| 0x14 | Mountain | Q8502 | 518K |
| 0x15 | Hill | Q54050 | 321K |
| 0x16 | River | Q4022 | 427K |
| 0x17 | Lake | Q23397 | 292K |
| 0x18 | Stream | Q47521 | 194K |
| 0x19 | Island | Q23442 | 153K |
| 0x1A | Bay | Q39594 | 25K |
| 0x1B | Cave | Q35509 | 20K |
| 0x1C | Settlement | Q486972 | 580K |
| 0x1D | Village | Q532 | 245K |
| 0x1E | Hamlet | Q5084 | 148K |
| 0x1F | Street | Q79007 | 711K |
| 0x20 | Cemetery | Q39614 | 298K |
| 0x21 | AdminRegion | Q15284 | 100K |
| 0x22 | Park | Q22698 | 45K |
| 0x23 | ProtectedArea | Q473972 | 35K |
| 0x24 | Building | Q41176 | 292K |
| 0x25 | Church | Q16970 | 286K |
| 0x26 | School | Q9842 | 242K |
| 0x27 | House | Q3947 | 235K |
| 0x28 | Structure | Q811979 | 216K |
| 0x29 | SportsVenue | Q1076486 | 145K |
| 0x2A | Castle | Q23413 | 42K |
| 0x2B | Bridge | Q12280 | 38K |
| 0x2C | Organization | Q43229 | 531K |
| 0x2D | Business | Q4830453 | 242K |
| 0x2E | PoliticalParty | Q7278 | 35K |
| 0x2F | SportsTeam | Q847017 | 95K |
| 0x30 | Painting | Q3305213 | 1.1M |
| 0x31 | Document | Q49848 | 45M |
| 0x32 | LiteraryWork | Q7725634 | 395K |
| 0x33 | Film | Q11424 | 335K |
| 0x34 | Album | Q482994 | 303K |
| 0x35 | MusicalWork | Q105543609 | 195K |
| 0x36 | TVEpisode | Q21191270 | 177K |
| 0x37 | VideoGame | Q7889 | 172K |
| 0x38 | TVSeries | Q5398426 | 85K |
| 0x39 | Patent | Q43305660 | 289K |
| 0x3A | Software | Q7397 | 13K |
| 0x3B | Website | Q35127 | 12K |
| 0x3C | SportsSeason | Q27020041 | 183K |
| 0x3D | Event | Q1656682 | 10K |
| 0x3E | Election | Q40231 | 11K |
| 0x3F | Other | - | 拡張用 |

## Attributes（48ビット）

EntityType ごとに異なる意味で解釈される**タイプ別可変スキーマ**である。高頻度属性により多くのビットを割り当て、WMS SIMD フィルタリングに直接活用する。

### Human (0x00) Attributes

```
┌──────────┬────────┬────────┬──────┬────────┬────────┬─────────┬──────────┬────────────┬──────────┐
│ サブ分類 │ 職業   │ 国籍   │ 時代 │ 10年代 │ 性別   │ 著名度  │ 言語     │ 出生地域   │ 活動分野 │
│  5bit    │  6bit  │  8bit  │ 4bit │  4bit  │  2bit  │  3bit   │  6bit    │   6bit     │   4bit   │
└──────────┴────────┴────────┴──────┴────────┴────────┴─────────┴──────────┴────────────┴──────────┘
offset:  0        5       11      19     23      27      29        32         38          44
```

### Star (0x0C) Attributes

```
┌────────────┬────────────┬──────────┬──────────┬────────┬────────┬──────────┬──────────┬────────┬────────┐
│ 星座       │ スペクトル │ 光度階級 │ 見かけ   │ 赤経   │ 赤緯   │ フラグ   │ 視線速度 │ 赤方偏移│ 視差   │
│   7bit     │    4bit    │   3bit   │  4bit    │  4bit  │  4bit  │   6bit   │   5bit   │  5bit  │  4bit  │
└────────────┴────────────┴──────────┴──────────┴────────┴────────┴──────────┴──────────┴────────┴────────┘
```

**フラグビット定義：**
- bit0: IR（赤外線源）
- bit1: Radio（電波源）
- bit2: X-ray（X線源）
- bit3: Binary（連星）
- bit4: Variable（変光星）
- bit5: HighPM（固有運動）

## 演算

### Entity 生成

```python
def make_entity(
    mode: int,           # 3ビット
    entity_type: int,    # 6ビット
    attrs: int           # 48ビット
) -> bytes:
    PREFIX = 0b0001001   # 7ビット (Entity Node)

    word1 = (PREFIX << 9) | (mode << 6) | entity_type
    word2 = (attrs >> 32) & 0xFFFF
    word3 = (attrs >> 16) & 0xFFFF
    word4 = attrs & 0xFFFF

    return (
        word1.to_bytes(2, 'big') +
        word2.to_bytes(2, 'big') +
        word3.to_bytes(2, 'big') +
        word4.to_bytes(2, 'big')
    )
```

### Entity パース

```python
def parse_entity(data: bytes) -> dict:
    word1 = int.from_bytes(data[0:2], 'big')
    word2 = int.from_bytes(data[2:4], 'big')
    word3 = int.from_bytes(data[4:6], 'big')
    word4 = int.from_bytes(data[6:8], 'big')

    prefix = (word1 >> 9) & 0x7F
    mode = (word1 >> 6) & 0x7
    entity_type = word1 & 0x3F
    attrs = (word2 << 32) | (word3 << 16) | word4

    return {
        'prefix': prefix,
        'mode': mode,
        'entity_type': entity_type,
        'attrs': attrs
    }
```

## 例

### 登録個体：織田信長

```python
# 織田信長 (Q178713)
oda_nobunaga = make_entity(
    mode=0,              # 登録個体
    entity_type=0x00,    # Human
    attrs=(
        (0x06 << 43) |   # サブ分類: Military
        (0x01 << 37) |   # 職業: Warlord
        (0x52 << 29) |   # 国籍: Japan
        (0x5 << 25) |    # 時代: Early Modern
        (0x0 << 21) |    # 10年代: 1530s
        (0x01 << 19) |   # 性別: Male
        (0x7 << 16)      # 著名度: 1000+
    )
)
# Q識別子接続: Triple(oda_nobunaga_SIDX, P-外部ID, "Q178713")
```

### 抽象：「すべての日本人男性」

```python
all_japanese_men = make_entity(
    mode=4,              # 全称（すべて）
    entity_type=0x00,    # Human
    attrs=(
        (0x52 << 29) |   # 国籍: Japan
        (0x01 << 19)     # 性別: Male
    )
)
```

## 下位タイプマッピング

ウィキデータの多くのタイプが64種 EntityType の下位タイプである。エンコーダは P31 値を見て適切な上位タイプにルーティングする。

| 下位タイプ (P31) | 上位タイプ | 個体数 |
|-----------------|-----------|--------|
| Q13442814 (scholarly article) | Document (0x31) | 45.2M |
| Q67206691 (infrared source) | Star (0x0C) | 2.6M |
| Q13100073 (village of China) | Village (0x1D) | 592K |

## カバレッジ

| 項目 | 数値 |
|------|------|
| ウィキデータ全個体 | 117,419,925 |
| Wikimedia 内部（除外） | 8,565,353 (7.3%) |
| SIDX 対象 | 108,854,572 (92.7%) |
| 64タイプ直接カバー | 36,295,074 (33.3%) |
| 下位タイプ吸収 | 71,842,429 (66.0%) |
| Other フォールバック | 717,069 (0.7%) |
| **最終カバレッジ** | **100%** |
| **衝突率** | **< 0.01%** |

## Q識別子接続

Entity Node は Q識別子を内蔵せず、[トリプルエッジ](../triple-edge/)で別途接続する。

```
Subject:  Entity_SIDX (64ビット)
Property: P-外部ID (例: P-Wikidata)
Object:   "Q12345" (文字列または整数)
```
