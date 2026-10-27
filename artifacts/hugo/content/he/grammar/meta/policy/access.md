---
title: "ACCESS"
weight: 82
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "ACCESS היא Meta של מדיניות שרושמת את היקף החשיפה של המסמך (ציבורי, פנימי, חסוי) כדרגה של WORD אחד."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

רושמת את היקף החשיפה של המסמך.

## פריסה

```
TAG WORD          0001 1LLL L101 0001      Codec 0x51
[Length extension TAG]
דרגה              WORD אחד (0 ציבורי, 1 פנימי, 2 חסוי, השאר שמור)
```

- Codec: Meta `0x51`, מחלקת מדיניות (`101`)
- Payload: ערך גולמי (דרגה של WORD אחד)
- מספר: לכל היותר אחד

## פירוש ותקינות

- מסמך חסוי אינו מתפרסם ([Issuer](/he/grammar/issuer/)).
- אינה משנה פירוש. רק קובעת איך מטפלים.

## שאלות פתוחות

- טבלת קודים של הדרגות.
