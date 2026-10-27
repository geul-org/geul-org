---
title: "EXTERNAL-ISSUER"
weight: 13
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "EXTERNAL-ISSUER הוא Reference מסוג הצבעה-הצהרה שמצטט ברשומה אחת, בלי IMPORT, LOCAL ID של מסמך ש-Issuer פרסם."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXTERNAL-ISSUER הוא Reference מסוג הצבעה-הצהרה שמצטט, בלי IMPORT, LOCAL ID של מסמך ש-Issuer פרסם. המשמעות שלו שלמה ברשומה אחת, והוא עוקב אחרי הגרסה האחרונה.

## פריסה

```
TAG WORD          0000 0LLL L11W WQQQ      CCCC = 11WW
[Length extension TAG]
Issuer            הרוחב ש-WW קובע (00=1, 01=2, 10=4, 11=16 WORD)
מזהה מסמך         4 WORD
ID של היעד        כל השאר. ה-LOCAL ID של אותו מסמך, ברוחב הקצר ביותר
```

| CCCC | שם | רוחב Issuer |
|---|---|---|
| `1100` | EXTERNAL-ISSUER-1WORD | 1 WORD (הקצאה של geul.org) |
| `1101` | EXTERNAL-ISSUER-2WORD | 2 WORD (רישום ב-geul.org, הוכחת דומיין) |
| `1110` | EXTERNAL-ISSUER-4WORD | 4 WORD (רישום ב-geul.org, בלי הוכחה) |
| `1111` | EXTERNAL-ISSUER-16WORD | 16 WORD (מחושב מהמפתח הציבורי) |

- Issuer ID הוא ערך מספרי שלם. ערך זהה פירושו אותו Issuer. ה-Issuer נכתב ברוחב הקצר ביותר שהערך נכנס בו, ובוחרים את ה-Codec של אותו רוחב (2 WORD רק כשהערך גדול מ-`0xFFFF`, 4 WORD רק מ-`2^32` ומעלה, 16 WORD רק מ-`2^64` ומעלה). רישום ברוחב רחב יותר הוא invalid ([Issuer](/he/grammar/issuer/)).
- רישום וניהול של Issuer נעשים על ידי geul.org.
- אין כותבים גרסה, והוא עוקב אחרי הגרסה האחרונה. כדי לנעול גרסה משתמשים ב-[IMPORT-DOC](/he/grammar/meta/import/import-doc/) וב-[EXTERNAL-POINTER](/he/grammar/reference/external-pointer/).
- המיקום נמצא לפי כללי כתובת הפרסום ([כתובת פרסום ורשימת גרסאות](/he/grammar/publishing/)).
- אותו LOCAL ID של אותו מסמך הוא אותו יעד, בין אם משתמשים בו כ-LOCAL בתוך המסמך, כ-EXTERNAL-ISSUER ממסמך אחר, או (אחרי IMPORT) כ-EXTERNAL-POINTER.
- הוא מצביע רק על LOCAL של מסמך. המסמך עצמו מוצבע באמצעות [DOC-POINTER](/he/grammar/reference/doc-pointer/), וה-Issuer עצמו באמצעות [ISSUER-POINTER](/he/grammar/reference/issuer-pointer/). לכן ה-ID של היעד אינו `0`. מזהה מסמך `0` הוא מסמך אינדקס הגדרות המונחים של ה-Issuer.

## תקינות

- אם רוחב ה-Issuer אינו תואם את ה-Codec, או שהערך נכנס ברוחב צר יותר, זה invalid.
- אם ה-ID של היעד הוא `0`, זה invalid. ID של יעד `0` (המסמך עצמו) הוא תפקידו של DOC-POINTER.
- WORD מוביל של `0x0000` ב-ID של היעד אסור.

## דוגמה

| יעד | WORD sequence |
|---|---|
| Issuer `0x0001`, מסמך `0x…0002`, LOCAL 7 | `0360 0001 0000 0000 0000 0002 0007` |
| Issuer `0x00012345`, מסמך `0x…0002`, LOCAL 7 | `03E8 0001 2345 0000 0000 0000 0002 0007` |

## דפים קשורים

- [Reference](/he/grammar/reference/), [DOC-POINTER](/he/grammar/reference/doc-pointer/), [ISSUER-POINTER](/he/grammar/reference/issuer-pointer/), [EXTERNAL-POINTER](/he/grammar/reference/external-pointer/)
- [Issuer ופרסום](/he/grammar/issuer/)
