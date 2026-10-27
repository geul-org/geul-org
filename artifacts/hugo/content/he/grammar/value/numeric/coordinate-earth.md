---
title: "COORDINATE-EARTH"
weight: 5
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "COORDINATE-EARTH הוא Value שמכיל נקודה אחת על כדור הארץ (WGS 84) כקו רוחב וקו אורך ב-binary64, אי-ודאות ב-binary32 ו-Reference של יחידת האי-ודאות."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COORDINATE-EARTH הוא Value של קואורדינטה שמבטא נקודה על כדור הארץ באמצעות קו רוחב, קו אורך ואי-ודאות. הוא Value עם קוד ישיר `0x04`, משפחה NUMERIC. המשמעות שלו זהה ל-`geo:קו-רוחב,קו-אורך;u=אי-ודאות` של [RFC 5870](https://www.rfc-editor.org/rfc/rfc5870) (geo URI) (מערכת הקואורדינטות WGS 84), והוא נשמר כמספרים ברוחב קבוע ולא כמחרוזת. את אי-הוודאות כותבים יחד עם היחידה. קואורדינטה של גרם שמים מחוץ לכדור הארץ נכתבת ב-[COORDINATE-GEO](/he/grammar/value/numeric/coordinate-geo/) (`0x05`).

## פריסה

```
TAG WORD          0000 1LLL L000 0100      Codec 0x04
Latitude          ערך גולמי של 4 WORD, IEEE 754 binary64 (מעלות)
Longitude         ערך גולמי של 4 WORD, IEEE 754 binary64 (מעלות)
Uncertainty       ערך גולמי של 2 WORD, IEEE 754 binary32 (ביחידת Unit)
Unit              רשומת Reference אחת, או סמן מקום 0x0000 ABSENT
```

## פירוש ותקינות

- ה-Payload הוא Latitude של 4 WORD, Longitude של 4 WORD, Uncertainty של 2 WORD ואחריהם רשומת Unit אחת בדיוק. הסמן שקרא את ה-Unit חייב להתלכד עם סוף הרשומה.
- מערכת הקואורדינטות היא WGS 84 (ברירת המחדל `crs=wgs84` של RFC 5870).
- Latitude ו-Longitude הם IEEE 754 binary64 שנוצר מחיבור ה-WORD של ה-Payload בסדר big-endian (אותו פריסת ביטים כמו binary64 ב-[BINARY-FLOAT](/he/grammar/value/numeric/binary-float/)). היחידה היא מעלה (°).
  - הערך חייב להיות סופי. NaN ו-±Infinity הם invalid.
  - Latitude הוא `-90 ≤ φ ≤ 90` (צפון חיובי), ו-Longitude הוא `-180 ≤ λ ≤ 180` (מזרח חיובי).
  - סדר הצירים הוא קו רוחב ואז קו אורך (כמו RFC 5870 ו-ISO 6709). אין זה סדר x (קו אורך) ו-y (קו רוחב) של WKB ו-GeoJSON.
- Uncertainty הוא IEEE 754 binary32 שנוצר מחיבור 2 WORD ב-big-endian (אותה פריסת ביטים כמו binary32 ב-BINARY-FLOAT). פירושו שהמיקום בפועל נמצא בתוך הרדיוס הזה, והערך נקרא ביחידת Unit.
  - הוא חייב להיות סופי ו-`+0` או גדול ממנו. ערך שלילי, `-0` (`8000 0000`), NaN ו-±Infinity הם invalid.
  - `0` (כשיש Unit): קואורדינטה מדויקת. אין הבדל באיזו יחידה כותבים.
- Unit הוא Reference שמצביע על יחידת ה-Uncertainty. אינו מקבל Value. ה-Quantifier הוא Identified (`000`).
  - מומלץ להשתמש בפריט יחידה של Wikidata [WIKIDATA-QID](/he/grammar/reference/wikidata-qid/): מעלה Q28390, דקת קשת Q209426, שנייה של קשת Q829073, מטר Q11573, מילימטר Q174789 וכד'. יחידה שאין לה QID מוצבעת באמצעות Reference אחר (LOCAL, GEUL וכד'). אם כמה Reference מצביעים על אותה יחידה, ה-QID הוא הצורה הקנונית.
  - אם ה-Unit הוא מטר (Q11573), ה-Uncertainty זהה ל-`u` של RFC 5870.
