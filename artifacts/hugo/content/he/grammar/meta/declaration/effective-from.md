---
title: "EFFECTIVE-FROM"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "EFFECTIVE-FROM היא Meta של הצהרה שמצהירה על יום כניסת הגרסה הזו לתוקף כ-Value של תאריך או חותמת זמן."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

מצהירה על יום כניסת הגרסה הזו לתוקף. יום התחולה שונה מזמן הפרסום ([תיקון](/he/grammar/document/#תיקון)).

## פריסה

```
TAG WORD          0001 1LLL L001 0011      Codec 0x13
[Length extension TAG]
Payload           Value אחד מסוג TIME
```

- Codec: Meta `0x13`, מחלקת הצהרה (`001`)
- Payload: Value מוטמע ([GREGORIAN-DATE](/he/grammar/value/time/gregorian-date/) או [POSIX-TIMESTAMP-SECONDS](/he/grammar/value/time/posix-timestamp-seconds/))
- מספר: לכל היותר אחד

## פירוש ותקינות

- אם אין, הגרסה בתוקף מזמן הפרסום.
- אם יש [EFFECTIVE-UNTIL](/he/grammar/meta/declaration/effective-until/), היא חייבת להקדים אותו.
- אם יום התחולה שונה מסעיף לסעיף, רושמים אותו בנפרד כ-QUALIFIER P580 (התחלה) ו-P582 (סוף) ב-Edge של אותו סעיף ([SOURCE](/he/grammar/edge/source/#ייצוג-של-ראיות-אחרות)).
- קוראים את הערך הזה כשמפרשים את המסמך לפי נקודת זמן מסוימת.

## דוגמה

- בתוקף מ-1970-01-02: `0x1993 0x0920 0x0000 0x0001`
