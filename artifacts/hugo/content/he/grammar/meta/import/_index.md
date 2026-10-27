---
title: "Meta — IMPORT"
weight: 70
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "import"]
summary: "מחלקת ה-IMPORT של Meta (שלושה ביטים עליונים `110`, `0x60`~`0x6F`) מייבאת מסמך חיצוני באמצעות IMPORT ID."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

מחלקת ה-IMPORT של Meta (שלושה ביטים עליונים `110`, Codec `0x60`~`0x6F`) מייבאת מסמך חיצוני באמצעות IMPORT ID. ה-Codec הוא `IMPORT-DOC` (`0x60`) בלבד.

- IMPORT מייבא מסמכים בלבד. יעד בתוך המסמך המיובא מוצבע ב-BODY באמצעות Reference `EXTERNAL-POINTER-*` (IMPORT ID, LOCAL ID) ([Reference](/he/grammar/reference/)).
- אם כותבים מזהה גרסה, הייבוא קשור למהדורה הזו, ואם `0`, למהדורה האחרונה בזמן הפירוש. מסמך שפורסם כותב גרסה.
- ה-HEAD של המסמך המיובא אינו מיובא. רשומות Reference ו-Value אינן מיובאות אלא מועתקות.
