---
title: "SILK — LLMナレッジのためのシンボリックインデックス"
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["SILK", "search", "SIDX", "neuro-symbolic"]
summary: "64ビット整数で検索するニューロシンボリック検索アーキテクチャ。ベクトルDB、ANNグラフ、埋め込みモデルなしでWikidata1億エンティティをサブ秒検索。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Symbolic Index for LLM Knowledge** — ニューロシンボリック検索アーキテクチャ。

64ビット整数で検索する。ベクトルDB、ANNグラフ、埋め込みモデルは不要。

<a href="https://github.com/park-jun-woo/silk" target="_blank" rel="noopener">GitHubリポジトリ</a>

## 核心命題

検索は難しい問題ではなく、**構造のないデータの症状**だった。
書き込み時に64ビット構造を付与すれば、症状は消える。

```python
results = index[(index & mask) == pattern]
```

Wikidata1億エンティティを1.3GBメモリでサブ秒検索。
Python（NumPy）だけで最適化されたC++/RustベクトルDBに勝つ——アーキテクチャの勝利。

## なぜベクトル埋め込みではないのか

ベクトル埋め込みは構造を潰す。

```
「織田信長は戦国時代の武将である」
 → 人間は即座に把握：日本人、武将、16世紀

埋め込みモデル：
 [0.234, -0.891, 0.445, ..., 0.112] (384次元 float)
 → 構造消滅。personなのかlocationなのか読めない。

潰された構造を復元するために：
 ANNグラフ (HNSW, IVF-PQ)、クロスエンコーダー、リランカー、メタデータフィルター…
```

SILKは構造を保存する。

```
SIDX: [Human / military / east_asia / early_modern]
 → ビットに構造が生きている。読める。
 → 復元不要。潰していないから。
```

核心は順序の転換にある。

```
従来：先に書く → 後で構造化（インデキシング）
SILK：書くときに構造化 → 検索がタダ
```

## SIDXビットレイアウト

SIDXは[GEUL文法](/ja/grammar/) Entity Node仕様に従う。

```
[prefix 7 | mode 3 | entity_type 6 | attrs 48]
 MSB(63)                                  LSB(0)
```

| フィールド | ビット | 幅 | 説明 |
|-----------|--------|------|------|
| prefix | 63-57 | 7 | GEULプロトコルヘッダー（`0001001`固定、検索時無視） |
| mode | 56-54 | 3 | 量化/数モード（登録エンティティ=0、定冠詞、普遍、存在など8種） |
| entity_type | 53-48 | 6 | 64個の最上位タイプ（Human=0 ~ Election=62、未分類=63） |
| attrs | 47-0 | 48 | タイプ別属性エンコーディング（コードブック定義） |

検索対象：entity_type 6ビット + attrs 48ビット = **54ビット**。
QIDはSIDXに含まれず、別の配列に格納する。

### attrs 48ビット — タイプ別スキーマ

```
Human(0):       subclass 5 | occupation 6 | country 8 | era 4 | decade 4 | gender 2 | notability 3 | ...
Star(12):       constellation 7 | spectral_type 4 | luminosity 3 | magnitude 4 | ra_zone 4 | dec_zone 4 | ...
Settlement(28): country 8 | admin_level 4 | admin_code 8 | lat_zone 4 | lon_zone 4 | population 4 | ...
Organization(44): country 8 | org_type 4 | legal_form 6 | industry 8 | era 4 | size 4 | ...
Film(51):       country 8 | year 7 | genre 6 | language 8 | color 2 | duration 4 | ...
```

現在5つのタイプの属性ビット配置が定義済み。残りはentity_typeのみエンコード。

## アーキテクチャ

SILKには2つのパイプラインがある。**エンコーディング**（書き込み時）と**検索**（クエリ時）。
両者とも同じ原理：シンボリックが構造を掴み、LLMが意味を処理する。

```
エンコーディングパイプライン（書き込み時）
┌──────────────┐   ┌──────────────┐   ┌──────────────┐
│  LLMタグ付け │──►│  VALID検証   │──►│コードブック   │
│  文書 → JSON │   │コードブック   │   │エンコード     │
│ （意味分類） │   │  有効値      │   │ JSON → SIDX  │
│              │   │整合性チェック│   │（ビット組立） │
│              │   │幻覚 → 脱落  │   │              │
└──────────────┘   └──────────────┘   └──────────────┘
   LLMがタグ付け    コードが検証      コードブック基盤エンコーディング
```

```
検索パイプライン（クエリ時）
┌──────────────┐   ┌──────────────┐   ┌──────────────┐
│  クエリ解析  │──►│ビットANDフィルタ│──►│  LLM判定    │
│ コードブック │   │  NumPy SIMD  │   │ 少数候補のみ │
│ ルックアップ │   │1億件 → 数十件│   │数十件 → 正解 │
│  + LLM補助   │   │              │   │              │
└──────────────┘   └──────────────┘   └──────────────┘
   意味抽出          広くフィルタリング   絞って判定
```

核心戦略：**SIDXビットANDで漏れなく広くフィルタリング**し、**LLMが少数候補のみ判定**する。

