---
title: "EFFECTIVE-UNTIL"
weight: 21
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "EFFECTIVE-UNTIL היא Meta של הצהרה שמצהירה על סוף תקופת התוקף של הגרסה הזו (חוק זמני) כ-Value של תאריך או חותמת זמן."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

מצהירה על סוף תקופת התוקף של הגרסה הזו (חוק זמני). מאותו זמן הגרסה הזו אינה בתוקף.

## פריסה

```
TAG WORD          0001 1LLL L001 0100      Codec 0x14
[Length extension TAG]
Payload           Value אחד מסוג TIME
```

- Codec: Meta `0x14`, מחלקת הצהרה (`001`)
- Payload: Value מוטמע ([GREGORIAN-DATE](/he/grammar/value/time/gregorian-date/) או [POSIX-TIMESTAMP-SECONDS](/he/grammar/value/time/posix-timestamp-seconds/))
- מספר: לכל היותר אחד

## פירוש ותקינות

- אם אין, הגרסה תקפה עד שתיכנס לתוקף הגרסה הבאה.
- אחרי שתקופת התוקף חלפה, אין מהדורה בתוקף. המהדורה הישנה אינה קמה לתחייה.
