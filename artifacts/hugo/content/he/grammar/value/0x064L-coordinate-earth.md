---
title: "COORDINATE-EARTH (0x064L)"
weight: 100
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "COORDINATE-EARTH הוא Value של קואורדינטה המייצג נקודה על כדור הארץ באמצעות קו רוחב, קו אורך ואי-ודאות."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `COORDINATE-EARTH` (מסמך מפרט BIND `COORDINATE-EARTH`) |
| TAG ID | `0x064L` |
| Codec ID | `0x00000640` |
| מסמך מפרט | `0x00000000/codecs/0x00000640/` (יעד DECLARE `0640`) |
| קטע | 3 `0011` (Value), היסט בתוך הקטע C = 4 |
| Kind | Value · משפחה: NUMERIC |
| TAG WORD | `0000 0110 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | קו רוחב וקו אורך על כדור הארץ (WGS 84) ב-binary64, אי-ודאות ב-binary32 ו-Reference של יחידתה (ABSENT = לא ידוע) |
| בצד Hugo | `value/numeric/coordinate-earth.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD במסמך הוא סדר שדות ה-Payload ([מסמך המפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `latitude` | #2 | ערך גולמי, 4 WORD | `0630` BINARY-FLOAT |  |
| 2 | `longitude` | #3 | ערך גולמי, 4 WORD | `0630` BINARY-FLOAT |  |
| 3 | `uncertainty` | #4 | ערך גולמי, 2 WORD | `0630` BINARY-FLOAT |  |
| 4 | `unit` | #12 | רשומה | `000F` כל קטע 0 (תו כללי, Reference), `020F` כל קטע 1 (תו כללי, Reference), `040F` כל קטע 2 (תו כללי, Reference), `0000` ABSENT (שדה אופציונלי) |  |

COORDINATE-EARTH הוא Value של קואורדינטה המייצג נקודה על כדור הארץ באמצעות קו רוחב, קו אורך ואי-ודאות. קוד ישיר של Value הוא `0x064L`, משפחה NUMERIC. משמעותו זהה ל-`geo:קו-רוחב,קו-אורך;u=אי-ודאות` של [RFC 5870](https://www.rfc-editor.org/rfc/rfc5870) (geo URI; מערכת קואורדינטות WGS 84), והיא נשמרת כערך מספרי ברוחב קבוע ולא כמחרוזת. אי-הוודאות נרשמת יחד עם יחידתה. קואורדינטות של גרמי שמים מחוץ לכדור הארץ נכתבות ב-[COORDINATE-GEO](0x065L-coordinate-geo.md) (`0x065L`).

## פריסה {#레이아웃}

```
TAG WORD          0000 0110 0100 LLLL      Codec 0x064L
Latitude          4 WORD ערך גולמי, IEEE 754 binary64 (מעלות)
Longitude         4 WORD ערך גולמי, IEEE 754 binary64 (מעלות)
Uncertainty       2 WORD ערך גולמי, IEEE 754 binary32 (ביחידת Unit)
Unit              רשומת Reference אחת, או סמן מקום 0x0000 ABSENT
```

## פירוש ותוקף {#해석과-유효성}

- ה-Payload הוא Latitude ב-4 WORD, Longitude ב-4 WORD, Uncertainty ב-2 WORD, ואחריהם רשומת Unit אחת בדיוק. הסמן שקרא את Unit חייב להתיישר עם סוף הרשומה.
- מערכת הקואורדינטות היא WGS 84 (ברירת המחדל `crs=wgs84` של RFC 5870).
- Latitude ו-Longitude הם IEEE 754 binary64 שנוצר מחיבור WORD של ה-Payload בסדר big-endian (אותה פריסת סיביות כמו binary64 ב-[BINARY-FLOAT](0x063L-binary-float.md)). היחידה היא מעלות (°).
  - הערך חייב להיות סופי. NaN ו-±Infinity הם invalid.
  - Latitude הוא `-90 ≤ φ ≤ 90` (צפון חיובי), ו-Longitude הוא `-180 ≤ λ ≤ 180` (מזרח חיובי).
  - סדר הצירים הוא קו רוחב ואחריו קו אורך (כמו ב-RFC 5870 וב-ISO 6709). זה אינו סדר x (קו אורך) ו-y (קו רוחב) של WKB ו-GeoJSON.
- Uncertainty הוא IEEE 754 binary32 שנוצר מחיבור 2 WORD בסדר big-endian (אותה פריסת סיביות כמו binary32 ב-BINARY-FLOAT). משמעותו שהמיקום האמיתי נמצא בתוך רדיוס זה, והערך נקרא ביחידת Unit.
  - הוא חייב להיות סופי ולפחות `+0`. ערך שלילי, `-0` (`8000 0000`), NaN ו-±Infinity הם invalid.
  - `0` (כאשר יש Unit): קואורדינטה מדויקת. אין הבדל באיזו יחידה נרשם.
- Unit הוא Reference המצביע על יחידת ה-Uncertainty. Value אינו מתקבל. ה-Quantifier הוא Identified.
  - מומלץ להשתמש בפריט יחידה של ויקינתונים, [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md): מעלה Q28390, דקת קשת Q209426, שנייה קשתית Q829073, מטר Q11573, מילימטר Q174789 וכד'. יחידה ללא QID מצוינת ב-Reference אחר (LOCAL, GEUL וכד'). אם כמה Reference מצביעים על אותה יחידה, ה-QID הוא הצורה הקנונית.
  - אם Unit הוא מטר (Q11573), Uncertainty זהה ל-`u` של RFC 5870.
- **לא ידוע**: בשדה Unit כותבים [ABSENT](../slot-marker.md) (`0x0000`), ו-Uncertainty נקבע ל-`+0` (`0000 0000`). זהו המקרה המקביל להשמטת `u` ב-RFC 5870. אם Unit הוא ABSENT ו-Uncertainty אינו `+0`, הרשומה invalid (הייצוג מקובע לאחד).
- גובה אינו נשמר. אם יידרש, יוגדר בפורמט נפרד. altitude בוויקינתונים לא נמצא בשימוש במדגם (0/23,066), ואם יש ערך כזה, הוא אינו מומר והטקסט המקורי נשמר ב-UTF8-TEXT.
- לקואורדינטות של כדור הארץ מומלץ להשתמש בפורמט זה. גם קואורדינטה שכדור הארץ (Q2) נרשם ב-COORDINATE-GEO אינה invalid, והצד המשווה מתאים אותה לאותה קואורדינטה.
- מסמך המפרט של geul.org `0x00000000/codecs/0x00000640` מציב בשדות הערך הגולמי Latitude, Longitude ו-Uncertainty את [CODEC](../edge/0x0BEL-codec.md) BINARY-FLOAT (`0630`) (4 WORD = binary64, 2 WORD = binary32), ובשדה רשומת Unit את CODEC `000F`, `020F`, `040F` (כל Reference) ו-`0000` (ABSENT).

## אורך {#길이}

- הסך הכול הוא TAG אחד + 10 WORD + רשומת Unit.

| Unit | סך הכול | TAG |
|---|---|---|
| ABSENT (1 WORD) | 12 WORD | `064B` (`LLLL=1011`) |
| כאשר ה-QID נכנס ל-WORD אחד (2 WORD, למשל מעלה Q28390) | 13 WORD | `064C` (`LLLL=1100`) |
| כאשר ה-QID הוא 2 WORD (3 WORD, למשל דקת קשת Q209426) | 14 WORD | `064D` (`LLLL=1101`) |
| רשומת Unit של 4 WORD ומעלה | 15 WORD ומעלה | אורך מורחב ([רשומה ו-TAG WORD](../record.md)) |

- אין זוג Codec זוגי-אי-זוגי.

## התאמה לוויקינתונים {#위키데이터-대응}

globecoordinate בוויקינתונים: `{"latitude":52.516666666667,"longitude":13.383333333333,"altitude":null,"precision":0.016666666666667,"globe":"http://www.wikidata.org/entity/Q2"}`

| ויקינתונים | COORDINATE-EARTH |
|---|---|
| globe `…/entity/Q2` | פורמט זה (כדור הארץ). גרמי שמים אחרים ב-COORDINATE-GEO |
| latitude, longitude | binary64 כמות שהם (ערכי ויקינתונים הם במקור binary64, ולכן אין אובדן) |
| precision (מעלות) | Uncertainty ו-Unit. ראו "דיוק" להלן |
| precision הוא null או חסר | Unit = ABSENT, Uncertainty = `+0` (לא ידוע) |
| altitude | נזרק (תמיד null) |

- precision בוויקינתונים אינו שגיאת מדידה אלא **רזולוציית הרישום** (באיזו יחידה של מעלות, דקות או שניות נרשמה הקואורדינטה). Uncertainty ב-GEUL מעביר ערך זה ללא שינוי. זה אינו רדיוס שנוספו לו שגיאות מדידה או שגיאות של מערכת הקואורדינטות.

### דיוק {#정밀도}

precision מועבר ללא המרה. נבחרת היחידה הראשונה, מבין מעלה, דקת קשת ושנייה קשתית, שמשחזרת את הרישום המקורי.

| טקסט מקורי של precision (דוגמאות) | Unit | Uncertainty |
|---|---|---|
| `0.0001`, `0.0000010`, `1`, `10` (10^k מעלות) | מעלה Q28390 | binary32 של ערך זה |
| רישום עשרוני קצר כגון `0.0166667` | מעלה Q28390 | binary32 של ערך זה |
| `0.016666666666667` (1/60°) | דקת קשת Q209426 | `1` |
| `0.00027777777777778` (1/3600°) | שנייה קשתית Q829073 | `1` |
| `0.000027777777777778` (1/36000° = 0.1″) | שנייה קשתית Q829073 | `0.1` |

- המרה קדימה: לפי הסדר מעלה, דקת קשת (×60), שנייה קשתית (×3600), ה-binary32 הקרוב ביותר לתוצאת הכפלת precision במספר היחידות נקבע כ-Uncertainty, ונעשה שימוש ביחידה הראשונה שההמרה ההפוכה שלהלן מחזירה בה את הטקסט המקורי של precision כמות שהוא.
- המרה הפוכה: הרישום העשרוני הקצר ביותר של Uncertainty (המספר הקצר ביותר שנקרא חזרה כאותו binary32) מחולק במספר היחידות וממיר למעלות, ונכתב באופן שבו Wikibase כותב בדמפ (14 ספרות significant, ומתחת ל-`1e-4` ברישום מעריכי `1.0e-6` ו-`2.7777777777778e-5`). מסד הנתונים הטעון (jsonb) שומר זאת ברישום עשרוני `0.0000010` ו-`0.000027777777777778`.
- אם אף יחידה אינה משחזרת את המקור (רישום של 17 ספרות significant `0.0002777777777777778`, ערכים חריגים הנראים כערכים מחושבים וכד'), הקואורדינטה כולה אינה מומרת והטקסט המקורי נשמר ב-UTF8-TEXT. כך גם precision שלילי וערך שבו גרם השמים ריק.
- מדגם Q1–Q10000 של ויקינתונים (7,026 טענות קואורדינטה, 6,824 עם precision): 5,933 שוחזרו למקור (86.9%; מעלה 4,104, שנייה קשתית 1,370, דקת קשת 459). מתוך 891 שלא שוחזרו, 753 הם משפחת 1/3600 ו-1/60 ברישום של 17 ספרות significant.

## דוגמה {#예시}

ברלין 52.516666666667, 13.383333333333, precision של 1/60° (דקת קשת 1):

```
064D 404A 4222 2222 2251 402A C444 4444 4389 3F80 0000 0142 0003 3212
```

- TAG `064D` (14 WORD), Latitude `404A 4222 2222 2251`, Longitude `402A C444 4444 4389`, Uncertainty `3F80 0000` (binary32 1.0), Unit `0142 0003 3212` (WIKIDATA-QID Q209426, דקת קשת).
- ייצוג טקסטואלי: `COORDINATE-EARTH(52.516666666667, 13.383333333333, 1, Q209426)`.

אותה נקודה כשאי-הוודאות אינה ידועה: `064B 404A 4222 2222 2251 402A C444 4444 4389 0000 0000 0000` (12 WORD, Unit ABSENT).

## בסיס תקני {#표준-근거}

- משמעות: [RFC 5870, A Uniform Resource Identifier for Geographic Locations ('geo' URI)](https://www.rfc-editor.org/rfc/rfc5870) — סדר קו רוחב וקו אורך, אי-ודאות `u` (במטרים), מערכת קואורדינטות ברירת מחדל WGS 84. אם Unit הוא מטר, Uncertainty = `u`.
- ערכים מספריים: [IEEE 754](https://standards.ieee.org/ieee/754/6210/) binary64 (קו רוחב וקו אורך), binary32 (אי-ודאות).
- סדר צירים וטווח: ISO 6709 (Standard representation of geographic point location by coordinates).
- יחידה: פריט יחידה בוויקינתונים (QID). הפריסה ברוחב קבוע, שדה Unit וייצוג של "לא ידוע" הם כללי GEUL.

## בעיות פתוחות {#열린-문제}

1. גובה.
2. פורמט השומר את מחרוזת ISO 6709 המקורית (COORDINATE-ISO6709) יוגדר כאשר יתעורר צורך בשימוש.
3. דרך להעביר ללא אובדן את רישום ה-precision של ויקינתונים בן 17 ספרות significant (כ-11% מהמדגם).

## דפים קשורים {#관련-페이지}

- [Value](_index.md), [COORDINATE-GEO](0x065L-coordinate-geo.md), [BINARY-FLOAT](0x063L-binary-float.md), [סמן מקום](../slot-marker.md)
- פורמט Issuer [POINT2-BINARY64](adhoc.geul.org/point2-binary64.md) הוא נקודה דו-ממדית כללית המשאירה את מערכת הקואורדינטות, היחידה ומשמעות הצירים להקשר חיצוני, ואילו פורמט זה הוא קואורדינטה גאוגרפית על כדור הארץ.

## הטקסט המקורי של מסמך המפרט {#규격-문서-원문}

זהו מסמך המפרט `0x00000000/codecs/0x00000640/latest.geul` כפי שהוא נקרא באמצעות `geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000064000000000
BODY
#1 DECLARE 0x0640
#2 FIELD #1 0x0004
#3 FIELD #1 0x0004
#4 FIELD #1 0x0002
#5 BIND #1 "COORDINATE-EARTH"
#6 BIND #2 "latitude"
#7 BIND #3 "longitude"
#8 BIND #4 "uncertainty"
#9 CODEC #2 0x0630
#10 CODEC #3 0x0630
#11 CODEC #4 0x0630
#12 FIELD #1 record
#13 BIND #12 "unit"
#14 CODEC #12 0x000F
#16 CODEC #12 0x020F
#17 CODEC #12 0x040F
#15 CODEC #12 0x0000
```
