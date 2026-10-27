---
title: "REFERENCE-NODE"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "REFERENCE-NODE היא Edge תיאורית מכוונת שקושרת Reference אחד לרשומת Object אחת ומגדירה מהו אותו Reference (Codec 0x00)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

REFERENCE-NODE היא Edge תיאורית מכוונת שמקשרת Reference אחד לרשומת Object אחת, ומגדירה או קושרת מהו אותו Reference. Codec `0x00`.

ה-Subject מצביע על ה-Object. הקשירה הזו אינה [SAME-NODE](/he/grammar/edge/same-node/) שטוענת זהות במשמעות, והיא גם אינה אומרת ששני הרשומות זהות בבייטים.

## פריסה

```
TAG WORD          0001 0LLL L000 0000
[Length extension TAG]
Edge Id           רשומת LOCAL Reference
Subject           רשומת Reference אחת
Object            רשומת Reference או Value אחת
```

## פירוש ותקינות

- Subject חייב להיות רשומת [Reference](/he/grammar/reference/) שלמה אחת בדיוק. גבולותיו נמצאים לפי ה-Length של ה-Subject עצמו, ואם אינו Reference או שאינו שלם, זה invalid.
- Object חייב להיות רשומת Reference או Value שלמה אחת בדיוק. גבולותיו נמצאים לפי ה-Length של ה-Object עצמו, ואם הוא Edge או Meta או שאינו שלם, זה invalid.
- אם ה-Object הוא Reference, שרשרת ה-Reference שעוקבים אחריה דרך קשירות REFERENCE-NODE אסור שתהיה מעגלית, ו-LOCAL חייב להיפתר בסופו של דבר. מעגל פתרון ו-LOCAL תלוי (dangling) הם invalid.
- אם LOCAL ID אחד במסמך אחד נקשר ל-Object-ים סותרים, זה invalid. תחום ה-LOCAL, ה-ID, הרוחב המינימלי וכללי המיזוג הם לפי [LOCAL](/he/grammar/reference/local/).
- לא כל Reference חייב להיקשר ב-REFERENCE-NODE.
- השימוש המייצג הוא `LOCAL → UTF8-LANGUAGE-TEXT`. כשמציבים LOCAL ב-Object של [LABEL](/he/grammar/edge/label/), הטקסט נפתר באמצעות הקשירה הזו באותו מסמך.

אסור לפרש הפוך את הכיוון שבו ה-Subject מצביע על ה-Object. המשמעות והכללים המפורטים של SAME ו-DIFFERENT נקבעים בנפרד בכל פורמט.

## אורך

```
סך הכול = 1 + N_len + N_id + N_subject + N_object WORD
```

`N_len` הוא מספר ה-WORD של TAG הרחבת ה-Length, `N_id` הוא מספר ה-WORD של רשומת ה-LOCAL של ה-Edge Id, ו-`N_subject` ו-`N_object` הם מספר ה-WORD הכולל של כל רשומה. הסמן אחרי קריאת ה-Subject וה-Object חייב להתלכד בדיוק עם סוף ה-Edge.

## דוגמה (לא נורמטיבית)

Edge Id `0008`, ה-Subject הוא LOCAL 1, וה-Object הוא [UTF8-LANGUAGE-TEXT](/he/grammar/value/text/utf8-language-text/) של `Donald Trump` (en).

- ה-Edge Id הוא `0088 0008`, 2 WORD.
- ה-Subject הוא `0088 0001`, 2 WORD.
- ה-Object הוא שפה `08C6 656e` (BCP47 `en`) + טקסט של 12 בייטים (זוגי), ולכן `UTF8-LANGUAGE-TEXT-EVEN` (`0x4A`), בסך הכול 9 WORD. ה-TAG הוא `0C4A`.
- ה-Edge היא TAG 1 + Edge Id 2 + Subject 2 + Object 9 = 14 WORD, `LLLL=1101`. ה-TAG הוא `1680`.

```
1680 0088 0008 0088 0001 0C4A 08C6 656e 446f 6e61 6c64 2054 7275 6d70
```

## דפים קשורים

- [Edge](/he/grammar/edge/), [SAME-NODE](/he/grammar/edge/same-node/), [DIFFERENT-NODE](/he/grammar/edge/different-node/), [LABEL](/he/grammar/edge/label/)
- [Reference](/he/grammar/reference/), [LOCAL](/he/grammar/reference/local/), [UTF8-LANGUAGE-TEXT](/he/grammar/value/text/utf8-language-text/)
