---
title: "BIND"
weight: 4
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "BIND היא Edge תיאורית שקושרת ל-Subject שם שהמכונה מתאימה אליו (UTF8-TEXT ללא שפה) (Codec 0x03)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BIND היא Edge תיאורית שקושרת ל-Subject שם שהמכונה מתאימה אליו. Codec `0x03`.

זוהי מתן שם. השם שאדם קורא (כותרת בכל שפה) הוא תפקידו של [LABEL](/he/grammar/edge/label/). שם של סמל בתוכנית ושם לכתובת של מסמך נכתבים באותה רשומה.

## פריסה

```
TAG WORD          0001 0LLL L000 0011
[Length extension TAG]
Edge Id           רשומת LOCAL Reference
Subject           רשומת Reference אחת, או TAG WORD של Codec (WORD אחד)
שם                Value אחד מסוג UTF8-TEXT-*
```

## פירוש ותקינות

- ה-Subject הוא בדיוק רשומת [Reference](/he/grammar/reference/) שלמה אחת. אם היא LOCAL, זהו יעד במסמך זה (סמל וכד'), ואם היא Reference מצביע, זהו יעד במסמך אחר. המסמך עצמו הוא [DOC-POINTER](/he/grammar/reference/doc-pointer/), וה-Issuer עצמו הוא [ISSUER-POINTER](/he/grammar/reference/issuer-pointer/).
- לחלופין, ה-Subject הוא TAG WORD אחד של Codec (Kind ו-Codec בלבד, `LLLL = 0`, ללא Payload). זו אינה רשומה עם Payload ריק, אלא מצביעה אל הקוד הישיר עצמו, כלומר אל מסמך המפרט שלו (מסמך Issuer של GEUL `0x000000000000<TAG>`) ([מסמך מפרט Codec](/he/grammar/codec-spec/), [DECLARE](/he/grammar/edge/declare/)). למשל: `1018` הוא PUBLICATION. באינדקס שמות משתמשים ב-Subject מסוג DOC-POINTER. לא משתמשים ב-Codec בפורמט Issuer.
- רשומות אחרות (Value וכד') אינן יכולות להיות Subject. ה-FIELD במסמך המפרט של BIND מצהיר על ה-Subject ברוחב `0` (רשומה) בלבד, ולכן אילוץ זה הוא כלל בגוף ה-BIND.
- השם הוא בדיוק Value אחד מסוג [UTF8-TEXT](/he/grammar/value/text/utf8-text/). ללא שפה וללא נרמול. שמות זהים רק אם הבייטים זהים.
- תחום השם הוא המסמך שמכיל את ה-BIND. במסמך אחד לא קושרים את אותו שם ל-Subject שונים.
- אפשר לקשור כמה שמות ל-Subject אחד (כינוי, שם ישן). אם המסמך לא קבע אחרת, ה-BIND האחרון הוא השם המייצג.
- רשומות אחרות מצביעות על היעד באמצעות LOCAL ID ולא באמצעות שם. השם משמש להתאמה לגורמים חיצוניים (פונקציית מארח, קלט כתובת, בני אדם).
- התווים המותרים בשם נקבעים לפי השימוש. שם לכתובת של מסמך כפוף לכללי שמות המסמכים (slug של ASCII באותיות קטנות) ([כתובת פרסום ורשימת גרסאות](/he/grammar/publishing/#שם-המסמך)).

## אורך

```
סה"כ = 1 + N_len + N_id + N_subject + N_name WORD
```

## דוגמאות (לא נורמטיביות)

סמל בתוכנית: Edge Id `0003`, Subject LOCAL 7, שם `main`.

- השם `main` הוא 4 בייטים (זוגי), ולכן 3 WORD: `0940 6d61 696e`.
- ה-Edge היא TAG 1 + Edge Id 2 + Subject 2 + שם 3 = 8 WORD, ו-TAG `1383`.

```
1383 0088 0003 0088 0007 0940 6d61 696e
```

שם מסמך (בתוך מסמך רשימת הגרסאות שלו, `0x0000/0xffff000000000002/versions.geul`): Edge Id `0005`, Subject `DOC-POINTER` (Issuer `0x0000`, מסמך `0xffff000000000002`, גרסה `0` = המסמך עצמו), שם `this-is-sample-doc`.

- ה-Subject הוא TAG `03B8` + Issuer 1 + מזהה מסמך 4 + מזהה גרסה 2 = 8 WORD.
- השם הוא 18 בייטים (זוגי), ולכן TAG `0CC0` + 9 WORD = 10 WORD.
- ה-Edge היא TAG 1 + Length extension 1 + Edge Id 2 + Subject 8 + שם 10 = 22 WORD, כלומר `LLLL=1110`, TAG `1703`, הרחבה `0016`.

```
1703 0016 0088 0005 03B8 0000 ffff 0000 0000 0002 0000 0000 0CC0 7468 6973 2d69 732d 7361 6d70 6c65 2d64 6f63
```

## דפים קשורים

- [Edge](/he/grammar/edge/), [LABEL](/he/grammar/edge/label/), [PUBLICATION](/he/grammar/edge/publication/) (שם המסמך במסמך רשימת הגרסאות)
- [LOCAL](/he/grammar/reference/local/), [DOC-POINTER](/he/grammar/reference/doc-pointer/), [ISSUER-POINTER](/he/grammar/reference/issuer-pointer/)
