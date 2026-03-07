---
title: "流格式"
weight: 100
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "stream", "TID"]
summary: "GEUL流是以Meta Node开始和结束的数据包序列。定义TID作用域、前向引用、数据包顺序规则。"
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

GEUL 流是**以 Meta Node 开始和结束的数据包序列**，构成一个完整的 GEUL 文档。

## 核心特征

- **边界明示：** STREAM_START / STREAM_END (Meta Node)
- **TID 作用域：** 仅在流内有效
- **前向引用：** 只能引用已声明的 TID
- **Big Endian：** Network Byte Order

## 流结构

```
┌─────────────────────────────────────┐
│          STREAM_START               │  ← 必需 (Meta Node)
│          (TID 宽度声明)              │     0xC000 (16位 TID)
├─────────────────────────────────────┤
│          元数据 (可选)               │
│          - VERSION    (0xC014)      │
│          - CREATED_AT (0xC008)      │
│          - CREATOR    (0xC010)      │
├─────────────────────────────────────┤
│          正文数据包                   │
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
│          STREAM_END                 │  ← 可选（建议）
└─────────────────────────────────────┘
```

最小流为 `STREAM_START`（1字）+ `STREAM_END`（1字）= 2字（4字节），空流也是有效的。

## TID 分配原则

| 规则 | 说明 |
|------|------|
| **必要性** | 流内所有 Edge/Node 都拥有 TID |
| **唯一性** | 流内 TID 唯一 |
| **作用域** | TID 仅在该流内有效 |
| **前向** | 引用时只能引用已声明的 TID |

### TID 位置

| 类型 | TID 位置 | 引用位置 |
|------|----------|-----------|
| **Meta Node** | 无 | 无 |
| **Entity Node** | 最后一个字 | 无 |
| **Quantity Node** | 最后一个字 | 无 |
| **Tiny Verb Edge** | 无 | 无（内联） |
| **Verb Edge** | Header 区域 | Payload 之后 |
| **Triple Edge** | Header 区域 | Payload 之后 |
| **Event6 Edge** | Header 区域 | Payload 之后 |
| **Clause Edge** | Header 区域 | Payload 之后 |
| **Context Edge** | Header 区域 | Payload 之后 |
| **Group Edge** | 第2字 | 第3+字 |

**Node** 仅定义自身所以 TID 在末尾，**Edge** 引用其他 TID 所以 TID 在引用之前。

### 保留 TID

| TID | 用途 |
|-----|------|
| 0x0000 | **终止标记**（[分组边](../group-edge/)等） |
| 0xFFFF | 保留（16位标准） |

## 数据包顺序规则

### 声明-引用顺序

```
正确:
  [Entity: 小明, TID=0x0001]
  [Entity: 小红, TID=0x0002]
  [Verb Edge: 见面, Subject=0x0001, Object=0x0002]

错误:
  [Verb Edge: 见面, Subject=0x0001, Object=0x0002]  ← 0x0001 未声明
  [Entity: 小明, TID=0x0001]
  [Entity: 小红, TID=0x0002]
```

### 建议顺序

```
1. STREAM_START
2. 元数据 (VERSION, CREATED_AT, CREATOR)
3. Entity Node (实体声明)
4. Quantity Node (数量/字面量)
5. Group Edge (分组定义)
6. Tiny Verb Edge (内联谓述)
7. Verb Edge (一般谓述)
8. Triple Edge (属性/关系)
9. Event6 Edge (事件)
10. Clause Edge (篇章关系)
11. Context Edge (语境)
12. Faber Edge (代码/AST)
13. STREAM_END
```

这仅是建议顺序，只要遵守声明-引用规则即可自由排列。

### 禁止循环引用

A → B → A 形式的循环引用不允许。如需循环关系则用单独的 Edge 表达。

```
可以:
  [Entity A, TID=0x0001]
  [Entity B, TID=0x0002]
  [Edge: A→B, TID=0x0003]
  [Edge: B→A, TID=0x0004]
```

## 流示例

### "小明见了小红"

```
1. STREAM_START (TID 16位)
   0xC0 0x00

2. Entity: 小明 (TID=0x0001)
   [Entity 数据包...] 0x00 0x01

3. Entity: 小红 (TID=0x0002)
   [Entity 数据包...] 0x00 0x02

4. Verb Edge: meet (TID=0x0100)
   Subject: 0x0001
   Object: 0x0002

5. STREAM_END
   0xC0 0x04
```

### "小明和小红在学校见面了"

```
1. STREAM_START
   0xC0 0x00

2. Entity: 小明 (TID=0x0001)
3. Entity: 小红 (TID=0x0002)
4. Entity: 学校 (TID=0x0003)

5. Group Edge: AND (TID=0x0010)
   成员: 0x0001, 0x0002, 0x0000 (终止)

6. Verb Edge: meet (TID=0x0100)
   Subject: 0x0010 (分组)
   Location: 0x0003

7. STREAM_END
   0xC0 0x04
```

## 流验证

### 必须验证

| 项目 | 验证 |
|------|------|
| 起始 | 是否以 STREAM_START 开始？ |
| TID 唯一性 | 是否存在重复 TID？ |
| 引用有效性 | 引用的 TID 是否全部已声明？ |
| 前向性 | 引用时 TID 是否已声明？ |

### 验证代码

```python
def validate_stream(packets: list) -> dict:
    """流有效性验证"""
    errors = []
    declared_tids = set()

    # 起始验证
    if not packets or packets[0].type != "STREAM_START":
        errors.append("流未以 STREAM_START 开始")

    for packet in packets:
        # TID 唯一性验证
        if packet.tid is not None:
            if packet.tid in declared_tids:
                errors.append(f"重复 TID: {packet.tid}")
            declared_tids.add(packet.tid)

        # 引用有效性验证
        for ref_tid in packet.references:
            if ref_tid not in declared_tids:
                errors.append(f"引用未声明 TID: {ref_tid}")

    return {
        "valid": len(errors) == 0,
        "errors": errors,
        "tid_count": len(declared_tids)
    }
```

## 多流

各流独立，TID 作用域按流分离。Stream A 的 TID=0x0001 与 Stream B 的 TID=0x0001 是不同实体。

流间引用（Cross-reference）目前不支持，未来可通过引入流 ID 和 Import/Export 机制进行扩展。
