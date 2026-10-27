---
title: "SOURCE וחלוקה"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "פורמטי ISSUER של GEUL, 0xC000~0xC005, שבהם נכתבים טקסט המקור של מסמך TOULMIN (SOURCE), מחרוזות (TEXT), חלוקה לסעיפים ולמקרים (SECTION, CASE-BEGIN, CASE-END) ופסקאות תיאור (PROSE)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

אלה הרשומות שבהן נכתבים הטקסט המקורי והחלוקה של מסמך TOULMIN. כולן Edge שמשתמשות במספר פורמט תחת `ISSUER-1WORD` (`0x7C`) ו-Issuer `0x0000` (GEUL) ([TOULMIN](/he/grammar/edge/toulmin/#פורמט-issuer)).

## פורמטים

| מספר פורמט | שם | פריסה |
|---|---|---|
| `0xC000` | SOURCE | ID, WORD של רוחב SPAN, Value של UTF8 |
| `0xC001` | TEXT | ID, Value של UTF8 |
| `0xC002` | SECTION | ID, קוד סעיף של WORD אחד |
| `0xC003` | CASE-BEGIN | ID, REF (מקרה) |
| `0xC004` | CASE-END | ID, REF (מקרה) |
| `0xC005` | PROSE | ID, SPAN |

- ID הוא Edge Id, ו-REF הוא Edge Id של רשומה במסמך הזה ([TOULMIN](/he/grammar/edge/toulmin/#שדות-משותפים), שדות משותפים).
- Value של UTF8 הוא רשומת Value מסוג [UTF8-TEXT](/he/grammar/value/text/utf8-text/). הבייטים נשמרים כמות שהם.

## SOURCE

זהו טקסט המקור כולו של הכותב. כל SPAN הוא טווח בייטים בתוך הטקסט המקורי הזה.

```
ID
WORD רוחב SPAN   2 ביטים עליונים = רוחב (00=1, 01=2, 10=4, 11=8 WORD), 14 הביטים הנותרים = 0
טקסט מקור        רשומת Value מסוג UTF8-TEXT
```

- SOURCE היא הרשומה הראשונה ב-BODY. יש אחת במסמך.
- SPAN הוא שני שדות: בייט התחלה ומספר בייטים. כל שדה הוא מספר שלם unsigned ברוחב ש-WORD רוחב ה-SPAN קובע (1/2/4/8 WORD).

## TEXT

שם או מחרוזת אחת. הרשימות F_WITH ו-F_GROUNDS של NODE, וכן LABEL ו-IMPORTED-FROM של LINK, מצביעים עליה ב-REF.

## SECTION

תחילת סעיף. קוד הסעיף הוא WORD אחד.

| קוד | סעיף | TANGEUL |
|---|---|---|
| 1 | Subject | `this document is x` |
| 2 | See | `see a from path` |
| 3 | Definitions | `means`, `has` |
| 4 | Rules | כללי ביטוי תנאי |
| 5 | Cases | `in case of x` |
| 6 | Provides | `provides x` |
| 7 | Internal | `on`, `every` |

- `0` אינו בשימוש. הסעיפים מוצהרים לפי סדר הקודים האלה.
- כותרת הסעיף היא ה-PROSE שמיד אחרי ה-SECTION.

## CASE-BEGIN, CASE-END

- טווח המקרה הוא בין CASE-BEGIN ל-CASE-END שמצביעים על אותו מקרה (NODE של CASE-DECLARE).

## PROSE

פסקת תיאור שאינה כלל. היא מצביעה רק על טווח הטקסט המקורי (SPAN).

## דפים קשורים

- [TOULMIN](/he/grammar/edge/toulmin/), [NODE](/he/grammar/edge/toulmin/node/), [LINK](/he/grammar/edge/toulmin/link/)
