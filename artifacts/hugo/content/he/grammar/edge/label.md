---
title: "LABEL"
weight: 5
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T23:00:00+09:00
tags: ["grammar", "edge"]
summary: "LABEL היא Edge תיאורית שמקשרת שם אחד בשפה מסוימת של יעד ה-Subject כ-Object מסוג UTF8-LANGUAGE-TEXT (Codec 0x04)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LABEL היא Edge תיאורית שמקשרת ליעד ה-Subject שם (label) אחד בשפה מסוימת כ-Object. Codec `0x04`. זו אינה Edge שמייצגת lemma בלקסיקוגרפיה כללית.

השם והשפה שלו נשמרים ב-Object אחד, [UTF8-LANGUAGE-TEXT](/he/grammar/value/text/utf8-language-text/). אין שדה גולמי.

## פריסה

```
TAG WORD          0001 0LLL L000 0100
[Length extension TAG]
Edge Id           רשומת LOCAL Reference
Subject           רשומת Reference אחת
Object            Value מסוג UTF8-LANGUAGE-TEXT או רשומת LOCAL Reference אחת
```

## פירוש ותקינות

- Subject הוא רשומת Reference שלמה אחת בדיוק. גבולותיו נמצאים לפי ה-Length של ה-Subject עצמו, ואם אינו Reference או שאינו שלם, זה invalid.
- Object הוא רשומת [UTF8-LANGUAGE-TEXT](/he/grammar/value/text/utf8-language-text/) (`0x4A`·`0x4B`) שלמה אחת בדיוק. כללי השפה והטקסט (שני פורמטי השפה מותרים, השוואת אותה שפה) הם לפי הפורמט הזה.
- ב-Object יכול להופיע גם LOCAL Reference. במקרה כזה הוא חייב להיפתר ל-UTF8-LANGUAGE-TEXT באמצעות קשירת [REFERENCE-NODE](/he/grammar/edge/reference-node/) באותו מסמך. אם אינו נפתר, או נפתר ליעד מסוג אחר, זה invalid.
- מסמך המפרט של geul.org כותב את ההגבלה הזו ב-[CODEC](/he/grammar/edge/codec/) (Object = `084A`·`084B`·`0008`). את יעד הפתרון של LOCAL לא מבטאים ב-CODEC.
- אם ה-Object אינו אחד משני הפורמטים שלמעלה או שהרשומה אינה שלמה, זה invalid. טקסט בלי שפה (UTF8-TEXT) אינו יכול להיות LABEL. שם למכונה, בלי שפה, נכתב כ-[BIND](/he/grammar/edge/bind/). שם משותף לכמה שפות נכתב עם שפה `mul`.
- לכל היותר LABEL אחת לכל Subject ושפה. שם נוסף נכתב כ-[ALIAS](/he/grammar/edge/alias/).

## אורך

```
סך הכול = 1 + N_len + N_id + N_subject + N_object WORD
```

- רשומת השפה של ה-Object ומספר בייטי הטקסט הם באחריות רשומת ה-Object ולא ה-Edge. הסמן אחרי קריאת הרשומה האחרונה חייב להתלכד בדיוק עם סוף ה-Edge.

## דוגמה (לא נורמטיבית)

קוד השפה `0784` של `en` הוא המספר ב-GEUL Language Registry v2 (מסמך המפרט `0x0000/0x0000000000000848` גרסה 2).

### LANGUAGE-SHORT-CODE

Edge Id `0007`, Subject Q22686 (`00A0 589e`), Object `Donald Trump` (en).

- ה-Object הוא שפה `08C8 0784` (SHORT-CODE, 2 WORD) + טקסט של 12 בייטים (זוגי, 6 WORD), ולכן `UTF8-LANGUAGE-TEXT-EVEN` (`0x4A`), בסך הכול 9 WORD: `0C4A 08C8 0784 446f 6e61 6c64 2054 7275 6d70`.
- ה-Edge היא TAG 1 + Edge Id 2 + Subject 2 + Object 9 = 14 WORD, `LLLL=1101`. ה-TAG הוא `1684`.

```
1684 0088 0007 00A0 589e 0C4A 08C8 0784 446f 6e61 6c64 2054 7275 6d70
```

### LANGUAGE-BCP47-CODE

Edge Id `0008`, Subject Q155 (`00A0 009b`), Object `Brasil` (pt-BR).

- ה-Object הוא שפה `09C7 7074 2d42 5200` (BCP47 `pt-BR`, 4 WORD) + טקסט של 6 בייטים (זוגי, 3 WORD), ולכן בסך הכול 8 WORD: `0BCA 09C7 7074 2d42 5200 4272 6173 696c`.
- ה-Edge היא TAG 1 + Edge Id 2 + Subject 2 + Object 8 = 13 WORD, `LLLL=1100`. ה-TAG הוא `1604`.

```
1604 0088 0008 00A0 009b 0BCA 09C7 7074 2d42 5200 4272 6173 696c
```

## דפים קשורים

- [Edge](/he/grammar/edge/), [ALIAS](/he/grammar/edge/alias/), [DESCRIPTION](/he/grammar/edge/description/), [BIND](/he/grammar/edge/bind/)
- [UTF8-LANGUAGE-TEXT](/he/grammar/value/text/utf8-language-text/), [LANGUAGE-SHORT-CODE](/he/grammar/value/text/language-short-code/), [LANGUAGE-BCP47-CODE](/he/grammar/value/text/language-bcp47-code/)
- [LOCAL](/he/grammar/reference/local/), [REFERENCE-NODE](/he/grammar/edge/reference-node/)
