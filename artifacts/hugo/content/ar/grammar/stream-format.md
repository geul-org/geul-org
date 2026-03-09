---
title: "تنسيق التدفق"
weight: 100
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "stream", "TID"]
summary: "تدفق GEUL هو سلسلة حزم تبدأ وتنتهي بـ Meta Node. يحدد نطاق TID، والمرجعية الأمامية، وقواعد ترتيب الحزم."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

تدفق GEUL هو **سلسلة حزم تبدأ وتنتهي بـ Meta Node**، وهو مستند GEUL مكتمل.

## الخصائص الأساسية

- **حدود صريحة:** STREAM_START / STREAM_END (Meta Node)
- **نطاق TID:** صالح فقط داخل التدفق
- **مرجعية أمامية:** يمكن الإشارة فقط إلى TID تم إعلانه مسبقاً
- **Big Endian:** Network Byte Order

## بنية التدفق

```
┌─────────────────────────────────────┐
│          STREAM_START               │  ← إلزامي (Meta Node)
│          (TID width declaration)    │     0xC000 (16-bit TID)
├─────────────────────────────────────┤
│          Metadata (optional)        │
│          - VERSION    (0xC014)      │
│          - CREATED_AT (0xC008)      │
│          - CREATOR    (0xC010)      │
├─────────────────────────────────────┤
│          Body packets               │
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
│          STREAM_END                 │  ← اختياري (موصى به)
└─────────────────────────────────────┘
```

أدنى تدفق هو `STREAM_START` (كلمة واحدة) + `STREAM_END` (كلمة واحدة) = كلمتان (4 بايت)، والتدفق الفارغ صالح.

## مبادئ تخصيص TID

| القاعدة | الوصف |
|---------|-------|
| **الإلزامية** | كل Edge/Node في التدفق يملك TID |
| **الفرادة** | TID فريد داخل التدفق |
| **النطاق** | TID صالح فقط ضمن التدفق المعني |
| **الأمامية** | عند الإشارة يجب أن يكون TID معلناً مسبقاً |

### موقع TID

| النوع | موقع TID | موقع المرجع |
|-------|----------|-------------|
| **Meta Node** | لا يوجد | لا يوجد |
| **Entity Node** | الكلمة الأخيرة | لا يوجد |
| **Quantity Node** | الكلمة الأخيرة | لا يوجد |
| **Tiny Verb Edge** | لا يوجد | لا يوجد (مضمّن) |
| **Verb Edge** | منطقة الرأس | بعد الحمولة |
| **Triple Edge** | منطقة الرأس | بعد الحمولة |
| **Event6 Edge** | منطقة الرأس | بعد الحمولة |
| **Clause Edge** | منطقة الرأس | بعد الحمولة |
| **Context Edge** | منطقة الرأس | بعد الحمولة |
| **Group Edge** | الكلمة الثانية | الكلمة الثالثة فما بعد |

**Node** يعرّف نفسه فقط لذا TID في النهاية، **Edge** يشير إلى TID أخرى لذا TID يسبق المراجع.

### TID محجوزة

| TID | الاستخدام |
|-----|-----------|
| 0x0000 | **علامة إنهاء** ([حافة المجموعة](../group-edge/) إلخ) |
| 0xFFFF | محجوز (أساس 16 بت) |

## قواعد ترتيب الحزم

### ترتيب الإعلان-المرجع

```
✅ صحيح:
  [Entity: أحمد, TID=0x0001]
  [Entity: فاطمة, TID=0x0002]
  [Verb Edge: يلتقي, Subject=0x0001, Object=0x0002]

❌ خاطئ:
  [Verb Edge: يلتقي, Subject=0x0001, Object=0x0002]  ← 0x0001 غير معلن
  [Entity: أحمد, TID=0x0001]
  [Entity: فاطمة, TID=0x0002]
```

### الترتيب الموصى

```
1. STREAM_START
2. Metadata (VERSION, CREATED_AT, CREATOR)
3. Entity Nodes (إعلان الكيانات)
4. Quantity Nodes (كميات/قيم حرفية)
5. Group Edges (تعريف المجموعات)
6. Tiny Verb Edges (أوصاف مضمّنة)
7. Verb Edges (أوصاف عامة)
8. Triple Edges (خصائص/علاقات)
9. Event6 Edges (أحداث)
10. Clause Edges (علاقات خطابية)
11. Context Edges (سياقات)
12. Faber Edges (أكواد/AST)
13. STREAM_END
```

هذا ترتيب موصى فقط، يمكن الترتيب بحرية مع الالتزام بقاعدة الإعلان-المرجع.

### منع المراجع الدائرية

لا يمكن وجود مراجع دائرية من نوع A → B → A. عند الحاجة لعلاقة دائرية تُعبَّر بـ Edge منفصلة.

```
✅ ممكن:
  [Entity A, TID=0x0001]
  [Entity B, TID=0x0002]
  [Edge: A→B, TID=0x0003]
  [Edge: B→A, TID=0x0004]
```

## مثال تدفق

### "التقى أحمد بفاطمة"

```
1. STREAM_START (TID 16-bit)
   0xC0 0x00

2. Entity: أحمد (TID=0x0001)
   [Entity packet...] 0x00 0x01

3. Entity: فاطمة (TID=0x0002)
   [Entity packet...] 0x00 0x02

4. Verb Edge: meet (TID=0x0100)
   Subject: 0x0001
   Object: 0x0002

5. STREAM_END
   0xC0 0x04
```

### "التقى أحمد وفاطمة في المدرسة"

```
1. STREAM_START
   0xC0 0x00

2. Entity: أحمد (TID=0x0001)
3. Entity: فاطمة (TID=0x0002)
4. Entity: المدرسة (TID=0x0003)

5. Group Edge: AND (TID=0x0010)
   Members: 0x0001, 0x0002, 0x0000 (terminator)

6. Verb Edge: meet (TID=0x0100)
   Subject: 0x0010 (group)
   Location: 0x0003

7. STREAM_END
   0xC0 0x04
```

## التحقق من التدفق

### التحقق الإلزامي

| العنصر | التحقق |
|--------|--------|
| البداية | هل يبدأ بـ STREAM_START؟ |
| فرادة TID | هل لا توجد TID مكررة؟ |
| صلاحية المرجع | هل كل TID مُشار إليها تم إعلانها؟ |
| الأمامية | هل TID مُعلنة قبل وقت الإشارة؟ |

### كود التحقق

```python
def validate_stream(packets: list) -> dict:
    """Stream validation"""
    errors = []
    declared_tids = set()

    # Start validation
    if not packets or packets[0].type != "STREAM_START":
        errors.append("Stream does not start with STREAM_START")

    for packet in packets:
        # TID uniqueness validation
        if packet.tid is not None:
            if packet.tid in declared_tids:
                errors.append(f"Duplicate TID: {packet.tid}")
            declared_tids.add(packet.tid)

        # Reference validity validation
        for ref_tid in packet.references:
            if ref_tid not in declared_tids:
                errors.append(f"Undeclared TID reference: {ref_tid}")

    return {
        "valid": len(errors) == 0,
        "errors": errors,
        "tid_count": len(declared_tids)
    }
```

## التدفقات المتعددة

كل تدفق مستقل، ونطاق TID منفصل لكل تدفق. TID=0x0001 في التدفق A يختلف عن TID=0x0001 في التدفق B.

المراجع بين التدفقات (Cross-reference) غير مدعومة حالياً، ويمكن توسيعها مستقبلاً عبر إدخال معرّف تدفق وآلية Import/Export.
