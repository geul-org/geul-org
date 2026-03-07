---
title: "حافة الحدث6"
weight: 50
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "event6", "5W1H"]
summary: "حافة حدث متغيرة الطول تعبّر عن الأسئلة الستة (مَن، ماذا، لِمَن، متى، أين، لماذا) دفعة واحدة. تحقق بنية متغيرة 3~8 كلمات عبر قناع Presence البتي."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Event6 Edge هو نوع Edge يعبّر عن **الأسئلة الستة** (Who, What, Whom, When, Where, Why) دفعة واحدة.

## عناصر الأسئلة الستة

| العنصر | الإنجليزي | البت | المعنى | هدف TID |
|--------|-----------|------|--------|---------|
| مَن | Agent | 0 | الفاعل | [عقدة الكيان](../entity-node/) |
| ماذا | Action | 1 | الفعل/الحدث | [حافة الفعل](../verb-edge/) |
| لِمَن | Patient | 2 | المتأثر | [عقدة الكيان](../entity-node/) |
| متى | Time | 3 | الزمن | Quantity/Entity |
| أين | Location | 4 | المكان | [عقدة الكيان](../entity-node/) |
| لماذا | Reason | 5 | السبب/الغرض | [حافة الجملة](../clause-edge/)/Entity |

## بنية الحزمة

```
1st WORD (16 bits)
┌────────────────────┬────────────────────┐
│      Prefix        │     Presence       │
│      10bit         │       6bit         │
└────────────────────┴────────────────────┘

2nd WORD (16 bits)
┌────────────────────────────────────────────┐
│                Edge TID                    │
└────────────────────────────────────────────┘

3rd+ WORD: Element TIDs (in Presence order)
```

### قناع Presence البتي (6 بت)

| البت | العنصر | إذا كان موجوداً |
|------|--------|----------------|
| 0 | Who | يُضاف TID |
| 1 | What | يُضاف TID |
| 2 | Whom | يُضاف TID |
| 3 | When | يُضاف TID |
| 4 | Where | يُضاف TID |
| 5 | Why | يُضاف TID |

إجمالي الكلمات = 2 (رأس + Edge TID) + popcount(Presence). النطاق 3~8 كلمات (48~128 بت).

## البنية حسب الوضع

### الوضع الأدنى (3 كلمات)

```
Example: "أمطرت" (What only)

1st: [Prefix] + [000010]      - What only
2nd: [Edge TID]
3rd: [What TID]               - "rain" Verb Edge
```

### الوضع الأساسي (5 كلمات)

Who + What + Whom. التركيب الأكثر شيوعاً.

```
Example: "ضرب أحمد خالداً"

1st: [Prefix] + [000111]      - Who, What, Whom
2nd: [Edge TID]
3rd: [Who TID]                - أحمد
4th: [What TID]               - "hit" Verb Edge
5th: [Whom TID]               - خالد
```

### الوضع القياسي (6 كلمات)

```
Example: "التقى أحمد بفاطمة أمس"

1st: [Prefix] + [001111]      - Who, What, Whom, When
2nd: [Edge TID]
3rd: [Who TID]                - أحمد
4th: [What TID]               - "meet" Verb Edge
5th: [Whom TID]               - فاطمة
6th: [When TID]               - أمس
```

### الوضع الكامل (8 كلمات)

```
Example: "أعطى أحمد فاطمة هدية في المدرسة أمس حباً"

1st: [Prefix] + [111111]      - all
2nd: [Edge TID]
3rd: [Who TID]                - أحمد
4th: [What TID]               - "give" Verb Edge
5th: [Whom TID]               - فاطمة
6th: [When TID]               - أمس
7th: [Where TID]              - المدرسة
8th: [Why TID]                - حب (السبب)
```

## تفاصيل العناصر

### What (الفعل)

يشير What إلى TID [حافة الفعل](../verb-edge/). تتضمن حافة الفعل المعنية معلومات المحددات كالزمن والمظهر.

### Why (السبب)

السبب البسيط يُعبَّر عنه بـ Entity TID ("حب")، والسبب المعقد بـ [حافة الجملة](../clause-edge/) TID ("لأنه أمطرت").

## مقارنة Event6 مقابل Verb Edge

| | Verb Edge | Event6 Edge |
|--|-----------|-------------|
| **التركيز** | وصف/فعل | حدث مكتمل |
| **المشاركون** | بنية Participant | TID الأسئلة الستة |
| **الزمكان** | تعبير منفصل | When/Where مدمجان |
| **السبب** | Clause منفصلة | Why مدمج |
| **الكلمات** | 2~5 | 3~8 |
| **الاستخدام** | تعبير وصفي | تخزين أحداث |

**دليل الاختيار:** Verb Edge لتحليل الأوصاف/الجمل، Event6 Edge لتخزين الأحداث/السجلات، [حافة الثلاثية](../triple-edge/) للحقائق البسيطة.

## أمثلة

### "استحوذت Apple على Tesla"

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

Total: 5 words
```

### "استشهد صلاح الدين في معركة حطين عام 1187"

```
Who:   صلاح الدين       → Entity TID 0x0010
What:  die (استشهد)      → Verb Edge TID 0x0101
When:  1187             → Entity TID 0x0011
Where: حطين             → Entity TID 0x0012

Event6 Edge:
  1st: [1100 000 011] + [011011]  - Who,What,When,Where
  2nd: [TID: 0x0202]
  3rd: [TID: 0x0010]              - صلاح الدين
  4th: [TID: 0x0101]              - die
  5th: [TID: 0x0011]              - 1187
  6th: [TID: 0x0012]              - حطين

Total: 6 words
```

## التحليل

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
