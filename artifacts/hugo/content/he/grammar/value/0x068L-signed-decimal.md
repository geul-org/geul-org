---
title: "SIGNED-DECIMAL (0x068L)"
weight: 104
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "SIGNED-DECIMAL הוא Value של מספר עשרוני מדויק (exact decimal) בעל coefficient עם סימן."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `SIGNED-DECIMAL` (מסמך מפרט BIND `SIGNED-DECIMAL`) |
| TAG ID | `0x068L` |
| Codec ID | `0x00000680` |
| מסמך מפרט | `0x00000000/codecs/0x00000680/` (יעד DECLARE `0680`) |
| קטע | 3 `0011` (Value), היסט בתוך הקטע C = 8 |
| Kind | Value · משפחה: DECIMAL |
| TAG WORD | `0000 0110 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | `C×10^E` של signed exponent בשם `E` ו-coefficient בשם `C` בשיטת המשלים ל-2 במספר WORD מינימלי |
| בצד Hugo | `value/decimal/signed-decimal.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD במסמך הוא סדר שדות ה-Payload ([מסמך המפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `exponent` | #2 | ערך גולמי, 2 WORD |  |  |
| 2 | `coefficient` | #3 | ערך גולמי, השאר (`0xFFFF`) |  |  |

SIGNED-DECIMAL הוא Value של מספר עשרוני מדויק (exact decimal) בעל coefficient עם סימן. קוד ישיר של Value הוא `0x068L`, משפחה DECIMAL. שני ה-WORD הראשונים של ה-Payload הם signed 32bit decimal exponent בשם `E`, והשאר הוא coefficient בשם `C` בשיטת המשלים ל-2 במספר WORD מינימלי, והערך הוא `C×10^E`.

## פריסה {#레이아웃}

```
TAG WORD          0000 0110 1000 LLLL      Codec 0x068L
[TAG הרחבת Length] כאשר הסך הכול 15 WORD ומעלה
Payload WORD 1st–2nd (32 סיביות)    Signed Base-10 Exponent E
Payload WORD 3rd–Nth (WORD אחד ומעלה)  Signed Two's-complement Coefficient C
```

## פירוש {#해석}

- `E` הוא מספר שלם signed 32bit big-endian בשיטת המשלים ל-2, הנרשם מה-WORD העליון.
- `C` הוא מספר שלם בשיטת המשלים ל-2 בדיוק שרירותי, שנוצר מחיבור כל שאר ה-WORD מה-WORD העליון.
- `C` כפוף לאותו כלל WORD מינימלי כמו [SIGNED-INTEGER](0x061L-signed-integer.md). WORD מוביל `0000` או `FFFF` שאפשר למחוק אסור.

## אורך ותוקף {#길이와-유효성}

- הסך הכול הוא מספר ה-WORD של TAG אחד, TAG הרחבת Length (אם יש) ו-Payload. עד 14 WORD משתמשים באורך ישיר, ו-15 WORD ומעלה משתמשים באורך מורחב `1110`·`1111`, וגם TAG ההרחבה נספר בסך הכול ([רשומה ו-TAG WORD](../record.md)).
- ה-Payload הוא exponent של 2 WORD ו-coefficient של WORD אחד ומעלה, ולכן לפחות 3 WORD.
- הקנוניות של ייצוג הבתים נבדקת רק לפי ייצוג ה-WORD המינימלי של ה-coefficient.

## דוגמה {#예시}

| ייצוג הערך | Payload (`E` + `C`) | קביעה |
|---|---|---|
| `1×10^0` | `0000 0000 0001` | ייצוג הבתים קנוני |
| `10×10^-1` | `FFFF FFFF 000A` | ייצוג הבתים קנוני, היחס הקנוני (canonical) לייצוג שלעיל הוא בעיה פתוחה |
| `1×10^0` | `0000 0000 0000 0001` | לא קנוני: `0000` מוביל ב-coefficient מיותר |
| Payload של 7 WORD | אורך ישיר `LLLL=0111`, סך הכול 8 WORD | מבנה אורך קנוני |

## מעמד הפורמט {#형식-지위}

- פריסה זו, המצמידה exponent בשם `E` בן signed 32 סיביות ל-coefficient בשם `C` ב-WORD מינימלי, היא פורמט ייחודי ל-GEUL ואינה IEEE 754 decimal interchange או `DECIMAL` של Apache Parquet.
- `DECIMAL` של Parquet משתמש ב-`unscaledValue × 10^(-scale)` ובמטא-נתונים חובה של precision/scale, שומר את ה-unscaled value של הטיפוס הפיזי byte-array בשיטת המשלים ל-2 big-endian, וה-scale הוא 0 ומעלה. פורמט זה מציב `E` עם סימן בגוף הרשומה ואין בו מטא-נתוני precision, ולכן אינו אותו פורמט.
- להמרה מול IEEE 754 decimal או `DECIMAL` של Parquet נדרשת המרה מפורשת הקובעת טווח, precision/scale, quantum ומדיניות ערכים מיוחדים.
- בסיס להשוואה: [IEEE 754-2019](https://standards.ieee.org/ieee/754/6210/), [Apache Parquet Logical Types — DECIMAL](https://parquet.apache.org/docs/file-format/types/logicaltypes/)

## בעיות פתוחות {#열린-문제}

- יש כמה זוגות exponent/coefficient המייצגים אותו מספר, כמו `10×10^-1` ו-`1×10^0`.
- עדיין לא נקבע אם פורמט זה שומר quantum, כיצד נקבע שוויון ערכים, וכיצד מנרמלים canonical exponent.
- לכן מימוש אינו רשאי לכפות באופן שרירותי נרמול של exponent/coefficient מעבר לכלל ה-WORD המינימלי של ה-coefficient.

## הטקסט המקורי של מסמך המפרט {#규격-문서-원문}

זהו מסמך המפרט `0x00000000/codecs/0x00000680/latest.geul` כפי שהוא נקרא באמצעות `geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000068000000000
BODY
#1 DECLARE 0x0680
#2 FIELD #1 0x0002
#3 FIELD #1 rest
#4 BIND #1 "SIGNED-DECIMAL"
#5 BIND #2 "exponent"
#6 BIND #3 "coefficient"
```
