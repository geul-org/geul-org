---
title: "FRACTION"
weight: 8
date: 2026-10-28T12:00:00+09:00
lastmod: 2026-10-28T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "FRACTION הוא Value של שבר שמכיל מונה (שלם או עשרוני) ומכנה (שלם או עשרוני בלי סימן) בדיוק כפי שנכתבו במקור, בלי צמצום."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

FRACTION הוא Value שמייצג שבר שנכתב בטקסט מקור תוך שמירה על הכתיב שלו. קוד ישיר של Value `0x07`, משפחה NUMERIC. המונה והמכנה הם כל אחד רשומת Value שלמה. השבר אינו מצומצם. הוא מכיל שברים שהכתיב שלהם הוא עצמו הרישום, כמו "שני שלישים" ו"חמישה ממאה" בחוקים, והחלק העשרוני `23.45/1256.1` בפנקס המקרקעין.

## פריסה

```
TAG WORD          0000 1LLL L000 0111      Codec 0x07
[TAG הרחבת Length] כשהסך הכול 15 WORD או יותר
numerator         רשומת Value אחת: SIGNED-INTEGER או SIGNED-DECIMAL
denominator       רשומת Value אחת: UNSIGNED-INTEGER או UNSIGNED-DECIMAL
```

## פירוש ותקינות

