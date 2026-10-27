---
title: "IMPORT-DOC"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "import"]
summary: "IMPORT-DOC היא Meta של IMPORT שמצביעה על מסמך חיצוני באמצעות DOC-POINTER ומקצה IMPORT ID."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

מייבאת מסמך חיצוני באמצעות IMPORT ID. המסמך לייבוא מוצבע על ידי [DOC-POINTER](/he/grammar/reference/doc-pointer/), וגם רוחב ה-Issuer נמצא ב-DOC-POINTER.

## פריסה

```
TAG WORD          0001 1LLL L110 0000      Codec 0x60
[Length extension TAG]
מסמך              רשומת DOC-POINTER Reference (Issuer, מזהה מסמך, מזהה גרסה. גרסה 0 פירושה האחרונה)
IMPORT ID         כל השאר. unsigned ברוחב הקצר ביותר
```

- Codec: Meta `0x60`, מחלקת IMPORT (`110`)
- Payload: Reference מוטמע `DOC-POINTER` (Issuer, מזהה מסמך, מזהה גרסה) + ערך גולמי של IMPORT ID
- מספר: אפשר כמה (אחד לכל IMPORT ID)

## פירוש ותקינות

- המסמך הוא רשומת DOC-POINTER אחת בדיוק. היא נגמרת ב-Length של עצמה, והשאר הוא ה-IMPORT ID.
- IMPORT ID הוא לפחות WORD אחד, ברוחב הקצר ביותר. רוחב ה-IMPORT ID נקבע כאן לפי אורך הרשומה, וב-[EXTERNAL-POINTER-*](/he/grammar/reference/external-pointer/) לפי ה-Codec. ה-IMPORT ID תקף רק בתוך אותו מסמך.
- במסמך אחד לא מקצים את אותו IMPORT ID פעמיים.
- אם כותבים מזהה גרסה, הייבוא קשור למהדורה הזו, ואם `0`, למהדורה האחרונה בזמן הפירוש (או למהדורה שהייתה בתוקף בנקודת הזמן שנקבעה) ([תיקון](/he/grammar/document/#תיקון)).
- [EXTERNAL-POINTER-*](/he/grammar/reference/external-pointer/) ב-BODY מצביע על ה-LOCAL של המסמך שיובא באמצעות IMPORT ID. המסמך המיובא עצמו מוצבע באמצעות DOC-POINTER.
- ה-HEAD של המסמך המיובא אינו מיובא. היעדים של אותו מסמך מפורשים לפי ההצהרות שלו.
- אי אפשר לחפש בין מסמכים באמצעות IMPORT ID. מאגר שטוען כמה מסמכים פותר את ה-IMPORT ID לנתיב מלא (Issuer, מזהה מסמך, מזהה גרסה, LOCAL ID) ושומר אותו.

## דוגמה

- IMPORT ID 1, Issuer `0x0001`, מסמך `0x…0002`, האחרונה: `1CE0 03B8 0001 0000 0000 0000 0002 0000 0000 0001` (TAG של Meta 1 + DOC-POINTER 8 + IMPORT ID 1 = 10 WORD)
