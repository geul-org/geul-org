---
title: "STML — SSOT Template Markup Language"
weight: 1
date: 2026-03-08T12:00:00+09:00
lastmod: 2026-03-08T12:00:00+09:00
tags: ["STML", "DSL", "SSOT", "frontend", "React", "OpenAPI"]
summary: "שפת הצהרת UI בלתי תלויה בפריימוורק. מגדירה מה עמודים מציגים ועושים עם תכונות HTML5 data-*, מאמתת סמלית מול OpenAPI ומייצרת קוד React."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**SSOT Template Markup Language** — הצהרת UI בלתי תלויה בפריימוורק.

קוד פרונטאנד מערבב שני דברים: **ההחלטות שלך** ו**חיווט הפריימוורק**. איזה API לקרוא, אילו שדות להציג, באיזה סדר, באילו תנאים — ההחלטות האלה קבורות ב-React hooks או Vue composables. כשמחליפים פריימוורק או מבצעים ריפקטורינג, ההחלטות מתפרשות מחדש או אובדות.

STML מפריד ביניהם. ההחלטות נשארות ב-HTML סטנדרטי עם תכונות `data-*`. חיווט הפריימוורק נוצר או מואצל.

<a href="https://github.com/geul-org/stml" target="_blank" rel="noopener">מאגר GitHub</a>

## מה נשמר

הכל ב-HTML של STML הוא החלטת משתמש:

- **אילו נקודות קצה API** לקרוא (`data-fetch`, `data-action`)
- **אילו שדות** להציג או לאסוף (`data-bind`, `data-field`)
- **באיזה סדר** מופיעים אלמנטים (מבנה DOM)
- **איך זה נראה** (מחלקות Tailwind, תגיות HTML)
- **איזה טקסט** המשתמשים רואים (כותרות, placeholders, תוויות כפתורים)
- **אילו תנאים** שולטים בנראות (`data-state`)
- **אילו רכיבים** מטפלים ב-UX מיוחד (`data-component`)
- **התנהגות רשימות** — עימוד, מיון, סינון

לא React. לא Vue. זה מה שהעמוד שלך עושה, מוצהר ב-HTML5 סטנדרטי.

## אימות

המאמת המובנה בודק STML מול OpenAPI לפני יצירת קוד:

- האם operationId קיים? האם שיטת HTTP נכונה?
- האם שדות הבקשה, התגובה והפרמטרים תואמים לסכמה?
- האם עמודות מיון/סינון/הכללה בתוך הרשימות המותרות?
- האם הרכיבים המוזכרים קיימים?

לוכד אי-התאמות פרונטאנד-API בזמן CI, לא בזמן ריצה.

```bash
stml validate specs/my-project    # 12 בדיקות סמליות מול OpenAPI
```

## תכונות data-*

| תכונה | מה היא מצהירה |
|---|---|
| `data-fetch` | טעינת נתונים מנקודת קצה GET |
| `data-action` | שליחת נתונים לנקודת קצה POST/PUT/DELETE |
| `data-field` | איסוף שדה גוף הבקשה |
| `data-bind` | הצגת שדה תגובה |
| `data-param-*` | הפעולה דורשת פרמטר נתיב/שאילתה |
| `data-each` | חזרה על שדה מערך |
| `data-state` | הצגה מותנית |
| `data-component` | האצלה לרכיב מותאם אישית |
| `data-paginate` | רשימה מעומדת |
| `data-sort` | רשימה הניתנת למיון (עמודה וכיוון ברירת מחדל) |
| `data-filter` | רשימה הניתנת לסינון (אילו עמודות) |
| `data-include` | הכללת משאבים קשורים |

## רישיון

MIT — <a href="https://github.com/geul-org/stml" target="_blank" rel="noopener">GitHub</a>
