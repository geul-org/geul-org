---
title: "DESCRIPTION"
weight: 7
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T23:00:00+09:00
tags: ["grammar", "edge"]
summary: "DESCRIPTION היא Edge תיאורית שמקשרת תיאור קצר אחד בשפה מסוימת ליעד ה-Subject (Codec 0x06). הפריסה זהה ל-LABEL."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIPTION היא Edge תיאורית שמקשרת תיאור אחד בשפה מסוימת של יעד ה-Subject בתור Object. Codec `0x06`.

התיאור הוא ביטוי קצר שמבחין את היעד (description ב-Wikidata, למשל: "בירת גרמניה והעיר הגדולה בה"). הוא אינו הגדרה של היעד ואינו טענה. טענות על היעד נכתבות כ-[TRIPLE](/he/grammar/edge/triple/). הפריסה זהה ל-[LABEL](/he/grammar/edge/label/). התיאור והשפה שלו נשמרים ב-Object אחד, [UTF8-LANGUAGE-TEXT](/he/grammar/value/text/utf8-language-text/). אין שדות גולמיים.

## פריסה

```
TAG WORD          0001 0LLL L000 0110
[Length extension TAG]
Edge Id           רשומת LOCAL Reference
Subject           רשומת Reference אחת
Object            Value מסוג UTF8-LANGUAGE-TEXT או רשומת LOCAL Reference אחת
```

## פירוש ותקינות

- הכללים של Subject ו-Object זהים ל-[LABEL](/he/grammar/edge/label/). ה-Subject הוא בדיוק רשומת Reference שלמה אחת. ה-Object הוא בדיוק רשומת UTF8-LANGUAGE-TEXT שלמה אחת (`0x4A`, `0x4B`), או LOCAL Reference שנפתר ל-UTF8-LANGUAGE-TEXT באמצעות קשירת [REFERENCE-NODE](/he/grammar/edge/reference-node/) באותו מסמך.
- טקסט ללא שפה (UTF8-TEXT) אינו יכול להיות DESCRIPTION. יש תיאור אחד לכל שפה, ולכן הכלל מתקיים רק כשיש שפה. תיאור משותף לכמה שפות נכתב בשפה `mul`.
- לכל היותר DESCRIPTION אחד לכל Subject ושפה.
- התיאור משמש להבחנה מיעד אחר בעל אותו שם. עדיף שזוג LABEL ו-DESCRIPTION באותה שפה לא יחזור בשני יעדים, אך המפרט אינו בודק זאת (גם ב-Wikidata זו המלצה בלבד ולא נאכפת).
- מסמך המפרט של geul.org מגביל את ה-Object ל-[CODEC](/he/grammar/edge/codec/) (`084A`, `084B`, `0008`, כמו ב-LABEL).

## אורך

```
סה"כ = 1 + N_len + N_id + N_subject + N_object WORD
```

- רשומת השפה של ה-Object ומספר בייטי הטקסט הם באחריות רשומת ה-Object. הסמן אחרי קריאת הרשומה האחרונה חייב להתלכד בדיוק עם סוף ה-Edge.
- תיאור ארוך מ-label, ולכן קל ש-Object וגם ה-Edge יחרגו מ-15 WORD. אז משתמשים ב-Length extension ([רשומה](/he/grammar/record/)).

## דוגמה (לא נורמטיבית)

Edge Id `0009`, Subject Q64 (`00A0 0040`), Object `capital and largest city of Germany` (en). השפה היא דוגמה לפורמט LANGUAGE-BCP47-CODE (ל-`en` יש מספר רישום `0x0784`, ולכן אפשר לכתוב אותה גם כ-SHORT-CODE).

- ה-Object הוא שפה `08C6 656E` (BCP47 `en`, 2 WORD) + טקסט של 35 בייטים (אי-זוגי, 18 WORD), ולכן `0x4B`, TAG 1 + extension TAG 1 + 20 = 22 WORD, כלומר `0F4B 0016 …`.
- ה-Edge היא TAG 1 + extension TAG 1 + Edge Id 2 + Subject 2 + Object 22 = 28 WORD, כלומר `LLLL=1110`, TAG `1706`, extension TAG `001C`.

```
1706 001C 0088 0009 00A0 0040
0F4B 0016 08C6 656E 6361 7069 7461 6C20 616E 6420 6C61 7267 6573 7420 6369 7479 206F 6620 4765 726D 616E 7900
```

## התאמה ל-Wikidata

- `descriptions` של פריט (אחד לכל שפה) → DESCRIPTION אחד לכל שפה. קוד השפה מומר לפי אותה טבלת התאמה של קודי שפה כמו ב-LABEL.

## שאלות פתוחות

- האם יש מקרים שבהם כדאי להתיר תיאור UTF8-TEXT ללא שפה (כרגע אינו מותר).

## דפים קשורים

- [Edge](/he/grammar/edge/), [LABEL](/he/grammar/edge/label/), [ALIAS](/he/grammar/edge/alias/), [CODEC](/he/grammar/edge/codec/)
- [UTF8-LANGUAGE-TEXT](/he/grammar/value/text/utf8-language-text/), [LOCAL](/he/grammar/reference/local/), [REFERENCE-NODE](/he/grammar/edge/reference-node/)
