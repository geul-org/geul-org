---
title: "ISSUER-POINTER"
weight: 7
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "ISSUER-POINTER הוא Reference מסוג הצבעה-הצהרה שמצביע על ה-Issuer עצמו. ה-Payload הוא Issuer אחד בלבד."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ISSUER-POINTER הוא Reference מסוג הצבעה-הצהרה שמצביע על ה-Issuer עצמו. הוא משמש יעד של `BIND` של שם Issuer, של `LABEL` ושל Edge הכרעה.

## פריסה

```
TAG WORD          0000 0LLL L011 0QQQ      CCCC = 0110
[Length extension TAG]
Issuer            1/2/4/16 WORD
```

- רוחב ה-Issuer הוא כל ה-Payload. ה-Codec אינו מחלק את הרוחב. אם הרוחב אינו 1, 2, 4 או 16 WORD, או שערך ה-Issuer נכנס ברוחב צר יותר, זה invalid (הצורה הקנונית של Issuer).
- אם ה-Issuer הוא 16 WORD, הרשומה היא 17 WORD בסך הכול ולכן נוסף WORD אחד של הרחבת Length.
- משתמשים רק ב-Quantifier `000` (Identified). כל ערך אחר הוא invalid.
- ערך ה-Issuer הוא לפי ההקצאה ב-[Issuer](/he/grammar/issuer/).
- שימושים: Subject של BIND באינדקס שמות ה-Issuer `issuers.geul` ([כתובת פרסום ורשימת גרסאות](/he/grammar/publishing/#שם-issuer)), LABEL של שם התצוגה של Issuer, הכרעה על Issuer, חותם, וכל מקום שה-Issuer עצמו הוא היעד בו.
- הפורמט היחיד שמצביע על ה-Issuer עצמו הוא ISSUER-POINTER. הצבעה על Issuer באמצעות `EXTERNAL-ISSUER-*` עם מזהה מסמך `0` ו-ID של יעד `0` היא invalid.

## דוגמה

| Issuer | WORD sequence |
|---|---|
| GEUL `0x0000` | `00B0 0000` |
| IEEE `0x0040` | `00B0 0040` |

## דפים קשורים

- [Reference](/he/grammar/reference/), [DOC-POINTER](/he/grammar/reference/doc-pointer/), [EXTERNAL-ISSUER](/he/grammar/reference/external-issuer/), [Issuer ופרסום](/he/grammar/issuer/)
