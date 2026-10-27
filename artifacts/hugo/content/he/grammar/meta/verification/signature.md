---
title: "SIGNATURE"
weight: 66
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "SIGNATURE היא Meta של אימות שרושמת חתימה על hash התוכן של המסמך: ID של אלגוריתם, חותם וחתימה."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

חתימה על hash התוכן של המסמך (git signed commit·tag).

## פריסה

```
TAG WORD          0001 1LLL L100 0001      Codec 0x41
[Length extension TAG]
ID של אלגוריתם    WORD אחד (0x0001 = Ed25519)
חותם              רשומת ISSUER-POINTER(Issuer) Reference
חתימה             כל השאר. הרוחב נקבע לפי האלגוריתם (Ed25519 32 WORD)
```

- Codec: Meta `0x41`, מחלקת אימות (`100`)
- Payload: ID של אלגוריתם (ערך גולמי של WORD אחד) + חותם (Reference מוטמע) + חתימה (ערך גולמי, השאר)
- מספר: אפשר כמה

## פירוש ותקינות

- היעד לחתימה הוא hash התוכן. לא חותמים על ה-BODY בלבד ([חתימה](/he/grammar/issuer/#חתימה)).
- היא מחלקת אימות ולכן מוצאת מ-hash התוכן. הוספת חתימה אינה משנה את ה-hash.
- מאמתים לא לפי "אם יש חתימה בודקים" אלא לפי "חייבת להיות חתימה של מפתח שנקבע".
- את מסמך רשימת הגרסאות חותם מקום הפרסום.
- החותם הוא [ISSUER-POINTER](/he/grammar/reference/issuer-pointer/) (Issuer) שמצביע על ה-Issuer עצמו. מכיוון שזו רשומת Reference שנגמרת ב-Length של עצמה, הפריסה נקבעת באופן יחיד גם כשרוחב החתימה שונה בין אלגוריתמים ([DECLARE](/he/grammar/edge/declare/), שאר הערך הגולמי).
- אם מספר ה-WORD של החתימה שונה מהרוחב שהאלגוריתם קובע, זה invalid.

## שאלות פתוחות

- האם לחתום יחד גם על זמן החתימה.
