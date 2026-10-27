---
title: "RETENTION"
weight: 84
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "RETENTION היא Meta של מדיניות שרושמת את תקופת השמירה של המסמך כ-Value של זמן תפוגה או של משך."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

רושמת את תקופת השמירה של המסמך.

## פריסה

```
TAG WORD          0001 1LLL L101 0011      Codec 0x53
[Length extension TAG]
Payload           זמן תפוגה (GREGORIAN-DATE וכד') או משך (DURATION-SECONDS)
```

- Codec: Meta `0x53`, מחלקת מדיניות (`101`)
- Payload: Value מוטמע (משפחת TIME: [GREGORIAN-DATE](/he/grammar/value/time/gregorian-date/) וכד', או [DURATION-SECONDS](/he/grammar/value/time/duration-seconds/))
- מספר: לכל היותר אחד

## פירוש ותקינות

- אם זה משך, סופרים מ-[RECORDED-AT](/he/grammar/meta/provenance/recorded-at/).
