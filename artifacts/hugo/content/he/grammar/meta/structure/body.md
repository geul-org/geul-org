---
title: "BODY"
weight: 15
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "BODY היא Meta של מבנה בת WORD אחד, שמסיימת את ה-HEAD של המסמך ומתחילה את ה-BODY."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

הרשומה שמסיימת את ה-HEAD ומתחילה את ה-BODY.

## פריסה

```
TAG WORD          0001 1LLL L000 1110      Codec 0x0E
[Length extension TAG]
```

- Codec: Meta `0x0E`, מחלקת מבנה (`000`)
- Payload: אין (WORD אחד)
- מספר: לכל היותר אחד לכל מסמך

## פירוש ותקינות

- אם ה-HEAD ריק, משמיטים. מסמך בלי `BODY` כולו BODY. אם יש ב-HEAD Meta או HEAD Edge (ה-[SOURCE](/he/grammar/edge/source/#מקור-המסמך-כולו) של המסמך כולו וה-QUALIFIER שלו), מציבים.
- אין Payload. סך הכול WORD אחד.

## דוגמה

- `0x180E`