```
それぞれの得意分野を遂行：
 人間：構造設計（コードブック）
 LLM： 意味分類（タグ付け）+ 意味判定（検索）
 コード：ルール検証（VALID）+ ビット組立
 CPU：  大量比較（NumPy SIMD）
```

### エンコーディング：LLMタグ付け → VALID検証

LLMが文書を読みJSONでタグ付けする。VALIDがコードブック基準で機械的検査を行う。
コードブックにない値、タイプ間整合性違反、制約条件違反は**物理的にインデックスに入れない**。

```
LLMタグ付け：{"type": "Human", "occupation": "military", "country": "korea"}
VALID：      occupation="military" ∈ コードブック? ✓  country="korea" ∈ コードブック? ✓
             Humanなのにconstellationフィールド? ✗ 脱落
エンコード：  コードブックから "military"→6ビット, "korea"→8ビット → ビット組立 → SIDX uint64
```

LLMは幻覚を起こし得る。しかしVALIDが門番の役割を果たすため、インデックス汚染の可能性はゼロ。
VALIDを通過したJSONのみがコードブック基盤でSIDX 64ビット整数にエンコードされる。

### 検索：広くフィルタリング、LLMが絞る

```
1. クエリ意味抽出     コードブックルックアップ 80% / LLM補助 20%
2. ビットマスク組立   決定的 — アルゴリズム
3. NumPyビットAND    決定的 — 1億件全数スキャン 20ms
4. LLM最終判定       少数候補のみ — 意味的精密判定
```

### 検索の80%は構造的クエリ

```
「織田信長」      → Q178521 完全一致。ビットAND。終了。
「トヨタ ニュース」→ org/company + doc_meta/news。ビットAND。終了。
「バイデン-習近平 会談」→ Q6279 ∩ Q15031 ∩ meeting。積集合。終了。
```

```
構造的クエリ（80%）：SILKビットANDで完結。LLM不要。
意味的クエリ（15%）：SILKで候補縮小 → LLMが5-10件判定。
生成クエリ （5%）： SILKで文書特定 → LLMが生成。
```

## Multi-SIDX

一つの文書/イベントに複数のSIDXが付く。

```
ニュース記事「トヨタ・ソニー・ソフトバンク首脳会合」：

SIDX[0]: [Human / business / east_asia ]  豊田章男
SIDX[1]: [Org   / company / east_asia ]  トヨタ自動車
SIDX[2]: [Human / business / east_asia ]  吉田憲一郎
SIDX[3]: [Org   / company / east_asia ]  ソニーグループ
SIDX[4]: [Human / business / east_asia ]  孫正義
SIDX[5]: [Org   / company / east_asia ]  ソフトバンクグループ
SIDX[6]: [Event / meeting / east_asia ]  会合
```

すべて同じ64ビットSIDX。同じインデックス。同じビットANDで検索。
entity_typeフィールドがエンティティ（Human, Org）とイベント（Event）を区別する。

## インデックス構造

```python
sidx_array = np.array([...], dtype=np.uint64)  # 108.8M × 8B = 870MB
qid_array  = np.array([...], dtype=np.uint32)  # 108.8M × 4B = 435MB
# 合計 ~1.3GB メモリ
```

```
インデックス構築：
 Elasticsearch：トークナイズ → 分析 → 転置インデックス → セグメントマージ
 Pinecone：     埋め込み → HNSWグラフ → クラスタリング
 SILK：         sort
```

データ構造なし。ソート済み配列が一つだけ。

## ベクトルDB比較

|  | SILK | ベクトルDB |
|------|------|-----------|
| インデックスサイズ（1兆件） | 12TB | 1.5PB（125倍） |
| インデックス構築 | sort | HNSW 数日 |
| コールドスタート | ファイルを開けば即座に | グラフ構築 数時間 |
| 分割スキャン | 可能（結果同一） | 不可能（グラフ断裂） |
| 複合条件 | 積集合（正確） | ベクトル1つに圧縮（近似） |
| 結果 | 正確（集合演算） | 近似（類似度ランキング） |
| 監査可能性 | JSON（ホワイトボックス） | 不可能（ブラックボックス） |

```
ビットANDは順序無関係、ステートレス、合算可能。
ベクトルDB：グラフ全体がメモリに必要。分割 = 破壊。
SILK：     どこで切っても動作。分割 = 遅くなるだけ。結果同一。
```

## 監査パイプライン

ベクトル埋め込みはブラックボックスで監査不可能。SIDXはJSONで監査可能。

```
第1段階 — 小型LLMタグ付け   Llama 8B / GPT-4o-mini。精度85-90%。
第2段階 — VALID機械検査      有効値、整合性、制約条件。コスト $0。
第3段階 — 大型LLM監査       confidence=lowのみ。精度99%+。

VALIDが門番：コードブック有効値の外の幻覚は物理的にインデックスに入れない。
```

## ライセンス

MIT — <a href="https://github.com/park-jun-woo/silk" target="_blank" rel="noopener">GitHub</a>
