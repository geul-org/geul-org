---
title: "DOC-ID"
weight: 19
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "DOC-ID היא Meta של הצהרה שמצהירה על מזהה המסמך באמצעות DOC-POINTER (Issuer, מזהה מסמך, גרסה 0) שמצביע על המסמך עצמו."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

מצהירה על מזהה המסמך הזה. היא דרושה כדי שמסמכים אחרים יוכלו להצביע על המסמך הזה ועל יעדים שבתוכו.

## פריסה

```
TAG WORD          0001 1LLL L001 0010      Codec 0x12
[Length extension TAG]
מסמך              רשומת DOC-POINTER Reference. (Issuer, מזהה מסמך, גרסה 0)
```

- Codec: Meta `0x12`, מחלקת הצהרה (`001`)
- Payload: Reference מוטמע [DOC-POINTER](/he/grammar/reference/doc-pointer/) (Issuer, מזהה מסמך, גרסה 0) אחד
- מספר: לכל היותר אחד. חובה במסמך ששמו מתחיל ב-`0x`

## פירוש ותקינות

- ה-Payload הוא בדיוק רשומת Reference אחת מסוג `DOC-POINTER` (Issuer, מזהה מסמך, גרסה `0`). כמזהה גרסה משתמשים רק ב-`0`. הגרסה מוקצית לא על ידי המסמך אלא על ידי רשימת הגרסאות. ה-Quantifier הוא `000`.
- לכן הרישום שמצביע על "המסמך הזה" זהה ב-DOC-ID, ב-Subject של [BIND](/he/grammar/edge/bind/) ב-`documents.geul` ובציטוטים ממסמכים אחרים.
- בלי קשר לגרסה, אותו מסמך הוא אותו `DOC-ID`. מזהה הגרסה ו-hash התוכן אינם נרשמים במסמך ([גרסה](/he/grammar/document/#גרסה)).
- השם לצורך כתובת הוא `BIND` תיאורי באינדקס השמות `documents.geul` ([כתובת פרסום ורשימת גרסאות](/he/grammar/publishing/#שם-המסמך)), והכותרת שבני אדם קוראים היא [LABEL](/he/grammar/edge/label/) תיאורי.
- אם אין, זהו מסמך ללא שם שאפשר להצביע עליו רק באמצעות hash התוכן. הוא דרוש כדי שמסמך אחר יוכל להצביע ב-Reference מצביע על ה-LOCAL של המסמך הזה.
- הצד שמייבא מסמך מוודא שה-`DOC-ID` של המסמך שהתקבל שווה ל-Issuer ולמזהה המסמך שהתבקשו.
- מזהה המסמך `0x0000000000000000` הוא מסמך אינדקס הגדרות המונחים של ה-Issuer ([Issuer](/he/grammar/issuer/)). גם שמו של המסמך הזה מתחיל ב-`0x`, ולכן יש לו DOC-ID (`DOC-POINTER` (Issuer, `0`, `0`)). ה-Issuer עצמו מיוצג על ידי [ISSUER-POINTER](/he/grammar/reference/issuer-pointer/).
- `DOC-ID` הוא חובה במסמך שנמצא תחת `.well-known/geul/` ושמו מתחיל ב-`0x` (מסמך גרסה `<version-id>.geul`, מסמך מפרט).
- מסמך ששמו אינו מתחיל ב-`0x` אינו מציב `DOC-ID`, כחריג: רשימת הגרסאות `versions.geul` ([PUBLICATION](/he/grammar/edge/publication/)), אינדקס שמות המסמכים `documents.geul` ואינדקס שמות ה-Issuer `issuers.geul` ([כתובת פרסום ורשימת גרסאות](/he/grammar/publishing/)). מאגר ה-hash של התוכן `h/` הוא עותק של המסמכים האלה ועוקב אחרי המקור.
- מסמך מפרט Codec הוא מסמך של Issuer `0x0000` של GEUL. מזהה המסמך הוא ה-TAG WORD של ה-Kind וה-Codec מורחב ל-4 WORD (`0x1018` → `0x0000000000001018`). Reference `0000` שמור, ולכן מזהה המסמך אינו יכול להיות `0` ([מסמך מפרט](/he/grammar/codec-spec/)).

## דוגמה

- Issuer `0x0001`, מסמך `0x…0005`: `1C12 03B8 0001 0000 0000 0000 0005 0000 0000` (TAG של Meta 1 + TAG של Reference 1 + Issuer 1 + מזהה מסמך 4 + גרסה 2 = 9 WORD)
