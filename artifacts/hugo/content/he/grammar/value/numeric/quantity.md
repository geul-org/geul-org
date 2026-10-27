---
title: "QUANTITY"
weight: 7
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-28T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "QUANTITY הוא Value שמכיל כמות אחת בארבע רשומות: כמות כרשומת Value מספרית (שלם, BINARY-FLOAT, עשרוני, שבר), Reference של יחידה, גבול תחתון וגבול עליון."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUANTITY הוא Value שמבטא כמות אחת באמצעות מספר, יחידה וגבול תחתון ועליון. הוא Value עם קוד ישיר `0x06`, משפחה NUMERIC. כל אחד מארבעת החלקים הוא רשומה שלמה. היחידה והגבולות הם [שדות רשות](/he/grammar/codec-spec/), ואם משמיטים אותם, כותבים ABSENT (`0x0000`).

## פריסה

```
TAG WORD          0000 1LLL L000 0110      Codec 0x06
[Length extension TAG] כשהכול 15 WORD ומעלה
amount            רשומת Value מספרית (שלם, BINARY-FLOAT, עשרוני, שבר)
unit              רשומת Reference (פריט יחידה), 0x0000 אם אין יחידה
lower             רשומת Value מספרית, 0x0000 ABSENT אם הושמט
upper             רשומת Value מספרית, 0x0000 ABSENT אם הושמט
```

## פירוש ותקינות

