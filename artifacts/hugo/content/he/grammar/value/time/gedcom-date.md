---
title: "GEDCOM-DATE"
weight: 39
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GEDCOM-DATE הוא Value שמכיל מחרוזת ערך תאריך של GEDCOM 7 ושומר כמות שהוא תאריך בלוח שנה אחר כמו היוליאני (Codec 0x26/0x27)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEDCOM-DATE הוא Value שמכיל מחרוזת ערך תאריך (`DateValue`) של [GEDCOM 7](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html) (FamilySearch). הוא שומר **כפי שנכתב** תאריך שהמקור כתב בלוח שאינו גרגוריאני (יוליאני וכד').

## פריסה

- קוד: קוד ישיר של Value `0x26` (מספר זוגי של בייטים) ו-`0x27` (מספר אי-זוגי). משפחה TIME.
- מספר הבייטים נקבע לפי הביט התחתון ביותר של ה-Codec ומספר ה-WORD של ה-Payload. הוא `2 × מספר ה-WORD של ה-Payload − הביט התחתון ביותר`, ואין Byte Count ([Value](/he/grammar/value/)).

```
TAG WORD          0000 1LLL L010 011P      Codec 0x26/0x27 (P = מספר אי-זוגי של בייטים)
[Length extension TAG] כשהכול 15 WORD ומעלה
Payload WORD 1st ... Nth          בייטי ASCII של מחרוזת תאריך GEDCOM / אם אי-זוגי, 0x00 בסוף
```

## פירוש ותקינות

- רצף הבייטים הוא מחרוזת ASCII לפי הדקדוק `DateValue` של GEDCOM 7. מחרוזת ריקה היא invalid. GEDCOM מתירה `DateValue` ריק, אך כשאין ערך לא כותבים את הרשומה.
- עיקרי הדקדוק: `[לוח] [[יום] חודש] שנה [BCE]`. לפניו אפשר להוסיף `ABT`·`CAL`·`EST` (בקירוב), `BEF`·`AFT`·`BET … AND …` (טווח) ו-`FROM … TO …` (תקופה). המפריד הוא רווח אחד.
- לוחות: `GREGORIAN` (ברירת מחדל אם משמיטים), `JULIAN`, `FRENCH_R`, `HEBREW`, ותגי הרחבה. שמות החודשים נקבעים לפי הלוח (הלוח היוליאני משתמש באותם `JAN`…`DEC` כמו הגרגוריאני).
- השנה היא בכתיב **היסטורי**. אין שנה 0, ולפני הספירה מוסיפים `BCE` (`44 BCE` = 44 לפני הספירה). יש הפרש של שנה מהכתיב האסטרונומי של EDTF ושל GREGORIAN-DATE.
- ה-schema בודק רק את פורמט הבייטים: ASCII ‏`0x20`~`0x7E`, לא ריק, בלי רווחים בתחילה ובסוף. את הדקדוק ואת קיומו של היום בפועל בודק היצרן. למשל `gedcom.ParseDate` של `github.com/cacack/gedcom-go/v3` (MIT). ‏`Validate` של הספרייה הזו בודקת יום רק בלוח הגרגוריאני ולכן מעבירה `JULIAN 30 FEB 1100`, ו-`ToGregorian` אינה ממירה בפועל דיוק של שנה·חודש. בדיקת הקיום של התאריך והנרמול נעשים בנפרד.
- **איפה משתמשים:** תאריך בלוח הגרגוריאני נכתב ב-[GREGORIAN-DATE](/he/grammar/value/time/gregorian-date/) או ב-[EDTF](/he/grammar/value/time/edtf/). GEDCOM-DATE משמש לתאריך בלוח אחר שחייבים לשמור בו את הכתיב המקורי.

## שימוש יחד עם ערך מנורמל

- כדי להשוות ולאנדקס את אותו תאריך על ציר הזמן, דרוש ערך בלוח הגרגוריאני. בדיוק של יום ההתאמה המדויקת היא GREGORIAN-DATE של אותו יום, ובדיוק של שנה·חודש היא EDTF של קטע בלוח הגרגוריאני שמתאים לתקופה (`JULIAN 1300` → `1300-01-09/1301-01-08`).
- הדרך לשמור יחד, כשני Value, את הכתיב המקורי (GEDCOM-DATE) ואת הערך המנורמל טרם נקבעה (שאלה פתוחה).

## אורך

- הסך הכול הוא מספר ה-WORD של TAG אחד, TAG הרחבת Length (אם יש) וה-Payload ([Length](/he/grammar/record/)).

## דוגמה

| תאריך | בייטים | כל ה-WORD |
|---|---|---|
| `JULIAN 1300` | 11 (אי-זוגי) | `0B27 4a55 4c49 414e 2031 3330 3000` |

## בסיס בתקנים

- [FamilySearch GEDCOM 7, Data types — Date](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html#date), [Appendix A: Calendars and Dates](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html#A-calendars). הרישיון של מאגר המפרט הוא Apache 2.0. GEUL מתייחסת לפורמט בלבד ואינה מעתיקה את גוף המפרט.
- ב-ISO 8601, EDTF, XSD ובמזהי הלוח של CLDR ‏(`u-ca`) אין לוח יוליאני. GEDCOM 7 הוא פורמט החלפה פומבי שמטפל בתחילית לוח, לפני הספירה, דיוק ומציינים בדקדוק אחד.

## שאלות פתוחות

- איך כותבים יחד את הכתיב המקורי ואת הערך המנורמל (איך מקשרים את השניים ב-TRIPLE אחת).
- בדיקת הדקדוק של GEDCOM ב-schema.
- דיוק של מאה ועשור. ל-GEDCOM אין פורמט כזה. תאריך מ-Wikidata שאי אפשר להעביר נשמר בטקסט המקורי ב-UTF8-TEXT.

## דפים קשורים

- [Value](/he/grammar/value/), [EDTF](/he/grammar/value/time/edtf/), [GREGORIAN-DATE](/he/grammar/value/time/gregorian-date/)
