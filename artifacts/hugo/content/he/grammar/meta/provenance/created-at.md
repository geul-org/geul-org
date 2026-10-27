---
title: "CREATED-AT"
weight: 35
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "CREATED-AT היא Meta של מוצא שרושמת כ-Value של TIME את זמן כתיבת המסמך (git author date)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

רושמת את זמן כתיבת המסמך (git author date).

## פריסה

```
TAG WORD          0001 1LLL L010 0010      Codec 0x22
[Length extension TAG]
Payload           Value אחד מסוג TIME (GREGORIAN-DATE, POSIX-TIMESTAMP-SECONDS וכד')
```

- Codec: Meta `0x22`, מחלקת מוצא (`010`)
- Payload: Value מוטמע (משפחת TIME: [GREGORIAN-DATE](/he/grammar/value/time/gregorian-date/), [POSIX-TIMESTAMP-SECONDS](/he/grammar/value/time/posix-timestamp-seconds/) וכד')
- מספר: לכל היותר אחד

## פירוש ותקינות

- הפורמט נבחר מבין Value של משפחת TIME. כשנדרש דיוק, משתמשים בפורמט ננו-שניות ש-Issuer הגדיר (למשל [POSIX-TIMESTAMP-NANOSECONDS](/he/grammar/value/time/posix-timestamp-nanoseconds/)).
