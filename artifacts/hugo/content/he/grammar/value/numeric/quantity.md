---
title: "QUANTITY"
weight: 7
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "QUANTITY הוא Value שמכיל כמות אחת בארבע רשומות: כמות עשרונית מדויקת, Reference של יחידה, גבול תחתון וגבול עליון."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUANTITY הוא Value שמבטא כמות אחת באמצעות מספר עשרוני מדויק, יחידה וגבול תחתון ועליון. הוא Value עם קוד ישיר `0x06`, משפחה NUMERIC. כל אחד מארבעת החלקים הוא רשומה שלמה. היחידה והגבולות הם [שדות רשות](/he/grammar/codec-spec/), ואם משמיטים אותם, כותבים ABSENT (`0x0000`).

## פריסה

```
TAG WORD          0000 1LLL L000 0110      Codec 0x06
[Length extension TAG] כשהכול 15 WORD ומעלה
amount            רשומת Value מסוג SIGNED-DECIMAL
unit              רשומת Reference (פריט יחידה), 0x0000 אם אין יחידה
lower             רשומת Value מסוג SIGNED-DECIMAL, 0x0000 ABSENT אם הושמט
upper             רשומת Value מסוג SIGNED-DECIMAL, 0x0000 ABSENT אם הושמט
```

## פירוש ותקינות

- ה-amount הוא [SIGNED-DECIMAL](/he/grammar/value/decimal/signed-decimal/) `C×10^E`. C ו-E שומרים את מספר הספרות של הכתיב המקורי: `1.20` = `120×10^-2`, `1.2` = `12×10^-1`. שני הערכים הם אותו מספר אך ספרות משמעותיות שונות, ולכן הם Value שונים. אין גבול עליון למספר הספרות של ה-coefficient (משלים ל-2 במינימום WORD, אורך משתנה).
- ה-unit הוא רשומת Reference שלמה אחת בדיוק או `0x0000`. אפשר להשתמש בכל Reference שמצביע על פריט יחידה (יחידה של Wikidata היא WIKIDATA-QID). `0x0000` פירושו בלי יחידה (ספירה, יחס, אוכלוסייה וכד').
- lower ו-upper הם כל אחד רשומת SIGNED-DECIMAL או `0x0000`. מספיק שאחד מהם קיים. גם טווח סימטרי (`652 ± 1`) נכתב כגבול תחתון ועליון (`651`, `653`). מכיוון שיש טווחים א-סימטריים ובכל מקרה דרושים שני ערכים, אין פורמט שמקצר ל-± אחד.
- היחידה היא חלק מהערך. לא מפרידים אותה ל-QUALIFIER וכד' (בלעדיה אי אפשר לדעת אם `652` הוא ק"מ או מטר).
- לא שומרים ערך שהומר ליחידות SI. זהו ערך נגזר שאפשר לחשב מהיחידה ומטבלת ההמרה.
- הסמן אחרי קריאת ארבע הרשומות חייב להתלכד בדיוק עם סוף ה-Payload. כל צורה אחרת היא invalid.
- מסמך המפרט של geul.org כותב אותו כארבעה שדות רשומה: amount (`0810`), unit (`0780`·`0000`), lower ו-upper (`0810`·`0000`) ([מסמך מפרט Codec](/he/grammar/codec-spec/)).

## אורך

- הסך הכול הוא TAG של WORD אחד + (TAG הרחבת Length) + ארבע הרשומות. רשומת עשרוני היא TAG 1 + מעריך 2 + coefficient של WORD אחד או יותר.
- מספר קטן בלי יחידה ובלי גבולות הוא 8 WORD. מ-15 WORD ומעלה משתמשים באורך מורחב ([רשומות ו-TAG WORD](/he/grammar/record/)).

## דוגמה

`1.20` בלי יחידה:

```
0B86 0990 FFFF FFFE 0078 0000 0000 0000
```

- TAG `0B86` (Codec `0x06`, 8 WORD), amount `0990 FFFF FFFE 0078` (E = -2, C = 120), unit·lower·upper `0000`.

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
- unit `"1"` הוא בלי יחידה (`0x0000`), ו-`http://www.wikidata.org/entity/Qn` הוא WIKIDATA-QID. יחידה אחרת, או מספר וגבול שהפורמט שלהם לא תקין, אינם מומרים והטקסט המקורי נשמר ב-UTF8-TEXT.
- מדגם Wikidata (כ-42 אלף quantity בתחילת ה-dump): בלי יחידה 61%, עם גבולות 13% (מהם 93% סימטריים), ה-amount הארוך ביותר 31 תווים.

## בסיס בתקנים

- כתיב עשרוני ושמירת מספר הספרות: המושגים coefficient, exponent ו-quantum של decimal ב-[IEEE 754-2008](https://standards.ieee.org/ieee/754/6210/) (SIGNED-DECIMAL של GEUL).
- מודל הכמות של Wikidata: ‏`QuantityValue` ב-Wikibase DataModel.

## דפים קשורים

- [Value](/he/grammar/value/), [SIGNED-DECIMAL](/he/grammar/value/decimal/signed-decimal/), [COORDINATE-GEO](/he/grammar/value/numeric/coordinate-geo/), [CODEC](/he/grammar/edge/codec/), [WIKIDATA-QID](/he/grammar/reference/wikidata-qid/)
