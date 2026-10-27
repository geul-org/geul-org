---
title: "EDTF"
weight: 37
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "EDTF הוא Value שמכיל מחרוזת תאריך מורחבת של ISO 8601-2 לתאריכים כמו דיוק של שנה או חודש, לפני הספירה, אי-ודאות וקטע (Codec 0x24/0x25)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EDTF הוא Value שמכיל תאריך כמחרוזת [Extended Date/Time Format](https://www.loc.gov/standards/datetime/edtf.html) (ספריית הקונגרס של ארה"ב, ISO 8601-2:2019). הוא מבטא דיוק גס מיום, לפני הספירה, אי-ודאות·קירוב·ידיעה חלקית, וקטעים.

## פריסה

- קוד: קוד ישיר של Value `0x24` (מספר זוגי של בייטים) ו-`0x25` (מספר אי-זוגי). משפחה TIME. ה-Payload הוא מחרוזת, אך הוא ממוקם במשפחת TIME כדי שמפענח ואינדקס יתייחסו אליו כערך זמן גם בלי להכיר את הפורמט.
- מספר הבייטים נקבע לפי הביט התחתון ביותר של ה-Codec ומספר ה-WORD של ה-Payload. הוא `2 × מספר ה-WORD של ה-Payload − הביט התחתון ביותר`, ואין Byte Count ([Value](/he/grammar/value/)).

```
TAG WORD          0000 1LLL L010 010P      Codec 0x24/0x25 (P = מספר אי-זוגי של בייטים)
[Length extension TAG] כשהכול 15 WORD ומעלה
Payload WORD 1st ... Nth          בייטי ASCII של מחרוזת EDTF / אם אי-זוגי, 0x00 בסוף
```

## פירוש ותקינות

- רצף הבייטים הוא מחרוזת ASCII לפי הדקדוק של EDTF ברמות 0, 1 ו-2. מחרוזת ריקה היא invalid.
- דוגמאות: יום `1952-03-11`, חודש `1952-03`, שנה `1952`, עשור `195X`, 44 לפני הספירה `-0043`, אי-ודאות `1974?`, קירוב `~1974`, קטע `1952/2001`, שנה גדולה `Y-13799999999`.
- השנה היא לפי ISO 8601 האסטרונומי. `0000` היא 1 לפני הספירה, ו-`-0043` היא 44 לפני הספירה. כשמעבירים מכתיב היסטורי, מזיזים שנה אחת.
- הלוח הוא גרגוריאני. EDTF אינו עוסק בלוחות אחרים. כתיב מקורי של לוח אחר כמו היוליאני נשמר ב-[GEDCOM-DATE](/he/grammar/value/time/gedcom-date/). ערך שהעביר את אותו יום או תקופה ללוח הגרגוריאני אפשר לכתוב ב-EDTF או ב-GREGORIAN-DATE.
- **צורה קנונית:** תאריך שאפשר לכתוב במדויק ב-[GREGORIAN-DATE](/he/grammar/value/time/gregorian-date/), כלומר `[-]YYYY-MM-DD` בלי מציין (`?`, `~`, `%`), בלי ספרות לא ידועות (`X`), בלי קטע ובלי תחילית `Y`, נכתב ב-GREGORIAN-DATE. כתיבה של תאריך כזה ב-EDTF היא invalid. רק כשאותו יום נכתב בפורמט אחד אפשר לאנדקס ולהשוות אותו כזמן.
- ה-schema עדיין אינו בודק את הדקדוק של EDTF. היצרן בודק באמצעות מנתח EDTF. למשל `parser.ParseString` של `github.com/sfomuseum/go-edtf` (BSD-3-Clause). לא משתמשים ב-`parser.IsValid`, כי הוא בודק רק את הדקדוק ומעביר גם `2023-02-29` ו-`1974-13`. המנתח הזה עדיין לא תומך בשנה עם תחילית `Y`.

## אורך

- הסך הכול הוא מספר ה-WORD של TAG אחד, TAG הרחבת Length (אם יש) וה-Payload ([Length](/he/grammar/record/)).

## דוגמה

| תאריך | בייטים | כל ה-WORD |
|---|---|---|
| `1974` | 4 (זוגי) | `0924 3139 3734` |
| `197X` | 4 (זוגי) | `0924 3139 3758` |
| `1952-03` | 7 (אי-זוגי) | `0A25 3139 3532 2d30 3300` |

## בסיס בתקנים

- [Library of Congress, Extended Date/Time Format (EDTF) Specification](https://www.loc.gov/standards/datetime/edtf.html). רמה 0 היא תת-קבוצה של ISO 8601-1, ורמות 1 ו-2 הן יכולות של ISO 8601-2.
- ב-RDF אותה מחרוזת מסומנת בטיפוס הנתונים `http://id.loc.gov/datatypes/edtf`.

## שאלות פתוחות

- בדיקת הדקדוק של EDTF בבודק (האם הבודק נשען על ספרייה חיצונית).
- הכלל להעברת דיוק של מאה ואלף שנים ב-Wikidata לספרות לא ידועות של EDTF.

## דפים קשורים

- [Value](/he/grammar/value/), [GREGORIAN-DATE](/he/grammar/value/time/gregorian-date/), [GEDCOM-DATE](/he/grammar/value/time/gedcom-date/)