- ה-numerator הוא בדיוק רשומה אחת של [SIGNED-INTEGER](/he/grammar/value/numeric/signed-integer/) (`0x01`) או [SIGNED-DECIMAL](/he/grammar/value/decimal/signed-decimal/) (`0x10`).
- ה-denominator הוא בדיוק רשומה אחת של [UNSIGNED-INTEGER](/he/grammar/value/numeric/unsigned-integer/) (`0x02`) או [UNSIGNED-DECIMAL](/he/grammar/value/decimal/unsigned-decimal/) (`0x11`).
- זו רשימה סגורה. Value אחרים, FRACTION עצמו (אסור קינון) וסמני מקום (`0x0000` וכד') אינם מתקבלים.
- כל אחת משתי הרשומות נושאת את האורך שלה, ולכן לא כותבים גבול נפרד. הסמן אחרי קריאת שתי הרשומות חייב להתאים בדיוק לסוף ה-Payload.
- גם הרשומות הפנימיות עוקבות אחר הצורה הקנונית של כל Codec (מינימום WORD לשלמים ול-coefficient). אם רשומה פנימית אינה קנונית, ה-FRACTION כולו invalid.
- הערך הוא `numerator / denominator`.

### שמירת הכתיב

- **שלם ועשרוני**: אם רכיב במקור הוא שלם (בלי נקודה עשרונית), משתמשים ברשומת INTEGER; אם יש בו נקודה עשרונית, ברשומת DECIMAL. כתיבת רכיב כ-DECIMAL עם מעריך `E = 0` היא invalid. לכן לכתיב אחד יש רצף בתים אחד בלבד.
- C ו-E של רכיב DECIMAL שומרים את מספר הספרות של המקור כמות שהוא. `23.450` הוא `23450×10^-3`, Value שונה מ-`23.45`.
- **אין צמצום.** `2/4` ו"חמישה ממאה" (`5/100`) נכתבים כמות שהם. אם הבתים זהים, הכתיב המקורי זהה.
- גם שבר שמכנהו 1 (`3/1`) נכתב כמות שהוא אם המקור כתב אותו כך. אם המקור הוא מספר שלם, משתמשים ב-Codec של שלם ולא ב-FRACTION. אם המקור הוא עשרוני (`0.5`, `5%`), משתמשים ב-DECIMAL.
- הסימן נמצא במונה בלבד. המכנה הוא Codec בלי סימן.
- מכנה שערכו 0 הוא invalid (גם `0` וגם `0.0`).

### השוואה

- שכבת ההשוואה מחשבת FRACTION כמספר רציונלי מדויק `(C1 × 10^E1) / (C2 × 10^E2)` (עם `E = 0` לרכיב INTEGER). היא אינה מקרבת בנקודה צפה.
- השוואה, מיון וזיהוי כפילויות נעשים לפי הערך הזה; אחסון, חתימות וגיבוב תוכן נעשים לפי הכתיב (הבתים). ל-`2/4`, `1/2` ו-`0.5` אותו ערך ובתים שונים.
- בדיקת מניין ("לפחות שני שלישים מזכויות ההצבעה של בעלי המניות הנוכחים") משווה לערך המדויק הזה.

## אורך

- הסך הכול הוא TAG של WORD אחד + (TAG הרחבת Length) + שתי הרשומות. רשומת שלם היא TAG 1 + Payload של WORD אחד או יותר, ורשומת עשרוני היא TAG 1 + מעריך 2 + coefficient של WORD אחד או יותר.
- שבר שלמים קטן הוא 5 WORD, ושבר עשרוני קטן הוא 9 WORD. מ-15 WORD ומעלה משתמשים באורך מורחב ([רשומות ו-TAG WORD](/he/grammar/record/)).

| מקור | רכיבים | סך הכול |
|---|---|---|
| `2/3` | INTEGER 2 WORD + INTEGER 2 WORD | 5 WORD |
| `5/100` | INTEGER 2 WORD + INTEGER 2 WORD | 5 WORD |
| `23.45/1256.1` | DECIMAL 4 WORD + DECIMAL 4 WORD | 9 WORD |

## דוגמה

`2/3`:

```
0A07 0881 0002 0882 0003
```

- TAG `0A07` (Codec `0x07`, 5 WORD), numerator `0881 0002` (SIGNED-INTEGER 2), denominator `0882 0003` (UNSIGNED-INTEGER 3).

`23.45/1256.1`:

```
0C07 0990 FFFF FFFE 0929 0991 FFFF FFFF 3111
```

- TAG `0C07` (9 WORD), numerator `0990 FFFF FFFE 0929` (SIGNED-DECIMAL E = -2, C = 2345), denominator `0991 FFFF FFFF 3111` (UNSIGNED-DECIMAL E = -1, C = 12561).

## קשר לפורמטים אחרים

- ה-amount, ה-lower וה-upper של [QUANTITY](/he/grammar/value/numeric/quantity/) מקבלים FRACTION. את "שני שלישים מזכויות ההצבעה הנוכחות" אפשר לכתוב כ-QUANTITY בלי יחידה עם amount `2/3`.
- מסמך המפרט של geul.org `0x0000/0x0000000000000807` כותב אותו בשני שדות רשומה: numerator (`0801`, `0810`) ו-denominator (`0802`, `0811`) ([מסמך מפרט Codec](/he/grammar/codec-spec/)).
- כשנדרש שבר int64 קבוע עם צמצום מחייב, משתמשים בפורמט ה-Issuer [RATIONAL-I64](/he/grammar/value/etc/rational-i64/).

## שאלות פתוחות

1. שמירת הכתיב של מספרים מעורבים (`1 ו-2/3`).
2. פורמט שמכיל שבר שלרכיביו יש יחידות (שטח/שטח) כשתי QUANTITY. FRACTION אינו מכיל יחידה.
3. כלל הכתיב לאחוזים ולפרומילים (`5%`, `5‰`): DECIMAL עם יחידה או FRACTION (`5/100`).
4. שברים מורכבים (FRACTION במונה או במכנה). כרגע אסורים.

## דפים קשורים

- [Value](/he/grammar/value/), [QUANTITY](/he/grammar/value/numeric/quantity/), [SIGNED-INTEGER](/he/grammar/value/numeric/signed-integer/), [SIGNED-DECIMAL](/he/grammar/value/decimal/signed-decimal/), [RATIONAL-I64](/he/grammar/value/etc/rational-i64/)
