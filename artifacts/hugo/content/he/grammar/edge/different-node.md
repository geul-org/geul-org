---
title: "DIFFERENT-NODE"
weight: 3
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DIFFERENT-NODE היא Edge תיאורית של אי-זהות: שני Reference מצביעים על יעדים שונים זה מזה (Codec 0x02)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DIFFERENT-NODE היא Edge תיאורית של אי-זהות: שני Reference מצביעים על referent שונים זה מזה. Codec `0x02`.

אין פירושה ששתי רשומות Reference נבדלות בקידוד הבייטים, ב-Codec או ב-ID. יש להבחין בינה לבין הקשירה המכוונת של [REFERENCE-NODE](/he/grammar/edge/reference-node/) ולבין הזהות של [SAME-NODE](/he/grammar/edge/same-node/).

## פריסה

```
TAG WORD          0001 0LLL L000 0010
[Length extension TAG]
Edge Id           רשומת LOCAL Reference
Subject           רשומת Reference אחת
Object            רשומת Reference אחת
```

## פירוש ותקינות

- כל אחד מ-Subject ו-Object חייב להיות בדיוק רשומת [Reference](/he/grammar/reference/) שלמה אחת. הגבולות נמצאים לפי ה-Length של כל רשומה, ואם זו Value או Edge או שהרשומה אינה שלמה, היא invalid.
- Subject ו-Object מצביעים על referent שונים זה מזה. לא מסיקים שה-referent שונים רק מכך שרצף הבייטים, ה-Codec או ה-ID של רשומות ה-Reference שונים.
- בפרט, ID שונים של [LOCAL](/he/grammar/reference/local/) הם רק Reference שונים, ולא אומרים שגם ה-referent במציאות שונים. לא גוזרים DIFFERENT מהבדל ב-LOCAL ID בלבד.
- אי-זהות היא סימטרית, אי-רפלקסיבית ולא טרנזיטיבית. `DIFFERENT(A, B)` הוא אותו יחס כמו `DIFFERENT(B, A)`. אך מ-`DIFFERENT(A, B)` ו-`DIFFERENT(B, C)` לא מסיקים `DIFFERENT(A, C)`.
- סדר Subject/Object ב-wire הוא סדר סריאליזציה לצורך framing בלבד ואינו יוצר כיוון משמעות. המימוש חייב לאפשר חיפוש בשני הכיוונים.
- הסמן אחרי קריאת שני הרכיבים חייב להתלכד בדיוק עם סוף ה-Edge.

היחס עצמו אי-רפלקסיבי, אך אסור למחוק כשגיאת תחביר ב-wire טענה תקפה מבנית כמו `DIFFERENT(A, A)` או טענה ש-SAME ו-DIFFERENT מתנגשים בה. טענות כאלה משמרות הקשר ושושלת, ושכבת ההכרעה מטפלת בהן כסתירה. בפירוש DIFFERENT או בהסקה ממנו משמרים את המקור, הזמן, ה-world וה-policy scope של המסמך שמכיל את ה-Edge, ואין להרחיב למסקנה גלובלית שמתעלמת מהם.

## אורך

```
סה"כ = 1 + N_len + N_id + N_subject + N_object WORD
```

## דוגמה (לא נורמטיבית)

Edge Id `000a`, ה-Subject הוא LOCAL 1, וה-Object הוא LOCAL 2.

- ה-Edge היא TAG 1 + Edge Id 2 + Subject 2 + Object 2 = 7 WORD, `LLLL=0110`. ה-TAG הוא `0001 0 0110 0000010` = `1302`.

```
1302 0088 000a 0088 0001 0088 0002
```

ההבדל בין ה-LOCAL ID בדוגמה זו נועד רק להראות את הקידוד. הופכים את הרצף הזה ל-DIFFERENT-NODE רק כשיש טענה נפרדת ש-ID 1 ו-ID 2 מצביעים על referent שונים.

## דפים קשורים

- [Edge](/he/grammar/edge/), [REFERENCE-NODE](/he/grammar/edge/reference-node/), [SAME-NODE](/he/grammar/edge/same-node/)
- [Reference](/he/grammar/reference/), [LOCAL](/he/grammar/reference/local/)
