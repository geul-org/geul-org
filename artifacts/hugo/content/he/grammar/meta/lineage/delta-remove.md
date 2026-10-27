---
title: "DELTA-REMOVE"
weight: 60
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "DELTA-REMOVE היא Meta של שושלת שרושמת ב-diff את רשימת ה-LOCAL ID (Edge Id) להסרה מה-BODY של ה-snapshot של הבסיס."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ב-diff ([DELTA-BASE](/he/grammar/meta/lineage/delta-base/)), רושמת את ה-LOCAL ID (Edge Id) של הרשומות להסרה מה-BODY של ה-snapshot של הבסיס ("מחיקת סעיף X").

## פריסה

```
TAG WORD          0001 1LLL L011 1011      Codec 0x3B
[Length extension TAG]
LOCAL ID להסרה    רשומת LOCAL Reference × 1 ומעלה
```

- Codec: Meta `0x3B`, מחלקת שושלת (`011`)
- Payload: רשומת [LOCAL](/he/grammar/reference/local/) Reference אחת או יותר
- מספר: לכל היותר אחד

## פירוש ותקינות

- מציבים רק במסמך שיש בו `DELTA-BASE`.
- כל LOCAL ID חייב להיות Edge Id שקיים ב-BODY של ה-snapshot של הבסיס. אם אין, זה invalid. אותו ID פעמיים הוא invalid.
- אם אותו Edge Id מופיע שוב ב-BODY של אותו diff, זה invalid (אי אפשר למחוק ולתקן יחד).
- LOCAL ID שנמחק לא מוקצה בגרסאות הבאות ליעד אחר ([תיקון](/he/grammar/document/#תיקון)).
- היעדר רשומה ב-BODY של ה-diff פירושו "לא השתנה". לכן מחיקה מבוטאת רק ב-Meta הזה.
- HEAD Edge (ה-[SOURCE](/he/grammar/edge/source/#מקור-המסמך-כולו) של המסמך כולו וה-QUALIFIER שלו) אינם נרשמים כאן. ה-HEAD מוחלף כולו ב-HEAD של ה-diff ([שמירת diff](/he/grammar/document/#שמירת-diff)).

## דוגמה

מחיקת LOCAL `#7` ו-`#12`:

```
1A3B 0088 0007 0088 000C
```

- TAG `1A3B` (Meta `0x3B`, `LLLL=0100`, 5 WORD), LOCAL Reference `0088 0007`, `0088 000C`.
