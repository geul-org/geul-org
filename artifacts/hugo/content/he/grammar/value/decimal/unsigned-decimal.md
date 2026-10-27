---
title: "UNSIGNED-DECIMAL"
weight: 18
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "UNSIGNED-DECIMAL הוא Value שמכיל מספר עשרוני מדויק C×10^E באמצעות מעריך E חתום של 32 ביט ומקדם C ללא סימן במינימום WORD."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UNSIGNED-DECIMAL הוא Value של מספר עשרוני מדויק (exact decimal) בעל coefficient ללא סימן. הוא Value עם קוד ישיר `0x11`, משפחה DECIMAL. שני ה-Payload WORD הראשונים הם exponent עשרוני `E` חתום של 32 ביט, והשאר הוא coefficient `C` unsigned במינימום WORD, והערך הוא `C×10^E`.

## פריסה

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x11
[TAG הרחבת Length] כשהכול 15 WORD ומעלה
Payload WORD 1st–2nd (32 ביט)       Signed Base-10 Exponent E
Payload WORD 3rd–Nth (1 WORD ומעלה)  Unsigned Coefficient C
```

## פרשנות

- `E` הוא מספר שלם חתום של 32 ביט בשיטת המשלים ל-2 ב-big-endian, הכתוב מה-WORD העליון.
- `C` הוא unsigned magnitude בדיוק שרירותי, הנקרא מכל שאר ה-WORD מה-WORD העליון.
- `C` כפוף לאותו כלל מינימום WORD כמו [UNSIGNED-INTEGER](/he/grammar/value/numeric/unsigned-integer/). 0 הוא `0000`, וב-2 WORD ומעלה ה-WORD הראשון `0000` אסור.

## אורך ותקינות

- האורך הכולל הוא מספר ה-WORD של TAG אחד, TAG הרחבת Length (אם יש) וה-Payload. עד 14 WORD משתמשים באורך ישיר, מ-15 WORD ומעלה באורך מורחב `1110`·`1111`, וגם TAG ההרחבה נכלל באורך הכולל ([רשומות ו-TAG WORD](/he/grammar/record/)).
- ה-Payload מורכב מ-2 WORD של exponent ומ-WORD אחד לפחות של coefficient, ולכן המינימום הוא 3 WORD.
- נורמליות הייצוג הבייטי נבדקת רק לפי הייצוג במינימום WORD של ה-coefficient.

## דוגמה

| ייצוג הערך | Payload (`E` + `C`) | פסק דין |
|---|---|---|
| `1×10^0` | `0000 0000 0001` | הייצוג הבייטי תקין |
| `10×10^-1` | `ffff ffff 000a` | הייצוג הבייטי תקין, ויחס ה-canonical לייצוג שלמעלה הוא שאלה פתוחה |
| `1×10^0` | `0000 0000 0000 0001` | לא תקין: ה-`0000` המוביל ב-coefficient מיותר |
| coefficient שלילי | לא רלוונטי | invalid |

## מעמד הפורמט

- הפריסה הזו, שמצמידה exponent `E` חתום של 32 ביט ל-coefficient `C` unsigned במינימום WORD, היא פורמט ייחודי של GEUL ואינה IEEE 754 decimal interchange או `DECIMAL` של Apache Parquet.
- `DECIMAL` של Parquet משתמש ב-unscaled value חתום, ב-`unscaledValue × 10^(-scale)` וב-metadata חובה של precision/scale, הטיפוס הפיזי byte-array הוא משלים ל-2 ב-big-endian, וה-scale שלו אינו שלילי. הפורמט הזה אינו אותו פורמט בגלל `C` ללא סימן, `E` חתום והיעדר precision metadata.
- כדי להחליף נתונים עם IEEE 754 decimal או עם `DECIMAL` של Parquet נדרשת המרה מפורשת שקובעת מדיניות לסימן, טווח, precision/scale, quantum וערכים מיוחדים.
- בסיס להשוואה: [IEEE 754-2019](https://standards.ieee.org/ieee/754/6210/), [Apache Parquet Logical Types — DECIMAL](https://parquet.apache.org/docs/file-format/types/logicaltypes/)

## שאלות פתוחות

- יש כמה זוגות exponent/coefficient שמייצגים את אותו מספר, כמו `10×10^-1` ו-`1×10^0`.
- עדיין לא נקבע אם הפורמט הזה שומר quantum, איך קובעים שוויון ערכים, ואיך מנרמלים ל-canonical exponent.
- לכן מימוש אינו רשאי לכפות באופן שרירותי נרמול של exponent/coefficient מעבר לכלל מינימום ה-WORD של ה-coefficient.
