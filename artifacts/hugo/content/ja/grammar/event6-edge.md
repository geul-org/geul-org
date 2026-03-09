---
title: "イベント6エッジ"
weight: 50
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "event6", "5W1H"]
summary: "六何原則（Who, What, Whom, When, Where, Why）を一度に表現する可変長イベントEdge。Presenceビットマスクで3~8ワードの可変構造を実現する。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Event6 Edge は**六何原則**（Who, What, Whom, When, Where, Why）を一度に表現するイベント Edge タイプである。

## 六何原則の要素

| 要素 | 英文 | ビット | 意味 | TID 参照対象 |
|------|------|------|------|---------------|
| Who | Agent | 0 | 行為者 | [エンティティノード](../entity-node/) |
| What | Action | 1 | 行為/動作 | [動詞エッジ](../verb-edge/) |
| Whom | Patient | 2 | 対象/被行為者 | [エンティティノード](../entity-node/) |
| When | Time | 3 | 時間 | Quantity/Entity |
| Where | Location | 4 | 場所 | [エンティティノード](../entity-node/) |
| Why | Reason | 5 | 理由/目的 | [節エッジ](../clause-edge/)/Entity |

## パケット構造

```
1st WORD (16ビット)
┌────────────────────┬────────────────────┐
│      Prefix        │     Presence       │
│      10bit         │       6bit         │
└────────────────────┴────────────────────┘

2nd WORD (16ビット)
┌────────────────────────────────────────────┐
│                Edge TID                    │
└────────────────────────────────────────────┘

3rd+ WORD: 要素 TID（Presence 順に並ぶ）
```

### Presence ビットマスク（6ビット）

| ビット | 要素 | 存在時 |
|------|------|--------|
| 0 | Who | 該当 TID を含む |
| 1 | What | 該当 TID を含む |
| 2 | Whom | 該当 TID を含む |
| 3 | When | 該当 TID を含む |
| 4 | Where | 該当 TID を含む |
| 5 | Why | 該当 TID を含む |

総ワード = 2（ヘッダ + Edge TID）+ popcount(Presence)。範囲は3~8ワード（48~128ビット）。

## モード別構造

### 最小モード（3ワード）

```
例:「雨が降った」（Whatのみ）

1st: [Prefix] + [000010]      - Whatのみ存在
2nd: [Edge TID]
3rd: [What TID]               - "rain" Verb Edge
```

### 核心モード（5ワード）

Who + What + Whom。最も頻出の構成。

```
例:「太郎が花子を叩いた」

1st: [Prefix] + [000111]      - Who, What, Whom
2nd: [Edge TID]
3rd: [Who TID]                - 太郎
4th: [What TID]               - "hit" Verb Edge
5th: [Whom TID]               - 花子
```

### 標準モード（6ワード）

```
例:「太郎が昨日花子に会った」

1st: [Prefix] + [001111]      - Who, What, Whom, When
2nd: [Edge TID]
3rd: [Who TID]                - 太郎
4th: [What TID]               - "meet" Verb Edge
5th: [Whom TID]               - 花子
6th: [When TID]               - 昨日
```

### 完全モード（8ワード）

```
例:「太郎が愛ゆえに昨日学校で花子にプレゼントを渡した」

1st: [Prefix] + [111111]      - 全部
2nd: [Edge TID]
3rd: [Who TID]                - 太郎
4th: [What TID]               - "give" Verb Edge
5th: [Whom TID]               - 花子
6th: [When TID]               - 昨日
7th: [Where TID]              - 学校
8th: [Why TID]                - 愛（理由）
```

## 要素詳細

### What（行為）

What は[動詞エッジ](../verb-edge/) TID を参照する。該当 Verb Edge に時制、アスペクトなどの限定子情報が含まれる。

### Why（理由）

単純な理由は Entity TID（「愛」）で、複雑な理由は[節エッジ](../clause-edge/) TID（「雨が降ったので」）で表現する。

## Event6 vs Verb Edge の比較

| | Verb Edge | Event6 Edge |
|--|-----------|-------------|
| **焦点** | 述語/動作 | 完結したイベント |
| **参加者** | Participant 構造 | 六何原則 TID |
| **時空** | 別途表現 | When/Where 内蔵 |
| **理由** | 別途 Clause | Why 内蔵 |
| **ワード** | 2~5 | 3~8 |
| **用途** | 述語表現 | イベント格納 |

**選択ガイド：** 述語/文の分析には Verb Edge、イベント/記録格納には Event6 Edge、簡単な事実には[トリプルエッジ](../triple-edge/)を使用する。

## 例

### 「AppleがTeslaを買収した」

```
Who:  Apple (Q312)     → Entity TID 0x0001
What: acquire          → Verb Edge TID 0x0100
Whom: Tesla (Q478214)  → Entity TID 0x0002

Event6 Edge:
  1st: [1100 000 011] + [000111]  - Prefix + Who,What,Whom
  2nd: [TID: 0x0200]              - Edge TID
  3rd: [TID: 0x0001]              - Apple (Who)
  4th: [TID: 0x0100]              - acquire (What)
  5th: [TID: 0x0002]              - Tesla (Whom)

合計: 5ワード
```

### 「李舜臣が1598年に露梁海戦で戦死した」

```
Who:   李舜臣           → Entity TID 0x0010
What:  die (戦死)       → Verb Edge TID 0x0101
When:  1598            → Entity TID 0x0011
Where: 露梁海戦         → Entity TID 0x0012

Event6 Edge:
  1st: [1100 000 011] + [011011]  - Who,What,When,Where
  2nd: [TID: 0x0202]
  3rd: [TID: 0x0010]              - 李舜臣
  4th: [TID: 0x0101]              - die
  5th: [TID: 0x0011]              - 1598
  6th: [TID: 0x0012]              - 露梁海戦

合計: 6ワード
```

## パース

```python
def parse_event6(data: bytes) -> dict:
    word1 = int.from_bytes(data[0:2], 'big')

    prefix = word1 >> 6
    assert prefix == 0b1100000011, "Not Event6 Edge"

    presence = word1 & 0x3F
    edge_tid = int.from_bytes(data[2:4], 'big')

    elements = {}
    element_names = ['who', 'what', 'whom', 'when', 'where', 'why']
    offset = 4

    for i, name in enumerate(element_names):
        if presence & (1 << i):
            tid = int.from_bytes(data[offset:offset+2], 'big')
            elements[name] = tid
            offset += 2

    return {
        'presence': presence,
        'edge_tid': edge_tid,
        'elements': elements,
        'words': 2 + bin(presence).count('1')
    }
```
