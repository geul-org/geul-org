---
title: "SAME-NODE"
weight: 2
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "SAME-NODE היא Edge תיאורית לא מכוונת של זהות, שמצהירה ששני Reference מצביעים על אותו יעד (Codec 0x01)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SAME-NODE היא Edge תיאורית לא מכוונת של זהות, שמצהירה ששני Reference מצביעים על אותו referent. Codec `0x01`.

אין פירושה שקידוד הבייטים, ה-Codec וה-ID של שתי רשומות ה-Reference זהים. בניגוד ל-[REFERENCE-NODE](/he/grammar/edge/reference-node/), שהיא קשירה מכוונת `Reference → רשומה`, SAME-NODE מבטאת זהות (referential identity) בין שני Reference.

## פריסה

```
TAG WORD          0001 0LLL L000 0001
[Length extension TAG]
Edge Id           רשומת LOCAL Reference
Subject           רשומת Reference אחת
Object            רשומת Reference אחת
```

## פירוש ותקינות

- Subject ו-Object מסודרים בסדר הזה בסריאליזציה, וכל אחד מהם חייב להיות רשומת [Reference](/he/grammar/reference/) שלמה אחת בדיוק. הגבולות נמצאים לפי ה-Length של כל רשומה.
- אם ה-Subject או ה-Object הוא Value, Edge או רשומה שאינה שלמה, זה invalid.
- היחס SAME-NODE הוא רפלקסיבי, סימטרי וטרנזיטיבי. הסדר Subject/Object ב-wire נועד ל-framing ואינו יוצר כיוון משמעות. מימוש חייב להיות מסוגל לחפש את היחס בשני הכיוונים.
- ID שונים של [LOCAL](/he/grammar/reference/local/) הם רק Reference שונים, ואינם ראיה לכך שה-referent זהה או שונה. הקביעה ששני Reference מצביעים על אותו referent נעשית ב-SAME-NODE.
- פירוש והסקה חייבים לשמר את המקור, הזמן, ה-world וה-policy scope של המסמך שמכיל את ה-Edge ושל גרף ההכרעה. אין להשתמש ב-SAME-NODE כבסיס למיזוג גלובלי שאינו תלוי בהקשר.
- גם כשיש SAME-NODE, אין למחוק או לדרוס את רשומות ה-Reference המקוריות או את השושלת.
- אם באותו זוג יש יחד SAME-NODE ו-[DIFFERENT-NODE](/he/grammar/edge/different-node/), ה-wire אינו invalid בגלל זה. משמרים את ההקשר של כל טענה ומעריכים אותן כסתירה.
- מקשרים Variable Reference ל-Identified Reference באמצעות SAME-NODE כדי לפתור את המשתנה (Variable ב-[Reference](/he/grammar/reference/)).

## אורך

```
סך הכול = 1 + N_len + N_id + N_subject + N_object WORD
```

## דוגמה (לא נורמטיבית)

Edge Id `0009`, ה-Subject הוא LOCAL 1 וה-Object הוא LOCAL 2.

- ה-Edge היא TAG 1 + Edge Id 2 + Subject 2 + Object 2 = 7 WORD, `LLLL=0110`. ה-TAG הוא `0001 0 0110 0000001` = `1301`.

```
1301 0088 0009 0088 0001 0088 0002
```

## דפים קשורים

- [Edge](/he/grammar/edge/), [REFERENCE-NODE](/he/grammar/edge/reference-node/), [DIFFERENT-NODE](/he/grammar/edge/different-node/)
- [Reference](/he/grammar/reference/), [LOCAL](/he/grammar/reference/local/)