- ה-amount הוא רשומת Value מספרית שלמה אחת בדיוק. ה-Codec המתקבלים הם שישה: [SIGNED-INTEGER](/he/grammar/value/numeric/signed-integer/) (`0x01`), [UNSIGNED-INTEGER](/he/grammar/value/numeric/unsigned-integer/) (`0x02`), [BINARY-FLOAT](/he/grammar/value/numeric/binary-float/) (`0x03`), [FRACTION](/he/grammar/value/numeric/fraction/) (`0x07`), [SIGNED-DECIMAL](/he/grammar/value/decimal/signed-decimal/) (`0x10`) ו-[UNSIGNED-DECIMAL](/he/grammar/value/decimal/unsigned-decimal/) (`0x11`). זו רשימה סגורה, לא תו כללי (wildcard). BOOL, COORDINATE-EARTH ו-COORDINATE-GEO, QUANTITY עצמו (אסור קינון, עומק קבוע) ו-Value אחרים אינם מתקבלים. ב-amount אי אפשר לכתוב סמן מקום (`0x0000` וכד').
- גם הרשומות הפנימיות עוקבות אחר הצורה הקנונית של כל Codec (מינימום WORD לשלמים ול-coefficient, 1/2/4/8 WORD ל-BINARY-FLOAT, FRACTION לפי הכללים שלו). אם רשומה פנימית אינה קנונית, ה-QUANTITY כולו invalid.
- אם amount, lower או upper הם BINARY-FLOAT, הערך חייב להיות סופי. NaN ו-±Infinity הם invalid (אותו כלל כמו לקו הרוחב ולקו האורך של [COORDINATE-EARTH](/he/grammar/value/numeric/coordinate-earth/)).
- תבנית המספר עוקבת אחר הכתיב המקורי כמות שהוא. מקור שלם נשמר כ-INTEGER, מקור עם ספרות אחרי הנקודה כ-DECIMAL, מקור שהוא שבר כ-FRACTION, וערך בינארי של IEEE 754 כ-BINARY-FLOAT; המקודד אינו מנרמל על ידי החלפת התבנית. C ו-E של DECIMAL שומרים את מספר הספרות של הכתיב המקורי: `1.20` = `120×10^-2`, `1.2` = `12×10^-1`. שני הערכים הם אותו מספר אך ספרות משמעותיות שונות, ולכן הם Value שונים. אין גבול עליון למספר הספרות של שלם ושל ה-coefficient (מינימום WORD, אורך משתנה).
- ה-unit הוא רשומת Reference שלמה אחת בדיוק או `0x0000`. אפשר להשתמש בכל Reference שמצביע על פריט יחידה (יחידה של Wikidata היא WIKIDATA-QID). `0x0000` פירושו בלי יחידה (ספירה, יחס, אוכלוסייה וכד').
- lower ו-upper הם כל אחד רשומה מאחד משישת ה-Codec של amount או `0x0000` ABSENT. סמן המקום היחיד המתקבל הוא השמטה ב-ABSENT. מספיק שאחד מהם קיים. שלושת המספרים אינם חייבים להיות באותו Codec. גם טווח סימטרי (`652 ± 1`) נכתב כגבול תחתון ועליון (`651`, `653`). מכיוון שיש טווחים א-סימטריים ובכל מקרה דרושים שני ערכים, אין פורמט שמקצר ל-± אחד.
- lower ≤ amount ≤ upper מושווים לפי ערך מספרי, לא לפי בתים או Codec. גם אם הטיפוסים שונים, משווים כמספרים (למשל SIGNED-INTEGER `652` ו-SIGNED-DECIMAL `651.5`). FRACTION מושווה כמספר רציונלי מדויק.
- היחידה היא חלק מהערך. לא מפרידים אותה ל-QUALIFIER וכד' (בלעדיה אי אפשר לדעת אם `652` הוא ק"מ או מטר).
- רשומת amount שמוציאים היא כמות שהיא רשומת Value עצמאית. כשצריך את המספר בלי היחידה, משתמשים ברשומה הזאת בלי לקודד מחדש.
- לא שומרים ערך שהומר ליחידות SI. זהו ערך נגזר שאפשר לחשב מהיחידה ומטבלת ההמרה.
- הסמן אחרי קריאת ארבע הרשומות חייב להתלכד בדיוק עם סוף ה-Payload. כל צורה אחרת היא invalid.
- מסמך המפרט של geul.org כותב אותו כארבעה שדות רשומה: amount (`0801`·`0802`·`0803`·`0807`·`0810`·`0811`), unit (`0780`·`0000`), lower ו-upper (`0801`·`0802`·`0803`·`0807`·`0810`·`0811`·`0000`) ([מסמך מפרט Codec](/he/grammar/codec-spec/)).

## אורך

- הסך הכול הוא TAG של WORD אחד + (TAG הרחבת Length) + ארבע הרשומות. רשומת שלם היא TAG 1 + Payload של WORD אחד או יותר, רשומת BINARY-FLOAT היא 2, 3, 5 או 9 WORD, ורשומת עשרוני היא TAG 1 + מעריך 2 + coefficient של WORD אחד או יותר. רשומת FRACTION היא 5 WORD או יותר.
- שלם קטן בלי יחידה ובלי גבולות הוא 6 WORD, ועשרוני קטן הוא 8 WORD. מ-15 WORD ומעלה משתמשים באורך מורחב ([רשומות ו-TAG WORD](/he/grammar/record/)).

## דוגמה

`1.20` בלי יחידה:

```
0B86 0990 FFFF FFFE 0078 0000 0000 0000
```

- TAG `0B86` (Codec `0x06`, 8 WORD), amount `0990 FFFF FFFE 0078` (E = -2, C = 120), unit·lower·upper `0000`.

שלם `42` בלי יחידה:

```
0A86 0881 002A 0000 0000 0000
```

- TAG `0A86` (6 WORD), amount `0881 002A` (SIGNED-INTEGER 42), unit·lower·upper `0000`.

שבר `2/3` בלי יחידה (שני שלישים מזכויות ההצבעה הנוכחות):

```
0C06 0A07 0881 0002 0882 0003 0000 0000 0000
```

- TAG `0C06` (9 WORD), amount `0A07 0881 0002 0882 0003` ([FRACTION](/he/grammar/value/numeric/fraction/) 2/3), unit·lower·upper `0000`.

`652 km`, טווח `[651, 653]` (km = Q828224):

```
0F06 0011
0990 0000 0000 028C
0120 000C A340
0990 0000 0000 028B
0990 0000 0000 028D
```

- סך הכול 17 WORD, ולכן `LLLL=1110`, TAG הרחבה `0011`.

## התאמה ל-Wikidata

- datavalue מסוג `quantity` ‏`{"amount","unit","lowerBound","upperBound"}` ← amount·unit·lower·upper. מחרוזות amount והגבולות (`+1.20`, כולל כתיב מעריכי) מועברות ל-C ול-E לפי מספר הספרות כמות שהוא.
- ה-amount והגבולות ב-Wikidata הם מחרוזות עשרוניות, ולכן גם בצורת שלם (`+652`) הם מועברים כ-SIGNED-DECIMAL. ההמרה מ-Wikidata אינה משתמשת ב-Codec מספריים אחרים.
- unit `"1"` הוא בלי יחידה (`0x0000`), ו-`http://www.wikidata.org/entity/Qn` הוא WIKIDATA-QID. יחידה אחרת, או מספר וגבול שהפורמט שלהם לא תקין, אינם מומרים והטקסט המקורי נשמר ב-UTF8-TEXT.
- מדגם Wikidata (כ-42 אלף quantity בתחילת ה-dump): בלי יחידה 61%, עם גבולות 13% (מהם 93% סימטריים), ה-amount הארוך ביותר 31 תווים.

## בסיס בתקנים

- כתיב עשרוני ושמירת מספר הספרות: המושגים coefficient, exponent ו-quantum של decimal ב-[IEEE 754-2008](https://standards.ieee.org/ieee/754/6210/) (SIGNED-DECIMAL של GEUL).
- מודל הכמות של Wikidata: ‏`QuantityValue` ב-Wikibase DataModel.

## דפים קשורים

- [Value](/he/grammar/value/), [SIGNED-DECIMAL](/he/grammar/value/decimal/signed-decimal/), [COORDINATE-GEO](/he/grammar/value/numeric/coordinate-geo/), [CODEC](/he/grammar/edge/codec/), [WIKIDATA-QID](/he/grammar/reference/wikidata-qid/)
