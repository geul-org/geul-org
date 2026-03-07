---
title: "קשת הקשר"
weight: 60
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "context", "worldview", "modal-logic"]
summary: "קשת קלת משקל בת 3 מילים המבטאת 'באיזו השקפת עולם/הקשר טענה זו אמיתית'. מקודדת תנאי אמת ב-64 סוגים הכוללים מקורות, השקפות, בדיון ונקודת מבט."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Context Edge מבטאת **"באיזו השקפת עולם/הקשר טענה זו אמיתית"**.

מתאימה למושג עולמות אפשריים בלוגיקה מודאלית (Modal Logic), שבו לאותו נושא יכולות להיות עובדות שונות בהשקפות שונות.

```
Context "מציאות":        (כדור הארץ, גיל, 4.6 מיליארד שנים)
Context "כדור ארץ צעיר": (כדור הארץ, גיל, 6000 שנים)
Context "הארי פוטר":     (קסם, exists, true)
```

## מבנה המנה (3 מילים, 48 סיביות)

```
1st WORD (16 bits):
┌─────────────────────┬─────────────────┐
│       Prefix        │  Context Type   │
│       10bit         │     6bit        │
└─────────────────────┴─────────────────┘
 [1100 000 100]        [TTTTTT]

2nd WORD: Context TID (16 bits)
3rd WORD: Target TID (16 bits)
```

| שדה | סיביות | תיאור |
|-----|--------|-------|
| Prefix | 10 | `1100 000 100` |
| Context Type | 6 | 0=לא מוגדר, 1~62=סוג, 63=מורחב(שמור) |
| Context TID | 16 | מזהה ייחודי של Context זה |
| Target TID | 16 | TID של הטענה המוכוונת ([שלישייה](../triple-edge/)/[פועל](../verb-edge/)/[אירוע6](../event6-edge/)/[פסוקית](../clause-edge/) TID) |

## Context Type (6 סיביות = 64 סוגים)

### מקור (Source) — Code 1~20

| Code | סוג | תיאור | דוגמה |
|------|-----|-------|-------|
| 1 | SYSTEM | יצירה אוטומטית | סנכרון ויקינתונים |
| 2 | USER | הזנה ישירה | כתיבה ידנית |
| 3 | DOCUMENT | מסמך כללי | PDF, Word |
| 4 | NEWS | חדשות | רויטרס, AP |
| 5 | ACADEMIC | מאמר אקדמי | arXiv, Nature |
| 6 | GOVERNMENT | גוף ממשלתי/ציבורי | SEC, לשכת הסטטיסטיקה |
| 7 | WIKI | ויקיפדיה/ויקינתונים | Q42, P31 |
| 8 | API | API חיצוני | פיננסי, מזג אוויר |
| 9 | ORG | הכרזת ארגון | יחסי משקיעים |
| 10 | BOOK | ספר | מבוסס ISBN |
| 11 | INTERVIEW | ראיון/עדות | ציטוט ישיר |
| 12 | DATASET | מערך נתונים | Kaggle |
| 13 | SOCIAL | מדיה חברתית | Twitter |
| 14 | LEGAL | חוק/פסיקה | פסק דין |
| 15 | ARCHIVE | ארכיון | archive.org |
| 16 | MULTIMEDIA | וידאו/אודיו | YouTube |
| 17 | DATABASE | מסד נתונים | IMDB, Freebase |
| 18 | ENCYCLOPEDIA | אנציקלופדיה | בריטניקה |
| 19 | MANUAL | מדריך | תיעוד טכני |
| 20 | STANDARD | מסמך תקן | ISO, RFC |

### נגזר/הסקה (Derived) — Code 21~30

| Code | סוג | תיאור | דוגמה |
|------|-----|-------|-------|
| 21 | MODEL | יצירת מודל AI | GPT, Claude |
| 22 | INFERENCE | הסקה לוגית | מבוסס כללים |
| 23 | AGGREGATION | צבירה/שילוב | מיזוג מקורות מרובים |
| 24 | CALCULATION | תוצאת חישוב | יישום נוסחה |
| 25 | TRANSLATION | תרגום | מקור→תרגום |
| 26 | EXTRACTION | חילוץ | NER, RE |
| 27 | CORRECTION | תיקון | תיקון שגיאה |
| 28 | HEARSAY | שמועה | לא מאומת |
| 29 | ESTIMATION | הערכה | ערך משוער |
| 30 | PREDICTION | תחזית | חיזוי עתידי |

### השקפה/אמונה (Worldview) — Code 31~45

