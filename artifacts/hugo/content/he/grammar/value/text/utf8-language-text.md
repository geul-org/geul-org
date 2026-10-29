---
title: "UTF8-LANGUAGE-TEXT"
weight: 75
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-30T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "UTF8-LANGUAGE-TEXT הוא טקסט עם שפה, שמכיל רשומת Value אחת של שפה וטקסט UTF-8 ב-Value אחד (Codec 0x4A/0x4B)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UTF8-LANGUAGE-TEXT הוא טקסט עם שפה. הוא מכיל רשומת Value אחת של שפה ורצף בייטים של UTF-8 ב-Value אחד.

[UTF8-TEXT](/he/grammar/value/text/utf8-text/) הוא מחרוזת בלי שפה (מזהה, קוד, שם קובץ, בייטים של טקסט מקורי), והפורמט הזה הוא טקסט עם שפה (שם, כותרת, סיסמה, משפט). גם כשהבייטים זהים, אלה ערכים שונים. "Paris" (מחרוזת) ו-"Paris" (בצרפתית) אינם זהים. זה כמו ש-RDF מבחין בין `xsd:string` ל-`rdf:langString`.

## פריסה

- קוד: קוד ישיר של Value `0x4A` (בייטי הטקסט במספר זוגי) ו-`0x4B` (בייטי הטקסט במספר אי-זוגי). משפחה TEXT.

```
TAG WORD          0000 1LLL L100 101P      Codec 0x4A/0x4B (P = הטקסט במספר אי-זוגי של בייטים)
[Length extension TAG] כשהכול 15 WORD ומעלה
Language          רשומת Value אחת של LANGUAGE-SHORT-CODE או LANGUAGE-BCP47-CODE (כולל TAG)
Text WORD 1st ... Nth             UTF-8 bytes / אם אי-זוגי, 0x00 בסוף
```

## פירוש ותקינות

- ה-Payload מתחיל ברשומת השפה. קוראים את ה-WORD הראשון של ה-Payload כ-TAG, ולפי ה-Length שלו נקבעת רשומת השפה, והשאר הוא בייטי הטקסט. רשומת השפה היא חובה. אם אין שפה, משתמשים ב-UTF8-TEXT ולא בפורמט הזה.
- רשומת השפה היא רשומת [LANGUAGE-SHORT-CODE](/he/grammar/value/text/language-short-code/) (`0x48`) או [LANGUAGE-BCP47-CODE](/he/grammar/value/text/language-bcp47-code/) (`0x46`·`0x47`) שלמה אחת בדיוק. Codec אחר או רשומה שאינה שלמה הם invalid. תקינות רשומת השפה היא לפי כללי הפורמט שלה.
- אפשר להשתמש בשני פורמטי השפה. כלל ההשוואה אם זו אותה שפה זהה ל-[LABEL](/he/grammar/edge/label/). SHORT-CODE ו-tag של BCP 47 שהרישום קשר למספר שלו הם אותה שפה.
- לא משתמשים ב-`zxx` (אין תוכן לשוני). מחרוזת כזו היא UTF8-TEXT. `und` (שפה לא מוכרעת) ו-`mul` (כמה שפות) הם טקסט עם שפה ולכן מותר להשתמש בהם.
- בייטי הטקסט עוקבים אחרי אותם כללים כמו UTF8-TEXT. חייב להיות UTF-8 תקין, U+FEFF בהתחלה מותר כתו, לא כופים נרמול והטקסט נשמר כמות שהוא במקור. הצד שמשווה ומאנדקס משווה לאחר נרמול ל-NFC.
- מספר בייטי הטקסט הוא `2 × (מספר ה-WORD של ה-Payload − מספר ה-WORD של רשומת השפה) − P`. P (הביט התחתון ביותר של ה-Codec) מציין רק אם בייטי הטקסט במספר זוגי או אי-זוגי. אם אי-זוגי, הבייט התחתון של ה-WORD האחרון חייב להיות `00`.
- טקסט ריק (0 בייטים) הוא Codec זוגי עם רשומת שפה בלבד.

## איפה משתמשים

