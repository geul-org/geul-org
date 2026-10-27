---
title: "PRIVACY"
weight: 83
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "PRIVACY היא Meta של מדיניות שרושמת ב-WORD אחד את דרגת המידע האישי של המסמך."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

רושמת את דרגת המידע האישי של המסמך.

## פריסה

```
TAG WORD          0001 1LLL L101 0010      Codec 0x52
[Length extension TAG]
דרגה              WORD אחד
```

- Codec: Meta `0x52`, מחלקת מדיניות (`101`)
- Payload: ערך גולמי (דרגה של WORD אחד)
- מספר: לכל היותר אחד

## פירוש ותקינות

- אינה משנה פירוש. רק קובעת איך מטפלים.

## שאלות פתוחות

- טבלת קודים של הדרגות (התאמה לסיווג בחוק הגנת המידע האישי).
