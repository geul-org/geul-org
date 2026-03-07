---
title: "トリプルエッジ"
weight: 30
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "triple", "property"]
summary: "(Subject, Property, Object)形式の関係と属性を表現するEdgeタイプ。基本モード4ワードと拡張モード5ワードの二重構造でTop 63高頻度属性を最適化する。"
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Triple Edge は `(Subject, Property, Object)` 形式の**関係/属性**を表現する Edge タイプである。

## 二重モード設計

- **基本モード（4ワード）：** PropCode 0~62（Top 63 属性）
- **拡張モード（5ワード）：** PropCode=63で全 P-ID をカバー（意味整列16ビット）

## 基本モード（4ワード = 64ビット）

```
1st WORD (16ビット)
┌────────────────────┬────────────────────┐
│      Prefix        │     PropCode       │
│      10bit         │       6bit         │
└────────────────────┴────────────────────┘

2nd WORD: Edge TID (16ビット)
3rd WORD: Subject TID (16ビット)
4th WORD: Object TID (16ビット)
```

| フィールド | ビット | 説明 |
|------|------|------|
| Prefix | 10 | `1100 000 001` |
| PropCode | 6 | 0~62: Top 63 属性, 63: 拡張モード |
| Edge TID | 16 | この Edge の TID |
| Subject TID | 16 | 主語 Entity/Node TID |
| Object TID | 16 | 目的語 Entity/Node/Quantity TID |

## 拡張モード（5ワード = 80ビット）

PropCode が63の場合、3rdワードに16ビット P-ID が追加される。

```
1st WORD: [Prefix 10bit] + [PropCode=63 6bit]
2nd WORD: Edge TID (16ビット)
3rd WORD: P-ID 意味整列 (16ビット)
4th WORD: Subject TID (16ビット)
5th WORD: Object TID (16ビット)
```

## Top 63 属性（PropCode 0~62）

ウィキデータ使用頻度に基づき選定された属性。

### 分類/タイプ（Code 0~7）

| Code | P-ID | 属性名 | 説明 |
|------|------|--------|------|
| 0 | P31 | instance of | ~のインスタンス |
| 1 | P279 | subclass of | ~の下位クラス |
| 2 | P361 | part of | ~の部分 |
| 3 | P527 | has part | ~を含む |
| 4 | P1552 | has quality | 属性/特性 |
| 5 | P460 | same as | 同一 |
| 6 | P1889 | different from | 異なる |
| 7 | P156 | followed by | 後続 |

### 空間/位置（Code 8~15）

| Code | P-ID | 属性名 | 説明 |
|------|------|--------|------|
| 8 | P17 | country | 国 |
| 9 | P131 | located in | 位置（行政区域） |
| 10 | P276 | location | 位置（場所） |
| 11 | P625 | coordinate | 座標 |
| 12 | P30 | continent | 大陸 |
| 13 | P36 | capital | 首都 |
| 14 | P150 | contains | 含む（地域） |
| 15 | P206 | located next to | 隣接水域 |

### 時間（Code 16~23）

| Code | P-ID | 属性名 | 説明 |
|------|------|--------|------|
| 16 | P569 | date of birth | 生年月日 |
| 17 | P570 | date of death | 没年月日 |
| 18 | P571 | inception | 設立日 |
| 19 | P576 | dissolved | 解散日 |
| 20 | P577 | publication date | 発表日 |
| 21 | P580 | start time | 開始時点 |
| 22 | P582 | end time | 終了時点 |
| 23 | P585 | point in time | 時点 |

### 人物基本（Code 24~31）

| Code | P-ID | 属性名 | 説明 |
|------|------|--------|------|
| 24 | P19 | place of birth | 出生地 |
| 25 | P20 | place of death | 死亡地 |
| 26 | P21 | sex or gender | 性別 |
| 27 | P27 | citizenship | 国籍 |
| 28 | P735 | given name | 名 |
| 29 | P734 | family name | 姓 |
| 30 | P1559 | name in native language | 本名 |
| 31 | P742 | pseudonym | 筆名/芸名 |

### 関係/所属（Code 32~39）

| Code | P-ID | 属性名 | 説明 |
|------|------|--------|------|
| 32 | P22 | father | 父 |
| 33 | P25 | mother | 母 |
| 34 | P26 | spouse | 配偶者 |
| 35 | P40 | child | 子 |
| 36 | P3373 | sibling | 兄弟姉妹 |
| 37 | P463 | member of | 所属 |
| 38 | P108 | employer | 雇用主 |
| 39 | P1027 | conferred by | 授与機関 |

