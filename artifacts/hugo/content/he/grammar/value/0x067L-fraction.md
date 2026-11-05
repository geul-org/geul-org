---
title: "FRACTION (0x067L)"
weight: 103
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "FRACTION הוא Value המייצג שבר כפי שנכתב בטקסט המקורי, בדיוק לפי הרישום."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `FRACTION` (מסמך מפרט BIND `FRACTION`) |
| TAG ID | `0x067L` |
| Codec ID | `0x00000670` |
| מסמך מפרט | `0x00000000/codecs/0x00000670/` (יעד DECLARE `0670`) |
| קטע | 3 `0011` (Value), היסט בתוך הקטע C = 7 |
| Kind | Value · משפחה: NUMERIC |
| TAG WORD | `0000 0110 0111 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | שבר השומר את הרישום המקורי: מונה שלם או עשרוני, מכנה שלם או עשרוני ללא סימן. ללא צמצום |
| בצד Hugo | `value/numeric/fraction.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD במסמך הוא סדר שדות ה-Payload ([מסמך המפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `numerator` | #2 | רשומה | `0610` SIGNED-INTEGER, `0680` SIGNED-DECIMAL |  |
| 2 | `denominator` | #3 | רשומה | `0620` UNSIGNED-INTEGER, `0690` UNSIGNED-DECIMAL |  |

FRACTION הוא Value המייצג שבר כפי שנכתב בטקסט המקורי, בדיוק לפי הרישום. קוד ישיר של Value הוא `0x067L`, משפחה NUMERIC. המונה והמכנה הם רשומות Value שלמות. אין מצמצמים. הפורמט שומר שברים שהנוסח הכתוב הוא עצמו הרישום, כגון "שני שלישים" ו"5 חלקי 100" בחקיקה, או חלק עשרוני בבעלות ברישום המקרקעין `23.45/1256.1`.

## פריסה {#레이아웃}

```
TAG WORD          0000 0110 0111 LLLL      Codec 0x067L
[TAG הרחבת Length] כאשר הסך הכול 15 WORD ומעלה
numerator         רשומת Value אחת: SIGNED-INTEGER או SIGNED-DECIMAL
denominator       רשומת Value אחת: UNSIGNED-INTEGER או UNSIGNED-DECIMAL
```

## פירוש ותוקף {#해석과-유효성}

- numerator הוא רשומת [SIGNED-INTEGER](0x061L-signed-integer.md) (`0x061L`) או [SIGNED-DECIMAL](0x068L-signed-decimal.md) (`0x068L`) אחת בדיוק.
- denominator הוא רשומת [UNSIGNED-INTEGER](0x062L-unsigned-integer.md) (`0x062L`) או [UNSIGNED-DECIMAL](0x069L-unsigned-decimal.md) (`0x069L`) אחת בדיוק.
- זוהי רשימה סגורה. Value אחרים, FRACTION עצמו (אין קינון) וסמן מקום (`0x0000` וכד') אינם מתקבלים.
- לשתי הרשומות יש אורך משלהן, ולכן הגבול ביניהן אינו נרשם בנפרד. הסמן שקרא את שתי הרשומות חייב להתיישר בדיוק עם סוף ה-Payload.
- גם הרשומות הפנימיות כפופות לצורה הקנונית של כל Codec (מספר שלם ו-coefficient ב-WORD מינימלי). אם יש רשומה פנימית שאינה קנונית, FRACTION כולו invalid.
- הערך הוא `numerator / denominator`.

### שמירת הרישום {#표기-보존}

- **מספר שלם ועשרוני**: אם הרכיב במקור הוא מספר שלם (ללא נקודה עשרונית), משתמשים ברשומת INTEGER, ואם יש נקודה עשרונית, ברשומת DECIMAL. כתיבת רכיב כ-DECIMAL עם מעריך `E = 0` היא invalid. לכן לאותו רישום יש רצף בתים אחד.
- ה-C וה-E של רכיב DECIMAL הם מספר הספרות של המקור כמות שהוא. `23.450` הוא `23450×10^-3`, והוא Value שונה מ-`23.45`.
- **אין מצמצמים.** `2/4` ו"5 חלקי 100" (`5/100`) נכתבים כפי שהם. אם הבתים זהים, הרישום המקורי זהה.
- גם שבר שמכנהו 1 (`3/1`) נכתב כמות שהוא אם כך כתב המקור. אם המקור הוא מספר שלם, משתמשים ב-Codec של מספר שלם ולא ב-FRACTION. אם המקור הוא מספר עשרוני (`0.5`, `5%`), משתמשים ב-DECIMAL.
- הסימן ממוקם במונה בלבד. המכנה הוא Codec ללא סימן.
- אם ערך המכנה הוא 0, הרשומה invalid (גם `0` וגם `0.0`).

### השוואה {#비교}

- שכבת ההשוואה מחשבת את FRACTION כמספר רציונלי מדויק `(C1 × 10^E1) / (C2 × 10^E2)` (רכיב INTEGER הוא `E = 0`). אין קירוב בנקודה צפה.
- השוואה, מיון וזיהוי כפילויות נעשים לפי ערך זה, ואילו אחסון, חתימה ו-hash של תוכן נעשים לפי הרישום (הבתים). `2/4`, `1/2` ו-`0.5` הם בעלי אותו ערך ובתים שונים.
- קביעת קוורום ("שני שלישים או יותר מזכויות ההצבעה של בעלי המניות הנוכחים") נעשית בהשוואה לפי ערך מדויק זה.

## אורך {#길이}

- הסך הכול הוא TAG אחד + (TAG הרחבת Length) + שתי רשומות. רשומת מספר שלם היא TAG אחד + Payload של WORD אחד ומעלה, ורשומה עשרונית היא TAG אחד + מעריך 2 + coefficient של WORD אחד ומעלה.
- שבר שלם קטן הוא 5 WORD, ושבר עשרוני קטן הוא 9 WORD. מ-15 WORD ומעלה משתמשים באורך מורחב ([רשומה ו-TAG WORD](../record.md)).

| טקסט מקורי | רכיבים | סך הכול |
|---|---|---|
| `2/3` | INTEGER 2 WORD + INTEGER 2 WORD | 5 WORD |
| `5/100` | INTEGER 2 WORD + INTEGER 2 WORD | 5 WORD |
| `23.45/1256.1` | DECIMAL 4 WORD + DECIMAL 4 WORD | 9 WORD |

## דוגמה {#예시}

`2/3`:

```
0674 0611 0002 0621 0003
```

- TAG `0674` (Codec `0x067L`, 5 WORD), numerator `0611 0002` (SIGNED-INTEGER 2), denominator `0621 0003` (UNSIGNED-INTEGER 3).

`23.45/1256.1`:

```
0678 0683 FFFF FFFE 0929 0693 FFFF FFFF 3111
```

- TAG `0678` (9 WORD), numerator `0683 FFFF FFFE 0929` (SIGNED-DECIMAL E = -2, C = 2345), denominator `0693 FFFF FFFF 3111` (UNSIGNED-DECIMAL E = -1, C = 12561).

## קשר לפורמטים אחרים {#다른-형식과의-관계}

- amount, lower ו-upper של [QUANTITY](0x066L-quantity.md) מקבלים FRACTION. "שני שלישים מזכויות ההצבעה של הנוכחים" אפשר לכתוב כ-QUANTITY ללא יחידה שה-amount שלו `2/3`.
- מסמך המפרט של geul.org `0x00000000/codecs/0x00000670` רושם שני שדות רשומה: numerator (`0610`, `0680`) ו-denominator (`0620`, `0690`) ([מסמך המפרט של Codec](../codec-spec.md)).
- אם נדרש שבר int64 קבוע הכופה צמצום, משתמשים בפורמט Issuer [RATIONAL-I64](adhoc.geul.org/rational-i64.md).

## בעיות פתוחות {#열린-문제}

1. שמירת הרישום של שבר מעורב (`1 ו-2/3`).
2. פורמט המכיל שבר שלרכיביו יחידות (שטח/שטח) בשני QUANTITY. FRACTION אינו מכיל יחידה.
3. קריטריון הרישום לאחוזים ולפרומיל (`5%`, `5‰`): האם להציבם ב-DECIMAL ויחידה או ב-FRACTION (`5/100`).
4. שבר מורכב (FRACTION במונה ובמכנה). נכון לעכשיו אסור.

## דפים קשורים {#관련-페이지}

- [Value](_index.md), [QUANTITY](0x066L-quantity.md), [SIGNED-INTEGER](0x061L-signed-integer.md), [SIGNED-DECIMAL](0x068L-signed-decimal.md), [RATIONAL-I64](adhoc.geul.org/rational-i64.md)

## הטקסט המקורי של מסמך המפרט {#규격-문서-원문}

זהו מסמך המפרט `0x00000000/codecs/0x00000670/latest.geul` כפי שהוא נקרא באמצעות `geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000067000000000
BODY
#1 DECLARE 0x0670
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "FRACTION"
#5 BIND #2 "numerator"
#6 BIND #3 "denominator"
#7 CODEC #2 0x0610
#8 CODEC #2 0x0680
#9 CODEC #3 0x0620
#10 CODEC #3 0x0690
```
