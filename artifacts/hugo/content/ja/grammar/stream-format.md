---
title: "ストリームフォーマット"
weight: 100
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "stream", "TID"]
summary: "GEULストリームはMeta Nodeで始まり終わるパケットシーケンスである。TIDスコーピング、順方向参照、パケット順序規則を定義する。"
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

GEUL ストリームは **Meta Node で始まり終わるパケットシーケンス**であり、一つの完結した GEUL 文書である。

## 核心特徴

- **境界明示：** STREAM_START / STREAM_END (Meta Node)
- **TID スコープ：** ストリーム内でのみ有効
- **順方向参照：** 宣言済みの TID のみ参照可能
- **Big Endian：** Network Byte Order

## ストリーム構造

```
┌─────────────────────────────────────┐
│          STREAM_START               │  ← 必須 (Meta Node)
│          (TID 幅宣言)               │     0xC000 (16ビット TID)
├─────────────────────────────────────┤
│          メタデータ (任意)            │
│          - VERSION    (0xC014)      │
│          - CREATED_AT (0xC008)      │
│          - CREATOR    (0xC010)      │
├─────────────────────────────────────┤
│          本文パケット                 │
│          - Entity Node              │
│          - Quantity Node            │
│          - Verb Edge                │
│          - Triple Edge              │
│          - Event6 Edge              │
│          - Clause Edge              │
│          - Context Edge             │
│          - Group Edge               │
│          - Faber Edge               │
├─────────────────────────────────────┤
│          STREAM_END                 │  ← 任意（推奨）
└─────────────────────────────────────┘
```

最小ストリームは `STREAM_START`（1ワード）+ `STREAM_END`（1ワード）= 2ワード（4バイト）であり、空ストリームも有効である。

## TID 割り当て原則

| 規則 | 説明 |
|------|------|
| **必須性** | ストリーム内のすべての Edge/Node は TID を持つ |
| **一意性** | ストリーム内で TID は一意である |
| **スコープ** | TID は当該ストリーム内でのみ有効 |
| **順方向** | 参照時点ですでに宣言された TID のみ参照可能 |

### TID の位置

| タイプ | TID の位置 | 参照の位置 |
|------|----------|-----------|
| **Meta Node** | なし | なし |
| **Entity Node** | 最終ワード | なし |
| **Quantity Node** | 最終ワード | なし |
| **Tiny Verb Edge** | なし | なし（インライン） |
| **Verb Edge** | Header 領域 | Payload 以降 |
| **Triple Edge** | Header 領域 | Payload 以降 |
| **Event6 Edge** | Header 領域 | Payload 以降 |
| **Clause Edge** | Header 領域 | Payload 以降 |
| **Context Edge** | Header 領域 | Payload 以降 |
| **Group Edge** | 2ndワード | 3rd+ワード |

**Node** は自分自身のみを定義するため TID が末尾に、**Edge** は他の TID を参照するため TID が参照より前に位置する。

### 予約 TID

| TID | 用途 |
|-----|------|
| 0x0000 | **終結マーカー**（[グループエッジ](../group-edge/)等） |
| 0xFFFF | 予約（16ビット基準） |

## パケット順序規則

### 宣言-参照順序

```
正しい:
  [Entity: 太郎, TID=0x0001]
  [Entity: 花子, TID=0x0002]
  [Verb Edge: 会う, Subject=0x0001, Object=0x0002]

誤り:
  [Verb Edge: 会う, Subject=0x0001, Object=0x0002]  ← 0x0001 未宣言
  [Entity: 太郎, TID=0x0001]
  [Entity: 花子, TID=0x0002]
```

### 推奨順序

```
1. STREAM_START
2. メタデータ (VERSION, CREATED_AT, CREATOR)
3. Entity Node（個体宣言）
4. Quantity Node（数量/リテラル）
5. Group Edge（グループ定義）
6. Tiny Verb Edge（インライン述語）
7. Verb Edge（一般述語）
8. Triple Edge（属性/関係）
9. Event6 Edge（イベント）
10. Clause Edge（談話関係）
11. Context Edge（文脈）
12. Faber Edge（コード/AST）
13. STREAM_END
```

推奨順序に過ぎず、宣言-参照規則さえ守れば自由に配置できる。

### 循環参照の禁止

A → B → A 形式の循環参照は不可能である。循環関係が必要な場合は別途 Edge で表現する。

```
可能:
  [Entity A, TID=0x0001]
  [Entity B, TID=0x0002]
  [Edge: A→B, TID=0x0003]
  [Edge: B→A, TID=0x0004]
```

## ストリーム例

### 「太郎が花子に会った」

```
1. STREAM_START (TID 16ビット)
   0xC0 0x00

2. Entity: 太郎 (TID=0x0001)
   [Entity パケット...] 0x00 0x01

3. Entity: 花子 (TID=0x0002)
   [Entity パケット...] 0x00 0x02

4. Verb Edge: meet (TID=0x0100)
   Subject: 0x0001
   Object: 0x0002

5. STREAM_END
   0xC0 0x04
```

### 「太郎と花子が学校で会った」

```
1. STREAM_START
   0xC0 0x00

2. Entity: 太郎 (TID=0x0001)
3. Entity: 花子 (TID=0x0002)
4. Entity: 学校 (TID=0x0003)

5. Group Edge: AND (TID=0x0010)
   メンバー: 0x0001, 0x0002, 0x0000 (終結)

6. Verb Edge: meet (TID=0x0100)
   Subject: 0x0010 (グループ)
   Location: 0x0003

7. STREAM_END
   0xC0 0x04
```

## ストリーム検証

### 必須検証

| 項目 | 検証 |
|------|------|
| 開始 | STREAM_START で始まっているか？ |
| TID 一意性 | 重複 TID がないか？ |
| 参照有効性 | 参照された TID がすべて宣言済みか？ |
| 順方向 | 参照時点で TID がすでに宣言されているか？ |

### 検証コード

```python
def validate_stream(packets: list) -> dict:
    """ストリーム有効性検証"""
    errors = []
    declared_tids = set()

    # 開始検証
    if not packets or packets[0].type != "STREAM_START":
        errors.append("ストリームが STREAM_START で始まっていない")

    for packet in packets:
        # TID 一意性検証
        if packet.tid is not None:
            if packet.tid in declared_tids:
                errors.append(f"重複 TID: {packet.tid}")
            declared_tids.add(packet.tid)

        # 参照有効性検証
        for ref_tid in packet.references:
            if ref_tid not in declared_tids:
                errors.append(f"未宣言 TID 参照: {ref_tid}")

    return {
        "valid": len(errors) == 0,
        "errors": errors,
        "tid_count": len(declared_tids)
    }
```

## 複数ストリーム

各ストリームは独立しており、TID スコープはストリームごとに分離される。Stream A の TID=0x0001 と Stream B の TID=0x0001 は異なる個体である。

ストリーム間参照（Cross-reference）は現在未サポートであり、今後ストリーム ID の導入と Import/Export メカニズムで拡張可能である。
