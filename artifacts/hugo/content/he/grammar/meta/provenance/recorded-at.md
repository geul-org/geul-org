---
title: "RECORDED-AT"
weight: 38
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "RECORDED-AT היא Meta של מוצא שרושמת כ-Value של TIME את זמן התיעוד של המסמך (git commit date)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

רושמת את זמן התיעוד של המסמך (git commit date).

## פריסה

```
TAG WORD          0001 1LLL L010 0101      Codec 0x25
[Length extension TAG]
Payload           Value אחד מסוג TIME (GREGORIAN-DATE, POSIX-TIMESTAMP-SECONDS וכד')
```

- Codec: Meta `0x25`, מחלקת מוצא (`010`)
- Payload: Value מוטמע (משפחת TIME: [GREGORIAN-DATE](/he/grammar/value/time/gregorian-date/), [POSIX-TIMESTAMP-SECONDS](/he/grammar/value/time/posix-timestamp-seconds/) וכד')
- מספר: לכל היותר אחד

## פירוש ותקינות

- הפורמט נבחר מבין Value של משפחת TIME. כשנדרש דיוק, משתמשים בפורמט ננו-שניות ש-Issuer הגדיר (למשל [POSIX-TIMESTAMP-NANOSECONDS](/he/grammar/value/time/posix-timestamp-nanoseconds/)).
- מסמך רשימת הגרסאות ([PUBLICATION](/he/grammar/edge/publication/)) משתמש בערך הזה כזמן הפרסום, ה-deprecate והמחיקה.

## שאלות פתוחות

- Meta של מוצא נכנס ל-hash התוכן. האם להתיר שרישום אותו תוכן בזמנים שונים ייצור hash שונה.
