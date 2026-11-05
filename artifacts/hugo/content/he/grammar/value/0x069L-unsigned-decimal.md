---
title: "UNSIGNED-DECIMAL (0x069L)"
weight: 105
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "UNSIGNED-DECIMAL הוא Value של מספר עשרוני מדויק (exact decimal) בעל coefficient ללא סימן."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `UNSIGNED-DECIMAL` (מסמך מפרט BIND `UNSIGNED-DECIMAL`) |
| TAG ID | `0x069L` |
| Codec ID | `0x00000690` |
| מסמך מפרט | `0x00000000/codecs/0x00000690/` (יעד DECLARE `0690`) |
| קטע | 3 `0011` (Value), היסט בתוך הקטע C = 9 |
| Kind | Value · משפחה: DECIMAL |
| TAG WORD | `0000 0110 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | `C×10^E` של signed exponent בשם `E` ו-unsigned coefficient בשם `C` במספר WORD מינימלי |
| בצד Hugo | `value/decimal/unsigned-decimal.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD במסמך הוא סדר שדות ה-Payload ([מסמך המפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `exponent` | #2 | ערך גולמי, 2 WORD |  |  |
| 2 | `coefficient` | #3 | ערך גולמי, השאר (`0xFFFF`) |  |  |

UNSIGNED-DECIMAL הוא Value של מספר עשרוני מדויק (exact decimal) בעל coefficient ללא סימן. קוד ישיר של Value הוא `0x069L`, משפחה DECIMAL. שני ה-WORD הראשונים של ה-Payload הם signed 32bit decimal exponent בשם `E`, והשאר הוא unsigned coefficient בשם `C` במספר WORD מינימלי, והערך הוא `C×10^E`.

## פריסה {#레이아웃}

```
TAG WORD          0000 0110 1001 LLLL      Codec 0x069L
[TAG הרחבת Length] כאשר הסך הכול 15 WORD ומעלה
Payload WORD 1st–2nd (32 סיביות)    Signed Base-10 Exponent E
Payload WORD 3rd–Nth (WORD אחד ומעלה)  Unsigned Coefficient C
```

## פירוש {#해석}

- `E` הוא מספר שלם signed 32bit big-endian בשיטת המשלים ל-2, הנרשם מה-WORD העליון.
- `C` הוא unsigned magnitude בדיוק שרירותי, הנקרא מכל שאר ה-WORD החל מה-WORD העליון.
- `C` כפוף לאותו כלל WORD מינימלי כמו [UNSIGNED-INTEGER](0x062L-unsigned-integer.md). 0 הוא `0000`, ובמקרה של 2 WORD ומעלה ה-WORD הראשון `0000` אסור.

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
| coefficient שלילי | לא רלוונטי | invalid |

## מעמד הפורמט {#형식-지위}

- פריסה זו, המצמידה exponent בשם `E` בן signed 32 סיביות ל-unsigned coefficient בשם `C` ב-WORD מינימלי, היא פורמט ייחודי ל-GEUL ואינה IEEE 754 decimal interchange או `DECIMAL` של Apache Parquet.
- `DECIMAL` של Parquet משתמש ב-signed unscaled value, ב-`unscaledValue × 10^(-scale)` ובמטא-נתונים חובה של precision/scale, הטיפוס הפיזי byte-array הוא בשיטת המשלים ל-2 big-endian, וה-scale הוא 0 ומעלה. פורמט זה אינו אותו פורמט בשל `C` ללא סימן, `E` עם סימן והיעדר מטא-נתוני precision.
- להמרה מול IEEE 754 decimal או `DECIMAL` של Parquet נדרשת המרה מפורשת הקובעת סימן, טווח, precision/scale, quantum ומדיניות ערכים מיוחדים.
- בסיס להשוואה: [IEEE 754-2019](https://standards.ieee.org/ieee/754/6210/), [Apache Parquet Logical Types — DECIMAL](https://parquet.apache.org/docs/file-format/types/logicaltypes/)

## בעיות פתוחות {#열린-문제}

- יש כמה זוגות exponent/coefficient המייצגים אותו מספר, כמו `10×10^-1` ו-`1×10^0`.
- עדיין לא נקבע אם פורמט זה שומר quantum, כיצד נקבע שוויון ערכים, וכיצד מנרמלים canonical exponent.
- לכן מימוש אינו רשאי לכפות באופן שרירותי נרמול של exponent/coefficient מעבר לכלל ה-WORD המינימלי של ה-coefficient.

## הטקסט המקורי של מסמך המפרט {#규격-문서-원문}

זהו מסמך המפרט `0x00000000/codecs/0x00000690/latest.geul` כפי שהוא נקרא באמצעות `geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000069000000000
BODY
#1 DECLARE 0x0690
#2 FIELD #1 0x0002
#3 FIELD #1 rest
#4 BIND #1 "UNSIGNED-DECIMAL"
#5 BIND #2 "exponent"
#6 BIND #3 "coefficient"
```
