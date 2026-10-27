---
title: "DOC-POINTER"
weight: 8
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "DOC-POINTER הוא Reference מסוג הצבעה-הצהרה שמצביע על גרסה אחת של מסמך ש-Issuer פרסם. מזהה גרסה 0 הוא הגרסה האחרונה."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DOC-POINTER הוא Reference מסוג הצבעה-הצהרה שמצביע על גרסה אחת של מסמך ש-Issuer פרסם. הוא משמש יעד של פרסום, deprecate ומחיקת מסמך, של ציטוט מהדורה ושל תיאורים על מסמך.

## פריסה

```
TAG WORD          0000 0LLL L011 1QQQ      CCCC = 0111
[Length extension TAG]
Issuer            1/2/4/16 WORD
מזהה מסמך         4 WORD
מזהה גרסה         2 WORD
```

## פירוש ותקינות

- רוחב ה-Issuer הוא מה שנותר ב-Payload אחרי מזהה המסמך (4 WORD) ומזהה הגרסה (2 WORD), כלומר 6 WORD. ה-Codec אינו מחלק את הרוחב. אם הרוחב אינו 1, 2, 4 או 16 WORD, או שערך ה-Issuer נכנס ברוחב צר יותר, זה invalid (הצורה הקנונית של Issuer).
- אין להשמיט את מזהה הגרסה. אם ההשמטה הייתה מותרת, אי אפשר היה לקבוע את רוחב ה-Issuer לפי אורך ה-Payload בלבד (Issuer של 4 WORD בלי גרסה ו-Issuer של 2 WORD עם גרסה הם אותם 8 WORD).
- מזהה גרסה `0` הוא הגרסה האחרונה. הוא קשור לגרסה התקפה בזמן הפירוש. כל ערך אחר ננעל לגרסה הזו ([PUBLICATION](/he/grammar/edge/publication/)).
- מזהה מסמך `0` הוא מסמך אינדקס הגדרות המונחים של ה-Issuer. ה-Issuer עצמו מוצבע באמצעות [ISSUER-POINTER](/he/grammar/reference/issuer-pointer/).
- משתמשים רק ב-Quantifier `000` (Identified). כל ערך אחר הוא invalid.
- הפורמט היחיד שמצביע על מסמך של Issuer הוא DOC-POINTER. הצבעה על מסמך באמצעות `EXTERNAL-ISSUER-*` (Issuer, מזהה מסמך, ID של יעד `0`) או `EXTERNAL-POINTER-*` (IMPORT ID, ID של יעד `0`) היא invalid.
- איפה משתמשים: Meta [DOC-ID](/he/grammar/meta/declaration/doc-id/) ו-[IMPORT-DOC](/he/grammar/meta/import/import-doc/), PUBLICATION, DEPRECATION ו-TOMBSTONE של רשימת הגרסאות ו-Subject של BIND, ו-Subject של BIND באינדקס השמות `documents.geul`.

## דוגמה

מסמך של ה-Issuer `0x0000` של GEUL עם מזהה `0xffff000000000001`.

| גרסה | WORD sequence |
|---|---|
| 1 | `03B8 0000 ffff 0000 0000 0001 0000 0001` |
| האחרונה (`0`) | `03B8 0000 ffff 0000 0000 0001 0000 0000` |

- TAG 1 + Issuer 1 + מזהה מסמך 4 + מזהה גרסה 2 = 8 WORD, `LLLL=0111`. ה-TAG הוא `0000 0 0111 0111 000` = `03B8`.

## דפים קשורים

- [Reference](/he/grammar/reference/), [ISSUER-POINTER](/he/grammar/reference/issuer-pointer/), [EXTERNAL-ISSUER](/he/grammar/reference/external-issuer/), [PUBLICATION](/he/grammar/edge/publication/)
- [Issuer ופרסום](/he/grammar/issuer/)
