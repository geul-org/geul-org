---
title: "מאגרים"
date: 2026-02-28T12:00:00+09:00
lastmod: 2026-10-29T12:00:00+09:00
summary: "המאגרים הציבוריים של GEUL ב-GitHub: ספריית Go וכלי geul CLI, טעינה והמרה של ויקינתונים, מנוע החיפוש SILK, ספרי קודים מלפני v1 ואתר זה."
image: "/images/og-default.webp"
---

המאגרים הציבוריים של GEUL נמצאים בארגון [geul-org](https://github.com/geul-org) ב-GitHub. הדקדוק המחייב הוא [דקדוק GEUL](/he/grammar/) באתר זה.

מסמך GEUL הוא רצף של WORD בני 16 ביט. יחידת הנתונים היא הרשומה, שמתחילה ב-TAG WORD אחד, והרשומות נתונות במסמך. מסמכים מפורסמים על ידי Issuer, וכל גרסה מקובעת בגיבוב תוכן. המאגרים שלהלן הם כלים לכתיבה, קריאה, המרה וחיפוש של מסמכים אלה.

---

## ספרייה

### gogeul

ספריית Go של GEUL וכלי שורת הפקודה `geul`.

כותבת, קוראת, בודקת ומפרסמת מסמכי GEUL (`.geul`). החבילות שלה מספקות בדיקת פורמט, פענוח רשומות באמצעות מסמכי מפרט Codec, הבדלים בין גרסאות, פתרון תלויות IMPORT ואת Codec TOULMIN. ה-CLI `geul` מכסה עריכה (`new`, `add`), פרסום (`publish`), עיון (`ls`, `log`, `show`, `diff`, `check`), מציג בדפדפן (`serve`, `build`) וארכיוני pack (`pack build`, `pack unpack`). ארכיוני pack יכולים לשמור רשומות דחוסות ב-zstd.

| | |
|---|---|
| GitHub | [geul-org/gogeul](https://github.com/geul-org/gogeul) |
| שפה | Go |
| רישיון | CC0 |

---

## ויקינתונים

### wikigeul

המרת ויקינתונים ← GEUL (שם קודם gogeulwiki).

קורא dump של ויקינתונים ש-wikipg טען ל-PostgreSQL ומפרסם מסמך GEUL אחד לכל פריט או מאפיין, עם תוויות, תיאורים, כינויים, היגדים עם המגדירים והמקורות שלהם וקישורי אתרים בכל השפות. כל המסמכים מתפרסמים תחת ה-Issuer `wikidata.geul.org` (`0x00010000`).

| | |
|---|---|
| GitHub | [geul-org/wikigeul](https://github.com/geul-org/wikigeul) |
| שפה | Go |
| רישיון | CC0 |

### wikipg

טעינה ללא אובדן של קובצי dump בפורמט JSON של ויקינתונים ל-PostgreSQL.

שומר ישויות, תוויות, תיאורים, כינויים, היגדים, מגדירים, מקורות, קישורי אתרים ו-Lexeme בסדר ה-dump, ומשמר כל שורה של ה-dump כלשונה. גם ה-dump עצמו (קובץ, URL, גודל, סכומי ביקורת, commit של הטוען) נרשם. wikipg אינו תלוי ב-GEUL.

| | |
|---|---|
| GitHub | [geul-org/wikipg](https://github.com/geul-org/wikipg) |
| שפה | Go |
| רישיון | CC0 |

---

## חיפוש

### silk

[SILK](/he/projects/silk/) — מנוע אינדוקס וחיפוש שנבנה עבור GEUL.

בונה אינדקסים מחולקים וממוינים של הרשומות בארכיון pack של GEUL, ועונה על שאילתות כמו "אילו מסמכים קובעים שעיסוקו (P106) של מישהו הוא פיזיקאי (Q169470)?" בלי לפענח את כל המסמכים. הוא מפריד רשומות ושדות על סמך TAG WORD בלבד, בלי ספר קודים. הוא בשלבי פיתוח מוקדמים ומאמת את אלגוריתמי החיפוש שלו, והפורמטים עשויים להשתנות לפני הגרסה הראשונה.

| | |
|---|---|
| GitHub | [geul-org/silk](https://github.com/geul-org/silk) |
| שפה | Go |
| רישיון | CC0 |

---

## ספרי קודים (לפני v1)

שני המאגרים שלהלן תוכננו לפני דקדוק v1 הנוכחי. חלקים מהם אינם תואמים לו.

### sidx

מחקר על הקצאת SIDX (Semantic-aligned Index).

חומרי מחקר להקצאת SIDX, כתובת סמנטית שנותנת מספרים קרובים לישויות קרובות במשמעות, על סמך סטטיסטיקות שימוש בוויקינתונים. מכיל את סכמת המאפיינים הישנה של Entity בת 48 ביט, סקריפטים של מקודד וספרי קודים; עדיין לא הופקה הקצאת SIDX. ההגדרה המחייבת של SIDX היא [GEUL-SIDX](/he/grammar/reference/geul-sidx/) בדקדוק.

| | |
|---|---|
| GitHub | [geul-org/sidx](https://github.com/geul-org/sidx) |
| שפה | Python |
| רישיון | CC0 |

### wordnet-verb

מהדורה זמנית של ספר קודים לפעלים בן 16 ביט המבוסס על WordNet 3.0.

נותן לכל אחד מ-13,767 ה-synset של פעלים ב-WordNet 3.0 קוד אחד בן 16 ביט, עם קודים קרובים לפעלים קרובים במשמעות. זו מהדורה זמנית שתוחלף בספר קודים שאינו משתמש ב-WordNet, ועדיין לא הוחלט כיצד יישאו הקודים ברשומות GEUL.

הוא מכיל חומר שנגזר מ-WordNet, ולכן **אינו תוצר CC0.** החלקים הנגזרים מ-WordNet כפופים ל-WordNet 3.0 License; רק החלקים של פרויקט GEUL עצמו, כמו הקודים והסיווג, הם CC0.

| | |
|---|---|
| GitHub | [geul-org/wordnet-verb](https://github.com/geul-org/wordnet-verb) |
| שפה | Python |
| רישיון | WordNet 3.0 License (חלקים נגזרים) · CC0 (חלקים עצמיים) |

---

## אתר

### geul-org

קוד המקור של אתר זה, geul.org.

אתר Hugo סטטי ב-12 שפות, המופץ באמצעות S3 + CloudFront.

| | |
|---|---|
| GitHub | [geul-org/geul-org](https://github.com/geul-org/geul-org) |
| שפה | Hugo |
| רישיון | CC0 |

---

## מאגרים קשורים

מאגרים מחוץ לארגון geul-org.

### toulmin

מנוע כללים המבוסס על מודל הטיעון של טולמין (TypeScript, Python, Go, C).

הכללים הם פונקציות, והחריגים הם יחסי התקפה בגרף. ה-Edge [TOULMIN](/he/grammar/edge/toulmin/) בדקדוק GEUL (קודים ישירים `0x60`–`0x7B`) כותב את גרפי השיפוט והביצוע האלה כמסמכי GEUL.

| | |
|---|---|
| GitHub | [park-jun-woo/toulmin](https://github.com/park-jun-woo/toulmin) |
| רישיון | MIT |