### 職業/活動（Code 40~47）

| Code | P-ID | 属性名 | 説明 |
|------|------|--------|------|
| 40 | P106 | occupation | 職業 |
| 41 | P39 | position held | 職位 |
| 42 | P69 | educated at | 学歴 |
| 43 | P101 | field of work | 分野 |
| 44 | P1344 | participant in | 参加（イベント） |
| 45 | P166 | award received | 受賞 |
| 46 | P800 | notable work | 代表作 |
| 47 | P1412 | languages spoken | 使用言語 |

### メディア/識別（Code 48~55）

| Code | P-ID | 属性名 | 説明 |
|------|------|--------|------|
| 48 | P18 | image | 画像 |
| 49 | P154 | logo | ロゴ |
| 50 | P41 | flag image | 国旗/旗 |
| 51 | P373 | Commons category | ウィキメディア |
| 52 | P856 | official website | 公式ウェブサイト |
| 53 | P214 | VIAF ID | VIAF |
| 54 | P227 | GND ID | GND |
| 55 | P213 | ISNI | ISNI |

### 作品/創作（Code 56~62）

| Code | P-ID | 属性名 | 説明 |
|------|------|--------|------|
| 56 | P50 | author | 著者 |
| 57 | P57 | director | 監督 |
| 58 | P86 | composer | 作曲家 |
| 59 | P175 | performer | 演奏者/歌手 |
| 60 | P136 | genre | ジャンル |
| 61 | P364 | original language | 原語 |
| 62 | P123 | publisher | 出版社 |

Code 63 は**拡張モード表示子**として予約されている。

## PropCode まとめ

```
┌─────────────────────────────────────────────┐
│  0~7:   分類/タイプ (P31, P279, ...)        │
│  8~15:  空間/位置 (P17, P131, ...)          │
│  16~23: 時間 (P569, P570, ...)              │
│  24~31: 人物基本 (P19, P20, ...)            │
│  32~39: 関係/所属 (P22, P25, ...)           │
│  40~47: 職業/活動 (P106, P39, ...)          │
│  48~55: メディア/識別 (P18, P856, ...)      │
│  56~62: 作品/創作 (P50, P57, ...)           │
├─────────────────────────────────────────────┤
│  63: 拡張モード表示子                        │
└─────────────────────────────────────────────┘
```

## 例

### 基本モード：「Appleは企業である」

```
P31 (instance of) → PropCode = 0

Triple Edge:
  1st: [1100 000 001] + [000000]  - Prefix + PropCode 0
  2nd: [TID: 0x0101]              - Edge TID
  3rd: [TID: 0x0010]              - Apple (Subject)
  4th: [TID: 0x0020]              - 企業 (Object)

合計: 4ワード
```

### 拡張モード：「エッフェル塔の高さは330m」

```
P2048 (height) → Top 63 外 → 拡張モード

Triple Edge:
  1st: [1100 000 001] + [111111]  - Prefix + Ext(63)
  2nd: [TID: 0x0102]              - Edge TID
  3rd: [0xA800]                   - P2048 意味整列
  4th: [TID: 0x0030]              - エッフェル塔 (Subject)
  5th: [TID: 0x0050]              - 330m Quantity (Object)

合計: 5ワード
```

## パース

```python
def parse_triple_edge(data: bytes) -> dict:
    word1 = int.from_bytes(data[0:2], 'big')

    prefix = word1 >> 6
    assert prefix == 0b1100000001, "Not Triple Edge"

    prop_code = word1 & 0x3F

    if prop_code < 63:
        # 基本モード (4ワード)
        return {
            'mode': 'basic',
            'prop_code': prop_code,
            'edge_tid': int.from_bytes(data[2:4], 'big'),
            'subject_tid': int.from_bytes(data[4:6], 'big'),
            'object_tid': int.from_bytes(data[6:8], 'big'),
            'words': 4
        }
    else:
        # 拡張モード (5ワード)
        return {
            'mode': 'extended',
            'p_id': int.from_bytes(data[4:6], 'big'),
            'edge_tid': int.from_bytes(data[2:4], 'big'),
            'subject_tid': int.from_bytes(data[6:8], 'big'),
            'object_tid': int.from_bytes(data[8:10], 'big'),
            'words': 5
        }
```
