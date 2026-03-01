---
title: "פורמט הזרימה"
weight: 100
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "stream", "TID"]
summary: "זרימת GEUL היא רצף מנות הפותח ונסגר ב-Meta Node. מגדיר תחום TID, הפניה קדימה וכללי סדר מנות."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

זרימת GEUL היא **רצף מנות הפותח ונסגר ב-Meta Node**, והוא מסמך GEUL שלם.

## מאפיינים מרכזיים

- **גבולות מפורשים:** STREAM_START / STREAM_END (Meta Node)
- **תחום TID:** תקף רק בתוך הזרימה
- **הפניה קדימה:** ניתן להפנות רק ל-TID שהוצהר קודם
- **Big Endian:** Network Byte Order

## מבנה הזרימה

```
┌─────────────────────────────────────┐
│          STREAM_START               │  ← חובה (Meta Node)
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
│          STREAM_END                 │  ← אופציונלי (מומלץ)
└─────────────────────────────────────┘
```

זרימה מינימלית היא `STREAM_START` (מילה אחת) + `STREAM_END` (מילה אחת) = 2 מילים (4 בתים), וזרימה ריקה תקפה.

## עקרונות הקצאת TID

| כלל | תיאור |
|-----|-------|
| **חובה** | כל Edge/Node בזרימה מחזיק TID |
| **ייחוד** | TID ייחודי בתוך הזרימה |
| **תחום** | TID תקף רק בזרימה הרלוונטית |
| **קדימה** | בעת הפניה, TID חייב להיות מוצהר כבר |

### מיקום TID

| סוג | מיקום TID | מיקום הפניה |
|-----|----------|-------------|
| **Meta Node** | אין | אין |
| **Entity Node** | המילה האחרונה | אין |
| **Quantity Node** | המילה האחרונה | אין |
| **Tiny Verb Edge** | אין | אין (מוטמע) |
| **Verb Edge** | אזור הכותרת | לאחר המטען |
| **Triple Edge** | אזור הכותרת | לאחר המטען |
| **Event6 Edge** | אזור הכותרת | לאחר המטען |
| **Clause Edge** | אזור הכותרת | לאחר המטען |
| **Context Edge** | אזור הכותרת | לאחר המטען |
| **Group Edge** | המילה השנייה | המילה השלישית ואילך |

**Node** מגדיר רק את עצמו ולכן TID בסוף, **Edge** מפנה ל-TID אחרים ולכן TID קודם להפניות.

### TID שמורים

| TID | שימוש |
|-----|-------|
| 0x0000 | **סמן סיום** ([קשת קבוצה](../group-edge/) וכו') |
| 0xFFFF | שמור (בסיס 16 סיביות) |

## כללי סדר מנות

### סדר הצהרה-הפניה

```
✅ נכון:
  [Entity: דוד, TID=0x0001]
  [Entity: שרה, TID=0x0002]
  [Verb Edge: לפגוש, Subject=0x0001, Object=0x0002]

❌ שגוי:
  [Verb Edge: לפגוש, Subject=0x0001, Object=0x0002]  ← 0x0001 לא הוצהר
  [Entity: דוד, TID=0x0001]
  [Entity: שרה, TID=0x0002]
```

### סדר מומלץ

```
1. STREAM_START
2. Metadata (VERSION, CREATED_AT, CREATOR)
3. Entity Nodes (הצהרת ישויות)
4. Quantity Nodes (כמויות/ליטרלים)
5. Group Edges (הגדרת קבוצות)
6. Tiny Verb Edges (תיאורים מוטמעים)
7. Verb Edges (תיאורים כלליים)
8. Triple Edges (מאפיינים/יחסים)
9. Event6 Edges (אירועים)
10. Clause Edges (יחסי שיח)
11. Context Edges (הקשרים)
12. Faber Edges (קוד/AST)
13. STREAM_END
```

זהו סדר מומלץ בלבד, ניתן לסדר בחופשיות בתנאי שמירה על כלל ההצהרה-הפניה.

### איסור הפניות מעגליות

הפניות מעגליות מסוג A → B → A אינן אפשריות. כאשר נדרש יחס מעגלי, מבוטא ב-Edge נפרד.

```
✅ אפשרי:
  [Entity A, TID=0x0001]
  [Entity B, TID=0x0002]
  [Edge: A→B, TID=0x0003]
  [Edge: B→A, TID=0x0004]
```

## דוגמת זרימה

### "דוד פגש את שרה"

```
1. STREAM_START (TID 16-bit)
   0xC0 0x00

2. Entity: דוד (TID=0x0001)
   [Entity packet...] 0x00 0x01

3. Entity: שרה (TID=0x0002)
   [Entity packet...] 0x00 0x02

4. Verb Edge: meet (TID=0x0100)
   Subject: 0x0001
   Object: 0x0002

5. STREAM_END
   0xC0 0x04
```

### "דוד ושרה נפגשו בבית הספר"

```
1. STREAM_START
   0xC0 0x00

2. Entity: דוד (TID=0x0001)
3. Entity: שרה (TID=0x0002)
4. Entity: בית ספר (TID=0x0003)

5. Group Edge: AND (TID=0x0010)
   Members: 0x0001, 0x0002, 0x0000 (terminator)

6. Verb Edge: meet (TID=0x0100)
   Subject: 0x0010 (group)
   Location: 0x0003

7. STREAM_END
   0xC0 0x04
```

## אימות זרימה

### אימות חובה

| פריט | בדיקה |
|------|-------|
| התחלה | האם מתחיל ב-STREAM_START? |
| ייחוד TID | האם אין TID כפולים? |
| תקפות הפניה | האם כל TID שהופנה אליו הוצהר? |
| קדימה | האם TID הוצהר לפני זמן ההפניה? |

### קוד אימות

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

## זרימות מרובות

כל זרימה עצמאית, ותחום TID מופרד לכל זרימה. TID=0x0001 בזרימה A שונה מ-TID=0x0001 בזרימה B.

הפניות בין זרימות (Cross-reference) אינן נתמכות כרגע, וניתן להרחיב בעתיד באמצעות הוספת מזהה זרימה ומנגנון Import/Export.