- **לא ידוע**: במקום של Unit כותבים [ABSENT](/he/grammar/reference/slot-marker/) (`0x0000`) ואת ה-Uncertainty משאירים `+0` (`0000 0000`). זה זהה למקרה ש-`u` הושמט ב-RFC 5870. אם ה-Unit הוא ABSENT ו-Uncertainty אינו `+0`, זה invalid (נועלים ייצוג אחד).
- גובה אינו נשמר. אם נדרש, יוגדר בפורמט נפרד. altitude של Wikidata לא היה בשימוש במדגם (0/23,066), ואם יש ערך, לא ממירים אלא שומרים את הטקסט המקורי ב-UTF8-TEXT.
- לקואורדינטה על כדור הארץ מומלץ להשתמש בפורמט הזה. גם קואורדינטה שבה כדור הארץ (Q2) נכתב ב-COORDINATE-GEO אינה invalid, והצד המשווה מתאים אותה לאותה קואורדינטה.
- מסמך המפרט של geul.org `0x0000/0x0000000000000804` קובע בשדות הגולמיים Latitude, Longitude ו-Uncertainty את [CODEC](/he/grammar/edge/codec/) BINARY-FLOAT (`0803`) (4 WORD = binary64, 2 WORD = binary32), ובשדה הרשומה Unit את CODEC `0780` (כל Reference) ו-`0000` (ABSENT).

## אורך

- הסך הכול הוא TAG של WORD אחד + 10 WORD + רשומת Unit.

| Unit | סך הכול | TAG |
|---|---|---|
| ABSENT (WORD אחד) | 12 WORD | `0D84` (`LLLL=1011`) |
| QID שנכנס ב-WORD אחד (2 WORD, למשל מעלה Q28390) | 13 WORD | `0E04` (`LLLL=1100`) |
| QID של 2 WORD (3 WORD, למשל דקת קשת Q209426) | 14 WORD | `0E84` (`LLLL=1101`) |
| רשומת Unit של 4 WORD ומעלה | 15 WORD ומעלה | אורך מורחב ([רשומות ו-TAG WORD](/he/grammar/record/)) |

- אין זוג Codec זוגי-אי-זוגי.

## התאמה ל-Wikidata

globecoordinate של Wikidata: `{"latitude":52.516666666667,"longitude":13.383333333333,"altitude":null,"precision":0.016666666666667,"globe":"http://www.wikidata.org/entity/Q2"}`

| Wikidata | COORDINATE-EARTH |
|---|---|
| globe `…/entity/Q2` | הפורמט הזה (כדור הארץ). גרם שמים אחר הוא COORDINATE-GEO |
| latitude, longitude | binary64 כמות שהוא (הערך ב-Wikidata הוא במקור binary64, ולכן אין אובדן) |
| precision (מעלות) | Uncertainty ו-Unit. ראו "דיוק" להלן |
| precision הוא null או חסר | Unit = ABSENT, Uncertainty = `+0` (לא ידוע) |
| altitude | נזרק (תמיד null) |

- ה-precision של Wikidata אינו שגיאת מדידה אלא **רזולוציית הרישום** (באיזו יחידה של מעלות, דקות או שניות נרשמה הקואורדינטה). ה-Uncertainty של GEUL מעביר את הערך הזה בלי לשנות אותו. אין זה רדיוס שמוסיף שגיאת מדידה ושגיאת מערכת קואורדינטות.

### דיוק

מעבירים את ה-precision בלי המרה. בוחרים את היחידה הראשונה מבין מעלה, דקת קשת ושנייה של קשת ששחזור הכתיב המקורי מחזיר באמצעותה.

| טקסט מקורי של precision (דוגמה) | Unit | Uncertainty |
|---|---|---|
| `0.0001`, `0.0000010`, `1`, `10` (10^k מעלות) | מעלה Q28390 | binary32 של הערך הזה |
| כתיב עשרוני קצר כמו `0.0166667` | מעלה Q28390 | binary32 של הערך הזה |
| `0.016666666666667` (1/60°) | דקת קשת Q209426 | `1` |
| `0.00027777777777778` (1/3600°) | שנייה של קשת Q829073 | `1` |
| `0.000027777777777778` (1/36000° = 0.1″) | שנייה של קשת Q829073 | `0.1` |