- ערך monolingualtext של Wikidata: ‏`{"text":"Bundesrepublik Deutschland","language":"de"}` הופך לפורמט אחד זה. הוא נכנס כמות שהוא ל-Object של [TRIPLE](/he/grammar/edge/triple/) ול-Value של [QUALIFIER](/he/grammar/edge/qualifier/). המאפיין, ה-rank וה-qualifier הם באחריות ה-TRIPLE.
- ה-Object של [LABEL](/he/grammar/edge/label/) ו-[ALIAS](/he/grammar/edge/alias/). הערך הזה מכיל את השם ואת השפה.
- טקסט ששפתו נקבעה, כמו שם של חקיקה או של מאמר.

## התאמת קודי שפה (Wikidata)

- לא כל קודי השפה של Wikidata ושל Wikimedia הם BCP 47 (למשל `simple`, `map-bms`). מעבירים אותם ל-tag של BCP 47 בטבלת התאמה. קוד שאי אפשר להעביר מטופל בדרך שונה לפי השימוש.
  - ערך (monolingualtext): שומרים את הטקסט המקורי של datavalue כ-UTF8-TEXT. הערך הוא חלק מהטענה, ואם זורקים אותו הטענה משתנה.
  - label, תיאור וכינוי: מדלגים ורושמים בדוח. ה-Edge האלה תקפות רק עם שפה (טקסט בלי שפה הוא invalid), והטקסט המקורי נשאר בנתוני המקור.
- אם ל-tag שהתקבל יש מספר ב-GEUL Language Registry, משתמשים ב-LANGUAGE-SHORT-CODE; אחרת ב-LANGUAGE-BCP47-CODE.

## אורך

- הסך הכול הוא מספר ה-WORD של TAG אחד, TAG הרחבת Length (אם יש), רשומת השפה ו-WORD הטקסט. עד 14 WORD משתמשים באורך ישיר, ומ-15 WORD ומעלה באורך מורחב ([Length](/he/grammar/record/)).
- רשומת השפה היא 2 WORD אם SHORT-CODE, ו-`ceil(בייטי tag/2) + 1` WORD אם BCP 47 (`de` 2 WORD, `zh-Hant` 5 WORD).

## דוגמה

כל השפות כאן הן דוגמאות לפורמט LANGUAGE-BCP47-CODE. ל-`fr`, ‏`ko` ו-`de` יש מספרי רישום, ולכן אפשר לכתוב אותן גם כ-SHORT-CODE ‏(2 WORD).

| ערך | בייטי הטקסט | כל ה-WORD |
|---|---|---|
| "Paris" (fr) | 5 (אי-זוגי) | `0ACB 08C6 6672 5061 7269 7300` |
| "" (ko) | 0 | `094A 08C6 6B6F` |
| "Bundesrepublik Deutschland" (de) | 26 (זוגי) | `0F4A 0011 08C6 6465 4275 6E64 6573 7265 7075 626C 696B 2044 6575 7473 6368 6C61 6E64` |

- "Paris": TAG ‏`0ACB` (Codec `0x4B`, `LLLL=0101`, 6 WORD בסך הכול), שפה `08C6 6672` (BCP 47 ‏`fr`), טקסט `5061 7269 7300` (5 בייטים, `00` בסוף).
- השלישי הוא 17 WORD בסך הכול ולכן משתמש בהרחבת Length (`LLLL=1110` של `0F4A`, TAG הרחבה `0011`).

## בסיס בתקנים

- language tag: [RFC 5646 (BCP 47)](https://www.rfc-editor.org/rfc/rfc5646). ‏`zxx`·`und`·`mul` הם קודי special של IANA Language Subtag Registry.
- טקסט: [RFC 3629](https://www.rfc-editor.org/rfc/rfc3629).
- ההבחנה בין מחרוזת לטקסט עם שפה: [RDF 1.1 Concepts — language-tagged string](https://www.w3.org/TR/rdf11-concepts/#dfn-language-tagged-string).

## שאלות פתוחות

- בדיקת הדקדוק של BCP 47 tag ב-schema. כרגע בודקים רק שהוא ASCII ושאינו ריק.

## דפים קשורים

- [Value](/he/grammar/value/), [UTF8-TEXT](/he/grammar/value/text/utf8-text/), [LANGUAGE-SHORT-CODE](/he/grammar/value/text/language-short-code/), [LANGUAGE-BCP47-CODE](/he/grammar/value/text/language-bcp47-code/), [LABEL](/he/grammar/edge/label/)
