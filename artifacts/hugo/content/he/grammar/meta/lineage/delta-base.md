---
title: "DELTA-BASE"
weight: 59
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "DELTA-BASE היא Meta של שושלת שמסמנת שקובץ הגרסה הזה הוא diff ביחס לגרסת בסיס של אותו מסמך."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

סימון שקובץ הגרסה הזה אינו snapshot אלא **diff** ביחס לגרסת בסיס של אותו מסמך (delta של git packfile). הגרסה עצמה עדיין מוגדרת כ-snapshot. hash התוכן, רשימת הגרסאות והחתימה מבוססים כולם על ה-snapshot ששוחזר בהחלת ה-diff ([שמירת diff](/he/grammar/document/#שמירת-diff)).

## פריסה

```
TAG WORD          0001 1LLL L011 1010      Codec 0x3A
מזהה גרסה         2 WORD unsigned (גרסת הבסיס של אותו מסמך)
```

- Codec: Meta `0x3A`, מחלקת שושלת (`011`)
- Payload: מזהה גרסה של 2 WORD (ערך גולמי)
- מספר: לכל היותר אחד

## פירוש ותקינות

- משתמשים רק במסמך שיש לו [DOC-ID](/he/grammar/meta/declaration/doc-id/) (מסמך שמנהל גרסאות ברשימת גרסאות). ל-`versions.geul`, `documents.geul`, `issuers.geul` שאינם מנוהלי גרסאות ולמסמכים ללא שם אין diff.
- גרסת הבסיס היא גרסה שפורסמה של אותו `DOC-ID` והיא קודמת לגרסה הזו. `0` (אין גרסה) הוא invalid.
- hash התוכן של ה-snapshot ששוחזר חייב להיות שווה ל-hash של הגרסה הזו ברשימת הגרסאות ([PUBLICATION](/he/grammar/edge/publication/)). אם שונה, ה-diff הזה invalid. לכן אין רושמים ב-diff את ה-hash של התוצאה בנפרד.
- רק מסמך שכל הרשומות ב-BODY שלו הן Edge (רשומות שיש להן Edge Id) יכול להישמר כ-diff, כי יחידת ה-diff היא LOCAL ID (Edge Id).
- כללי שחזור ה-snapshot הם לפי [שמירת diff](/he/grammar/document/#שמירת-diff). מחיקה היא תפקידו של [DELTA-REMOVE](/he/grammar/meta/lineage/delta-remove/).
- אין סימון נפרד להוספה או לתיקון. אם ה-Edge Id ב-BODY של ה-diff קיים בבסיס, זה תיקון, ואם לא, זו הוספה. הוספה מקבלת מספר החל מ-[NEXT-LOCAL-ID](/he/grammar/meta/lineage/next-local-id/) של רשימת הגרסאות. שימוש חוזר ב-LOCAL ID שנמחק הוא invalid ([תיקון](/he/grammar/document/#תיקון)).

## דוגמה

diff ביחס לגרסת בסיס 3:

```
193A 0000 0003
```

- TAG `193A` (Meta `0x3A`, `LLLL=0010`, 3 WORD), מזהה גרסה `0000 0003`.

## שאלות פתוחות

1. מרווח ה-snapshot: כל כמה גרסאות מציבים snapshot מלא (אורך שרשרת ה-diff ועלות השחזור).
2. האם להגביל את גרסת הבסיס לגרסה הקודמת הישירה.
3. מיקום האחסון של קובץ ה-diff: האם במקום של קובץ הגרסה (`<version-id>.geul`), והקשר למאגר ה-hash של התוכן `h/` (`h/` נמצא לפי hash התוכן של ה-snapshot).
