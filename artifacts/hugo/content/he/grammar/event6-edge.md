---
title: "קשת אירוע6"
weight: 50
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "event6", "5W1H"]
summary: "קשת אירוע באורך משתנה המבטאת את שש השאלות (מי, מה, למי, מתי, איפה, למה) בבת אחת. מממשת מבנה משתנה של 3~8 מילים באמצעות מסכת סיביות Presence."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Event6 Edge הוא סוג Edge המבטא את **שש השאלות** (Who, What, Whom, When, Where, Why) בבת אחת.

## רכיבי שש השאלות

| רכיב | אנגלית | סיבית | משמעות | יעד TID |
|------|--------|-------|--------|---------|
| מי | Agent | 0 | הפועל | [צומת ישות](../entity-node/) |
| מה | Action | 1 | הפעולה | [קשת פועל](../verb-edge/) |
| למי | Patient | 2 | המושפע | [צומת ישות](../entity-node/) |
| מתי | Time | 3 | הזמן | Quantity/Entity |
| איפה | Location | 4 | המקום | [צומת ישות](../entity-node/) |
| למה | Reason | 5 | הסיבה/המטרה | [קשת פסוקית](../clause-edge/)/Entity |

## מבנה המנה

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

### מסכת סיביות Presence (6 סיביות)

| סיבית | רכיב | אם קיים |
|-------|------|---------|
| 0 | Who | TID נכלל |
| 1 | What | TID נכלל |
| 2 | Whom | TID נכלל |
| 3 | When | TID נכלל |
| 4 | Where | TID נכלל |
| 5 | Why | TID נכלל |

סך מילים = 2 (כותרת + Edge TID) + popcount(Presence). טווח 3~8 מילים (48~128 סיביות).

## מבנה לפי מצב

### מצב מינימלי (3 מילים)

```
Example: "ירד גשם" (What only)

1st: [Prefix] + [000010]      - What only
2nd: [Edge TID]
3rd: [What TID]               - "rain" Verb Edge
```

### מצב ליבה (5 מילים)

Who + What + Whom. ההרכב השכיח ביותר.

```
Example: "דוד הכה את יוסי"

1st: [Prefix] + [000111]      - Who, What, Whom
2nd: [Edge TID]
3rd: [Who TID]                - דוד
4th: [What TID]               - "hit" Verb Edge
5th: [Whom TID]               - יוסי
```

### מצב תקני (6 מילים)

```
Example: "דוד פגש את שרה אתמול"

1st: [Prefix] + [001111]      - Who, What, Whom, When
2nd: [Edge TID]
3rd: [Who TID]                - דוד
4th: [What TID]               - "meet" Verb Edge
5th: [Whom TID]               - שרה
6th: [When TID]               - אתמול
```

### מצב מלא (8 מילים)

```
Example: "דוד נתן לשרה מתנה בבית הספר אתמול מאהבה"

1st: [Prefix] + [111111]      - all
2nd: [Edge TID]
3rd: [Who TID]                - דוד
4th: [What TID]               - "give" Verb Edge
5th: [Whom TID]               - שרה
6th: [When TID]               - אתמול
7th: [Where TID]              - בית ספר
8th: [Why TID]                - אהבה (סיבה)
```

## פירוט רכיבים

### What (פעולה)

What מפנה ל-TID של [קשת פועל](../verb-edge/). קשת הפועל הרלוונטית מכילה מידע על מגדירים כגון זמן והיבט.

### Why (סיבה)

סיבה פשוטה מבוטאת ב-Entity TID ("אהבה"), סיבה מורכבת ב-[קשת פסוקית](../clause-edge/) TID ("כי ירד גשם").

## השוואת Event6 מול Verb Edge

| | Verb Edge | Event6 Edge |
|--|-----------|-------------|
| **מיקוד** | תיאור/פעולה | אירוע שלם |
| **משתתפים** | מבנה Participant | TID שש השאלות |
| **זמן-מקום** | ביטוי נפרד | When/Where מובנים |
| **סיבה** | Clause נפרדת | Why מובנה |
| **מילים** | 2~5 | 3~8 |
| **שימוש** | ביטוי תיאורי | אחסון אירועים |

**מדריך בחירה:** Verb Edge לניתוח תיאורים/משפטים, Event6 Edge לאחסון אירועים/רשומות, [קשת שלישייה](../triple-edge/) לעובדות פשוטות.

## דוגמאות

### "Apple רכשה את Tesla"

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

### "בן-גוריון הכריז על העצמאות בתל אביב ב-1948"

```
Who:   בן-גוריון       → Entity TID 0x0010
What:  declare (הכריז)  → Verb Edge TID 0x0101
When:  1948             → Entity TID 0x0011
Where: תל אביב          → Entity TID 0x0012

Event6 Edge:
  1st: [1100 000 011] + [011011]  - Who,What,When,Where
  2nd: [TID: 0x0202]
  3rd: [TID: 0x0010]              - בן-גוריון
  4th: [TID: 0x0101]              - declare
  5th: [TID: 0x0011]              - 1948
  6th: [TID: 0x0012]              - תל אביב

Total: 6 words
```

## פיענוח

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
