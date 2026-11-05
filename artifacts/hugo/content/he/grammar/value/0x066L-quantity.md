---
title: "QUANTITY (0x066L)"
weight: 102
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "QUANTITY הוא Value המייצג כמות אחת באמצעות מספר, יחידה, גבול תחתון וגבול עליון."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `QUANTITY` (מסמך מפרט BIND `QUANTITY`) |
| TAG ID | `0x066L` |
| Codec ID | `0x00000660` |
| מסמך מפרט | `0x00000000/codecs/0x00000660/` (יעד DECLARE `0660`) |
| קטע | 3 `0011` (Value), היסט בתוך הקטע C = 6 |
| Kind | Value · משפחה: NUMERIC |
| TAG WORD | `0000 0110 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | amount כ-Value מספרי (מספר שלם, BINARY-FLOAT, מספר עשרוני, שבר), Reference של יחידה, גבול תחתון וגבול עליון. אפשר להשמיט יחידה וגבולות (ABSENT `0x0000`) |
| בצד Hugo | `value/numeric/quantity.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD במסמך הוא סדר שדות ה-Payload ([מסמך המפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `amount` | #2 | רשומה | `0680` SIGNED-DECIMAL, `0610` SIGNED-INTEGER, `0620` UNSIGNED-INTEGER, `0630` BINARY-FLOAT, `0670` FRACTION, `0690` UNSIGNED-DECIMAL |  |
| 2 | `unit` | #3 | רשומה | `000F` כל קטע 0 (תו כללי, Reference), `020F` כל קטע 1 (תו כללי, Reference), `040F` כל קטע 2 (תו כללי, Reference), `0000` ABSENT (שדה אופציונלי) |  |
| 3 | `lower` | #4 | רשומה | `0680` SIGNED-DECIMAL, `0000` ABSENT (שדה אופציונלי), `0610` SIGNED-INTEGER, `0620` UNSIGNED-INTEGER, `0630` BINARY-FLOAT, `0670` FRACTION, `0690` UNSIGNED-DECIMAL |  |
| 4 | `upper` | #5 | רשומה | `0680` SIGNED-DECIMAL, `0000` ABSENT (שדה אופציונלי), `0610` SIGNED-INTEGER, `0620` UNSIGNED-INTEGER, `0630` BINARY-FLOAT, `0670` FRACTION, `0690` UNSIGNED-DECIMAL |  |

QUANTITY הוא Value המייצג כמות אחת באמצעות מספר, יחידה, גבול תחתון וגבול עליון. קוד ישיר של Value הוא `0x066L`, משפחה NUMERIC. כל אחד מארבעת החלקים הוא רשומה שלמה. היחידה והגבולות הם [שדות אופציונליים](../codec-spec.md), ולכן אם משמיטים אותם כותבים ABSENT (`0x0000`).

## פריסה {#레이아웃}

```
TAG WORD          0000 0110 0110 LLLL      Codec 0x066L
[TAG הרחבת Length] כאשר הסך הכול 15 WORD ומעלה
amount            רשומת Value מספרי (מספר שלם, BINARY-FLOAT, מספר עשרוני, שבר)
unit              רשומת Reference (פריט יחידה), 0x0000 אם אין יחידה
lower             רשומת Value מספרי, אם משמיטים 0x0000 ABSENT
upper             רשומת Value מספרי, אם משמיטים 0x0000 ABSENT
```

## פירוש ותוקף {#해석과-유효성}

- amount הוא רשומת Value מספרי שלמה אחת. ה-Codec המתקבלים הם שישה: [SIGNED-INTEGER](0x061L-signed-integer.md) (`0x061L`), [UNSIGNED-INTEGER](0x062L-unsigned-integer.md) (`0x062L`), [BINARY-FLOAT](0x063L-binary-float.md) (`0x063L`), [FRACTION](0x067L-fraction.md) (`0x067L`), [SIGNED-DECIMAL](0x068L-signed-decimal.md) (`0x068L`), [UNSIGNED-DECIMAL](0x069L-unsigned-decimal.md) (`0x069L`). זוהי רשימה סגורה ולא תו כללי. BOOL, COORDINATE-EARTH ו-COORDINATE-GEO, QUANTITY עצמו (אין קינון, העומק קבוע) ו-Value אחרים אינם מתקבלים. ב-amount אי אפשר לכתוב סמן מקום (`0x0000` וכד').
- גם הרשומות הפנימיות כפופות לצורה הקנונית של כל Codec (מספר שלם ו-coefficient ב-WORD מינימלי, BINARY-FLOAT ב-1/2/4/8 WORD, FRACTION לפי כלליו). אם יש רשומה פנימית שאינה קנונית, QUANTITY כולו invalid.
- אם amount, lower או upper הם BINARY-FLOAT, הערך חייב להיות סופי. NaN ו-±Infinity הם invalid (אותו כלל כמו קו הרוחב וקו האורך ב-[COORDINATE-EARTH](0x064L-coordinate-earth.md)).
- פורמט המספר עוקב אחר הרישום המקורי. טקסט מקורי של מספר שלם נשמר כ-INTEGER, של מספר עשרוני כ-DECIMAL, של שבר כ-FRACTION, וערך binary של IEEE 754 כ-BINARY-FLOAT, והמקודד אינו מנרמל על ידי החלפת פורמט. ה-C וה-E של DECIMAL שומרים את מספר הספרות של הרישום המקורי כמות שהוא: `1.20` = `120×10^-2`, `1.2` = `12×10^-1`. שני הערכים הם אותו מספר, אך מספר הספרות significant שונה, ולכן הם Value שונים. אין גבול עליון למספר הספרות של המספר השלם ושל ה-coefficient (WORD מינימלי, אורך משתנה).
- unit הוא רשומת Reference שלמה אחת בדיוק, או `0x0000`. אפשר להשתמש בכל Reference המצביע על פריט יחידה (יחידה בוויקינתונים היא WIKIDATA-QID). `0x0000` פירושו ללא יחידה (מניין, יחס, אוכלוסייה וכד').
- כל אחד מ-lower ו-upper הוא רשומה מאחד מששת ה-Codec שמקבל amount, או `0x0000` ABSENT. סמן המקום מקבל רק השמטה ב-ABSENT. מותר שיהיה רק אחד מהשניים. ה-Codec של שלושת המספרים אינו חייב להיות זהה.
- lower ≤ amount ≤ upper נבדק לפי הערך המספרי, לא לפי בתים או Codec. משווים כמספרים גם כשהטיפוסים שונים (למשל SIGNED-INTEGER `652` ו-SIGNED-DECIMAL `651.5`). FRACTION מושווה כמספר רציונלי מדויק. גם טווח סימטרי (`652 ± 1`) נכתב בשני גבולות, תחתון ועליון (`651`, `653`). מכיוון שבכל מקרה נדרשים שני ערכים בשל טווחים א-סימטריים, אין פורמט המצמצם אותם ל-± אחד.
- היחידה היא חלק מהערך. אין להפריד את היחידה ל-QUALIFIER וכד' (לאחר ההפרדה לא ניתן לדעת אם `652` הוא ק"מ או מטר).
- רשומת amount שחולצה היא רשומת Value עצמאית כמות שהיא. אם נדרש המספר בלי היחידה, משתמשים ברשומה זו ולא מקודדים מחדש.
- ערך שהומר ליחידות SI אינו נשמר. זהו ערך נגזר שאפשר לחשב מהיחידה ומטבלת ההמרה.
- הסמן שקרא את ארבע הרשומות חייב להתיישר בדיוק עם סוף ה-Payload. כל צורה אחרת היא invalid.
- מסמך המפרט של geul.org רושם ארבעה שדות רשומה: amount (`0610`, `0620`, `0630`, `0670`, `0680`, `0690`), unit (`000F`, `020F`, `040F`, `0000`), lower ו-upper (`0610`, `0620`, `0630`, `0670`, `0680`, `0690`, `0000`) ([מסמך המפרט של Codec](../codec-spec.md)).

## אורך {#길이}

- הסך הכול הוא TAG אחד + (TAG הרחבת Length) + ארבע רשומות. רשומת מספר שלם היא TAG אחד + Payload של WORD אחד ומעלה, רשומת BINARY-FLOAT היא 2, 3, 5 או 9 WORD, רשומת מספר עשרוני היא TAG אחד + מעריך 2 + coefficient של WORD אחד ומעלה, ורשומת FRACTION היא 5 WORD ומעלה.
- מספר שלם קטן ללא יחידה וללא גבולות הוא 6 WORD, ומספר עשרוני קטן הוא 8 WORD. מ-15 WORD ומעלה משתמשים באורך מורחב ([רשומה ו-TAG WORD](../record.md)).

## דוגמה {#예시}

`1.20` ללא יחידה:

```
0667 0683 FFFF FFFE 0078 0000 0000 0000
```

- TAG `0667` (Codec `0x066L`, 8 WORD), amount `0683 FFFF FFFE 0078` (E = -2, C = 120), unit, lower ו-upper הם `0000`.

מספר שלם `42` ללא יחידה:

```
0665 0611 002A 0000 0000 0000
```

- TAG `0665` (6 WORD), amount `0611 002A` (SIGNED-INTEGER 42), unit, lower ו-upper הם `0000`.

שבר `2/3` ללא יחידה (שני שלישים מזכויות ההצבעה של הנוכחים):

```
0668 0674 0611 0002 0621 0003 0000 0000 0000
```

- TAG `0668` (9 WORD), amount `0674 0611 0002 0621 0003` ([FRACTION](0x067L-fraction.md) 2/3), unit, lower ו-upper הם `0000`.

`652 km`, טווח `[651, 653]` (km = Q828224):

```
066E 0011
0683 0000 0000 028C
0142 000C A340
0683 0000 0000 028B
0683 0000 0000 028D
```

- סך הכול 17 WORD, ולכן `LLLL=1110`, ו-TAG ההרחבה הוא `0011`.

## התאמה לוויקינתונים {#위키데이터-대응}

- datavalue מסוג `quantity` בצורה `{"amount","unit","lowerBound","upperBound"}` → amount, unit, lower, upper. מחרוזות amount והגבולות (`+1.20`, כולל רישום מעריכי) מועברות ל-C ול-E כפי שהן, בלי לשנות את מספר הספרות.
- amount והגבולות בוויקינתונים הם מחרוזות עשרוניות, ולכן גם אם הן נראות כמספר שלם (`+652`) הן מועברות כ-SIGNED-DECIMAL. ההמרה מוויקינתונים אינה משתמשת ב-Codec מספרי אחר.
- unit `"1"` פירושו ללא יחידה (`0x0000`), ו-`http://www.wikidata.org/entity/Qn` הוא WIKIDATA-QID. יחידות אחרות, ומספרים או גבולות שאינם בפורמט המתאים, אינם מומרים והטקסט המקורי נשמר ב-UTF8-TEXT.
- מדגם ויקינתונים (כ-42 אלף quantity בתחילת הדמפ): 61% ללא יחידה, 13% עם גבולות (מהם 93% סימטריים), amount הארוך ביותר 31 תווים.

## בסיס תקני {#표준-근거}

- רישום עשרוני ושמירת מספר הספרות: מושגי coefficient, exponent ו-quantum של decimal ב-[IEEE 754-2008](https://standards.ieee.org/ieee/754/6210/) (SIGNED-DECIMAL של GEUL).
- מודל הכמות בוויקינתונים: `QuantityValue` של Wikibase DataModel.

## דפים קשורים {#관련-페이지}

- [Value](_index.md), [SIGNED-DECIMAL](0x068L-signed-decimal.md), [COORDINATE-GEO](0x065L-coordinate-geo.md), [CODEC](../edge/0x0BEL-codec.md), [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md)

## הטקסט המקורי של מסמך המפרט {#규격-문서-원문}

זהו מסמך המפרט `0x00000000/codecs/0x00000660/latest.geul` כפי שהוא נקרא באמצעות `geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000066000000000
BODY
#1 DECLARE 0x0660
#2 FIELD #1 record
#3 FIELD #1 record
#4 FIELD #1 record
#5 FIELD #1 record
#6 BIND #1 "QUANTITY"
#7 BIND #2 "amount"
#8 BIND #3 "unit"
#9 BIND #4 "lower"
#10 BIND #5 "upper"
#11 CODEC #2 0x0680
#12 CODEC #3 0x000F
#33 CODEC #3 0x020F
#34 CODEC #3 0x040F
#13 CODEC #3 0x0000
#14 CODEC #4 0x0680
#15 CODEC #4 0x0000
#16 CODEC #5 0x0680
#17 CODEC #5 0x0000
#18 CODEC #2 0x0610
#19 CODEC #2 0x0620
#20 CODEC #2 0x0630
#21 CODEC #2 0x0670
#22 CODEC #2 0x0690
#23 CODEC #4 0x0610
#24 CODEC #4 0x0620
#25 CODEC #4 0x0630
#26 CODEC #4 0x0670
#27 CODEC #4 0x0690
#28 CODEC #5 0x0610
#29 CODEC #5 0x0620
#30 CODEC #5 0x0630
#31 CODEC #5 0x0670
#32 CODEC #5 0x0690
```
