---
title: "DOC"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "DOC-1WORD·DOC-2WORD·DOC-4WORD הן Meta של מבנה שפותחות מסמך ומציינות את מספר ה-WORD הכולל שלו."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

אלה הרשומות שפותחות מסמך. ב-Payload מצוין מספר ה-WORD של המסמך כולו. הדף הזה עוסק יחד ב-`DOC-1WORD` (`0x00`), ב-`DOC-2WORD` (`0x01`) וב-`DOC-4WORD` (`0x02`).

## פריסה

```
TAG WORD          0001 1LLL L000 0000      Codec 0x00
[Length extension TAG]
Payload           מספר ה-WORD הכולל. ה-Codec קובע את הרוחב: DOC-1WORD 1, DOC-2WORD 2, DOC-4WORD 4
```

- Codec: Meta `0x00`~`0x02`, מחלקת מבנה (`000`)
- Payload: ערך גולמי (מספר ה-WORD של המסמך כולו, unsigned)
- מספר: אחד לכל מסמך, בהתחלה

## פירוש ותקינות

- האורך הוא מתחילת הרשומה הפותחת ועד סוף ה-[END](/he/grammar/meta/structure/end/).
- משתמשים ברוחב הצר ביותר שהערך נכנס בו. קידוד ברוחב רחב יותר נדחה כקידוד לא קנוני.
- האורך חייב להיות שווה לכל הקלט. מסמך אחד הוא קלט אחד.
- המפענח יכול לדלג על המסמך כולו לפי האורך הזה. אין Codec שפותח בלי לדעת את האורך.
- בחישוב hash התוכן כותבים מחדש עם האורך בלי Meta של מחלקת האימות ועם הרוחב המתאים לו ([hash תוכן](/he/grammar/document/#hash-תוכן)).

## דוגמה

- `0x1880 0x0017`: DOC-1WORD, 23 WORD בסך הכול