- המרה קדימה: לפי הסדר מעלה, דקת קשת (×60), שנייה של קשת (×3600), לוקחים כ-Uncertainty את ה-binary32 הקרוב ביותר לערך ה-precision כפול מספר היחידות, ומשתמשים ביחידה הראשונה שההמרה ההפוכה שלהלן מחזירה בה את הטקסט המקורי של ה-precision כמות שהוא.
- המרה הפוכה: מחלקים את הכתיב העשרוני הקצר ביותר של ה-Uncertainty (המספר הקצר ביותר שנקרא שוב כאותו binary32) במספר היחידות כדי להחזיר למעלות, וכותבים בשיטה ש-Wikibase כותב ב-dump (14 ספרות משמעותיות, ומתחת ל-`1e-4` כתיב מעריכי `1.0e-6`·`2.7777777777778e-5`). מסד הנתונים שנטען (jsonb) שומר אותו בכתיב עשרוני `0.0000010`·`0.000027777777777778`.
- אם אף יחידה אינה מחזירה את הטקסט המקורי (כתיב של 17 ספרות משמעותיות `0.0002777777777777778`, ערך חריג שנראה כמו ערך מחושב וכד'), לא ממירים את הקואורדינטה כולה אלא שומרים את הטקסט המקורי ב-UTF8-TEXT. כך גם precision שלילי וערך שגרם השמים בו ריק.
- מדגם Q1–Q10000 של Wikidata (7,026 טענות קואורדינטה, 6,824 עם precision): 5,933 (86.9%) שוחזרו לטקסט המקורי (מעלה 4,104, שנייה של קשת 1,370, דקת קשת 459). מבין 891 שלא שוחזרו, 753 הם משפחת 1/3600 ו-1/60 בכתיב של 17 ספרות משמעותיות.

## דוגמה

ברלין 52.516666666667, 13.383333333333, precision של 1/60° (דקת קשת 1):

```
0E84 404A 4222 2222 2251 402A C444 4444 4389 3F80 0000 0120 0003 3212
```

- TAG `0E84` (14 WORD), Latitude `404A 4222 2222 2251`, Longitude `402A C444 4444 4389`, Uncertainty `3F80 0000` (binary32 1.0), Unit `0120 0003 3212` (WIKIDATA-QID Q209426, דקת קשת).
- סימון טקסטואלי: `COORDINATE-EARTH(52.516666666667, 13.383333333333, 1, Q209426)`.

אותה נקודה כשאי-הוודאות לא ידועה: `0D84 404A 4222 2222 2251 402A C444 4444 4389 0000 0000 0000` (12 WORD, Unit ABSENT).

## בסיס בתקנים

- משמעות: [RFC 5870, A Uniform Resource Identifier for Geographic Locations ('geo' URI)](https://www.rfc-editor.org/rfc/rfc5870) — סדר קו רוחב וקו אורך, אי-ודאות `u` (במטרים), מערכת הקואורדינטות ברירת המחדל WGS 84. אם ה-Unit הוא מטר, Uncertainty = `u`.
- מספרים: [IEEE 754](https://standards.ieee.org/ieee/754/6210/) binary64 (קו רוחב וקו אורך), binary32 (אי-ודאות).
- סדר צירים וטווח: ISO 6709 (Standard representation of geographic point location by coordinates).
- יחידה: פריט יחידה של Wikidata (QID). הפריסה ברוחב קבוע, שדה ה-Unit והייצוג של "לא ידוע" הם כללי GEUL.

## שאלות פתוחות

1. גובה.
2. פורמט ששומר את מחרוזת ISO 6709 המקורית (COORDINATE-ISO6709) ייקבע כשיהיה לו שימוש.
3. איך להעביר ללא אובדן את הכתיב של 17 ספרות משמעותיות של ה-precision ב-Wikidata (כ-11% מהמדגם).

## דפים קשורים

- [Value](/he/grammar/value/), [COORDINATE-GEO](/he/grammar/value/numeric/coordinate-geo/), [BINARY-FLOAT](/he/grammar/value/numeric/binary-float/), [סמן מקום](/he/grammar/reference/slot-marker/)
- פורמט ה-Issuer [POINT2-BINARY64](/he/grammar/value/vector/point2-binary64/) הוא נקודה דו-ממדית כללית שמשאירה את מערכת הקואורדינטות, היחידה ומשמעות הצירים להקשר חיצוני, והפורמט הזה הוא קואורדינטה גיאוגרפית על כדור הארץ.
