---
title: "USAGE"
weight: 86
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "USAGE היא Meta של מדיניות שרושמת מגבלות שימוש כמו איסור אימון ואיסור שימוש מסחרי."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

רושמת מגבלות שימוש (למשל איסור אימון, איסור שימוש מסחרי).

## פריסה

```
TAG WORD          0001 1LLL L101 0101      Codec 0x55
[Length extension TAG]
Payload           טקסט או Reference שמבטא את מגבלת השימוש
```

- Codec: Meta `0x55`, מחלקת מדיניות (`101`)
- Payload: Value או Reference מוטמע
- מספר: אפשר כמה

## שאלות פתוחות

- טבלת קודים של סוגי המגבלות.