| Code | סוג | תיאור | דוגמה |
|------|-----|-------|-------|
| 31 | RELIGION | השקפה דתית | יהדות, נצרות |
| 32 | PHILOSOPHY | נקודת מבט פילוסופית | אקזיסטנציאליזם |
| 33 | SCIENCE | קונצנזוס מדעי | פיזיקה מודרנית |
| 34 | POLITICS | נקודת מבט פוליטית | שמרני, פרוגרסיבי |
| 35 | CULTURE | נקודת מבט תרבותית | מזרחי, מערבי |
| 36 | MYTHOLOGY | מערכת מיתוסים | מיתולוגיה יוונית |
| 37 | FOLKLORE | סיפורי עם | אגדות מקומיות |
| 38 | IDEOLOGY | מערכת אידיאולוגית | קפיטליזם |
| 39 | THEORY | תיאוריה | יחסות |
| 40 | HYPOTHESIS | השערה | טרם אימות |
| 41 | TRADITION | מסורת/מנהג | מסורת יהודית |
| 42 | CONSENSUS | קונצנזוס/דעת הרוב | דעה אקדמית |
| 43 | MAINSTREAM | דעת רוב | דעת הרבים |
| 44 | ALTERNATIVE | דעה חלופית | דעת מיעוט |
| 45 | FRINGE | שולי/סוטה | פסבדו |

### בדיון/יצירה (Fiction) — Code 46~55

| Code | סוג | תיאור | דוגמה |
|------|-----|-------|-------|
| 46 | NOVEL | עולם רומן | שר הטבעות |
| 47 | FILM | עולם סרט | MCU |
| 48 | GAME | עולם משחק | זלדה |
| 49 | COMICS | עולם קומיקס | יקום DC |
| 50 | ANIMATION | עולם אנימציה | ג'יבלי |
| 51 | DRAMA | עולם דרמה | משחקי הכס |
| 52 | THEATER | עולם תיאטרון | המלט |
| 53 | FANFIC | יצירה משנית | פאן פיקשן |
| 54 | LEGEND | אגדה | המלך ארתור |
| 55 | FAIRYTALE | אגדת ילדים | סינדרלה |

### נקודת מבט/מספר (Perspective) — Code 56~62

| Code | סוג | תיאור | דוגמה |
|------|-----|-------|-------|
| 56 | NARRATOR | נקודת מבט המספר | מספר כל-יודע |
| 57 | PROTAGONIST | נקודת מבט הגיבור | ראייה של הגיבור |
| 58 | ANTAGONIST | נקודת מבט היריב | ראייה של הנבל |
| 59 | AUTHOR | כוונת המחבר | פרשנות המחבר |
| 60 | EXPERT | דעת מומחה | דעת חוקר |
| 61 | LAYMAN | תפיסת ההדיוט | תפיסה עממית |
| 62 | SATIRICAL | סאטירה/אירוניה | ביטוי אירוני |

Code 0 הוא UNSPECIFIED (לא מוגדר), Code 63 הוא EXTENDED (מורחב, שמור).

## הרחבת מטא-נתונים

מידע נוסף על ה-Context עצמו (מקור, אמינות, שם השקפה) מבוטא דרך [קשת שלישייה](../triple-edge/).

```
(Context TID, P:source_entity, Reuters_Entity)    - גוף המקור
(Context TID, P:confidence, 0.95)                  - אמינות
(Context TID, P:universe_name, "הארי פוטר")         - שם העולם
(Context TID, P:perspective_holder, Villain_Entity) - בעל נקודת המבט
```

## דוגמאות

### מקור: "דיווח רויטרס"

```
Context Edge:
  1st: [1100 000 100] + [000100]  - NEWS (4)
  2nd: [0x0300]                   - Context TID
  3rd: [0x0001]                   - Target: Triple "Apple acquired Tesla"

Additional Triples:
  (0x0300, P:source_entity, Reuters)
  (0x0300, P:date, 2026-01-29)
```

### בדיון: "עולם הארי פוטר"

```
Context Edge:
  1st: [1100 000 100] + [101110]  - NOVEL (46)
  2nd: [0x0302]                   - Context TID
  3rd: [0x0003]                   - Target: Triple "Hogwarts is_a school"

Additional Triples:
  (0x0302, P:universe_name, "Harry Potter")
  (0x0302, P:author, J.K. Rowling)
```

### הסקת AI: "הסקה של Claude"

```
Context Edge:
  1st: [1100 000 100] + [010101]  - MODEL (21)
  2nd: [0x0304]                   - Context TID
  3rd: [0x0005]                   - Target: Triple "X causes Y"

Additional Triples:
  (0x0304, P:model, Claude_Entity)
  (0x0304, P:confidence, 0.75)
```

## נימוקי עיצוב

- **Context Edge כסוג עצמאי**: השקפת עולם היא שכבת מטא שונה מ-Triple/Clause. מתאימה ל-G (Graph) ב-RDF Quad.
- **6 סיביות Context Type**: סיווג מיידי ללא Triple נוסף. 62 סוגים מכסים את רוב המקרים.
- **מבנה קל של 3 מילים**: חיבור Context מתרחש בתדירות גבוהה, לכן הגודל המינימלי מבטיח יעילות אחסון.
