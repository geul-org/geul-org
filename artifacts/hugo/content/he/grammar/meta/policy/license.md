---
title: "LICENSE"
weight: 81
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "LICENSE היא Meta של מדיניות שרושמת את הרישיון של המסמך הזה ושל יצירות שבתוך רצף בייטים."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

רושמת את הרישיון של המסמך הזה ושל יצירות שבתוך רצף בייטים.

## פריסה

```
TAG WORD          0001 1LLL L101 0000      Codec 0x50
[Length extension TAG]
Payload           Reference שמצביע על הרישיון, או מזהה SPDX כ-UTF8-TEXT, או Value מסוג URI
```

- Codec: Meta `0x50`, מחלקת מדיניות (`101`)
- Payload: Reference או Value מוטמע ([UTF8-TEXT](/he/grammar/value/text/utf8-text/), [URI](/he/grammar/value/text/uri/))
- מספר: לכל היותר אחד

## פירוש ותקינות

- מסמך שפורסם ב-geul.org הוא CC0. בפרסום פרטי ה-Issuer קובע ([Issuer](/he/grammar/issuer/)).
- רושמים את הרישיון המקורי של יצירת המקור.

## שאלות פתוחות

- האם לכתוב מזהה SPDX כטקסט או כ-Reference לישות של GEUL.
