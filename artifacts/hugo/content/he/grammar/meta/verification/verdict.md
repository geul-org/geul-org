---
title: "VERDICT"
weight: 69
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "VERDICT היא Meta של אימות שרושמת ב-WORD אחד את תוצאת ההכרעה של המסמך כולו (Pass, Review, Fail)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

רושמת את תוצאת ההכרעה של המסמך כולו. הכרעה ברמת צומת או רשומה היא תפקידו של `VERDICT` ב-[TOULMIN](/he/grammar/edge/toulmin/) (Edge `0x78`).

## פריסה

```
TAG WORD          0001 1LLL L100 0100      Codec 0x44
[Length extension TAG]
הכרעה             WORD אחד (0 Pass, 1 Review, 2 Fail)
```

- Codec: Meta `0x44`, מחלקת אימות (`100`)
- Payload: ערך גולמי (הכרעה של WORD אחד)
- מספר: לכל היותר אחד

## פירוש ותקינות

- היא מחלקת אימות ולכן מוצאת מ-hash התוכן.
- הכרעה על מסמך אחר מוצבת ב-BODY של מסמך שונה ממסמך היעד.

## שאלות פתוחות

- האם לרשום יחד גם את הגורם המכריע ואת הבסיס.
