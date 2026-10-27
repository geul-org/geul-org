---
title: "Meta — מבנה"
weight: 10
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "מחלקת המבנה של Meta (שלושה ביטים עליונים `000`, `0x00`~`0x0F`) קובעת את גבולות המסמך ואורכו. פותחים ב-DOC-1WORD/2WORD/4WORD, מסיימים את ה-HEAD ב-BODY וסוגרים ב-END."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

מחלקת המבנה של Meta (שלושה ביטים עליונים `000`, Codec `0x00`~`0x0F`) קובעת את גבולות המסמך ואורכו. יחידת הנתונים של GEUL היא מסמך אחד.

```
DOC-*                  ← תחילת HEAD
  Meta של הצהרה·מוצא·שושלת·אימות·מדיניות·IMPORT
  SOURCE של המסמך כולו וה-QUALIFIER שלו
BODY                   ← תחילת BODY
  Reference, Value, Edge
END                    ← סגירת המסמך
```

- כל מסמך נפתח ב-`DOC-1WORD/2WORD/4WORD` שמציין את האורך הכולל. המפענח יכול לדלג על המסמך כולו בבת אחת לפי האורך הזה.
- `BODY` ו-`END` הן רשומות של WORD אחד בלי Payload. `END` הוא חובה.
- מסמכים אינם מקוננים. מסמך אחר מוצבע באמצעות IMPORT.
- אם ה-HEAD (Meta, ה-SOURCE של המסמך כולו וה-QUALIFIER שלו) ריק, מוותרים על `BODY`. `BODY` מופיע פעם אחת בלבד בכל מסמך.

מבנה המסמך המלא נמצא ב[מסמך](/he/grammar/document/).
